class LoginModel
{
  int? id;
  String? username;
  String? email;
  String? firstName;
  String? lastName;

  String? gender;
  String? image;
  String? token;
  String? refreshToken;

  LoginModel.fromJson(Map<String,dynamic> json)
  {
    id= json['id'];
    username = json['username'];
    email = json['email'];

    firstName = json['firstName'];
    lastName = json['lastName'];
    gender = json['gender'];
    image = json['image'];

    token = json['accessToken'];
    refreshToken = json['refreshToken'];
  }

}