import 'dart:async';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:better_player/better_player.dart';
import 'package:dataly_app/combo/new_combo_course.dart';
import 'package:dataly_app/models/video_details.dart';
import 'package:dataly_app/globals.dart';
import 'package:dataly_app/module/assignment_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dataly_app/module/submit_resume.dart';
import 'package:dataly_app/screens/quiz/quizentry.dart';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:video_player/video_player.dart';
import 'package:dataly_app/global_variable.dart' as globals;
import '../homepage.dart';
import 'downloaded_video.dart';

class VideoScreen extends StatefulWidget {
  final int? sr;
  final bool? isdemo;
  final String? courseName;
  final List<dynamic>? courses;
  final String? comboCourseName;

  //static ValueNotifier<double> currentSpeed = ValueNotifier(1.0);
  //final int? quality;
  const VideoScreen(
      {required this.isdemo,
      this.sr,
      this.courseName,
      this.courses,
      this.comboCourseName});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

String oldurl = "";
String moduleid = "";
String videoid = "";

class _VideoScreenState extends State<VideoScreen> {
  int quality = 0;
  int selected = 0;
  //VideoPlayerController? _videoController;
  late Future<void> _initializeVideoPlayerFuture;
  bool? downloading = false;
  bool? isInternet;
  var sublist = <DataList>[];
  var gecoursedata;
  List videos = [];
  var course = 'R Language';
  bool downloaded = false;
  Map<String, dynamic>? data;
  String? videoUrl;
  Future<void>? playVideo;
  bool showAssignment = false;
  int? serialNo;
  String? assignMentVideoUrl;
  bool _disposed = false;
  bool _isPlaying = false;
  bool enablePauseScreen = false;
  var datahere;
  bool _isBuffering = false;
  Duration? _duration;
  Duration? _position;
  bool switchTOAssignment = false;
  bool showAssignSol = false;
  bool stopdownloading = true;
  var presentvideolink = '';

  var _delayToInvokeonControlUpdate = 0;
  var _progress = 0.0;
  List<VideoDetails> _listOfVideoDetails = [];

  ValueNotifier<int> _currentVideoIndex = ValueNotifier(0);
  ValueNotifier<double> _downloadProgress = ValueNotifier(0);
  // void intializeVidController1(String url, String moduleID, String videoID,
  //     {int quality1 = 0}) async {
  //   String quality = "";
  //   Wakelock.enable();
  //   Wakelock.enable();
  //   try {
  //     final oldVideoController = _videoController;
  //     late Duration newCurrentPosition;
  //     newCurrentPosition = _videoController!.value.position;
  //     if (oldVideoController != null) {
  //       oldVideoController.removeListener(_onVideoControllerUpdate);
  //       oldVideoController.pause();
  //       oldVideoController.dispose();
  //     }
  //     String baseurl = "https://media.publit.io/file";
  //     quality1 == 0
  //         ? quality = "/h_360/"
  //         : quality1 == 1
  //             ? quality = "/h_480/"
  //             : quality1 == 2
  //                 ? quality = "/h_720/"
  //                 : quality = "/h_360/";
  //     String route = url.split("/file/")[1];
  //     globals.route = route;
  //     oldurl = url;
  //     moduleid = moduleID;
  //     videoid = videoID;
  //     print(route);
  //     final _localVideoController =
  //         await VideoPlayerController.network(baseurl + quality + route);
  //     setState(() {
  //       _videoController = _localVideoController;
  //     });
  //     playVideo = _localVideoController.initialize().then((value) {
  //       setState(() {
  //         videoId = videoID;
  //         moduleId = moduleID;
  //         totalDuration =
  //             _localVideoController.value.duration.inSeconds.toInt();
  //         _localVideoController.addListener(_onVideoControllerUpdate);
  //         _videoController!.seekTo(newCurrentPosition);
  //         _videoController!.play();
  //         _duration = newCurrentPosition;
  //       });
  //     });
  //   } catch (e) {
  //     // showToast(e.toString());
  //   }
  // }

  // void intializeVidController(String url, String moduleID, String videoID,
  //     {int quality1 = 0}) async {
  //   String quality = "";
  //   Wakelock.enable();
  //   Wakelock.enable();
  //   try {
  //     final oldVideoController = _videoController;
  //     if (oldVideoController != null) {
  //       oldVideoController.removeListener(_onVideoControllerUpdate);
  //       oldVideoController.pause();
  //       oldVideoController.dispose();
  //     }
  //     String baseurl = "https://media.publit.io/file";
  //     quality1 == 0
  //         ? quality = "/h_360/"
  //         : quality1 == 1
  //             ? quality = "/h_480/"
  //             : quality1 == 2
  //                 ? quality = "/h_720/"
  //                 : quality = "/h_360/";
  //     String route = url.split("/file/")[1];
  //     globals.route = route;
  //     oldurl = url;
  //     moduleid = moduleID;
  //     videoid = videoID;
  //     print(route);
  //     final _localVideoController =
  //         await VideoPlayerController.network(baseurl + quality + route);
  //     setState(() {
  //       _videoController = _localVideoController;
  //     });
  //     playVideo = _localVideoController.initialize().then((value) {
  //       setState(() {
  //         videoId = videoID;
  //         moduleId = moduleID;
  //         totalDuration =
  //             _localVideoController.value.duration.inSeconds.toInt();
  //         _localVideoController.addListener(_onVideoControllerUpdate);
  //         _localVideoController.play();
  //         _duration = _localVideoController.value.duration;
  //       });
  //     });
  //   } catch (e) {
  //     // showToast(e.toString());
  //   }
  // }
  updateVideoProgress(dynamic listOfProgress) async {
    int total = 0, count = 0;

    await FirebaseFirestore.instance
        .collection("courseprogress_dataly")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      // if(value.get(CourseID.toString()))

      List res = value.get(CourseID.toString());
      List<int> integerValues = [100];

      for (var element in res) {
        for (var dictionary in element.values) {
          for (var value in dictionary) {
            if (value.values.first is int) {
              integerValues.add(value.values.first);
            }
          }
        }
      }

      total = integerValues.reduce((a, b) => a + b);
      count = integerValues.length - 1;
    });

