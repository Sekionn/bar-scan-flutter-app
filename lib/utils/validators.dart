String? requiredText(String? value, {String requiredMessage = 'Required'}) {
  if (value == null || value.trim().isEmpty) {
    return requiredMessage;
  }
  return null;
}

String? numberText(
  String? value, {
  String requiredMessage = 'Required',
  String numberMessage = 'Enter a number',
}) {
  final requiredError = requiredText(value, requiredMessage: requiredMessage);
  if (requiredError != null) {
    return requiredError;
  }
  if (num.tryParse(value!.trim()) == null) {
    return numberMessage;
  }
  return null;
}

String? nonNegativeIntegerText(
  String? value, {
  String requiredMessage = 'Required',
  String integerMessage = 'Enter a whole number',
  String zeroOrHigherMessage = 'Enter 0 or higher',
}) {
  final requiredError = requiredText(value, requiredMessage: requiredMessage);
  if (requiredError != null) {
    return requiredError;
  }

  final parsed = int.tryParse(value!.trim());
  if (parsed == null) {
    return integerMessage;
  }
  if (parsed < 0) {
    return zeroOrHigherMessage;
  }
  return null;
}
