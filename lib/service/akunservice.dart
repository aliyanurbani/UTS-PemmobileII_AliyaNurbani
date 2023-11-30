import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/akun.dart';
import '../page/auth/loginpage.dart';

class AkunService {
  final String sessionKey = 'loggedIn';
  final String key = 'akun';

  Future<bool> saveAkun(Akun akun, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String akunData = prefs.getString(key) ?? '';
    List<Map<String, dynamic>> akunList = [];

    if (akunData.isNotEmpty) {
      akunList =
          (jsonDecode(akunData) as List<dynamic>).cast<Map<String, dynamic>>();
    }

    if (akunList.any((existingAkun) => existingAkun['email'] == akun.email)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Email sudah terdaftar.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return false;
    }

    Map<String, dynamic> userData = {
      'id': akun.id,
      'nama': akun.nama,
      'email': akun.email,
      'password': akun.password,
    };
    akunList.add(userData);

    prefs.setString(key, json.encode(akunList));

    return true;
  }

  Future<List<Akun>> getAkunList() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> akunStrings = prefs.getStringList(key) ?? [];
    return akunStrings.map((akunString) {
      final Map<String, dynamic> akunMap = jsonDecode(akunString);
      return Akun.fromJson(akunMap);
    }).toList();
  }

  Future<Akun?> getAkunByUsername(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String akunData = prefs.getString(key) ?? '';
    List<Map<String, dynamic>> akunList = [];

    if (akunData.isNotEmpty) {
      akunList =
          (jsonDecode(akunData) as List<dynamic>).cast<Map<String, dynamic>>();
    }

    Map<String, dynamic>? userData;
    for (var existingAkun in akunList) {
      if (existingAkun['email'] == email) {
        userData = existingAkun;
        break;
      }
    }

    if (userData != null) {
      return Akun.fromJson(userData);
    }

    return null;
  }

  Future<void> saveSession(Akun akun) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('sessionUserId', akun.id);
    prefs.setString('sessionName', akun.nama);
    prefs.setString('sessionEmail', akun.email);
  }

  Future<Map<String, dynamic>?> getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('sessionUserId');
    String? username = prefs.getString('sessionName');
    String? email = prefs.getString('sessionEmail');

    if (userId != null && username != null && email != null) {
      return {'userId': userId, 'username': username, 'email': email};
    } else {
      return null;
    }
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('sessionUserId');
    await prefs.remove('sessionName');
    await prefs.remove('sessionEmail');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
