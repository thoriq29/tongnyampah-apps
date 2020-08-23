import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recase/recase.dart';
import 'package:tongnyampah/services/database.dart';
import 'package:tongnyampah/utils/color_theme.dart';
import 'package:tongnyampah/utils/miscellaneous.dart';

class NotificationDetail extends StatefulWidget {
  final DocumentSnapshot notificationData;

  NotificationDetail({@required this.notificationData});

  @override
  _NotificationDetailState createState() => _NotificationDetailState();
}

class _NotificationDetailState extends State<NotificationDetail> {
  String status = '';

  @override
  void setState(fn) {
    if (this.mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
          ..init(context);
    listenNotifData();
    return Scaffold(
      appBar: TongsWidget.appBar(title: 'Pemberitahuan Detail'),
      bottomNavigationBar: status == "Terverifikasi"
          ? BottomAppBar(
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: () {
                    TongsWidget.tongsDialog(
                        context: context,
                        title: 'Konfirmasi',
                        content:
                            'Pastikan anda telah mengambil barang dari kios kami',
                        buttons: [
                          FlatButton(
                            onPressed: () {
                              DatabaseService(
                                      id: widget.notificationData.documentID)
                                  .updateAsDoneNotif();
                              Navigator.of(context).pop();
                            },
                            child: Text('Ok'),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Batal'),
                          )
                        ]);
                    print("Selesai");
                  },
                  child: Container(
                    color: ThemeApp.bluePrimary,
                    height: 56,
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        "Selesai",
                        style: TextStyle(
                          fontSize: ScreenUtil.getInstance().setSp(35),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : null,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 8,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: ThemeApp.bluePrimary,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 4),
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.25),
                    ),
                  ]),
              child: Text(
                ReCase(widget.notificationData['type']).titleCase,
                style: TextStyle(
                  fontSize: ScreenUtil.getInstance().setSp(25),
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              widget.notificationData['title'],
              style: TextStyle(
                fontSize: ScreenUtil.getInstance().setSp(40),
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              status != ''
                  ? 'Status: $status'
                  : 'Status: ${widget.notificationData['status']}',
              style: TextStyle(
                fontSize: ScreenUtil.getInstance().setSp(20),
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 10),
            FadeInImage.assetNetwork(
              placeholder: '',
              image: widget.notificationData['image'],
              width: ScreenUtil.getInstance().width,
            ),
            SizedBox(height: 10),
            Text(
              widget.notificationData['verifikasi']
                  ? widget.notificationData['desc_verifed']
                  : widget.notificationData['desc'],
            ),
          ],
        ),
      ),
    );
  }

  Future listenNotifData() async {
    await DatabaseService(id: widget.notificationData.documentID)
        .getDocNotification()
        .then((value) {
      setState(() {
        status = value['status'];
      });
    });
  }
}
