import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tongnyampah/utils/color_theme.dart';

class HistoryCard extends StatelessWidget {
  HistoryCard({this.width, this.title, this.image, this.onPressed});
  final double width;
  final String title;
  final String image;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: onPressed,
          child: Container(
            height: 130,
            width: width,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
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
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: ScreenUtil.getInstance().setSp(40),
                      color: Colors.white,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 100,
                    child: Image.asset(
                      image,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
