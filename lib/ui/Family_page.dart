import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kafil/Services/Family.dart';
import 'package:kafil/ui/add_family.dart';

class FamilyPage extends StatefulWidget {
  const FamilyPage({Key? key}) : super(key: key);

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  final Stream<QuerySnapshot> _familiesStream =
      FirebaseFirestore.instance.collection('family').snapshots();

  Future<List<DocumentSnapshot>> getKidsDocuments(
      DocumentSnapshot familyDocument) async {
    final kidsSnapshot =
        await familyDocument.reference.collection('Kids').get();
    return kidsSnapshot.docs;
  }

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

                        final List<Kids> kids = kidsSnapshot.data ?? [];

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
                                    Row(
                                      children: [
                                        Icon(Icons.location_on),
                                        SizedBox(width: 4),
                                        IconButton(
                                          icon: Icon(Icons.edit,
                                              color: Colors.deepPurple),
                                          onPressed: () {
                                            Family f = Family(
                                                family_name:
                                                    data['family_name'],
                                                father_name:
                                                    data['father_name'],
                                                mother_name:
                                                    data['mother_name'],
                                                father_sick:
                                                    data['father_sick'],
                                                mother_sick:
                                                    data['mother_sick'],
                                                fatherInLife:
                                                    data['father_alive'],
                                                motherInLife:
                                                    data['mother_alive'],
                                                kids: kids);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FamilyEditor(
                                                          initialFamily: f,
                                                          doc: document
                                                              .reference,
                                                        )));
                                          },
                                        ),
                                      ],
                                    ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FamilyEditor()),
          );
        },
        child: Image.asset('assets/add_family.png'),
      ),
    );
  }
}