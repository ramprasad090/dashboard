import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../utils/app_strings.dart';
import '../utils/local_storage.service.dart';


class AuthServices {
  //

  //
  static bool authenticated() {
    return LocalStorageService.prefs!.getBool(AppStrings.authenticated) ??
        false;
  }




  static Future<bool> isAuthenticated() {
    return LocalStorageService.prefs!.setBool(AppStrings.authenticated, true);
  }



  static User? currentUser;
  static Future<User> getCurrentUser({bool force = false}) async {
    if (currentUser == null || force) {
      final userStringObject =
          await LocalStorageService.prefs!.getString(AppStrings.userKey);
      final userObject = json.decode(userStringObject!);
      currentUser = User.fromJson(userObject);
    }
    return currentUser!;
  }



  ///
  static Future<User?> saveUser(User currentUser) async {

    try {
      await LocalStorageService.prefs!.setString(
        AppStrings.userKey,
        json.encode(
          currentUser.toJson(),
        ),
      );
      return currentUser;
    } catch (error) {
      print("Error Saving user ==> $error");
      return null;
    }
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await LocalStorageService.prefs!.clear();
    currentUser = null;
    await LocalStorageService.prefs!.setBool(AppStrings.firstTimeOnApp, false);

  }
}
