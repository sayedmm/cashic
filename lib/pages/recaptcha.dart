import 'package:cashic/ads-helper.dart';
import 'package:cashic/constants.dart';
import 'package:cashic/firebase/model/user.dart';
import 'package:cashic/firebase/services/authenticate.dart';
import 'package:cashic/main.dart';
import 'package:cashic/pages/shared-pref.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class Recaptcha extends StatefulWidget {
  static String id = 'Recaptcha';
  Recaptcha({Key? key}) : super(key: key);
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  @override
  _RecaptchaState createState() => _RecaptchaState();
}

String reCAPCODE = 'h8HKcq65';

void getCpCode() {
  // connect to database to get reCAPCODE
  //add reCAPCODE to var reCAPCODE to showing in app
}
void getPoints() {
  // add 10 points to balance in database
}

class _RecaptchaState extends State<Recaptcha> {
  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  // late int x;
  late String reCAPCODE = '';
  Random random = new Random();

  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  String? txt;

   int? recpoints;
 _savesp() async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
       var a = prefs.getInt('z') ?? 0;
       var z = a + recpoints!;
       SharedPref.saveData('z', z);
        print( ' sayed mhmd   $z');

    User? xuser = MyAppState.currentUser;
    FireStoreUtils.firestore.collection('users').doc(xuser?.userID).update({
      'points': z,
    });
    }
  _submitRecap() {
    if (widget.globalKey.currentState?.validate() ?? false) {
      widget.globalKey.currentState!.save();
      if (reCAPCODE == txt.toString()) {
        return showDialog(
            context: context,
            builder: (BuiderContext) {
              return AlertDialog(
                backgroundColor: Colors.purple,
                title: Text('Congrats !!'),
                content: RichText(
                  text: TextSpan(
                    text: 'Your CAPTCHA CODE Is Correct ! You Gets  ',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    //style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                          text: '${recpoints}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.blue)),
                      TextSpan(text: '  Points!'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                      child: Text('ADD TO WALLET!'),
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
                title: Text(
                  'InCorrect !!',
                  style: TextStyle(color: Colors.red),
                ),
                content: Text('Your CAPTCHA CODE Not Correct ! '),
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
    reCAPCODE = getRandomString(10);
    recpoints = random.nextInt(10);
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
        elevation: 0.0,
        title: Text(
          'reCAPTCHA',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.blue[900],
          ),
        ),
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
              ' YOUR CAPTCHA CODE',
              style: TextStyle(fontSize: 10, wordSpacing: 5),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * .6,
              margin: EdgeInsets.only(top: 5, bottom: 10),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
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
                '$reCAPCODE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green[800],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                          onSaved: (val) {
                            txt = val;
                          },
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Please Add your Refer Code';
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
                      setState(() {
                        _submitRecap();
                        print(reCAPCODE);
                        print(txt);
                      });
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
                '[ NOTE: TYPE THE CORRECT CODE TO GET WIN & GET SOME FREE POINTS ]',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.red),
              ),
            ),
            SizedBox(
              height: 40,
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
