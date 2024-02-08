import 'package:flutter/cupertino.dart';
import 'package:untitled2/service.dart';

import 'package:untitled2/Aliment.dart';

class AlimentListViewModel extends ChangeNotifier {
  late List<Aliment> _alimentList = <Aliment>[];
  var _alimentService = AlimentService();

  List<Aliment> get alimentList => _alimentList;

  Future<void> getAllAlimentInformation() async {
    print('heer');
    var aliments = await _alimentService.readAllAliments();
    _alimentList = <Aliment>[];
    aliments.forEach((aliment) {
      var alimentModel = Aliment();
      alimentModel.id = aliment['id'];
      alimentModel.name = aliment['name'];
      alimentModel.buy_date = aliment['buy_date'];
      alimentModel.expiration_date = aliment['expiration_date'];
      alimentModel.aliment_quantity = aliment['aliment_quantity'];
      alimentModel.status = aliment['status'];
      _alimentList.add(alimentModel);
    });
    notifyListeners();
  }

  Future<void> updateAliment(Aliment aliment) async {
    print("good1");
    var result = await _alimentService.UpdateAliment(aliment);
    print("good");
    print(aliment);
    if (result != null) {
      print(aliment);
      _alimentList[_alimentList.indexWhere((element) => element.id == aliment.id)] = aliment;
      notifyListeners();
    }
  }

  Future<void> addAliment(Aliment aliment) async {
    print("good1");
    var result = await _alimentService.SaveAliment(aliment);
    if (result != null) {
      _alimentList.add(aliment);
      notifyListeners();
    }
  }

  Future<void> deleteAliment(int alimentId) async {
    var result = await _alimentService.deleteAliment(alimentId);
    if (result != null) {
      _alimentList.removeWhere((aliment) => aliment.id == alimentId);
      notifyListeners();
    }
  }
}