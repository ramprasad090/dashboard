import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:velocity_x/velocity_x.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(),
      appBar: AppBar(
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
    );
  }
}
