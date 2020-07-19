class User {
  String username;
  String password;
  String email;
  String firstName;
  String lastName;

  User(
      {this.username,
      this.password,
      this.email,
      this.firstName,
      this.lastName});

  Map<String, dynamic> toMap() {
    return {
      'username': this.username,
      'email': this.email,
      'password': this.password,
      'first_name': this.firstName,
      'last_name': this.lastName
    };
  }
}
