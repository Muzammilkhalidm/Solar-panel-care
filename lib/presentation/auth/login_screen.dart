import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/app_routes.dart';
import '../../core/theme/ui_helpers.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_snackbar.dart';
import '../../core/widgets/app_text_field.dart';
import '../../state/auth_provider.dart';
import 'widgets/auth_scaffold.dart';

/// Email + password login with demo account shortcut.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _fillDemo() {
    _email.text = AppConstants.demoEmail;
    _password.text = AppConstants.demoPassword;
  }

  Future<void> _submit() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    final auth = context.read<AuthProvider>();
    final bool ok = await auth.signIn(
      email: _email.text,
      password: _password.text,
    );
    if (!mounted) return;
    if (ok) {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.home, (route) => false);
    } else {
      AppSnackBar.error(auth.error ?? 'Login failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    final auth = context.watch<AuthProvider>();

    return AuthScaffold(
      title: 'Welcome back 👋',
      subtitle:
          'Sign in to monitor every solar plate of your system in real time.',
      children: [
        Form(
          key: _form,
          child: Column(
            children: [
              AppTextField(
                controller: _email,
                label: 'Email',
                hint: 'you@example.com',
                prefixIcon: Icons.alternate_email,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: _password,
                label: 'Password',
                hint: '••••••••',
                prefixIcon: Icons.lock_outline,
                obscure: _obscure,
                validator: Validators.password,
                suffix: IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                    size: 20,
                    color: p.textFaint,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.forgotPassword),
                  child: const Text('Forgot password?'),
                ),
              ),
              const SizedBox(height: 6),
              AppButton(
                label: 'Sign In',
                icon: Icons.login,
                loading: auth.loading,
                onPressed: _submit,
              ),
              const SizedBox(height: 14),
              // Demo credentials shortcut card
              InkWell(
                onTap: _fillDemo,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: p.warningSoft,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color(0xFFF5A524).withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.bolt,
                          color: Color(0xFFF5A524), size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Demo account (tap to fill)',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: p.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              AuthProvider.demoHint,
                              style: TextStyle(
                                fontSize: 11.5,
                                color: p.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.register),
                    child: const Text('Register'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
