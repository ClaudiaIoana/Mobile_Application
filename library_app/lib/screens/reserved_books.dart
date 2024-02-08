// ReservedBooksPage.dart

import 'package:flutter/material.dart';
import 'package:try1_library_exam_model/api/api.dart';
import 'package:try1_library_exam_model/models/books.dart';

class ReservedBooksPage extends StatefulWidget {
  @override
  _ReservedBooksPageState createState() => _ReservedBooksPageState();
}

class _ReservedBooksPageState extends State<ReservedBooksPage> {
  List<Book> reservedBooks = [];

  @override
  void initState() {
    super.initState();
    fetchReservedBooks();
  }

  Future<void> fetchReservedBooks() async {
    try {
      List<Book> books = await ApiService.instance.getReservedBooks();
      setState(() {
        reservedBooks = books;
      });
    } catch (e) {
      // Handle error
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reserved Books'),
      ),
      body: reservedBooks.isEmpty
          ? Center(
        child: Text('No reserved books available.'),
      )
          : ListView.builder(
        itemCount: reservedBooks.length,
        itemBuilder: (context, index) {
          Book book = reservedBooks[index];
          return ListTile(
            title: Text(book.title),
            subtitle: Text('Author: ${book.author}\nGenre: ${book.genre}\nQuantity: ${book.quantity}\nReserved: ${book.reserved}'),
            // Add more details as needed
            onTap: () {

            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: const BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
          );
        },
      ),
    );
  }
}
