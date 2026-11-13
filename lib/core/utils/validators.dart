/// Form validators used by auth and panel registration forms.
class Validators {
  Validators._();

  static String? email(String? value) {
    final String v = value?.trim() ?? '';
    if (v.isEmpty) return 'Email is required';
    final RegExp regex = RegExp(r'^[\w\.\-+]+@([\w\-]+\.)+[a-zA-Z]{2,}$');
    if (!regex.hasMatch(v)) return 'Enter a valid email address';
    return null;
  }

  static String? password(String? value) {
    final String v = value ?? '';
    if (v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? required(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required';
    }
    return null;
  }

  static String? phone(String? value) {
    final String v = value?.trim() ?? '';
    if (v.isEmpty) return 'Phone number is required';
    if (v.length < 10) return 'Enter a valid phone number';
    return null;
  }

  static String? positiveNumber(String? value, {String field = 'Value'}) {
    final String v = value?.trim() ?? '';
    if (v.isEmpty) return '$field is required';
    final double? parsed = double.tryParse(v);
    if (parsed == null || parsed <= 0) return 'Enter a valid positive number';
    return null;
  }
}
