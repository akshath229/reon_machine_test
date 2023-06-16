import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reon_machine_test/routes/route_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: Routes.routes,
    );
  }
}


