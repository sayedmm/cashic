import 'package:cashic/ads-helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoTaskes extends StatefulWidget {
  static String id = 'VideoTaskes';
  const VideoTaskes({Key? key}) : super(key: key);

  @override
  _VideoTaskesState createState() => _VideoTaskesState();
}

class _VideoTaskesState extends State<VideoTaskes> {
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (!_isInterstitialAdReady) {
      _loadInterstitialAd();
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
              if (_isInterstitialAdReady) {
                _interstitialAd?.show();
                Navigator.of(context).pop(false);
              }
              ;
            },
            child: Text('Watch Ad Now!!')),
      ),
    );
  }
}
