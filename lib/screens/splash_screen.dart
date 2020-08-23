import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tongnyampah/services/route_page.dart';
import 'package:tongnyampah/utils/color_theme.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  // PreferenceUtil appData = PreferenceUtil();
  bool showLoading = false;

  startTime() async {
    var _duration = new Duration(milliseconds: 4500);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => RootPage()));
  }

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 3000,
      ),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.fastLinearToSlowEaseIn,
    );
    animationController.forward();
    Future.delayed(Duration(milliseconds: 3100), () {
      setState(() {
        showLoading = true;
      });
    });
    startTime();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
          ..init(context);
    return Scaffold(
      // backgroundColor: ThemeApp.toscaPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ScaleTransition(
              scale: animation,
              child: Container(
                  height: ScreenUtil.getInstance().setHeight(500),
                  width: ScreenUtil.getInstance().setWidth(500),
                  child: Image.asset(
                    'assets/images/logos/typo.png',
                  )),
            ),
            showLoading
                ? SpinKitFadingCircle(
                    size: 35,
                    itemBuilder: (BuildContext context, int index) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                            color: index.isEven
                                ? ThemeApp.bluePrimary
                                : ThemeApp.toscaPrimary),
                      );
                    },
                  )
                : Center(
                    child: Container(
                      height: 35,
                      width: 35,
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
