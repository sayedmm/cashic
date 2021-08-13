
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacyAndPolicy extends StatefulWidget {
  static String id = 'PrivacyAndPolicy';
  const PrivacyAndPolicy({ Key? key }) : super(key: key);

  @override
  _PrivacyAndPolicyState createState() => _PrivacyAndPolicyState();
}

class _PrivacyAndPolicyState extends State<PrivacyAndPolicy> {
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
      appBar: AppBar(title: Text('PrivacyAndPolicy'),),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 8,
          child: Text('PrivacyAndPolicy'),
        ),
      ),
    );
  }
}