import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tongnyampah/utils/miscellaneous.dart';
import 'package:tongnyampah/utils/color_theme.dart';

class BannerSliderAdvertisement extends StatefulWidget {
  @override
  _BannerSliderAdvertisementState createState() =>
      _BannerSliderAdvertisementState();
}

class _BannerSliderAdvertisementState extends State<BannerSliderAdvertisement> {
  Firestore _firestore = Firestore.instance;
  int _current = 1;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firestore.collection('advertisements').snapshots(),
        builder:
            ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Stack(
              children: <Widget>[
                CarouselSlider(
                  options: CarouselOptions(
                    height: 170,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    viewportFraction: 1.0,
                    onPageChanged: (int index, _) {
                      setState(() {
                        _current = index;
                      });
                    },
                  ),
                  items: snapshot.data.documents.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: ScreenUtil.getInstance().width,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: FadeInImage.assetNetwork(
                              fit: BoxFit.cover,
                              placeholder:
                                  'assets/images/placeholders/placeholder_iklan.png',
                              image: i['image'],
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                Positioned(
                    bottom: 0.0,
                    left: 10.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(snapshot.data.documents.length,
                          (index) {
                        for (int i = 0;
                            i < snapshot.data.documents.length;
                            i++) {}
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: 8.0,
                              height: 8.0,
                              margin: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 2.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _current == index
                                      ? ThemeApp.bluePrimary
                                      : Color.fromRGBO(0, 0, 0, 0.3)),
                            );
                          },
                        );
                      }).toList(),
                    ))
              ],
            );
          } else {
            return Center(child: TongsWidget.loadingData());
          }
        }));
  }
}
