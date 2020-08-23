import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tongnyampah/services/auth.dart';
import 'package:tongnyampah/services/database.dart';
import 'package:tongnyampah/utils/color_theme.dart';
import 'package:tongnyampah/utils/miscellaneous.dart';
import 'package:tongnyampah/utils/styles.dart';
import 'package:tongnyampah/widgets/clipper.dart';

class CreateAcount extends StatefulWidget {
  CreateAcount({Key key, this.loginCallback}) : super(key: key);

  final VoidCallback loginCallback;
  @override
  _CreateAcountState createState() => _CreateAcountState();
}

class _CreateAcountState extends State<CreateAcount> {
  final _key = GlobalKey<FormState>();
  bool _pripacyPolicy = false;
  bool _isName = false;
  bool _isPhone = false;
  bool _isEmail = false;
  bool _isPassword1 = false;
  bool _isPassword2 = false;
  TextEditingController _name = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password1 = TextEditingController();
  TextEditingController _password2 = TextEditingController();

  _CreateAcountState() {
    _name.addListener(() {
      if (_name.text.isEmpty) {
        setState(() {
          _isName = false;
        });
      } else {
        setState(() {
          _isName = true;
        });
      }
    });
    _phone.addListener(() {
      if (_phone.text.isEmpty) {
        setState(() {
          _isPhone = false;
        });
      } else {
        setState(() {
          _isPhone = true;
        });
      }
    });
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
    _password1.addListener(() {
      if (_password1.text.isEmpty) {
        setState(() {
          _isPassword1 = false;
        });
      } else {
        setState(() {
          _isPassword1 = true;
        });
      }
    });
    _password2.addListener(() {
      if (_password2.text.isEmpty) {
        setState(() {
          _isPassword2 = false;
        });
      } else {
        setState(() {
          _isPassword2 = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
          ..init(context);
    return Scaffold(
      appBar: TongsWidget.appBar(title: "Daftar"),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/images/first_page_bottom.png',
              width: ScreenUtil.getInstance().width,
            ),
          ),
          ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: [
              Stack(
                children: [
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
                    left: 16,
                    top: 40,
                    child: Text(
                      'Akun',
                      style: TextStyle(
                          fontSize: ScreenUtil.getInstance().setSp(50),
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    top: 70,
                    child: Text(
                      'Baru',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil.getInstance().setSp(50),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 16,
                    child: Image.asset(
                      'assets/images/daftar.png',
                      height: 150,
                    ),
                  )
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
                        Text('Nama Lengkap', style: Styles.TitleTextFieldStyle),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Nama Lengkap tidak boleh kosong';
                            }
                            return null;
                          },
                          controller: _name,
                          style: Styles.InputTextFieldStyle,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: 'nama lengkap',
                              hintStyle: Styles.HintTextFieldStyle),
                        ),
                        SizedBox(
                          height: ScreenUtil.getInstance().setHeight(30),
                        ),
                        Text('Nomor Handphone',
                            style: Styles.TitleTextFieldStyle),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Nomor Headphone tidak boleh kosong';
                            }
                            return null;
                          },
                          controller: _phone,
                          style: Styles.InputTextFieldStyle,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              hintText: 'nomor handphone',
                              hintStyle: Styles.HintTextFieldStyle),
                        ),
                        SizedBox(
                          height: ScreenUtil.getInstance().setHeight(30),
                        ),
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
                        Text('Kata Sandi', style: Styles.TitleTextFieldStyle),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Kata sandi tidak boleh kosong';
                            } else if (value.length <= 6) {
                              return 'Masukan lebih dari 6 karakter';
                            }
                            return null;
                          },
                          controller: _password1,
                          style: Styles.InputTextFieldStyle,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: InputDecoration(
                              hintText: 'kata sandi',
                              hintStyle: Styles.HintTextFieldStyle),
                        ),
                        SizedBox(
                          height: ScreenUtil.getInstance().setHeight(30),
                        ),
                        Text('Ulangi Kata Sandi',
                            style: Styles.TitleTextFieldStyle),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Kata sandi tidak boleh kosong';
                            } else if (value.length < 6) {
                              return 'Masukan lebih dari 6 karakter';
                            } else if (_password1.text != _password2.text) {
                              return 'Tidak sesuai';
                            }
                            return null;
                          },
                          controller: _password2,
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
                    color: (!_pripacyPolicy ||
                            !_isName ||
                            !_isPhone ||
                            !_isEmail ||
                            !_isPassword1 ||
                            !_isPassword2)
                        ? ThemeApp.bluePrimary.withOpacity(0.5)
                        : ThemeApp.bluePrimary,
                    borderRadius: BorderRadius.circular(25)),
                height: 45,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  onPressed: (!_pripacyPolicy ||
                          !_isName ||
                          !_isPhone ||
                          !_isEmail ||
                          !_isPassword1 ||
                          !_isPassword2)
                      ? null
                      : () => this._onSubmit(context, _name.text, _phone.text,
                          _email.text, _password1.text),
                  child: Text(
                    "Daftar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil.getInstance().setSp(25),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 100),
            ],
          ),
        ],
      ),
    );
  }

  void _onSubmit(BuildContext context, String name, String phone, String email,
      String password) async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_key.currentState.validate()) {
      TongsWidget.loadingPageIndicator(context: context);
      var createAt = DateTime.now();
      try {
        dynamic user = await BaseAuthService().signUp(email, password);
        // widget.auth.sendEmailVerification();
        print('user id: ' + user.toString());
        DatabaseService(id: user).createNewProfile(name, phone, createAt);
        if (user.length > 0 && user != null) {
          Navigator.pop(context);
          TongsWidget.tongsDialog(
              context: context,
              title: 'Terimakasih Telah Mendaftar',
              content: 'Apakah anda ingin langsung masuk?',
              buttons: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.loginCallback();
                    //   Navigator.of(context).pushReplacement(
                    //       MaterialPageRoute(builder: (context) => RootPage()));
                  },
                  child: Text('Ya'),
                ),
                FlatButton(
                  onPressed: () {
                    exit(0);
                  },
                  child: Text('Tidak'),
                )
              ]);
          // widget.loginCallback();
        } else {
          print('not callback');
        }
      } catch (e) {
        Navigator.pop(context);
        TongsWidget.tongsDialog(
            context: context,
            title: 'Mohon Maaf',
            content: 'Email yang anda masukan sudah terdaftar',
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
