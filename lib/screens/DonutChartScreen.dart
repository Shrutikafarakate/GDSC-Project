import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pie_chart/pie_chart.dart';
import '../models/trancs.dart';

class DonutChartScreen extends StatefulWidget {
  const DonutChartScreen({super.key});

  @override
  State<DonutChartScreen> createState() => _DonutChartScreenState();
}

class _DonutChartScreenState extends State<DonutChartScreen> {
  Map<String, double> dataMap = {};
  final colorList = <Color>[
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
  ];

  @override
  void initState() {
    super.initState();
    loadCategoryData();
  }

  void loadCategoryData() {
    final box = Hive.box('transactions');
    final Map<String, double> categoryMap = {};

    for (var item in box.values) {
      final transaction = item as Transaction;

      final category = transaction.category;
      final amount = transaction.amount;

      if (categoryMap.containsKey(category)) {
        categoryMap[category] = categoryMap[category]! + amount;
      } else {
        categoryMap[category] = amount;
      }
    }

    setState(() {
      dataMap = categoryMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Spending by Category"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            dataMap.isEmpty
                ? const Center(child: Text("No Data"))
                : PieChart(
              dataMap: dataMap,
              animationDuration: const Duration(milliseconds: 800),
              chartLegendSpacing: 32,
              chartRadius: MediaQuery.of(context).size.width / 2.2,
              colorList: colorList,
              initialAngleInDegree: 0,
              chartType: ChartType.ring,
              ringStrokeWidth: 30,
              centerText: "Total\n₹${dataMap.values.fold(0.0, (a, b) => a + b).toStringAsFixed(2)}",
              legendOptions: const LegendOptions(
                showLegendsInRow: false,
                legendPosition: LegendPosition.right,
                showLegends: true,
                legendTextStyle: TextStyle(fontSize: 14),
              ),
              chartValuesOptions: const ChartValuesOptions(
                showChartValueBackground: true,
                showChartValues: true,
                showChartValuesInPercentage: true,
                showChartValuesOutside: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
