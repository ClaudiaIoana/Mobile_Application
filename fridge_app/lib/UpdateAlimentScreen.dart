import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled2/Aliment.dart';
import 'package:untitled2/service.dart';

class UpdateAlimentScreen extends StatefulWidget{
  final Aliment aliment;
  const UpdateAlimentScreen({Key? key,required this.aliment}) : super(key: key);

  @override
  State<UpdateAlimentScreen> createState() => UpdateAlimentScreenState();
}

class UpdateAlimentScreenState extends State<UpdateAlimentScreen>{
  var _alimentNameController = TextEditingController();
  DateTime? _alimentBuyDate; // Change the type to DateTime
  DateTime? _alimentExpirationDate;
  var _alimentQuantityController = TextEditingController();
  var _alimentStatusController = TextEditingController();
  bool _validateName = false;
  bool _validateBuyDate = false;
  bool _validateExpirationDate = false;
  bool _validateQuantity = false;
  bool _validateStatus = false;
  var _alimentService=AlimentService();

  @override
  void initState() {
    setState(() {
      _alimentNameController.text=widget.aliment.name??'';
      _alimentBuyDate=DateTime.parse(widget.aliment.buy_date??'');
      _alimentExpirationDate=DateTime.parse(widget.aliment.expiration_date??'');
      _alimentQuantityController.text=widget.aliment.aliment_quantity??'';
      _alimentStatusController.text=widget.aliment.status??'';
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update aliment"),
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
                'Update',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.lightGreen,
                    fontWeight: FontWeight.w500),
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
                    labelStyle: TextStyle(color: Colors.lightGreen),
                    errorText:
                    _validateName ? 'Name Value Can\'t Be Empty' : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),
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
                    labelStyle: TextStyle(color: Colors.lightGreen),
                    errorText: _validateQuantity
                        ? 'Quantity Value Can\'t Be Empty'
                        : null,
                  )),
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
                    labelStyle: TextStyle(color: Colors.lightGreen),
                    errorText: _validateStatus
                        ? 'Status Value Can\'t Be Empty'
                        : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.green,
                          textStyle: const TextStyle(fontSize: 15)),
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
                        if (_validateName == false &&
                            _validateBuyDate == false &&
                            _validateExpirationDate == false &&
                            _validateQuantity == false &&
                            _validateStatus == false) {
                          // print("Good Data Can Save");
                          var _aliment = Aliment();
                          _aliment.id=widget.aliment.id;
                          _aliment.name = _alimentNameController.text;
                          _aliment.buy_date = _alimentBuyDate != null
                              ? DateFormat('yyyy-MM-dd').format(_alimentBuyDate!)
                              : null;
                          _aliment.expiration_date = _alimentBuyDate != null
                              ? DateFormat('yyyy-MM-dd').format(_alimentExpirationDate!)
                              : null;
                          _aliment.aliment_quantity = _alimentQuantityController.text;
                          _aliment.status = _alimentStatusController.text;
                          var result=await _alimentService.UpdateAliment(_aliment);
                          Navigator.pop(context,result);
                        }
                      },
                      child: const Text('Update Details')),
                  const SizedBox(
                    width: 10.0,
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.red,
                          textStyle: const TextStyle(fontSize: 15)),
                      onPressed: () {
                        _alimentNameController.text = '';
                        _alimentBuyDate = null;
                        _alimentExpirationDate = null;
                        _alimentQuantityController.text = '';
                        _alimentStatusController.text = '';
                      },
                      child: const Text('Clear Details'))
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