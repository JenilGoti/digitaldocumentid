import 'package:digitaldocumentid/screens/phone_verification_screens/enter_phone_numberScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '../service/local_push_notification.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/initial_user_details_screen.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

Future<void> _hendlBackgroundMessages(RemoteMessage message) async {
  print(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().whenComplete(() => print('ok'));
  FirebaseAuth.instance;
  LocalNotificationServises.initialize();
  FirebaseMessaging.onBackgroundMessage(_hendlBackgroundMessages);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitUp]);
  runApp(
      Phoenix(
        child: const MyApp(),
      ),
      );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.deepPurpleAccent,
          accentColorBrightness: Brightness.dark,
          backgroundColor: Colors.indigo.withOpacity(0.5),
          buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Colors.indigo,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)))),
      home: StreamBuilder(
        builder: (context, userSnapshot) {
          if (userSnapshot.hasData) {
            if ((FirebaseAuth.instance.currentUser!.displayName == null) ||
                (FirebaseAuth.instance.currentUser!.email == null)) {
              return InitialUserDetailScreen();
            } else {
              return HomePage();
            }
          } else {
            return EnterPhoneNumberScreen();
          }
        },
        stream: FirebaseAuth.instance.authStateChanges(),
      ),
    );
  }
}
