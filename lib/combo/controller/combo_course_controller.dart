import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ComboCourseController extends GetxController {
  final List<dynamic>? courses;
  ComboCourseController({required this.courses});

  @override
  void onInit() {
    print('Courses is ::: $courses');
    print('Courses Length ::: ${courses!.length}');

    getCourses();
    getPercentageOfCourse();

    super.onInit();
  }

  var courseList = [].obs;
  var courseData = {}.obs;
  var tmp = [].obs;
  var oldModuleProgress = false.obs;

  getCourses() async {
    await {
      courses!.forEach((element) {
        Future<QuerySnapshot<Map<String, dynamic>>> data = FirebaseFirestore
            .instance
            .collection("courses")
            .where('id', isEqualTo: element)
            .get();
        data.then((value) {
          courseList.add(value.docs.first.data());
          courseList.sort((a, b) =>
              courses!.indexOf(a["id"]).compareTo(courses!.indexOf(b["id"])));
        });
      })
    };
  }

  getPercentageOfCourse() async {
    try{

       var data = await FirebaseFirestore.instance
        .collection("courseprogress")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

      tmp.clear();
      for (var i = 0; i < data.data()!.length; i++) {
        try {
          if (i != 0) {
            tmp.add(data.data()![courses![i] + "percentage"]);
          }
        } catch (e) {}
      }
      for (int i = 1; i < tmp.length; i++) {
        if (tmp[i] is int) {
          oldModuleProgress.value = true;
        }
      }




 courseData.value = data.data() as Map;

    }catch(e){
      print("the progress exception for mobile is-$e");
    }
    

  }

}
