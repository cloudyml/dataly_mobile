import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/MyAccount/myaccount.dart';
import 'package:cloudyml_app2/Providers/AppProvider.dart';
import 'package:cloudyml_app2/Providers/UserProvider.dart';
import 'package:cloudyml_app2/Providers/chat_screen_provider.dart';
import 'package:cloudyml_app2/Services/database_service.dart';
import 'package:cloudyml_app2/authentication/firebase_auth.dart';
import 'package:cloudyml_app2/models/course_details.dart';
import 'package:cloudyml_app2/models/user_details.dart';
import 'package:cloudyml_app2/models/video_details.dart';
import 'package:cloudyml_app2/module/downloaded_video.dart';
import 'package:cloudyml_app2/my_Courses.dart';
import 'package:cloudyml_app2/notification.dart';
import 'package:cloudyml_app2/screens/chat_screen.dart';
import 'package:cloudyml_app2/screens/splash.dart';
import 'package:cloudyml_app2/screens/stores/login_store.dart';
import 'package:cloudyml_app2/services/local_notificationservice.dart';
import 'package:cloudyml_app2/story/story_provider.dart';
import 'package:cloudyml_app2/widgets/image_msg_tile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:toast/toast.dart';
import 'package:sizer/sizer.dart'; 
import 'Services/deeplink_service.dart';
Future<void> backgroundHandler(RemoteMessage message) async {
  sendAppNotification();
}
sendAppNotification() async {
  Stream<QuerySnapshot<Map<String, dynamic>>> notificationStream =
      FirebaseFirestore.instance.collection('Notifications').snapshots();
  notificationStream.listen((event) {
    if (event.docs.isEmpty) {
      return;
    } else {
      event.docs.indexWhere((element) {
        if (element.get('send')) {
          NotiFicationServ().init().whenComplete(
            () {
            NotiFicationServ().showBasicNotification(element);
          }
          );
          return true;
        }
        return false;
      });
    }
  });
}
final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox('myBox');
  await Hive.openBox("NotificationBox");
  await Hive.openBox("ListenMessages");
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'image',
      channelName: 'Dataly',
      channelDescription: "Dataly",
      enableLights: true,
      playSound: true,
      locked: true,
      defaultColor: Colors.green,
    )
  ]);
  print("sidfsoijossd");
  // initAutoStart();
  print("sidjvosioieroior");
  await Firebase.initializeApp();
  DeepLinkService.instance?.handleDynamicLinks();

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LocalNotificationService.initialize();
  await _flutterLocalNotificationsPlugin.cancelAll();
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  sendAppNotification();
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: UserProvider.initialize()),
          Provider<LoginStore>(
            create: (_) => LoginStore(),
          ),
          ChangeNotifierProvider(create: (context) => Downloadlink()),
          ChangeNotifierProvider(
              create: (_) => ChatScreenNotifier(), child: ChatScreen()),
          ChangeNotifierProvider(
              create: (_) => ChatScreenNotifier(), child: ImageMsgTile()),
          ChangeNotifierProvider.value(value: AppProvider()),
          StreamProvider<List<CourseDetails>>.value(
            value: DatabaseServices().courseDetails,
            initialData: [],
          ),
          StreamProvider<List<VideoDetails>>.value(
            value: DatabaseServices().videoDetails,
            initialData: [],
          ),
          StreamProvider<UserDetails?>.value(
            value: DatabaseServices().currentUserDetails,
            initialData: null,
          ),
          // ChangeNotifierProvider.value(value: StoryProvider.initialize()),
        ],
       child: Sizer(builder: ((context, orientation, deviceType) {
            return ResponsiveSizer(builder: (context, orientation, screenType) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Dataly',
            builder: (BuildContext context, Widget? widget) {
              ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
                return Container();
              };
              return MediaQuery(
                child: widget!,
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.15),
              );
            },
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: splash(),
            routes: {
              "account": (_) => MyAccountPage(),
              "courses": (_) => HomeScreen(),
            },
          );
        });})),
      ),
    );
  }
}
