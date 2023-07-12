
import 'package:flutter/material.dart';
import 'package:kafil/ui/stock.dart';
import 'package:kafil/widget/stockwithSearch.dart';
import '../widget/basics_fam_info.dart';

class MaterialScreen extends StatelessWidget {
  MaterialScreen({required this.titleController});
  final String titleController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(children: [
            TextSpan(
              text: '$titleController',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            TextSpan(
              text: '  admin controller',
              style: TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 103, 84, 84),
              ),
            ),
          ]),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Container(
                height: 2, width: double.infinity, color: Colors.deepPurple),
            SizedBox(height: 20),
            SizedBox(height: 8),
            Container(height: 160, child: StockwithSearch()),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return My_stock();
                }));
              },
              child: Text(
                'See Stock',
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 8),
            Container(
                height: 2, width: double.infinity, color: Colors.deepPurple),
                SizedBox(height: 8),
            Container(
              height: 300,
              child: GetFamilies( Check_box: true,),
            )
          ],
        ),
      ),
    );
  }
}
