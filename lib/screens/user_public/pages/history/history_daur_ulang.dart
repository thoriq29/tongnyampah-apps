import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tongnyampah/utils/miscellaneous.dart';
import 'package:tongnyampah/utils/color_theme.dart';

Firestore _firestore = Firestore.instance;
DateFormat f = DateFormat('EEEE, dd MMMM yyyy');

class HistoryDaurUlang extends StatefulWidget {
  HistoryDaurUlang({this.userUID});

  final String userUID;
  @override
  _HistoryDaurUlang createState() => _HistoryDaurUlang();
}

class _HistoryDaurUlang extends State<HistoryDaurUlang> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: TongsWidget.appBar(
            title: 'Riwayat Daur Ulang',
            bottom: TabBar(
              tabs: [
                Tab(text: 'Menunggu Verifikasi'),
                Tab(text: 'Terverifikasi'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              NotVerifed(userUID: widget.userUID),
              IsVerifed(userUID: widget.userUID),
            ],
          )),
    );
  }
}

class IsVerifed extends StatelessWidget {
  IsVerifed({this.userUID});

  final String userUID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder(
          stream: _firestore
              .collection('users')
              .document(userUID)
              .collection('point_history')
              .where('verifed', isEqualTo: true)
              .where('user_uid', isEqualTo: userUID)
              .where('type', isEqualTo: 'foto_daur_ulang')
              .orderBy('updated_at', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.documents.length == 0) {
                return TongsWidget.noData(
                  title: 'Belum ada pemberitahuan',
                  subtitle: 'Tidak ada data yang terverifikasi oleh admin',
                );
              }
              return ListView(
                padding: EdgeInsets.all(15),
                children: snapshot.data.documents.map((docs) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 35,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          child: FittedBox(
                            child: Text(
                              docs['title'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: ThemeApp.bluePrimary.withOpacity(0.1),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(6),
                            ),
                          ),
                        ),
                        Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  docs['point_defference'].toString() +
                                      ' Point',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ThemeApp.bluePrimary,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              Text(
                                docs['updated_at'] != null
                                    ? f
                                        .format(Timestamp(
                                                docs['updated_at'].seconds,
                                                docs['updated_at'].nanoseconds)
                                            .toDate())
                                        .toString()
                                    : "-",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey[200],
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Point Awal : ${docs['point_before'].toString()}',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  'Point Setelahnya : ${docs['point_after'].toString()}',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.grey[400],
                          offset: new Offset(0.0, 1.0),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(6),
                    ),
                  );
                }).toList(),
              );
            } else {
              return Container(
                child: Center(
                  child: TongsWidget.loadingData(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class NotVerifed extends StatelessWidget {
  NotVerifed({this.userUID});

  final String userUID;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder(
          stream: _firestore
              .collection('users')
              .document(userUID)
              .collection('point_history')
              .where('verifed', isEqualTo: false)
              .where('user_uid', isEqualTo: userUID)
              .where('type', isEqualTo: 'foto_daur_ulang')
              .orderBy('updated_at', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.documents.length == 0) {
                return TongsWidget.noData(
                  title: 'Belum ada pemberitahuan',
                  subtitle:
                      'Tidak ada data yang menunggu verifikasi oleh admin',
                );
              }
              return ListView(
                padding: EdgeInsets.all(15),
                children: snapshot.data.documents.map((docs) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 35,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          child: FittedBox(
                            child: Text(
                              docs['title'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: ThemeApp.bluePrimary.withOpacity(0.1),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(6),
                            ),
                          ),
                        ),
                        Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  docs['point_defference'].toString() +
                                      ' Point',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ThemeApp.bluePrimary,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              Text(
                                docs['updated_at'] != null
                                    ? f
                                        .format(Timestamp(
                                                docs['updated_at'].seconds,
                                                docs['updated_at'].nanoseconds)
                                            .toDate())
                                        .toString()
                                    : "-",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey[200],
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Point Awal : ${docs['point_before'].toString()}',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  'Point Setelahnya : ${docs['point_after'].toString()}',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.grey[400],
                          offset: new Offset(0.0, 1.0),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(6),
                    ),
                  );
                }).toList(),
              );
            } else {
              return Container(
                child: Center(
                  child: TongsWidget.loadingData(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
