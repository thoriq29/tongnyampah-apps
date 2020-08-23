import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tongnyampah/screens/user_public/pages/edusa/edusa.dart';
import 'package:tongnyampah/screens/user_public/pages/edusa/edusa_detail.dart';
import 'package:tongnyampah/utils/color_theme.dart';

class Educations extends StatefulWidget {
  @override
  _EducationsState createState() => _EducationsState();
}

class _EducationsState extends State<Educations> {
  Firestore _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          _firestore.collection('educations').orderBy('created_at').snapshots(),
      builder: ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return Container(
            padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(
                snapshot.data.documents.length <= 6
                    ? snapshot.data.documents.length
                    : 6,
                (index) {
                  DocumentSnapshot educationsData =
                      snapshot.data.documents[index];
                  return index !=
                          (snapshot.data.documents.length <= 6
                              ? snapshot.data.documents.length - 1
                              : 5)
                      ? Container(
                          padding: EdgeInsets.only(bottom: 15, top: 15),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EdusaDetail(
                                    dataEdusa: educationsData,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 5),
                              height: 110,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            padding:
                                                EdgeInsets.only(bottom: 5.0),
                                            child: Text(
                                              educationsData['title'],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                              style: TextStyle(
                                                fontSize:
                                                    ScreenUtil.getInstance()
                                                        .setSp(30),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              educationsData['creator'],
                                              style: TextStyle(
                                                  fontFamily: 'Poppins-Italic'),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: 100,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: FadeInImage.assetNetwork(
                                        placeholder:
                                            'assets/images/placeholders/artikel.png',
                                        image: educationsData['cover'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => Edusa())),
                          child: Container(
                            padding: EdgeInsets.only(bottom: 40),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text('Lihat semua'),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      color: ThemeApp.bluePrimary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.navigate_next,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                },
              ),
            ),
          );
        } else {
          return Container();
        }
      }),
    );
  }
}
