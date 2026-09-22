import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges {
    return _firebaseAuth.authStateChanges();
  }

  User? get currentUser {
    return _firebaseAuth.currentUser;
  }

  Future<UserCredential> login(
    String email,
    String password,
  ) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> register(
  String name,
  String email,
  String password,
) async {
  final credential = await _firebaseAuth.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );

  await credential.user?.updateDisplayName(name);

  await credential.user?.reload();

  return credential;
}

  Future<void> resetPassword(String email) async {
  await _firebaseAuth.sendPasswordResetEmail(
    email: email,
  );
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Future<UserCredential?> signInWithGoogle() async {
  final googleSignIn = GoogleSignIn.instance;

  final googleUser = await googleSignIn.authenticate();

  final googleAuth = googleUser.authentication;

  final credential = GoogleAuthProvider.credential(
    idToken: googleAuth.idToken,
  );
  
  return await _firebaseAuth.signInWithCredential(credential);
}
  
}