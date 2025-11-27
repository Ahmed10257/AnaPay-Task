import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  /// The currently logged in user's display name.
  /// Pass the real username here when authentication is available.
  final String username;

  const HomePage({Key? key, this.username = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayName = username.isNotEmpty ? username : 'Guest';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SafeArea(
        child: Center(
          child: Text(
            'Hi, $displayName',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}