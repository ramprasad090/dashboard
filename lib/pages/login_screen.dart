import 'package:dashboard/main.dart';
import 'package:dashboard/pages/registration.dart';
import 'package:dashboard/utils/custom_button.dart';
import 'package:dashboard/utils/custom_text_form_field.dart';
import 'package:dashboard/view_models/login.view.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
        viewModelBuilder: () => LoginViewModel(context),
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, model, child) {
          return Scaffold(
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomButton(
                  title: "Login",
                  loading: model.isBusy,
                  onPressed: () {
                    model.signIn(model.emailTEC.text, model.passwordTEC.text);
                  },
                ),
                SizedBox(
                  height: 4.h,
                ),

                SizedBox(
                  height: 8.h,
                ),
              ],
            ).pSymmetric(h: 12.r, v: 12.r),
            body: Column(
              children: [
                CustomTextFormField(
                  heading: "Email",
                  keyboardType: TextInputType.emailAddress,
                  textEditingController: model.emailTEC,
                  validator: model.emailValidator,
                  focusNode: model.emailFocusNode,
                  nextFocusNode: model.passwordFocusNode,
                ).py8(),
                CustomTextFormField(
                  heading: "Password",
                  obscureText: true,
                  focusNode: model.passwordFocusNode,
                  textEditingController: model.passwordTEC,
                  validator: model.validatePassword,
                ).py8(),
              ],
            ).pSymmetric(h: 12.r).safeArea(),
          );
        });
  }
}
