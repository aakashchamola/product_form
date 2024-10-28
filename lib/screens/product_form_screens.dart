import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:product_form/models/product_model.dart';
import 'package:product_form/screens/product_lists_screen.dart';
import 'package:product_form/services/validation_utils.dart';
import 'package:product_form/widgets/check_box_field.dart';
import 'package:product_form/widgets/custom_text_field.dart';
import 'package:product_form/widgets/dropdown_field.dart';
import 'package:product_form/widgets/date_picker_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final String defaultImage =
      "https://www.packingsupply.in/web/templates/images/products/1523101691-Rectangle-corrugated-boxes-cartons.jpg";
  // Controllers
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productIdController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController discountPriceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController storeController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  // Form fields
  String? selectedCategory;
  String? selectedMeasurementType;
  String? selectedProductType;
  bool notifyUsers = false;
  bool whatsappAlert = false;
  DateTime? validFrom;
  DateTime? validTo;
  List<String> existingProductIds = [];
  String selectedCurrency = 'Rs'; // Default currency

  Future<void> _saveProductData() async {
    // Regex to validate if the URL is a valid image link
    bool _isValidImageUrl(String url) {
      final RegExp regex = RegExp(
          r'^(http(s?):)([/|.|\w|\s|-])*\.(?:jpg|gif|png|jpeg|bmp|webp)$',
          caseSensitive: false);
      return regex.hasMatch(url);
    }

    // Validate the imageUrl and assign default if invalid
    String imageUrl = imageUrlController.text;
    if (imageUrl.isEmpty || !_isValidImageUrl(imageUrl)) {
      imageUrl = defaultImage;
    }
    Product product = Product(
      productName: productNameController.text,
      productId: productIdController.text,
      category: selectedCategory,
      brand: brandController.text,
      currency: selectedCurrency,
      price: double.parse(priceController.text),
      discountPrice: discountPriceController.text.isNotEmpty
          ? double.parse(discountPriceController.text)
          : null,
      quantity: int.parse(quantityController.text),
      measurementType: selectedMeasurementType,
      store: storeController.text,
      validFrom: validFrom,
      validTo: validTo,
      productType: selectedProductType,
      imageUrl: imageUrl,
      notifyUsers: notifyUsers,
      whatsappAlert: whatsappAlert,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? existingData = prefs.getString('productData');

    List<Product> products = existingData != null
        ? (jsonDecode(existingData) as List)
            .map((json) => Product.fromJson(json))
            .toList()
        : [];

    products.add(product);

    await prefs.setString(
        'productData', jsonEncode(products.map((p) => p.toJson()).toList()));
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (validFrom != null &&
          validTo != null &&
          validFrom!.isAfter(validTo!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Valid To must be after Valid From')),
        );
        return;
      }

      _saveProductData().then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product saved successfully!')),
        );

        // Clear the fields after saving
        productNameController.clear();
        productIdController.clear();
        brandController.clear();
        priceController.clear();
        discountPriceController.clear();
        quantityController.clear();
        storeController.clear();
        imageUrlController.clear();
        setState(() {
          selectedCategory = null;
          selectedMeasurementType = null;
          selectedProductType = null;
          validFrom = null;
          validTo = null;
          notifyUsers = false;
          whatsappAlert = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Entry Form'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductsListScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Product Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: productNameController,
                labelText: 'Product Name',
                helperText: 'Enter the name of the product',
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the product name'
                    : null,
              ),
              CustomTextField(
                controller: productIdController,
                labelText: 'Product ID',
                helperText: 'Unique ID for the product (max 10 characters)',
                validator: (value) =>
                    validateProductId(value, existingProductIds),
                maxlength: 10,
              ),
              DropDownField(
                labelText: 'Category',
                items: const ['Grocery', 'Electronics'],
                value: selectedCategory,
                helperText: 'Choose a category for the product',
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                    if (selectedCategory != 'Grocery') {
                      selectedMeasurementType = null;
                    }
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a category' : null,
              ),
              CustomTextField(
                controller: brandController,
                labelText: 'Brand',
                helperText: 'Enter the brand of the product',
              ),
              Row(
                children: [
                  Expanded(
                    child: DropDownField(
                      labelText: 'Currency',
                      items: const ['Rs', '\$'],
                      value: selectedCurrency,
                      helperText: 'Choose currency',
                      onChanged: (value) => setState(() {
                        selectedCurrency = value!;
                      }),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomTextField(
                      controller: priceController,
                      labelText: 'Price',
                      helperText: 'Enter the price of the product',
                      inputType: TextInputType.number,
                      validator: validatePositiveNumber,
                      prefixText: selectedCurrency,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: discountPriceController,
                      labelText: 'Discount Price',
                      helperText: 'Enter the discount price if applicable',
                      inputType: TextInputType.number,
                      validator: (value) =>
                          validateDiscountPrice(value, priceController.text),
                      prefixText: selectedCurrency,
                    ),
                  ),
                ],
              ),
              CustomTextField(
                controller: quantityController,
                labelText: 'Quantity',
                helperText: 'Enter the available quantity',
                inputType: TextInputType.number,
                validator: validateQuantity,
              ),
              DropDownField(
                labelText: 'Measurement Type',
                items: const ['kg', 'liters'],
                value: selectedMeasurementType,
                helperText: 'Select the unit of measurement',
                onChanged: selectedCategory == 'Grocery'
                    ? (value) => setState(() => selectedMeasurementType = value)
                    : null, // Disable for Electronics by setting onChanged to null
                validator: selectedCategory == 'Grocery'
                    ? (value) => value == null
                        ? 'Please select a measurement type'
                        : null
                    : null, // No validation needed for Electronics
              ),
              DropDownField(
                labelText: 'Product Type',
                items: const ['Regular', 'Combo'],
                value: selectedProductType,
                helperText: 'Select the Product Type',
                onChanged: (value) =>
                    setState(() => selectedProductType = value),
                validator: (value) =>
                    value == null ? 'Please select a Product type' : null,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  DatePickerField(
                    label: 'Valid From',
                    selectedDate: validFrom,
                    onDateSelected: (date) => setState(() => validFrom = date),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  DatePickerField(
                    label: 'Valid To',
                    selectedDate: validTo,
                    onDateSelected: (date) => setState(() => validTo = date),
                  ),
                ],
              ),
              CheckBoxField(
                label: 'Notify Users',
                value: notifyUsers,
                icon: Icons.notifications, // Pass the icon here
                onChanged: (value) => setState(() {
                  notifyUsers = value!;
                }),
              ),
              CheckBoxField(
                label: 'WhatsApp Alert',
                value: whatsappAlert,
                icon: Icons.wechat, // Pass the icon here
                onChanged: (value) => setState(() {
                  whatsappAlert = value!;
                }),
              ),
              CustomTextField(
                controller: storeController,
                labelText: 'Store',
                helperText: 'Enter the store where the product is available',
              ),
              CustomTextField(
                controller: imageUrlController,
                labelText: 'Image URL',
                helperText:
                    'Enter a valid image URL for the product (optional)',
                validator: validateUrl,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleSubmit,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
