
import 'package:flutter/material.dart';
import 'package:reon_machine_test/pages/firstpage.dart';
import 'package:reon_machine_test/pages/gallery_page.dart';
import 'package:reon_machine_test/pages/splash_screen_page.dart';
import '../pages/upload_page.dart';

class Routes {
  static final routes = <String, WidgetBuilder>{
    '/': (context) => SplashScreen(),
    '/home': (context) => HomeScreen(),
    '/gallery': (context) => GalleryScreen(),
    '/upload': (context) => UploadScreen(),
  };
}
