
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

String convertTo12HourFormat(int hour) {
  if (hour == 24) {
    return '12 PM';
  } else {
    String amPm = hour <= 12 ? 'AM' : 'PM';
    int hour12 = hour % 12;
    if (hour12 == 0) {
      hour12 = 12; // Set 0 to 12 for 12-hour clock representation
    }
    return '${hour12.toString().padLeft(2, '0')} $amPm';
  }
}

String convertTo24HourFormat(String time12Hour) {
  // Parse the time in 12-hour format
  DateFormat inputFormat = DateFormat('h:mm a');
  DateTime dateTime = inputFormat.parse(time12Hour);

  // Extract hour and minute components
  int hour = dateTime.hour;
  int minute = dateTime.minute;

  // Convert 12:00 PM to 24:00 format
  if (time12Hour.endsWith('PM') && hour == 12) {
    hour = 0;
  }

  // Convert the time to 24-hour format
  String time24Hour = '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  return time24Hour;
}

String convertToShowingDateFormat(String timestamp) {
  // Parse the timestamp string
  DateTime dateTime = DateTime.parse(timestamp);

  // Format the date
  DateFormat outputFormat = DateFormat('dd MMM yyyy');
  String formattedDate = outputFormat.format(dateTime);

  return formattedDate;
}

// String convertTo24HourFormat(String time) {
//   String time12Hour = '12:00 PM';
//
//   // Parse the time in 12-hour format
//   DateFormat inputFormat = DateFormat('h:mm a');
//   DateTime dateTime = inputFormat.parse(time12Hour);
//
//   // Convert the time to 24-hour format
//   DateFormat outputFormat = DateFormat('HH:mm');
//   String time24Hour = outputFormat.format(dateTime);
//
//   print(time24Hour); // Output: 12:00
//
//   // DateFormat inputFormat = DateFormat('h:mm a');
//   // DateTime dateTime = inputFormat.parse(time);
//   //
//   // // Convert the time to 24-hour format
//   // DateFormat outputFormat = DateFormat('HH:mm');
//   // String time24Hour = outputFormat.format(dateTime);
//   // // print(time24Hour); // Output: 21:00
//
//   return time24Hour;
// }

// String convertTo24HourFormat(String time12Hour) {
//   // Parse the time in 12-hour format
//   DateFormat inputFormat = DateFormat('h:mm a');
//   DateTime dateTime = inputFormat.parse(time12Hour);
//
//   // Convert the time to 24-hour format
//   DateFormat outputFormat = DateFormat('HH:mm');
//   return outputFormat.format(dateTime);
// }


String getCurrentTime() {
  Timestamp timestamp = Timestamp.now();
  DateTime dateTime = timestamp.toDate();
  String currentTime = dateTime.toUtc().toString();
  return currentTime;
}

String formatDate(DateTime dateTime) {
  DateFormat dateFormat = DateFormat('dd MMM yyyy, EEEE');
  return dateFormat.format(dateTime);
}

// String uniqueString() {
//   var uuid = Uuid();
//   return uuid.v4();
// }

String uniqueString() {
  const int minLength = 8;
  const int maxLength = 8;
  const String alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const String numbers = '0123456789';
  String result = '';

  Random random = Random();

  for (int i = 0; i < maxLength; i++) {
    if (i % 2 == 0) {
      result += alphabet[random.nextInt(alphabet.length)];
    } else {
      result += numbers[random.nextInt(numbers.length)];
    }
  }

  while (result.length < minLength) {
    if (result.length % 2 == 0) {
      result += alphabet[random.nextInt(alphabet.length)];
    } else {
      result += numbers[random.nextInt(numbers.length)];
    }
  }
  result = result.substring(0, maxLength);

  return result;
}

// String uniqueString() {
//   const int maxLength = 6;
//   const String alphabet = 'abcdefghijklmnopqrstuvwxyz';
//   const String numbers = '0123456789';
//   String result = '';
//
//   Random random = Random();
//
//   for (int i = 0; i < maxLength; i++) {
//     if (i % 2 == 0) {
//       result += alphabet[random.nextInt(alphabet.length)];
//     } else {
//       result += numbers[random.nextInt(numbers.length)];
//     }
//   }
//
//   return result;
// }