    await FirebaseFirestore.instance
        .collection("courseprogress_dataly")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      CourseID.toString(): listOfProgress,
      CourseID.toString() + "percentage":
          ((total / (count * 100)) * 100).toInt(),
    }).catchError((err) => print("Error$err"));
  }

  setVideoProgress(String moduleId, String videoId, int percentage) async {
    _getVideoPercentageList!.forEach((element) {
      if (element[moduleId] != null) {
        element[moduleId].forEach((ed) {
          if (ed[videoId] != null) {
            ed[videoId] = percentage;
          }
        });
      }
    });
  }

  void getData() async {
    await setModuleId();
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .collection('Modules')
        .doc(moduleId)
        .collection('Topics')
        .orderBy('sr')
        .get()
        .then((value) {
      for (var video in value.docs) {
        _listOfVideoDetails.add(
          VideoDetails(
            videoId: video.data()['id'] ?? '',
            type: video.data()['type'] ?? '',
            canSaveOffline: video.data()['Offline'] ?? true,
            serialNo: video.data()['sr'].toString(),
            videoTitle: video.data()['name'] ?? '',
            videoUrl: video.data()['url'] ?? '',
          ),
        );
      }
    });
  }

  Future<void> setModuleId() async {
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .collection('Modules')
        .where('firstType', isEqualTo: 'video')
        .get()
        .then((value) {
      print('MMMMM : ${value.docs[0].get('id')}');
      moduleId = value.docs[0].get('id');
    });
  }

  String convertToTwoDigits(int value) {
    return value < 10 ? "0$value" : "$value";
  }

  // Widget timeRemainingString() {
  //   final totalDuration =
  //       _videoController!.value.duration.toString().substring(2, 7);
  //   final duration = _duration?.inSeconds ?? 0;
  //   final currentPosition = _position?.inSeconds ?? 0;
  //   final timeRemained = max(0, duration - currentPosition);
  //   final mins = convertToTwoDigits(timeRemained ~/ 60);
  //   final seconds = convertToTwoDigits(timeRemained % 60);
  //   // timeRemaining = '$mins:$seconds';
  //   return Text(
  //     totalDuration,
  //     style: TextStyle(
  //       color: Colors.white,
  //       fontWeight: FontWeight.bold,
  //     ),
  //   );
  // }

  // Widget timeElapsedString() {
  //   var timeElapsedString = "00.00";
  //   final currentPosition = _position?.inSeconds ?? 0;
  //   final mins = convertToTwoDigits(currentPosition ~/ 60);
  //   final seconds = convertToTwoDigits(currentPosition % 60);
  //   timeElapsedString = '$mins:$seconds';
  //   return Text(
  //     timeElapsedString,
  //     style: TextStyle(
  //         color: Colors.white,
  //         // fontSize: 12,
  //         fontWeight: FontWeight.bold),
  //   );
  // }

  // void _onVideoControllerUpdate() {
  //   print("----$moduleName");
  //   print("------$moduleId");
  //   print("-----$videoId");
  //   print("---total duration $totalDuration");
  //   print("----percent ${((currentPosition / totalDuration) * 100).toInt()}");
  //
  //   print(_getVideoPercentageList);
  //   if (_disposed) {
  //     return;
  //   }
  //   final now = DateTime.now().microsecondsSinceEpoch;
  //   if (_delayToInvokeonControlUpdate > now) {
  //     return;
  //   }
  //   _delayToInvokeonControlUpdate = now + 500;
  //   final controller = _videoController;
  //   if (controller == null) {
  //     debugPrint("The video controller is null");
  //     return;
  //   }
  //   if (!controller.value.isInitialized) {
  //     debugPrint("The video controller cannot be initialized");
  //     return;
  //   }
  //   if (_duration == null) {
  //     _duration = _videoController!.value.duration;
  //   }
  //   if (!(_videoController!.value.duration >
  //           _videoController!.value.position) &&
  //       !_videoController!.value.isPlaying) {
  //     VideoScreen.currentSpeed.value = 1.0;
  //     _currentVideoIndex.value++;
  //
  //     intializeVidController(
  //       _listOfVideoDetails[_currentVideoIndex.value].videoUrl,
  //       '',
  //       _listOfVideoDetails[_currentVideoIndex.value].videoId,
  //     );
  //   }
  //   var duration = _duration;
  //   if (duration == null) return;
  //   setState(() {});
  //
  //   if (_getVideoPercentageList != null) {
  //     for (var i in _getVideoPercentageList!) {
  //       if (i[moduleId.toString()] != null) {
  //         for (var j in i[moduleId.toString()]) {
  //           j[videoId.toString()] != null &&
  //                   j[videoId.toString()] <
  //                       ((currentPosition / totalDuration) * 100).toInt()
  //               ? j[videoId.toString()] =
  //                   ((currentPosition / totalDuration) * 100).toInt()
  //               : null;
  //         }
  //       }
  //     }
  //     //
  //     int total = 0, count = 0;
  //     try {
  //       for (int i = 0; i < _getVideoPercentageList!.length; i++) {
  //         for (var j in _getVideoPercentageList![i].entries) {
  //           // j.value.forEach((element) {
  //           //   Map<String, int> dic = element as Map<String, int>;
  //           //   int t = dic.values.first;
  //           //   total += t;
  //           //   count += 1;
  //           // });
  //           try {
  //             j.value.forEach((element) {
  //               // Map<String, int> dic = element as Map<String, int>;
  //               // int t = dic.values.first;
  //               total += int.parse(element.values.first.toString()).toInt();
  //               count += 1;
  //             });
  //           } catch (err) {
  //             print("j--$j");
  //           }
  //         }
  //       }
  //     } catch (err) {
  //       print("errrororor");
  //     }
  //
  //     CourseID != null
  //         ? FirebaseFirestore.instance
  //             .collection("courseprogress_dataly")
  //             .doc(FirebaseAuth.instance.currentUser!.uid)
  //             .update({
  //             CourseID.toString(): _getVideoPercentageList,
  //             CourseID.toString() + "percentage":
  //                 ((total / (count * 100)) * 100).toInt(),
  //           })
  //         : null;
  //   }
  //
  //   var position = _videoController?.value.position;
  //   setState(() {
  //     _position = position;
  //     currentPosition = _videoController!.value.position.inSeconds.toInt();
  //   });
  //   final buffering = controller.value.isBuffering;
  //   setState(() {
  //     _isBuffering = buffering;
  //   });
  //   final playing = controller.value.isPlaying;
  //   if (playing) {
  //     if (_disposed) return;
  //     setState(() {
  //       _progress = position!.inMilliseconds.ceilToDouble() /
  //           duration.inMilliseconds.ceilToDouble();
  //     });
  //   }
  //   _isPlaying = playing;
  // }

  // void intializedownloadedVidController1(File filename) async {
  //   late Duration newCurrentPosition;
  //   Wakelock.enable();
  //   try {
  //     final oldVideoController = _videoController;
  //     newCurrentPosition = _videoController!.value.position;
  //
  //     if (oldVideoController != null) {
  //       oldVideoController.removeListener(_onVideoControllerUpdate);
  //       oldVideoController.pause();
  //       oldVideoController.dispose();
  //     }
  //     final _localVideoController = await VideoPlayerController.file(filename);
  //     setState(() {
  //       _videoController = _localVideoController;
  //     });
  //     playVideo = _localVideoController.initialize().then((value) {
  //       setState(() {
  //         _videoController!.seekTo(newCurrentPosition);
  //         _videoController!.play();
  //       });
  //     });
  //     //  _initializeVideoPlayerFuture = _videoController!.initialize().then((_) {
  //
  //     // });
  //   } catch (e) {
  //     // showToast(e.toString());
  //   }
  // }
  //
  // void intializedownloadedVidController(File filename) async {
  //   Wakelock.enable();
  //   try {
  //     final oldVideoController = _videoController;
  //     if (oldVideoController != null) {
  //       oldVideoController.removeListener(_onVideoControllerUpdate);
  //       oldVideoController.pause();
  //       oldVideoController.dispose();
  //     }
  //     final _localVideoController = await VideoPlayerController.file(filename);
  //     setState(() {
  //       _videoController = _localVideoController;
  //     });
  //     playVideo = _localVideoController.initialize().then((value) {
  //       setState(() {
  //         _localVideoController.addListener(_onVideoControllerUpdate);
  //         _localVideoController.play();
  //         _duration = _localVideoController.value.duration;
  //       });
  //     });
  //   } catch (e) {
  //     // showToast(e.toString());
  //   }
  // }

  void getPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  // Future download({
  //   Dio? dio,
  //   String? url,
  //   String? savePath,
  //   String? fileName,
  //   String? courseName,
  //   String? topicName,
  // }) async {
  //   getPermission();
  //   var directory = await getApplicationDocumentsDirectory();
  //   try {
  //     setState(() {
  //       downloading = true;
  //     });
  //     Response response = await dio!.get(
  //       url!,
  //       onReceiveProgress: (rec, total) {
  //         _downloadProgress.value = rec / total;
  //       },
  //       options: Options(
  //         responseType: ResponseType.bytes,
  //         followRedirects: false,
  //         validateStatus: (status) {
  //           return status! < 500;
  //         },
  //       ),
  //     );

  //     File file = File(savePath!);
  //     var raf = file.openSync(mode: FileMode.write);
  //     print('savepath--$savePath');

  //     raf.writeFromSync(response.data);
  //     await raf.close();
  //     DatabaseHelper _dbhelper = DatabaseHelper();
  //     OfflineModel video = OfflineModel(
  //         topic: topicName,
  //         path: '${directory.path}/${fileName!.replaceAll(' ', '')}.mp4');
  //     _dbhelper.insertTask(video);

  //     setState(() {
  //       downloading = false;
  //       downloaded = true;
  //     });
  //   } catch (e) {
  //     print('e::$e');
  //   }
  // }

  late BetterPlayerController _betterPlayerController;
  bool isIntVideo = false;
  initBetterPlayer(String url) {
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
      allowedScreenSleep: false,
      deviceOrientationsOnFullScreen: [DeviceOrientation.landscapeLeft],
    );
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      url,
      useAsmsSubtitles: true,

      //videoFormat: BetterPlayerVideoFormat.hls
    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource);
    isIntVideo = true;
  }

  @override
  void dispose() {
    super.dispose();
    // AutoOrientation.portraitUpMode();
    // _disposed = true;
    // _videoController!.dispose();
    _betterPlayerController.dispose();
    // _videoController = null;
  }

  var courseCurriculum;
  var userQuizTrack;
  Map quizScoreMap = {};

  getScoreOfAllQuiz() async {
    print('courseId : $courseId');
    try {
      courseCurriculum = await FirebaseFirestore.instance
          .collection("courses")
          .doc(courseId)
          .get();

      userQuizTrack = await FirebaseFirestore.instance
          .collection("Users_dataly")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      var courseQuizList = courseCurriculum['curriculum1'][widget.courseName];

      for (var i = 0; i < courseQuizList.length; i++) {
        for (var j = 0; j < courseQuizList[i]['videos'].length; j++) {
          if (courseQuizList[i]['videos'][j]['type'] == 'quiz') {
            for (var name in userQuizTrack['quiztrack']) {
              if (courseQuizList[i]['videos'][j]['name'] == name['quizname']) {
                setState(() {
                  quizScoreMap[name['quizname']] = name['quizScore'];
                });
              }
            }
          }
        }
      }
      print('quizScoreMap $quizScoreMap');
    } catch (e) {
      print('Error quizScoreMap: $e');
    }
  }

  deletetemprogress() async {
    await FirebaseFirestore.instance
        .collection("courseprogress_dataly")
        .where("email", isEqualTo: 'shubham@gamil.com')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        element.reference.delete();
      });
    });
  }

  @override
  void initState() {
    deletetemprogress();
    getScoreOfAllQuiz();
    globals.isdemo = widget.isdemo!;
    globals.widgetvid1 = widget.courseName;
    getCourseQuiz();

    setState(() {
      course = widget.courseName!;
    });
    // VideoScreen.currentSpeed.value = 1.0;
    // getData();
    // Wakelock.toggle(enable: true);
    getUserRole();
    getcoursedata("");

    // getProgressData();
    globalquizstatus();
    // Wakelock.toggle(enable: true);
    Future.delayed(Duration(milliseconds: 500), () {
      //  Wakelock.enable();

      // intializeVidController(_listOfVideoDetails[0].videoUrl);
      getFirstVideo();
    });
    super.initState();
  }

  bool _switchValue = false;

  globalquizstatus() async {
    List modularquizlist = [];
    for (var j in videos) {
      if (j['type'] == 'quiz') {
        modularquizlist.add(j['name']);
      }
      print("wiefjwoie$modularquizlist");
    }
    print("hoiwejiowj${await modularquizlist}");
    List userquiztakenlist = [];
    bool showglobalquiz = true;
    await FirebaseFirestore.instance
        .collection("Users_dataly")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) async {
      print("fiweofw${await modularquizlist}");
      try {
        print("hoiwejiiweofowowj${modularquizlist}");
        print("quiztaken iwfejo ${value.data()!['quiztrack']}");
        try {
          for (var i in value.data()!['quiztrack']) {
            print(
                "wjefweiwoeiw ${i['quizname']} ${i['quizlevel']}  ${i['quizlevel']}");
            if (i['quizlevel'] == 'modulelevel' &&
                i['courseName'] == widget.courseName) {
              userquiztakenlist.add(i['quizname']);
            }

            if (i['quizCleared'] == false && i['quizlevel'] == 'modulelevel') {
              setState(() {
                showglobalquiz = false;
              });
            }
          }
        } catch (e) {
          print("quizid: wej3434434fwio: ${e}");
        }

        print("wefiwjeofiw${modularquizlist}");
        print("userquiijowe ${userquiztakenlist.length}");
        print("userquiijow2e ${userquiztakenlist}");
        print("modularquis ijweo ${modularquizlist}");
        if (userquiztakenlist.length != modularquizlist.length) {
          print("yes it is not equal");
          setState(() {
            showglobalquiz = false;
          });
        }

        print("iffwoejf4${modularquizlist.length}");
        if (modularquizlist.length == 0) {
          print("iffwoejf${modularquizlist.length}");
          setState(() {
            showglobalquiz = true;
          });
        }

        setState(() {
          _switchValue = showglobalquiz;
        });
      } catch (e) {
        print("quizid: wej3434434fwio: ${e}");
      }
    });
  }

  getFirstVideo() async {
    print("Firstvideo---");
    String? documentId;
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('courses').get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    for (QueryDocumentSnapshot document in documents) {
      if (document.get('name') == widget.courseName) {
        documentId = document.id;
      }
    }

    var res = await FirebaseFirestore.instance
        .collection("courses")
        .doc(documentId)
        .get();
    var list = res.get("curriculum1")[widget.courseName];
    list.sort((a, b) {
      if (a["sr"] > b["sr"]) {
        return 1;
      }
      return -1;
    });
    list[0]["videos"].sort((a, b) {
      if (a["sr"] > b["sr"]) {
        return 1;
      }
      return -1;
    });

    String vidUrl = setUrl(list[0]["videos"][0]["url"].toString());

    initBetterPlayer(vidUrl);

    // intializeVidController(list[0]["videos"][0]["url"].toString(),
    //     list[0]["id"].toString(), list[0]["videos"][0]["id"].toString());
  }

  String? role;
  String? userEmail;
  String? studentId;
  String? studentName;
  getUserRole() async {
    isInternet = await InternetConnectionChecker().hasConnection;
    await FirebaseFirestore.instance
        .collection("Users_dataly")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        role = value.exists ? value.data()!["role"] : null;
        userEmail = value.exists ? value.data()!['email'] : null;
        studentId = value.exists ? value.data()!["id"] : null;
        studentName = value.exists ? value.data()!["name"] : null;
      });
    });
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  Future<String> getProooDataaa(String moduleId, String videoId) async {
    try {
      String prooData = '';
      await {
        _getVideoPercentageList!.forEach((element) {
          if (element[moduleId] != null) {
            element[moduleId].forEach((ed) {
              if (ed[videoId] != null) {
                print('_getVideoPercentageList ${ed[videoId]}');
                prooData = ed[videoId].toString();
                return prooData;
              }
            });
          }
        })
      };
      return prooData;
    } catch (e) {
      return '$e';
    }
  }

  List quizlist = [];
  List assignmentlist = [];
  var dataSetUrl = {};
  String dataSetName = '';
  String assignmentName = '';
  var pdfUrl = {};

  getcoursedata(valuepassed) async {
    isInternet = await InternetConnectionChecker().hasConnection;
    print("IS Internet Connected:  ${isInternet}");
    var coursedata =
        await FirebaseFirestore.instance.collection("courses").get();
    print("kokokokokok:  ${coursedata.docs})}");
    var data = coursedata.docs;
    List newlist = [];
    data.forEach(
      (element) {
        print(element['name']);
        if (element['name'] == course) {
          gecoursedata = element['curriculum1'][course];
          print('dd $gecoursedata');
          for (var k in gecoursedata) {
            videos.addAll(k['videos']);
          }
          print('klklklk....l: $videos');
          print(gecoursedata);
          for (var i = 0; i <= 20; i++) {
            for (var j in gecoursedata) {
              if (j['sr'] == i) {
                newlist.add(j);
              }
            }
          }
          printWrapped(newlist.toString());
        }
      },
    );
    globalquizstatus();

    List widgetlist = [];
    num leng = 0;
    for (var i in gecoursedata) {
      var keyvalue;
      var valuelist = <DataList>[];
      print('start');

      keyvalue = i['modulename'];
      print("this is length: ${i['videos'].length}");
      printWrapped("sjdfsji: ifjio: ${i['videos']}");
      isInternet! ? await getProgressData() : null;
      try {
        for (var l = 0; l <= i['videos'].length; l++) {
          print("lengthwala $l");
          print(i['videos'].runtimeType);
          for (var k in i['videos']) {
            if (l == k['sr']) {
              var ifexist = await Downloadlink().checkiffileexist(k['name']);

              var progresDataa;

              isInternet!
                  ? await {
                      _getVideoPercentageList!.forEach((element) {
                        if (element[i['id'].toString()] != null) {
                          element[i['id'].toString()].forEach((ed) {
                            if (ed[k['id'].toString()] != null) {
                              progresDataa = ed[k['id'].toString()];
                              print('DDDDDD ::: ${ed[k['id'].toString()]}');
                            }
                          });
                        }
                      })
                    }
                  : null;
              if (k['type'] == 'quiz') {
                quizlist.add(k);
              }

              valuelist.add(DataList(
                k['name'],
                k['url'],
                ifexist,
                k['type'],
                '${progresDataa.toString()}',
                i['id'].toString(),
                k['id'].toString(),
              ));
            }
            if (k['type'] == 'assignment') {
              assignmentlist.add(k);
              pdfUrl[k['name']] = k['pdf'];

              print('pdfName pdfUrl $pdfUrl ');
            }
            if (k['dataset'] != null) {
              dataSetUrl[k['name']] = k['dataset'][0]['url'];
              dataSetName = k['dataset'][0]['name'];
            }
            ;
          }
        }
      } catch (e) {
        print("this is eror: ${e.toString()}");
      }
      ;
      setState(() {
        sublist
            .add(DataList('$keyvalue', '', false, '', '0', '', '', valuelist));
      });

      print("yyguyguyguyg${sublist}");
    }
    print("here: ${sublist}");
    setState(() {
      if (valuepassed == true) {
      } else {
        print('MODEEL ID : ${moduleId}');

        // initBetterPlayer(videos[0]['url']);

        // intializeVidController(videos[0]['url'], '$moduleId', videos[0]['id']);
        presentvideolink = videos[0]['url'];
        Future.delayed(Duration(milliseconds: 1000), () {
          //  Wakelock.enable();
          if (sublist.first.link != null) {
            sublist;
            print("doijeoifj");
            print(sublist);
          }
          ;
        });
      }
    });
  }

  List coursequiz = [];

  getCourseQuiz() async {
    try {
      await FirebaseFirestore.instance
          .collection("courses")
          .where("name", isEqualTo: widget.courseName)
          .get()
          .then((value) {
        setState(() {
          try {
            coursequiz = value.docs.first.data()['coursequiz'];
          } catch (e) {
            setState(() {
              coursequiz = [];
            });
          }
        });

        print("coursequiz1: ${coursequiz}");
      });
    } catch (e) {
      setState(() {
        coursequiz = [];
      });
      print(e.toString());
    }
  }

  // final Downloadlink downloadlink = Downloadlink();
  // Video Progress Code

  int totalDuration = 0;
  int currentPosition = 0;
  String? moduleName, moduleId, videoId;

  var _initialVideoPercentageList = {};
  List<dynamic>? _getVideoPercentageList;
  String? CourseID;
  getProgressData() async {
    String? documentId;
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('courses').get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    for (QueryDocumentSnapshot document in documents) {
      if (document.get('name') == widget.courseName) {
        documentId = document.id;
        print('Docc ID: $documentId');
      }
    }

    var res = await FirebaseFirestore.instance
        .collection("courses")
        .doc(documentId)
        .get();
    CourseID = await res.get("id");

    var courseType = await res.get("courseContent");

    if (courseType == 'video') {
      await FirebaseFirestore.instance
          .collection("courseprogress_dataly")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) async {
        print("vvvvvvvvvvvvvvvvvvvvvvvvv");
        print(FirebaseAuth.instance.currentUser!.uid.toString());
        print(value.exists);

        print('course id - $CourseID ');

        var list = await res.get("curriculum1")[widget.courseName];
        if (value.exists) {
          if (value.data()![CourseID] != null) {
            print("List-----$list");
            for (int i = 0; i < list.length; i++) {
              for (int j = 0; j < list[i]["videos"].length; j++) {
                list[i]["videos"][j]["type"] == "video"
                    ? null
                    : list[i]["videos"].removeAt(j);
              }
            }
            list.sort((a, b) {
              if (a["sr"] > b["sr"]) {
                return 1;
              }
              return -1;
            });

            /* check */
            var finalProgressData = [];
            var progressData = value.data()![CourseID];

            for (int i = 0; i < list.length; i++) {
              // int counter = 0;
              for (int k = 0; k < progressData.length; k++) {
                if (progressData[k][list[i]["id"]] != null) {
                  print("((((((( ${progressData[k]}");
                  finalProgressData.add(progressData[k]);
                  // counter=1;
                }
              }
              // Map<String,dynamic> moduleNew = {};
              // if(counter==0)
              //   {
              //     for(int k=0;k<list[i]["videos"].length;k++)
              //       {
              //         moduleNew[list[i]["id"].toString()]!.add({list[i]["videos"][k]["id"]:0});
              //       }
              //     // print("dic===$dic");
              //   }
              // counter==0?print("RRRTTT    ${list[i]["videos"]}  $moduleNew"):null;
            }

            print("UUUUUUUUU $finalProgressData");

            await FirebaseFirestore.instance
                .collection("courseprogress_dataly")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update({CourseID.toString(): finalProgressData});

            print("yyyyyyy $list");
            // value.data()![CourseID][0][list[0]["id"]];

            // print("&&&&&&&& ${_initialVideoPercentageList[widget.courseName]}");

            print("data((--- ${finalProgressData}");
            var data = finalProgressData;
            print("oooo ${list.length}");
            if (list.length == finalProgressData.length) {
              for (int k = 0; k < list.length; k++) {
                if (list[k]["videos"].length ==
                    finalProgressData[k][list[k]["id"]].length) {
                } else {
                  if (list[k]["videos"].length >
                      finalProgressData[k][list[k]["id"]].length) {
                    for (int g = 0; g < list[k]["videos"].length; g++) {
                      int count = 0;
                      finalProgressData[k][list[k]["id"]].forEach((ele) => {
                            if (ele.containsKey(list[k]["videos"][g]["id"]))
                              {
                                // print("True")
                                count = 1
                              }
                            else
                              {
                                print("false")
                                // data[k][list[k]["id"]].add(ele)
                              }
                          });
                      count == 1
                          ? null
                          : data[k][list[k]["id"]]
                              .add({list[k]["videos"][g]["id"].toString(): 0});
                    }
                  } else {
                    for (int g = 0; g < data[k][list[k]["id"]].length; g++) {
                      int count = 0;
                      print("====${data[k][list[k]["id"]][g]}");
                      list[k]["videos"].forEach((ele) => {
                            if (data[k][list[k]["id"]][g]
                                .containsKey(ele["id"]))
                              {count = 1}
                            else
                              {print("false ${ele["id"]}")}
                          });
                      count == 0 ? data[k][list[k]["id"]].removeAt(g) : null;
                    }
                  }
                }
              }
            } else {
              if (list.length > finalProgressData.length) {
                for (int i = 0; i < list.length; i++) {
                  int count = 0;
                  finalProgressData.forEach((ele) => {
                        // print("tyypypypyp $ele")
                        if (ele.containsKey(list[i]["id"]))
                          {
                            // print("True")
                            count = 1
                          }
                        else
                          {
                            print("false")
                            // data[k][list[k]["id"]].add(ele)
                          }
                      });
                  var listOfID = [];
                  for (int j = 0; j < list[i]["videos"].length; j++) {
                    listOfID.add({list[i]["videos"][j]["id"]: 0});
                  }
                  print("iddddddd");
                  print(listOfID);
                  count == 1
                      ? null
                      : data.add({list[i]["id"].toString(): listOfID});
                }
              } else {
                for (int j = 0; j < data.length; j++) {
                  int count = 0;
                  list.forEach((ele) {
                    if (data[j].containsKey(ele["id"])) {
                      count = 1;
                    }
                  });
                  count == 1 ? null : data.removeAt(j);
                }
              }
            }

            await FirebaseFirestore.instance
                .collection("courseprogress_dataly")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update({CourseID.toString(): data});
            print("finally  $data");
            _getVideoPercentageList = data;
          } else {
            var list = await res.get("curriculum1")[widget.courseName];
            list.sort((a, b) {
              if (a["sr"] > b["sr"]) {
                return 1;
              }
              return -1;
            });
            _initialVideoPercentageList[widget.courseName.toString()] = [];
            for (int i = 0; i < list.length; i++) {
              print(_initialVideoPercentageList[widget.courseName.toString()]
                  .runtimeType);
              _initialVideoPercentageList[widget.courseName.toString()]
                  .add({list[i]["id"].toString(): []});
              for (int j = 0; j < list[i]["videos"].length; j++) {
                list[i]["videos"][j]["type"] == "video"
                    ? _initialVideoPercentageList[widget.courseName][i]
                            [list[i]["id"]]
                        .add({list[i]["videos"][j]["id"]: 0})
                    : null;
              }
            }
            print("**** $_initialVideoPercentageList");
            await getUserRole();
            await FirebaseFirestore.instance
                .collection("courseprogress_dataly")
                .doc(FirebaseAuth.instance.currentUser!.uid.toString())
                .update({
              CourseID.toString():
                  _initialVideoPercentageList[widget.courseName.toString()],
              "email": userEmail,
            }).catchError((err) => print("Error$err"));
            print("done----");
            _getVideoPercentageList =
                _initialVideoPercentageList[widget.courseName.toString()];
          }
        } else {
          var list = await res.get("curriculum1")[widget.courseName];
          list.sort((a, b) {
            if (a["sr"] > b["sr"]) {
              return 1;
            }
            return -1;
          });
          _initialVideoPercentageList[widget.courseName.toString()] = [];
          for (int i = 0; i < list.length; i++) {
            print(_initialVideoPercentageList[widget.courseName.toString()]
                .runtimeType);
            _initialVideoPercentageList[widget.courseName.toString()]
                .add({list[i]["id"].toString(): []});
            for (int j = 0; j < list[i]["videos"].length; j++) {
              list[i]["videos"][j]["type"] == "video"
                  ? _initialVideoPercentageList[widget.courseName][i]
                          [list[i]["id"]]
                      .add({list[i]["videos"][j]["id"]: 0})
                  : null;
            }
          }
          print("**** $_initialVideoPercentageList");
          await getUserRole();
          await FirebaseFirestore.instance
              .collection("courseprogress_dataly")
              .doc(FirebaseAuth.instance.currentUser!.uid.toString())
              .set({
            CourseID.toString():
                _initialVideoPercentageList[widget.courseName.toString()],
            "email": userEmail,
          }).catchError((err) => print("Error$err"));
          print("done----");
          _getVideoPercentageList =
              _initialVideoPercentageList[widget.courseName.toString()];
        }
      });
      setState(() {
        _getVideoPercentageList;
      });
    }
  }

  setUrl(String url) {
    print("URL IS :: $url");
    String newExtension = 'm3u8';
    RegExp extensionRegex = RegExp(r'\.\w+$');
    String newUrl = url.replaceFirst(extensionRegex, '.$newExtension');
    return newUrl;
  }

  @override
  Widget build(BuildContext context) {
    //datahere = Provider.of<Downloadlink>(context, listen: false).progress.value;
    // setState(() {
    //   Downloadlink().progress.value = Downloadlink().progress.value;
    // });
    // final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;
    // var verticalScale = screenHeight / mockUpHeight;
    // var horizontalScale = screenWidth / mockUpWidth;
    //
    // if (enablePauseScreen == true) {
    //   Wakelock.toggle(enable: true);
    //   print("enabledllllllllllllll");
    // }
    // if (enablePauseScreen == false) {
    //   Wakelock.toggle(enable: true);
    //   print("enabledllllllllllllll");
    // }
    // if (enablePauseScreen == true) {
    //   Wakelock.toggle(enable: true);
    //   print("enabledllllllllllllll");
    // }
    // if (enablePauseScreen == false) {
    //   Wakelock.toggle(enable: true);
    //   print("enabledllllllllllllll");
    // }
    return WillPopScope(
      onWillPop: () async {
        _betterPlayerController.dispose();
        widget.isdemo == false
            ? Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => NewComboCourse(
                      courseName: widget.comboCourseName,
                      courses: widget.courses),
                ))
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
            // NewScreen(courseName: widget.comboCourseName,courses: widget.courses),))
            : Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(),
                ),
                (route) => false);
        return false;
      },
      child: Scaffold(
          body: SafeArea(
        child: Container(
          color: Colors.white,
          child: OrientationBuilder(builder: (context, orientation) {
            final isPortrait = orientation == Orientation.portrait;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back_rounded, size: 28),
                    ],
                  ),
                ),
                widget.courseName! == 'Apply for placement' ||
                        widget.courseName! == 'Apply for internship'
                    ? Container()
                    : AspectRatio(
                        aspectRatio: 16 / 9,
                        child: isIntVideo
                            ? BetterPlayer(controller: _betterPlayerController)
                            : Center(
                                child: CircularProgressIndicator(
                                    color: Colors.deepPurpleAccent,
                                    strokeWidth: 2),
                              )),
                isPortrait
                    ? _buildPartition(
                        context,
                      )
                    : SizedBox(),
                isPortrait
                    ? Expanded(
                        flex: 2,
                        child: _buildVideoDetailsListTile(),
                      )
                    : SizedBox(),
              ],
            );
          }),
        ),
      )),
    );
  }

  // Widget _buildControls(
  //   BuildContext context,
  //   bool isPortrait,
  //   double horizontalScale,
  //   double verticalScale,
  // ) {
  //   return Container(
  //     color: Color.fromARGB(114, 0, 0, 0),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         ListTile(
  //           leading: InkWell(
  //             onTap: () {
  //               Navigator.pop(context);
  //             },
  //             child: Icon(
  //               Icons.arrow_back_ios_new,
  //               color: Colors.white,
  //             ),
  //           ),
  //           title:
  //               // Text(
  //               //   "Hey", //_listOfVideoDetails[_currentVideoIndex.value].videoTitle
  //               //   textAlign: TextAlign.center,
  //               //   style: TextStyle(
  //               //     color: Colors.white,
  //               //     fontSize: 15,
  //               //   ),
  //               // ),
  //               // trailing:
  //
  //               Row(
  //             children: [
  //               Spacer(),
  //               InkWell(
  //                 onTap: () {
  //                   showModalBottomSheet(
  //                     backgroundColor: Colors.transparent,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(10),
  //                     ),
  //                     isDismissible: true,
  //                     context: context,
  //                     builder: (context) {
  //                       return Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child: Container(
  //                           decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(10),
  //                               color: Colors.white),
  //                           // height: 250,
  //                           child: ListView.builder(
  //                             shrinkWrap: true,
  //                             itemCount: 3,
  //                             itemBuilder: (context, index) {
  //                               return ListTile(
  //                                 onTap: () {
  //                                   Navigator.pop(context);
  //                                   quality = index;
  //                                   index == 0
  //                                       ? intializeVidController1(
  //                                           oldurl, moduleid, videoid,
  //                                           quality1: 0)
  //                                       : index == 1
  //                                           ? intializeVidController1(
  //                                               oldurl, moduleid, videoid,
  //                                               quality1: 1)
  //                                           : intializeVidController1(
  //                                               oldurl, moduleid, videoid,
  //                                               quality1: 2);
  //
  //                                   VideoScreen(isdemo: false, quality: index);
  //                                 },
  //                                 leading: quality == index
  //                                     ? Icon(Icons.check)
  //                                     : SizedBox(),
  //                                 title: index == 0
  //                                     ? Text('360p')
  //                                     : index == 1
  //                                         ? Text('480p')
  //                                         : index == 2
  //                                             ? Text('720p')
  //                                             : Text(
  //                                                 'Default Quality',
  //                                               ),
  //                               );
  //                             },
  //                           ),
  //                           // Column(
  //                           //   mainAxisSize: MainAxisSize.min,
  //                           //   children: [
  //                           //     ListTile(
  //                           //       leading: Icon(Icons.speed),
  //                           //       title: Text('Playback speed'),
  //                           //     ),
  //                           //     InkWell(
  //                           //       onTap: (){
  //                           //         Navigator.pop(context);
  //                           //       },
  //                           //       child: ListTile(
  //                           //         title: Icon(Icons.close),
  //                           //       ),
  //                           //     )
  //                           //   ],
  //                           // ),
  //                           // Column(
  //                           //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                           //   crossAxisAlignment: CrossAxisAlignment.center,
  //                           //   children: [
  //                           //     Text(
  //                           //       'As assignments cant open on mobile please open below link on Laptop browser to get Assignment and Course certificates.',
  //                           //       textAlign: TextAlign.center,
  //                           //       textScaleFactor: min(horizontalScale, verticalScale),
  //                           //       style: TextStyle(
  //                           //         fontFamily: 'Poppins',
  //                           //         fontSize: 16,
  //                           //         fontWeight: FontWeight.w500,
  //                           //       ),
  //                           //     ),
  //                           //     SelectableText(
  //                           //       'https://courses.cloudyml.com/s/store',
  //                           //       style: TextStyle(
  //                           //         fontFamily: 'Poppins',
  //                           //         fontSize: 16,
  //                           //         fontWeight: FontWeight.w900,
  //                           //       ),
  //                           //     ),
  //                           //     Text(
  //                           //       'To Open LMS On Mobile Please Click Below',
  //                           //       style: TextStyle(
  //                           //         fontFamily: 'Poppins',
  //                           //         fontSize: 16,
  //                           //         fontWeight: FontWeight.w500,
  //                           //       ),
  //                           //     ),
  //                           //     ElevatedButton(
  //                           //       style: ButtonStyle(
  //                           //         backgroundColor: MaterialStateProperty.all(
  //                           //           Color(0xFF7860DC),
  //                           //         ),
  //                           //       ),
  //                           //       onPressed: () {
  //                           //         Utils.openLink(Url: 'https://courses.cloudyml.com/s/store');
  //                           //       },
  //                           //       child: Text('Open Url'),
  //                           //     ),
  //                           //   ],
  //                           // ),
  //                         ),
  //                       );
  //                     },
  //                   );
  //                   // var directory = await getApplicationDocumentsDirectory();
  //                   // download(
  //                   //   dio: Dio(),
  //                   //   fileName: data!['name'],
  //                   //   url: data!['url'],
  //                   //   savePath:
  //                   //       "${directory.path}/${data!['name'].replaceAll(' ', '')}.mp4",
  //                   //   topicName: data!['name'],
  //                   // );
  //                   // print(directory.path);
  //                 },
  //                 child: Icon(
  //                   Icons.high_quality,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //               SizedBox(
  //                 width: 10,
  //               ),
  //               InkWell(
  //                 onTap: () {
  //                   showSettingsBottomsheet(
  //                     context,
  //                     horizontalScale,
  //                     verticalScale,
  //                     _videoController!,
  //                   );
  //                   // var directory = await getApplicationDocumentsDirectory();
  //                   // download(
  //                   //   dio: Dio(),
  //                   //   fileName: data!['name'],
  //                   //   url: data!['url'],
  //                   //   savePath:
  //                   //       "${directory.path}/${data!['name'].replaceAll(' ', '')}.mp4",
  //                   //   topicName: data!['name'],
  //                   // );
  //                   // print(directory.path);
  //                 },
  //                 child: Icon(
  //                   Icons.settings,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           //   ],
  //           // ),
  //         ),
  //         ValueListenableBuilder(
  //           valueListenable: _currentVideoIndex,
  //           builder: (context, value, child) {
  //             return Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceAround,
  //               children: [
  //                 _currentVideoIndex.value >= 1
  //                     ? InkWell(
  //                         onTap: () {
  //                           var url;
  //                           var sr;
  //                           for (var i in videos) {
  //                             if (i.values.containsKey(presentvideolink)) {
  //                               sr = i['sr'];
  //                             }
  //                           }
  //                           VideoScreen.currentSpeed.value = 1.0;
  //                           _currentVideoIndex.value--;
  //                           sr--;
  //                           for (var j in videos) {
  //                             if (sr == j['sr']) {
  //                               url = j['url'];
  //                             }
  //                           }
  //                           // intializeVidController(url,'','');
  //                         },
  //                         child: Icon(
  //                           Icons.skip_previous_rounded,
  //                           color: Colors.white,
  //                           size: 40,
  //                         ),
  //                       )
  //                     : SizedBox(),
  //                 replay10(
  //                   videoController: _videoController,
  //                 ),
  //                 !_isBuffering
  //                     ? InkWell(
  //                         onTap: () {
  //                           if (_isPlaying) {
  //                             setState(() {
  //                               _videoController!.pause();
  //                             });
  //                           } else {
  //                             setState(() {
  //                               enablePauseScreen = !enablePauseScreen;
  //                               _videoController!.play();
  //                             });
  //                           }
  //                         },
  //                         child: Icon(
  //                           _isPlaying ? Icons.pause : Icons.play_arrow,
  //                           color: Colors.white,
  //                           size: 50,
  //                         ),
  //                       )
  //                     : CircularProgressIndicator(
  //                         color: Color.fromARGB(
  //                           114,
  //                           255,
  //                           255,
  //                           255,
  //                         ),
  //                       ),
  //                 fastForward10(
  //                   videoController: _videoController,
  //                 ),
  //                 _currentVideoIndex.value < _listOfVideoDetails.length - 1
  //                     ? InkWell(
  //                         onTap: () {
  //                           VideoScreen.currentSpeed.value = 1.0;
  //                           _currentVideoIndex.value++;
  //
  //                           intializeVidController(
  //                               _listOfVideoDetails[_currentVideoIndex.value]
  //                                   .videoUrl,
  //                               '',
  //                               _listOfVideoDetails[_currentVideoIndex.value]
  //                                   .videoId);
  //                         },
  //                         child: Icon(
  //                           Icons.skip_next_rounded,
  //                           color: Colors.white,
  //                           size: 40,
  //                         ),
  //                       )
  //                     : SizedBox(),
  //               ],
  //             );
  //           },
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 10),
  //           child: Column(
  //             children: [
  //               Container(
  //                 height: 10,
  //                 child: VideoProgressIndicator(
  //                   _videoController!,
  //                   allowScrubbing: true,
  //                   colors: VideoProgressColors(
  //                     backgroundColor: Color.fromARGB(74, 255, 255, 255),
  //                     bufferedColor: Color(0xFFC0AAF5),
  //                     playedColor: Color(0xFF7860DC),
  //                   ),
  //                 ),
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Row(
  //                     children: [
  //                       timeElapsedString(),
  //                       Text(
  //                         '/${_videoController!.value.duration.toString().substring(2, 7)}',
  //                         style: TextStyle(
  //                           color: Colors.white,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   fullScreenIcon(
  //                     isPortrait: isPortrait,
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildPartition(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // _buildquality(context),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.courseName!,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: "Medium",
                ),
              ),
            ),
          ),
          SizedBox(
            height: 60,
            child: Center(
              child: Row(
                children: [
                  SizedBox(width: 20),
                  _buildLecturesTab(context),
                  SizedBox(width: 30),
                  // _buildAssignmentTab(
                  //   context,
                  //   horizontalScale,
                  //   verticalScale,
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Container _buildquality(BuildContext context) {
  //   final ButtonStyle style = ElevatedButton.styleFrom(
  //       textStyle: const TextStyle(fontSize: 20),
  //       backgroundColor: Color(0xFF7860DC));
  //   final ButtonStyle style2 = ElevatedButton.styleFrom(
  //       textStyle: TextStyle(fontSize: 20, color: Color(0xFF7860DC)),
  //       backgroundColor: Colors.white);
  //   return Container(
  //       child: Center(
  //     child: Padding(
  //       padding:
  //           const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 20, right: 20),
  //       child: Row(
  //         children: [
  //           ElevatedButton(
  //             style: selected == 0 ? style : style2,
  //             onPressed: () {
  //               selected = 0;
  //               intializeVidController(oldurl, moduleid, videoid, quality1: 0);
  //             },
  //             child: selected == 0
  //                 ? Text('360p')
  //                 : Text(
  //                     '360p',
  //                     style: TextStyle(fontSize: 20, color: Color(0xFF7860DC)),
  //                   ),
  //           ),
  //           SizedBox(
  //             width: 10,
  //           ),
  //           ElevatedButton(
  //             style: selected == 1 ? style : style2,
  //             onPressed: () {
  //               selected = 1;
  //               intializeVidController(oldurl, moduleid, videoid, quality1: 1);
  //             },
  //             child: selected == 1
  //                 ? Text('480p')
  //                 : Text(
  //                     '480p',
  //                     style: TextStyle(fontSize: 20, color: Color(0xFF7860DC)),
  //                   ),
  //           ),
  //           SizedBox(
  //             width: 10,
  //           ),
  //           ElevatedButton(
  //             style: selected == 2 ? style : style2,
  //             onPressed: () {
  //               selected = 2;
  //               intializeVidController(oldurl, moduleid, videoid, quality1: 2);
  //             },
  //             child: selected == 2
  //                 ? Text('720p')
  //                 : Text(
  //                     '720p',
  //                     style: TextStyle(fontSize: 20, color: Color(0xFF7860DC)),
  //                   ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   ));
  // }

  Container _buildLecturesTab(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Modules',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            height: 3,
            width: MediaQuery.of(context).size.width * 0.2,
            color: Color(0xFF7860DC),
          )
        ],
      ),
    );
  }

  List values = [];
  Future<void> downloadvideotoPath(
      url, filename, BuildContext context, DataList root) async {
    values.add(filename);
    // container.value = values;

    final directory = await getApplicationDocumentsDirectory();
    // print("${directory.path.contains(filename)}");
    // print("$directory/$filename");
    await downloadVideo(
        url, "${directory.path}/${filename}", context, filename, root);
    // return directory.path;
  }

  var progressdata = 0.0;
  CancelToken cancelToken = CancelToken();
  Future<void> downloadVideo(String url, String savePath, BuildContext context,
      filename, DataList root) async {
    Dio dio = Dio();
    var value;

    try {
      await dio.download(url, savePath, cancelToken: cancelToken,
          onReceiveProgress: (received, total) {
        progressdata =
            double.parse(((received / total) * 100).toStringAsFixed(0));

        // print(progressdata);
        // value = progress.value; // Prints after 1 second.
        setState(() {
          progressdata;
          print('this is progress $progressdata');
        });
      });
      if (progressdata == 100.0) {
        values.remove(filename);
        setState(() {
          root.downloaded = true;
        });
      }
      // Toast.show('${progress.value}%', context: context,animDuration: Duration(seconds: 2), duration: Duration(seconds: 2));
      // showDialog(
      //     context: context,
      //     builder: (context) {
      //       return AlertDialog(
      //         title: Text('${progress.value}%'),
      //         content: Text('Hey! I am Coflutter!'),
      //         actions: <Widget>[
      //           TextButton(
      //               onPressed: () {
      //                 // _dismissDialog();
      //               },
      //               child: Text('Close')),
      //           TextButton(
      //             onPressed: () {
      //               print('HelloWorld!');
      //               // _dismissDialog();
      //             },
      //             child: Text('HelloWorld!'),
      //           )
      //         ],
      //       );
      //     });
      // });
    } catch (e) {
      print(e);
    }
  }

  // InkWell _buildAssignmentTab(
  //     BuildContext context, double horizontalScale, double verticalScale) {
  //   return InkWell(
  //     onTap: () {
  //       setState(() {
  //         _videoController!.pause();
  //         showAssignmentBottomSheet(
  //           context,
  //           horizontalScale,
  //           verticalScale,
  //         );
  //       });
  //     },
  //     child: Container(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         children: [
  //           Text(
  //             'Assignments',
  //             style: TextStyle(
  //               fontSize: 15,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //           Container(
  //             height: 3,
  //             width: MediaQuery.of(context).size.width * 0.25,
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  List deletedlist = [];
  String typevalue = '';
  List toggle = [];

  Widget courseQuiz(context) {

    return

      
      coursequiz.runtimeType != Null
        ? Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Column(
              children: [
                Container(
                  color: Color.fromARGB(255, 255, 255, 255),
                  child: ExpansionTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Certificate Quiz',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        true ? Icon(Icons.lock_open) : Icon(Icons.lock)
                      ],
                    ),
                    children: true
                        ? List.generate(
                            coursequiz.length,
                            (index1) {
                              // print("ppppp ${valueMap}");
                              return Column(
                                children: [
                                  // videoPercentageList.length != 0 ?
                                  // Text(videoPercentageList[index][courseData.entries.elementAt(index).key][courseData.entries.elementAt(index).value[index1].videoTitle].toString()) : SizedBox(),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        enablePauseScreen = true;
                                      });
                                      print("pppppppppppppppppppp");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              QuizentrypageWidget(
                                                  coursequiz[index1]),
                                        ),
                                      );
                                      // FirebaseAuth.instance.currentUser!.getIdToken().then((value) {
                                      //   printWrapped("token ${value}");

                                      // });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 60, top: 15, bottom: 15),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          coursequiz[index1]['name'],
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          )
                        : [
                            Container(
                              child: Center(
                                child: Text(
                                  "You need to clear all the quiz of this course to unlock this certificate quiz!",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            )
                          ],
                  ),
                ),
              ],
            ),
          )
        : Container()

    ;
  }

  Widget _buildTiles(DataList root) {
    typevalue = root.type;
    if (root.children.isEmpty)
      return Column(
        children: [
          InkWell(
            onTap: () {
              currentPosition = 0;
              totalDuration = 0;

              if (root.type == 'resume') {
                Navigator.push(
                  this.context,
                  MaterialPageRoute(
                    builder: (context) => SubmitResume(
                      studentId: studentName!,
                      studentEmail: userEmail!,
                      studentName: studentName!,
                    ),
                  ),
                );
              }

              if (root.type == 'assignment') {
                for (var i in assignmentlist) {
                  if (i['name'] == root.title) {
                    assignmentName = root.title;
                    print('assignmentName ${root.title}');
                  }
                }
              }

              if (root.type == 'assignment') {
                print('root.link assignment1 ${root.link}');
                for (var i in assignmentlist) {
                  if (i['name'] == root.title) {
                    print('root.link assignment1 ${i['url']}');
                    Navigator.push(
                      this.context,
                      MaterialPageRoute(
                        builder: (context) => AssignmentScreen(
                            i['url'], i['pdf'],
                            pdfUrl: pdfUrl,
                            assignmentName: assignmentName,
                            dataSetName: dataSetName,
                            dataSetUrl: dataSetUrl),
                      ),
                    );
                    break;
                  }
                }
              } else if (root.type == 'quiz') {
                // logic for getting the map by filtering by title
                var data;
                for (var i in quizlist) {
                  if (i['name'] == root.title) {
                    data = i;
                    break;
                  }
                }
                Navigator.push(
                  this.context,
                  MaterialPageRoute(
                    builder: (context) => QuizentrypageWidget(data),
                  ),
                );
              } else {
                // currentPosition = 0;
                // totalDuration = 0;
                print('MODDLE Id: ${root.moduleId}');
                print('VIDDDD Id: ${root.videoId}');
                _betterPlayerController.dispose();

                String vidUrl = setUrl(root.link!);
                initBetterPlayer(vidUrl);
                // intializeVidController(
                //     root.link!, root.moduleId!, root.videoId!);
                print(root.link);
                setState(() {
                  presentvideolink = root.link!;
                });
              }
            },
            child: ListTile(
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      color: Color.fromARGB(255, 255, 255, 255),
                      icon: progressdata == 100.0 && values.contains(root.title)
                          ? Icon(
                              Icons.done,
                              color: Color.fromARGB(255, 0, 255, 8),
                            )
                          : values.contains(root.title)
                              ? Text(
                                  "${progressdata.toInt()}%",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 255, 8),
                                  ),
                                )
                              : root.type == 'assignment' ||
                                      root.type == 'quiz' ||
                                      root.type == 'resume'
                                  ? Container()
                                  // : Icon(Icons
                                  //     .download_for_offline_rounded),
                                  : Container(),
                      onPressed: () async {
                        print('root.type ${root.link}');

                        if (root.type == 'resume') {
                          Navigator.push(
                            this.context,
                            MaterialPageRoute(
                              builder: (context) => SubmitResume(
                                studentId: studentName!,
                                studentEmail: userEmail!,
                                studentName: studentName!,
                              ),
                            ),
                          );
                        }

                        if (root.type == 'assignment') {
                          for (var i in assignmentlist) {
                            if (i['name'] == root.title) {
                              assignmentName = root.title;
                              print('assignmentName ${root.title}');
                            }
                          }
                        }

                        if (root.type == 'assignment') {
                          print('root.link assignment ${root.link}');
                          for (var i in assignmentlist) {
                            if (i['name'] == root.title) {
                              Navigator.push(
                                this.context,
                                MaterialPageRoute(
                                  builder: (context) => AssignmentScreen(
                                      i['url'], i['pdf'],
                                      pdfUrl: pdfUrl,
                                      assignmentName: assignmentName,
                                      dataSetName: dataSetName,
                                      dataSetUrl: dataSetUrl),
                                ),
                              );
                              break;
                            }
                          }
                        } else if (root.type == 'quiz') {
                          // logic for getting the map by filtering by title
                          var data;

                          for (var i in quizlist) {
                            if (i['name'] == root.title) {
                              data = i;
                              break;
                            }
                          }
                          Navigator.push(
                            this.context,
                            MaterialPageRoute(
                              builder: (context) => QuizentrypageWidget(data),
                            ),
                          );
                        } else {
                          // if (!values.contains(root.title)) {
                          //   downloadvideotoPath(
                          //       root.link, root.title, context, root);
                          // }
                          setState(() {
                            toggle;
                          });
                        }
                      },
                    ),
                    FutureBuilder(
                      future: getProooDataaa(root.moduleId!, root.videoId!),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return root.type == 'assignment' ||
                                  root.type == 'quiz' ||
                                  root.type == 'resume'
                              ? SizedBox()
                              : Row(
                                  children: [
                                    Text(
                                      snapshot.data == ''
                                          ? '0%'
                                          : '${snapshot.data}%',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Transform.scale(
                                          scale: 0.9,
                                          child: Checkbox(
                                            checkColor: snapshot.data == '100'
                                                ? Colors.white
                                                : Colors.white,
                                            fillColor: snapshot.data == '100'
                                                ? MaterialStateProperty
                                                    .resolveWith<Color>((Set<
                                                            MaterialState>
                                                        states) {
                                                    if (states.contains(
                                                        MaterialState
                                                            .disabled)) {
                                                      return Colors.green;
                                                    }
                                                    return Colors.green;
                                                  })
                                                : null,
                                            value: snapshot.data == '100'
                                                ? true
                                                : false,
                                            shape: CircleBorder(),
                                            onChanged: snapshot.data != '100' ||
                                                    snapshot.data == ''
                                                ? (bool? value) {
                                                    setState(() {
                                                      setVideoProgress(
                                                          root.moduleId!,
                                                          root.videoId!,
                                                          100);
                                                      print(
                                                          'Updated List ::: ${_getVideoPercentageList}');
                                                      updateVideoProgress(
                                                          _getVideoPercentageList);
                                                    });
                                                  }
                                                : null,
                                          ),
                                        ),
                                        Text(
                                          'Mark As Complete',
                                          style: TextStyle(fontSize: 6, color: Colors.white),
                                        )
                                      ],
                                    )
                                  ],
                                );
                        } else {
                          return SizedBox();
                        }
                      },
                    )
                  ],
                ),
                title: root.type == 'quiz'
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            root.title,
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                          quizScoreMap[root.title] != null
                              ? Text(
                                  '${quizScoreMap[root.title].round()}%',
                                  style: TextStyle(color: Colors.white),
                                )
                              : Container(),
                        ],
                      )
                    : Text(
                        root.title,
                        style: TextStyle(color: Colors.white),
                      )),
          ),
        ],
      );

    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: typevalue == 'assignment' ? Colors.white : HexColor('7B62DF'),
          border: Border.all(
              color: Color.fromARGB(255, 0, 0, 0), // Set border color
              width: 0.0), // Set border width
          borderRadius: BorderRadius.all(
              Radius.circular(20.0)), // Set rounded corner radius
          boxShadow: [
            BoxShadow(
                blurRadius: 2,
                color: root.type == 'assignment'
                    ? Colors.white
                    : Color.fromARGB(255, 98, 97, 97),
                offset: Offset(1, 3))
          ] // Make rounded corner of border
          ),
      child: ExpansionTile(
        iconColor: Colors.white,
        collapsedIconColor: Colors.white,
        key: PageStorageKey<DataList>(root),
        title: Text(root.title, style: TextStyle(color: Colors.white)),
        children: root.children.map(_buildTiles).toList(),
      ),
    );
  }

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  Future<void> _showProgressNotification() async {
    const int maxProgress = 40;
    for (int i = 0; i <= maxProgress; i++) {
      await Future<void>.delayed(const Duration(seconds: 1), () async {
        final AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails('progress channel', 'progress channel',
                channelShowBadge: false,
                importance: Importance.max,
                priority: Priority.high,
                onlyAlertOnce: true,
                showProgress: true,
                maxProgress: maxProgress,
                progress: i);
        final NotificationDetails platformChannelSpecifics =
            NotificationDetails(android: androidPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(
            1,
            'progress notification title',
            'progress notification body',
            platformChannelSpecifics,
            payload: 'item x');
      });
    }
  }

  int? dragSectionIndex, dragSubsectionIndex;
  int? subIndex, index;
  String solutionUrl = '';
  String assignmentUrl = '';
  streamVideoData() async {
    print("Videoss;");
    String? documentId;
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('courses').get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    for (QueryDocumentSnapshot document in documents) {
      if (document.get('name') == widget.courseName) {
        documentId = document.id;
        print('Docc ID: $documentId');
      }
    }

    await FirebaseFirestore.instance
        .collection("courses")
        .doc(documentId)
        .get()
        .then((value) async {
      print("!!!!!!!!!!!!!!!!!!!!!!! ${value.data()}");
      Map<String, dynamic>? data = await value.data();
      Counter.counterSinkVideos.add(data != null ? data : null);
    });
  }

  Widget _buildVideoDetailsListTile() {
    return

      StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("courses")
              .doc(courseId)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              print("snapdata----------");
              var listOfSectionData;
              // setState(() {
              listOfSectionData = snapshot.data["curriculum1"];
              print(widget.courseName);
              print(snapshot.data);
              listOfSectionData[widget.courseName].sort((a, b) {
                print("---========");
                print(a["sr"]);
                if (a["sr"] > b["sr"]) {
                  return 1;
                }
                return -1;
              });
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children:
                  List.generate(listOfSectionData[widget.courseName].length,
                          (sectionIndex) {
                        return sectionIndex ==
                            listOfSectionData[widget.courseName].length - 1
                            ? Column(
                          children: [
                            moduleExpandabletile(
                                listOfSectionData, sectionIndex),

                            true
                                ?  coursequiz.isNotEmpty ?

                            courseQuiz(context) : SizedBox() : SizedBox()
                          ],
                        )
                            : moduleExpandabletile(listOfSectionData, sectionIndex);
                      }),
                ),
              );
            } else {
              return Text("Loading..");
            }
          });


  }

  Widget moduleExpandabletile(listOfSectionData, sectionIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          " ",
          style: TextStyle(fontSize: 0.5),
        ),
        Container(
          child: ExpansionTile(
              expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
              title: Text(
                listOfSectionData[widget.courseName][sectionIndex]["modulename"]
                    .toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: List.generate(
                  listOfSectionData[widget.courseName][sectionIndex]["videos"]
                      .length, (subsectionIndex) {
                listOfSectionData[widget.courseName][sectionIndex]["videos"]
                    .sort((a, b) {
                  if (a["sr"] > b["sr"]) {
                    return 1;
                  }
                  return -1;
                });
                return Column(children: [
                  subIndex != null &&
                      subIndex == subsectionIndex &&
                      index == sectionIndex
                      ? Draggable(
                    data: 0,
                    child: Container(
                      color: Colors.purpleAccent,
                      child: GestureDetector(
                          onTap: () {},
                          child: Container(
                              padding: EdgeInsets.only(
                                  left: 60, top: 15, bottom: 15),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    listOfSectionData[widget.courseName]
                                    [sectionIndex]
                                    ["videos"]
                                    [subsectionIndex]
                                    ["type"] ==
                                        "video"
                                        ? Icon(Icons.play_circle)
                                        : Icon(Icons.assessment),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Text(
                                          listOfSectionData[widget.courseName]
                                          [sectionIndex]
                                          ["videos"]
                                          [subsectionIndex]
                                          ["type"] ==
                                              "video"
                                              ? listOfSectionData[widget.courseName]
                                          [sectionIndex]
                                          ["videos"]
                                          [subsectionIndex]
                                          ["name"]
                                              .toString()
                                              : "Assignment : " +
                                              listOfSectionData[widget.courseName]
                                              [sectionIndex]
                                              ["videos"]
                                              [subsectionIndex]["name"]
                                                  .toString(),
                                          style: TextStyle(
                                              overflow:
                                              TextOverflow.ellipsis),
                                        ))
                                  ],
                                ),
                              ))),
                    ),
                    feedback: SizedBox(
                      height: 50,
                      child: Container(
                          padding: EdgeInsets.only(
                              left: 60, top: 15, bottom: 15),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                listOfSectionData[widget.courseName]
                                [index]["videos"]
                                [subIndex]["type"] ==
                                    "video"
                                    ? Icon(Icons.play_circle)
                                    : Icon(Icons.assessment),
                                SizedBox(
                                  width: 10,
                                ),
                                DefaultTextStyle(
                                  style: TextStyle(
                                      color: Colors.black,
                                      overflow: TextOverflow.ellipsis),
                                  child:
                                  // Expanded(
                                  //   child:
                                  Text(
                                    listOfSectionData[widget.courseName]
                                    [index]["videos"]
                                    [subIndex]["type"] ==
                                        "video"
                                        ? listOfSectionData[widget.courseName]
                                    [index]["videos"]
                                    [subIndex]["name"]
                                        .toString()
                                        : "Assignment : " +
                                        listOfSectionData[widget
                                            .courseName]
                                        [index]["videos"]
                                        [subIndex]["name"]
                                            .toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.normal,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  // )
                                )
                              ],
                            ),
                          )),
                    ),
                  )
                      : DragTarget<int>(
                    builder: (context, _, __) => GestureDetector(
                        onDoubleTap: () {
                          print("doubletap");
                          if (role != null) {
                            if (role == "mentor") {
                              setState(() {
                                // selectAssignment = null;
                                subIndex = subsectionIndex;
                                index = sectionIndex;
                              });
                            }
                          }
                          print(subsectionIndex);
                        },
                        onTap: () {
                          if (listOfSectionData[widget.courseName]
                          [sectionIndex]["videos"]
                          [subsectionIndex]["type"] ==
                              "video") {
                            _betterPlayerController.dispose();

                            String vidUrl = setUrl(
                                listOfSectionData[widget.courseName]
                                [sectionIndex]["videos"]
                                [subsectionIndex]["url"]);
                            initBetterPlayer(vidUrl);

                            setState(() {
                              presentvideolink =
                              listOfSectionData[widget.courseName]
                              [sectionIndex]["videos"]
                              [subsectionIndex]["url"];
                            });
                          } else if (listOfSectionData[widget.courseName]
                          [sectionIndex]["videos"]
                          [subsectionIndex]["type"] ==
                              'assignment') {
                            for (var i in assignmentlist) {
                              if (i['name'] ==
                                  listOfSectionData[widget.courseName]
                                  [sectionIndex]["videos"]
                                  [subsectionIndex]["name"]) {
                                print(
                                    'root.link assignment1 ${i['url']}');
                                Navigator.push(
                                  this.context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AssignmentScreen(
                                            i['url'], i['pdf'],
                                            pdfUrl: pdfUrl,
                                            assignmentName:
                                            assignmentName,
                                            dataSetName: dataSetName,
                                            dataSetUrl: dataSetUrl),
                                  ),
                                );
                                break;
                              }
                            }
                          } else if (listOfSectionData[widget.courseName]
                          [sectionIndex]["videos"]
                          [subsectionIndex]["type"] ==
                              'quiz') {
                            // logic for getting the map by filtering by title
                            var data;
                            for (var i in quizlist) {
                              if (i['name'] ==
                                  listOfSectionData[widget.courseName]
                                  [sectionIndex]["videos"]
                                  [subsectionIndex]["name"]) {
                                data = i;
                                break;
                              }
                            }
                            Navigator.push(
                              this.context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    QuizentrypageWidget(data),
                              ),
                            );
                          } else if (listOfSectionData[widget.courseName]
                          [sectionIndex]["videos"]
                          [subsectionIndex]["type"] ==
                              'resume') {
                            Navigator.push(
                              this.context,
                              MaterialPageRoute(
                                builder: (context) => SubmitResume(
                                  studentId: studentName!,
                                  studentEmail: userEmail!,
                                  studentName: studentName!,
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 30, top: 15, bottom: 15),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                listOfSectionData[widget.courseName]
                                [sectionIndex]["videos"]
                                [subsectionIndex]["type"] ==
                                    "video"
                                    ? Icon(Icons.play_circle)
                                    : Icon(Icons.assessment,
                                    color: listOfSectionData[widget.courseName][sectionIndex]
                                    ["videos"]
                                    [subsectionIndex]
                                    ["type"] ==
                                        'assignment' ||
                                        listOfSectionData[widget.courseName]
                                        [sectionIndex]
                                        ["videos"]
                                        [subsectionIndex]["type"] ==
                                            'quiz'
                                        ? Colors.purple
                                        : null),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    listOfSectionData[widget.courseName]
                                    [sectionIndex]
                                    ["videos"][subsectionIndex]
                                    ["type"] ==
                                        "video"
                                        ? listOfSectionData[widget.courseName]
                                    [sectionIndex]["videos"]
                                    [subsectionIndex]["name"]
                                        .toString()
                                        : listOfSectionData[widget.courseName]
                                    [sectionIndex]
                                    ["videos"][subsectionIndex]
                                    ["type"] ==
                                        "assignment"
                                        ? "Assignment : " +
                                        listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]["name"].toString()
                                        : listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]["type"] == "quiz"
                                        ? "Quiz : " + listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]["name"].toString()
                                        : listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]["name"].toString(),
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: listOfSectionData[widget.courseName]
                                        [sectionIndex]
                                        ["videos"]
                                        [subsectionIndex]
                                        ["type"] ==
                                            'assignment' ||
                                            listOfSectionData[widget
                                                .courseName]
                                            [sectionIndex]
                                            ["videos"][
                                            subsectionIndex]["type"] ==
                                                'quiz'
                                            ? Colors.purple
                                            : null),
                                  ),
                                ),
                                listOfSectionData[widget.courseName]
                                [sectionIndex]["videos"]
                                [subsectionIndex]["type"] ==
                                    'video'
                                    ? FutureBuilder(
                                  future: getProooDataaa(
                                      listOfSectionData[widget
                                          .courseName]
                                      [sectionIndex]["id"]
                                          .toString(),
                                      listOfSectionData[widget
                                          .courseName]
                                      [sectionIndex]
                                      ["videos"][
                                      subsectionIndex]["id"]
                                          .toString()),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Row(
                                        children: [
                                          Text(
                                            snapshot.data == '' ||
                                                snapshot.data ==
                                                    null ||
                                                snapshot.data ==
                                                    'null'
                                                ? '0%'
                                                : '${snapshot.data}%',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight:
                                                FontWeight
                                                    .bold),
                                          ),
                                          Column(
                                            mainAxisSize:
                                            MainAxisSize.min,
                                            children: [
                                              Transform.scale(
                                                scale: 1,
                                                child: Checkbox(
                                                  checkColor:
                                                  snapshot.data ==
                                                      '100'
                                                      ? Colors
                                                      .white
                                                      : Colors
                                                      .white,
                                                  fillColor: snapshot
                                                      .data ==
                                                      '100'
                                                      ? MaterialStateProperty.resolveWith<
                                                      Color>((Set<
                                                      MaterialState>
                                                  states) {
                                                    if (states
                                                        .contains(
                                                        MaterialState.disabled)) {
                                                      return Colors
                                                          .green;
                                                    }
                                                    return Colors
                                                        .green;
                                                  })
                                                      : null,
                                                  value:
                                                  snapshot.data ==
                                                      '100'
                                                      ? true
                                                      : false,
                                                  shape:
                                                  CircleBorder(),
                                                  onChanged: snapshot
                                                      .data !=
                                                      '100' ||
                                                      snapshot.data ==
                                                          ''
                                                      ? (bool?
                                                  value) {
                                                    setState(
                                                            () {
                                                          setVideoProgress(
                                                              listOfSectionData[widget.courseName][sectionIndex]["id"],
                                                              listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]["id"],
                                                              100);
                                                          print(
                                                              'Updated List ::: ${_getVideoPercentageList}');
                                                          updateVideoProgress(
                                                              _getVideoPercentageList);
                                                        });
                                                  }
                                                      : null,
                                                ),
                                              ),
                                              Text(
                                                'Mark As Complete',
                                                style: TextStyle(
                                                    fontSize: 5,
                                                    color: Colors
                                                        .black),
                                              )
                                            ],
                                          )
                                        ],
                                      );
                                    } else {
                                      return SizedBox();
                                    }
                                  },
                                )
                                    : SizedBox(),
                                quizScoreMap[listOfSectionData[
                                widget.courseName]
                                [sectionIndex]["videos"]
                                [subsectionIndex]["name"]] !=
                                    null
                                    ? Padding(
                                  padding:
                                  EdgeInsets.only(right: 10),
                                  child: Text(
                                    '${quizScoreMap[listOfSectionData[widget.courseName][sectionIndex]["videos"][subsectionIndex]["name"]].round()}%',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight:
                                        FontWeight.bold),
                                  ),
                                )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                          color: presentvideolink ==
                              listOfSectionData[widget.courseName]
                              [sectionIndex]["videos"]
                              [subsectionIndex]["url"]
                              ? Colors.purpleAccent.withOpacity(0.5)
                              : null,
                        )),
                    onAccept: (data) async {
                      int count = 0;
                      if (subIndex != null &&
                          index != null &&
                          index == sectionIndex) {
                        if (subIndex! < subsectionIndex) {
                          print(true);
                          for (int i = 0; i <= subsectionIndex; i++) {
                            print("count===");
                            if (i == subIndex) {
                              listOfSectionData[widget.courseName]
                              [sectionIndex]["videos"][i]["sr"] =
                              listOfSectionData[widget.courseName]
                              [sectionIndex]["videos"]
                              [subsectionIndex]["sr"];
                              continue;
                            }
                            print("count===${count}");
                            listOfSectionData[widget.courseName]
                            [sectionIndex]["videos"][i]["sr"] = count;
                            count++;
                          }
                        } else {
                          print(false);
                          count = 0;
                          for (int j = subsectionIndex;
                          j <= subIndex!;
                          j++) {
                            print("j======${j}");
                            if (j == subIndex) {
                              listOfSectionData[widget.courseName]
                              [sectionIndex]["videos"][j]["sr"] =
                                  subsectionIndex;
                              print(
                                  "a = ${listOfSectionData[widget.courseName][sectionIndex]["videos"][j]["sr"]}");
                            } else {
                              listOfSectionData[widget.courseName]
                              [sectionIndex]["videos"][j]["sr"] =
                                  j + 1;
                              print(
                                  "b = ${listOfSectionData[widget.courseName][sectionIndex]["videos"][j]["sr"]}");
                            }
                          }
                        }
                        await FirebaseFirestore.instance
                            .collection("courses")
                            .doc(courseId)
                            .update({"curriculum1": listOfSectionData});
                        setState(() {
                          listOfSectionData;
                          subIndex = null;
                          index = null;
                        });
                      }
                    },
                  ),
                ]);
              })),
        ),
      ],
    );
  }

}

