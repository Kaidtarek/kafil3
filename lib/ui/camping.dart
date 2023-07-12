import 'package:flutter/material.dart';
class camping extends StatelessWidget {
  const camping({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){},child: Icon(Icons.add)),
      body: Center(child: Text('camping'),),
    );
  }
}