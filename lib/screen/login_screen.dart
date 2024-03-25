import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:story_app/model/user.dart';
import 'package:story_app/provider/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  final Function() onLogin;
  final Function() onRegister;

  const LoginScreen(
      {super.key, required this.onLogin, required this.onRegister});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Screen"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/login_story_app.png',
                    width: 200,
                    height: 200,
                  ),
                  TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email.';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "Email",
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(hintText: "Password"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  context.watch<AuthProvider>().isLoadingLogin
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              final scaffoldMessenger =
                                  ScaffoldMessenger.of(context);
                              final User user = User(
                                  email: emailController.text,
                                  password: passwordController.text);
                              final authRead = context.read<AuthProvider>();

                              final result = await authRead.login(user);
                              if (result) {
                                print("Success login");
                                widget.onLogin();
                              } else {
                                print("gagal login");
                                scaffoldMessenger.showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Your email or password is invalid")),
                                );
                              }
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.deepPurple)),
                          child: const Text("Login",
                              style: TextStyle(color: Colors.white)),
                        ),
                  const SizedBox(
                    height: 8,
                  ),
                  OutlinedButton(
                      onPressed: () => widget.onRegister(),
                      child: const Text("REGISTER"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
