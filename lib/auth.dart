import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth{
  static Future<User?> iniciarSesion() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount!=null) {
        GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        AuthCredential credenciales = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken
        );
      try {
        UserCredential userCredential = await auth.signInWithCredential(credenciales);
        user = userCredential.user;
        return user;
      } on FirebaseAuthException catch (e) {
        print(e);
      }
    }
      
    return null;
  }
}