import 'package:maids_project/models/LoginModel/LoginModel.dart';

class UserData
{
  int? id;
  String? username;
  String? email;
  String? firstName;
  String? lastName;

  String? gender;
  String? image;

  UserData.fromJson(Map<String,dynamic>json)
  {
    id= json['id'];
    username = json['username'];
    email = json['email'];

    firstName = json['firstName'];
    lastName = json['lastName'];
    gender = json['gender'];
    image = json['image'];
  }

  UserData.fromLoginModel(LoginModel model)
  {
    id= model.id;
    username = model.username;
    email = model.email;

    firstName = model.firstName;
    lastName = model.lastName;
    gender = model.gender;
    image = model.image;
  }

}