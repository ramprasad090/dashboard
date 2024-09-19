import 'package:dashboard/models/user.dart';
import 'package:dashboard/services/auth.service.dart';
import 'package:dashboard/view_models/base_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';

class UserDashboardViewModel extends MyBaseViewModel{
  UserDashboardViewModel(BuildContext context){
    this.context = context;
  }

  @override
  initialise() async {

    // TODO: implement initialise
    return super.initialise();
  }
}