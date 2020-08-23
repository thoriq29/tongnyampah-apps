import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tongnyampah/utils/miscellaneous.dart';
import 'package:tongnyampah/screens/user_public/pages/edusa/edusa.dart';
import 'package:tongnyampah/screens/user_public/pages/history/history_buang_sampah.dart';
import 'package:tongnyampah/screens/user_public/pages/history/history_daur_ulang.dart';
import 'package:tongnyampah/screens/user_public/pages/history/history_laporkan_tukang_nyampah.dart';
import 'package:tongnyampah/services/auth.dart';
import 'package:tongnyampah/services/database.dart';
import 'package:tongnyampah/services/feature.dart';
import 'package:tongnyampah/utils/color_theme.dart';
import 'package:tongnyampah/widgets/history_card.dart';

import '../../wrapper.dart';
import '../notifications/notifications.dart';
import 'history_tukar_point.dart';

class Historis extends StatefulWidget {
  Historis({Key key}) : super(key: key);
  @override
  _HistorisState createState() => _HistorisState();
}

class _HistorisState extends State<Historis> {
  bool apper = false;
  String uid = '';
  String name = '';
  String email = '';
  int countNotif = 0;

  File image;
  File kirimImage;
  String filename = '';
  String namaShared = '';
  String second = '';

  final _scrollController = ScrollController();

