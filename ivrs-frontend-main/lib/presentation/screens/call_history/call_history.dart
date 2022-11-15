import 'package:flutter/material.dart';
import 'package:ivr_frontend/presentation/screens/call_history/widgets/custom_tabbed_bar.dart';
import 'package:ivr_frontend/presentation/widgets/app_bar.dart';
import 'package:ivr_frontend/presentation/widgets/body_padding_widget.dart';
import 'package:ivr_frontend/presentation/widgets/home_padding_widget.dart';

class CallHistory extends StatefulWidget {
  const CallHistory({Key? key}) : super(key: key);

  @override
  State<CallHistory> createState() => _CallHistoryState();
}

class _CallHistoryState extends State<CallHistory> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: appBar(title: "Call History", context: context, backIcon: false),
        body: HomePaddingWidget(
          child: BodyPaddingWidget(
              child: Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: const CustomTabbedAppBar(),
              ),
            ),
        ),
        ),
    );
  }
}
