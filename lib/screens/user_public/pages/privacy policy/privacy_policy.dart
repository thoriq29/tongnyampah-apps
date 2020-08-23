import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tongnyampah/utils/miscellaneous.dart';
import 'package:html/dom.dart' as dom;

class PrivacyPolicy extends StatefulWidget {
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  Firestore _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
          ..init(context);
    return Scaffold(
      appBar: TongsWidget.appBar(
        title: 'Syarat & Ketentuan dan Kebijakan Privasi',
      ),
      body: StreamBuilder(
        stream: _firestore
            .collection('about-privacy-policy')
            .document('privacy-policy')
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else
            return ListView(
              padding: EdgeInsets.all(15),
              children: [
                Html(
                  data: snapshot.data['desc'],
                  customTextAlign: (dom.Node node) {
                    if (node is dom.Element) {
                      switch (node.localName) {
                        case "p":
                          return TextAlign.left;
                      }
                    }
                    return null;
                  },
                )
              ],
            );
        },
      ),
    );
  }
}
