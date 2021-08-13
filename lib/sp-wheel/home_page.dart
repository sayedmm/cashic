import 'dart:async';
import 'dart:math';

import 'package:cashic/ads-helper.dart';
import 'package:cashic/firebase/model/user.dart';
import 'package:cashic/firebase/services/authenticate.dart';
import 'package:cashic/main.dart';
import 'package:cashic/pages/shared-pref.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'board_view.dart';
import 'model.dart';

class HomePage extends StatefulWidget {
  static String id = 'HomePage';
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>with SingleTickerProviderStateMixin {
  int? sp;
  int? sp2;
  late User _user ;
   

  double _angle = 0;
  double _current = 0;
  late AnimationController _ctrl;
  late Animation _ani;
  List<Luck> _items = [
    Luck(1, Colors.blue),
    Luck(2, Colors.blueGrey),
    Luck(3, Colors.brown),
    Luck(4, Colors.green),
    Luck(5, Colors.grey),
    Luck(6, Colors.orange),
    Luck(7, Colors.pink),
    Luck(8, Colors.purple),
    Luck(9, Colors.yellow),
    Luck(10, Colors.red),
    Luck(11, Colors.teal),
    Luck(12, Colors.lime),
  ];
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
    var _duration = Duration(milliseconds: 5000);
    _ctrl = AnimationController(vsync: this, duration: _duration);
    _ani = CurvedAnimation(parent: _ctrl, curve: Curves.fastLinearToSlowEaseIn);
  }

  _savesp() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
       var a = prefs.getInt('z') ?? 0;
       var z = a + sp!;
       SharedPref.saveData('z', z);
        print( ' sayed mhmd   $z');

    User? xuser = MyAppState.currentUser;
    FireStoreUtils.firestore.collection('users').doc(xuser?.userID).update({
      'points': z,
    });
    
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Fortune Wheel'),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.green, Colors.blue.withOpacity(0.2)])),
        child: AnimatedBuilder(
            animation: _ani,
            builder: (context, child) {
              final _value = _ani.value;
              final _angle = _value * this._angle;
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  BoardView(items: _items, current: _current, angle: _angle),
                  _buildGo(),
                  _buildResult(_value),
                ],
              );
            }),
      ),
    );
  }

  _buildGo() {
    return Material(
      color: Colors.white,
      shape: CircleBorder(),
      child: InkWell(
        customBorder: CircleBorder(),
        child: Container(
          alignment: Alignment.center,
          height: 72,
          width: 72,
          child: Text(
            "GO",
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
        ),
        onTap: _animation,
      ),
    );
  }

  _animation() {
    if (!_ctrl.isAnimating) {
      var _random = Random().nextDouble();
      _angle = 20 + Random().nextInt(5) + _random;
      _ctrl.forward(from: 0.0).then((_) {
        _current = (_current + _random);
        _current = _current - _current ~/ 1;
        _ctrl.reset();
      });
    }
    seeDialog();
  }

  int _calIndex(value) {
    var _base = (2 * pi / _items.length / 2) / (2 * pi);
    return (((_base + value) % 1) * _items.length).floor();
  }

  _buildResult(_value) {
    var _index = _calIndex(_value * _angle + _current);
     sp = _items[_index].list;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Text(
          sp.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
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
            content: Text('You have won ${sp} Points. Play again to get more free Points'),
            actions: <Widget>[
              FlatButton(
                child: Text('ADD TO WALLET!'),
                onPressed: () {
                  _savesp();
                  if (_isInterstitialAdReady) {
                    _interstitialAd?.show();
                    Navigator.of(context).pop(false);
                  } else {
                  }
                },
              ),
            ],
          );
        }
       );
       });
    }
  }
  
  