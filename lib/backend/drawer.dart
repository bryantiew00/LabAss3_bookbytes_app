// import 'package:bookbyte/pages/cartitempage.dart';
import 'package:flutter/material.dart';

import 'package:bookbyte/backend/InOut.dart' show EnterExitRoute;

import 'package:bookbyte/buyer/user.dart';
import 'package:bookbyte/pages/homepage.dart';
import 'package:bookbyte/pages/profilepage.dart';


class BDrawer extends StatefulWidget {
  final String page;
  final User userdata;

  const BDrawer(
    {super.key, required this.page, required this.userdata}
  );

  @override
  State<BDrawer> createState() => BDrawerState();
}

class BDrawerState extends State<BDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            currentAccountPicture: const CircleAvatar(
              foregroundImage: AssetImage('assets/images/profile.png'),
              backgroundColor: Colors.white,
            ),
            accountName: Text(widget.userdata.userName.toString()),
            accountEmail: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.userdata.userEmail.toString()),
                  // const Text("RM100")
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.money),
            title: const Text('Books'),
            onTap: () {
              Navigator.pop(context);
              if (widget.page.toString() == "books") {
                return;
              }
              Navigator.pop(context);
              Navigator.push(
                context,
                EnterExitRoute(
                  exit: BookListPage(
                    user: widget.userdata,
                  ),
                  enter: BookListPage(user: widget.userdata),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('My Account'),
            onTap: () {
              Navigator.pop(context);
              if (widget.page.toString() == "account") {
                return;
              }
              Navigator.pop(context);
              Navigator.push(
                context,
                EnterExitRoute(
                  exit: ProfilePage(userdata: widget.userdata),
                  enter: ProfilePage(userdata: widget.userdata),
                ),
              );
            },
          ),
          const Divider(
            color: Colors.blueGrey,
          ),
          // ListTile(
          //   leading: const Icon(Icons.shopping_cart_checkout),
          //   title: const Text('Setting'),
          //   onTap: () {
          //     // Navigator.pop(context);
          //     Navigator.push(
          //         context,
          //         EnterExitRoute(
          //             exit: CartPage(
          //               user: widget.userdata,
          //             ),
          //             enter: CartPage(
          //               user: widget.userdata,
          //             )));
          //   },
          // ),
        ],
      ),
    );
  }
}