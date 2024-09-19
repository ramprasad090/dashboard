import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/pages/registration.dart';
import 'package:dashboard/pages/splash_screen.dart';
import 'package:dashboard/pages/user.profile.dart';
import 'package:dashboard/services/auth.service.dart';
import 'package:dashboard/utils/custom_button.dart';
import 'package:dashboard/view_models/user.dashboard.view.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserDashboardViewModel>.reactive(
        viewModelBuilder: () => UserDashboardViewModel(context),
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, model, child) {
          return Scaffold(
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                (model.currentUser?.role == 'admin')
                    ? CustomButton(
                        title: "Add User",
                        onPressed: () {
                          context.nextPage(RegistrationPage());
                        },
                      ).pSymmetric(h: 12.r,v: 12.r).safeArea()
                    : SizedBox()
              ],
            ),
            key: _scaffoldKey,
            drawer: Drawer(
              child: ListView(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 225.w,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    model.currentUser?.name ?? "",
                                    style: GoogleFonts.inter(
                                      color: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .color,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    model.currentUser?.email ?? "",
                                    style: GoogleFonts.inter(
                                      color: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .color,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).pSymmetric(h: 12.r, v: 12.r),
                        ],
                      ),
                      Icon(
                        Icons.keyboard_arrow_right_rounded,
                        size: 24.sp,
                      )
                          .box
                          .color(context.cardColor)
                          .withRounded(value: 2.r)
                          .make()
                          .pOnly(right: 4.r)
                    ],
                  ).onTap(() {
                    context.nextPage(UserProfile());
                    _scaffoldKey.currentState?.closeDrawer();
                  }),
                  CustomButton(
                    title: "Logout",
                    isSecondary: true,
                    onPressed: () {
                      AuthServices.logout();
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) {
                        return SplashScreen();
                      }), (route) => true);
                    },
                  ).pSymmetric(h: 12.r)
                ],
              ),
            ),
            appBar: AppBar(
              title: Text("Home"),
              leading: ClipOval(
                child: Container(
                  decoration: BoxDecoration(
                    color: context.cardColor,
                  ),
                  child: Icon(
                    Icons.menu,
                    color: Theme.of(context).iconTheme.color,
                    size: 18.sp,
                  ).onInkTap(
                    () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                ),
              ).p(6.r),
            ),
            body: Column(
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData) {
                      return Center(child: Text("No users found"));
                    }

                    final users = snapshot.data!.docs;

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        var user = users[index];
                        return ListTile(
                          title: Text(user['user_name']),
                          subtitle: Text(user['email']),
                          trailing: Text("Role: ${user['role']}"),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        });
  }
}
