import 'package:flutter/material.dart';
import 'package:exam_try1/api/api.dart';
import 'package:exam_try1/widgets/message.dart';

import '../models/cars.dart';

class RequestCar extends StatefulWidget {
  final Car car;

  const RequestCar({Key? key, required this.car}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditItemState();
}

class _EditItemState extends State<RequestCar> {
  late TextEditingController typeController;

  @override
  void initState() {
    typeController = TextEditingController(text: widget.car.type.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Car'),
      ),
      body: ListView(
        children: [
          Text('name: ${widget.car.name}'),
          Text('supplier: ${widget.car.supplier}'),
          Text('details: ${widget.car.details}'),
          Text('status: ${widget.car.status}'),
          Text('quantity: ${widget.car.quantity}'),
          Text('type: ${widget.car.type}'),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(
                    context,
                    Car(
                      id: widget.car.id,
                      name: widget.car.name,
                      supplier: widget.car.supplier,
                      details: widget.car.details,
                      status: widget.car.status,
                      quantity: widget.car.quantity,
                      type:  widget.car.type,
                    ));
              },
              child: const Text('Request')),
        ],

      ),
    );
  }
}