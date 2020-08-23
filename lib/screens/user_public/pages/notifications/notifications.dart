import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tongnyampah/screens/user_public/pages/notifications/notofication_detail.dart';
import 'package:tongnyampah/utils/miscellaneous.dart';
import 'package:tongnyampah/services/database.dart';
import 'package:tongnyampah/utils/color_theme.dart';

Firestore _firestore = Firestore.instance;

class NotificationsPage extends StatefulWidget {
  NotificationsPage({this.userUID});

  final String userUID;
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (this.mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
          ..init(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: TongsWidget.appBar(
            title: 'Pemberitahuan',
            bottom: TabBar(
              tabs: [
                Tab(text: "Menunggu Verifikasi"),
                Tab(text: "Terverifikasi"),
              ],
            )),
        body: TabBarView(
          children: [
            NotVerifed(userUID: widget.userUID),
            IsVerifed(userUID: widget.userUID),
          ],
        ),
      ),
    );
  }
}

class IsVerifed extends StatefulWidget {
  final String userUID;

  IsVerifed({@required this.userUID});

  @override
  _IsVerifedState createState() => _IsVerifedState();
}

class _IsVerifedState extends State<IsVerifed> {
  final _dateFormat = DateFormat("dd/MM/yyyy");

  int countNotif = 0;

  @override
  void setState(fn) {
    if (this.mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    getCountNotif();
    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder(
            stream: _firestore
                .collection('notifications')
                .where('verifikasi', isEqualTo: true)
                .where('user_uid', isEqualTo: widget.userUID)
                .orderBy('updated_at', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.documents.length == 0) {
                  return TongsWidget.noData(
                    title: 'Belum ada pemberitahuan',
                    subtitle: 'Tidak ada data yang terverifikasi oleh admin',
                  );
                }
                return ListView(
                  padding: EdgeInsets.only(top: 10),
                  children: snapshot.data.documents.map((docs) {
                    return InkWell(
                      onTap: () {
                        DatabaseService(id: docs.documentID)
                            .updateAsReadNotif();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => NotificationDetail(
                              notificationData: docs,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(
                                Icons.notifications_active,
                                color: docs['read']
                                    ? Colors.grey
                                    : ThemeApp.bluePrimary,
                              ),
                              title: Text(
                                docs['title'],
                                style: TextStyle(
                                  fontSize: ScreenUtil.getInstance().setSp(35),
                                ),
                              ),
                              subtitle: Text(
                                'Tanggal: ${_dateFormat.format(docs['created_at'].toDate())}',
                                style: TextStyle(
                                  fontSize: ScreenUtil.getInstance().setSp(20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              } else {
                return Container(
                  child: Center(
                    child: TongsWidget.loadingData(),
                  ),
                );
              }
            },
          ),
          countNotif > 0
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 100,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          DatabaseService(id: widget.userUID)
                              .getNotifications(read: false, verif: true)
                              .then((value) {
                            for (int i = 0; i < value.documents.length; i++) {
                              DatabaseService(id: value.documents[i].documentID)
                                  .updateAsReadNotif();
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white,
                            boxShadow: [
                              new BoxShadow(
                                color: Colors.black38,
                                blurRadius: 5.0,
                              ),
                            ],
                          ),
                          margin: EdgeInsets.only(bottom: 10),
                          child: Text("Tandai semua dibaca"),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Future getCountNotif() async {
    try {
      DatabaseService(id: widget.userUID)
          .getNotifications(read: false, verif: true)
          .then((notifications) {
        setState(() {
          countNotif = notifications.documents.length;
        });
      });
    } catch (e) {}
  }
}

class NotVerifed extends StatefulWidget {
  final String userUID;

  NotVerifed({@required this.userUID});

  @override
  _NotVerifedState createState() => _NotVerifedState();
}

class _NotVerifedState extends State<NotVerifed> {
  final _dateFormat = DateFormat("dd/MM/yyyy");
  int countNotif = 0;

  @override
  void setState(fn) {
    if (this.mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    getCountNotif();
    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder(
            stream: _firestore
                .collection('notifications')
                .where('verifikasi', isEqualTo: false)
                .where('user_uid', isEqualTo: widget.userUID)
                .orderBy('updated_at', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.documents.length == 0) {
                  return TongsWidget.noData(
                    title: 'Belum ada pemberitahuan',
                    subtitle: 'Tidak ada data yang terverifikasi oleh admin',
                  );
                }
                return ListView(
                  padding: EdgeInsets.only(top: 10),
                  children: snapshot.data.documents.map((docs) {
                    return InkWell(
                      onTap: () {
                        DatabaseService(id: docs.documentID)
                            .updateAsReadNotif();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => NotificationDetail(
                              notificationData: docs,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(
                                Icons.notifications_active,
                                color: docs['read']
                                    ? Colors.grey
                                    : ThemeApp.bluePrimary,
                              ),
                              title: Text(
                                docs['title'],
                                style: TextStyle(
                                  fontSize: ScreenUtil.getInstance().setSp(35),
                                ),
                              ),
                              subtitle: Text(
                                'Tanggal: ${_dateFormat.format(docs['created_at'].toDate())}',
                                style: TextStyle(
                                  fontSize: ScreenUtil.getInstance().setSp(20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              } else {
                return Container(
                  child: Center(
                    child: TongsWidget.loadingData(),
                  ),
                );
              }
            },
          ),
          countNotif > 0
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 100,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          DatabaseService(id: widget.userUID)
                              .getNotifications(read: false, verif: false)
                              .then((value) {
                            for (int i = 0; i < value.documents.length; i++) {
                              DatabaseService(id: value.documents[i].documentID)
                                  .updateAsReadNotif();
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white,
                            boxShadow: [
                              new BoxShadow(
                                color: Colors.black38,
                                blurRadius: 5.0,
                              ),
                            ],
                          ),
                          margin: EdgeInsets.only(bottom: 10),
                          child: Text("Tandai semua dibaca"),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Future getCountNotif() async {
    try {
      DatabaseService(id: widget.userUID)
          .getNotifications(read: false, verif: false)
          .then((notifications) {
        setState(() {
          countNotif = notifications.documents.length;
        });
      });
    } catch (e) {}
  }
}
