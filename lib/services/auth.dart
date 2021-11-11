import 'package:drink_deals/models/myuser.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Creating MyUser object based on FirebaseUser
  MyUser? _userFromFirebaseUser(User user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  //Stream listening for change in sign-in status
  Stream<MyUser?> get myuser {
    return _auth
        .authStateChanges()
        .map((User? myuser) => _userFromFirebaseUser(myuser!));
  }

  //anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (error) {
      print(error);
      print('oof');
      return null;
    }
  }

  //sign in email/pw
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  // register email/pw
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    } catch (e) {
      print(e.toString());
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
}
