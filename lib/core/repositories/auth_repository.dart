import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Google Sign-In instance (Singleton in v7+)
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  // Stream of auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Current user
  User? get currentUser => _auth.currentUser;

  // Sign in anonymously (for MVP/Testing if other providers not setup)
  Future<UserCredential> signInAnonymously() async {
      try {
        return await _auth.signInAnonymously();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'operation-not-allowed') {
          print("⚠️ ERROR: Anonymous Login is disabled in Firebase Console!");
          print("👉 Go to Authentication > Sign-in method > Enable Anonymous");
        }
        rethrow;
      }
  }

  // Google Sign-In
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    // Note: GoogleSignIn.instance.initialize() must be called once before this.
    // We assume it is called in main.dart or lazily here if needed.
    // For now, we proceed with authenticate().
    
    final GoogleSignInAccount googleUser;
    try {
      googleUser = await _googleSignIn.authenticate();
    } catch (error) {
       // Check for cancellation or other errors
       // In v7, cancellation throws an exception using GoogleSignInException
       // We can check the code if needed or just handle genericaly.
       // Assuming cancellation if we get here for now to match previous logic logic
       throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }

    // Obtain the auth details from the request
    // In v7, authentication is synchronous
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await _auth.signInWithCredential(credential);
  }

  // Sign out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // Check if user profile exists in Firestore
  Future<bool> checkProfileExists(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.exists;
    } catch (e) {
      // Handle error gracefully, maybe retry or assume false
      return false;
    }
  }

  // Save user profile
  Future<void> saveUserProfile(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).set(data, SetOptions(merge: true));
  }
}
