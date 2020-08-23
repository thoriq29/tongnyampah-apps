import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tongnyampah/utils/miscellaneous.dart';
import 'package:tongnyampah/screens/user_public/pages/redeem/redeem_point_after.dart';
import 'package:tongnyampah/services/auth.dart';
import 'package:tongnyampah/services/database.dart';
import 'package:tongnyampah/utils/color_theme.dart';

class RedeemPointDetail extends StatefulWidget {
  RedeemPointDetail({this.dataGift});

  final DocumentSnapshot dataGift;
  @override
  _RedeemPointDetailState createState() => _RedeemPointDetailState();
}

class _RedeemPointDetailState extends State<RedeemPointDetail> {
  bool tukar = false;
  String userUID = '';
  num point = 0;

  Future getUserData() async {
    await BaseAuthService().getUserData().then((user) {
      DatabaseService(id: user.uid).getUserData().then((data) {
        if (data['point'] >= widget.dataGift['point']) {
          setState(() {
            tukar = true;
          });
        } else {
          setState(() {
            tukar = false;
          });
        }
        setState(() {
          userUID = data.documentID;
          point = data['point'];
        });
      });
    });
  }

  Future redeemPoint() async {
    await DatabaseService().createNotifications(
        userUID: userUID,
        giftID: widget.dataGift.documentID,
        point: -widget.dataGift['point'],
        url: widget.dataGift['image'],
        title: widget.dataGift['name'],
        desc: 'Meminta verifikasi penukaran point',
        type: 'tukar_point',
        descVerifed: '',
        status: 'Menunggu Verifikasi');
    await DatabaseService().createPointHistory(
      title: 'Penukaran dengan ${widget.dataGift['name']}',
      pointBefore: point,
      pointDefference: -widget.dataGift['point'],
      type: "tukar_point",
      userUID: userUID,
      giftId: widget.dataGift.documentID,
      verifed: false,
    );
    await DatabaseService(id: userUID).updatePointUser(
      point + (-widget.dataGift['point']),
    );
  }

  @override
  void setState(fn) {
    if (this.mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
          ..init(context);
    getUserData();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TongsWidget.appBar(title: widget.dataGift['name']),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FadeInImage.assetNetwork(
              placeholder: '',
              image: widget.dataGift['image'],
              width: ScreenUtil.getInstance().width,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.dataGift['point'].toString() + ' Point',
                    style: TextStyle(
                      fontSize: ScreenUtil.getInstance().setSp(50),
                      fontWeight: FontWeight.bold,
                      color: ThemeApp.bluePrimary,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.dataGift['categori'],
                    style: TextStyle(
                      fontSize: ScreenUtil.getInstance().setSp(40),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.dataGift['description'],
                  ),
                  SizedBox(height: 50),
                ],
              ),
            )
          ],
        ),
      ),
      bottomSheet: InkWell(
        onTap: () {
          tukar
              ? TongsWidget.tongsDialog(
                  context: context,
                  title: 'Konfirmasi',
                  content:
                      'Apakah anda yakin akan menukarkan point anda dengan ${widget.dataGift['name']}',
                  buttons: [
                    FlatButton(
                      onPressed: () {
                        // TongsWidget.loadingPageIndicator(context: context);
                        redeemPoint().whenComplete(() {
                          Navigator.of(context)
                            ..pop()
                            ..push(
                              MaterialPageRoute(
                                builder: (context) => RedeemPointAfter(
                                  dateTime: DateTime.now(),
                                  userUID: userUID,
                                  dataGift: widget.dataGift,
                                ),
                              ),
                            );
                        });
                      },
                      child: Text('Tukar'),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Tidak'),
                    )
                  ],
                )
              : TongsWidget.tongsDialog(
                  context: context,
                  title: 'Mohon Maaf',
                  content:
                      'Point tidak mencukupi untuk menukarkan dengan ${widget.dataGift['name']}',
                  buttons: [
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ]);
        },
        child: Container(
          height: 50.0,
          color: tukar
              ? ThemeApp.bluePrimary
              : ThemeApp.textPrimary.withOpacity(0.5),
          child: Center(
            child: Text(
              'Tukar',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
        ),
      ),
    );
  }
}
