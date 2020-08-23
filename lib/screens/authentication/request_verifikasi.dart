import 'package:flutter/material.dart';
import 'package:tongnyampah/services/auth.dart';
import 'package:tongnyampah/utils/color_theme.dart';

class RequestVerifikasiPage extends StatefulWidget {
  RequestVerifikasiPage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuthService auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  _RequestVerifikasiPageState createState() => _RequestVerifikasiPageState();
}

class _RequestVerifikasiPageState extends State<RequestVerifikasiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Anda belum Verifikasi Email',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Mohon lakukan verifikasi terlebihdahulu',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13.0, color: Colors.grey),
                ),
                SizedBox(height: 10.0),
                ButtonTheme(
                  minWidth: 80,
                  height: 40,
                  child: FlatButton(
                      child: Text('Sudah Verifikasi ',
                          style: TextStyle(color: Colors.white)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        // side: side != null ? side : BorderSide(color: Colors.transparent, width: 0,),
                      ),
                      color: ThemeApp.bluePrimary,
                      onPressed: () {
                        widget.logoutCallback();
                      }),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Minta verifikasi ulang? ',
                      style:
                          TextStyle(color: ThemeApp.textPrimary, fontSize: 12),
                    ),
                    Material(
                      child: InkWell(
                        onTap: () {
                          widget.auth.sendEmailVerification();
                        },
                        child: Text('Kirim Verifikasi',
                            style: TextStyle(
                                color: ThemeApp.bluePrimary, fontSize: 12)),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                Material(
                  child: InkWell(
                    onTap: () {
                      widget.auth.signOut();
                      widget.logoutCallback();
                    },
                    child: Text('Logout',
                        style: TextStyle(
                            color: ThemeApp.bluePrimary, fontSize: 12)),
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
