import 'package:flutter/material.dart';
import 'package:kafil/widget/edit_camp.dart';
import 'package:kafil/widget/stockwithSearch.dart';
import 'package:intl/intl.dart';

class Camp extends StatefulWidget {

  @override
  State<Camp> createState() => _CampState();
}

class _CampState extends State<Camp> {
  List<Gotocamping> camping_info = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddCamping(
                onCampingAdded: (itemCamp) {
                  setState(() {
                    camping_info.add(itemCamp);
                  });
                },
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 150,
              child: StockwithSearch(),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              color: Colors.deepPurple,
              height: 2,
            ),
            SizedBox(
              height: 8,
            ),
            Flexible(
              child: ListView.builder(
                itemCount: camping_info.length,
                itemBuilder: (context, index) {
                  return Card(
                      color: const Color.fromARGB(255, 255, 250, 250),
                      child: ListTile(
                        title: Text(camping_info[index].camping_name ?? ''),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("to:  "),
                                Text(
                                  '${camping_info[index].place ?? ''}',
                                  style: TextStyle(color: Colors.deepPurple),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Text("Start: "),
                                Text(
                                  '${DateFormat.yMd().format(camping_info[index].startDate!)}',
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Finish: "),
                                Text(
                                  '${DateFormat.yMd().format(camping_info[index].finishDate!)}',
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text("with: "),
                                Text(
                                  '${camping_info[index].num_ppl}',
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text("by: "),
                                Text(
                                  '${camping_info[index].num_employee}',
                                ),
                                Text(" employee "),
                              ],
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return EditCamping(
                                  camping: camping_info[index],
                                  onCampingEdited: (editedCamp) {
                                    setState(() {
                                      camping_info[index] = editedCamp;
                                    });
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Gotocamping {
  late String camping_name;
  late String place;
  late DateTime startDate;
  late DateTime finishDate;
  late int num_ppl;
  late int num_employee;

  Gotocamping({
    required this.camping_name,
    required this.num_employee,
    required this.num_ppl,
    required this.place,
    required this.startDate,
    required this.finishDate,
  });

  set setName(String name) {
    camping_name = name;
  }

  set setPlace(String p) {
    place = p;
  }

  set setStartDate(DateTime date) {
    startDate = date;
  }

  set setFinishDate(DateTime date) {
    finishDate = date;
  }

  set setNumPeople(int num) {
    num_ppl = num;
  }

  set setNumEmployee(int num) {
    num_employee = num;
  }
}

class AddCamping extends StatefulWidget {
  final Function(Gotocamping) onCampingAdded;

  AddCamping({required this.onCampingAdded});

  @override
  _AddCampingState createState() => _AddCampingState();
}

class _AddCampingState extends State<AddCamping> {
  final TextEditingController camping_nameController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  late DateTime selectedStartDate;
  late DateTime selectedFinishDate;
  final TextEditingController num_pplController = TextEditingController();
  final TextEditingController num_employeeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedStartDate = DateTime.now();
    selectedFinishDate = DateTime.now();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedStartDate) {
      setState(() {
        selectedStartDate = picked;
      });
    }
  }

  Future<void> _selectFinishDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedFinishDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedFinishDate) {
      setState(() {
        selectedFinishDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: Text('New Camping'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: camping_nameController,
              decoration: InputDecoration(labelText: 'اسم الرحلة'),
            ),
            TextField(
              controller: placeController,
              decoration: InputDecoration(labelText: 'مكان الرحلة'),
            ),
            GestureDetector(
              onTap: () => _selectStartDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'تاريخ بدء الرحلة',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                    text: DateFormat.yMd().format(selectedStartDate),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _selectFinishDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'تاريخ انتهاء الرحلة',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                    text: DateFormat.yMd().format(selectedFinishDate),
                  ),
                ),
              ),
            ),
            TextField(
              controller: num_pplController,
              decoration: InputDecoration(labelText: 'عدد الأشخاص المسافرين'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: num_employeeController,
              decoration: InputDecoration(labelText: 'عدد الموظفين الذاهبين'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Cancel',style: TextStyle(color: Colors.blueGrey),)),
          TextButton(
            onPressed: () {
              Gotocamping newcamp = Gotocamping(
                camping_name: camping_nameController.text,
                num_employee: int.tryParse(num_employeeController.text) ?? 0,
                num_ppl: int.tryParse(num_pplController.text) ?? 0,
                place: placeController.text,
                startDate: selectedStartDate,
                finishDate: selectedFinishDate,
              );
              widget.onCampingAdded(newcamp);
              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
