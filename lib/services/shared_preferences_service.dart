import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static Future<void> saveProductForm(
    String name,
    String id,
    String? category,
    String brand,
    String price,
    String discountPrice,
    String quantity,
    String? measurementType,
    String store,
    DateTime? validFrom,
    DateTime? validTo,
    String? productType,
    String imageUrl,
    bool notifyUsers,
    bool whatsappAlert,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('productName', name);
    prefs.setString('productId', id);
    prefs.setString('category', category ?? '');
    prefs.setString('brand', brand);
    prefs.setString('price', price);
    prefs.setString('discountPrice', discountPrice);
    prefs.setString('quantity', quantity);
    prefs.setString('measurementType', measurementType ?? '');
    prefs.setString('store', store);
    prefs.setString('validFrom', validFrom.toString());
    prefs.setString('validTo', validTo.toString());
    prefs.setString('productType', productType ?? '');
    prefs.setString('imageUrl', imageUrl);
    prefs.setBool('notifyUsers', notifyUsers);
    prefs.setBool('whatsappAlert', whatsappAlert);
  }
}
