import 'package:flutter/material.dart';
import 'package:ivr_frontend/core/theme/colors.dart';
import 'package:sizer/sizer.dart';



class BtnGradient extends StatelessWidget {
  final String? text;
  final Function()? onTap;
  final bool? isLoading;
  final double? top, bottom, left, right;
  final int? fontSize;
  const BtnGradient({Key? key, this.text, this.onTap, this.isLoading, this.top, this.left, this.right, this.bottom, this.fontSize}) : super(key: key) ;

  @override
  Widget build(BuildContext context) {
    bool _isLoading = isLoading ?? false;

    final textTheme = Theme.of(context).textTheme;


    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          height:  6.0.h,
          margin: EdgeInsets.only(
              top: top!, left: left!, bottom: bottom!, right: right!),
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors : [primaryColor, primaryColor],
                begin: FractionalOffset.centerLeft,
                end: FractionalOffset.centerRight,
              ),
              borderRadius: BorderRadius.circular(4)),
          child: Stack(
            children: [
              Visibility(
                visible: _isLoading ? false : true,
                child: Center(
                  child: Text(
                    text ?? "Text",
                    style: textTheme.headline3?.copyWith(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w500), textAlign: TextAlign.center,),
                  ),
                ),
              Visibility(
                visible: _isLoading,
                child: const Center(
                  child: SizedBox(
                    height: 30.0,
                    width: 30.0,
                    child: CircularProgressIndicator(color: Colors.white,),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
