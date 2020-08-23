import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tongnyampah/screens/user_public/pages/redeem/redeem_point_detail.dart';
import 'package:tongnyampah/utils/miscellaneous.dart';
import 'package:tongnyampah/utils/color_theme.dart';

class BannerSliderGift extends StatefulWidget {
  @override
  _BannerSliderGiftState createState() => _BannerSliderGiftState();
}

class _BannerSliderGiftState extends State<BannerSliderGift> {
  Firestore _firestore = Firestore.instance;
  int _current = 1;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore
          .collection('gifts')
          .where('highlight', isEqualTo: true)
          .snapshots(),
      builder: ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.documents.length != 0) {
            return Padding(
              padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
              child: Stack(
                children: <Widget>[
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 260,
                      autoPlay: true,
                      enlargeCenterPage: false,
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
                    items: snapshot.data.documents.map((docs) {
                      return Builder(
                        builder: (BuildContext context) {
                          return GestureDetector(
                            onTap: () {
                              MaterialPageRoute(
                                builder: (context) => RedeemPointDetail(
                                  dataGift: docs,
                                ),
                              );
                            },
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  height: MediaQuery.of(context).size.height,
                                  margin: EdgeInsets.symmetric(horizontal: 7.0),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    color: Colors.white54,
                                  ),
                                  child: FadeInImage.assetNetwork(
                                    fit: BoxFit.cover,
                                    placeholder:
                                        'assets/images/placeholders/highlightgift.png',
                                    image: docs['image'],
                                  ),
                                ),
                                Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 7.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      // Add one stop for each color. Stops should increase from 0 to 1
                                      stops: [0.2, 0.7],
                                      colors: [
                                        Color.fromARGB(60, 0, 0, 0),
                                        Color.fromARGB(60, 0, 0, 0),
                                      ],
                                      // stops: [0.0, 0.1],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 160.0),
                                  child: Container(
                                    constraints:
                                        BoxConstraints.expand(height: 75.0),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 14.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            docs['name'],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.white,
                                              shadows: <Shadow>[
                                                Shadow(
                                                    color: Colors.black,
                                                    offset: Offset(0.0, 0.8),
                                                    blurRadius: 16.0),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 2.0),
                                            child: Text(
                                              docs['description'],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  Positioned(
                      bottom: 0.0,
                      left: 10.0,
                      right: 10.0,
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
                                      : Colors.white.withOpacity(0.5),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ))
                ],
              ),
            );
          } else {
            return Container();
          }
        } else {
          return Center(child: TongsWidget.loadingData());
        }
      }),
    );
  }
}
