// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   _signInWithGoogle() async {
//     print('SIGN IN ===========================================================');
//     final googleUser = await _googleSignIn.signIn();
//     final googleAuth = await googleUser!.authentication;
//     final AuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );
//     final auth = await _auth.signInWithCredential(credential);
//     final user = auth.user;
//     print(
//         "signed in ${user!.displayName} =====================================p===================================================================================================================================================================");
//     return user;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const SizedBox(height: 40),
//           ElevatedButton.icon(
//               onPressed: () {
//                 // _signInWithGoogle();
//               },
//               icon: const Icon(
//                 Icons.local_atm,
//                 size: 32,
//               ),
//               label: const Text(
//                 "Sign In witth google",
//                 style: TextStyle(fontSize: 24),
//               ))
//         ],
//       ),
//     );
//   }
// }

// class GoogleSignInProvider extends ChangeNotifier {
//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   GoogleSignInAccount? _user;

//   Future googleLogin() async {
//     final googleUser = await _googleSignIn.signIn();
//     if (googleUser == null) return;
//     _user = googleUser;

//     final googleAuth = await googleUser.authentication;

//     final credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

//     await FirebaseAuth.instance.signInWithCredential(credential);

//     notifyListeners();
//   }
// }
