import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Themes extends StatefulWidget {
  static String id = 'Themes';
  const Themes({Key? key}) : super(key: key);

  @override
  _ThemesState createState() => _ThemesState();
}

class _ThemesState extends State<Themes> {
  int color1 = Color.fromRGBO(245, 246, 250, 5).value;
  late SharedPreferences prefs;
  _ssaveData(int color) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setInt('colos', color);
  }
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
        title: Text('Select Theme'),
      ),
      body: Center(
        child: Column(
          children: [
            RadioListTile(
              //title: Text('Th'),
              value: Colors.purple.value,
              //value: Color.fromRGBO(1, 59, 158, .5).value,
              groupValue: color1,
              onChanged: (int? color) {
                setState(() {
                  color1 = color as int;
                });
                _ssaveData(color as int);
              },
            ),
             RadioListTile(
               value: Colors.white.value,
              //value:  Colors.tealAccent[100]!.value,
              groupValue: color1,
              onChanged: (int? color) {
                setState(() {
                  color1 = color!;
                });
                _ssaveData(color!);
              },
            ),
             RadioListTile(
               value: Colors.pink.value,
              // value: Color.fromRGBO(4, 25, 65, .5).value,
              groupValue: color1,
              onChanged: (int? color) {
                setState(() {
                  color1 = color!;
                });
                _ssaveData(color!);
              },
            ),
          ],
        ),
      ),
    );
  }
}
