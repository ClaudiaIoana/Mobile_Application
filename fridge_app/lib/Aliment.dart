import 'dart:ffi';

class Aliment {
  int? id;
  String? name;
  String? buy_date; // Change the type to String
  String? expiration_date; // Change the type to String
  String? aliment_quantity;
  String? status;

  Map<String, dynamic> alimentMap() {
    return {
      'id': id,
      'name': name,
      'buy_date': buy_date,
      'expiration_date': expiration_date,
      'aliment_quantity': aliment_quantity,
      'status': status,
    };
  }
}
