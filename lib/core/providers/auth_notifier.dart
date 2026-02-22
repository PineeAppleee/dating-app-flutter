import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthNotifier extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<DocumentSnapshot>? _profileSubscription;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  User? _user;
  User? get user => _user;

  bool _profileExists = false;
  bool get profileExists => _profileExists;

  AuthNotifier() {
    _authSubscription = _auth.authStateChanges().listen((User? user) {
      print("🔥 AUTH STATE CHANGE");
      print("USER: $user");

      _user = user;

      if (user == null) {
        print("❌ user null");
        _profileSubscription?.cancel();
        _profileExists = false;
        _isLoading = false;
        notifyListeners();
        return;
      }

      print("✅ user logged in: ${user.uid}");

      // Use snapshots().listen() instead of get() to avoid hanging and to get real-time updates
      _profileSubscription?.cancel();
      _profileSubscription = _firestore.collection('users').doc(user.uid).snapshots().listen((doc) {
        print("📄 firestore doc exists: ${doc.exists}");
        print("📄 firestore data: ${doc.data()}");

        final data = doc.data();
        final isCompleted = data?['meta']?['isProfileCompleted'] == true || data?['name'] != null;

        if (doc.exists && isCompleted) {
          _profileExists = true;
          print("🟢 PROFILE EXISTS TRUE");
        } else {
          _profileExists = false;
          print("🔴 PROFILE EXISTS FALSE");
        }

        _isLoading = false;
        notifyListeners();
      }, onError: (e) {
        print("❌ Error fetching user profile: $e");
        _profileExists = false;
        _isLoading = false;
        notifyListeners();
      });
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _profileSubscription?.cancel();
    super.dispose();
  }
}