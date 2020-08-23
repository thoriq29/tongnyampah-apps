import 'package:flutter/material.dart';
import 'package:tongnyampah/screens/authentication/login_page.dart';
import 'package:tongnyampah/screens/user_admin/wrapper.dart';
import 'package:tongnyampah/screens/user_admin_super/wrapper.dart';
import 'package:tongnyampah/screens/user_public/wrapper.dart';
import 'package:tongnyampah/services/auth.dart';
import 'package:tongnyampah/services/database.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  USER_PUBLIC,
  USER_ADMIN,
  USER_ADMIN_SUPER
}

class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String userId = "";

  @override
  void initState() {
    BaseAuthService().getCurrentUser().then((user) {
      if (user != null) {
        userId = user?.uid;
        print('User InitState Route: $userId');
        DatabaseService(id: user?.uid).getUserData().then((data) {
          final String _role = data['role'];
          print("HOLLA : " + _role);
          if (_role == 'user public') {
            print('user public initstate route');
            setState(() {
              authStatus = user?.uid == null
                  ? AuthStatus.NOT_LOGGED_IN
                  : AuthStatus.USER_PUBLIC;
            });
          } else if (_role == 'admin') {
            setState(() {
              authStatus = user?.uid == null
                  ? AuthStatus.NOT_LOGGED_IN
                  : AuthStatus.USER_ADMIN;
            });
          } else if (_role == 'super admin') {
            setState(() {
              authStatus = user?.uid == null
                  ? AuthStatus.NOT_LOGGED_IN
                  : AuthStatus.USER_ADMIN_SUPER;
            });
          }
        });
      } else {
        print('Else Indon InitState:v');
      }
      setState(() {
        authStatus = user?.uid == null
            ? AuthStatus.NOT_LOGGED_IN
            : AuthStatus.NOT_DETERMINED;
      });
    });
    super.initState();
  }

  void loginCallback() {
    BaseAuthService().getCurrentUser().then((user) {
      setState(() {
        userId = user.uid.toString();
        print('User LoginCallBack $userId');
        if (user != null) {
          userId = user?.uid;
          print(userId);
        } else {
          print('Else Indon CallBack:v');
        }
      });
      DatabaseService(id: user?.uid).getUserData().then((data) {
        final String _role = data['role'];
        print("HOLLA : " + _role);
        if (_role == 'user public') {
          print('User public LoginCallBack');
          setState(() {
            authStatus = AuthStatus.USER_PUBLIC;
          });
          Navigator.pop(context);
        } else if (_role == 'admin') {
          setState(() {
            authStatus = AuthStatus.USER_ADMIN;
          });
          Navigator.pop(context);
        } else if (_role == 'super admin') {
          setState(() {
            authStatus = AuthStatus.USER_ADMIN_SUPER;
          });
          Navigator.pop(context);
        }
      });
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        color: Colors.transparent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        print('Status Not Determined');
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return LoginPage(
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.USER_PUBLIC:
        if (userId.length > 0 && userId != null) {
          return WrapperPublic();
        } else
          print('User Public else');
        return buildWaitingScreen();
        break;
      case AuthStatus.USER_ADMIN:
        if (userId.length > 0 && userId != null) {
          return WrapperAdmin();
        } else
          print('User Admin else');
        return buildWaitingScreen();
        break;
      case AuthStatus.USER_ADMIN_SUPER:
        if (userId.length > 0 && userId != null) {
          return WrapperAdminSuper();
        } else
          print('User Super else');
        return buildWaitingScreen();
        break;
      default:
        print('Kondisi Default');
        return buildWaitingScreen();
    }
  }
}
