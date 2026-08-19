abstract final class Validators {
  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) return 'Username is required';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    return null;
  }
}