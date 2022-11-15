import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HomePaddingWidget extends StatelessWidget {
  final Widget child;

  const HomePaddingWidget({Key? key,required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(left:  20.w , right: 20.w),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.2),),
              right: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.2),),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}