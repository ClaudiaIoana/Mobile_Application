import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:exam_try1/api/api.dart';
import 'package:exam_try1/screens/edit_reserved.dart';
import 'package:exam_try1/services/database_helper.dart';

import '../api/network.dart';
import '../models/cars.dart';
import '../widgets/message.dart';

class SupplierSection extends StatefulWidget {
  @override
  _SupplierSectionState createState() => _SupplierSectionState();
}

class _SupplierSectionState extends State<SupplierSection> {
  var logger = Logger();
  bool online = true;
  late List<Car> categories = [];
  bool isLoading = false;
  Map _source = {ConnectivityResult.none: false};
  final NetworkConnectivity _connectivity = NetworkConnectivity.instance;
  String string = '';

  @override
  void initState() {
    super.initState();
    connection();
    getCarOwners();
  }

  void connection() {
    _connectivity.initialize();
    _connectivity.myStream.listen((source) {
      _source = source;
      var newStatus = true;
      switch (_source.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          string =
          _source.values.toList()[0] ? 'Mobile: online' : 'Mobile: offline';
          break;
        case ConnectivityResult.wifi:
          string =
          _source.values.toList()[0] ? 'Wifi: online' : 'Wifi: offline';
          newStatus = _source.values.toList()[0] ? true : false;
          break;
        case ConnectivityResult.none:
        default:
          string = 'Offline';
          newStatus = false;
      }
      if (online != newStatus) {
        online = newStatus;
      }
      getCarOwners();
      logger.log(Level.info, "a intrat2");
    });
  }

  getCarOwners() async {
    logger.log(Level.info, "a intrat");

    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    if (online) {
      try {
        Map<String, List<Car>> carOwners = await ApiService.instance.getCarOwners();
        categories = carOwners.values.expand((list) => list).toList();
      } catch (e) {
        logger.e(e);
        message(context, "Error connecting to the server", "Error");
      }
    } else {
      message(context, "Available only online", "Error");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supplier Section'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.signal_cellular_alt),
            color: online ? Colors.green : Colors.red,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
        child: ListView(
          children: [
            ListView.builder(
              itemBuilder: ((context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(categories[index].name),
                      subtitle: Text('Id: ${categories[index].id}\nSupplier: ${categories[index].supplier}\nType: ${categories[index].type}\n'),
                      onTap: () {
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ],
                );
              }),
              itemCount: categories.length,
              physics: ScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(10),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
