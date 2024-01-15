// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:developer';

import 'package:bookbyte/pages/homepage.dart';

import '../buyer/user.dart';
import '../buyer/books.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:bookbyte/backend/my_server_config.dart' show MyServerConfig;

// class BookDetails extends StatelessWidget {
//   final User user;
//   final Book book;

//   const BookDetails({super.key, required this.user, required this.book});
  
  
class BookDetails extends StatefulWidget {
  final User user;
  final Book book;

  const BookDetails({super.key, required this.user, required this.book});

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  late double screenWidth, screenHeight;
  final f = DateFormat('dd-MM-yyyy hh:mm a');
  bool bookowner = false;
  @override
  Widget build(BuildContext context) {
    if (widget.user.userId == widget.book.userId) {
      bookowner = true;
    } else {
      bookowner = false;
    }
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

  // @override
  // Widget build(BuildContext context) {
  //   final f = DateFormat('dd-MM-yyyy hh:mm a');
  //   bool bookowner = user.userId == book.userId;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.bookTitle.toString()),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                "${MyServerConfig.server}books/${widget.book.bookId}.png",
                fit: BoxFit.fill,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      widget.book.bookTitle.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    "Author Name: ${widget.book.bookAuthor.toString()}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    "Available Date: ${f.format(DateTime.parse(widget.book.bookDate.toString()))}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                ListTile(
                  title: Text("ISBN ${widget.book.bookIsbn}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 9),
                ListTile(
                  title: Text(widget.book.bookDesc.toString(), textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),)
                ),
                ListTile(
                  title: Text(
                    "RM ${widget.book.bookPrice}", textAlign: TextAlign.center, 
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  title: Text("Quantity Available: ${widget.book.bookQty} units", textAlign: TextAlign.center,
                style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    )),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ElevatedButton(
                    onPressed: () {
                      addCartDialog(context);
                    },
                    child: const Text("Add to Cart"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void addCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(26.0)),
          ),
          title: const Text(
            "Add Items to Cart?",
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Are You Sure?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).push(
                MaterialPageRoute(
                   builder: (context) => BookListPage(user: widget.user),
                  ),
                );
                addCart();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                
              ),
              onPressed: () {
                Navigator.of(context).push(
                MaterialPageRoute(
                   builder: (context) => BookListPage(user: widget.user),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                content: Text("Add Cart Cancelled"),
                backgroundColor: Colors.redAccent,
            ),
          );
              },
            ),
          ],
        );
      },
    );
  }

  void addCart() {
    http.post(
      Uri.parse("${MyServerConfig.server}php/add_cart.php"),
      body: {
        "buyer_id": widget.user.userId.toString(),
        "seller_id": widget.book.userId.toString(),
        "book_id": widget.book.bookId.toString(),
      },
    ).then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Successful to Add Cart"),
              backgroundColor: Colors.greenAccent,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to Add Cart"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });
  }
}


