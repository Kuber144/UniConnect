import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'package:uniconnect/providers/providers.dart';
import 'package:uniconnect/screens/home_page.dart';
import 'package:uniconnect/screens/login_screen.dart';

import 'package:uniconnect/util/colors.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyBuZeCsxa5hZGxE59Nxngd9G0Ue4O_VG_w',
          appId: '1:187717066638:web:6aa322172fd6fbb1994edf',
          messagingSenderId: '187717066638',
          projectId: 'uniconnect-62628',
          storageBucket: 'uniconnect-62628.appspot.com'
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  await FlutterDownloader.initialize(
      debug: true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl: true // option: set to false to disable working with http links (default: false)
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent)
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>UserProvider(),
        ),
      ],
      
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'UniConnect',
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                // return ResponsiveLayout(
                //     webScreenLayout: WebScreenLayout(),
                //     mobileScreenLayout: MobileScreenLayout());
                return HomePage();
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('some internal error occurred'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
