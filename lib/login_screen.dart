// screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_journal/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailCtrl, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: passCtrl, obscureText: true, decoration: InputDecoration(labelText: "Password")),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                setState(() => loading = true);

                final error = await AuthService.signIn(
                  email:emailCtrl.text,
                  password:passCtrl.text,
                );

                setState(() => loading = false);

                if (error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("logged in")),
                  );
                                    Navigator.pop(context);

                } else {
                  Navigator.pop(context);
                }
              },
              child: loading ? CircularProgressIndicator() : Text("Login"),
            ),


        ElevatedButton(
              onPressed: () async {
                setState(() => loading = true);

                final error = await AuthService.signUp(
                  email:emailCtrl.text,
                  password:passCtrl.text,
                );

                setState(() => loading = false);

                if (error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("signed up")),
                  );
                                    Navigator.pop(context);

                } else {
                  Navigator.pop(context);
                }
              },
              child: loading ? CircularProgressIndicator() : Text("Sign up"),
            ),

          ],
        ),
      ),
    );
  }
}