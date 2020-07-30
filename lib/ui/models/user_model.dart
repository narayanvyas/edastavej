import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class User {
  String firstName;
  String lastName;
  String email;
  String phone;
  String aadharNumber;
  String panNumber;
  String role;
  bool status;
  String accessToken;
  bool isAdmin;

  User(
      {this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.aadharNumber,
      this.panNumber,
      this.role,
      this.status,
      this.accessToken,
      this.isAdmin});

  Map<String, dynamic> toMap() {
    return {
      'email': this.email,
      'access_token': this.accessToken,
      'isAdmin': this.isAdmin
    };
  }
}
