import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  String id = "", name = "", role = "",email = "";

  UserSession({this.id, this.name, this.email, this.role});

  bool get validate{
    return this.id.isNotEmpty || this.role.isNotEmpty;
  }

  UserSession.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    role = json['role'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['role'] = this.role;
    data['email'] = this.email;
    return data;
  }
}

class SessionManager {

  Future<UserSession> save(UserSession userSession) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("session", jsonEncode(userSession.toJson()));
    log("SAVE SESSION : ${userSession}");
    return userSession;
  }

  Future<UserSession> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String session = prefs.getString("session");
    log("LOAD SESSION : ${session}");
    return UserSession.fromJson(jsonDecode(session));
  }

  clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("session");
  }
}