import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brew_crew/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CurrentUser _userFromFirebase(user) {
    return user != null ? CurrentUser(uid: user.uid) : null;
  }

  Stream<CurrentUser> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  Future signInAnon() async {
    try {
      var result = await _auth.signInAnonymously();
      var user = result.user;
      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign up
  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      //
      await DatabaseService(uid: result.user.uid)
          .updateUserData("New Crew Member", "0", 100);
      return _userFromFirebase(result.user);
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  //Sign In
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebase(result.user);
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
}
