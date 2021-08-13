import 'dart:io';

 
class User {
  
  
  String email;

  String name;

  String userID;

  int? points;

  //String profilePictureURL;

  String appIdentifier;

  User(
      {this.email = '',
      this.name = '',
      this.userID = '',
      this.points  = 0,
     // this.profilePictureURL = ''
      })
      : this.appIdentifier = 'Flutter Login Screen ${Platform.operatingSystem}';

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return new User(
        email: parsedJson['email'] ?? '',
        name: parsedJson['name'] ?? '',
        userID: parsedJson['id'] ?? parsedJson['userID'] ?? '',
        points: parsedJson['points'] ?? '',
        //profilePictureURL: parsedJson['profilePictureURL'] ?? ''
        );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': this.email,
      'name': this.name,
      'id': this.userID,
      'points': this.points,
      //'profilePictureURL': this.profilePictureURL,
      'appIdentifier': this.appIdentifier
    };
  }
  
}
