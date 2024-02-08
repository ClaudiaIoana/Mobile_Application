import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../models/cars.dart';

const String baseUrl = 'http://192.168.224.210:2406';

class ApiService {
  static final ApiService instance = ApiService._init();
  static final Dio dio = Dio();
  var logger = Logger();

  ApiService._init();

  //TODO
  Future<List<Car>> getCars() async {
    logger.log(Level.info, 'getCars');
    final response = await dio.get('$baseUrl/cars');
    logger.log(Level.info, response.data);
    if (response.statusCode == 200) {
      final result = response.data as List;
      return result.map((e) => Car.fromJson(e)).toList();
    } else {
      throw Exception(response.statusMessage);
    }
  }

  // Future<List<Car>> getCarOwners() async {
  //   logger.log(Level.info, 'getCarOwners');
  //   final response = await dio.get('$baseUrl/carorders');
  //   logger.log(Level.info, response.data);
  //   if (response.statusCode == 200) {
  //     final result = response.data as List;
  //     return result.map((e) => Car.fromJson(e)).toList();
  //   } else {
  //     throw Exception(response.statusMessage);
  //   }
  // }

  Future<Map<String, List<Car>>> getCarOwners() async {
    logger.log(Level.info, 'getCarOwners');
    final response = await dio.get('$baseUrl/carorders');
    logger.log(Level.info, response.data);
    if (response.statusCode == 200) {
      final result = response.data as List;
      // Convert JSON data to a list of Car objects
      List<Car> cars = result.map((e) => Car.fromJson(e)).toList();

      // Group cars by the supplier field
      Map<String, List<Car>> groupedCars = {};
      for (var car in cars) {
        if (!groupedCars.containsKey(car.supplier)) {
          groupedCars[car.supplier] = [];
        }
        groupedCars[car.supplier]!.add(car);
      }

      return groupedCars;
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<Map<String, List<Car>>> getCarTypes() async {
    logger.log(Level.info, 'getCarTypes');
    final response = await dio.get('$baseUrl/carstypes');
    logger.log(Level.info, response.data);
    if (response.statusCode == 200) {
      final result = response.data as List;
      // Convert JSON data to a list of Car objects
      List<Car> cars = result.map((e) => Car.fromJson(e)).toList();

      // Group cars by the supplier field
      Map<String, List<Car>> groupedCars = {};
      for (var car in cars) {
        if (!groupedCars.containsKey(car.type)) {
          groupedCars[car.type] = [];
        }
        groupedCars[car.type]!.add(car);
      }

      return groupedCars;
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<Car> addItem(Car item) async {
    logger.log(Level.info, 'addCar: $item');
    final response =
    await dio.post('$baseUrl/car', data: item.toJsonWithoutId());
    logger.log(Level.info, response.data);
    if (response.statusCode == 200) {
      return Car.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }


  Future<Map<String, int>> countCarsByType() async {
    try {
      final response = await dio.get('$baseUrl/carstypes');
      if (response.statusCode == 200) {
        final result = response.data as List;
        List<Car> cars = result.map((e) => Car.fromJson(e)).toList();
        Map<String, int> carTypeCounts = {};

        for (var car in cars) {
          carTypeCounts[car.type] = (carTypeCounts[car.type] ?? 0) + 1;
        }

        // Log the computed carTypeCounts
        logger.d('Computed Car Type Counts: $carTypeCounts');

        return carTypeCounts;
      } else {
        throw Exception(response.statusMessage);
      }
    } catch (e) {
      logger.e(e);
      throw Exception("Error counting cars by type");
    }
  }




// Future<List<Book>> getReservedBooks() async {
  //   logger.log(Level.info, 'getReservedBooks');
  //   final response = await dio.get('$baseUrl/reserved');
  //   logger.log(Level.info, response.data);
  //   if (response.statusCode == 200) {
  //     final result = response.data as List;
  //     return result.map((e) => Book.fromJson(e)).toList();
  //   } else {
  //     throw Exception(response.statusMessage);
  //   }
  // }
  //
  // void updateReserved(int id) async {
  //   logger.log(Level.info, 'updateReserved: $id');
  //   final response =
  //   await dio.put('$baseUrl/reserve/$id');
  //   logger.log(Level.info, response.data);
  //   if (response.statusCode != 200) {
  //     throw Exception(response.statusMessage);
  //   }
  // }

  void requestCar(String type) async {
    logger.log(Level.info, 'requestCar: $type');
    final response =
    await dio.put('$baseUrl/requestcar/$type');
    logger.log(Level.info, response.data);
    if (response.statusCode != 200) {
      throw Exception(response.statusMessage);
    }
  }


}

