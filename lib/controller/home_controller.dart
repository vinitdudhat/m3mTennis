import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:m3m_tennis/repository/common_function.dart';

class BookSlotController extends GetxController {
  RxInt selectedSlotIndex = 0.obs;
  String selectedSlotTime = "9:00 am - 10:00 am";

  List timeList = [8, 9, 10, 11, 12, 13,14,15,16];
  List slotList = ["8:00 am - 9:00 am", "9:00 am - 10:00 am", "10:00 am - 11:00 am", "11:00 am - 12:00 am",
    "12:00 am - 01:00 pm",
    "01:00 pm - 02:00 pm",
    "02:00 pm - 03:00 pm",
    "03:00 pm - 04:00 pm",
  ];

  String? currentDate;
  DateTime? selectedDate;
  int selectedDateIndex = 0;
  List<DateTime> next7Days = [];

  final _dbRef = FirebaseDatabase.instance.ref('Booking').child("User_Bookings");
  final FirebaseAuth auth = FirebaseAuth.instance;

  confirmBookingSlot() {
    print(selectedSlotTime);
    List<String> times = selectedSlotTime.split(" - ");

    String fromTime = times[0];
    String toTime = times[1];
    // print(fromTime);
    // print(toTime);

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
      "from" : fromTime,
      "to" : toTime,
      "courtId" : "WC",
      // "slotTime" : selectedSlotTime,
      "createdAt" : currentTime,
    });
  }

}