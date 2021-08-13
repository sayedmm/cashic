import 'dart:core';

import 'package:cashic/ads-helper.dart';
import 'package:cashic/constants.dart';
import 'package:cashic/firebase/model/user.dart';
import 'package:cashic/firebase/services/authenticate.dart';
import 'package:cashic/main.dart';
import 'package:cashic/pages/recaptcha.dart';
import 'package:cashic/pages/shared-pref.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class SolveMath extends StatefulWidget {
  static String id = 'SolveMath';
   SolveMath({Key? key}) : super(key: key);
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  
  @override
  _SolveMathState createState() => _SolveMathState();
}

class _SolveMathState extends State<SolveMath> {

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  int val1 = 0;
  int val2 = 0;
  late String mark;

  String? txt;
  int sNum = 0;
  
 int solvepointsAd = 5;
  _savesp()async{
       SharedPreferences prefs = await SharedPreferences.getInstance();
       var a = prefs.getInt('z') ?? 0;
       var z = a + solvepointsAd;
       SharedPref.saveData('z', z);
        print( ' sayed mhmd   $z');

    User? xuser = MyAppState.currentUser;
    FireStoreUtils.firestore.collection('users').doc(xuser?.userID).update({
      'points': z,
    });
    }
  _sumVal() {
    if (widget.globalKey.currentState?.validate() ?? false) {
      widget.globalKey.currentState!.save();
      if (val1 + val2 == sNum) {
        return showDialog(
            context: context,
            builder: (BuiderContext) {
              return AlertDialog(
                backgroundColor: Colors.purple,
                title: Text('Correct !!'),
                content: RichText(
                  text: TextSpan(
                    text: 'Your Answer Is Correct ! You Gets  ',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    children: <TextSpan>[
                      TextSpan(
                          text: '${solvepointsAd}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20,
                              color: Colors.blue)),
                      TextSpan(text: '  Points!'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                      child: Text('Try Again'),
                      onPressed: () {
                         _savesp();
                        Navigator.of(context).pop(false);
                      }),
                ],
              );
            });
      } else {
        return showDialog(
            context: context,
            builder: (BuiderContext) {
              return AlertDialog(
                 backgroundColor: Colors.purple,
                title: Text('InCorrect !!'),
                content: Text('Your Answer Not Correct ! '),
                actions: <Widget>[
                  FlatButton(
                      child: Text('Try Again'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      }),
                ],
              );
            }); 
      }
    }
  }

  @override
  void initState() {
    Random random = new Random();
    val1 = random.nextInt(10000);
    solvepointsAd = random.nextInt(10);

    Random random2 = new Random();
    val2 = random2.nextInt(10000);
    mark = '+';
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
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
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
    return Scaffold(
      backgroundColor: Color(color1),
      appBar: AppBar(
        title: Text(
          'Solve Math',
          style: TextStyle(
              fontSize: 14,
              color: Colors.blue[900],
              fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(right: 20),
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                ' [TOTAL : 10/10 ]',
                style: TextStyle(fontSize: 10, wordSpacing: 5),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'SOLVE THIS PROBLEM',
              style: TextStyle(fontSize: 10, wordSpacing: 5),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 9),
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Text(
                    '$val1',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent[700]),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  '  $mark  ',
                  style: TextStyle(fontSize: 20, color: Colors.redAccent),
                ),
                Container(
                  padding: EdgeInsets.only(top: 9),
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Text(
                    '$val2',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent[700]),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Container(
              //height: 0,
              width: MediaQuery.of(context).size.width * .8,
              margin: EdgeInsets.only(top: 30, bottom: 20),
              padding:
                  EdgeInsets.only(bottom: 30, top: 50, left: 40, right: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Form(
                      key: widget.globalKey,
                      child: TextFormField(
                          keyboardType: TextInputType.number,
                          onSaved: (txt) {
                            sNum = txt as int;
                          },
                          validator: (txt) {
                            if (txt!.isEmpty) {
                              return 'Please Add Answer';
                            }
                          },
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              fillColor: Colors.white,
                              hintText: 'Refer Code',
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(COLOR_PRIMARY),
                                  width: 2.0,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              )))),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.purple[800], // background
                      onPrimary: Colors.yellow, // foreground
                    ),
                    onPressed: () {
                      _sumVal();
                      print(sNum);
                      print(solvepointsAd);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      child: Text(
                        'SUBMIT',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            letterSpacing: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * .8,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(5.0),
              //   color: Colors.white
              // ),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Text(
                '[ NOTE: TYPE THE CORRECT ANSWER TO GET WIN & GET SOME FREE POINTS ]',
                style: TextStyle(fontSize: 12, color: Colors.red),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            if (_isBannerAdReady)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: _bannerAd.size.width.toDouble(),
                  height: 150,
                  child: AdWidget(ad: _bannerAd),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
}
