import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3m_tennis/screens/authentication/login_Screen.dart';
import 'package:m3m_tennis/screens/authentication/sucess_Screen.dart';
import 'package:m3m_tennis/screens/booking/bookingCriteria_screen.dart';
import 'package:m3m_tennis/screens/booking/confirmBooking_screen.dart';
import 'package:m3m_tennis/screens/booking/myBooking%20_screen.dart';
import 'package:m3m_tennis/screens/practise_screen.dart';
import 'package:m3m_tennis/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: HomeScreen(),
      home: SplashScreen(),
      // home: SuccessScreen(),
      // home: BookingCriteriaScreen(),
      // home: MyBookingScreen(),
      // home: ConfirmBookingScreen(),
      // LoginScreen(),
    );
  }
}

