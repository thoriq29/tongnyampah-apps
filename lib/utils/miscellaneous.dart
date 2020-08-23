import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:tongnyampah/utils/styles.dart';
import 'package:tongnyampah/utils/color_theme.dart';

class TongsWidget {
  //===================== APP BAR ===================
  static Widget appBar({
    @required String title,
    bool centerTitle,
    List<Widget> actions,
    Widget leading,
    PreferredSizeWidget bottom,
  }) {
    return GradientAppBar(
      leading: leading,
      gradient: LinearGradient(
        colors: [
          ThemeApp.toscaPrimary,
          ThemeApp.bluePrimary,
        ],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp,
      ),
      title: Text(
        title,
        style: TextStyle(
            fontSize: ScreenUtil().setSp(40), fontWeight: FontWeight.bold),
      ),
      actions: actions != null ? actions : <Widget>[],
      centerTitle: centerTitle ?? true,
      bottom: bottom,
    );
  }
  //=================== END =================

  //=============LOADING DATA================
  static Widget loadingData(
      {String loadingTitle = '', double loadingSize = 30.0}) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SpinKitFadingCircle(
              size: loadingSize,
              itemBuilder: (BuildContext context, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: index.isEven
                        ? ThemeApp.bluePrimary
                        : ThemeApp.toscaPrimary,
                  ),
                );
              },
            ),
            SizedBox(height: 10.0),
            Text(loadingTitle)
          ]),
    );
  }
  //======================END=======================

  //==================No Data========================

  static Widget noData(
      {String title = '', String subtitle = '', Widget button}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.0, color: Colors.grey),
              ),
              SizedBox(height: 3.0),
              button != null ? button : Container()
            ]),
      ),
    );
  }

  //=========================END==========================
  //==================LOADING DIALOG====================
  static loadingPageIndicator(
      {@required BuildContext context,
      String loadingText,
      double loadingSize = 30}) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        transitionDuration: Duration(milliseconds: 100),
        barrierLabel: '',
        barrierColor: Colors.black.withOpacity(0.6),
        pageBuilder: (context, animation1, animation2) {
          return Container();
        },
        transitionBuilder: (BuildContext context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
                opacity: a1.value,
                child: LoadingIndicator(
                  loadingText: loadingText != null ? loadingText : '',
                  loadingSize: loadingSize,
                )),
          );
        });
  }
  //===================END====================

  //===================THONGS DOALOG==========
  static tongsDialog(
      {@required BuildContext context,
      @required String title,
      @required String content,
      List<Widget> buttons,
      bool isDismissible = false}) {
    showGeneralDialog(
        context: context,
        barrierDismissible: isDismissible,
        transitionDuration: Duration(milliseconds: 150),
        barrierLabel: '',
        barrierColor: Colors.black.withOpacity(0.6),
        pageBuilder: (context, animation1, animation2) {
          return Container();
        },
        transitionBuilder: (BuildContext context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: TongsDialog(
                title: Text(title,
                    style: Styles.alertTitleStyle, textAlign: TextAlign.center),
                content: Text(content, style: Styles.alertDescriptionStyle),
                buttonActions: buttons != null
                    ? buttons
                    : FlatButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
              ),
            ),
          );
        });
  }

  //=================== Button ==================

  static Widget tongsButton({
    String buttonText = '',
    Function onPressed,
    double minWidth = 88.0,
    double height = 40.0,
    Color color,
    BorderSide side,
    Color textColor = Colors.white,
  }) {
    return ButtonTheme(
      minWidth: minWidth,
      height: height,
      child: FlatButton(
          child: Text(buttonText, style: TextStyle(color: textColor)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: side != null
                ? side
                : BorderSide(
                    color: Colors.transparent,
                    width: 0,
                  ),
          ),
          color: color != null ? color : ThemeApp.bluePrimary,
          onPressed: onPressed != null ? onPressed : () {}),
    );
  }
  //===================== END =================
}

//============== LOADING INDICATOR ==============
class LoadingIndicator extends StatelessWidget {
  final String loadingText;
  final double loadingSize;
  LoadingIndicator({this.loadingText, this.loadingSize});

  Future<bool> _onWillPop() {
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(
      width: ScreenUtil.getInstance().width,
      height: ScreenUtil.getInstance().height,
      allowFontScaling: true,
    )..init(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: loadingText != ''
          ? Center(
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                content: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SpinKitFadingCircle(
                        size: loadingSize,
                        itemBuilder: (BuildContext context, int index) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                                color: index.isEven
                                    ? ThemeApp.bluePrimary
                                    : ThemeApp.toscaPrimary),
                          );
                        },
                      ),
                      SizedBox(height: 10.0),
                      Text(loadingText)
                    ],
                  ),
                ),
              ),
            )
          : Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  dialogContent(context),
                ],
              ),
            ),
    );
  }

  dialogContent(BuildContext context) {
    return Center(
      child: Container(
          width: 50,
          height: 50,
          decoration: new BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(accentColor: ThemeApp.bluePrimary),
            child: SpinKitFadingCircle(
              size: loadingSize,
              itemBuilder: (BuildContext context, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                      color: index.isEven
                          ? ThemeApp.bluePrimary
                          : ThemeApp.toscaPrimary),
                );
              },
            ),
          )),
    );
  }
}
//======================= END ===================

//====================[TONGS DIALOG WIDGET]====================
class TongsDialog extends StatelessWidget {
  final Widget title, content;
  final List<Widget> buttonActions;

  TongsDialog({
    this.title,
    @required this.content,
    this.buttonActions,
  });

  Future<bool> _onWillPop() {
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      allowFontScaling: true,
    )..init(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: AlertDialog(
          title: title != null ? title : Container(),
          content: content,
          backgroundColor: Colors.white.withOpacity(0.9),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          actions: buttonActions != null ? buttonActions : <Widget>[]),
    );
  }
}
//====================[END]====================

//====================[LIST ANIMATOR]====================
class Animator extends StatefulWidget {
  final Widget child;
  final Duration time;
  Animator(this.child, this.time);
  @override
  _AnimatorState createState() => _AnimatorState();
}

class _AnimatorState extends State<Animator>
    with SingleTickerProviderStateMixin {
  Timer timer;
  AnimationController animationController;
  Animation animation;
  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(milliseconds: 290), vsync: this);
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    timer = Timer(widget.time, animationController.forward);
  }

  @override
  void dispose() {
    timer.cancel();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: widget.child,
      builder: (BuildContext context, Widget child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0.0, (1 - animation.value) * 20),
            child: child,
          ),
        );
      },
    );
  }
}

Timer timer;
Duration duration = Duration();
wait() {
  if (timer == null || !timer.isActive) {
    timer = Timer(Duration(microseconds: 120), () {
      duration = Duration();
    });
  }
  duration += Duration(milliseconds: 100);
  return duration;
}

class TongsListAnimator extends StatelessWidget {
  final Widget child;
  TongsListAnimator({this.child});
  @override
  Widget build(BuildContext context) {
    return Animator(child, wait());
  }
}
//====================[END]====================
