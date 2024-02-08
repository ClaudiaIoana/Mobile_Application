
import 'dart:async';

import 'package:untitled2/db_helper/repository.dart';
import 'package:untitled2/Aliment.dart';

class AlimentService
{
  late Repository _repository;
  AlimentService(){
    _repository = Repository();
  }

  SaveAliment(Aliment aliment) async{
    return await _repository.insertData('aliments', aliment.alimentMap());
  }

  readAllAliments() async{
    return await _repository.readData('aliments');
  }

  UpdateAliment(Aliment aliment) async{
    return await _repository.updateData('aliments', aliment.alimentMap());
  }

  deleteAliment(alimentId) async {
    return await _repository.deleteDataById('aliments', alimentId);
  }

}