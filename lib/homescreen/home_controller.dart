import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloudyml_app2/global_variable.dart' as globals;
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workmanager/workmanager.dart';

import '../Providers/UserProvider.dart';
import '../models/course_details.dart';

class HomeController extends GetxController {
  final BuildContext context;
  HomeController({required this.context});

  var numberOfLearners = '19000+ learners'.obs;

  var course = <CourseDetails>[].obs;
  var courses = [].obs;
  var searchcomplete = false.obs;

  var providerNotification;

  var getData = <String, dynamic>{}.obs;
  var coursePercent = {}.obs;
  var featuredCourse = <CourseDetails>[].obs;
  var userMap = Map<String, dynamic>().obs;

  var isAnnouncement = false.obs;
  var announcementMsg = ''.obs;
  var notificationBox = Hive.box('NotificationBox').obs;

  getPercentageOfCourse() async {
    try {
      await FirebaseFirestore.instance
          .collection('Users_dataly')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        courses.value = value.data()!['paidCourseNames'];

        print("courses = ${courses}");
      }).whenComplete(() {
        searchcomplete.value = true;
      });
    } catch (e) {
      print('coursess error ${e.toString()}');
    }

    print('1}');
    if (courses.length != 0) {
      print('2');

      try {
        await FirebaseFirestore.instance
            .collection("courseprogress")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((value) {
          getData.value = value.data()!;
          print('4');
        });
        print('getData = $getData');
        for (var courseId in courses) {
          print("ID = = ${courseId}");
          num count = 0;
          try {
            await FirebaseFirestore.instance
                .collection("courses")
                .where("id", isEqualTo: courseId)
                .get()
                .then((value) async {
              if (value.docs.first.exists) {
                var coursesName = value.docs.first.data()["courses"];
                print('coursesName = $coursesName');
                if (coursesName != null) {
                  print("name");
                  for (var Id in coursesName) {
                    num number = (getData[Id + "percentage"] != null)
                        ? getData[Id + "percentage"]
                        : 0;
                    count += number.toInt();
                    print("Count = ${count.toDouble()}");
                    coursePercent[courseId] =
                        count ~/ (value.docs.first.data()["courses"].length);
                  }
                } else {
                  print("yy");
                  print(getData[value.docs.first.data()["id"].toString() +
                          "percentage"]
                      .toString());
                  coursePercent[courseId] = getData[
                              value.docs.first.data()["id"].toString() +
                                  "percentage"] !=
                          null
                      ? getData[value.docs.first.data()["id"].toString() +
                          "percentage"]
                      : 0;
                }
              }
            }).catchError((err) => print("${err.toString()} Error"));
          } catch (err) {
            print('error 3 ${err.toString()}');
          }
        }
      } catch (e) {
        print('error 4 ${e.toString()}');
      }

      print("done");

      coursePercent;

      print(coursePercent);
    }
  }

  setFeaturedCourse(List<CourseDetails> course) async {
    featuredCourse.clear();
    course.forEach((element) {
      if (element.dataly_FcSerialNumber!.isNotEmpty && element.dataly_FcSerialNumber != null) {
        featuredCourse.add(element);
      }
    });
    featuredCourse.sort((a, b) {
      return int.parse(a.FcSerialNumber).compareTo(int.parse(b.FcSerialNumber));
    });
  }

  bool navigateToCatalogueScreen(String id) {
    if (userMap['payInPartsDetails'][id] != null) {
      final daysLeft = (DateTime.parse(
              userMap['payInPartsDetails'][id]['endDateOfLimitedAccess'])
          .difference(DateTime.now())
          .inDays);
      print(daysLeft);
      return daysLeft < 1;
    } else {
      return false;
    }
  }

  dbCheckerForPayInParts() async {
    DocumentSnapshot userDocs = await FirebaseFirestore.instance
        .collection('Users_dataly')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    userMap.value = userDocs.data() as Map<String, dynamic>;
    globals.quiztrack = userMap['quiztrack'];
  }

  bool statusOfPayInParts(String id) {
    if (!(userMap['payInPartsDetails'][id] == null)) {
      if (userMap['payInPartsDetails'][id]['outStandingAmtPaid']) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  launchWhatsapp() async {
    var note = await FirebaseFirestore.instance
        .collection('Notice')
        .doc('rLwaS5rDufmCQ7Gv5vMI')
        .get()
        .then((value) {
      return value.data()!['msg']; // Access your after your get the data
    });

    var whatsApp1 = await FirebaseFirestore.instance
        .collection('Notice')
        .doc('rLwaS5rDufmCQ7Gv5vMI')
        .get()
        .then((value) {
      return value.data()!['number']; // Access your after your get the data
    });

    print("the number is====$whatsApp1");

    var whatsapp = "+918902530551";
    var whatsappAndroid =
        Uri.parse("whatsapp://send?phone=$whatsApp1&text=$note");
    if (await canLaunchUrl(whatsappAndroid)) {
      await launchUrl(whatsappAndroid);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp is not installed on the device"),
        ),
      );
    }
  }

  void getAnnouncement() async {
    await FirebaseFirestore.instance
        .collection('Notice')
        .doc('qdsnWW9NtIHwuFOGcuus_Annoucement')
        .get()
        .then((value) {
      announcementMsg.value = value.data()!['Message'];
      isAnnouncement.value = value.data()!['show'];
    });
  }

  showNotification() async {
    final provider = Provider.of<UserProvider>(context, listen: false);
    if (notificationBox.value.isEmpty) {
      notificationBox.value.put(1, {"count": 0});
    }
  }

  void cancelBackgroundTask() {
    Workmanager().cancelByUniqueName(
        "getpercentageofcourse"); // Replace with your task's unique name
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("disposed.....");
    cancelBackgroundTask();
  }

  @override
  void onInit() {
    try {
      Workmanager()
          .initialize(callbackDispatcher)
          .catchError((onError) => print('oefjowieofwefjow4$onError'));
    } catch (e) {
      print("oefjowieofwefjow3$e");
    }

    course.value = Provider.of<List<CourseDetails>>(context);

    providerNotification = Provider.of<UserProvider>(context, listen: false);
    getPercentageOfCourse();
    setFeaturedCourse(course);
    dbCheckerForPayInParts();

    showNotification();

    super.onInit();
  }
}

