import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tongnyampah/models/user.dart';
import 'package:tongnyampah/utils/miscellaneous.dart';
import 'package:tongnyampah/utils/styles.dart';
import 'package:tongnyampah/services/auth.dart';
import 'package:tongnyampah/services/database.dart';
import 'package:tongnyampah/utils/color_theme.dart';
import 'package:image/image.dart' as Im;

class FormPages extends StatefulWidget {
  FormPages(
      {Key key,
      @required this.titleBar,
      @required this.image,
      @required this.typeFeature,
      @required this.fileName})
      : super(key: key);

  final File image;
  final String titleBar;
  final String typeFeature;
  final String fileName;

  @override
  _FormPagesState createState() => _FormPagesState();
}

class _FormPagesState extends State<FormPages> {
  final _formKeyBuangSampah = GlobalKey<FormState>();
  final _formKeyDaurUlang = GlobalKey<FormState>();
  final _formKeyTukangNyamah = GlobalKey<FormState>();
  String uid = '';
  String classRoom = '';
  String foto = '';
  String detik = '';
  num point = 0;
  var url;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  Future saveDataFeature() async {
    try {
      //Function Save to Storage
      if (widget.image != null) {
        Im.Image fileImage = Im.decodeImage(widget.image.readAsBytesSync());
        Im.Image smallerImage = Im.copyResize(fileImage,
            width: 600); // choose the size here, it will maintain aspect ratio

        String sendToStorage =
            "feature-tongnyampah/" + widget.typeFeature + "/" + widget.fileName;
        File compressedImage = widget.image
          ..writeAsBytesSync(Im.encodeJpg(smallerImage, quality: 85));

        StorageReference ref =
            FirebaseStorage.instance.ref().child(sendToStorage);
        StorageUploadTask uploadTask = ref.putFile(compressedImage);

        var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
        url = downUrl.toString();

        //Fuction Upload to Firebase
        await DatabaseService().createNotifications(
          userUID: uid,
          point: widget.typeFeature == 'foto_buang_sampah'
              ? 50
              : widget.typeFeature == 'foto_daur_ulang' ? 200 : 150,
          url: url,
          title: _titleController.text,
          desc: _descriptionController.text,
          type: widget.typeFeature,
          descVerifed: '',
          status: 'Menunggu Verifikasi',
        );

        await DatabaseService().createPointHistory(
          title: widget.typeFeature == 'foto_buang_sampah'
              ? 'Membuang Sampah'
              : widget.typeFeature == 'foto_daur_ulang'
                  ? 'Mendaur Ulang Sampah'
                  : 'Melaporkan Tukang Sampah',
          pointBefore: point,
          pointDefference: widget.typeFeature == 'foto_buang_sampah'
              ? 50
              : widget.typeFeature == 'foto_daur_ulang' ? 200 : 150,
          type: widget.typeFeature,
          userUID: uid,
          verifed: false,
        );
      }
      Navigator.of(context)..pop()..pop();
      TongsWidget.tongsDialog(
          buttons: [
            FlatButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/homepublic');
                },
                child: Text('OK'))
          ],
          context: context,
          title: 'Terimakasih',
          content: widget.typeFeature == 'foto_buang_sampah'
              ? 'Anda telah membuang sampah pada tempatnya, mohon tunggu verifikasi data untuk mendapatkan poin.'
              : widget.typeFeature == 'foto_daur_ulang'
                  ? 'Anda telah daur ulang sampah dengan kreatif, mohon tunggu verifikasi data untuk mendapatkan poin.'
                  : 'Anda telah melaporkan tukang nyampah, mohon tunggu verifikasi data untuk mendapatkan poin.');
    } catch (e) {
      print(e);
      Navigator.of(context)..pop()..pop();
      TongsWidget.tongsDialog(
          buttons: [
            FlatButton(
                onPressed: () {
                  // Navigator.pushReplacementNamed(context, '/homepublic');
                  Navigator.of(context).pop();
                },
                child: Text('OK'))
          ],
          context: context,
          title: 'Ops, Maaf',
          content:
              'Sepertinya terjadi kesalahan tidak terduga, silahkan coba kembali.');
    }
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  void dispose() {
    this.dispose();
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
    return Scaffold(
      appBar: TongsWidget.appBar(title: widget.titleBar),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: ScreenUtil.getInstance().width,
                child: FadeInImage(
                  placeholder:
                      AssetImage('assets/images/BG_bottom_create_acount.png'),
                  fit: BoxFit.cover,
                  image: FileImage(widget.image),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: InkWell(
        onTap: () {
          if (widget.typeFeature == 'foto_buang_sampah') {
            showGeneralDialog(
                context: context,
                barrierDismissible: false,
                transitionDuration: Duration(milliseconds: 150),
                barrierLabel: '',
                barrierColor: Colors.black.withOpacity(0.6),
                pageBuilder: (context, animation1, animation2) {
                  return Container();
                },
                transitionBuilder: (BuildContext context, a1, a2, widget) {
                  return Transform.scale(
                    scale: a1.value,
                    child: Opacity(
                      opacity: a1.value,
                      child: WillPopScope(
                        onWillPop: () => Future.value(false),
                        child: AlertDialog(
                          contentPadding:
                              EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                          title: Text('Masukan Detail',
                              style: Styles.alertTitleStyle,
                              textAlign: TextAlign.center),
                          content: Container(child: formBuangSampah()),
                          backgroundColor: Colors.white.withOpacity(0.9),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          actions: [
                            FlatButton(
                              child: Text('Batal'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            FlatButton(
                              child: Text('Kirim'),
                              onPressed: () {
                                if (_formKeyBuangSampah.currentState
                                    .validate()) {
                                  //Loading Indicator
                                  TongsWidget.loadingPageIndicator(
                                      context: context);
                                  saveDataFeature();
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          } else if (widget.typeFeature == 'foto_daur_ulang') {
            showGeneralDialog(
                context: context,
                barrierDismissible: false,
                transitionDuration: Duration(milliseconds: 150),
                barrierLabel: '',
                barrierColor: Colors.black.withOpacity(0.6),
                pageBuilder: (context, animation1, animation2) {
                  return Container();
                },
                transitionBuilder: (BuildContext context, a1, a2, widget) {
                  return Transform.scale(
                    scale: a1.value,
                    child: Opacity(
                      opacity: a1.value,
                      child: WillPopScope(
                        onWillPop: () => Future.value(false),
                        child: AlertDialog(
                          contentPadding:
                              EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                          title: Text('Masukan Detail',
                              style: Styles.alertTitleStyle,
                              textAlign: TextAlign.center),
                          content: Container(child: formDaurUlang()),
                          backgroundColor: Colors.white.withOpacity(0.9),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          actions: [
                            FlatButton(
                              child: Text('Batal'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            FlatButton(
                              child: Text('Kirim'),
                              onPressed: () {
                                if (_formKeyDaurUlang.currentState.validate()) {
                                  //Loading Indicator
                                  TongsWidget.loadingPageIndicator(
                                      context: context);
                                  saveDataFeature();
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          } else if (widget.typeFeature == 'foto_tukang_nyampah') {
            showGeneralDialog(
                context: context,
                barrierDismissible: false,
                transitionDuration: Duration(milliseconds: 150),
                barrierLabel: '',
                barrierColor: Colors.black.withOpacity(0.6),
                pageBuilder: (context, animation1, animation2) {
                  return Container();
                },
                transitionBuilder: (BuildContext context, a1, a2, widget) {
                  return Transform.scale(
                    scale: a1.value,
                    child: Opacity(
                      opacity: a1.value,
                      child: WillPopScope(
                        onWillPop: () => Future.value(false),
                        child: AlertDialog(
                          contentPadding:
                              EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                          title: Text('Masukan Detail',
                              style: Styles.alertTitleStyle,
                              textAlign: TextAlign.center),
                          content: Container(child: formTukangNyampah()),
                          backgroundColor: Colors.white.withOpacity(0.9),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          actions: [
                            FlatButton(
                              child: Text('Batal'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            FlatButton(
                              child: Text('Kirim'),
                              onPressed: () {
                                if (_formKeyTukangNyamah.currentState
                                    .validate()) {
                                  //Loading Indicator
                                  TongsWidget.loadingPageIndicator(
                                      context: context);
                                  saveDataFeature();
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          } else {}
        },
        child: Container(
          height: 50.0,
          color: ThemeApp.bluePrimary,
          child: Center(
            child: Text(
              'Lanjutkan',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget formBuangSampah() {
    return Form(
      key: _formKeyBuangSampah,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(15),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                  onChanged: (value) {},
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Judul tidak boleh kosong';
                    }
                    return null;
                  },
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Judul',
                    hintStyle: TextStyle(
                      fontSize: ScreenUtil.getInstance().setSp(20),
                    ),
                    hintMaxLines: 2,
                    hintText: 'Misal. Sampah Plastik',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: ThemeApp.bluePrimary,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: TextFormField(
                  onChanged: (value) {},
                  controller: _descriptionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Penjelasan',
                    hintStyle: TextStyle(
                      fontSize: ScreenUtil.getInstance().setSp(20),
                    ),
                    hintText:
                        'Misal. Sampah plastik tergeletak di depan gerbang.',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: ThemeApp.bluePrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget formDaurUlang() {
    return Form(
      key: _formKeyDaurUlang,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(15),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                  onChanged: (value) {},
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Judul tidak boleh kosong';
                    }
                    return null;
                  },
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Judul',
                    hintStyle: TextStyle(
                      fontSize: ScreenUtil.getInstance().setSp(20),
                    ),
                    hintMaxLines: 2,
                    hintText: 'Misal. Tas Belanja',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: ThemeApp.bluePrimary,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: TextFormField(
                  onChanged: (value) {},
                  controller: _descriptionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Penjelasan',
                    hintStyle: TextStyle(
                      fontSize: ScreenUtil.getInstance().setSp(20),
                    ),
                    hintText:
                        'Misal. Tas belanja yang terbuat dari sampah bekas kopi.',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: ThemeApp.bluePrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget formTukangNyampah() {
    return Form(
      key: _formKeyTukangNyamah,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(15),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                  onChanged: (value) {},
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Judul tidak boleh kosong';
                    }
                    return null;
                  },
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Judul',
                    hintStyle: TextStyle(
                      fontSize: ScreenUtil.getInstance().setSp(20),
                    ),
                    hintMaxLines: 2,
                    hintText: 'Misal. Buang Sampah Sembarangan',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: ThemeApp.bluePrimary,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: TextFormField(
                  onChanged: (value) {},
                  controller: _descriptionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Penjelasan',
                    hintStyle: TextStyle(
                      fontSize: ScreenUtil.getInstance().setSp(20),
                    ),
                    hintText:
                        'Misal. Orang ini buang sampah sembarangan di area depan masjid',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: ThemeApp.bluePrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getUserData() async {
    await BaseAuthService().getUserData().then((user) {
      DatabaseService(id: user.uid).getUserData().then((data) {
        setState(() {
          uid = user.uid;
          point = data['point'];
        });
        return User(
            uid: user.uid,
            email: user.email,
            data: DatabaseService(id: user.uid).getUserData());
      });
    });
  }
}
