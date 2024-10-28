class Product {
  final String productName;
  final String productId;
  final String? category;
  final String? brand;
  final String currency;
  final double price;
  final double? discountPrice;
  final int quantity;
  final String? measurementType;
  final String store;
  final DateTime? validFrom;
  final DateTime? validTo;
  final String? productType;
  final String imageUrl;
  final bool notifyUsers;
  final bool whatsappAlert;

  Product({
    required this.productName,
    required this.productId,
    this.category,
    this.brand,
    required this.currency,
    required this.price,
    this.discountPrice,
    required this.quantity,
    this.measurementType,
    required this.store,
    this.validFrom,
    this.validTo,
    this.productType,
    required this.imageUrl,
    required this.notifyUsers,
    required this.whatsappAlert,
  });

  Map<String, dynamic> toJson() => {
        'productName': productName,
        'productId': productId,
        'category': category,
        'brand': brand,
        'price': price,
        'currency': currency,
        'discountPrice': discountPrice,
        'quantity': quantity,
        'measurementType': measurementType,
        'store': store,
        'validFrom': validFrom?.toIso8601String(),
        'validTo': validTo?.toIso8601String(),
        'productType': productType,
        'imageUrl': imageUrl,
        'notifyUsers': notifyUsers,
        'whatsappAlert': whatsappAlert,
      };

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productName: json['productName'],
      productId: json['productId'],
      category: json['category'],
      brand: json['brand'],
      currency: json['currency'],
      price: json['price'],
      discountPrice: json['discountPrice'],
      quantity: json['quantity'],
      measurementType: json['measurementType'],
      store: json['store'],
      validFrom:
          json['validFrom'] != null ? DateTime.parse(json['validFrom']) : null,
      validTo: json['validTo'] != null ? DateTime.parse(json['validTo']) : null,
      productType: json['productType'],
      imageUrl: json['imageUrl'],
      notifyUsers: json['notifyUsers'],
      whatsappAlert: json['whatsappAlert'],
    );
  }
}
