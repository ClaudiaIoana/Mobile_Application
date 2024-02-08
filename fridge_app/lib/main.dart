import 'package:untitled2/Aliment.dart';
import 'package:untitled2/UpdateAlimentScreen.dart';
import 'package:untitled2/AddAlimentScreen.dart';
import 'package:untitled2/ListScreen.dart';
import 'package:untitled2/service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late List<Aliment> _alimentList = <Aliment>[];
  final _alimentService = AlimentService();

  getAllAlimentDetails() async {
    try{
      var aliments = await _alimentService.readAllAliments();
      _alimentList = <Aliment>[];
      aliments.forEach((aliment) {
        setState(() {
          var alimentModel = Aliment();
          alimentModel.id = aliment['id'];
          alimentModel.name = aliment['name'];
          alimentModel.buy_date = aliment['buy_date'];
          alimentModel.expiration_date = aliment['expiration_date'];
          alimentModel.aliment_quantity = aliment['aliment_quantity'];
          alimentModel.status = aliment['status'];
          _alimentList.add(alimentModel);
        });
    });} catch(error){
    showFlashError(context, error.toString());
  }
  }

  @override
  void initState() {
    getAllAlimentDetails();
    super.initState();
  }

  _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _deleteFormDialog(BuildContext context, userId) {
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            title: const Text(
              'Are you sure?',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            backgroundColor: Colors.lightGreen[200],
            actions: [
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, // foreground
                      backgroundColor: Colors.red),
                  onPressed: ()  async{
                    try{
                      var result=await _alimentService.deleteAliment(userId);
                    }catch(error){
                      showFlashError(context, error.toString());
                    }
                    Navigator.pop(context);
                    getAllAlimentDetails();
                    _showSuccessSnackBar(
                        'Aliment Deleted Successfully');
                  },
                  child: const Text('Delete')),
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, // foreground
                      backgroundColor: Colors.green),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aliments"),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.black,
      body: ListView.builder(
          itemCount: _alimentList.length,
          itemBuilder: (context, index) {
            return Card(

              color: Colors.lightGreen[200],
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListScreen(
                            aliment: _alimentList[index],
                          )));
                },
                leading: const Icon(Icons.food_bank),
                title: Text(_alimentList[index].name ?? ''),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Buy Date: ${_alimentList[index].buy_date ?? ''}'),
                    Text('Expiration Date: ${_alimentList[index].expiration_date ?? ''}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdateAlimentScreen(
                                    aliment: _alimentList[index],
                                  ))).then((data) {
                            if (data != null) {
                              getAllAlimentDetails();
                              _showSuccessSnackBar(
                                  'Aliment Updated Successfully');
                            }
                          }).catchError((error) {
                            showFlashError(context, error.toString());
                          });
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.teal,
                        )),
                    IconButton(
                        onPressed: () {
                          _deleteFormDialog(context, _alimentList[index].id);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ))
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddAlimentScreen()))
              .then((data) {
            if (data != null) {
              getAllAlimentDetails();
            }
          }).catchError((error) {
            showFlashError(context, error.toString());
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void showFlashError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}
}
