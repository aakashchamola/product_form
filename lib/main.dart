import 'package:flutter/material.dart';
import 'package:product_form/screens/product_form_screens.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Entry Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductFormScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
