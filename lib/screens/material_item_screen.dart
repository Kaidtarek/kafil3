import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kafil/admin_show/gridOfActions/stock.dart';

import '../Services/Family.dart';
import '../ui/add_family.dart';

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
            Container(height: 2, width: double.infinity, color: Colors.deepPurple),
            SizedBox(height: 20),
            
            SizedBox(height: 8),
            Container(height: 160, child: JustTwoFirst()),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                  return My_stock();
                }));
              },
              child: Text(
                'See Stock',
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 8),
            Container(height: 2, width: double.infinity, color: Colors.deepPurple),
            Container(height: 160,child:GetFamilies(),)
          ],
        ),
      ),
    );
  }
}

class JustTwoFirst extends StatefulWidget {
  @override
  _JustTwoFirstState createState() => _JustTwoFirstState();
}

class _JustTwoFirstState extends State<JustTwoFirst> {
  late Stream<QuerySnapshot> _productStream;
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _productStream = FirebaseFirestore.instance.collection('Products').snapshots();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "Stock :",
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
              flex: 5,
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search product...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Flexible(
          child: StreamBuilder<QuerySnapshot>(
            stream: _productStream,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 48,
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              List<Widget> productList = snapshot.data!.docs.map((DocumentSnapshot document) {
                String docId = document.reference.id;
                print("This is doc ID: $docId");
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                String productName = data['Product_name'];

                // Filter the product list based on search text
                if (_searchText.isNotEmpty && !productName.toLowerCase().contains(_searchText.toLowerCase())) {
                  return SizedBox.shrink();
                }

                return Card(
                  color: Colors.grey[400],
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: ListTile(
                              title: Text("Product: $productName"),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Text("Quantity: ${data['Quantity']}"),
                                  SizedBox(height: 4),
                                  // Add more fields as needed
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList();

              return ListView(children: productList);
            },
          ),
        ),
      ],
    );
  }
}


//////////////////////////////////////////////////////////////
///   see families
//////////////////////////////////////////////////////////////
///
class GetFamilies extends StatefulWidget {
  const GetFamilies({super.key});

  @override
  State<GetFamilies> createState() => _GetFamiliesState();
}

class _GetFamiliesState extends State<GetFamilies> {
  final Stream<QuerySnapshot> _familiesStream =
  FirebaseFirestore.instance.collection('family').snapshots();
  Future<List<Kids>> change(DocumentSnapshot familyDocument) async {
    List<Kids> kids = [];
    final kidsDocuments = await getKidsDocuments(familyDocument);
    final kidsData = kidsDocuments.map((doc) => doc.data()).toList();
    for (var (kidData as Map) in kidsData) {
      Kids k = Kids(
        age: kidData['age'],
        name: kidData['name'],
        work: kidData['job'],
        sick: kidData['sick'],
      );
      kids.add(k);
    }
    return kids;
  }
  Future<List<DocumentSnapshot>> getKidsDocuments(
      DocumentSnapshot familyDocument) async {
    final kidsSnapshot =
        await familyDocument.reference.collection('Kids').get();
    return kidsSnapshot.docs;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Families",
              style: TextStyle(fontSize: 35),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _familiesStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.size == 0) {
                  return const Center(child: Text('No families found'));
                }

                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    return FutureBuilder<List<Kids>>(
                      future: change(document),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Kids>> kidsSnapshot) {
                        if (kidsSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        if (kidsSnapshot.hasError) {
                          return Text('Error: ${kidsSnapshot.error}');
                        }


                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return Column(
                          children: [
                            Card(
                              child: ListTile(
                                title: Text(data['family_name']),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 4),
                                    
                                  ],
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    // Handle the action when the info button is pressed
                                  },
                                  icon: Icon(Icons.info_outlined),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


// class FamilyScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Fetch family information from Firestore or any other data source
//     // Replace the dummy values with the actual values from your data source
//     String familyName = 'Smith';
//     String fatherName = 'John Smith';
//     String motherName = 'Jane Smith';
//     bool fatherSick = false;
//     bool motherSick = true;
//     bool fatherInLife = true;
//     bool motherInLife = true;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Family Information'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: FamilyInfoWidget(
//           familyName: familyName,
//           fatherName: fatherName,
//           motherName: motherName,
//           fatherSick: fatherSick,
//           motherSick: motherSick,
//           fatherInLife: fatherInLife,
//           motherInLife: motherInLife,
//         ),
//       ),
//     );
//   }
// }

// class FamilyInfoWidget extends StatelessWidget {
//   final String familyName;
//   final String fatherName;
//   final String motherName;
//   final bool fatherSick;
//   final bool motherSick;
//   final bool fatherInLife;
//   final bool motherInLife;

//   FamilyInfoWidget({
//     required this.familyName,
//     required this.fatherName,
//     required this.motherName,
//     required this.fatherSick,
//     required this.motherSick,
//     required this.fatherInLife,
//     required this.motherInLife,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Family Name: $familyName',
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 8),
//         Text('Father: $fatherName'),
//         Text('Mother: $motherName'),
//         SizedBox(height: 8),
//         Text('Father Sick: ${fatherSick ? 'Yes' : 'No'}'),
//         Text('Mother Sick: ${motherSick ? 'Yes' : 'No'}'),
//         SizedBox(height: 8),
//         Text('Father Alive: ${fatherInLife ? 'Yes' : 'No'}'),
//         Text('Mother Alive: ${motherInLife ? 'Yes' : 'No'}'),
//       ],
//     );
//   }
// }
