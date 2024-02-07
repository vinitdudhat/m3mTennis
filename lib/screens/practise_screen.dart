import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Court Usage Chart'),
      ),
      body : Center(
        child:Container(
          width: 300,
          height: 300,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              barTouchData: BarTouchData(enabled: false),
              // titlesData: FlTitlesData(
              //   bottomTitles: AxisTitles(
              //     showTitles: true,
              //     getTextStyles: (value) => const TextStyle(
              //       color: Colors.black,
              //       fontSize: 10,
              //     ),
              //     margin: 10,
              //     getTitles: (value) {
              //       return value.toString();
              //     },
              //   ),
              //   leftTitles: AxisTitles(showTitles: false),
              //   rightTitles: AxisTitles(showTitles: false),
              // ),

              borderData: FlBorderData(show: false),
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                       toY: 5, // Value for the first column of the first group
                      color: Colors.blue,
                    ),
                    BarChartRodData(
                       toY: 7, // Value for the second column of the first group
                      color: Colors.red,
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 1,
                  barRods: [
                    // BarChartRodData(
                    //    toY: 8, // Value for the first column of the second group
                    //   color: Colors.blue,
                    // ),
                    // BarChartRodData(
                    //    toY: 4, // Value for the second column of the second group
                    //   color: Colors.red,
                    // ),
                  ],
                ),
                // Add more BarChartGroupData for additional groups if needed
              ],
            ),
          ),
        ),

        // Container(
        //   width: 300,
        //   height: 300,
        //   child: BarChart(
        //     BarChartData(
        //       alignment: BarChartAlignment.spaceAround,
        //       barTouchData: BarTouchData(
        //         enabled: false,
        //       ),
        //       // titlesData: FlTitlesData(
        //       //   bottomTitles: SideTitles(
        //       //     showTitles: true,
        //       //     getTextSttoYles: (value) => const TextSttoYle(
        //       //       color: Colors.black,
        //       //       fontSize: 10,
        //       //     ),
        //       //     margin: 10,
        //       //     getTitles: (double value) {
        //       //       switch (value.toInt()) {
        //       //         case 0:
        //       //           return '9:00 AM';
        //       //         case 1:
        //       //           return '10:00 AM';
        //       //         case 2:
        //       //           return '11:00 AM';
        //       //         case 3:
        //       //           return '12:00 PM';
        //       //         case 4:
        //       //           return '1:00 PM';
        //       //         case 5:
        //       //           return '2:00 PM';
        //       //         default:
        //       //           return '';
        //       //       }
        //       //     },
        //       //   ),
        //       //   leftTitles: SideTitles(showTitles: false),
        //       //   rightTitles: SideTitles(showTitles: false),
        //       // ),
        //       titlesData: FlTitlesData(
        //         // leftTitles: AxisTitles(sideTitles: false),
        //         // bottomTitles: AxisTitles(
        //         //   sideTitles: true,
        //         //   getTextStyles: (value) => const TextStyle(
        //         //     color: Colors.black,
        //         //     fontSize: 10,
        //         //   ),
        //         //   margin: 10,
        //         //   getTitles: (value) {
        //         //     return value.toString();
        //         //   },
        //         // ),
        //       ),
        //
        //       // titlesData: FlTitlesData(
        //       //   leftTitles: AxisTitles(showTitles: false),
        //       //   bottomTitles: AxisTitles(
        //       //     showTitles: true,
        //       //     getTextSttoYles: (value) => const TextSttoYle(
        //       //       color: Colors.black,
        //       //       fontSize: 10,
        //       //     ),
        //       //     margin: 10,
        //       //     getTitles: (value) {
        //       //       return value.toString();
        //       //     },
        //       //   ),
        //       // ),
        //
        //       borderData: FlBorderData(
        //         show: false,
        //       ),
        //       barGroups: [
        //         BarChartGroupData(
        //           x: 0,
        //           barRods: [
        //             BarChartRodData(
        //               color: Colors.blue,  to toY: 5,
        //             ),
        //             BarChartRodData(
        //               to toY: 7,
        //               color: Colors.red,
        //             ),
        //           ],
        //         ),
        //         BarChartGroupData(
        //           x: 1,
        //           barRods: [
        //             BarChartRodData(
        //               color: Colors.blue,  to toY: 8,
        //             ),
        //             BarChartRodData(
        //               to toY: 4,
        //               color: Colors.red,
        //             ),
        //           ],
        //         ),
        //         BarChartGroupData(
        //           x: 2,
        //           barRods: [
        //             BarChartRodData(
        //               to toY: 3,
        //               color: Colors.blue,
        //             ),
        //             BarChartRodData(
        //               to toY: 6,
        //               color: Colors.red,
        //             ),
        //           ],
        //         ),
        //         BarChartGroupData(
        //           x: 3,
        //           barRods: [
        //             BarChartRodData(
        //               to toY: 9,
        //               color: Colors.blue,
        //             ),
        //             BarChartRodData(
        //               to toY: 2,
        //               color: Colors.red,
        //             ),
        //           ],
        //         ),
        //         BarChartGroupData(
        //           x: 4,
        //           barRods: [
        //             BarChartRodData(
        //               to toY: 6,
        //               color: Colors.blue,
        //             ),
        //             BarChartRodData(
        //               to toY: 5,
        //               color: Colors.red,
        //             ),
        //           ],
        //         ),
        //         BarChartGroupData(
        //           x: 5,
        //           barRods: [
        //             BarChartRodData(
        //               to toY: 7,
        //               color: Colors.blue,
        //             ),
        //             BarChartRodData(
        //               to toY: 3,
        //               color: Colors.red,
        //             ),
        //           ],
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
