// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bookbyte/backend/my_server_config.dart' show MyServerConfig;
import 'package:bookbyte/pages/userloginpage.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final FocusNode _focusNodeEmail = FocusNode();
 //final FocusNode _focusNodePhone = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  final FocusNode _focusNodeConfirmPassword = FocusNode();
  final TextEditingController controllerUsername = TextEditingController();
  final TextEditingController controllerEmail = TextEditingController();
 //final TextEditingController controllerPhone = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  final TextEditingController _controllerConFirmPassword = TextEditingController();
  
  String eula = "";
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              const SizedBox(height: 100),
              const Text(
                "3Bs BookBytes Store",
                style: TextStyle (fontSize: 36,fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Sign Up",
                style: TextStyle (fontSize: 25,fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: controllerUsername,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Username",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(500),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(500),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter username.";
                  } 
                  return null;
                },
                onEditingComplete: () => _focusNodeEmail.requestFocus(),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controllerEmail,
                focusNode: _focusNodeEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(500),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(500),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter email.";
                  } else if (!(value.contains('@') && value.contains('.'))) {
                    return "Invalid email";
                  }
                  return null;
                },
              //   onEditingComplete: () => _focusNodePhone.requestFocus(),
              // ),
              // const SizedBox(height: 10),
              // TextFormField(
              //   controller: controllerPhone,
              //   focusNode: _focusNodePhone,
              //   keyboardType: TextInputType.phone,
              //   decoration: InputDecoration(
              //     labelText: "Phone Number",
              //     prefixIcon: const Icon(Icons.phone_outlined),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(500),
              //     ),
              //     enabledBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(500),
              //     ),
              //   ),
              //   validator: (String? value) {
              //     if (value == null || value.isEmpty) {
              //       return "Please enter phone number.";
              //     } else if (value.length < 11) {
              //       return "Invalid Phone Number";
              //     }
              //     return null;
              //   },
                onEditingComplete: () => _focusNodePassword.requestFocus(),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controllerPassword,
                obscureText: _obscurePassword,
                focusNode: _focusNodePassword,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: _obscurePassword
                          ? const Icon(Icons.visibility_outlined)
                          : const Icon(Icons.visibility_off_outlined)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(450),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(450),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter password.";
                  } else if (value.length < 8) {
                    return "Password must be at least 8 character.";
                  }
                  return null;
                },
                onEditingComplete: () =>
                    _focusNodeConfirmPassword.requestFocus(),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerConFirmPassword,
                obscureText: _obscurePassword,
                focusNode: _focusNodeConfirmPassword,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: _obscurePassword
                          ? const Icon(Icons.visibility_outlined)
                          : const Icon(Icons.visibility_off_outlined)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(500),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(500),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter password.";
                  } else if (value != controllerPassword.text) {
                    return "Password not match.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 50),
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(500),
                      ),
                    ),
                    onPressed: () {
                      registerUser();},
                    child: const Text("Register", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?",style: TextStyle(fontSize: 15)),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("SIGN IN", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
    _focusNodeConfirmPassword.dispose();
    controllerUsername.dispose();
    controllerEmail.dispose();
    //controllerPhone.dispose();
    controllerPassword.dispose();
    _controllerConFirmPassword.dispose();
    super.dispose();
  }


void registerUser() {
    String name = controllerUsername.text;
    String email = controllerEmail.text;
    String pass = controllerPassword.text;
    //String phone = controllerPhone.text;
    if (!_formKey.currentState!.validate()) {
      return;
    }

    http.post(
        Uri.parse("${MyServerConfig.server}php/user_register.php"),
        body: {
          "name": name,
          "email": email,
         // "phone number": phone,
          "password": pass
        }).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
            content: Text("Registered Successful"),
            backgroundColor: Colors.green,
          ));
           Navigator.push(context,
              MaterialPageRoute(builder: (content) => const LoginPage()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Register Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}
