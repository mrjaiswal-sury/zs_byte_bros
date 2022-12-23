import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thehappyclub/services/db_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DBService dbService = DBService.instance;
  SharedPreferences prefs;

  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  FirebaseUser _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? user : null;
  }

  Future registerWithEmailAndPassword(
      String email, String password, String displayName, int depression, int pornAddiction) async {
    try {
      AuthResult result;
      try {
        result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      } catch (signUpError) {
        if (signUpError is PlatformException) {
          if (signUpError.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
            print('oh no');
            return 'User already exists';
          }
        }
      }
      print("result");
      print(result);
      FirebaseUser user = result.user;
      UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
      userUpdateInfo.displayName = displayName;
      user.updateProfile(userUpdateInfo);
      DBService.instance.createUser(user.uid, displayName, email, "", depression, pornAddiction);
      await sendEmailVerification(user);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result;
      try {
        result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      }catch (signUpError) {
        if (signUpError is PlatformException) {
          print(signUpError.code);
          if (signUpError.code == 'ERROR_WRONG_PASSWORD') {
            return 'Wrong password';
          }
          if (signUpError.code == 'ERROR_USER_NOT_FOUND') {
            return 'User not found';
          }
        }
      }
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future sendEmailVerification(FirebaseUser user) async{
    try{
      await user.sendEmailVerification();
    }catch(e){
      print(e);
    }
  }

  Future resetPassword(String email) async {
    try {
      var result = await _auth.sendPasswordResetEmail(email: email);
      return true;
    }
    catch (signUpError) {
      if (signUpError is PlatformException) {
        print(signUpError.code);
        if (signUpError.code == 'ERROR_USER_NOT_FOUND') {
          return 'User not found';
        }
      }
    }
  }

  Future signOut() async {
    try {
      prefs = await SharedPreferences.getInstance();
      prefs.remove('verified');
      return await _auth.signOut();
    } catch (e) {
      print(e);
      return null;
    }
  }
}
