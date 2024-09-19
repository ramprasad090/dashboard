import 'package:dashboard/view_models/base_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

import '../utils/custom_button.dart';
import '../utils/custom_text_form_field.dart';

class ProfileViewModel extends MyBaseViewModel {
  ProfileViewModel(BuildContext context) {
    this.context = context;
  }
  @override
  initialise() {
    // TODO: implement initialise
    return super.initialise();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  // Method to update the password in Firebase
  Future<String?> updatePassword(
      String currentPassword, String newPassword) async {
    setBusy(true);
    User? user = _auth.currentUser;

    if (user == null) {
      return 'No user signed in';
    }

    try {
      // Re-authenticate user to verify current password
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Update the user's password
      await user.updatePassword(newPassword);
      Navigator.pop(context!);
      setBusy(false);
      return 'Password updated successfully';
    } on FirebaseAuthException catch (e) {
      setBusy(false);
      toastError(e.message.toString());
      return e.message;
    }
  }

  TextEditingController currentPasswordTEC = new TextEditingController();
  TextEditingController newPasswordTEC = new TextEditingController();
  TextEditingController confirmNewPasswordTEC = new TextEditingController();

  openChangePassword() async {
    await showModalBottomSheet(
        context: context!,
        isDismissible: false,
        enableDrag: false,
        useSafeArea: true,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.r),
            topRight: Radius.circular(12.r),
          ),
        ),
        backgroundColor: Colors.transparent,
        barrierColor: Color(0xB20F1728),
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 12.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Change Password",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: Color(0xFF0F1728),
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        ClipOval(
                          child: Container(
                            height: 40.h,
                            width: 40.h,
                            decoration: BoxDecoration(
                              color: Color(0xfff5f5f7),
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              size: 24.sp,
                              color: Colors.black,
                            ),
                          ),
                        ).onInkTap(() {
                          Navigator.pop(context!);
                        })
                      ],
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    CustomTextFormField(
                      heading: "Current Password",
                      labelText: "",
                      obscureText: true,
                      textEditingController: currentPasswordTEC,
                      validator: validatePassword,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    CustomTextFormField(
                      heading: "New Password",
                      labelText: "",
                      obscureText: true,
                      textEditingController: newPasswordTEC,
                      validator: validatePassword,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    CustomTextFormField(
                      heading: "Confirm Password",
                      labelText: "",
                      obscureText: true,
                      textEditingController: confirmNewPasswordTEC,
                      validator: validatePassword,
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    CustomButton(
                      title: "Save Changes",
                      height: 46.h,
                      color: Color(0xFF252731),
                      loading: busy(newPasswordTEC),
                      shapeRadius: 10.r,
                      titleStyle: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      onPressed: () async {
                        setBusyForObject(newPasswordTEC, true);
                        setState(
                          () {},
                        );
                        if ((newPasswordTEC.text !=
                            confirmNewPasswordTEC.text)) {
                          toastError("Password Not Matched");
                        }
                        if (newPasswordTEC.text.isNotEmpty &&
                            confirmNewPasswordTEC.text.isNotEmpty &&
                            currentPasswordTEC.text.isNotEmpty &&
                            (newPasswordTEC.text ==
                                confirmNewPasswordTEC.text)) {
                          updatePassword(
                              currentPasswordTEC.text, newPasswordTEC.text);
                        } else {
                          toastError("Please Fill form");
                        }
                        //
                        setState(
                          () {},
                        );
                        setBusyForObject(newPasswordTEC, false);
                      },
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Container(
                      height: 44.h,
                      padding: EdgeInsets.symmetric(
                          horizontal: 18.r, vertical: 10.r),
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side:
                              BorderSide(width: 1.w, color: Color(0xFFCFD4DC)),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x0C101828),
                            blurRadius: 2.r,
                            offset: Offset(0, 1.r),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Cancel",
                            style: GoogleFonts.inter(
                              color: Color(0xFF344053),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ).wFull(context).onInkTap(() {
                      Navigator.pop(context!);
                    }),
                    SizedBox(
                      height: 16.h,
                    ),
                  ],
                )
                    .scrollVertical()
                    .pSymmetric(h: 16.r)
                    .box
                    .withDecoration(BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x07101828),
                          blurRadius: 8.r,
                          offset: Offset(0, 8.r),
                          spreadRadius: -4.r,
                        ),
                        BoxShadow(
                          color: Color(0x14101828),
                          blurRadius: 24.r,
                          offset: Offset(0, 20.r),
                          spreadRadius: -4.r,
                        )
                      ],
                    ))
                    .make()
                    .pSymmetric(h: 16.r, v: 22.r),
              ),
            );
          });
        });
    // Navigator.of(viewContext!).pushNamed(
    //   AppRoutes.changePasswordRoute,
    // );
  }
}
