import 'package:flutter/material.dart';
import 'package:tongnyampah/utils/miscellaneous.dart';
import 'package:tongnyampah/utils/styles.dart';
import 'package:tongnyampah/services/auth.dart';

class WrapperAdminSuper extends StatefulWidget {
  WrapperAdminSuper({Key key, this.page}) : super(key: key);
  final int page;
  @override
  _WrapperAdminSuperState createState() => _WrapperAdminSuperState();
}

class _WrapperAdminSuperState extends State<WrapperAdminSuper> {
  void signOut() async {
    try {
      await BaseAuthService().signOut();
      Navigator.pushReplacementNamed(context, '/routepage');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('name'),
              accountEmail: Text('email'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  'N',
                  style: Styles.alertTitleStyle,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Keluar',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              leading: Icon(
                Icons.exit_to_app,
                size: 30.0,
                color: Color(0xFF070707),
              ),
              onTap: () {
                TongsWidget.tongsDialog(
                    context: context,
                    title: 'Keluar dari aplikasi',
                    content: 'Apakah anda akan keluar dari akun ini?',
                    buttons: <Widget>[
                      FlatButton(
                          child: Text('Ya'),
                          onPressed: () {
                            signOut();
                            Navigator.of(context).pop();
                          }),
                      FlatButton(
                          child: Text('Tidak'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ]);
              },
            )
          ],
        ),
      ),
      body: Container(
        child: Center(
            child: InkWell(
                onTap: () {
                  signOut();
                  // Navigator.of(context).pop();
                },
                child: Text('Admin Super'))),
      ),
    );
  }
}