void callbackDispatcher() {
  Workmanager().cancelByUniqueName("getpercentageofcourse");
  print('oefjowieofwefjow1');
  Workmanager().executeTask((task, inputData) {
    print('oefjowieofwefjow');
    getPercentageOfCourse();

    return Future.value(true);
  });
  Workmanager().registerPeriodicTask(
    "getpercentageofcourse", // A unique task name
    "backgroundTask", // The function name to execute (callbackDispatcher)
    frequency: Duration(minutes: 15), // Adjust the frequency as needed
  );
}

ValueNotifier<dynamic> courses = ValueNotifier([]);
ValueNotifier searchcomplete = ValueNotifier(false);
ValueNotifier getData = ValueNotifier({});
ValueNotifier coursePercent = ValueNotifier({});

getPercentageOfCourse() async {
  try {
    await FirebaseFirestore.instance
        .collection('Users_dataly')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      courses.value = value.data()!['paidCourseNames'];

      print("courses 2= ${courses}");
    }).whenComplete(() {
      searchcomplete.value = true;
    });
  } catch (e) {
    print('coursess error ${e.toString()}');
  }

  print('1}');
  if (courses.value.length != 0) {
    print('2');

    try {
      await FirebaseFirestore.instance
          .collection("courseprogress")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        getData.value = value.data()!;
        print('4');
      });
      print('getData = $getData');
      for (var courseId in courses.value) {
        print("ID = = ${courseId}");
        num count = 0;
        try {
          await FirebaseFirestore.instance
              .collection("courses")
              .where("id", isEqualTo: courseId)
              .get()
              .then((value) async {
            if (value.docs.first.exists) {
              var coursesName = value.docs.first.data()["courses"];
              print('coursesName = $coursesName');
              if (coursesName != null) {
                print("name");
                for (var Id in coursesName) {
                  num number = (getData.value[Id + "percentage"] != null)
                      ? getData.value[Id + "percentage"]
                      : 0;
                  count += number.toInt();
                  print("Count = ${count.toDouble()}");
                  coursePercent.value[courseId] =
                      count ~/ (value.docs.first.data()["courses"].length);
                }
              } else {
                print("yy");
                print(getData.value[
                        value.docs.first.data()["id"].toString() + "percentage"]
                    .toString());
                coursePercent.value[courseId] = getData.value[
                            value.docs.first.data()["id"].toString() +
                                "percentage"] !=
                        null
                    ? getData.value[
                        value.docs.first.data()["id"].toString() + "percentage"]
                    : 0;
              }
            }
          }).catchError((err) => print("${err.toString()} Error"));
        } catch (err) {
          print('error 3 ${err.toString()}');
        }
      }
    } catch (e) {
      print('error 4 ${e.toString()}');
    }

    print("done");

    coursePercent;

    print(coursePercent);
  }
}
