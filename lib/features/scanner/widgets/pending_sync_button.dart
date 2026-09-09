import 'package:flutter/material.dart';

class PendingSyncButton extends StatelessWidget {
  const PendingSyncButton({
    super.key,
    required this.count,
    required this.isSyncing,
    required this.onPressed,
  });

  final int count;
  final bool isSyncing;
  final VoidCallback onPressed;

  Color get _badgeColor {
    if (count >= 70) {
      return Colors.red;
    }
    if (count >= 40) {
      return Colors.amber.shade700;
    }
    if (count >= 1) {
      return Colors.green;
    }
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Synchronize',
      onPressed: isSyncing ? null : onPressed,
      icon: Badge(
        label: Text('$count'),
        backgroundColor: _badgeColor,
        alignment: Alignment.bottomRight,
        offset: const Offset(-13, -7),
        child: const Icon(Icons.sync),
      ),
    );
  }
}
