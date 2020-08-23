import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tongnyampah/screens/user_public/pages/home/form_pages.dart';
import 'package:tongnyampah/services/auth.dart';
import 'package:tongnyampah/services/database.dart';

class BaseFeature {
  static void getImage({
    @required BuildContext context,
    // @required String phone,
    @required String titleBar,
    @required String typeFeature,
  }) async {
    BaseAuthService().getCurrentUser().then((user) {
      DatabaseService(id: user.uid).getUserData().then((data) async {
        DateTime _secondNow = DateTime.now();
        File image;
        String filename;
        String second;
        var selectedImage = await ImagePicker.pickImage(
          source: ImageSource.camera,
        );

        second = DateFormat("hhmmss").format(_secondNow).toString();
        image = selectedImage;
        filename = data['phone'] + second + "_$typeFeature.jpg";

        if (image != null) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormPages(
                image: image,
                titleBar: titleBar,
                typeFeature: typeFeature,
                fileName: filename,
              ),
            ),
          );
        } else {
          Navigator.pop(context);
        }
      });
    });
  }
}
