import 'package:flutter/material.dart';
import '../defaults/dimensions.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
    return Scaffold(backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(-0.5),
              child: Image.asset(fit: BoxFit.cover,
                'lib/images/image_1.png',
                width: Dimensions.width130,
                height: Dimensions.height100,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(fit: BoxFit.cover,
                'lib/images/image_2.png',
                width: Dimensions.width100,
                height: Dimensions.height97,
              ),
            ),

            Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(0.5),
              child: Image.asset(fit: BoxFit.cover,
                'lib/images/image_3.png',
                width: Dimensions.width140,
                height: Dimensions.height100,
              ),
            ),
          ],
        ),
            SizedBox(height: Dimensions.height36),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'S',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'nap',
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: 'Mosaic',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height36),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(-0.5),
              child: Image.asset(fit: BoxFit.cover,
                'lib/images/image_6.png',
                width: Dimensions.width130,
                height: Dimensions.height100,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(fit: BoxFit.cover,
                'lib/images/image_7.png',
                width: Dimensions.width100,
                height: Dimensions.height97,
              ),
            ),

            Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(0.5),
              child: Image.asset(fit: BoxFit.cover,
                'lib/images/image_4.png',
                width: Dimensions.width140,
                height:  Dimensions.height100,
              ),
            ),
          ],
        ),
          ],
        ),

      ),
    );
  }
} 