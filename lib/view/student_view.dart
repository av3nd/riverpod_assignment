import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_class_app/model/student.dart';
import 'package:riverpod_class_app/view_model/student_viewmodel.dart';

class StudentView extends ConsumerStatefulWidget {
  const StudentView({super.key});

  @override
  ConsumerState<StudentView> createState() => _StudentViewState();
}

class _StudentViewState extends ConsumerState<StudentView> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController marksController = TextEditingController();
  bool addingStudent = false; // Track the progress state
  String? selectedCourse;
  List<String> courses = [
    'wep-api',
    'flutter',
    'Design thinking',
    'Data Science'
  ];

  String calculateResult(List<Student> students) {
    int totalMarks =
        students.map((student) => student.marks).reduce((a, b) => a + b);
    double averageMarks = totalMarks / students.length;

    if (averageMarks >= 40) {
      return 'Pass';
    } else {
      return 'Fail';
    }
  }

  String calculateDivision(List<Student> students) {
    double averageMarks =
        students.map((student) => student.marks).reduce((a, b) => a + b) /
            students.length;

    if (averageMarks >= 60) {
      return '1st';
    } else if (averageMarks >= 50) {
      return '2nd';
    } else if (averageMarks >= 40) {
      return '3rd';
    } else {
      return 'Fail';
    }
  }

  @override
  Widget build(BuildContext context) {
    var data = ref.watch(studentViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("STUDENT's MARKS GENERATOR"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: "First Name"),
            ),
            TextFormField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: "Last Name"),
            ),
            DropdownButtonFormField<String>(
              value: selectedCourse,
              onChanged: (newValue) {
                setState(() {
                  selectedCourse = newValue!;
                });
              },
              items: courses.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: 'Course'),
            ),
            TextFormField(
              controller: marksController,
              decoration: const InputDecoration(labelText: "Marks"),
            ),
            ElevatedButton(
              onPressed: () async {
                // setState(() {
                //   addingStudent = true;
                // });

                Student student = Student(
                    fname: firstNameController.text.trim(),
                    lname: lastNameController.text.trim(),
                    courses: selectedCourse,
                    marks: int.parse(marksController.text.trim()));
                ref.read(studentViewModelProvider.notifier).addStudent(student);

                // setState(() {
                //   addingStudent = false;
                // });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Student Added Successfully'),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: //addingStudent
                  //     ? CircularProgressIndicator() // Show the progress bar if addingStudent is true
                  //     :
                  const Text("Add"),
            ),
            if (data.students.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('First Name')),
                      DataColumn(label: Text('Marks')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: data.students.map((student) {
                      return DataRow(
                        cells: [
                          DataCell(Text(student.fname!)),
                          DataCell(Text(student.marks.toString())),
                          DataCell(
                            IconButton(
                              onPressed: () {
                                ref
                                    .read(studentViewModelProvider.notifier)
                                    .deleteStudent(student);
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            SizedBox(height: 10),
            if (data.students.isNotEmpty)
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius:
                      BorderRadius.circular(10), // Adjust the radius as desired
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Marks: ${data.students.map((student) => student.marks).reduce((a, b) => a + b)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Result: ${calculateResult(data.students)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Division: ${calculateDivision(data.students)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              )
            else
              const Text('No Data')
          ],
        ),
      ),
    );
  }
}
