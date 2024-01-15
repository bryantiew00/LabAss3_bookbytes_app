import '../backend/drawer.dart';
import '../pages/userloginpage.dart';
import '../pages/userregisterpage.dart';

import 'package:flutter/material.dart';

import '../buyer/user.dart';


class ProfilePage extends StatefulWidget {
  final User userdata;
  const ProfilePage({super.key, required this.userdata});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late double screenWidth, screenHeight;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "My Account",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey,
            height: 1.0,
          ),
        ),
      ),
      drawer: BDrawer(
        page: 'account',
        userdata: widget.userdata,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: screenHeight * 0.25,
              padding: const EdgeInsets.all(4),
              child: Card(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      width: screenWidth * 0.4,
                      height: screenHeight * 0.4,
                      child: const CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/profile.png'),
                        radius: 60,
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Column(
                        children: [
                          Text(
                            widget.userdata.userName.toString(),
                            style: const TextStyle(fontSize: 24),
                          ),
                          const Divider(
                            color: Colors.blueGrey,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (content) => const RegisterPage(),
                  ),
                );
              },
              title: const Text("Create New Account"),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (content) {
                      return const LoginPage();
                    },
                  ),
                );              },
              title: const Text("Sign Out"),
            ),
          ],
        ),
      ),
    );
  }
}
