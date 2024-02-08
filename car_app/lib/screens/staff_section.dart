import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:exam_try1/screens/request_car.dart';
import 'package:exam_try1/screens/type_number.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:exam_try1/api/api.dart';
import 'package:exam_try1/screens/edit_reserved.dart';
import 'package:exam_try1/services/database_helper.dart';

import '../api/network.dart';
import '../models/cars.dart';
import '../widgets/message.dart';

class StaffSectioon extends StatefulWidget {
  @override
  _StaffSectioonState createState() => _StaffSectioonState();
}

class _StaffSectioonState extends State<StaffSectioon> {
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
        Map<String, List<Car>> carOwners = await ApiService.instance.getCarTypes();
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

  requestCar(Car item) async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    logger.log(Level.info, 'updatePrice');
    try {
      if (online) {
        ApiService.instance.requestCar(item.type);
      } else {
        message(context, "No internet connection", "Error");
      }
    } catch (e) {
      logger.log(Level.error, e.toString());
      message(context, "Error updating price", "Error");
    }
    setState(() {
      isLoading = false;
    });
    getCarOwners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Section'),
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
            ElevatedButton(
              onPressed: () {
                if (!online) {
                  message(context, "No internet connection", "Info");
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TypeNumberPage()),
                );
                // Handle Price section button tap
              },
              //TODO
              child: const Text('Type number page'),
            ),
            ListView.builder(
              itemBuilder: ((context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(categories[index].name),
                      subtitle: Text('Id: ${categories[index].id}\nStatus: ${categories[index].status}\nType: ${categories[index].type}\n'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RequestCar(
                              car: categories[index],
                            ),
                          ),
                        ).then((updatedBook) {
                          // Handle the returned book after editing (if needed)
                          if (updatedBook != null) {
                            setState(() {
                              requestCar(updatedBook);
                            });
                          }
                        });
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
