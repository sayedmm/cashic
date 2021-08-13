// ignore: import_of_legacy_library_into_null_safe
import 'dart:async';

import 'package:cashic/ads-helper.dart';
import 'package:cashic/constants.dart';
import 'package:cashic/firebase/model/user.dart';
import 'package:cashic/firebase/services/authenticate.dart';
import 'package:cashic/firebase/services/helper.dart';
import 'package:cashic/firebase/ui/home/homeScreen.dart';
import 'package:cashic/main.dart';
// import 'package:cashic/main.dart';
import 'package:cashic/pages/get-referred.dart';
import 'package:cashic/pages/privacy-policy.dart';
import 'package:cashic/pages/recaptcha.dart';
// import 'package:cashic/pages/shared-pref.dart';
import 'package:cashic/pages/themes.dart';
import 'package:cashic/pages/video-taskes.dart';
import 'package:cashic/pages/watchad.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cashic/pages/solve-math.dart';
import 'package:cashic/pages/withdraw.dart';
import 'package:cashic/sp-wheel/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  static String id = 'HomeScreen';

  static int? total;
//static User? user;
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home> {
  User? nuser = MyAppState.currentUser;

  var total;

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          this._interstitialAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {},
          );

          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  //////////////////////////////////////////////////////

  late BannerAd _bannerAd;

  bool _isBannerAdReady = false;
  late User user;
  @override
  void initState() {
    user = nuser!;
    hasFinishedOnBoarding();
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
    if (!_isInterstitialAdReady) {
      _loadInterstitialAd();
    }
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  int dePoints = 10;

  _onBackPress() {
    return showDialog(
        context: context,
        builder: (BuiderContext) {
          return AlertDialog(
            title: Text('Are You Sure?'),
            content: Text('You are going to Exit App!!'),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  if (_isInterstitialAdReady) {
                    _interstitialAd?.show();
                    SystemNavigator.pop();
                  } else {
                    SystemNavigator.pop();
                  }
                },
              ),
            ],
          );
        });
    //   //  if (!_isInterstitialAdReady) {
    //   // _loadInterstitialAd();
    // }
  }

  int color1 = Colors.tealAccent[100]!.value;
  late SharedPreferences prefs;
  _ggetData() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      color1 = prefs.getInt('colos') ?? Colors.tealAccent[100]!.value;
    });
  }

  String appUrl =
      'https://play.google.com/store/apps/details?id=com.gee.cashic';
  @override
  Widget build(BuildContext context) {
    _ggetData();
    return WillPopScope(
      onWillPop: () => _onBackPress(),
      child: Scaffold(
        backgroundColor: Color(color1),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          title: Padding(
            padding: EdgeInsets.only(top: 18),
            child: Image.asset(
              'assets/images/cashic_pavert_copy.png',
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, Themes.id);
              },
              icon: Icon(Icons.settings),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20, bottom: 8),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Points'),
                    Text(
                      '${nuser!.points}'.toString().toUpperCase(),
                      style: TextStyle(fontSize: 30),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      'Withdrawal minimum is 5000 points (5\$)',
                      style: TextStyle(
                          fontSize: 10, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            behavior: HitTestBehavior.deferToChild,
                            onTap: () async {
                              Navigator.pushNamed(context, VideoTaskes.id);
                              // SharedPreferences prefs =
                              //     await SharedPreferences.getInstance();
                              // var a = prefs.getInt('z') ?? 0;
                              // print('Points cccccc $a');
                            },
                            child: Card(
                              elevation: 16,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width * .38,
                                height: 125,
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 0),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        image: new DecorationImage(
                                          image: AssetImage(
                                              "assets/images/movies_app.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 12),
                                      child: Text(
                                        'Video Task',
                                        style: TextStyle(
                                          fontSize: 11,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.deferToChild,
                            onTap: () {
                              Navigator.pushNamed(context, HomePage.id);
                            },
                            child: Card(
                              elevation: 16,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width * .38,
                                height: 125,
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 0),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        image: new DecorationImage(
                                          image: AssetImage(
                                              "assets/images/spinner.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 12),
                                      child: Text(
                                        'Fortune Wheel',
                                        style: TextStyle(
                                          fontSize: 11,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            behavior: HitTestBehavior.deferToChild,
                            onTap: () {
                              Navigator.pushNamed(context, SolveMath.id);
                            },
                            child: Card(
                              elevation: 16,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width * .38,
                                height: 125,
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 0),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        image: new DecorationImage(
                                          image: AssetImage(
                                              "assets/images/calculator.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 12),
                                      child: Text(
                                        'Solve Math',
                                        style: TextStyle(
                                          fontSize: 11,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.deferToChild,
                            onTap: () {
                              Navigator.pushNamed(context, Recaptcha.id);
                            },
                            child: Card(
                              elevation: 16,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width * .38,
                                height: 125,
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 0),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        image: new DecorationImage(
                                          image: AssetImage(
                                              "assets/images/captcha.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 12),
                                      child: Text(
                                        'reCaptcha',
                                        style: TextStyle(
                                          fontSize: 11,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            behavior: HitTestBehavior.deferToChild,
                            onTap: () {
                              _deilyDonus();
                            },
                            child: Card(
                              elevation: 16,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width * .38,
                                height: 125,
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 0),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        image: new DecorationImage(
                                          image: AssetImage(
                                              "assets/images/calendar.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 12),
                                      child: Text(
                                        'Daily Bonus',
                                        style: TextStyle(
                                          fontSize: 11,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.deferToChild,
                            onTap: () {
                              Navigator.pushNamed(context, GetReferred.id);
                            },
                            child: Card(
                              elevation: 16,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width * .38,
                                height: 125,
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 0),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        image: new DecorationImage(
                                          image: AssetImage(
                                              "assets/images/friendship.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 12),
                                      child: Text(
                                        'Get Referred',
                                        style: TextStyle(
                                          fontSize: 11,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            behavior: HitTestBehavior.deferToChild,
                            onTap: () {
                              // //hasFinishedOnBoarding();
                              // //Navigator.pushNamed(context, HomeScreen.id);
                              // NavigatorKey.currentState.push();
                              pushReplacement(
                                  context,
                                  new HomeScreen(
                                    user: nuser as User,
                                  ));
                            },
                            child: Card(
                              elevation: 16,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width * .38,
                                height: 125,
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 0),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        image: new DecorationImage(
                                          image: AssetImage(
                                              "assets/images/Person.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 12),
                                      child: Text(
                                        'My Account',
                                        style: TextStyle(
                                          fontSize: 11,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.deferToChild,
                            onTap: () {
                              Navigator.pushNamed(context, WatchAds.id);
                            },
                            child: Card(
                              elevation: 16,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width * .38,
                                height: 125,
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 0),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        image: new DecorationImage(
                                          image: AssetImage(
                                              "assets/images/Ad-Break.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 12),
                                      child: Text(
                                        'Watch Ads & Get Points',
                                        style: TextStyle(
                                          fontSize: 11,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(
                        height: .02,
                        color: Colors.black,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            behavior: HitTestBehavior.deferToChild,
                            onTap: () {
                              Navigator.pushNamed(context, Withdraw.id);
                            },
                            child: Card(
                              elevation: 16,
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width * .25,
                                height: 100,
                                padding: EdgeInsets.only(
                                    top: 7, left: 7, right: 7, bottom: 7),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        image: new DecorationImage(
                                          image: AssetImage(
                                              "assets/images/wallet.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 14),
                                      child: Text(
                                        'WithDraw',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.deferToChild,
                            onTap: () {
                              Share.share(appUrl);
                            },
                            child: Card(
                              elevation: 16,
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width * .25,
                                height: 100,
                                padding: EdgeInsets.only(
                                    top: 7, left: 7, right: 7, bottom: 7),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        image: new DecorationImage(
                                          image: AssetImage(
                                              "assets/images/collaboration.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 14),
                                      child: Text(
                                        'Shara us',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.deferToChild,
                            onTap: () {
                              _launchURL();
                            },
                            child: Card(
                              elevation: 16,
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width * .25,
                                height: 100,
                                padding: EdgeInsets.only(
                                    top: 7, left: 7, right: 7, bottom: 7),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        image: new DecorationImage(
                                          image: AssetImage(
                                              "assets/images/playstore.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 14),
                                      child: Text(
                                        'Rate us',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_isBannerAdReady)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: _bannerAd.size.width.toDouble(),
                  height: _bannerAd.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd),
                ),
              ),
          ],
        ),
        drawer: Drawer(
          elevation: 5,
          child: ListView(
            children: <Widget>[
              Container(
                width: 500,
                height: 150,
                decoration: BoxDecoration(
                  image: new DecorationImage(
                    image: AssetImage("assets/images/cashic-ico2.png"),
                    //fit: BoxFit.fill,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, Home.id);
                },
                title: Text('DashBoard'),
                leading: Icon(Icons.dashboard, color: Colors.black),
              ),
              //Divider(height: 0.2),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, Withdraw.id);
                },
                title: Text('Withdraw'),
                leading: Icon(Icons.payments, color: Colors.black),
              ),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, GetReferred.id);
                },
                title: Text('Refer & Earn'),
                leading: Icon(Icons.people, color: Colors.black),
              ),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, PrivacyAndPolicy.id);
                },
                title: Text('Privacy Policy'),
                leading: Icon(Icons.privacy_tip, color: Colors.black),
              ),
              ListTile(
                onTap: () {
                  Share.share(appUrl);
                },
                title: Text('Share us'),
                leading: Icon(Icons.share, color: Colors.black),
              ),
              ListTile(
                onTap: () {
                  _launchURL();
                },
                title: Text('Rate us'),
                leading: Icon(Icons.star, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _launchURL() async {
    const url = 'https://play.google.com/store/apps/details?id=com.gee.cashic';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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
          var snackBar = SnackBar(content: Text('Your data Not Ready'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        var snackBar = SnackBar(content: Text('Still Working!!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  void _deilyDonus() {
    // Timer timer = Timer(Duration(seconds: 3),(){};
    // //var _asset = 5;
    // if(timer.isActive){

    // }
    var bool = false;
    if (bool == true) {
      Future.delayed(Duration(hours: 24), () {
        Dialog errorDialog = Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0)), //this right here
          child: Container(
            height: MediaQuery.of(context).size.height * .3,
            width: 300.0,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    'Congrats !!',
                    //style: TextStyle(color: Colors.red),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'You have won ${dePoints} Points. Play again to get more free Points',
                    //style: TextStyle(color: Colors.red),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10.0)),
                TextButton(
                    onPressed: () {
                      //_savesp();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'ADD TO WALLET!',
                      style: TextStyle(color: Colors.purple, fontSize: 12.0),
                    ))
              ],
            ),
          ),
        );
        showDialog(
            context: context, builder: (BuildContext context) => errorDialog);
      });
    } else {
      var snackBar = SnackBar(content: Text('Aready Checked'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    void videoTask() {
      // run brogress bar
      // show video() method
      // add 10 points to balance in database
      // massage you get 10 points
    }
    void showVideo() {
      //get a video from database
      // show a video in new alert screen
      //add mark x to out video and show alert massage should reseum video
      //video finish
    }
  }

  // _savesp() {
  //   SharedPref.saveData('dailyB', dePoints);
  // }

  // _sum() async {
  //   // SharedPreferences prefs = await SharedPreferences.getInstance();
  //   // var a = prefs.getInt('sp') ?? 0;
  //   // var b = prefs.getInt('solve') ?? 0;
  //   // var c = prefs.getInt('reCap') ?? 0;
  //   // var d = prefs.getInt('getRef') ?? 0;
  //   // var e = prefs.getInt('dailyB') ?? 0;
  //   // var f = prefs.getInt('watch1') ?? 0;
  //   // var g = prefs.getInt('watch2') ?? 0;
  //   // var total = a + b + c + d + e + f + g;
  //   // print('this is watchuhiuhi2    $total');

  //   // User? xuser = MyAppState.currentUser;
  //   // total = total + total;
  //   // FireStoreUtils.firestore.collection('users').doc(xuser?.userID).update({
  //   //   'points': total,
  //   // });
  // }
}
