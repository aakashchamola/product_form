import 'package:flutter/material.dart';
import 'package:product_form/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isSelected;
  final VoidCallback onTap;

  const ProductCard({
    Key? key,
    required this.product,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 4.0,
        color: isSelected ? Colors.blue.shade50 : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey.shade200,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Image.network(product.imageUrl),
                              actions: [
                                TextButton(
                                  child: const Text('Close'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade300,
                        ),
                        child: SizedBox(
                          child: Image.network(product.imageUrl),
                        ),
                      ),
                    ),
                  ),
                  if (isSelected)
                    const Positioned(
                      right: 0,
                      top: 0,
                      child: Icon(Icons.check_circle, color: Colors.blue),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                product.productName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '${product.currency}${product.price.toStringAsFixed(2)}', // Updated currency display
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              if (product.discountPrice != null) ...{
                Text(
                    'Discount Price: ${product.currency} ${product.discountPrice!.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.red)),
              },
              const SizedBox(height: 5),
              Text('Category: ${product.category ?? 'N/A'}'),
              const SizedBox(height: 5),
              Text('Brand: ${product.brand ?? 'N/A'}'),
              const SizedBox(height: 5),
              const SizedBox(height: 5),
              Text(
                  'Quantity: ${product.quantity} ${product.measurementType ?? ''}'),
              const SizedBox(height: 5),
              product.validFrom != null
                  ? Text(
                      'Valid: ${product.validFrom} - ${product.validTo}',
                    )
                  : const SizedBox(),
              const SizedBox(height: 5),
              Text('Store: ${product.store}'),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (product.notifyUsers)
                    const Icon(Icons.notifications, color: Colors.blue),
                  if (product.whatsappAlert)
                    const Icon(Icons.wechat, color: Colors.green),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
