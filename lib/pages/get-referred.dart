import 'dart:math';

import 'package:cashic/ads-helper.dart';
import 'package:cashic/constants.dart';
import 'package:cashic/firebase/model/user.dart';
import 'package:cashic/firebase/services/authenticate.dart';
import 'package:cashic/main.dart';
import 'package:cashic/pages/shared-pref.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetReferred extends StatefulWidget {
  static String id = 'GetReferred';
  GetReferred({Key? key}) : super(key: key);
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  

  @override
  _GetReferredState createState() => _GetReferredState();
}

class _GetReferredState extends State<GetReferred> {
  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  late BannerAd _bannerAd;

  bool _isBannerAdReady = false;

@override
void initState() {
  //reCAPCODE = getRandomString(10);
    getRefpointsAd = random.nextInt(10);
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

  //var myContraller = new TextEditingController();
   //String codeGenerate = 'hg6kAG54G5';
  User?user = MyAppState.currentUser;

  // void getReferred(String codeRefer) {
  //   codeRefer = myContraller.toString();
  // }

  int getRefpointsAd = 5;

 _savesp() async{
       SharedPreferences prefs = await SharedPreferences.getInstance();
       var a = prefs.getInt('z') ?? 0;
       var z = a + getRefpointsAd;
       SharedPref.saveData('z', z);
        print( ' sayed mhmd   $z');

    User? xuser = MyAppState.currentUser;
    FireStoreUtils.firestore.collection('users').doc(xuser?.userID).update({
      'points': z,
    });
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
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          'GET REFERRED',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.blue[900],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 30, bottom: 20),
                width: MediaQuery.of(context).size.width * .8,
                child: Text(
                  'PUT THE REFER CODE,  GET REFERRED & GET 25 POINTS',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, wordSpacing: 5),
                ),
              ),
              Container(
                //height: 0,
                width: MediaQuery.of(context).size.width * .8,
                margin: EdgeInsets.only(top: 10, bottom: 20),
                padding:
                    EdgeInsets.only(bottom: 30, top: 50, left: 40, right: 40),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white),
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
                       // getReferred(myContraller.toString());
                        //action method code
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
                          'REFER',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              letterSpacing: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'YOUR REFER CODE IS',
                style: TextStyle(fontSize: 10),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                
                '${user!.userID}',
                maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                style: TextStyle(fontSize: 15, color: Colors.redAccent[700]),
              ),
              SizedBox(height: 70,),
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
      ),
    );
  }
  late String reCAPCODE = '';
  Random random = new Random();

  //var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  //Random _rnd = Random();
  // String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
  //     length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  String? txt;

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
                          text: '${getRefpointsAd}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20,
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
                title: Text('InCorrect !!', style: TextStyle(color: Colors.red),),
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
  

}
