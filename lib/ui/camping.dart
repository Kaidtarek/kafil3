import 'package:flutter/material.dart';
class camping extends StatelessWidget {
  const camping({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){},child: Icon(Icons.add)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(color: Colors.amber,child: Text('hello'),),
            SizedBox(height: 16,),
            Container(color: Colors.amber,child: Text('heillo'),),
          ],
        ),
      ),
    );
  }
}