import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ivr_frontend/core/utils/helpers.dart';
import 'package:ivr_frontend/presentation/getx/controllers/home_controller.dart';
import 'package:ivr_frontend/presentation/screens/main/home.dart';
import 'package:ivr_frontend/presentation/widgets/border_info_box.dart';
import 'package:ivr_frontend/presentation/widgets/row_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/theme/colors.dart';
import '../all_tabs.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;


/// Builds custom tab bar for application
class CustomTabbedAppBar extends StatefulWidget {
  const CustomTabbedAppBar({Key? key}) : super(key: key);

  @override
  State<CustomTabbedAppBar> createState() => CustomTabbedAppBarState();
}

class CustomTabbedAppBarState extends State<CustomTabbedAppBar>
    with SingleTickerProviderStateMixin {

  HomeController homeController = Get.find<HomeController>();
  late TabController _tabController;

  int _currentTabIndex = 0;

  late Timer timer;
  late io.Socket socket;



  @override
  void initState() {
    super.initState();
    connect();

    _tabController = TabController(
        length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      if (_tabController.animation?.value == _tabController.index) {
        setState(() {
          _currentTabIndex = _tabController.index;
        });

        // context.pushNamed('LEAD_ROUTES', params: {'path': _tabController.index == 0 ? leads : _tabController.index == 1 ? quotes : _tabController.index == 2 ? liveBidding : _tabController.index == 3 ? orders : _tabController.index == 4 ? endBids :  lostBids});
        debugPrint('current tab $_currentTabIndex');
      }
    });
  }

  Future<void> asyncFunction()async{
    await connect();
    if(socket.connected){
      socketListener();
    }else{
      Helpers.toast("not connexted");
    }
  }


  Future<void> connect()async{
    socket = io.io("http://192.168.2.169:5000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();
    socket.onConnect((data){
      debugPrint("Socket is Connected");
      socketListener();
    });
    debugPrint('socket status is connected? ${socket.connected}');
  }

  void socketListener(){
    socket.on('data', (data) {
      debugPrint('socket data $data');
      socketActions(data: data);
    });
  }


  void socketActions({@required dynamic data})async{
    switch(data['action']){
      case 'incoming':
        homeController.isIncoming.value = true;
        homeController.isEnded.value = false;
        homeController.phone.value = data['phone'] ?? '';
        // Helpers.callingDialog(context, homeController.phone.value);
        break;

      case 'ended':
        homeController.isIncoming.value = false;
        homeController.isEnded.value = true;
        // Future.delayed(Duration.zero, () {
        //   Navigator.pop(context);
        // });
        break;
    }

    getCallType(data: data);
  }

  void getCallType({@required dynamic data})async{
    switch(data['call_type']){
      case 'blank':
        // Navigator.pop(context);
        Helpers.actionDialog(context, title: "It is a blank call. Would you like to block it?", onYes: ()async{
          await FirebaseFirestore.instance.collection("calls").doc(data['phone']).update({
            "type": "blank",
            "status": "block",
          });
          Navigator.pop(context);
        });
        break;

      case 'abusive':
        Helpers.actionDialog(context, title: "It is a Abusive call. Would you like to block it?", onYes: ()async{
          await FirebaseFirestore.instance.collection("calls").doc(data['phone']).update({
            "type": "abusive",
            "status": "block",
          });
          Navigator.pop(context);
        });
        break;
    }
  }



  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;


    return Column(
      children: [
        Obx(() {
          if(homeController.isIncoming.value){
            return Container(
              padding: const EdgeInsets.all(8.0),
              color: primaryColor,
              height: 6.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Ongoing Call", style: textTheme.headline3?.copyWith(color: Colors.white),),
                  Text(homeController.phone.value, style: textTheme.headline3?.copyWith(color: Colors.white),),
                ],
              ),
            );
          }else{
            return const SizedBox();
          }
        }),
        TabBar(
          isScrollable: true,
          labelColor: primaryColor,
          unselectedLabelColor: Colors.black,
          labelStyle: textTheme.headline3,
          controller: _tabController,
          indicatorColor: primaryColor,
          onTap: (value) {
            setState(() => _currentTabIndex = value);
            // context.pushNamed('LEAD_ROUTES', params: {'path': value == 0 ? leads : value == 1 ? quotes : value == 2 ? liveBidding : value == 3 ? orders : value == 4 ? endBids :  lostBids});
          },
          // indicator: null,
          tabs: const [
            Tab(text: 'Real Call',),
            Tab(text: 'Fake Call',),
          ],
        ),
        // if (_currentTabIndex == 0)
        SizedBox(height: 0.2.h),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              AllTabs(tab: 'real',),
              AllTabs(tab: 'fake',),
            ],
          ),
        ),
      ],
    );
  }


}

