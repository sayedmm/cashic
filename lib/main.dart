import 'dart:async';

import 'package:cashic/constants.dart';
import 'package:cashic/firebase/model/user.dart';
import 'package:cashic/firebase/services/authenticate.dart';
import 'package:cashic/firebase/services/helper.dart';
import 'package:cashic/firebase/ui/auth/authScreen.dart';
import 'package:cashic/firebase/ui/home/homeScreen.dart';
import 'package:cashic/firebase/ui/login/loginScreen.dart';
import 'package:cashic/firebase/ui/onBoarding/onBoardingScreen.dart';
import 'package:cashic/firebase/ui/signUp/signUpScreen.dart';
import 'package:cashic/pages/get-referred.dart';
import 'package:cashic/pages/home.dart';
import 'package:cashic/pages/my-account.dart';
import 'package:cashic/pages/privacy-policy.dart';
import 'package:cashic/pages/recaptcha.dart';
import 'package:cashic/pages/solve-math.dart';
import 'package:cashic/pages/splash-screen.dart';
import 'package:cashic/pages/themes.dart';
import 'package:cashic/pages/video-taskes.dart';
import 'package:cashic/pages/watchad.dart';
import 'package:cashic/pages/withdraw.dart';
import 'package:cashic/sp-wheel/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  static late User? currentUser;


  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }
  int color1 = Colors.tealAccent[100]!.value;
  late SharedPreferences prefs;
   _ggetData() async {
    prefs = await SharedPreferences.getInstance();
    
    setState(() {
      color1 = prefs.getInt('colos') ?? Colors.tealAccent[100]!.value;
    });
  }
  @override
  Widget build(BuildContext context) {
    _ggetData();
    // Show error message if initialization failed
    if (_error) {
      return MaterialApp(
          home: Scaffold(
        body: Container(
          color: Colors.white,
          child: Center(
              child: Column(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 25,
              ),
              SizedBox(height: 16),
              Text(
                'Failed to initialise firebase!',
                style: TextStyle(color: Colors.red, fontSize: 25),
              ),
            ],
          )),
        ),
      ));
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }

    return MaterialApp(
      
        debugShowCheckedModeBanner: false,
        routes: {
          SolveMath.id: (context) => SolveMath(),
          Withdraw.id: (context) => Withdraw(),
          Recaptcha.id: (context) => Recaptcha(),
          GetReferred.id: (context) => GetReferred(),
          MyAccount.id: (context) => MyAccount(),
          HomePage.id: (context) => HomePage(),
          Home.id: (context) => Home(),
          LoginScreen.id: (context) => LoginScreen(),
          SignUpScreen.id: (context) => SignUpScreen(),
          WatchAds.id: (context) => WatchAds(),
          VideoTaskes.id: (context) => VideoTaskes(),
           Themes.id: (context) => Themes(),
          my_page.id: (context) => my_page(),
          PrivacyAndPolicy.id: (context) => PrivacyAndPolicy(),
        },
        
        theme: ThemeData(
          primaryColor: Color(color1),
        ),
        home: my_page());
  }

  @override
  void initState() {
    super.initState();
    initializeFlutterFire();
  }
}

class OnBoarding extends StatefulWidget {
  @override
  State createState() {
    return OnBoardingState();
  }
}

class OnBoardingState extends State<OnBoarding> {
  Future hasFinishedOnBoarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool finishedOnBoarding = (prefs.getBool(FINISHED_ON_BOARDING) ?? false);

    if (finishedOnBoarding) {
      auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        auth.User? user =
            (await FireStoreUtils.getCurrentUser(firebaseUser.uid))
                as auth.User?;
        if (user != null) {
          MyAppState.currentUser = user as User?;
          pushReplacement(context, new HomeScreen(user: user as User));
        } else {
          pushReplacement(context, new AuthScreen());
        }
      } else {
        pushReplacement(context, new AuthScreen());
      }
    } else {
      pushReplacement(context, new OnBoardingScreen());
    }
  }

  @override
  void initState() {
    super.initState();
    hasFinishedOnBoarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator.adaptive(
          valueColor: AlwaysStoppedAnimation(Color(COLOR_PRIMARY)),
        ),
      ),
    );
  }
}
