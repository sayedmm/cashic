
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {


   static saveData(String key, int value) async{
 SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.setInt(key, value);
     
  }

  static getData(String key) async{
 SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.getInt(key) ?? 0;
  }

  static removeData(String key) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
    
  }

// static saveData<T>(String key, T value) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     switch (T) {
//       case String:
//         prefs.setString(key, value as String);
//         break;
//       case int:
//         prefs.setInt(key, value as int);
//         break;
//       case bool:
//         prefs.setBool(key, value as bool);
//         break;
//       case double:
//         prefs.setDouble(key, value as double);
//         break;
//     }

// }
//      /// إقرأ البيانات
//   static Future<T> getData<T>(String key) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     T res;
//     switch (T) {
//       case String:
//         res = prefs.getString(key) as T;
//         break;
//       case int:
//         res = prefs.getInt(key) as T;
//         break;
//       case bool:
//         res = prefs.getBool(key) as T;
//         break;
//       case double:
//         res = prefs.getDouble(key) as T;
//         break;
//     }
//     return res;
 // }
  
  
  // late SharedPreferences pref;
  //   saveData() async{
  //   pref = await  SharedPreferences.getInstance();
  //   pref.setInt(key, value)
  // }

  // getData() async {
  //   pref =  await SharedPreferences.getInstance();
  // }

}