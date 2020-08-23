import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:provider/provider.dart';
import 'package:tongnyampah/screens/user_admin/wrapper.dart';
import 'package:tongnyampah/screens/user_admin_super/wrapper.dart';
import 'package:tongnyampah/screens/user_public/pages/about_developer/about_developer.dart';
import 'package:tongnyampah/screens/user_public/pages/privacy%20policy/privacy_policy.dart';
import 'package:tongnyampah/screens/user_public/wrapper.dart';
import 'package:tongnyampah/services/route_page.dart';
import 'package:tongnyampah/screens/splash_screen.dart';
import 'package:tongnyampah/services/auth.dart';

import 'models/user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  GoogleMap.init('AIzaSyAk_7ppZ-lKIsNmPoxwNTY3aAjUBVTg1LA');
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

const MaterialColor primarySwatchColor = const MaterialColor(
  0xFF6078EA,
  const <int, Color>{
    50: const Color(0xFF6078EA),
    100: const Color(0xFF6078EA),
    200: const Color(0xFF6078EA),
    300: const Color(0xFF6078EA),
    400: const Color(0xFF6078EA),
    500: const Color(0xFF6078EA),
    600: const Color(0xFF6078EA),
    700: const Color(0xFF6078EA),
    800: const Color(0xFF6078EA),
    900: const Color(0xFF6078EA),
  },
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: BaseAuthService().user,
      child: MaterialApp(
        title: 'Tong Nyampah',
        debugShowCheckedModeBanner: false,
        theme:
            ThemeData(primarySwatch: primarySwatchColor, fontFamily: 'Poppins'),
        home: SplashScreen(),
        initialRoute: '/',
        // This widget is the root of your application.
        routes: <String, WidgetBuilder>{
          '/routepage': (BuildContext context) => RootPage(),
          '/homepublic': (BuildContext context) => WrapperPublic(),
          '/homeadmin': (BuildContext context) => WrapperAdmin(),
          '/homesuperadmin': (BuildContext context) => WrapperAdminSuper(),
          '/privacypolicy': (BuildContext context) => PrivacyPolicy(),
          '/aboutdeveloper': (BuildContext context) => AboutDeveloper(),
        },
      ),
    );
  }
}