class Counter {
  static final _stateStreamControllerVideos =
      StreamController<Map<String, dynamic>?>.broadcast();
  static StreamSink<Map<String, dynamic>?> get counterSinkVideos =>
      _stateStreamControllerVideos.sink;
  static Stream<Map<String, dynamic>?> get counterStreamVideos =>
      _stateStreamControllerVideos.stream;
}

class replay10 extends StatelessWidget {
  const replay10({
    Key? key,
    required VideoPlayerController? videoController,
  })  : _videoController = videoController,
        super(key: key);

  final VideoPlayerController? _videoController;

  Widget quizWidget() {
    return Container(
      child: Column(
        children: [
          Text("data"),
          IconButton(
              color: Color.fromARGB(255, 250, 22, 22),
              icon: Icon(
                Icons.done,
                color: Color.fromARGB(255, 0, 255, 8),
              ),
              onPressed: () async {}
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) =>
              //         QuizentrypageWidget(data),
              //   ),
              // );

              ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (() async {
        final currentPosition = await _videoController!.position;
        final newPosition = currentPosition! - Duration(seconds: 10);
        _videoController!.seekTo(newPosition);
      }),
      child: Icon(
        Icons.replay_10,
        size: 40,
        color: Colors.white,
      ),
    );
  }
}

class fastForward10 extends StatelessWidget {
  const fastForward10({
    Key? key,
    required VideoPlayerController? videoController,
  })  : _videoController = videoController,
        super(key: key);

  final VideoPlayerController? _videoController;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (() async {
        final currentPosition = await _videoController!.position;
        final newPosition = currentPosition! + Duration(seconds: 10);
        _videoController!.seekTo(newPosition);
      }),
      child: Icon(
        Icons.forward_10,
        size: 40,
        color: Colors.white,
      ),
    );
  }
}

class fullScreenIcon extends StatelessWidget {
  const fullScreenIcon({
    Key? key,
    required this.isPortrait,
  }) : super(key: key);

  final bool isPortrait;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IconButton(
        onPressed: () {
          if (isPortrait) {
            AutoOrientation.landscapeRightMode();
          } else {
            AutoOrientation.portraitUpMode();
          }
        },
        icon: Icon(
          isPortrait ? Icons.fullscreen_rounded : Icons.fullscreen_exit_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}

class DataList {
  DataList(this.title, this.link, this.downloaded, this.type, this.progressData,
      this.moduleId, this.videoId,
      [this.children = const <DataList>[]]);
  final String? link;
  String type;
  bool downloaded;
  final String title;
  final String progressData;
  final String? moduleId;
  final String? videoId;
  final List<DataList> children;
}
