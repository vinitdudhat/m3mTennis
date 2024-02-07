import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:m3m_tennis/repository/common_function.dart';

class BookSlotController extends GetxController {
  RxInt selectedSlotIndex = 0.obs;
  String selectedSlotTime = "9:00 - 10:00 AM";

  List timeList = [8, 9, 10, 11, 12, 13,14,15,16];
  // List timeList = ["9:00 - 10:00 AM", "9:00 - 10:00 AM", "9:00 - 10:00 AM", "9:00 - 10:00 AM", 10, 11, 12, 13, 14, 15, 16];

  String? currentDate;
  DateTime? selectedDate;
  int selectedDateIndex = 0;
  List<DateTime> next7Days = [];

  final _dbRef = FirebaseDatabase.instance.ref('Booking').child("User_Bookings");
  final FirebaseAuth auth = FirebaseAuth.instance;

  confirmBookingSlot() {
    // print(auth.currentUser!.displayName.toString());

    String bookingId = uniqueString();
    String currentTime =  getCurrentTime();
    print(bookingId);

    _dbRef.child(bookingId).set({
      "BookingId" :bookingId,
      "user" : {
        "userId" : auth.currentUser?.uid,
        "name" : auth.currentUser?.displayName.toString(),
      },
      "date" : formatDate(selectedDate!),
      "slotTime" : selectedSlotTime,
      "createdAt" : currentTime,
      "updatedAt" : currentTime,
    });
  }

}