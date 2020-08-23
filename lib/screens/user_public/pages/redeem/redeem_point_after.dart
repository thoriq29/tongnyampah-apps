import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tongnyampah/utils/miscellaneous.dart';
import 'package:tongnyampah/screens/user_public/wrapper.dart';
import 'package:tongnyampah/utils/color_theme.dart';

class RedeemPointAfter extends StatelessWidget {
  RedeemPointAfter({this.dateTime, this.userUID, this.dataGift});
  final DateTime dateTime;
  final String userUID;
  final DocumentSnapshot dataGift;
  final f = new DateFormat.yMd().add_jm();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
          ..init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TongsWidget.appBar(title: 'Berhasil Menukar'),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: <Widget>[
          Center(
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: ThemeApp.bluePrimary,
                  width: 2,
                ),
              ),
              child: Icon(Icons.done),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Penukaran dalam proses',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ScreenUtil.getInstance().setSp(30),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Point anda telah di tukar, mohon tunggu verifikasi admin untuk pengambilan barang anda.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ScreenUtil.getInstance().setSp(20),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                  child: Text(
                    '${f.format(dateTime)}',
                    style: TextStyle(
                      fontSize: ScreenUtil.getInstance().setSp(25),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                  child: Text(
                    'ID. \n$userUID-${dataGift.documentID}',
                    style: TextStyle(
                      fontSize: ScreenUtil.getInstance().setSp(25),
                    ),
                  ),
                ),
                Divider(
                  indent: 0,
                  color: Colors.grey[400],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                  child: Text(
                    'Menukarkan point dengan ${dataGift['name']}',
                    style: TextStyle(
                      fontSize: ScreenUtil.getInstance().setSp(30),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(
                  indent: 0,
                  color: Colors.grey[400],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Total Point',
                          style: TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(25),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '${dataGift['point']}',
                        style: TextStyle(
                          fontSize: ScreenUtil.getInstance().setSp(25),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
                  child: Text(
                    'Note: \nPoint anda akan otomatis kembali jika gagal di verifikasi oleh admin.',
                    style: TextStyle(
                      fontSize: ScreenUtil.getInstance().setSp(25),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          TongsWidget.tongsButton(
            buttonText: 'Kembali ke rincian hadiah',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (contexr) => WrapperPublic(),
                  ),
                );
              },
              child: Text(
                'Kembali ke beranda',
                style: TextStyle(
                  color: ThemeApp.bluePrimary,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
