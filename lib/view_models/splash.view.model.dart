import 'dart:developer';

import 'package:dashboard/models/user.dart';
import 'package:dashboard/pages/login_screen.dart';
import 'package:dashboard/view_models/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../pages/AdminDashboard.dart';
import '../pages/UserDashboard.dart';
import '../services/auth.service.dart';

class SplashViewModel extends MyBaseViewModel {
  SplashViewModel(BuildContext context) {
    this.context = context;
  }

  @override
  initialise() {
    loadApp();
    super.initialise();
  }

  loadApp() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!AuthServices.authenticated()) {
        context!.nextPage(LoginScreen());
      } else {
        User user = await AuthServices.getCurrentUser(force: true);
        Navigator.pushReplacement(
          context!,
          MaterialPageRoute(
            builder: (context) => UserDashboard(),
          ),
        );
      }
    });
    WidgetsFlutterBinding.ensureInitialized();
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
}
