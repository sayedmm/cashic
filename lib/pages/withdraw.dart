// ignore: unused_import

import 'package:cashic/firebase/model/user.dart';
import 'package:cashic/firebase/services/authenticate.dart';
import 'package:cashic/firebase/ui/login/loginScreen.dart';
import 'package:cashic/main.dart';
import 'package:cashic/pages/home.dart';
import 'package:cashic/pages/shared-pref.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:url_launcher/url_launcher.dart';

class Withdraw extends StatefulWidget {
  static String id = 'Withdraw'; //to nivagate to class
  final int points = 0;
  Withdraw({Key? key}) : super(key: key);

  @override
  _WithdrawState createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
  GlobalKey<FormState> globalKey = new GlobalKey();

  User? user = MyAppState.currentUser;
  int sNum = 0;
  var textController1 = new TextEditingController();
  var textController2 =
      new TextEditingController(); //save text value from textFromField
  final primaryColorss = const Color.fromRGBO(242, 253, 241, 1);

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
        title: Text(
          'Withdraw',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Center(
          // layout to center
          child: Column(
            //layout
            children: [
              Container(
                  margin: EdgeInsets.only(top: 30),
                  padding: EdgeInsets.only(top: 30),
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
                  height: 140,
                  width: MediaQuery.of(context).size.width * .8,
                  child: Column(
                    children: [
                      Text(
                        '${xuser!.points}', // to show points
                        style: TextStyle(
                            fontSize: 45,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        'TOTAL POINTS IS',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  )),
              SizedBox(
                height: 30, //add spaces between items
              ),
              Container(
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
                padding: EdgeInsets.symmetric(vertical: 20),
                width: MediaQuery.of(context).size.width * .8,
                child: Column(
                  children: [
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Radio(
                    //       value: 'Paypal Address',
                    //       groupValue: txt,
                    //       onChanged: (value) {
                    //         setState(() {
                    //           txt = value.toString();
                    //           _paypal();
                    //           //action after select radio
                    //         });
                    //       },
                    //       activeColor:
                    //           Colors.black, // color radio after selected
                    //     ),
                    //     Text('paypal'),
                    //     SizedBox(
                    //       width: 50,
                    //     ),
                    //     Radio(
                    //       value: 'BitCoin Address',
                    //       groupValue: txt,
                    //       onChanged: (value) {
                    //         setState(() {
                    //           txt = value.toString();
                    //           _bitcoin();
                    //           // action
                    //         });
                    //       },
                    //       activeColor: Colors.black,
                    //     ),
                    //     Text('bitcoin'),
                    //   ],
                    // ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 30, left: 35, right: 35),
                      child: Form(
                        key: globalKey,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          onSaved: (v) {
                            // sNum = v as int;
                            sNum = int.parse(v!);
                          },
                          // onSaved: (val) => sNum = val as int,
                          validator: (c) {
                            if (c!.isEmpty) {
                              return 'Please Add Your Points';
                            }
                          },
                          controller: textController1,
                          style: TextStyle(
                            decorationColor: Colors.white,
                          ),
                          autofocus: false,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            hintText: 'Minimum 5,000 points',
                            hintStyle: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 35),
                    //   child: TextFormField(
                    //      onSaved: (txt) {
                    //         // sNum = int.parse(txt!);
                    //       },
                    //       validator: (txt) {
                    //         if (txt!.isEmpty) {
                    //           return 'Please Add Your Points';
                    //         }
                    //       },
                    //     keyboardType: TextInputType.number,
                    //     controller: textController2,
                    //     style: TextStyle(
                    //       decorationColor: Colors.white,
                    //     ),
                    //     autofocus: false,
                    //     onSaved: (value) {
                    //       sNum = value as int;
                    //     },
                    //     decoration: InputDecoration(
                    //       contentPadding:
                    //           EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    //       hintText: 'Minimum 5,000 points',
                    //       hintStyle: TextStyle(fontSize: 12),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey[700], // background
                        onPrimary: Colors.yellow, // foreground
                      ),
                      onPressed: () {
                        print('Points BBBBB $sNum');
                        _setAction();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 18),
                        child: Text(
                          'REDEEM',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              letterSpacing: 7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width * .8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Text(
                  'THE MINIMUN WITHDRAW AMOUNT IS 5,000 = 5\$ AFTER REQUESTING'
                  ' FOR REDEEM WAIT FOR SOME DAYS.'
                  '5,000 POINTS =5\$ --- 10.000 POINTS = 10\$ --- 20,000 POINTS = 20\$',
                  style: TextStyle(fontSize: 12, color: Colors.red),
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  User? xuser = MyAppState.currentUser;

  // _SubmitAddress() {
  //   if (widget.globalKey.currentState?.validate() ?? false) {
  //     widget.globalKey.currentState?.save();
  //     if (sNum >= 5000 || sNum >= 10000 || sNum >= 1500 || sNum >= 20000) {
  //       if (txt == '') {
  //         if (txt == 'Paypal Address') {
  //           _paypal();
  //         } else {
  //           //error with your paypal address
  //           var snackBar = SnackBar(
  //               content: Text('error with your paypal address try agian !'));
  //           ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //         }
  //         if (txt == 'BitCoin Address') {
  //           _bitcoin();
  //         } else {
  //           //error with your paypal address
  //           var snackBar = SnackBar(
  //               content: Text('error with your bitcoin address try agian !'));
  //           ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //         }
  //       } else {
  //         //// please choose type your address
  //         var snackBar =
  //             SnackBar(content: Text('please choose type your address !'));
  //         ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //       }
  //       if (sNum < 5000) {
  //         /// you have less then 5000
  //         var snackBar = SnackBar(content: Text('you have less then 5000 !'));
  //         ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //       } else {
  //         //error with your insert
  //         var snackBar = SnackBar(content: Text('error with your insert !'));
  //         ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //       }
  //     }
  //   }
  // }

  _setAction() async {
    if (globalKey.currentState?.validate() ?? false) {
      globalKey.currentState!.save();

      if (xuser!.points! < 5000) {
        print('Points AAAA ${xuser!.points!}');
        var snackBar = SnackBar(content: Text('Your Points Less then 5,000 !'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        if (xuser!.points! >= 5000 && sNum < 5000) {
          print('Points BBBBB $sNum');
          var snackBar =
              SnackBar(content: Text('Your Entered Less then 5,000 !'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          switch (sNum) {
            case 5000:
              print('Points cccccc $sNum');
              _seeDialog();
              break;
            case 10000:
              _seeDialog();
              break;
            case 15000:
              _seeDialog();
              break;
            case 20000:
              _seeDialog();
              ;
              break;
            case 25000:
              _seeDialog();
              ;
              break;
            default:
              print('Points AAAA ${xuser!.points!}');
              print('Points WWWWWWW $sNum');
              var snackBar = SnackBar(
                  content: Text(
                      'Your Entered Should Be 5,000, 10000, 15000,.... !'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }
      }
    }
  }

  _seeDialog() {
    return showDialog(
        context: context,
        builder: (BuiderContext) {
          return AlertDialog(
            title: Text('Congrats !!'),
            content: Text(
                'Add Your Paypal or Bitcoin address to transfer money to you '),
            actions: <Widget>[
              FlatButton(
                child: Text('Get Money!'),
                onPressed: () {
                  _savesp();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  _savesp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var a = prefs.getInt('z') ?? 0;
    var z = a - sNum;
    if (z < 0) return;
    SharedPref.saveData('z', z);
    print(' sayed mhmd   $z');

    User? xuser = MyAppState.currentUser;
    FireStoreUtils.firestore.collection('users').doc(xuser?.userID).update({
      'points': z,
    });

    //    dynamic result =  await FireStoreUtils.updateCurrentUser(xuser!);
    // MyAppState.currentUser = result;

    //  await SharedPref.removeData('z');

    final url = Uri.encodeFull(
        'mailto:cashicpayments@gmail.com?subject=Get Money&body=Your id is ${user!.userID} Your Paypal or Bitcoin Address:');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
    Navigator.of(context)
        .pushNamed(LoginScreen.id)
        .then((value) => setState(() {}));
  }

  // _dd()async{
  //   dynamic result = await FireStoreUtils.updateCurrentUser(xuser!);
  //   MyAppState.currentUser = result;
  // }
}
