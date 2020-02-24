import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:record/data/classes/user.dart';
import 'package:record/data/classes/bind.dart';
import 'package:record/common/user_fun.dart';
class AuthModel extends ChangeNotifier{
  User _user;
  User _otherUser;
  Bind _bind;

  Future<String> loadLogged({Map other}) async {
    //如果是已经登陆的用户 获取存储在本地的token验证是否过期
    var _prefs = await SharedPreferences.getInstance();
    String _saveUser = _prefs.getString('user_data');
    if(_saveUser!=null){
      Map _newUser = await UserFun().tokenLogin(json.decode(_saveUser)['token'],other:other);
      if (_newUser['user'] != null) {
        _user = _newUser['user'];
        notifyListeners();
      }
      if (_newUser['otheruser'] != null) {
        _otherUser = _newUser['otheruser'];
        notifyListeners();
      }
      if (_newUser['bind'] != null) {
        SharedPreferences.getInstance().then((prefs) {
          var _bindsave = json.encode(_bind.toJson());
          prefs.setString("bind_data", _bindsave);
        });
        _bind = _newUser['bind'];
        notifyListeners();
      }
      if (_newUser['user']?.token == null || _newUser['user'].token.isEmpty) return _newUser['msg'];
    }
    return '';
  }

  User get user => _user;
  User get otherUser => _otherUser;
  Bind get bind => _bind;

  Future<String> login({
    @required String username,
    @required String password,
    Map other
  }) async {
    String _username = username;
    String _password = password;
    Map _newUser = await UserFun().userLogin(_username,_password,other: other);
    if (_newUser['user'] != null) {
      _user = _newUser['user'];
      notifyListeners();
      SharedPreferences.getInstance().then((prefs) {
        var _save = json.encode(_user.toJson());
        prefs.setString("user_data", _save);
      });
      if (_newUser['otheruser'] != null) {
        _otherUser = _newUser['otheruser'];
        notifyListeners();
      }
      if (_newUser['bind'] != null) {
        SharedPreferences.getInstance().then((prefs) {
          var _bindsave = json.encode(_bind.toJson());
          prefs.setString("bind_data", _bindsave);
        });
        _bind = _newUser['bind'];
        notifyListeners();
      }
    }

    if (_newUser['user']?.token == null || _newUser['user'].token.isEmpty) return _newUser['msg'];
    return '';
  }

  void logout() async{
    var _prefs = await SharedPreferences.getInstance();
    _prefs.remove('user_data');
    _prefs.remove('bind_data');
    _user = null;
    _otherUser = null;
    _bind = null;
    notifyListeners();
  }
}