import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tongnyampah/utils/miscellaneous.dart';

class EdusaDetail extends StatefulWidget {
  EdusaDetail({this.dataEdusa});

  final DocumentSnapshot dataEdusa;
  @override
  _EdusaDetailState createState() => _EdusaDetailState();
}

class _EdusaDetailState extends State<EdusaDetail> {
  DateFormat f = DateFormat('EEEE, dd MMMM yyyy');

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
          ..init(context);
    return Scaffold(
      appBar: TongsWidget.appBar(
        title: 'Edukasi Sampah',
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.dataEdusa['title'],
                style: TextStyle(
                  fontSize: ScreenUtil.getInstance().setSp(40),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              widget.dataEdusa['cover'] != null
                  ? Image.network(widget.dataEdusa['cover'])
                  : Container(),
              SizedBox(
                height: 20,
              ),
              Html(
                data: widget.dataEdusa['content'],
                customTextAlign: (dom.Node node) {
                  if (node is dom.Element) {
                    switch (node.localName) {
                      case "p":
                        return TextAlign.left;
                    }
                  }
                  return null;
                },
                defaultTextStyle: TextStyle(
                  fontSize: ScreenUtil.getInstance().setSp(30),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text('Sumber',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil.getInstance().setSp(25),
                  )),
              Text(
                widget.dataEdusa['reference'],
                style: TextStyle(
                  fontSize: ScreenUtil.getInstance().setSp(20),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text('Di Upload Pada: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil.getInstance().setSp(25),
                  )),
              Text(
                f.format(widget.dataEdusa['created_at'].toDate()),
                style: TextStyle(
                  fontSize: ScreenUtil.getInstance().setSp(20),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
