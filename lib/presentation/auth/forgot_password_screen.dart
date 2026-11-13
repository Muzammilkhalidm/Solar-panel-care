import 'package:flutter/material.dart';

import '../../core/constants/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_dialog.dart';
import '../../core/widgets/app_text_field.dart';
import 'widgets/auth_scaffold.dart';

/// Demo password-reset screen (local only — shows instructions dialog).
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    await AppDialog.info(
      context,
      title: 'Reset link sent',
      message:
          'If an account exists for "${_email.text}", a password reset link '
          'has been sent.\n\n'
          'For the offline demo you can always sign in with the demo account:\n'
          'demo@solarcare.pk / solar123',
    );
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Reset password',
      subtitle:
          'Enter your account email and we will send you a reset link.',
      children: [
        AppTextField(
          controller: _email,
          label: 'Email',
          prefixIcon: Icons.alternate_email,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 18),
        AppButton(
          label: 'Send Reset Link',
          icon: Icons.outgoing_mail,
          onPressed: _submit,
        ),
      ],
    );
  }
}
