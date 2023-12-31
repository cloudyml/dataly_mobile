import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dataly_app/globals.dart';
import 'package:dataly_app/models/course_details.dart';
import 'package:dataly_app/models/user_details.dart';
import 'package:dataly_app/models/video_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

const ID = 'id';
const NAME = 'name';
const MOBILE = 'mobilenumber';
const EMAIL = 'email';
const IMAGE = 'image';
const USERNOTIFICATIONS = "usernotification";
const AUTHTYPE = "authType";
const PHONEVERIFIED = "phoneVerified";

class DatabaseServices {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<CourseDetails>> get courseDetails {
    return _fireStore.collection('courses').snapshots().map(
          (querySnapshot) => querySnapshot.docs
              .map(
                (documentSnapshot) => CourseDetails(
                  amountPayable: documentSnapshot.data()['Amount Payable'],
                  courseDocumentId: documentSnapshot.id,
                  courseId: documentSnapshot.data()['id'],
                  courseImageUrl: documentSnapshot.data()['image_url'],
                  courseLanguage: documentSnapshot.data()['language'],
                  // courseMentors: documentSnapshot.data()['mentors'],
                  coursePrice: documentSnapshot.data()['Course Price'],
                  createdBy: documentSnapshot.data()['created by'],
                  discount: documentSnapshot.data()['Discount'],
                  isItComboCourse: documentSnapshot.data()['combo'],
                  courses: documentSnapshot.data()['courses'] ?? [''],
                  courseName: documentSnapshot.data()['name'],
                  // isItPaidCourse: documentSnapshot.data()['paid'],
                  numOfVideos:
                      documentSnapshot.data()['videosCount'].toString(),
                  curriculum: documentSnapshot.data()['curriculum1'],
                  show: documentSnapshot.data()['show'],
                  courseDescription: documentSnapshot.data()['description'],
                  FcSerialNumber: documentSnapshot.data()['FC'] ?? '',
                  courseContent: documentSnapshot.data()['courseContent'],
                  free: documentSnapshot.data()['free'],
                  duration: documentSnapshot.data()['duration'],
                  reviews: documentSnapshot.data()['reviews'],
                  trialCourse: documentSnapshot.data()['trialCourse'],
                  trialDays: documentSnapshot.data()['trialDays'],
                  multiCombo: documentSnapshot.data()['multiCombo'],
                  international: documentSnapshot.data()['international'],
                    dataly_actual_price: documentSnapshot.data()['dataly_actual_price'] ?? null,
                    dataly_discounted_price: documentSnapshot.data()['dataly_discounted_price'] ?? null,
                    dataly_FcSerialNumber: documentSnapshot.data()['dataly_FcSerialNumber'] ?? ''
                ),
              )
              .toList(),
        );
  }

  Stream<List<VideoDetails>> get videoDetails {
    return _fireStore
        .collection('courses')
        .doc(courseId)
        .collection('Modules')
        .doc(moduleId)
        .collection('Topics')
        .orderBy('sr')
        .snapshots()
        .map(
          (querySnapshot) => querySnapshot.docs
              .map(
                (documentSnapshot) => VideoDetails(
                  videoId: documentSnapshot.data()['id'] ?? '',
                  type: documentSnapshot.data()['type'] ?? '',
                  canSaveOffline: documentSnapshot.data()['Offline'] ?? true,
                  serialNo: documentSnapshot.data()['sr'].toString(),
                  videoTitle: documentSnapshot.data()['name'] ?? '',
                  videoUrl: documentSnapshot.data()['url'] ?? '',
                ),
              )
              .toList(),
        );
  }

  static Future<UserDetails> userDetails(BuildContext context) async {
    return await FirebaseFirestore.instance
        .collection('Users_dataly')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then(
          (documentSnapshot) => UserDetails(
            userName: (documentSnapshot.data()![NAME] == '')
                ? 'Enter Your Name'
                : documentSnapshot.data()![NAME],
            userId: documentSnapshot.data()![ID],
            emailId: (documentSnapshot.data()![EMAIL] == '')
                ? 'Enter Your Email'
                : documentSnapshot.data()![EMAIL],
            mobilenumber: documentSnapshot.data()![MOBILE],
            paidCoursesId: documentSnapshot.data()!['paidCourseNames'],
            payInPartsDetails: documentSnapshot.data()!['payInPartsDetails'],
            role: documentSnapshot.data()!['role'],
            authType: documentSnapshot.data()![AUTHTYPE],
            image: documentSnapshot.data()![IMAGE],
            phoneVerified: documentSnapshot.data()![PHONEVERIFIED],
          ),
        );
    // .snapshots()
    // .map(
    //   (documentSnapshot) => UserDetails(
    //     userName: (documentSnapshot.data()![NAME] == '')
    //         ? 'Enter Your Name'
    //         : documentSnapshot.data()![NAME],
    //     userId: documentSnapshot.data()![ID],
    //     emailId: (documentSnapshot.data()![EMAIL] == '')
    //         ? 'Enter Your Email'
    //         : documentSnapshot.data()![EMAIL],
    //     mobilenumber: documentSnapshot.data()![MOBILE],
    //     paidCoursesId: documentSnapshot.data()!['paidCourseNames'],
    //     payInPartsDetails: documentSnapshot.data()!['payInPartsDetails'],
    //     role: documentSnapshot.data()!['role'],
    //     authType: documentSnapshot.data()![AUTHTYPE],
    //     image: documentSnapshot.data()![IMAGE],
    //     phoneVerified: documentSnapshot.data()![PHONEVERIFIED],
    //   ),
    // );
  }

  Stream<UserDetails?> get currentUserDetails {
    return FirebaseFirestore.instance
        .collection('Users_dataly')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .map(
          (documentSnapshot) => UserDetails(
            userName: (documentSnapshot.data()![NAME] == '')
                ? 'Enter Your Name'
                : documentSnapshot.data()![NAME],
            userId: documentSnapshot.data()![ID],
            emailId: (documentSnapshot.data()![EMAIL] == '')
                ? 'Enter Your Email'
                : documentSnapshot.data()![EMAIL],
            mobilenumber: documentSnapshot.get(MOBILE).toString(),
            paidCoursesId: documentSnapshot.get('paidCourseNames'),
            payInPartsDetails: documentSnapshot.get('payInPartsDetails'),
            role: documentSnapshot.data()!['role'],
            authType: documentSnapshot.data()![AUTHTYPE],
            image: documentSnapshot.data()![IMAGE],
            phoneVerified: documentSnapshot.data()![PHONEVERIFIED],
          ),
        );
  }
}
