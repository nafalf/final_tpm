import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:final_tpm/models/user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  late Box<User> usersBox;

  @override
  void initState() {
    super.initState();
    usersBox = Hive.box('usersBox'); // buka box usersBox di main nanti
  }

  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  void registerUser() {
    if (_formKey.currentState!.validate()) {
      final username = _usernameCtrl.text.trim();
      final password = _passwordCtrl.text.trim();
      final hashedPassword = hashPassword(password);

      // Cek apakah username sudah ada
      User? existingUser;
      try {
        existingUser = usersBox.values.firstWhere(
          (user) => user.username == username,
        );
      } catch (_) {
        existingUser = null;
      }


      if (existingUser != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username sudah terdaftar')),
        );
        return;
      }

      // Simpan user baru
      final newUser = User(username: username, hashedPassword: hashedPassword);
      usersBox.add(newUser);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrasi berhasil, silakan login')),
      );

      Navigator.pop(context); // kembali ke halaman login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameCtrl,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Masukkan username' : null,
              ),
              TextFormField(
                controller: _passwordCtrl,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Masukkan password' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: registerUser,
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
