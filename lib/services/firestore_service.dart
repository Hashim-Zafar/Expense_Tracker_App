import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expense_tracker/models/subscription.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;

  // Stream of subscriptions for current user
  Stream<List<Subscription>> getSubscriptions() {
    if (_user == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(_user.uid)
        .collection('subscriptions')
        .orderBy('nextDue')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Subscription.fromFirestore(doc))
              .toList();
        });
  }

  // Add new subscription
  Future<void> addSubscription(Subscription sub) async {
    if (_user == null) return;

    await _firestore
        .collection('users')
        .doc(_user.uid)
        .collection('subscriptions')
        .add(sub.toFirestore());
  }

  //Update subscription
  Future<void> updateSubscription(String id, Map<String, dynamic> data) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('subscriptions')
        .doc(id)
        .update(data);
  }

  //delete subscription
  Future<void> deleteSubscription(String id) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('subscriptions')
        .doc(id)
        .delete();
  }

  // Get user budget (stub - store in user doc)
  Future<double> getBudget() async {
    if (_user == null) return 2000.0;

    DocumentSnapshot doc = await _firestore
        .collection('users')
        .doc(_user.uid)
        .get();
    return (doc.data() as Map?)?['budget']?.toDouble() ?? 2000.0;
  }

  // Set user budget
  Future<void> setBudget(double budget) async {
    if (_user == null) return;

    await _firestore.collection('users').doc(_user.uid).set({
      'budget': budget,
    }, SetOptions(merge: true));
  }

  // Add a new category
  Future<void> addCategory(String name) async {
    if (_user == null) return;
    await _firestore
        .collection('users')
        .doc(_user!.uid)
        .collection('categories')
        .add({'name': name});
  }

  // Fetch categories
  Stream<List<String>> getCategories() {
    if (_user == null) return Stream.value([]);
    return _firestore
        .collection('users')
        .doc(_user!.uid)
        .collection('categories')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => doc['name'] as String).toList(),
        );
  }
}
