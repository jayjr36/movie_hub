import 'package:flutter/material.dart';
import 'package:movie_hub/extensions/constants.dart';
import 'package:movie_hub/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Colors.black,
        width: w,
        height: h,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: h * 0.3),
            Image.asset('assets/logo.png', width: h*0.3, height: h*0.3,),
            SizedBox(height: h * 0.3),
            Text(
              'Powered by JSolutions',
              style: AppConstant.smallText.copyWith(color: AppConstant.primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
