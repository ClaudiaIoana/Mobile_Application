import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled2/Aliment.dart';
import 'package:untitled2/service.dart';

class AddAlimentScreen extends StatefulWidget {
  const AddAlimentScreen({Key? key}) : super(key: key);

  @override
  State<AddAlimentScreen> createState() => AddAlimentScreenState();
}

class AddAlimentScreenState extends State<AddAlimentScreen> {
  var _alimentNameController = TextEditingController();
  DateTime? _alimentBuyDate; // Change the type to DateTime
  DateTime? _alimentExpirationDate; // Change the type to DateTime
  var _alimentQuantityController = TextEditingController();
  var _alimentStatusController = TextEditingController();
  bool _validateName = false;
  bool _validateBuyDate = false;
  bool _validateExpirationDate = false;
  bool _validateQuantity = false;
  bool _validateStatus = false;
  var _alimentService=AlimentService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SQLite CRUD"),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Aliment',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.lightGreen,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: _alimentNameController,
                style: TextStyle(color: Colors.grey),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Enter Name',
                  labelText: 'Name',
                  errorText: _validateName ? 'Name Value Can\'t Be Empty' : null,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              // TextFormField for selecting Buy Date
              TextFormField(
                readOnly: true,
                style: TextStyle(color: Colors.grey),
                controller: _alimentBuyDate != null
                    ? TextEditingController(
                  text: DateFormat('yyyy-MM-dd').format(_alimentBuyDate!),
                )
                    : TextEditingController(),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Select Buy Date',
                  labelText: 'Buy Date',
                  errorText: _validateBuyDate ? 'Buy Date Value Can\'t Be Empty' : null,
                ),
                onTap: () async {
                  DateTime? pickedDate = await _selectDate(context, _alimentBuyDate);
                  if (pickedDate != null) {
                    setState(() {
                      _alimentBuyDate = pickedDate;
                    });
                  }
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                readOnly: true,
                style: TextStyle(color: Colors.grey),
                controller: _alimentExpirationDate != null
                    ? TextEditingController(
                  text: DateFormat('yyyy-MM-dd').format(_alimentExpirationDate!),
                )
                    : TextEditingController(),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Select Expiration Date',
                  labelText: 'Expiration Date',
                  errorText: _validateBuyDate ? 'Expiration Date Value Can\'t Be Empty' : null,
                ),
                onTap: () async {
                  DateTime? pickedDate = await _selectDate(context, _alimentExpirationDate);
                  if (pickedDate != null) {
                    setState(() {
                      _alimentExpirationDate = pickedDate;
                    });
                  }
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: _alimentQuantityController,
                style: TextStyle(color: Colors.grey),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Enter Quantity',
                  labelText: 'Quantity',
                  errorText: _validateQuantity ? 'Quantity Value Can\'t Be Empty' : null,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: _alimentStatusController,
                style: TextStyle(color: Colors.grey),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Enter Status',
                  labelText: 'Status',
                  errorText: _validateStatus ? 'Status Value Can\'t Be Empty' : null,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.green,
                      textStyle: const TextStyle(fontSize: 15),
                    ),
                    onPressed: () async {
                      setState(() {
                        _alimentNameController.text.isEmpty
                            ? _validateName = true
                            : _validateName = false;
                        _alimentBuyDate == null
                            ? _validateBuyDate = true
                            : _validateBuyDate = false;
                        _alimentExpirationDate == null
                            ? _validateExpirationDate = true
                            : _validateExpirationDate = false;
                        _alimentQuantityController.text.isEmpty
                            ? _validateQuantity = true
                            : _validateQuantity = false;
                        _alimentStatusController.text.isEmpty
                            ? _validateStatus = true
                            : _validateStatus = false;
                      });

                      if (!_validateName &&
                          !_validateBuyDate &&
                          !_validateExpirationDate &&
                          !_validateQuantity &&
                          !_validateStatus) {
                        // Your logic to save the aliment
                        print("Good Data Can Save");
                        var _aliment = Aliment();
                        _aliment.name = _alimentNameController.text;
                        _aliment.buy_date = _alimentBuyDate != null
                            ? DateFormat('yyyy-MM-dd').format(_alimentBuyDate!)
                            : null;
                        _aliment.expiration_date = _alimentBuyDate != null
                            ? DateFormat('yyyy-MM-dd').format(_alimentExpirationDate!)
                            : null;
                        _aliment.aliment_quantity = _alimentQuantityController.text;
                        _aliment.status = _alimentStatusController.text;


                        var result=await _alimentService.SaveAliment(_aliment);
                        print("Good Data Can Save2");
                        print(result);
                        print(_aliment.alimentMap());

                          Navigator.pop(context,result);
                        }
                      },
                      child: const Text('Save aliment')),
                  const SizedBox(
                    width: 10.0,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.red,
                      textStyle: const TextStyle(fontSize: 15),
                    ),
                    onPressed: () {
                      _alimentNameController.text = '';
                      _alimentBuyDate = null;
                      _alimentExpirationDate = null;
                      _alimentQuantityController.text = '';
                      _alimentStatusController.text = '';
                    },
                    child: const Text('Clear fields'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<DateTime?> _selectDate(BuildContext context, DateTime? initialDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    return pickedDate;
  }
}
