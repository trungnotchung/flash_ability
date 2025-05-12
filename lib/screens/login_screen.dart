import 'package:flutter/material.dart';

import '../mock_data/profile/profile.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate network delay
      Future.delayed(const Duration(seconds: 1), () {
        final username = _usernameController.text;
        final password = _passwordController.text;

        final user = userAccounts.firstWhere(
          (user) =>
              user['username'] == username && user['password'] == password,
          orElse: () => {},
        );

        setState(() {
          _isLoading = false;
        });

        if (user.isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Login successful!')));
          // Navigate to main screen and remove all previous routes
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid username or password'),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    }
  }

  void _showRegisterDialog() {
    final _regUsernameController = TextEditingController();
    final _regPasswordController = TextEditingController();
    final _regEmailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Register New Account'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _regUsernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _regEmailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _regPasswordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final username = _regUsernameController.text.trim();
                final email = _regEmailController.text.trim();
                final password = _regPasswordController.text.trim();
                if (username.isNotEmpty &&
                    password.isNotEmpty &&
                    email.isNotEmpty) {
                  // Check if username already exists
                  final exists = userAccounts.any(
                    (u) => u['username'] == username,
                  );
                  if (exists) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Username already exists!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    userAccounts.add({
                      'username': username,
                      'name': username,
                      'email': email,
                      'password': password,
                      'learningLevel': 'Beginner',
                      'learningProgress': '0%',
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Account created! Please log in.'),
                      ),
                    );
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('Register'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F3FF),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Flashcard + Accessibility Icon
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.style,
                        size: 72,
                        color: Colors.deepPurple[200],
                      ), // flashcard
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Icon(
                          Icons.bolt,
                          size: 32,
                          color: Colors.amber,
                        ), // flash
                      ),
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: Icon(
                          Icons.accessibility_new,
                          size: 32,
                          color: Colors.green[400],
                        ), // accessibility
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // App Name
                  Text(
                    'FlashAbility',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                      letterSpacing: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  // Tagline
                  Text(
                    'Flashcards for Everyone, Anywhere',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.deepPurple[300],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  // Username Field
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Please enter your username'
                                : null,
                  ),
                  const SizedBox(height: 16),
                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Please enter your password'
                                : null,
                  ),
                  const SizedBox(height: 24),
                  // Login Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              'Start Learning',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                  ),
                  TextButton(
                    onPressed: () {
                      _showRegisterDialog();
                    },
                    child: const Text(
                      "Don't have an account? Sign Up",
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
