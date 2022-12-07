
import 'package:bipolari_app/models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthStates{
  uninitialized,
  authenticated,
  authenticating,
  unauthenticated,
  noauthorized
}

class AuthProvider with ChangeNotifier{
  FirebaseAuth _auth = FirebaseAuth.instance;
  Usuario?_user;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  AuthStates _status = AuthStates.uninitialized;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Usuario? get user => _user;
  AuthStates get status => _status;

  AuthProvider(){
    FirebaseAuth.instance
    .authStateChanges()
    .listen((event) async{
      if (event == null) {
        print('El usuario cerro sesión');
        _status = AuthStates.unauthenticated;
        _user = null;
        notifyListeners();
      }else{
        print("El usuario inicio sesión");
        _status = AuthStates.authenticated;
        notifyListeners();
      }
    });
  }

  Future<void> signInGoogle() async{
    try {
      _status = AuthStates.authenticating;
      notifyListeners();
      
      GoogleSignInAccount? _googleUser = await _googleSignIn.signIn().catchError((onError)=> print(onError));
      if(_googleUser == null){
        print("Sesion cancelada!");
        _status = AuthStates.unauthenticated;
        notifyListeners();
        return;
      }

      GoogleSignInAuthentication googleSignInAuthentication = await _googleUser.authentication;
      AuthCredential credenciales = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken
      );
      UserCredential userCredential = await _auth.signInWithCredential(credenciales);
      userCredential.user;
      
      var _data = await _db.collection("usuarios")
        .where('email', isEqualTo: userCredential.user?.email)
        .limit(1)
        .get();

      if (_data.docs.length == 0){
        await FirebaseAuth.instance.signOut();
        await _googleSignIn.disconnect();
        _status = AuthStates.noauthorized;
        return;
      }

      var fields = _data.docs.first.data();
      if(fields["rol"] == "psicologo"){
        _user = Usuario(id:_data.docs.first.id,nombre: fields['nombre'], email: fields['email'], rol: fields["rol"], fotoUrl: userCredential.user?.photoURL);
      }else{
        _user = Usuario(
          id: _data.docs.first.id,
          nombre: fields['nombre'],
          email: fields['email'],
          rol: fields["rol"],
          emailTutor: fields['emailTutor'],
          historiaClinica: {
            "ocupacion": fields['historiaClinica']['ocupacion'],
            "estadoCivil": fields['historiaClinica']['estadoCivil'],
            "fechaNacimiento": fields['historiaClinica']['fechaNacimiento'].toDate()
          },
          fotoUrl: userCredential.user?.photoURL
        );
      }
    }on PlatformException catch(e){
      _status = AuthStates.unauthenticated;
      notifyListeners();
      print("ERROR: $e");
    } catch (e) {
      _status = AuthStates.unauthenticated;
      notifyListeners();
      print("ERROR: $e");
    }
  }

  Future<void> cerrarSesion()async{
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.disconnect();
  }
}