import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService{
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> signIn(
    {required String email, required String password}) async{
      try {
        await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
        return "Signed Out";
      } on FirebaseAuthException catch (e) {
        return e.message.toString();
      }
    }
}