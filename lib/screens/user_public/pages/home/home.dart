import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tongnyampah/models/user.dart';
import 'package:tongnyampah/utils/miscellaneous.dart';
import 'package:tongnyampah/screens/user_public/pages/edusa/edusa.dart';
import 'package:tongnyampah/screens/user_public/pages/notifications/notifications.dart';
import 'package:tongnyampah/screens/user_public/wrapper.dart';
import 'package:tongnyampah/services/auth.dart';
import 'package:tongnyampah/services/database.dart';
import 'package:tongnyampah/services/feature.dart';
import 'package:tongnyampah/utils/color_theme.dart';
import 'package:tongnyampah/widgets/banner_slier_advertisement.dart';
import 'package:tongnyampah/widgets/education.dart';
import 'package:tongnyampah/widgets/feature_card.dart';
import 'package:tongnyampah/widgets/gift_card.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int lengthGift = 0;
  int countNotif = 0;
  bool apper = false;
  String gamification = '';
  String rank = '';
  String uid = '';
  String name = '';
  String email = '';
  String point = '0';

  File image;
  File kirimImage;
  String filename = '';
  String namaShared = '';
  String second = '';

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
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
    getLengthGift();
    cekGemifications();
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
                          'Tong Nyampah',
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
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => NotificationsPage(
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
              body: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowGlow();
                  return false;
                },
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 0),
                        height: 100,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  // color: ThemeApp.bluePrimary,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Center(child: Image.asset(gamification)),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Hai, ${name.split(' ').first}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: ScreenUtil.getInstance().setSp(
                                        40,
                                      )),
                                ),
                                Text(
                                  '$point Poin',
                                  style: TextStyle(
                                      fontSize: ScreenUtil.getInstance().setSp(
                                    30,
                                  )),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      //Menu Feature
                      Container(
                        padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
                        child: Text(
                          'Ayo Dapatkan Point',
                          style: TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(40),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 15.0),
                        height: 150.0,
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          primary: false,
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            SizedBox(width: 15),
                            FeatureCard(
                              icon: Image.asset(
                                'assets/images/logos/icon-blue.png',
                                width: 45.0,
                              ),
                              title: 'Sampah',
                              onTap: () {
                                TongsWidget.loadingPageIndicator(
                                    context: context);
                                BaseFeature.getImage(
                                  context: context,
                                  titleBar: 'Buang Sampah',
                                  typeFeature: 'foto_buang_sampah',
                                );
                              },
                            ),
                            FeatureCard(
                              icon: Icon(
                                Icons.restore,
                                size: 60.0,
                                color: ThemeApp.bluePrimary,
                              ),
                              title: 'Daur Ulang',
                              margin: EdgeInsets.only(left: 15.0),
                              onTap: () {
                                TongsWidget.loadingPageIndicator(
                                    context: context);
                                BaseFeature.getImage(
                                  context: context,
                                  titleBar: 'Daur Ulang',
                                  typeFeature: 'foto_daur_ulang',
                                );
                              },
                            ),
                            FeatureCard(
                              icon: Icon(
                                Icons.report,
                                size: 60.0,
                                color: ThemeApp.bluePrimary,
                              ),
                              title: 'Laporkan',
                              margin: EdgeInsets.only(left: 15.0, right: 15.0),
                              onTap: () {
                                TongsWidget.loadingPageIndicator(
                                    context: context);
                                BaseFeature.getImage(
                                  context: context,
                                  titleBar: 'Tukang Nyampah',
                                  typeFeature: 'foto_tukang_nyampah',
                                );
                              },
                            )
                          ],
                        ),
                      ),
                      //END
                      //Slider Banner
                      Container(
                        padding: EdgeInsets.fromLTRB(15.0, 35.0, 15.0, 0),
                        child: Container(
                            height: 170,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // color: ThemeApp.bluePrimary,
                            ),
                            child: BannerSliderAdvertisement()),
                      ),
                      //End
                      //Store point
                      Container(
                        padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Text(
                                'Tukar Poin',
                                style: TextStyle(
                                  fontSize: ScreenUtil.getInstance().setSp(40),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Container(
                              child: GestureDetector(
                                child: Text(
                                  'Semua (${lengthGift.toString()})',
                                  style: TextStyle(
                                    color: ThemeApp.bluePrimary,
                                    fontSize:
                                        ScreenUtil.getInstance().setSp(25),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context)
                                    ..pop()
                                    ..push(MaterialPageRoute(
                                      builder: (context) => WrapperPublic(
                                        page: 1,
                                      ),
                                    ));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Gift
                      GiftCard(),
                      //END
                      Container(
                        padding: EdgeInsets.fromLTRB(15.0, 35.0, 15.0, 15.0),
                        child: Text(
                          'Edukasi Lingkungan Hidup',
                          style: TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(40),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      //Education
                      Educations()
                      //END
                    ],
                  ),
                ),
              ),
            ),
          )
        : TongsWidget.loadingData();
  }

  Future getUserData() async {
    await BaseAuthService().getUserData().then((user) {
      DatabaseService(id: user.uid).getUserData().then((data) {
        setState(() {
          uid = user.uid;
          name = data['name'];
          point = data['point'].toString();
          email = user.email;
          apper = true;
        });
        return User(
            uid: user.uid,
            email: user.email,
            data: DatabaseService(id: user.uid).getUserData());
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

  Future getLengthGift() async {
    try {
      DatabaseService(id: uid).getGift().then((gift) {
        setState(() {
          lengthGift = gift.documents.length;
        });
      });
    } catch (e) {}
  }

  void cekGemifications() async {
    if (int.parse(point) <= 500) {
      setState(() {
        gamification = 'assets/images/gamifications/bronze.png';
        rank = 'Bronze';
      });
    } else if (int.parse(point) <= 1000) {
      setState(() {
        gamification = 'assets/images/gamifications/silver.png';
        rank = 'Silver';
      });
    } else {
      setState(() {
        gamification = 'assets/images/gamifications/gold.png';
        rank = 'Gold';
      });
    }
  }
}
