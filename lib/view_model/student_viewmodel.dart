import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_class_app/model/student.dart';
import 'package:riverpod_class_app/state/student_state.dart';

final studentViewModelProvider =
    StateNotifierProvider<StudentViewModel, StudentState>(
        (ref) => StudentViewModel());

class StudentViewModel extends StateNotifier<StudentState> {
  StudentViewModel() : super(StudentState.initialState()) {
    getStudent();
  }
  //get Student
  void getStudent() {
    state = state.copyWith(isLoading: true);
    // state.students.add(Student(fname: "ads", lname: "Asdas", dob: "Asdasd"));
    // state.students.add(Student(fname: "ads", lname: "Asdas", dob: "Asdasd"));
    state = state.copyWith(isLoading: false);
  }

  //Add Student
  void addStudent(Student student) {
    state = state.copyWith(isLoading: true);
    state.students.add(student);
    state = state.copyWith(isLoading: false);
  }

  //Delete Student
  void deleteStudent(Student student) {
    state = state.copyWith(isLoading: true);
    state.students.remove(student);
    state = state.copyWith(isLoading: false);
  }
}
