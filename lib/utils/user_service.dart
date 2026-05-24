import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  static final _db = FirebaseFirestore.instance;

  static String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  /// Fetch the current user's profile document from Firestore.
  static Future<Map<String, dynamic>?> fetchProfile() async {
    final uid = _uid;
    if (uid == null) return null;
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data();
  }

  /// Update the user's profile in Firestore and Firebase Auth display name.
  static Future<void> updateProfile({
    required String name,
    required String phone,
    required String address,
  }) async {
    final uid = _uid;
    if (uid == null) return;

    // Update Firestore doc
    await _db.collection('users').doc(uid).update({
      'name': name,
      'phone': phone,
      'address': address,
    });

    // Keep Firebase Auth display name in sync
    await FirebaseAuth.instance.currentUser?.updateDisplayName(name);
  }

  /// Count how many orders the user has placed.
  static Future<int> fetchOrderCount() async {
    final uid = _uid;
    if (uid == null) return 0;
    final snap = await _db
        .collection('users')
        .doc(uid)
        .collection('orders')
        .count()
        .get();
    return snap.count ?? 0;
  }
}