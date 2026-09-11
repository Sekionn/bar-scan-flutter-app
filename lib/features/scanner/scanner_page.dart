import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../../data/models/auth_session.dart';
import '../../data/models/scan_record.dart';
import '../../data/repositories/scan_repository.dart';
import '../../ui/core/app_drawer.dart';
import 'widgets/pending_sync_button.dart';
import 'widgets/scan_confirmation_dialog.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key, required this.session, required this.segment});

  final AuthSession session;
  final String segment;

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  late final ScanRepository _scanRepository;
  late final MobileScannerController _scannerController;

  int _pendingCount = 0;
  bool _isHandlingScan = false;
  bool _isScanning = false;
  bool _isSyncing = false;
  double _syncProgress = 0;

  @override
  void initState() {
    super.initState();
    _scanRepository = context.read<ScanRepository>();
    _scannerController = MobileScannerController(
      facing: CameraFacing.back,
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
    unawaited(_refreshPendingCount());
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _refreshPendingCount() async {
    final count = await _scanRepository.pendingCount();
    if (mounted) {
      setState(() => _pendingCount = count);
    }
  }

  Future<void> _handleBarcode(BarcodeCapture capture) async {
    if (!_isScanning || _isHandlingScan || _isSyncing) {
      return;
    }

    final scannedBarcode = _firstBarcodeValue(capture);
    if (scannedBarcode == null) {
      return;
    }

    _isHandlingScan = true;
    if (mounted) {
      setState(() => _isScanning = false);
    }
    try {
      if (!mounted) {
        return;
      }

      final record = await showDialog<ScanRecord>(
        context: context,
        barrierDismissible: false,
        builder: (_) => ScanConfirmationDialog(
          userId: widget.session.userId,
          username: widget.session.username,
          segment: widget.segment,
          barcode: scannedBarcode,
        ),
      );

      if (record != null) {
        await _addPendingRecord(record);
      }
    } finally {
      _isHandlingScan = false;
    }
  }

  String? _firstBarcodeValue(BarcodeCapture capture) {
    for (final entry in capture.barcodes) {
      final value = entry.rawValue?.trim();
      if (value != null && value.isNotEmpty) {
        return value;
      }
    }
    return null;
  }

  Future<void> _addPendingRecord(ScanRecord record) async {
    await _scanRepository.addScan(record);
    if (mounted) {
      setState(() => _pendingCount += 1);
    }
    unawaited(_refreshPendingCount());
  }

  void _toggleScanning() {
    if (_isHandlingScan || _isSyncing) {
      return;
    }

    if (mounted) {
      setState(() => _isScanning = !_isScanning);
    }
  }

  Future<void> _syncPendingRecords() async {
    if (_isSyncing) {
      return;
    }

    final records = await _scanRepository.pendingScans();
    if (records.isEmpty) {
      _showSnack('No products waiting to sync.');
      return;
    }

    setState(() {
      _isSyncing = true;
      _isScanning = false;
      _syncProgress = 0;
    });

    try {
      final synced = await _scanRepository.syncPendingScans(
        onProgress: (synced, total) {
          if (mounted) {
            setState(() {
              _syncProgress = synced / total;
              _pendingCount = total - synced;
            });
          }
        },
      );
      _showSnack('Synced $synced product${synced == 1 ? '' : 's'}.');
    } catch (_) {
      _showSnack('Sync stopped. Check RabbitMQ connection and try again.');
    } finally {
      await _refreshPendingCount();
      if (mounted) {
        setState(() {
          _isSyncing = false;
          _syncProgress = 0;
        });
      }
    }
  }

  void _showSnack(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        session: widget.session,
        segment: widget.segment,
        pendingCount: _pendingCount,
        onRecordsChanged: _refreshPendingCount,
      ),
      appBar: AppBar(
        title: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => Navigator.of(context).pop(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(child: Text('Shelf ${widget.segment}')),
                const SizedBox(width: 6),
                const Icon(Icons.edit, size: 18),
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: PendingSyncButton(
              count: _pendingCount,
              isSyncing: _isSyncing,
              onPressed: _syncPendingRecords,
            ),
          ),
        ],
        bottom: _isSyncing
            ? PreferredSize(
                preferredSize: const Size.fromHeight(32),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Column(
                    children: [
                      LinearProgressIndicator(value: _syncProgress),
                      const SizedBox(height: 6),
                      Text(
                        'Synchronizing. Please keep the app open.',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
              )
            : null,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _scannerController,
            onDetect: _handleBarcode,
          ),
          IgnorePointer(
            child: Center(
              child: Container(
                width: 260,
                height: 160,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 3),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _isSyncing ? null : _toggleScanning,
                    icon: Icon(_isScanning ? Icons.stop : Icons.camera_alt),
                    label: Text(_isScanning ? 'Stop scanning' : 'Scan'),
                  ),
                ),
                const SizedBox(height: 10),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.68),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      _isScanning
                          ? 'Point the back camera at a barcode.'
                          : 'Tap Scan when you are ready.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
