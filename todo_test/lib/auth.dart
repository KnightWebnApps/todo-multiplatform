import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  FirebaseUser user;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    
  );

  
  final FirebaseAuth _auth = FirebaseAuth.instance;

  
  Future<FirebaseUser> handleLogginWithGoogle()async{
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    user = (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
  }

  Future<FirebaseUser> handleLoginAnon()async {
    user = (await _auth.signInAnonymously()).user;
    print('signed in anon');
    return user;
  }

  Future signOut() async{
    await _auth.signOut();
  }

  
  
}