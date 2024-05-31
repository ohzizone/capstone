// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:running_mate/theme/colors.dart';

// List<Color> lineColor = [
//   iris_100,
// ];

// class LineChartContent extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('/running record/qLGojNsNczqZF0UI95Im/record')
//             .orderBy('date', descending: true)
//             .snapshots(),
//         builder: (BuildContext context,
//             AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           final docs = snapshot.data!.docs;

//           // Extracting FlSpot and x-axis labels
//           List<FlSpot> spots = [];
//           List<String> dateLabels = [];

//           docs.asMap().entries.forEach((entry) {
//             int index = entry.key;
//             var doc = entry.value;
//             double pace = double.parse(doc['pace']); // Convert pace to double
//             String date = doc['date']; // Date for x-axis labels

//             spots.add(FlSpot(index.toDouble(), pace));
//             dateLabels.add(date);
//           });

//           List<LineChartBarData> lineChartBarData = [
//             LineChartBarData(colors: lineColor, isCurved: false, spots: spots)
//           ];

//           return LineChart(
//             LineChartData(
//               borderData: FlBorderData(
//                   border: Border.all(color: Colors.black, width: 0.5)),
//               gridData: FlGridData(
//                 drawHorizontalLine: false,
//               ),
//               titlesData: FlTitlesData(
//                 bottomTitles: SideTitles(
//                   showTitles: true,
//                   getTextStyles: (value) => TextStyle(
//                       color: Colors.grey,
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold),
//                   getTitles: (value) {
//                     // Ensure value is within bounds
//                     if (value.toInt() >= 0 &&
//                         value.toInt() < dateLabels.length) {
//                       return dateLabels[value.toInt()];
//                     }
//                     return '';
//                   },
//                 ),
//                 leftTitles: SideTitles(
//                   interval: 4,
//                   showTitles: true,
//                   getTextStyles: (value) => TextStyle(
//                       color: Colors.white,
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold),
//                   getTitles: (value) {
//                     if (value.toInt() == 0)
//                       return '';
//                     else
//                       return value.toInt().toString();
//                   },
//                 ),
//               ),
//               minX: 0,
//               minY: 0,
//               maxX: spots.length.toDouble() - 1,
//               maxY: spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b),
//               lineBarsData: lineChartBarData,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
