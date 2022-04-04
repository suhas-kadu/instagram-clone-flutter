import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/resources/auth_methods.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';
import 'package:instagram_clone_flutter/utils/utils.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _emailController = TextEditingController();

  resetPassword() async {
    String res =
        await AuthMethods().resetPassword(_emailController.text.trim());

    if (res != "success") {
      showSnackBar(context, res);
    } else {
      showSnackBar(context, "Link to reset password sent on email");
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "You will get an email to reset your password",
                  style: TextStyle(fontSize: 28),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                      hintText: "Enter your email address"),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                    onPressed: resetPassword,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        margin: EdgeInsets.zero,
                        decoration: const BoxDecoration(color: Colors.blue),
                        child: const Text(
                          "Submit",
                          style: TextStyle(color: primaryColor),
                        ))),
              ]),
        ),
      ),
    );
  }
}