  @override
  void initState() {
    getUserData();
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
    getUserData();
    getCountNotif();
    return apper
        ? Scaffold(
            backgroundColor: Colors.white,
            endDrawer: Drawer(
              child: ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text(
                      '$name',
                      style: TextStyle(color: Colors.white),
                    ),
                    accountEmail: Text(email),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                        '${name.substring(0, 1)}',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Buang Sampah',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    leading: Image.asset(
                      'assets/images/logos/icon-blue.png',
                      width: 25.0,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      TongsWidget.loadingPageIndicator(context: context);
                      BaseFeature.getImage(
                        context: context,
                        titleBar: 'Buang Sampah',
                        typeFeature: 'foto_buang_sampah',
                      );
                    },
                  ),
                  Divider(
                    height: 1,
                    indent: 0,
                    color: Colors.grey[400],
                  ),
                  ListTile(
                    title: Text(
                      'Daur Ulang',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    leading: Icon(
                      Icons.restore,
                      size: 30.0,
                      color: ThemeApp.bluePrimary,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      TongsWidget.loadingPageIndicator(context: context);
                      BaseFeature.getImage(
                        context: context,
                        titleBar: 'Daur Ulang',
                        typeFeature: 'foto_daur_ulang',
                      );
                    },
                  ),
                  Divider(
                    height: 1,
                    indent: 0,
                    color: Colors.grey[400],
                  ),
                  ListTile(
                    title: Text(
                      'Laporkan',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    leading: Icon(
                      Icons.report,
                      size: 30.0,
                      color: ThemeApp.bluePrimary,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      TongsWidget.loadingPageIndicator(context: context);
                      BaseFeature.getImage(
                        context: context,
                        titleBar: 'Tukang Nyampah',
                        typeFeature: 'foto_tukang_nyampah',
                      );
                    },
                  ),
                  Divider(
                    height: 1,
                    indent: 0,
                    color: Colors.grey[400],
                  ),
                  ListTile(
                    title: Text(
                      'Edukasi Sampah',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    leading: Icon(
                      Icons.collections_bookmark,
                      size: 30.0,
                      color: ThemeApp.bluePrimary,
                    ),
                    onTap: () {
                      Navigator.of(context)
                        ..pop()
                        ..push(
                          MaterialPageRoute(
                            builder: (context) => Edusa(),
                          ),
                        );
                    },
                  ),
                  Divider(
                    height: 1,
                    indent: 0,
                    color: Colors.grey[400],
                  ),
                  ListTile(
                    title: Text(
                      'Tukar Poin',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    leading: Icon(
                      Icons.shopping_cart,
                      size: 30.0,
                      color: ThemeApp.bluePrimary,
                    ),
                    onTap: () {
                      Navigator.of(context)
                        ..pop()
                        ..push(
                          MaterialPageRoute(
                            builder: (context) => WrapperPublic(
                              page: 1,
                            ),
                          ),
                        );
                    },
                  ),
                  Divider(
                    height: 1,
                    indent: 0,
                    color: Colors.grey[400],
                  ),
                  ListTile(
                    title: Text(
                      'Riwayat',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    leading: Icon(
                      Icons.history,
                      size: 30.0,
                      color: ThemeApp.bluePrimary,
                    ),
                    onTap: () {
                      Navigator.of(context)
                        ..pop()
                        ..push(
                          MaterialPageRoute(
                            builder: (context) => WrapperPublic(
                              page: 2,
                            ),
                          ),
                        );
                    },
                  ),
                  Divider(
                    height: 1,
                    indent: 0,
                    color: Colors.grey[400],
                  ),
                  ListTile(
                    title: Text(
                      'Keluar',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    leading: Icon(
                      Icons.exit_to_app,
                      size: 30.0,
                      color: Colors.red,
                    ),
                    onTap: () {
                      TongsWidget.tongsDialog(
                        context: context,
                        title: 'Konfirmasi',
                        content: 'Apakah anda akan keluar dari akun ini?',
                        buttons: <Widget>[
                          FlatButton(
                              child: Text('Ya'),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await BaseAuthService().signOut();
                                Navigator.pushReplacementNamed(
                                    context, '/routepage');
                              }),
                          FlatButton(
                              child: Text('Tidak'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                        ],
                      );
                    },
                  ),
                  Divider(
                    height: 1,
                    indent: 0,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 50)
                ],
              ),
            ),
            body: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (BuildContext context, bool isScrolled) {
                  return [
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                      sliver: SliverSafeArea(
                        top: false,
                        bottom: false,
                        sliver: SliverAppBar(
                          elevation: 0.5,
                          automaticallyImplyLeading: false,
                          pinned: true,
                          floating: true,
                          title: Text(
                            'Riwayat',
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(40),
                                fontWeight: FontWeight.bold),
                          ),
                          flexibleSpace: Container(
                              decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 5.0,
                              ),
                            ],
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
                          )),
                          actions: <Widget>[
                            Stack(
                              children: <Widget>[
                                IconButton(
                                  padding: EdgeInsets.only(top: 10),
                                  icon: Icon(Icons.notifications,
                                      size: 30.0, color: Colors.white),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NotificationsPage(
                                                  userUID: uid,
                                                )));
                                  },
                                ),
                                countNotif != 0
                                    ? Positioned(
                                        right: 10,
                                        top: 15,
                                        child: Container(
                                          padding: EdgeInsets.all(0.5),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          constraints: BoxConstraints(
                                            minWidth: 13,
                                            minHeight: 13,
                                          ),
                                          child: Center(
                                            child: Text(
                                              countNotif.toString() ?? '0',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 9,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.menu,
                                size: 30.0,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Scaffold.of(context).openEndDrawer();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                body: SingleChildScrollView(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: <Widget>[
                      HistoryCard(
                        title: 'Riwayat Tukar Poin',
                        width: ScreenUtil.getInstance().width,
                        image: 'assets/images/tukar_point.png',
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HistoryTukarPoint(
                              userUID: uid,
                            ),
                          ));
                        },
                      ),
                      HistoryCard(
                        title: 'Riwayat Buang Sampah',
                        width: ScreenUtil.getInstance().width,
                        image: 'assets/images/buang_sampah.png',
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HistoryBuangSampah(
                              userUID: uid,
                            ),
                          ));
                        },
                      ),
                      HistoryCard(
                        title: 'Riwayat Daur Ulang',
                        width: ScreenUtil.getInstance().width,
                        image: 'assets/images/daur_ulang.png',
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HistoryDaurUlang(
                              userUID: uid,
                            ),
                          ));
                        },
                      ),
                      HistoryCard(
                        title: 'Riwayat Laporkan Tukang Nyampah',
                        width: ScreenUtil.getInstance().width,
                        image: 'assets/images/laporkan.png',
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HistoryLaporkanTukangNyampah(
                              userUID: uid,
                            ),
                          ));
                        },
                      ),
                    ],
                  ),
                )),
          )
        : TongsWidget.loadingData();
  }

  Future getUserData() async {
    await BaseAuthService().getUserData().then((user) {
      DatabaseService(id: user.uid).getUserData().then((data) {
        setState(() {
          uid = user.uid;
          name = data['name'];
          email = user.email;
          apper = true;
        });
      });
    });
  }

  Future getCountNotif() async {
    try {
      DatabaseService(id: uid)
          .getNotifications(read: false)
          .then((notifications) {
        setState(() {
          countNotif = notifications.documents.length;
        });
      });
    } catch (e) {}
  }
}
