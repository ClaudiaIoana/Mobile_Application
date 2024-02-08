
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/AddAlimentScreen.dart';
import 'package:untitled2/Aliment.dart';
import 'package:untitled2/UpdateAlimentScreen.dart';

class ListScreen extends StatefulWidget{
  final Aliment aliment;

  const ListScreen({Key? key, required this.aliment}) : super(key: key);

  @override
  State<ListScreen> createState() => ListScreenState();
}

class ListScreenState extends State<ListScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Aliment details"),
          backgroundColor: Colors.green,
        ),
        backgroundColor: Colors.black,
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Name',
                      style: TextStyle(
                          color: Colors.lightGreen,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(widget.aliment.name ?? '', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Text('Buy date',
                      style: TextStyle(
                          color: Colors.lightGreen,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(widget.aliment.buy_date.toString() ?? '', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Text('Expiration date',
                      style: TextStyle(
                          color: Colors.lightGreen,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(widget.aliment.expiration_date.toString() ?? '', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Text('Quantity',
                      style: TextStyle(
                          color: Colors.lightGreen,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(widget.aliment.aliment_quantity ?? '', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Text('Status',
                      style: TextStyle(
                          color: Colors.lightGreen,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(widget.aliment.status ?? '', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}

