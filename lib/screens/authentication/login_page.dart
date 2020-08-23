import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tongnyampah/screens/authentication/create_acount.dart';
import 'package:tongnyampah/services/auth.dart';
import 'package:tongnyampah/services/database.dart';
import 'package:tongnyampah/utils/color_theme.dart';
import 'package:tongnyampah/utils/miscellaneous.dart';
import 'package:tongnyampah/utils/styles.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.loginCallback}) : super(key: key);

  final VoidCallback loginCallback;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _key = GlobalKey<FormState>();
  final _scrollContreller = ScrollController();
  bool _pripacyPolicy = false;
  bool _isEmail = false;
  bool _isPassword = false;
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  _LoginPageState() {
    _email.addListener(() {
      if (_email.text.isEmpty) {
        setState(() {
          _isEmail = false;
        });
      } else {
        setState(() {
          _isEmail = true;
        });
      }
    });
    _password.addListener(() {
      if (_password.text.isEmpty) {
        setState(() {
          _isPassword = false;
        });
      } else {
        setState(() {
          _isPassword = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
          ..init(context);
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
        body: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/images/first_page_bottom.png',
                width: ScreenUtil.getInstance().width,
              ),
            ),
            SafeArea(
              child: ListView(
                physics: BouncingScrollPhysics(),
                controller: _scrollContreller,
                shrinkWrap: true,
                children: [
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          padding: EdgeInsets.all(70.0),
                          child: Image.asset(
                            'assets/images/logos/typo.png',
                          ),
                        ),
                      ),
                      Container(
                        child: Positioned(
                          top: 50,
                          child: Image.asset(
                            'assets/images/first_page_image.png',
                            height: 200,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    color: Colors.white,
                    child: Form(
                      key: _key,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Email', style: Styles.TitleTextFieldStyle),
                            TextFormField(
                              validator: (value) {
                                Pattern pattern =
                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                RegExp regex = new RegExp(pattern);
                                if (value.isEmpty) {
                                  return 'Email tidak boleh kosong';
                                } else if (!regex.hasMatch(value))
                                  return 'Email tidak benar';
                                else
                                  return null;
                              },
                              controller: _email,
                              style: Styles.InputTextFieldStyle,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  hintText: 'nama@example.com',
                                  hintStyle: Styles.HintTextFieldStyle),
                            ),
                            SizedBox(
                              height: ScreenUtil.getInstance().setHeight(30),
                            ),
                            Text('Kata Sandi',
                                style: Styles.TitleTextFieldStyle),
                            TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Kata sandi tidak boleh kosong';
                                }
                                return null;
                              },
                              controller: _password,
                              style: Styles.InputTextFieldStyle,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              decoration: InputDecoration(
                                  hintText: 'kata sandi',
                                  hintStyle: Styles.HintTextFieldStyle),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(35),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                    ),
                    height: 45,
                    child: Row(
                      children: [
                        Checkbox(
                          value: _pripacyPolicy,
                          onChanged: (bool newValue) {
                            setState(() {
                              _pripacyPolicy = newValue;
                              print(_pripacyPolicy);
                            });
                          },
                        ),
                        Text(
                          "Saya setuju dengan",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil.getInstance().setSp(25),
                          ),
                        ),
                        SizedBox(width: 5),
                        GestureDetector(
                          onTap: () =>
                              Navigator.of(context).pushNamed('/privacypolicy'),
                          child: Text(
                            "Syarat & Ketentuan",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.red,
                              fontSize: ScreenUtil.getInstance().setSp(25),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(35),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: (!_pripacyPolicy || !_isEmail || !_isPassword)
                            ? ThemeApp.bluePrimary.withOpacity(0.5)
                            : ThemeApp.bluePrimary,
                        borderRadius: BorderRadius.circular(25)),
                    height: 45,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      onPressed: (!_pripacyPolicy || !_isEmail || !_isPassword)
                          ? null
                          : () =>
                              _onSubmit(context, _email.text, _password.text),
                      child: Text(
                        "MASUK",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil.getInstance().setSp(25),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      horizontalLine(),
                      Text('Atau',
                          style: TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(25),
                            fontFamily: 'Poppins-Medium',
                          )),
                      horizontalLine(),
                    ],
                  ),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        width: 2,
                        color: ThemeApp.bluePrimary,
                      ),
                    ),
                    height: 45,
                    child: FlatButton.icon(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      onPressed: () {
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
                      icon: Image.asset(
                        'assets/images/icons/google-blue.png',
                        width: 20,
                      ),
                      label: Text(
                        "MASUK DENGAN GOOGLE",
                        style: TextStyle(
                          color: ThemeApp.bluePrimary,
                          fontSize: ScreenUtil.getInstance().setSp(25),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Belum Terdaftar? ',
                        style: TextStyle(
                            color: ThemeApp.textPrimary,
                            fontSize: ScreenUtil.getInstance().setSp(25)),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CreateAcount(
                                loginCallback: widget.loginCallback,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'DAFTAR',
                          style: TextStyle(
                            color: ThemeApp.bluePrimary,
                            fontSize: ScreenUtil.getInstance().setSp(25),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 100),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: ScreenUtil.getInstance().setWidth(120),
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );

  _onSubmit(BuildContext context, String email, String password) async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_key.currentState.validate() && _pripacyPolicy) {
      TongsWidget.loadingPageIndicator(context: context);
      try {
        dynamic user =
            await BaseAuthService().signIn(_email.text, _password.text);
        print(user);
        if (user.length > 0 && user != null) {
          DatabaseService(id: user).getUserData().then((userData) {
            print(userData['role'] + " Rolenyaa");
          }).whenComplete(() {
            widget.loginCallback();
          });
        } else {
          print('not callback');
        }
        print('user = ' + user.toString());
      } catch (e) {
        Navigator.pop(context);
        TongsWidget.tongsDialog(
            context: context,
            title: 'Mohon Maaf',
            content: 'Mohon cek kembali email dan password anda',
            buttons: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              )
            ]);
        print('error :' + e.toString());
      }
    }
  }
}
