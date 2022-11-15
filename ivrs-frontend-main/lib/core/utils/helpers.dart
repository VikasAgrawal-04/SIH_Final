import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;

import '../theme/colors.dart';



class Helpers {

  static toast(String text) {
    return Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }


  static String formattedTime(int secTime) {
    String getParsedTime(String time) {
      if (time.length <= 1) return "0$time";
      return time;
    }

    int min = secTime ~/ 60;
    int sec = secTime % 60;

    String parsedTime = "${getParsedTime(min.toString())} : ${getParsedTime(sec.toString())}";

    return parsedTime;
  }


  static DateTime? convertTimeStampToDateTime(int? timeStamp) {
    if(timeStamp == null){
      return null;
    }else{
      var dateToTimeStamp = DateTime.fromMillisecondsSinceEpoch(timeStamp.floor() * 1000);
      return dateToTimeStamp;
    }
  }


  static formatDateTime({DateTime? dateTime}){
    final format = DateFormat.yMd().add_jms().format(dateTime!);
    final dateSplit = format.split(" ")[0].split("/");
    final timeSplit = format.split(" ")[1].split(":");
    final result = "${formatDigits(dateSplit[1])}/${formatDigits(dateSplit[0])}/${dateSplit[2]} @ ${formatDigits(timeSplit[0])}:${timeSplit[1]} ${format.split(" ")[2]}";
    return result;
  }

  static formatDigits(String number){
    if(number.length < 2) {
      return '0$number';
    }else{
      return number;
    }
  }


  static Future loader(BuildContext context, {String title = "Loading..."})async{
    final textTheme = Theme.of(context).textTheme;

    final ProgressDialog pd = ProgressDialog(context, customBody: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 0.5.w,),
       const  Padding(
          padding:  EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
        SizedBox(width: 1.w,),
        Text(title, style: textTheme.headline3?.copyWith(fontSize: 18),)
      ],
    ),
    isDismissible: true);

    await pd.show();
  }

  static Future hideLoader(BuildContext context)async{
    ProgressDialog pd = ProgressDialog(context);
    final isOpen = pd.isShowing();

    if(isOpen){
      await pd.hide();
    }
  }


  static actionDialog(BuildContext context, {Function()? onNo, Function()? onYes, String? title}){
    final textTheme = Theme
        .of(context)
        .textTheme;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(title ?? "Are You Sure You Want To Delete This Item?", style: textTheme.headline3,),
          actions: [
            TextButton(
              onPressed:  onNo ?? () {
                Navigator.pop(context);
              },
              child: Text("No", style: textTheme.headline3,),
            ),
            TextButton(
              onPressed: onYes ?? () {
                Navigator.pop(context);
              },
              child: Text("Yes", style: textTheme.headline3,),
            ),
          ],
        );
      },
    );
  }



  static callingDialog(BuildContext context, String number){
    final textTheme = Theme
        .of(context)
        .textTheme;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(borderRadius: BorderRadius.circular(50), child: Image.asset("assets/images/profile.png", height: 150, width: 150,),),
                SizedBox(height: 2.h,),
                Text(number, style: textTheme.headlineLarge?.copyWith(color: primaryColor),),
                SizedBox(height: 2.h,),
                Text("Ongoing Call...", style: textTheme.headline1?.copyWith(color: primaryColor),),
                SizedBox(height: 6.h,),
                Container(
                  width: 8.w,
                  height: 5.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                      child: Text("Hangup", style: textTheme.headline3?.copyWith(color: Colors.white), textAlign: TextAlign.center,)),
                )
              ],
            ),
          )
        );
      },
    );
  }


  static textDialog(BuildContext context, TextTheme textTheme,
      {String? heading, String? body}) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(heading?? '',
            style: textTheme.headline3?.copyWith(
                fontWeight: FontWeight.w500), textAlign: TextAlign.center,),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  body ?? '',
                  style: textTheme.headline4?.copyWith(
                      fontWeight: FontWeight.w500),),
              ],
            ),
          actions: [
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
                child: Text('Close',
                  style: textTheme.headline2?.copyWith(color: primaryColor,
                      fontWeight: FontWeight.w500)),
              ),
            ),
          ],
        );
      },
    );
  }
}
