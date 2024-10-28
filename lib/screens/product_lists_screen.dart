import 'package:flutter/material.dart';
import 'package:product_form/models/product_model.dart';
import 'package:product_form/widgets/product_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProductsListScreen extends StatefulWidget {
  @override
  _ProductsListScreenState createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  List<Product> products = [];
  List<String> selectedProductIds = [];
  String selectedCurrency = 'Rs'; // Default currency

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('productData');

    if (jsonString != null) {
      setState(() {
        products = (jsonDecode(jsonString) as List)
            .map((json) => Product.fromJson(json))
            .toList();
      });
    }
  }

  Future<void> _deleteSelectedProducts() async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text(
            'Are you sure you want to delete the selected products?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<Product> updatedProducts = products
          .where((product) => !selectedProductIds.contains(product.productId))
          .toList();

      await prefs.setString(
          'productData',
          jsonEncode(
              updatedProducts.map((product) => product.toJson()).toList()));
      setState(() {
        products = updatedProducts;
        selectedProductIds.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products List'),
        actions: [
          if (selectedProductIds.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteSelectedProducts,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  bool isSelected =
                      selectedProductIds.contains(product.productId);

                  return ProductCard(
                    product: product,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedProductIds.remove(product.productId);
                        } else {
                          selectedProductIds.add(product.productId);
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
