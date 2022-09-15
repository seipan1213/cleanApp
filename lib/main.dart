import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rakuten_demo/firebase_options.dart';
import 'package:rakuten_demo/fragments/postPage.dart';
import 'package:rakuten_demo/pages/loginPage.dart';
import 'package:rakuten_demo/services/apiService.dart';
import 'fragments/profile.dart';
import 'fragments/timeline.dart';
import 'fragments/cleaningSetting.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  try {
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
  } catch (e) {
    tz.setLocalLocation(tz.getLocation("Asia/Tokyo"));
  }

  // flutter_local_notificationsの初期化
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await FlutterLocalNotificationsPlugin().initialize(initializationSettings);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cleaning Reminder',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: LoginPage(),
    );
  }
}


// required widgets
// foating button→onpushでページ遷移→form表示
// PostList→ListViewを継承した投稿表示用 Widget
// FooterNavigation→Footerの切り替えbutton
//  button onTapの処理→対応画面の描画(Navigator?)
//  _pagesにそれぞれのページのWidgetを入れ込む→NavigationBarによって状態を遷移させることで
//  _pagesに入れ込むwidgetについては、file単位で分ける(profileは編集も同時画面でできるようにしていい気がしてきた。)
//