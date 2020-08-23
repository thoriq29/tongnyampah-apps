import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tongnyampah/services/auth.dart';
import 'package:tongnyampah/services/database.dart';
import 'package:tongnyampah/utils/color_theme.dart';
import 'package:tongnyampah/utils/miscellaneous.dart';
import 'package:tongnyampah/utils/styles.dart';

class EditProfile extends StatefulWidget {
  final String uid;
  final String name;
  final String phone;
  final String email;
  EditProfile({
    @required this.uid,
    @required this.name,
    @required this.phone,
    @required this.email,
  });

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _key = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    setUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
          ..init(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: TongsWidget.appBar(title: 'Edit Profil'),
      bottomSheet: Container(
          color: ThemeApp.bluePrimary,
          width: ScreenUtil.getInstance().width,
          height: 56,
          child: FlatButton(
            onPressed: () {
              TongsWidget.loadingPageIndicator(context: context);
              DatabaseService(id: widget.uid).updateDataUser({
                'name': _nameController.text,
                'phone': _phoneController.text,
                'email': _emailController.text,
              }).whenComplete(() {
                Navigator.of(context).pop();
                TongsWidget.tongsDialog(
                  context: context,
                  title: 'Diperbarui',
                  content: 'Data anda telah diperbarui',
                  buttons: [
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context)..pop()..pop();
                      },
                      child: Text("Ok"),
                    )
                  ],
                );
              });
            },
            child: Center(
              child: Text(
                'Simpan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil.getInstance().setSp(35),
                ),
              ),
            ),
          )),
      body: ListView(
        padding: EdgeInsets.all(15),
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          Form(
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
                    controller: _nameController,
                    style: Styles.InputTextFieldStyle,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: 'nama lengkap',
                        hintStyle: Styles.HintTextFieldStyle),
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(30),
                  ),
                  Text('Nomor Handphone', style: Styles.TitleTextFieldStyle),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Nomor Headphone tidak boleh kosong';
                      }
                      return null;
                    },
                    controller: _phoneController,
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
                    readOnly: true,
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
                    controller: _emailController,
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
                    readOnly: true,
                    onTap: () {
                      TongsWidget.tongsDialog(
                          context: context,
                          title: 'Konfirmasi',
                          content: 'Apakah anda ingin mengganti password?',
                          buttons: [
                            FlatButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                TongsWidget.loadingPageIndicator(
                                    context: context);
                                await BaseAuthService()
                                    .resetPassword(widget.email)
                                    .whenComplete(() {
                                  Navigator.of(context).pop();
                                  TongsWidget.tongsDialog(
                                    context: context,
                                    title: 'Pemberitahuan',
                                    content:
                                        'Anda telah melakukan request password, silahkan cek email anda.',
                                    buttons: [
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Ok",
                                        ),
                                      ),
                                    ],
                                  );
                                });
                              },
                              child: Text(
                                "Ok",
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Batal",
                              ),
                            ),
                          ]);
                    },
                    style: Styles.InputTextFieldStyle,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                        ),
                        hintText: 'Ubah kata sandi',
                        hintStyle: Styles.HintTextFieldStyle),
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(30),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: ScreenUtil.getInstance().setHeight(35),
          ),
        ],
      ),
    );
  }

  Future setUserData() async {
    setState(() {
      _nameController = TextEditingController(text: widget.name);
      _phoneController = TextEditingController(text: widget.phone);
      _emailController = TextEditingController(text: widget.email);
    });
  }
}
