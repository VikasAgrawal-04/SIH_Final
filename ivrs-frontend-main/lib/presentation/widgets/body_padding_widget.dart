import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class BodyPaddingWidget extends StatelessWidget {
  final Widget? child;

  const BodyPaddingWidget({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15 , right: 15),
    child: child,
    );
  }
}