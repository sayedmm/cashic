import 'package:cashic/ads-helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAccount extends StatefulWidget {
  static String id = 'MyAccount';
  const MyAccount({Key? key}) : super(key: key);

  void initState() {
    // put it here
  }
  @override
  _MyAccountState createState() => _MyAccountState();
}

void showMyPoints(){
  // connect to database and show my balance 
}

class _MyAccountState extends State<MyAccount> {

  late RewardedAd _rewardedAd;

  bool _isRewardedAdReady = false;

  // TODO: Implement _loadRewardedAd()
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
        title: Text('Welcome'),
      ),
     // _buildFloatingActionButton(),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: 10, bottom: 20),
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.white
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
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(
                  'EXAMPLE@gmail.com',
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
              ),
              Text(
                '[ TOTAL POINTS: ++++ ]',
                style: TextStyle(fontSize: 12, color: Colors.greenAccent[700]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  'minimum withdrawl is 5,000 points (5\$)',
                  style: TextStyle(fontSize: 12,),
                ),
              )
            ],
          ),
        ),
      ),
     // _buildFloatingActionButton();
    );
  }
  Widget? _buildFloatingActionButton() {
  // TODO: Return a FloatingActionButton if a Rewarded Ad is available
  //return (!QuizManager.instance.isHintUsed && _isRewardedAdReady)
      FloatingActionButton.extended(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Need a hint?'),
                  content: Text('Watch an Ad to get a hint!'),
                  actions: [
                    TextButton(
                      child: Text('cancel'.toUpperCase()),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: Text('ok'.toUpperCase()),
                      onPressed: () {
                        Navigator.pop(context);
                        //_rewardedAd?.show();
                      },
                    ),
                  ],
                );
              },
            );
          },
          label: Text('Hint'),
          icon: Icon(Icons.card_giftcard),
        );
       null;}
}
