import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/pages/login_screen.dart';
import 'package:dashboard/view_models/base_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationViewModel extends MyBaseViewModel {
  RegistrationViewModel(BuildContext context) {
    this.context = context;
  }
  TextEditingController emailTEC = TextEditingController();
  TextEditingController nameTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();
  var emailFocusNode = FocusNode();
  var passwordFocusNode = FocusNode();
  var nameFocusNode = FocusNode();
  int? role = 1;
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

  //For Password  validation
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    // Check for minimum length of 8
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    // Check for at least 1 capital letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least 1 capital letter';
    }

    // Check for at least 1 symbol
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least 1 symbol';
    }

    return null; // Password is valid
  }

  final _auth = FirebaseAuth.instance;
  void signUp(String email, String password, String role) async {
    setBusy(true);
    if (emailTEC.text.isEmpty ||
        passwordTEC.text.isEmpty ||
        nameTEC.text.isEmpty) {
      toastError("Please fill the above details");
      setBusy(false);
      return;
    }
    if (emailValidator(emailTEC.text) != null) {
      toastError(emailValidator(emailTEC.text).toString());
      setBusy(false);
      return;
    }
    if (validatePassword(passwordTEC.text) != null) {
      toastError(validatePassword(passwordTEC.text).toString());
      setBusy(false);
      return;
    }

    setBusy(true);
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) => {postDetailsToFirestore(email, role)})
        .catchError((e) {
      toastError(e.toString());
      setBusy(false);
    });
    setBusy(false);
  }

  postDetailsToFirestore(String email, String role) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    ref
        .doc(user!.uid)
        .set({'email': emailTEC.text, 'role': role, 'user_name': nameTEC.text});
    toastSuccessful("Account Created Successfully");
    Navigator.pop(context!);
  }
}
