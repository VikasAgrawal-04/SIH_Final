import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';



PreferredSizeWidget? appBar({
  String? title,
  required BuildContext context,
  Function()? onBack,
  bool backIcon = true,
  bool isTitleShown = true,

}) {
  final textTheme = Theme.of(context).textTheme;

  return PreferredSize(
    preferredSize: const Size(double.infinity, 60),
    child: SafeArea(
      child: SizedBox(
        height: 7.h,
        child : Row(
          mainAxisAlignment: backIcon == false ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                backIcon == false ? Container()
                    : IconButton(
                  onPressed: () {
                    if(onBack == null){
                      Navigator.pop(context);
                    }else{
                      onBack();
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                ),
                isTitleShown ? Text(
                  title!,
                  style: textTheme.headline3?.copyWith(fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ) : const SizedBox(),
              ],
            ),
      ),
    ),
  );
}
