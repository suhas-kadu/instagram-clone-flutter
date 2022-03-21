import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/models/user.dart' as model;
import 'package:instagram_clone_flutter/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
   model.User? _user;
  final AuthMethods _authMethods = AuthMethods();

  model.User get getUser =>  _user!;
  

  Future<void> refreshUser() async {
    model.User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
