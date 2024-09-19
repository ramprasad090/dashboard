import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/pages/AdminDashboard.dart';
import 'package:dashboard/pages/UserDashboard.dart';
import 'package:dashboard/services/auth.service.dart';
import 'package:dashboard/view_models/base_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/models/user.dart' as _user;

class LoginViewModel extends MyBaseViewModel {
  LoginViewModel(BuildContext context) {
    this.context = context;
  }

  TextEditingController emailTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();
  var emailFocusNode = FocusNode();
  var passwordFocusNode = FocusNode();

  @override
  initialise() {
    // TODO: implement initialise
    return super.initialise();
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
        .hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null; // Validation passed
  }

  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        currentUser = _user.User(
            id: documentSnapshot.id,
            name: documentSnapshot.get('user_name') ?? "",
            email: documentSnapshot.get("email") ?? "",
            role: documentSnapshot.get("role") ?? "user");
        await AuthServices.saveUser(currentUser!);
        await AuthServices.isAuthenticated();
        toastSuccessful("Login Successful");
        Navigator.pushReplacement(
          context!,
          MaterialPageRoute(
            builder: (context) => UserDashboard(),
          ),
        );
      } else {
        toastError('Account does not exist on the database');
      }
    });
  }

  void signIn(String email, String password) async {
    setBusy(true);
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      route();
      setBusy(false);
    } on FirebaseAuthException catch (e) {
      setBusy(false);
      if (e.code == 'user-not-found') {
        toastError('No user found for that email.');
      } else if (e.code == 'invalid-credential') {
        toastError('Wrong password provided for that user.');
      }else{
        toastError('${e.code}');
      }
    }
  }
}
