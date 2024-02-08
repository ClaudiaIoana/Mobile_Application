import 'package:flutter/material.dart';

import 'package:try1_library_exam_model/widgets/message.dart';
import 'package:try1_library_exam_model/widgets/text_box.dart';
import 'package:try1_library_exam_model/models/books.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<StatefulWidget> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  late TextEditingController titleController;
  late TextEditingController authorController;
  late TextEditingController genreController;
  late TextEditingController quantityController;
  late TextEditingController reservedController;

  @override
  void initState() {
    titleController = TextEditingController();
    authorController = TextEditingController();
    genreController = TextEditingController();
    quantityController = TextEditingController();
    reservedController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Book'),
      ),
      body: ListView(
        children: [
          TextBox(titleController, 'title'),
          TextBox(authorController, 'author'),
          TextBox(genreController, 'genre'),
          TextBox(quantityController, 'quantity'),
          TextBox(reservedController, 'reserved'),
          ElevatedButton(
              onPressed: () {
                String title = titleController.text;
                String author = authorController.text;
                String genre = genreController.text;
                int? quantity = int.tryParse(quantityController.text);
                int? reserved = int.tryParse(reservedController.text);
                if (title.isNotEmpty &&
                    author.isNotEmpty &&
                    genre.isNotEmpty &&
                    quantity != null &&
                    reserved != null) {
                  Navigator.pop(
                      context,
                      Book(
                          title: title,
                          author: author,
                          genre: genre,
                          quantity: quantity,
                          reserved: reserved));
                } else {
                  if (title.isEmpty) {
                    message(context, 'title is required', "Error");
                  } else if (author.isEmpty) {
                    message(context, 'author is required', "Error");
                  } else if (genre.isEmpty) {
                    message(context, 'genre is required', "Error");
                  } else if (quantity != null) {
                    message(context, 'quantity is required', "Error");
                  } else if (reserved == null) {
                    message(context, 'reserved must be an integer', "Error");
                  }
                }
              },
              child: const Text('Save'))
        ],
      ),
    );
  }
}