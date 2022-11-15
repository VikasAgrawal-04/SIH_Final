import 'package:flutter/material.dart';

class RoutingService extends StatefulWidget {
  const RoutingService({Key? key}) : super(key: key);

  @override
  State<RoutingService> createState() => _RoutingServiceState();
}

class _RoutingServiceState extends State<RoutingService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.4,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Center(child: CircularProgressIndicator()),
              Text("Redirecting...!"),
            ],
          ),
        ),
      ),
    );
  }
}
