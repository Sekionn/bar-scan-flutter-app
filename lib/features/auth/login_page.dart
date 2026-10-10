import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/services/auth_api_service.dart';
import '../../i18n/app_localizations.dart';
import '../../ui/core/language_switcher.dart';
import '../../utils/validators.dart';
import '../legal/legal_support_page.dart';
import '../segment/segment_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoggingIn = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _logIn() async {
    if (_isLoggingIn || !_formKey.currentState!.validate()) {
      return;
    }

    final t = AppLocalizations.read(context);
    setState(() => _isLoggingIn = true);
    try {
      final session = await context.read<AuthRepository>().login(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) {
        return;
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => SegmentPage(session: session)),
      );
    } on InvalidCredentialsException {
      _showSnack(t.invalidLogin);
    } on AuthRequestException catch (error) {
      _showSnack(t.loginHttpFailed(error.statusCode));
    } catch (_) {
      _showSnack(t.loginFailed);
    } finally {
      if (mounted) {
        setState(() => _isLoggingIn = false);
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
    final t = AppLocalizations.of(context);

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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: Image.asset(
                              'assets/branding/app_icon.png',
                              width: 184,
                              height: 184,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          t.loginIntro,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: t.username,
                            prefixIcon: const Icon(Icons.person_outline),
                          ),
                          enabled: !_isLoggingIn,
                          textInputAction: TextInputAction.next,
                          validator: (value) => requiredText(
                            value,
                            requiredMessage: t.required,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: t.password,
                            prefixIcon: const Icon(Icons.lock_outline),
                          ),
                          enabled: !_isLoggingIn,
                          obscureText: true,
                          onFieldSubmitted: (_) => _logIn(),
                          validator: (value) => requiredText(
                            value,
                            requiredMessage: t.required,
                          ),
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: _isLoggingIn ? null : _logIn,
                          icon: _isLoggingIn
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.login),
                          label: Text(_isLoggingIn ? t.loggingIn : t.logIn),
                        ),
                        const SizedBox(height: 16),
                        TextButton.icon(
                          onPressed: _isLoggingIn
                              ? null
                              : () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => const LegalSupportPage(),
                                    ),
                                  );
                                },
                          icon: const Icon(Icons.help_outline),
                          label: Text(t.privacyTermsSupport),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
