part of 'auth_gate.dart';

class _AuthGateState extends State<AuthGate> {
  late final Future<AuthSession?> _restoreSessionFuture;

  @override
  void initState() {
    super.initState();
    _restoreSessionFuture = context.read<AuthRepository>().restoreSession();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return FutureBuilder<AuthSession?>(
      future: _restoreSessionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  const Positioned(
                    top: 8,
                    right: 8,
                    child: LanguageSwitcher(),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: Image.asset(
                            'assets/branding/app_icon.png',
                            width: 144,
                            height: 144,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(t.checkingLogin),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final session = snapshot.data;
        if (session == null) {
          return const LoginPage();
        }

        return SegmentPage(session: session);
      },
    );
  }
}
