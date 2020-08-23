import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tongnyampah/utils/miscellaneous.dart';
import 'package:tongnyampah/screens/user_public/pages/edusa/edusa_detail.dart';
import 'package:tongnyampah/screens/user_public/wrapper.dart';

class Edusa extends StatefulWidget {
  @override
  _EdusaState createState() => _EdusaState();
}

class _EdusaState extends State<Edusa> {
  Firestore _firestore = Firestore.instance;
  TextEditingController _searchControl = new TextEditingController();
  bool _isSearching;
  String searchText = "";
  List<dynamic> _list = List<dynamic>();
  List<dynamic> searchresult = List<dynamic>();

  _EdusaState() {
    _searchControl.addListener(() {
      if (_searchControl.text.isEmpty) {
        setState(() {
          _isSearching = false;
          searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          searchText = _searchControl.text;
        });
      }
    });
  }

  Widget _buildItemList(DocumentSnapshot educationsData) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          educationsData['title'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(30),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          educationsData['creator'],
                          style: TextStyle(fontFamily: 'Poppins-Italic'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              Container(
                width: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/placeholders/artikel.png',
                    image: educationsData['cover'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
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
    return WillPopScope(
      onWillPop: () {
        return Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => WrapperPublic(),
          ),
        );
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: TongsWidget.appBar(title: 'Edukasi Sampah'),
        body: Stack(
          children: <Widget>[
            Container(
              width: ScreenUtil.getInstance().width,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0.0),
                child: Card(
                  elevation: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    child: TextField(
                      controller: _searchControl,
                      onChanged: searchOperation,
                      onTap: values,
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: "Cari...",
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        hintStyle: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                            fontFamily: 'Comfortaa'),
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 70.0),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 15.0, 0),
                child: StreamBuilder(
                  stream: _firestore
                      .collection('educations')
                      .orderBy('created_at')
                      .snapshots(),
                  builder: ((BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: List.generate(
                          searchresult.length != 0 ||
                                  _searchControl.text.isNotEmpty
                              ? searchresult.length
                              : snapshot.data.documents.length,
                          (index) {
                            if (searchresult.length != 0 ||
                                _searchControl.text.isNotEmpty) {
                              DocumentSnapshot educationsData =
                                  searchresult[index];
                              return _buildItemList(educationsData);
                            } else {
                              DocumentSnapshot educationsData =
                                  snapshot.data.documents[index];
                              return _buildItemList(educationsData);
                            }
                          },
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void values() async {
    await _firestore.collection('educations').getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        if (docs.documents.isNotEmpty) {
          for (var data in docs.documents) {
            _list.add(data);
          }
        }
      }
    });
  }

  void searchOperation(String searchText) {
    searchresult.clear();
    if (_isSearching != null) {
      for (int i = 0; i < _list.length; i++) {
        var data = _list[i];
        if (data['title'].toLowerCase().contains(searchText.toLowerCase())) {
          searchresult.add(data);
        }
      }
    }
  }
}
