import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/app_constants.dart';

class FirestoreUtils {
  static final _db = FirebaseFirestore.instance;

  static Future<DocumentReference> createOrder(Map<String, dynamic> data) {
    return _db.collection(AppConstants.ordersCollection).add(data);
  }

  static Stream<QuerySnapshot> getPendingOrders() {
    return _db
        .collection(AppConstants.ordersCollection)
        .where("status", isEqualTo: "pending")
        .snapshots();
  }

  static Stream<QuerySnapshot> getCompleteOrders() {
    return _db
        .collection(AppConstants.ordersCollection)
        .where("status", isNotEqualTo: "pending")
        .snapshots();
  }

  static Stream<DocumentSnapshot> getOrder(String id) {
    return _db.collection(AppConstants.ordersCollection).doc(id).snapshots();
  }

  static Future<void> updateOrder(String id, Map<String, dynamic> data) {
    return _db.collection(AppConstants.ordersCollection).doc(id).update(data);
  }

  static Future<DocumentReference> createLocation(Map<String, dynamic> data) {
    return _db.collection(AppConstants.locationsCollection).add(data);
  }

  static Stream<QuerySnapshot> getOrderLocation(String id) {
    return _db
        .collection(AppConstants.locationsCollection)
        .where("orderId", isEqualTo: id)
        .snapshots();
  }
}
