import 'package:flutter/material.dart';

import 'package:exam_try1/widgets/message.dart';
import 'package:exam_try1/widgets/text_box.dart';
import 'package:exam_try1/models/cars.dart';

class AddCar extends StatefulWidget {
  const AddCar({super.key});

  @override
  State<StatefulWidget> createState() => _AddCarState();
}

class _AddCarState extends State<AddCar> {
  late TextEditingController nameController;
  late TextEditingController supplierController;
  late TextEditingController detailsController;
  late TextEditingController statusController;
  late TextEditingController quantityController;
  late TextEditingController typeController;

  @override
  void initState() {
    nameController = TextEditingController();
    supplierController = TextEditingController();
    detailsController = TextEditingController();
    statusController = TextEditingController();
    quantityController = TextEditingController();
    typeController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Car'),
      ),
      body: ListView(
        children: [
          TextBox(nameController, 'name'),
          TextBox(supplierController, 'supplier'),
          TextBox(detailsController, 'details'),
          TextBox(statusController, 'status'),
          TextBox(quantityController, 'quantity'),
          TextBox(typeController, 'type'),
          ElevatedButton(
              onPressed: () {
                String name = nameController.text;
                String supplier = supplierController.text;
                String details = detailsController.text;
                String status = statusController.text;
                int? quantity = int.tryParse(quantityController.text);
                String type = typeController.text;
                if (name.isNotEmpty &&
                    supplier.isNotEmpty &&
                    details.isNotEmpty &&
                    status.isNotEmpty &&
                    quantity != null &&
                    type.isNotEmpty) {
                  Navigator.pop(
                      context,
                      Car(
                          name: name,
                          supplier: supplier,
                          details: details,
                          status: status,
                          quantity: quantity,
                          type: type));
                } else {
                  if (name.isEmpty) {
                    message(context, 'name is required', "Error");
                  } else if (supplier.isEmpty) {
                    message(context, 'supplier is required', "Error");
                  } else if (details.isEmpty) {
                    message(context, 'details is required', "Error");
                  } else if (status.isEmpty) {
                    message(context, 'status is required', "Error");
                  } else if (quantity != null) {
                    message(context, 'quantity is required', "Error");
                  } else if (type == null) {
                    message(context, 'type must be an integer', "Error");
                  }
                }
              },
              child: const Text('Save'))
        ],
      ),
    );
  }
}