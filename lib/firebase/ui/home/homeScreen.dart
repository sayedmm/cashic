import 'dart:math';

import 'package:cashic/ads-helper.dart';
import 'package:cashic/firebase/model/user.dart';
import 'package:cashic/firebase/services/authenticate.dart';
import 'package:cashic/firebase/services/helper.dart';
import 'package:cashic/firebase/ui/auth/authScreen.dart';
import 'package:cashic/main.dart';
import 'package:cashic/pages/home.dart';
import 'package:cashic/pages/shared-pref.dart';
import 'package:cashic/pages/withdraw.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  late User user;

  late RewardedAd _rewardedAd;
  bool _isRewardedAdReady = false;
  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          this._rewardedAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                _isRewardedAdReady = false;
              });
              _loadRewardedAd();
            },
          );

          setState(() {
            _isRewardedAdReady = true;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a rewarded ad: ${err.message}');
          setState(() {
            _isRewardedAdReady = false;
          });
        },
      ),
    );
  }
  int adReward = 10;

   _savesp() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
       var a = prefs.getInt('z') ?? 0;
       var z = a + adReward;
       SharedPref.saveData('z', z);
        print( ' sayed mhmd   $z');
    User? xuser = MyAppState.currentUser;
    FireStoreUtils.firestore.collection('users').doc(xuser?.userID).update({
      'points': z,
    });
  }
  @override
  void initState() {
    setState(() {
      user = widget.user;
    });
    super.initState();
    if (!_isRewardedAdReady) {
      _loadRewardedAd();
    }else{
       var snackBar = SnackBar(content: Text('Ad Not Ready Yet'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
  _back() async {
    await auth.FirebaseAuth.instance.signOut();
    //MyAppState.currentUser = null;
    pushAndRemoveUntil(context, Home(), false);
  }

   @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _back(),
      child: Scaffold(
        backgroundColor: Colors.tealAccent[100],
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await auth.FirebaseAuth.instance.signOut();
            MyAppState.currentUser = null;
            pushAndRemoveUntil(context, AuthScreen(), false);
          },
          backgroundColor: Colors.blue,
          child: Text('Out'),
        ),
        appBar: AppBar(
          title: Text(
            'My Acount',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //displayCircleImage(user.profilePictureURL, 80, false),
              Container(
                width: MediaQuery.of(context).size.width * .8,
                padding: EdgeInsets.all(20),
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
                    Container(
                      width: 100,
                      height: 100,
                      child: CircleAvatar(
                        child: Image.asset('assets/images/Person.png'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        user.name,
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        user.email,
                        style: TextStyle(fontSize: 18, fontFamily: 'Comfortaa'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Minimum withdrawal is 5,000 points (5\$)',
                      style: TextStyle(fontSize: 12, 
                      color: Colors.green[700]
                      ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 10),
                child: Text(
                  user.points.toString(),
                  style: TextStyle(
                      fontSize: 35,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 30,
                ),
                child: Text('Total Points points'.toUpperCase(),
                style: TextStyle(color: Colors.green[700]),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.only(top: 9),
                      width: 130,
                      height: 60,
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
                      child: GestureDetector(
                        onTap: () {
                          _onPressAd();
                        },
                        child: Text(
                          'Watch Ads And Get Points',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Withdraw.id);
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 9),
                      width: 130,
                      height: 60,
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
                        'Replace Your Points',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

   _onPressAd() {
    return showDialog(
        context: context,
        builder: (BuiderContext) {
          return AlertDialog(
            title: Text('Need a Points?'),
            content: Text('Watch an Ad to get a Points!'),
            actions: <Widget>[
              FlatButton(
                child: Text('cancel'.toUpperCase()),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('ok'.toUpperCase()),
                onPressed: () {
                  _rewardedAd.show(onUserEarnedReward:
                      (RewardedAd ad, RewardItem rewardItem) {
                        var snackBar = SnackBar(content: Text('You get 10 Points !'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    // Reward the user for watching an ad.
                    var reward;
                    print(
                        '$ad with reward $RewardItem(${reward.amount}, ${reward.type}');
                        
                  });
                  _savesp();
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        });
  }
  @override
  void dispose() {
    _rewardedAd.dispose();
    super.dispose();
  }
}
