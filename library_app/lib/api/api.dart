import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../models/books.dart';

const String baseUrl = 'http://192.168.0.122:2425';

class ApiService {
  static final ApiService instance = ApiService._init();
  static final Dio dio = Dio();
  var logger = Logger();

  ApiService._init();

  Future<List<Book>> getBooks() async {
    logger.log(Level.info, 'getBooks');
    final response = await dio.get('$baseUrl/books');
    logger.log(Level.info, response.data);
    if (response.statusCode == 200) {
      final result = response.data as List;
      return result.map((e) => Book.fromJson(e)).toList();
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<List<Book>> getReservedBooks() async {
    logger.log(Level.info, 'getReservedBooks');
    final response = await dio.get('$baseUrl/reserved');
    logger.log(Level.info, response.data);
    if (response.statusCode == 200) {
      final result = response.data as List;
      return result.map((e) => Book.fromJson(e)).toList();
    } else {
      throw Exception(response.statusMessage);
    }
  }

  void updateReserved(int id) async {
    logger.log(Level.info, 'updateReserved: $id');
    final response =
    await dio.put('$baseUrl/reserve/$id');
    logger.log(Level.info, response.data);
    if (response.statusCode != 200) {
      throw Exception(response.statusMessage);
    }
  }

  void deleteBook(int id) async {
    logger.log(Level.info, 'deleteBook: $id');
    final response = await dio.delete('$baseUrl/delete/$id');
    logger.log(Level.info, response.data);
    if (response.statusCode != 200) {
      throw Exception(response.statusMessage);
    }
  }

  void borrowBook(int id) async {
    logger.log(Level.info, 'borrowBook: $id');
    final response =
    await dio.put('$baseUrl/borrow/$id');
    logger.log(Level.info, response.data);
    if (response.statusCode != 200) {
      throw Exception(response.statusMessage);
    }
  }

  Future<Book> addItem(Book item) async {
    logger.log(Level.info, 'addBook: $item');
    final response =
    await dio.post('$baseUrl/book', data: item.toJsonWithoutId());
    logger.log(Level.info, response.data);
    if (response.statusCode == 200) {
      return Book.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
}

