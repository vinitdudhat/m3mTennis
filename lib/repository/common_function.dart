
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

String adjustTimeRange(String originalTimeRange) {
  List<String> times = originalTimeRange.split(' - ');
  String startTime = times[0];
  String endTime = times[1];

  String start = adjustTime(startTime);
  String end = adjustTime(endTime);
  // print(start);
  // print(end);

  String adjustTimeRange = start +" - "+ end;

  return adjustTimeRange;
}

String adjustTime(String originalTime) {
  List<String> parts = originalTime.split(' ');
  List<String> timeParts = parts[0].split(':');
  int hour = int.parse(timeParts[0]);
  int minute = int.parse(timeParts[1]);
  String period = parts[1];

  // Adjust the minutes
  minute += 30;
  if (minute >= 60) {
    minute -= 60;
    hour++;
    if (hour == 12) {
      // If the hour becomes 12, toggle the period
      period = (period == 'AM') ? 'PM' : 'AM';
    } else if (hour > 12) {
      hour -= 12;
    }
  }

  // Format the adjusted time
  String adjustedTime = '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';

  return adjustedTime;
}

//
// String adjustTimeRange(String originalTimeRange) {
//   // Split the original time range into start and end times
//   List<String> times = originalTimeRange.split(' - ');
//
//   // Parse the start and end times
//   String startTime = times[0];
//   String endTime = times[1];
//
//   // Parse the start and end times into DateTime objects
//   DateTime start = DateTime.parse('2024-01-01 ' + startTime);
//   DateTime end = DateTime.parse('2024-01-01 ' + endTime);
//
//   // Calculate the mid-time between start and end times
//   DateTime midTime = start.add(end.difference(start) ~/ 2);
//
//   // Adjust the start and end times by adding and subtracting 30 minutes
//   DateTime adjustedStartTime = start.add(Duration(minutes: 30));
//   DateTime adjustedEndTime = end.add(Duration(minutes: 30));
//
//   // Format the adjusted times into strings
//   String adjustedStartTimeString = '${adjustedStartTime.hour.toString().padLeft(2, '0')}:${adjustedStartTime.minute.toString().padLeft(2, '0')} ${adjustedStartTime.hour >= 12 ? 'PM' : 'AM'}';
//   String adjustedEndTimeString = '${adjustedEndTime.hour.toString().padLeft(2, '0')}:${adjustedEndTime.minute.toString().padLeft(2, '0')} ${adjustedEndTime.hour >= 12 ? 'PM' : 'AM'}';
//
//   // Concatenate the adjusted times into a time range string
//   String adjustedTimeRange = '$adjustedStartTimeString - $adjustedEndTimeString';
//
//   return adjustedTimeRange;
// }

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