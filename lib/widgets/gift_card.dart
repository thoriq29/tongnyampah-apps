import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tongnyampah/utils/miscellaneous.dart';
import 'package:tongnyampah/screens/user_public/pages/redeem/redeem_point_detail.dart';
import 'package:tongnyampah/utils/color_theme.dart';

class GiftCard extends StatefulWidget {
  GiftCard({this.categori});
  final String categori;

  @override
  _GiftCardState createState() => _GiftCardState();
}

class _GiftCardState extends State<GiftCard> {
  Firestore _firestore = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: StreamBuilder(
          stream: widget.categori != null
              ? _firestore
                  .collection('gifts')
                  .where('categori', isEqualTo: widget.categori)
                  .snapshots()
              : _firestore.collection('gifts').limit(5).snapshots(),
          builder:
              ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: snapshot.data.documents.map((docs) {
                    return Container(
                      padding: EdgeInsets.only(left: 15, top: 15, bottom: 15),
                      child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5.0,
                            ),
                          ],
                        ),
                        child: Stack(
                          fit: StackFit.passthrough,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: FadeInImage.assetNetwork(
                                placeholder:
                                    'assets/images/placeholders/Framegift.png',
                                image: docs['image'],
                                fit: BoxFit.cover,
                              ),
                            ),
                            InkWell(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => RedeemPointDetail(
                                    dataGift: docs,
                                  ),
                                ),
                              ),
                              child: Container(
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    constraints:
                                        BoxConstraints.expand(height: 60.0),
                                    decoration: BoxDecoration(
                                      color: ThemeApp.bluePrimary,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10.0),
                                        bottomRight: Radius.circular(10.0),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.fromLTRB(
                                              18.0, 10.0, 18.0, 0.0),
                                          child: Text(
                                            docs['name'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.fromLTRB(
                                              18.0, 5.0, 18.0, 0.0),
                                          child: Text(
                                            docs['point'].toString(),
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 13.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList());
            } else {
              return Container(child: Center(child: TongsWidget.loadingData()));
            }
          })),
    );
  }
}
