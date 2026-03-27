import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../utils/firestore_utils.dart';

class OrderProvider extends ChangeNotifier {
  String? food;
  int qty = 1;
  int amount = 0;
  int total = 0;

  bool isLoading = false;

  void setFood(String? value) {
    food = value;
    _calculate();
  }

  void setQty(int value) {
    qty = value;
    _calculate();
  }

  void _calculate() {
    if (food != null) {
      amount = AppConstants.foodPrices[food]!;
      total = amount * qty;
      notifyListeners();
    }
  }

  Future<String?> submitOrder() async {
    if (food == null) return null;

    isLoading = true;
    notifyListeners();

    final doc = await FirestoreUtils.createOrder({
      "foodName": food,
      "quantity": qty,
      "amount": amount,
      "total": total,
      "status": "pending",
    });

    isLoading = false;
    notifyListeners();

    return doc.id;
  }
}
