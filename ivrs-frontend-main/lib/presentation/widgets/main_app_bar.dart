import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ivr_frontend/core/theme/colors.dart';
import 'package:ivr_frontend/services/routing_service/routes_name.dart';
import 'package:sizer/sizer.dart';

import 'btn_gradient.dart';

class MainAppBar extends StatefulWidget {


  const MainAppBar({Key? key,}) : super(key: key);

  @override
  State<MainAppBar> createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {


  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Container(

          height: 15.h,
          decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: bottomNavDivider,
                  width: 0.6))),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 5.0, left: 2.w),
                child:Image.asset(
                  "assets/icons/header_logo.png", height: 35,),
              ),
              BtnGradient(
                  top: 0.0 ,left: 2.w, right:  2.w, bottom : 0.h,
                  text:  'Call History',
                  onTap: () async {
                    context.pushNamed(callHistoryPage);
                  }

              ),


            ],
          ),
        ),
    );
  }
}



