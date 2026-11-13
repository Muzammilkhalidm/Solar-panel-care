import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_routes.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_snackbar.dart';
import '../../core/widgets/app_text_field.dart';
import '../../state/auth_provider.dart';
import 'widgets/auth_scaffold.dart';

/// Local account creation.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  bool _obscure = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    if (_password.text != _confirm.text) {
      AppSnackBar.warning('Passwords do not match');
      return;
    }
    final auth = context.read<AuthProvider>();
    final bool ok = await auth.register(
      name: _name.text,
      email: _email.text,
      phone: _phone.text,
      password: _password.text,
    );
    if (!mounted) return;
    if (ok) {
      AppSnackBar.success('Account created — welcome to Solar Panel Care!');
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.home, (route) => false);
    } else {
      AppSnackBar.error(auth.error ?? 'Registration failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return AuthScaffold(
      title: 'Create account',
      subtitle:
          'Register once, then connect your IoT solar plates to this app.',
      children: [
        Form(
          key: _form,
          child: Column(
            children: [
              AppTextField(
                controller: _name,
                label: 'Full name',
                prefixIcon: Icons.person_outline,
                validator: (v) => Validators.required(v, field: 'Name'),
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: _email,
                label: 'Email',
                prefixIcon: Icons.alternate_email,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: _phone,
                label: 'Phone',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: Validators.phone,
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: _password,
                label: 'Password',
                prefixIcon: Icons.lock_outline,
                obscure: _obscure,
                validator: Validators.password,
                suffix: IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: _confirm,
                label: 'Confirm password',
                prefixIcon: Icons.lock_outline,
                obscure: _obscure,
                validator: Validators.password,
              ),
              const SizedBox(height: 20),
              AppButton(
                label: 'Create Account',
                icon: Icons.person_add_alt,
                loading: auth.loading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
