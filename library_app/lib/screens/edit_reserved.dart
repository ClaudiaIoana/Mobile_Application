import 'package:flutter/material.dart';
import 'package:try1_library_exam_model/api/api.dart';
import 'package:try1_library_exam_model/widgets/message.dart';

import '../models/books.dart';

class EditItemPage extends StatefulWidget {
  final Book book;

  const EditItemPage({Key? key, required this.book}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditItemState();
}

class _EditItemState extends State<EditItemPage> {
  late TextEditingController reservedController;

  @override
  void initState() {
    reservedController = TextEditingController(text: widget.book.reserved.toString());
    super.initState();
  }

  void borrowBook() async {
    try {
      ApiService.instance.borrowBook(widget.book.id!);
      message(context, "Book borrowed successfully", "Success");
    } catch (e) {
      message(context, "Error borrowing book", "Error");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserve book'),
      ),
      body: ListView(
        children: [
          Text('Title: ${widget.book.title}'),
          Text('Author: ${widget.book.author}'),
          Text('Genre: ${widget.book.genre}'),
          Text('Quantity: ${widget.book.quantity}'),
          Text('Reserved: ${widget.book.reserved}'),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(
                    context,
                    Book(
                      id: widget.book.id,
                      title: widget.book.title,
                      author: widget.book.author,
                      genre: widget.book.genre,
                      quantity: widget.book.quantity,
                      reserved:  widget.book.reserved,
                    ));
              },
              child: const Text('Reserve')),
          ElevatedButton(
            onPressed: () {
              borrowBook(); // Call the borrowBook method on button press
            },
            child: const Text('Borrow'),
          ),
        ],
      ),
    );
  }
}