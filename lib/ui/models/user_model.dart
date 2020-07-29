import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class User {
  String email;
  String accessToken;
  bool isAdmin;

  User({this.email, this.accessToken, this.isAdmin});

  Map<String, dynamic> toMap() {
    return {
      'email': this.email,
      'access_token': this.accessToken,
      'isAdmin': this.isAdmin
    };
  }
}
