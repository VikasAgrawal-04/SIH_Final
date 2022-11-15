import 'package:flutter/material.dart';
import 'package:ivr_frontend/core/theme/colors.dart';


class BorderInfoBox extends StatelessWidget {
  final Widget? child;
  final double? padding;
  const BorderInfoBox({Key? key, this.child, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding ?? 16.0),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 1.2),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: child,
    );
  }
}
