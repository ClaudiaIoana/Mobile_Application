import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:exam_try1/screens/add_car.dart';
import 'package:exam_try1/screens/edit_reserved.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:exam_try1/api/api.dart';
import 'package:exam_try1/services/database_helper.dart';

import '../api/network.dart';
import '../models/cars.dart';
import '../widgets/message.dart';

class MainSection extends StatefulWidget {
  @override
  _MainSectionState createState() => _MainSectionState();
}

class _MainSectionState extends State<MainSection> {
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
    getCars();
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
      getCars();
      logger.log(Level.info, "a intrat2");
    });
  }

  getCars() async {
    logger.log(Level.info, "a intrat");

    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    if (online) {
      try {
        categories = await ApiService.instance.getCars();
        DatabaseHelper.updateCars(categories);
      } catch (e) {
        logger.e(e);
        message(context, "Error connecting to the server", "Error");
      }
    } else {
      categories = await DatabaseHelper.getCars();
    }

    setState(() {
      isLoading = false;
    });
  }

  saveCar(Car item) async {
    logger.log(Level.info, "a intrat in add");
    setState(() {
      isLoading = true;
    });

    try {
      if (online) {
        logger.log(Level.info, "a intrat in add");
        // If online, save the car remotely and update the local database
        final Car received = await ApiService.instance.addItem(item);
        await DatabaseHelper.addItem(received);
      } else {
        logger.log(Level.info, "a intrat in add");
        // If offline, save the car only to the local database
        await DatabaseHelper.addItem(item);
      }
    } catch (e) {
      logger.e(e);
      message(context, "Error saving the car", "Error");
    }

    setState(() {
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Organizer Section'),
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
            // ElevatedButton(
            //   onPressed: () {
            //     if (online) {
            //       getReservedCars();
            //     } else {
            //       message(context, "No internet connection", "Error");
            //     }
            //   },
            //   child: const Text('Fetch Reserved Books'),
            // ),

            ListView.builder(
              itemBuilder: ((context, index) {
                return ListTile(
                  title: Text(categories[index].name),
                  subtitle: Text('Id: ${categories[index].id}\nSupplier: ${categories[index].supplier}\nType: ${categories[index].type}\n'),
                  onTap: () {
                    // Navigate to EditItemPage when a Car is tapped
                    //TODO: modify to do on click
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditItemPage(
                          car: categories[index],
                        ),
                      ),
                    ).then((updatedCar) {
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: const BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: ((context) => AddCar())))
              .then((value) {
            if (value != null) {
              setState(() {
                saveCar(value);
              });
              getCars();
            }
          });
        },
        tooltip: 'Add item',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
