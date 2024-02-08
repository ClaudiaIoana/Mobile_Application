import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:try1_library_exam_model/api/api.dart';
import 'package:try1_library_exam_model/screens/add_item.dart';
import 'package:try1_library_exam_model/screens/edit_reserved.dart';
import 'package:try1_library_exam_model/screens/reserved_books.dart';
import 'package:try1_library_exam_model/services/database_helper.dart';

import '../api/network.dart';
import '../models/books.dart';
import '../widgets/message.dart';

class EmployeeSection extends StatefulWidget {
  @override
  _EmployeeSectionState createState() => _EmployeeSectionState();
}

class _EmployeeSectionState extends State<EmployeeSection> {
  var logger = Logger();
  bool online = true;
  late List<Book> categories = [];
  bool isLoading = false;
  Map _source = {ConnectivityResult.none: false};
  final NetworkConnectivity _connectivity = NetworkConnectivity.instance;
  String string = '';

  @override
  void initState() {
    super.initState();
    connection();
    getBooks();
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
      getBooks();
      logger.log(Level.info, "a intrat2");
    });
  }

  getBooks() async {
    logger.log(Level.info, "a intrat");

    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    if (online) {
      try {
        categories = await ApiService.instance.getBooks();
        DatabaseHelper.updateBooks(categories);
      } catch (e) {
        logger.e(e);
        message(context, "Error connecting to the server", "Error");
      }
    } else {
      categories = await DatabaseHelper.getBooks();
    }

    setState(() {
      isLoading = false;
    });
  }

  getReservedBooks() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });

    try {
      List<Book> reservedBooks = await ApiService.instance.getReservedBooks();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReservedBooksPage(),
        ),
      );
    } catch (e) {
      logger.e(e);
      message(context, "Error fetching reserved books", "Error");
    }

    setState(() {
      isLoading = false;
    });
  }

  updateBook(Book item) async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    logger.log(Level.info, 'updatePrice');
    try {
      if (online) {
        ApiService.instance.updateReserved(item.id!);
      } else {
        message(context, "No internet connection", "Error");
      }
    } catch (e) {
      logger.log(Level.error, e.toString());
      message(context, "Error updating price", "Error");
    }
    setState(() {
      isLoading = false;
    });
    getBooks();
  }

  saveItem(Book item) async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    if (online) {
      try {
        final Book received = await ApiService.instance.addItem(item);
        DatabaseHelper.addItem(received);
      } catch (e) {
        logger.e(e);
        message(context, "Error connecting to the server", "Error");
      }
    } else {
      message(context, "Operation not available", "Error");
    }
    setState(() {
      isLoading = false;
    });
  }

  void deleteBook(Book book) async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });

    try {
      if (online) {
        ApiService.instance.deleteBook(book.id!);
        // Assuming deleteBook is an API call to delete the book on the server
      } else {
        message(context, "No internet connection", "Error");
      }
    } catch (e) {
      logger.log(Level.error, e.toString());
      message(context, "Error deleting book", "Error");
    }

    setState(() {
      isLoading = false;
      getBooks(); // Refresh the book list after deletion
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Section'),
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
            ElevatedButton(
              onPressed: () {
                if (online) {
                  getReservedBooks();
                } else {
                  message(context, "No internet connection", "Error");
                }
              },
              child: const Text('Fetch Reserved Books'),
            ),

            ListView.builder(
              itemBuilder: ((context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(categories[index].title),
                      subtitle: Text('Author: ${categories[index].author}\nGenre: ${categories[index].genre}\nQuantity: ${categories[index].quantity}\nReserved: ${categories[index].reserved}'),
                      onTap: () {
                        // Navigate to EditItemPage when a book is tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditItemPage(
                              book: categories[index],
                            ),
                          ),
                        ).then((updatedBook) {
                          // Handle the returned book after editing (if needed)
                          if (updatedBook != null) {
                            setState(() {
                              updateBook(updatedBook);
                            });
                          }
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Handle the delete action here
                        // You can show a confirmation dialog before deleting
                        // and then call a function to delete the book
                        deleteBook(categories[index]);
                      },
                    ),
                    Divider(), // Add a divider between each book and delete button
                  ],
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
          if (!online) {
            message(context, "Operation not available", "Error");
            return;
          }
          Navigator.push(
              context, MaterialPageRoute(builder: ((context) => AddItem())))
              .then((value) {
            if (value != null) {
              setState(() {
                saveItem(value);
              });
              getBooks();
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
