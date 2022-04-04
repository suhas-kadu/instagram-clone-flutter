import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:instagram_clone_flutter/providers/user_provider.dart';
import 'package:instagram_clone_flutter/secret.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';
import 'package:instagram_clone_flutter/views/login_screen.dart';
import 'package:instagram_clone_flutter/views/verify_email_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: firebaseApikey,
          authDomain: "instagram-clone-flutter-1edb6.firebaseapp.com",
          projectId: "instagram-clone-flutter-1edb6",
          storageBucket: "instagram-clone-flutter-1edb6.appspot.com",
          messagingSenderId: "889741998736",
          appId: "1:889741998736:web:b08571ab5b403c5e3f3615"),
    );
  } else {
    await Firebase.initializeApp();
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp(
          title: 'Instagram Clone',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: mobileBackgroundColor,
              iconTheme: const IconThemeData(size: 24, color: Colors.white)),
          home: StreamBuilder(
              stream: FirebaseAuth.instance.userChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return VerifyEmailScreen();
                  } else if (snapshot.hasError) {
                    return Center(child: Text("${snapshot.error}"));
                  }
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                return LoginScreen();
              })),
    );
  }
}
