import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final String id;
  Firestore _firestore = Firestore.instance;

  DatabaseService({this.id});

  Future<QuerySnapshot> getNotifications({bool read, bool verif}) async {
    return await _firestore
        .collection('notifications')
        .where('verifikasi', isEqualTo: verif)
        .where('read', isEqualTo: read)
        .where('user_uid', isEqualTo: this.id)
        .getDocuments();
  }

  Future<QuerySnapshot> getAllDocumentUsers() async {
    return await _firestore.collection('users').getDocuments();
  }

  Future<QuerySnapshot> getGift() async {
    return await _firestore.collection('gifts').getDocuments();
  }

  Future<QuerySnapshot> getEducationData() async {
    return await _firestore.collection('educations').getDocuments();
  }

  Future<QuerySnapshot> getAdvertisementsData() async {
    return await _firestore.collection('advertisements').getDocuments();
  }

  Future<DocumentSnapshot> getUserData() async {
    return await _firestore.collection('users').document(this.id).get();
  }

  Future<DocumentSnapshot> getDocNotification() async {
    return await _firestore.collection('notifications').document(this.id).get();
  }

  Future createNewProfile(String name, String phone, var createAt) async {
    try {
      await _firestore.collection('users').document(this.id).setData({
        "name": name,
        "phone": phone,
        "created_at": createAt,
        "point": 0,
        "role": "user public"
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future createNotifications({
    @required String userUID,
    String giftID,
    @required num point,
    @required String url,
    @required String title,
    String desc,
    @required String type,
    String descVerifed,
    @required status,
  }) async {
    try {
      _firestore.collection('notifications').document().setData({
        "user_uid": userUID,
        "gift_id": giftID ?? "-",
        "point": point,
        "image": url,
        "title": title,
        "desc": desc ?? "-",
        "type": type,
        "verifikasi": false,
        "desc_verifed": descVerifed,
        'read': false,
        'status': status,
        "created_at": DateTime.now(),
        "updated_at": DateTime.now()
      });
    } catch (e) {}
  }

  Future createPointHistory({
    String title,
    num pointBefore,
    num pointDefference,
    String type,
    String userUID,
    String giftId,
    bool verifed,
    String descVerif,
  }) async {
    try {
      _firestore
          .collection('users')
          .document(userUID)
          .collection('point_history')
          .document()
          .setData({
        "title": title,
        "point_before": pointBefore,
        "point_defference": pointDefference,
        "point_after": pointBefore + pointDefference,
        "type": type,
        "user_uid": userUID,
        "gift_id": giftId ?? '-',
        "verifed": verifed,
        "desc_Verif": descVerif ?? "-",
        "created_at": DateTime.now(),
        "updated_at": DateTime.now()
      });
    } catch (e) {}
  }

  Future updateDataUser(var data) async {
    try {
      _firestore.collection('users').document(this.id).updateData(data);
    } catch (e) {
      print(e.toString());
    }
  }

  Future updatePointUser(num point) async {
    try {
      _firestore.collection('users').document(this.id).updateData({
        "point": point,
      });
    } catch (e) {}
  }

  Future updateAsReadNotif() async {
    try {
      _firestore.collection('notifications').document(this.id).updateData({
        'read': true,
      });
    } catch (e) {}
  }

  Future updateAsDoneNotif() async {
    try {
      _firestore.collection('notifications').document(this.id).updateData({
        'status': 'Selesai',
      });
    } catch (e) {}
  }
}
