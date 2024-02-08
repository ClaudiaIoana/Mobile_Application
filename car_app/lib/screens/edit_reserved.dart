import 'package:flutter/material.dart';
import 'package:exam_try1/api/api.dart';
import 'package:exam_try1/widgets/message.dart';

import '../models/cars.dart';

class EditItemPage extends StatefulWidget {
  final Car car;

  const EditItemPage({Key? key, required this.car}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditItemState();
}

class _EditItemState extends State<EditItemPage> {
  late TextEditingController reservedController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car'),
      ),
      body: ListView(
        children: [
          Text('name: ${widget.car.name}'),
          Text('supplier: ${widget.car.supplier}'),
          Text('details: ${widget.car.details}'),
          Text('status: ${widget.car.status}'),
          Text('quantity: ${widget.car.quantity}'),
          Text('type: ${widget.car.type}'),
        ],
      ),
    );
  }
}