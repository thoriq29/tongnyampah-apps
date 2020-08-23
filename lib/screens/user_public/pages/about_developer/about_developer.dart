import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tongnyampah/utils/miscellaneous.dart';
import 'package:html/dom.dart' as dom;

class AboutDeveloper extends StatefulWidget {
  @override
  _AboutDeveloperState createState() => _AboutDeveloperState();
}

class _AboutDeveloperState extends State<AboutDeveloper> {
  Firestore _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
          ..init(context);
    return Scaffold(
      appBar: TongsWidget.appBar(title: 'Tentang Pengembang'),
      body: StreamBuilder(
          stream: _firestore
              .collection('about-privacy-policy')
              .document('about-developer')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Container();
            } else
              return ListView(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Image.asset(
                      'assets/images/about-developer-pic.png',
                      width: ScreenUtil.getInstance().width,
                    ),
                  ),
                  Html(
                    data: snapshot.data['desc'],
                    customTextAlign: (dom.Node node) {
                      if (node is dom.Element) {
                        switch (node.localName) {
                          case "p":
                            return TextAlign.center;
                        }
                      }
                      return null;
                    },
                  )
                ],
              );
          }),
    );
  }
}
