import 'package:cashic/ads-helper.dart';
import 'package:cashic/firebase/model/user.dart';
import 'package:cashic/firebase/services/authenticate.dart';
import 'package:cashic/main.dart';
import 'package:cashic/pages/shared-pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WatchAds extends StatefulWidget {
  static String id = 'WatchAds';
  const WatchAds({Key? key}) : super(key: key);

  @override
  _WatchAdsState createState() => _WatchAdsState();
}

class _WatchAdsState extends State<WatchAds> {
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

  int xpointsAd = 10;
  _savesp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var a = prefs.getInt('z') ?? 0;
    var z = a + xpointsAd;
    SharedPref.saveData('z', z);
    print(' sayed mhmd   $z');

    User? xuser = MyAppState.currentUser;
    FireStoreUtils.firestore.collection('users').doc(xuser?.userID).update({
      'points': z,
    });
  }

  @override
  void initState() {
    super.initState();
    if (!_isRewardedAdReady) {
      _loadRewardedAd();
    } else {
      var snackBar = SnackBar(content: Text('Ad Not Ready Yet !'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
    return Scaffold(
      backgroundColor: Color(color1),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              _rewardedAd.show(
                  onUserEarnedReward: (RewardedAd ad, RewardItem rewardItem) {
                var snackBar = SnackBar(content: Text('You get 10 Points !'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                // Reward the user for watching an ad.
                var reward;
                print('$ad with reward $RewardItem(${reward.amount}}');
              });

              //Navigator.of(context).pop();
            },
            child: Text('Watch Ad Now!!')),
      ),
    );
  }

  seeDialog() {
    Future.delayed(Duration(milliseconds: 5000), () {
      return showDialog(
          context: context,
          builder: (BuiderContext) {
            return AlertDialog(
              title: Text('Congrats !!'),
              content: Text('You have won ${xpointsAd} Points !'),
              actions: <Widget>[
                FlatButton(
                  child: Text('ADD TO WALLET!'),
                  onPressed: () {
                    // send 10 points to database
                    _savesp();
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          });
    });
  }
}
