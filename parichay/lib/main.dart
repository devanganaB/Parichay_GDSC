import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parichay/colors/pallete.dart';
import 'package:parichay/firebase_options.dart';
import 'package:parichay/model/recommendation.dart';
import 'package:parichay/screens/home.dart';
import 'package:parichay/screens/login.dart';
import 'package:parichay/screens/tabs_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // print("firebase initialised");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parichay:MahanRashtra',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // @override
  // void initState() {
  //   super.initState();
  //   // _navigateToOnboarding();
  //   checkUser();
  // }

  // Future<void> checkUser() async {
  //   // Check if user is already logged in
  //   User? user = _auth.currentUser;

  //   if (user != null) {
  //     // User is logged in, navigate to the desired screen
  //     // For example, navigate to the home screen
  //     Navigator.of(context).pushReplacement(MaterialPageRoute(
  //         builder: (context) => TabsScreen(
  //               getIndex: 0,
  //             )));
  //   } else {
  //     // User is not logged in, navigate to the login screen
  //     Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(builder: (context) => RegistrationPage()));
  //   }
  // }

  // final AuthService authService = AuthService();
  // final FirestoreService firestoreService = FirestoreService();

  // // Delayed navigation based on the session and user role
  // Future.delayed(const Duration(seconds: 3), () async {
  //   final user = await authService.getCurrentUser();

  //   if (user == null) {
  //     // Navigator.of(context).pushReplacement(
  //     //     MaterialPageRoute(builder: (context) => const LoginScreenOTP()));
  //     // return;
  //   } else {
  //     final userData = await firestoreService.getUserData();

  //     if (userData != null) {
  //       // final role = userData["role"];

  //       // if (role != null) {
  //       //   if (role == 0) {
  //       //     // User is a sender, navigate to sender homepage
  //       //     Navigator.of(context).pushReplacement(
  //       //       MaterialPageRoute(
  //       //         builder: (context) => const MainSender(
  //       //           getIndex: 0,
  //       //         ),
  //       //       ),
  //       //     );
  //       //   } else if (role == 1) {
  //       //     // User is a traveler, navigate to traveler homepage
  //       //     Navigator.of(context).pushReplacement(
  //       //       MaterialPageRoute(
  //       //           builder: (context) => const MainTraveller(
  //       //                 getIndex: 0,
  //       //               )),
  //       //     );
  //       //   }
  //       // } else {
  //       //   // Role not found, navigate to login page
  //       //   // Navigator.of(context).pushReplacement(MaterialPageRoute(
  //       //   //     builder: (context) => const LoginScreenOTP()));
  //       // }
  //     }
  //   }
  // });

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () async {
      User? user = _auth.currentUser;

      if (user != null) {
        // User is logged in, navigate to the desired screen
        // For example, navigate to the home screen
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => TabsScreen(
                  getIndex: 0,
                )));
      } else {
        // User is not logged in, navigate to the login screen
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
      }
    });
    return Scaffold(
      // backgroundColor: Pallete.blueprimary,
      body: Center(
        child: Stack(children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/maharashtra_outline.png', // Replace with the correct path to your image
                ),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
