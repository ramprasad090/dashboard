import 'package:dashboard/utils/custom_button.dart';
import 'package:dashboard/view_models/register.view.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../utils/custom_text_form_field.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegistrationViewModel>.reactive(
        viewModelBuilder: () => RegistrationViewModel(context),
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, double.maxFinite),
              child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 16.h,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor:
                            Theme.of(context).cardColor,
                            radius: 14.r,
                            child: Icon(
                              Icons.arrow_back,
                              size: 14.sp,
                              color:
                              Theme.of(context).iconTheme.color,
                            ),
                          ).onInkTap((){
                            Navigator.pop(context);
                          }),
                          SizedBox(width: 10.w),
                          Text(
                            '${"Register User"}',
                            style: GoogleFonts.inter(
                              color:
                              Theme.of(context).textTheme.titleLarge!.color,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,

                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ).w(context.percentWidth * 75),
                        ],
                      ),
                      SizedBox(
                        height: 19.h,
                      ),
                    ],
                  ).pSymmetric(h: 15.r))
                  .color(

                Theme.of(context).colorScheme.surface,
              ),
            ),
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomButton(
                  title: "Create Account",
                  loading: model.isBusy,
                  onPressed: () {
                    model.signUp(model.emailTEC.text, model.passwordTEC.text,
                        model.role == 1 ? "admin" : "user");
                  },
                )
              ],
            ).pSymmetric(h: 12.r, v: 12.r),
            body: Column(
              children: [
                CustomTextFormField(
                  heading: "Name",
                  keyboardType: TextInputType.name,
                  textEditingController: model.nameTEC,
                  focusNode: model.nameFocusNode,
                  nextFocusNode: model.emailFocusNode,
                ).py8(),
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
                DropdownButton<int>(
                  alignment: Alignment.centerLeft,
                  value: model.role,
                  items: [
                    DropdownMenuItem(value: 1, child: Text('Admin')),
                    DropdownMenuItem(value: 2, child: Text('User')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      model.role = value!;
                    });
                  },
                  hint: Text('Select Role'),
                ),
              ],
            ).pSymmetric(h: 12.r).safeArea(),
          );
        });
  }
}
