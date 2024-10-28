// validation_utils.dart

bool isPositiveNumber(String? value) =>
    value != null && double.tryParse(value) != null && double.parse(value) > 0;

bool isPositiveInteger(String? value) =>
    value != null && int.tryParse(value) != null && int.parse(value) > 0;

bool isValidUrl(String? value) {
  const urlPattern = r'^(http|https):\/\/[a-zA-Z0-9\-.]+\.[a-zA-Z]{2,}';
  return value != null && RegExp(urlPattern).hasMatch(value);
}

String? validateProductId(String? value, List<String> existingIds) {
  if (value == null || value.isEmpty) return 'Please enter a unique Product ID';
  if (value.length > 10) return 'Product ID must be 10 characters or less';
  if (existingIds.contains(value)) return 'Product ID already exists';
  return null;
}

String? validatePositiveNumber(String? value) {
  if (value == null || value.isEmpty) return 'This field cannot be empty';
  return isPositiveNumber(value) ? null : 'Please enter a positive number';
}

String? validateDiscountPrice(String? value, String price) {
  if (value == null || value.isEmpty) return null; // Optional field
  if (!isPositiveNumber(value)) return 'Enter a valid discount price';
  if (double.parse(value) > double.parse(price))
    return 'Discount Price must be ≤ Price';
  return null;
}

String? validateQuantity(String? value) =>
    isPositiveInteger(value) ? null : 'Please enter a positive quantity';

String? validateDates(DateTime? from, DateTime? to) {
  if (from != null && to != null && from.isAfter(to)) {
    return 'Valid To must be after Valid From';
  }
  return null;
}

String? validateUrl(String? value) =>
    isValidUrl(value) ? null : 'Please enter a valid URL';
