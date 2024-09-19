import 'package:dashboard/main.dart';
import 'package:dashboard/pages/AdminDashboard.dart';
import 'package:dashboard/pages/registration.dart';
import 'package:dashboard/utils/custom_button.dart';
import 'package:dashboard/view_models/profile.view.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
        viewModelBuilder: () => ProfileViewModel(context),
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
                            '${"Profile"}',
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
            body: Column(
              children: [
                CustomButton(
                  title: "Change Password",
                  onPressed: () {
                    model.openChangePassword();
                  },
                ),
                SizedBox(height: 12.h,),
                (model.currentUser?.role == 'admin')?
                CustomButton(
                  title: "Add User",
                  onPressed: (){
                    context.nextPage(RegistrationPage());
                  },
                ):SizedBox()
              ],
            ).pSymmetric(h: 12.r,v: 12.r).safeArea(),
          );
        });
  }
}
