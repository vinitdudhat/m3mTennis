import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:m3m_tennis/repository/const_pref_key.dart';
import 'package:m3m_tennis/screens/authentication/login_Screen.dart';
import 'package:m3m_tennis/screens/authentication/sucess_Screen.dart';
import 'package:m3m_tennis/screens/booking/bookingCriteria_screen.dart';
import 'package:m3m_tennis/screens/booking/confirmBooking_screen.dart';
import 'package:m3m_tennis/screens/booking/myBooking%20_screen.dart';
import 'package:m3m_tennis/screens/dashboard/home_Screen.dart';
import 'package:m3m_tennis/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    // 'This channel is used for important notifications.', // description
    description: 'This channel is used for important notifications',
    showBadge: false,
    importance: Importance.high,
    playSound: true);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final prefs = await SharedPreferences.getInstance();
  bool? isNotificationOn = prefs.getBool(SharedPreferenKey.isNotificationOn);

  if(isNotificationOn == null) {
    prefs.setBool(SharedPreferenKey.isNotificationOn, true);
    FirebaseMessaging.instance.subscribeToTopic("All");
  } else if(isNotificationOn) {
    FirebaseMessaging.instance.subscribeToTopic("All");
  } else {
    FirebaseMessaging.instance.unsubscribeFromTopic("All");
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // runApp(
  //   DevicePreview(
  //     enabled: true,
  //     tools: [
  //       ...DevicePreview.defaultTools,
  //       // const CustomPlugin(),
  //     ],
  //     builder: (context) => const MyApp(),
  //   ),
  // );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification!.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                importance: Importance.high,
                channelShowBadge: true,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher'),
          ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

