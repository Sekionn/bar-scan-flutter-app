String? requiredText(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Required';
  }
  return null;
}

String? numberText(String? value) {
  final requiredError = requiredText(value);
  if (requiredError != null) {
    return requiredError;
  }
  if (num.tryParse(value!.trim()) == null) {
    return 'Enter a number';
  }
  return null;
}

String? nonNegativeIntegerText(String? value) {
  final requiredError = requiredText(value);
  if (requiredError != null) {
    return requiredError;
  }

  final parsed = int.tryParse(value!.trim());
  if (parsed == null) {
    return 'Enter a whole number';
  }
  if (parsed < 0) {
    return 'Enter 0 or higher';
  }
  return null;
}
