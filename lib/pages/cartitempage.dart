// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import '../buyer/user.dart';
import '../buyer/cart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../backend/my_server_config.dart' show MyServerConfig;

class CartPage extends StatefulWidget {
  final User user;

  const CartPage({Key? key, required this.user}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Carts> cartList = <Carts>[];
  double total = 0.0;

  @override
  void initState() {
    super.initState();
    loadUserCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueGrey,
        title: const Text("My Cart"),
        centerTitle: true,
      ),
      body: cartList.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart, size: 78, color: Colors.grey),
                  Text("Your cart is Empty"),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: cartList.length,
                      itemBuilder: (context, index) {
                        return cartItem(index);
                      }),
                ),
                totalSection(),
              ],
            ),
    );
  }

  Widget cartItem(int index) {
    return Dismissible(
      key: Key(cartList[index].bookId.toString()),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        deleteCart(index);
      },
      child: Card(
        margin: const EdgeInsets.all(8),
        child: ListTile(
          title: Text(cartList[index].bookTitle.toString()),
          subtitle: Text("RM ${cartList[index].bookPrice}"),
          leading: const Icon(Icons.book),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  updateCartQuantity(index, -1);
                },
              ),
              Text("${cartList[index].cartQty} unit"),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  updateCartQuantity(index, 1);
                },
              ),
            ],
          ),
          onTap: () {},
        ),
      ),
    );
  }

  Widget totalSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "TOTAL RM ${total.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(onPressed: () {}, child: const Text("Pay Now"))
        ],
      ),
    );
  }

  void loadUserCart() {
    String userid = widget.user.userId.toString();
    http
        .get(
      Uri.parse("${MyServerConfig.server}php/loading_cart.php?userid=$userid"),
    )
        .then((response) {
      if (response.statusCode == 200) {
        log(response.body);
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          cartList.clear();
          total = 0.0;
          for (var v in data['data']['carts']) {
            Carts cartItem = Carts.fromJson(v);
            total += (double.parse(v['book_price']) * int.parse(v['cart_qty']+ 10.00));
            mergeCartItems(cartItem);
          }
          setState(() {});
        } else {
          // Handle status failed scenario
        }
      } else {
        // Handle server error scenario
      }
    }).timeout(const Duration(seconds: 5), onTimeout: () {
      // Handle timeout scenario
    });
  }

  void mergeCartItems(Carts item) {
    int index = cartList.indexWhere((cart) => cart.bookId == item.bookId);
    if (index != -1) {
      cartList[index].cartQty = (int.parse(cartList[index].cartQty.toString()) +
              int.parse(item.cartQty.toString()))
          .toString();
      cartList[index].bookPrice =
          (double.parse(cartList[index].bookPrice.toString()) +
                  double.parse(item.bookPrice.toString()))
              .toString();
    } else {
      cartList.add(item);
    }
  }

  void deleteCart(int index) {
    http.post(Uri.parse("${MyServerConfig.server}php/remove_cart.php"), body: {
      "cartid": cartList[index].cartId,
    }).then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          setState(() {
            cartList.removeAt(index);
            recalculateTotal();
          });
          showSnackBar("Delete Success");
        } else {
          showSnackBar("Delete Failed");
        }
      } else {
        showSnackBar("Server error");
      }
    });
  }

  void updateCartQuantity(int index, int change) async {
    int currentQuantity = int.parse(cartList[index].cartQty.toString());
    int newQuantity = currentQuantity + change;

    // Force the new quantity to be at least 1 (assuming a minimum quantity of 1)
    newQuantity = newQuantity > 0 ? newQuantity : 1;

    // Make HTTP POST request to update the cart on the server
    try {
      final response = await http.post(
        Uri.parse("${MyServerConfig.server}php/update_cart.php"),
        body: {
          "cartid": cartList[index].cartId,
          "newqty": newQuantity.toString(),
        },
      );

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          // Update UI with the new quantity
          setState(() {
            cartList[index].cartQty = newQuantity.toString();
          });

          recalculateTotal();

          showSnackBar("Quantity Updated Successfully");
        } else {
          // Update UI with the previous quantity
          setState(() {
            cartList[index].cartQty = currentQuantity.toString();
          });

          recalculateTotal();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Error"),
                content: const Text("Quantity exceeds available books."),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
          // showSnackBar("Failed to Update Quantity");
        }
      } else {
        // Update UI with the previous quantity
        setState(() {
          cartList[index].cartQty = currentQuantity.toString();
        });

        recalculateTotal();

        showSnackBar("Server error");
      }
    } catch (e) {
      // Update UI with the previous quantity
      setState(() {
        cartList[index].cartQty = currentQuantity.toString();
      });

      recalculateTotal();

      print("Error updating quantity: $e");
      showSnackBar("Error updating quantity");
    }
  }

  void recalculateTotal() {
    total = 0.0;
    for (var item in cartList) {
      if (item.bookPrice != null && item.cartQty != null) {
        try {
          total += (double.parse(item.bookPrice.toString()) *
                  int.parse(item.cartQty.toString()) +
              10.00);
        } catch (e) {
          // Handle parsing errors, e.g., invalid data in cartList
          print("Error parsing data: $e");
        }
      }
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
