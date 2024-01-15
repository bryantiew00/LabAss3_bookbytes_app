// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'package:bookbyte/pages/userregisterpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bookbyte/backend/my_server_config.dart';
import 'package:bookbyte/buyer/user.dart';
import 'package:bookbyte/pages/homepage.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final FocusNode _focusNodePassword = FocusNode();
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController passwordEditingController = TextEditingController();

  bool isChecked = false;
  bool securePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login.jpeg'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(35.0),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    "Welcome to 3B's BookByte Store",
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 200),
                  const SizedBox(height: 190),
                  TextFormField(
                    controller: emailEditingController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(290),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(290),
                      ),
                    ),
                    onEditingComplete: () => _focusNodePassword.requestFocus(),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter email.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passwordEditingController,
                    focusNode: _focusNodePassword,
                    obscureText: securePassword,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              securePassword = !securePassword;
                            });
                          },
                          icon: securePassword
                              ? const Icon(Icons.visibility_outlined)
                              : const Icon(Icons.visibility_off_outlined)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(350),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(350),
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter password.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 43),
                  Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(400),
                          ),
                        ),
                        onPressed: () {
                          userLogin();
                        },
                        child: const Text("Sign In"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Do Not Have an Account?"),
                          TextButton(
                            onPressed: () {
                              _formKey.currentState?.reset();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const RegisterPage();
                                  },
                                ),
                              );
                            },
                            child: const Text("Sign Up"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _focusNodePassword.dispose();
    emailEditingController.dispose();
    passwordEditingController.dispose();
    super.dispose();
  }

  void userLogin() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    String email = emailEditingController.text;
    String pass = passwordEditingController.text;

    http.post(
      Uri.parse("${MyServerConfig.server}php/user_login.php"),
      body: {"email": email, "password": pass},
    ).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          User user = User.fromJson(data['data']);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Successful"),
            backgroundColor: Colors.green,
          ));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookListPage(user: user),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Not Successful"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}