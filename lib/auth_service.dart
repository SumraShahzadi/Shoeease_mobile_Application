import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Register a new user and save profile to Firestore
  Future<String> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;

    // Save user info to Firestore users collection
    await _db.collection('users').doc(uid).set({
      'fullName': fullName,
      'email': email,
      'createdAt': Timestamp.now(),
    });

    return fullName;
  }

  /// Login and return the user's full name from Firestore
  Future<String> login({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;
    final doc = await _db.collection('users').doc(uid).get();

    if (doc.exists) {
      return doc.data()?['fullName'] ?? email;
    }
    return email;
  }

  /// Logout the current user
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// Get current user's name from Firestore
  Future<String> getCurrentUserName() async {
    final user = _auth.currentUser;
    if (user == null) return '';
    final doc = await _db.collection('users').doc(user.uid).get();
    return doc.data()?['fullName'] ?? '';
  }
}
