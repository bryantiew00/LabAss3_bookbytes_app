class User {
  String? userId;
  String? userEmail;
  String? userName;
  String? userPassword;
  String? userRegDate;

  User(
      {this.userId,
      this.userEmail,
      this.userName,
      this.userPassword,
      this.userRegDate});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userEmail = json['user_email'];
    userName = json['user_name'];
    userPassword = json['user_pass'];
    userRegDate = json['user_regdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_email'] = userEmail;
    data['user_name'] = userName;
    data['user_pass'] = userPassword;
    data['user_regdate'] = userRegDate;
    return data;
  }
}