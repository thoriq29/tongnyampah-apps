import 'package:flutter/material.dart';
import 'package:tongnyampah/utils/styles.dart';
import 'package:tongnyampah/widgets/unicorn_outline_button.dart';

class FeatureCard extends StatelessWidget {
  @required
  final Widget icon;
  @required
  final String title;
  @required
  final EdgeInsetsGeometry margin;
  final Function onTap;

  FeatureCard({this.icon, this.title, this.margin, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          margin: this.margin,
          width: 125.0,
          height: 100,
          child: UnicornOutlineButton(
            strokeWidth: 2,
            radius: 15,
            gradient:
                LinearGradient(colors: [Color(0xFF17ead9), Color(0xFF6078ea)]),
            child: this.icon,
            onPressed: () {},
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          margin: this.margin,
          width: 125.0,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(top: 70),
              width: 125.0,
              height: 50.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0),
                  ),
                  gradient: LinearGradient(
                      colors: [Color(0xFF17ead9), Color(0xFF6078ea)])
                  // color: ThemeApp.bluePrimary,
                  ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          margin: this.margin,
          width: 125.0,
          height: 145,
          child: InkWell(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
            onTap: this.onTap,
            child: Padding(
              padding: EdgeInsets.only(top: 95),
              child: Text(
                '$title',
                textAlign: TextAlign.center,
                style: Styles.TextFeatureCard,
              ),
            ),
          ),
        )
      ],
    );
  }
}
