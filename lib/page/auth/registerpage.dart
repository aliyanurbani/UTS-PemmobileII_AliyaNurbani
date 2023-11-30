import 'package:flutter/material.dart';
import 'package:utspemwebaliya/page/auth/loginpage.dart';
import 'package:utspemwebaliya/service/akunservice.dart';

import '../../models/akun.dart';

class RegisterPage extends StatelessWidget {
  final AkunService _authService = AkunService();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Color.fromRGBO(250, 193, 48, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _namaController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nama',
                labelText: 'Nama',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Email',
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Password',
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Text('Sudah punya akun? Login sekarang'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                String id = DateTime.now().millisecondsSinceEpoch.toString();
                String nama = _namaController.text;
                String email = _emailController.text;
                String password = _passwordController.text;

                if (nama.isEmpty || email.isEmpty || password.isEmpty) {
                  return;
                }

                Akun newAccount =
                    Akun(id: id, nama: nama, email: email, password: password);

                bool registrationResult =
                    await _authService.saveAkun(newAccount, context);

                if (registrationResult) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                } else {}
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 32),
                primary: Color.fromRGBO(250, 193, 48, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: Container(
                width: double.infinity,
                child: Center(
                  child: Text('REGISTER'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: RegisterPage(),
  ));
}
