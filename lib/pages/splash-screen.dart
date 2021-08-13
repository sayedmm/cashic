import 'package:carousel_slider/carousel_slider.dart';
import 'package:cashic/firebase/services/helper.dart';
import 'package:cashic/firebase/ui/auth/authScreen.dart';
// import 'package:cashic/firebase/ui/login/loginScreen.dart';
// import 'package:cashic/firebase/ui/signUp/signUpScreen.dart';
// ignore: unused_import
import 'package:cashic/sp-wheel/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPageItem {
  String itemName;
  String path;
  MyPageItem(this.itemName, this.path);
}

class my_page extends StatefulWidget {
  static String id = 'my_page';
  @override
  _my_pageState createState() => _my_pageState();
}

class _my_pageState extends State<my_page> {
  List<MyPageItem> items = [
    MyPageItem("PLAY SOME SIMPLE IN-APP GAMES & GET WIN &GET SOME FREE POINTS",
        'assets/images/game_controller.png'),
    MyPageItem("WATCH ADS AND GET POINTS", 'assets/images/Ad-Break.png'),
    MyPageItem("REPLACE YOUR POINTS WITH MONEY PAYPAL & BITCOIN",
        'assets/images/get_money.png'),
    MyPageItem("ALL USERS DATA SECURE HERE. THE 3rd PARTY ACCESS IS NOT ACCEPT",
        'assets/images/web-security.png'),
  ];
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
      body: CarouselSlider(
          options: CarouselOptions(
            height: double.infinity,
            aspectRatio: 16 / 9,
            viewportFraction: 0.8,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            // onPageChanged: callbackFunction,
            scrollDirection: Axis.horizontal,
          ),
          items: items.map((i) {
            return Builder(builder: (BuildContext context) {
              return Column(
                children: [
                  GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.only(top: 50),
                      child: Image.asset(
                        i.path,
                        fit: BoxFit.fill,
                      ),
                    ),
                    onTap: () {
                      push(context, new AuthScreen());

                      //Navigator.pushNamed(context, AuthScreen.id);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => LogInScreen.id),
                      // );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        i.itemName,
                        style: TextStyle(
                            fontSize: 16,
                            wordSpacing: 5,
                            letterSpacing: 1,
                            color: Colors.pinkAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  // Align(
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(5.0),
                  //         color: Colors.white),
                  //     padding:
                  //         EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  //     //color: Colors.grey,
                  //     margin: EdgeInsets.only(top: 60),
                  //     child: Row(
                  //       children: [
                  //         Row(
                  //           children: [
                  //             Image.asset(
                  //               'assets/images/google-symbol.png',
                  //               width: 40,
                  //               height: 30,
                  //               fit: BoxFit.contain,
                  //             ),
                  //             SizedBox(
                  //               width: 20,
                  //             ),
                  //             Text('GOOGL'),
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // // Align(
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(5.0),
                  //         color: Colors.white),
                  //     padding:
                  //         EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  //     //color: Colors.grey,
                  //     margin: EdgeInsets.only(top: 10),
                  //     child: Row(
                  //       children: [
                  //         Row(
                  //           children: [
                  //             Image.asset(
                  //               'assets/images/facebook.png',
                  //               width: 40,
                  //               height: 30,
                  //               fit: BoxFit.contain,
                  //             ),
                  //             SizedBox(
                  //               width: 20,
                  //             ),
                  //             Text('facebook'),
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              );
            });
          }).toList()),
    );
  }
}
