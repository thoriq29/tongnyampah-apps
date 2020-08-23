import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tongnyampah/screens/user_public/pages/history/hostoris.dart';
import 'package:tongnyampah/screens/user_public/pages/redeem/redeem_point.dart';
import 'package:tongnyampah/screens/user_public/pages/home/home.dart';
import 'package:tongnyampah/screens/user_public/pages/profile/profile.dart';
import 'package:tongnyampah/services/auth.dart';
import 'package:tongnyampah/services/feature.dart';
import 'package:tongnyampah/utils/color_theme.dart';
import 'package:tongnyampah/widgets/fab_bottom_app_bar.dart';
import 'package:tongnyampah/utils/miscellaneous.dart';

class WrapperPublic extends StatefulWidget {
  WrapperPublic(
      {Key key, this.auth, this.userId, this.logoutCallback, this.page})
      : super(key: key);

  final BaseAuthService auth;
  final VoidCallback logoutCallback;
  final String userId;
  final int page;

  @override
  _WrapperPublicState createState() => _WrapperPublicState();
}

class _WrapperPublicState extends State<WrapperPublic> {
  final PageStorageBucket bucket = PageStorageBucket();
  PageController _myPage = PageController(initialPage: 0);
  int selectedIndex = 0;

  File image;
  File kirimImage;
  String phone = '';
  String filename = '';
  String namaShared = '';
  String second = '';

  @override
  void initState() {
    if (widget.page != null) {
      setState(() {
        _myPage = PageController(initialPage: widget.page);
        selectedIndex = widget.page;
      });
    }
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
    return WillPopScope(
      onWillPop: () {
        return TongsWidget.tongsDialog(
            context: context,
            title: 'Keluar dari aplikasi',
            content: 'Apakah anda akan keluar dari aplikasi ?',
            buttons: <Widget>[
              FlatButton(
                  child: Text('Ya'),
                  onPressed: () {
                    exit(0);
                  }),
              FlatButton(
                  child: Text('Tidak'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ]);
      },
      child: Scaffold(
        body: PageView(
          controller: _myPage,
          onPageChanged: (index) {
            print('Page Changes to index $index');
          },
          children: <Widget>[
            new HomePage(key: PageStorageKey('Page Home')),
            new RedeemPoint(key: PageStorageKey('Page Redeem')),
            new Historis(key: PageStorageKey('Page History')),
            new ProfileUser(key: PageStorageKey('Page Profile'))
          ],
          physics:
              NeverScrollableScrollPhysics(), // Comment this if you need to use Swipe.
        ),
        floatingActionButton: Container(
          height: 60.0,
          width: 60.0,
          child: FittedBox(
            child: FloatingActionButton(
                tooltip: 'Foto Sampah',
                backgroundColor: ThemeApp.bluePrimary,
                onPressed: () {
                  TongsWidget.loadingPageIndicator(context: context);
                  BaseFeature.getImage(
                    context: context,
                    titleBar: 'Buang Sampah',
                    typeFeature: 'foto_buang_sampah',
                  );
                },
                child: Image.asset(
                  'assets/images/logos/icon-white.png',
                  width: 30,
                )
                // elevation: 5.0,
                ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: FABBottomAppBar(
          color: ThemeApp.textPrimary,
          selectedColor: ThemeApp.bluePrimary,
          notchedShape: CircularNotchedRectangle(),
          selected: selectedIndex,
          onTabSelected: (index) {
            if (index != selectedIndex) {
              setState(() {
                selectedIndex = index;
                setState(() {
                  _myPage.jumpToPage(index);
                });
              });
            }
          },
          items: [
            FABBottomAppBarItem(iconData: Icons.home, text: 'Beranda'),
            FABBottomAppBarItem(iconData: Icons.shopping_cart, text: 'Tukar'),
            FABBottomAppBarItem(iconData: Icons.history, text: 'Riwayat'),
            FABBottomAppBarItem(iconData: Icons.person, text: 'Profil'),
          ],
        ),
      ),
    );
  }
}
