import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ivr_frontend/core/theme/colors.dart';
import 'package:ivr_frontend/core/utils/helpers.dart';
import 'package:ivr_frontend/presentation/widgets/border_info_box.dart';
import 'package:ivr_frontend/presentation/widgets/row_widget.dart';
import 'package:ivr_frontend/services/routing_service/routes_name.dart';
import 'package:sizer/sizer.dart';

class AllTabs extends StatefulWidget {
  final String tab;
  const AllTabs({Key? key, required this.tab}) : super(key: key);

  @override
  State<AllTabs> createState() => _AllTabsState();
}

class _AllTabsState extends State<AllTabs> {

  late Stream callHistoryStream;

  Widget nomineesList() {
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("calls").where('main_type', isEqualTo: widget.tab).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if(snapshot.hasData) {
                  final docs = snapshot.data!.docs;
                  return ListView.separated(
                    //padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return callHistoryTile(
                        phoneNumber: docs[index]["phone"],
                        date: Helpers.formatDateTime(dateTime: docs[index]["date"].toDate()),
                        status: docs[index]["type"],
                      );
                    }, separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 2.h,);
                  },
                  );
                }
                else {
                  return const Text("Something Went wrong");
                }
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: nomineesList(),
          ),
          const SizedBox(height: 50,),
        ] ,
      ),
    );
  }


  Widget callHistoryTile({String? phoneNumber, String? date, String? status}){
    final textTheme = Theme.of(context).textTheme;
    return BorderInfoBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          RowWidget(text1: 'Phone Number', text2: phoneNumber),
          RowWidget(text1: 'Date', text2: date),
          RowWidget(text1: 'Status', text2: status, isLast: true,),
        ],
      ),
    );
  }
}
