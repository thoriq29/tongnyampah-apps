import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tongnyampah/models/user.dart';
import 'package:tongnyampah/screens/user_public/pages/edusa/edusa.dart';
import 'package:tongnyampah/screens/user_public/pages/notifications/notifications.dart';
import 'package:tongnyampah/screens/user_public/pages/profile/edit_profile.dart';
import 'package:tongnyampah/screens/user_public/wrapper.dart';
import 'package:tongnyampah/services/feature.dart';
import 'package:tongnyampah/utils/miscellaneous.dart';
import 'package:tongnyampah/services/auth.dart';
import 'package:tongnyampah/services/database.dart';
import 'package:tongnyampah/utils/color_theme.dart';
import 'package:tongnyampah/widgets/clipper.dart';

class ProfileUser extends StatefulWidget {
  ProfileUser({Key key}) : super(key: key);
  @override
  _ProfileUserState createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  final _scrollController = ScrollController();
  String gamification = '';
  String rank = '';
  String uid = '';
  String name = '';
  String email = '';
  String phone = '';
  String point = '0';
  bool apper = false;
  int countNotif = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
    cekGemifications();
    getCountNotif();
    return apper
        ? Scaffold(
            backgroundColor: Colors.white,
            // appBar: TongsWidget.appBar(title: "Profil"),
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
                          'Profil',
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
                      Stack(
                        children: <Widget>[
                          ClipPath(
                            clipper: MyClipper(),
                            child: Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                colors: [
                                  ThemeApp.toscaPrimary,
                                  ThemeApp.bluePrimary,
                                ],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(1, 0.0),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp,
                              )),
                              width: double.infinity,
                              height: 200,
                            ),
                          ),
                          Positioned(
                            top: 30,
                            right: 25,
                            child: Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        ThemeApp.toscaPrimary.withOpacity(0.5),
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(150)),
                              child: Image.asset(
                                gamification,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 30,
                            left: 25,
                            child: Text(
                              name,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins-Medium',
                                fontSize: ScreenUtil.getInstance().setSp(40),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 55,
                            left: 25,
                            child: Text(
                              email,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil.getInstance().setSp(20),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 90,
                            left: 25,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.local_atm,
                                            color: Colors.white,
                                            size: 22,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            point,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Poppins-Medium',
                                              fontSize: ScreenUtil.getInstance()
                                                  .setSp(30),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Point Saya',
                                        style: TextStyle(
                                          color: Colors.white60,
                                          fontFamily: 'Poppins-Medium',
                                          fontSize: ScreenUtil.getInstance()
                                              .setSp(28),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: ScreenUtil.getInstance().setWidth(40),
                                ),
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.local_play,
                                            color: Colors.white,
                                            size: 22,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            rank,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Poppins-Medium',
                                              fontSize: ScreenUtil.getInstance()
                                                  .setSp(30),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Rank Saya',
                                        style: TextStyle(
                                          color: Colors.white60,
                                          fontFamily: 'Poppins-Medium',
                                          fontSize: ScreenUtil.getInstance()
                                              .setSp(28),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditProfile(
                                uid: uid,
                                name: name,
                                phone: phone,
                                email: email,
                              ),
                            ),
                          );
                        },
                        leading: Image.asset(
                          "assets/images/icons/edit-outline.png",
                          width: 35,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: ThemeApp.bluePrimary,
                        ),
                        title: Text(
                          "Edit Profil",
                          style: TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(30),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ListTile(
                        onTap: () {
                          // TODO
                          TongsWidget.tongsDialog(
                            context: context,
                            title: 'Insyaallah',
                            content: 'Akan Segera hadir.',
                            buttons: [
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Ok"),
                              ),
                            ],
                          );
                        },
                        leading: Image.asset(
                          "assets/images/icons/cupon.png",
                          width: 35,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: ThemeApp.bluePrimary,
                        ),
                        title: Text(
                          "Hadiah Saya",
                          style: TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(30),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ListTile(
                        onTap: () {
                          // TODO
                          TongsWidget.tongsDialog(
                            context: context,
                            title: 'Insyaallah',
                            content: 'Akan Segera hadir.',
                            buttons: [
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Ok"),
                              ),
                            ],
                          );
                        },
                        leading: Image.asset(
                          "assets/images/icons/share.png",
                          width: 35,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: ThemeApp.bluePrimary,
                        ),
                        title: Text(
                          "Berbagi Aplikasi",
                          style: TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(30),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ListTile(
                        onTap: () {
                          // TODO
                          Navigator.of(context).pushNamed('/aboutdeveloper');
                        },
                        leading: Image.asset(
                          "assets/images/icons/code.png",
                          width: 35,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: ThemeApp.bluePrimary,
                        ),
                        title: Text(
                          "Tentang Pengembang",
                          style: TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(30),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed('/privacypolicy');
                        },
                        leading: Image.asset(
                          "assets/images/icons/syarat-ketentuan.png",
                          width: 35,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: ThemeApp.bluePrimary,
                        ),
                        title: Text(
                          "Syarat & Ketentuan dan Kebijakan Privasi",
                          style: TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(30),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 100)
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
          phone = data['phone'];
          apper = true;
        });
        return User(
            uid: user.uid,
            email: user.email,
            data: DatabaseService(id: user.uid).getUserData());
      });
    });
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
