import 'package:flutter/material.dart';
import 'package:exam_try1/api/api.dart';
import 'package:exam_try1/widgets/message.dart';

import '../models/cars.dart';

class TypeNumberPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TypeNumberPageState();
}

class _TypeNumberPageState extends State<TypeNumberPage> {
  Map<String, int> carTypeCounts = {};

  @override
  void initState() {
    super.initState();
    fetchCarTypeCounts();
  }

  void fetchCarTypeCounts() async {
    try {
      Map<String, int> counts = await ApiService.instance.countCarsByType();
      setState(() {
        carTypeCounts = counts;
      });
    } catch (e) {
      message(context, "Error retrieving car type counts", "Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Type Counts'),
      ),
      body: ListView.builder(
        itemCount: carTypeCounts.length,
        itemBuilder: (context, index) {
          final type = carTypeCounts.keys.toList()[index];
          final count = carTypeCounts[type];
          return ListTile(
            title: Text('$type: $count'),
          );
        },
      ),
    );
  }
}
