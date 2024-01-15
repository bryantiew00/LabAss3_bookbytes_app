import 'dart:convert';

import 'package:bookbyte/backend/InOut.dart';
import 'package:bookbyte/backend/drawer.dart';

import '../buyer/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../buyer/books.dart';
import '../pages/bookdetails.dart';
import '../backend/my_server_config.dart';
import '../pages/cartitempage.dart';

class BookListPage extends StatefulWidget {
  final User user;

  const BookListPage({super.key, required this.user});

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  List<Book> bookList = <Book>[];
  late double screenWidth, screenHeight;
  int numofpage = 1;
  int curpage = 1;
  int numofresult = 0;
  int axiscount = 2;
  // ignore: prefer_typing_uninitialized_variables
  var color;
  String title = "";

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadBooks(title);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "3Bs Book List",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              width: 55,
            ),
          ],
        ),
        
        actions: [
          IconButton(
            onPressed: () {
              showSearchDialog();
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
           onPressed: () {
             Navigator.push(
                  context,
                  EnterExitRoute(
                      exit: CartPage(
                        user: widget.user,
                      ),
                      enter: CartPage(
                        user: widget.user,
                      )));
           },
           icon: const Icon(Icons.add_shopping_cart),
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.blueGrey,
            height: 2.0,
          ),
        )),
        drawer: BDrawer(
        page: "Books",
        userdata: widget.user
      ),
      body: bookList.isEmpty
          ? const Center(child: Text("Null"))
          : Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text("Page $curpage/$numofresult"),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: axiscount,
                    children: List.generate(bookList.length, (index) {
                      return Card(
                        child: InkWell(
                          onTap: () async {
                            Book book = Book.fromJson(bookList[index].toJson());
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (content) => BookDetails(
                                  user: widget.user,
                                  book: book,
                                ),
                              ),
                            );
                            loadBooks(title);
                          },
                          child: Column(
                            children: [
                              Flexible(
                                flex: 6,
                                child: Container(
                                  width: screenWidth,
                                  padding: const EdgeInsets.all(5.0),
                                  child: Image.network(
                                    fit: BoxFit.fill,
                                    "${MyServerConfig.server}books/${bookList[index].bookId}.png",
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 4,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      truncateString(
                                          bookList[index].bookTitle.toString()),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    Text("RM ${bookList[index].bookPrice}"),
                                    Text("Available ${bookList[index].bookQty} unit"),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: numofpage,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      if ((curpage - 1) == index) {
                        color = Colors.red;
                      } else {
                        color = Colors.blue;
                      }
                      return TextButton(
                        onPressed: () {
                          curpage = index + 1;
                          loadBooks(title);
                        },
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(color: color, fontSize: 22),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  String truncateString(String str) {
    if (str.length > 20) {
      str = str.substring(0, 20);
      return "$str...";
    } else {
      return str;
    }
  }

  void loadBooks(String title) {
    String userid = "all";
    http
        .get(
      Uri.parse(
          "${MyServerConfig.server}php/load_books.php?userid=$userid&title=$title&pageno=$curpage"),
    )
        .then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          bookList.clear();
          data['data']['books'].forEach((v) {
            bookList.add(Book.fromJson(v));
          });
          numofpage = int.parse(data['numofpage'].toString());
          numofresult = int.parse(data['numberofresult'].toString());
        } else {
          //if no status failed
        }
      }
      setState(() {});
    });
  }

  void showSearchDialog() {
    TextEditingController searchctlr = TextEditingController();
    title = searchctlr.text;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Search Title",
            style: TextStyle(),
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: searchctlr,
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  loadBooks(searchctlr.text);
                },
                child: const Text("Search"),
              )
            ],
          ),
        );
      },
    );
  }
}
