import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:badges/badges.dart' as Badge;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dataly_app/MyAccount/myaccount.dart';
import 'package:dataly_app/Providers/UserProvider.dart';
import 'package:dataly_app/aboutus.dart';
import 'package:dataly_app/authentication/firebase_auth.dart';
import 'package:dataly_app/models/course_details.dart';
import 'package:dataly_app/payments_history.dart';
import 'package:dataly_app/my_Courses.dart';
import 'package:dataly_app/homepage.dart';
import 'package:dataly_app/offline/offline_videos.dart';
import 'package:dataly_app/privacy_policy.dart';
import 'package:dataly_app/screens/all_certificate_screen.dart';
import 'package:dataly_app/screens/groups_list.dart';
import 'package:dataly_app/screens/moneyref/money_referal_screen.dart';
import 'package:dataly_app/screens/review.dart';
import 'package:dataly_app/services/database_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:dataly_app/services/local_notificationservice.dart';
import 'package:dataly_app/store.dart';
import 'package:dataly_app/story/story_provider.dart';
import 'package:dataly_app/story/story_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:dataly_app/screens/groupscreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Services/code_generator.dart';
import 'Services/deeplink_service.dart';
import 'catalogue_screen.dart';
import 'globals.dart';
import 'package:http/http.dart' as http;
// import 'package:package_info/package_info.dart';
import 'global_variable.dart' as globals;
import 'homescreen/home_screen.dart';
import 'models/referal_model.dart';
import 'package:share_extend/share_extend.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'module/submit_resume.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();

  final GlobalKey _four = GlobalKey();
  final GlobalKey _five = GlobalKey();
  final GlobalKey _six = GlobalKey();
  final GlobalKey _seven = GlobalKey();
  final GlobalKey _eight = GlobalKey();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int? _selectedIndex = 0;
  var rewardCount = 0;
  String? _linkMessage;
  bool openPaymentHistory = false;
  Map<String, dynamic>? userdetails = {};

  String currentVersion = '';
  String latestVersion = '';

  List<String> titles = [
    'Home',
    // 'Store',
    // 'Story',
    // 'Offline Videos',
    'Chat',
  ];
  var count = 0;

  List<Widget> screens() {
    return [
      NewHomeScreen(),
      // StoreScreen(),
      // StoryScreen(),
      // OfflinePage(),
      GroupPage()
    ];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAppVersion();
    print('jwoeifjowiefiojwoe');
    WidgetsBinding.instance!.addObserver(this);
    // setShowCaseView();
    insertToken();
    // print('UID--${FirebaseAuth.instance.currentUser!.uid}');
    getuserdetails();
    checkrewardexpiry();
    getgroupChatCountNew();
    // Provider.of<UserProvider>(context, listen: false).reloadUserModel();
    // if (storyTimer) {
    //   //adding cron task for updating the status in every 5 minutes
    //   //we can reduce the frequency later on
    //   //run this timer only once after that it will run periodic
    //   Timer.periodic(Duration(minutes: 5), (timer) {
    //     Provider.of<StoryProvider>(context, listen: false).reloadStoryModel();
    //   });
    //   storyTimer = false;
    // }
  }

  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    currentVersion = packageInfo.version;
    String appName = packageInfo.appName;
    print('app name: $appName');
    String packageName = packageInfo.packageName;
    print('package name: $packageName');
    String version = packageInfo.version;
    print('version: $version');
    String buildNumber = packageInfo.buildNumber;
    currentVersion = "$version+$buildNumber";
    print('build number: $buildNumber');
    FirebaseFirestore.instance
        .collection("Controllers")
        .doc('variables')
        .get()
        .then((value) {
      latestVersion = value.data()!['appversion'];
      print("wiofjowej");
      print(currentVersion);
      print(latestVersion);
      _checkForUpdate();
    });
  }

  void _checkForUpdate() {
    if (currentVersion != '' &&
        latestVersion != '' &&
        currentVersion != latestVersion) {
      // Current version is outdated, show dialog or screen to update
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Update Required'),
          content: Text(
              'A new version of the app is available. Please update to the latest version.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Redirect to Play Store
                // Replace "YOUR_APP_PACKAGE_NAME" with your app's package name
                launch(
                    'https://play.google.com/store/apps/details?id=com.cloudyml.cloudymlapp');
              },
              child: Text('Update'),
            ),
          ],
        ),
      );
    }
  }

  final dynamicLink = FirebaseDynamicLinks.instance;

  Future<void> handleDynamicLinks() async {
    //Get initial dynamic link if app is started using the link
    final data = await dynamicLink.getInitialLink();
    try {
      globals.moneyreflink = data!.link.toString();
    } catch (e) {
      print(e);
    }

    print("sdfffffffffffffffasdjfaaaaaaaaaaaaaaaaaaaaaaaaaaaa: ${data}");
    if (data != null) {
      print("sdfffffffffffffffasdjfaaaaaaaaaaaaaaaaaaaaaaaaaaaa ${data}");
      _handleDeepLink(data);
    }

    //handle foreground
    dynamicLink.onLink.listen((event) {
      _handleDeepLink(event);
    }).onError((v) {
      debugPrint('Failed: $v');
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        handleDynamicLinks();
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

  ValueNotifier<String> referrerCode = ValueNotifier<String>('');
  ValueNotifier<String> moneyreferrerCode = ValueNotifier<String>('');

  Future<void> _handleDeepLink(PendingDynamicLinkData data) async {
    final Uri deepLink = data.link;
    var len = deepLink.toString().length;
    var index = data.link.toString().indexOf("moneyreward");
    print("llllppoooo ${deepLink}");
    print(index);
    print(data.link);
    if (deepLink.toString().length > 15) {
      if (index == -1) {
        var value = deepLink.toString().substring(len - 14, len);
        // print("this is value ${value}");
        print(
            "sdfffffffffffffffasdjfaaaaaaaaaaa${index}aajhhjhhhhhhhhhhhh${value}hhhhhaaaaaaaaaaaaaaa ${data.link}");
        referrerCode.value = value;
        print(value);
        print(referrerCode.value);
        referrerCode.notifyListeners();
      } else {
        print(
            "else block: ${index}aajhhjhhhhhhhhhhhhhhhhhaaaaaaaaaaaaaaa ${data.link}");
        var splitingdatalink =
            data.link.toString().split('cloudymlapp&/refer?code=');
        globals.moneyrefcode = splitingdatalink[1];
        courseId = splitingdatalink[1].split('-')[1];
        FirebaseFirestore.instance
            .collection("Users_dataly")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((value) {
          if (value.data()!['sendermoneyrefcode'] != globals.moneyrefcode) {
            FirebaseFirestore.instance
                .collection("Users_dataly")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update({
              "sendermoneyrefcode": globals.moneyrefcode,
              "sendermoneyrefuid": globals.moneyrefcode.split('-')[2],
              "senderrefvalidfrom": DateTime.now()
            });
          }
        });
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CatelogueScreen(),
          ),
        );

        print("this is refer code: ${globals.moneyrefcode}");

        courseId = globals.moneyrefcode.split('-')[1];
        referrerCode.value = '';
        moneyreferrerCode.value = globals.moneyrefcode[2];
        if (globals.moneyrefcode[2].toString() !=
            FirebaseAuth.instance.currentUser!.uid) {}

        moneyreferrerCode.notifyListeners();
        referrerCode.notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // setShowCaseView() async {
  //   try {
  //     if (await IsFirstRun.isFirstRun()) {
  //       WidgetsBinding.instance.addPostFrameCallback(
  //         (_) => ShowCaseWidget.of(this.context).startShowCase(
  //             [_one, _two, _three, _four, _five, _six, _seven, _eight]),
  //       );
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // create a function for checking if today is the last day of month
  bool isLastDayOfMonth() {
    var now = DateTime.now();
    var lastDayDateTime = DateTime(now.year, now.month + 1, 0);
    var lastDay = lastDayDateTime.day;
    var today = now.day;
    return today == lastDay;
  }

  calculateMoneyRefAmount() {
    var lastday = isLastDayOfMonth();
    num totalmoneyrefamount = 0;
    if (lastday) {
      FirebaseFirestore.instance
          .collection("Users_dataly")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        var moneyreflist = value.data()!['moneyreflist'];
        for (var i in moneyreflist) {
          try {
            if (i['status'] == "panding") {
              totalmoneyrefamount = totalmoneyrefamount + i['price'];
            }
          } catch (e) {
            print(e.toString());
          }
        }
        if (totalmoneyrefamount != 0) {
          // send money to user wallet

          // update the status of items in moneyreflist to creadited(green color)
        }
      });
    }
  }

  getgroupChatCountNew() async {
    var data;
    try {
      data = await FirebaseFirestore.instance
          .collection("groups_dataly")
          .where("groupChatCountNew",
              arrayContains: FirebaseAuth.instance.currentUser!.uid)
          .snapshots();
      var items = <dynamic>[];

      await FirebaseFirestore.instance
          .collection("groups_dataly")
          .orderBy("groupChatCountNew")
          .where("groupChatCountNew")
          .get()
          .then((QuerySnapshot snapshot) {
        snapshot.docs.forEach(
          (f) => items.add(f.get("groupChatCountNew")),
        );
      });
      print("sdifjoiejo${items}");
      for (var i in items) {
        try {
          // print(
          //     "this is value:${FirebaseAuth.instance.currentUser!.uid.toString()} soseio  ${i["${FirebaseAuth.instance.currentUser!.uid.toString()}"]}");

          if (i['${FirebaseAuth.instance.currentUser!.uid.toString()}'] !=
              null) {
            if (i['${FirebaseAuth.instance.currentUser!.uid.toString()}'] !=
                0) {
              count += 1;
            }
          }
        } catch (e) {
          print(e.toString());
        }
      }
      print("value of count: ${count}");
      setState(() {
        count = count;
        globals.chatcount = count;
      });
    } catch (e) {
      print("this si ijeo${e.toString()}");
    }

    var ele;
    data.forEach((element) {
      ele = element;
    });
  }

  checkrewardexpiry() async {
    var rewardvalidfrom;
    var rewardexpireindays;
    try {
      await FirebaseFirestore.instance
          .collection("Users_dataly")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        rewardvalidfrom = value.data()!['rewardvalidfrom'];
      });
      await FirebaseFirestore.instance
          .collection("Controllers")
          .doc("variables")
          .get()
          .then((value) {
        rewardexpireindays = value.data()!['rewardexpireindays'];
      });
    } catch (e) {
      print(e.toString());
    }
    if (rewardexpireindays == null) {
      rewardexpireindays = 7;
    }
    if (rewardvalidfrom != null) {
      var data = DateTime.now().difference(rewardvalidfrom.toDate());
      if (data.inDays >= rewardexpireindays) {
        await FirebaseFirestore.instance
            .collection("Users_dataly")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({"reward": 0}).whenComplete(() {
          print('success');
        }).onError((error, stackTrace) => print(error));
      }
    }
  }

  void insertToken() async {
    try {
      print("insertToken");
      final token = await FirebaseMessaging.instance.getToken();
      print(token);
      await FirebaseFirestore.instance
          .collection("Users_dataly")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"token": token});
      final data = await FirebaseFirestore.instance
          .collection("Users_dataly")
          .doc(FirebaseAuth.instance.currentUser!.uid);

      final response = data.get().then((DocumentSnapshot doc) {
        final data2 = doc.data() as Map<String, dynamic>;
        print(data2);
      });
      print(response);
      print("insertedToken");
    } catch (e) {
      print("sjdfojd: ${e.toString()}");
    }
  }

  void getuserdetails() async {
    final deepLinkRepo = await DeepLinkService.instance;
    var referralCode = await deepLinkRepo?.referrerCode.value;

    print(
        "sddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd $referralCode ddd");
    await FirebaseFirestore.instance
        .collection('Users_dataly')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) async {
      print(value.data());
      print(FirebaseAuth.instance.currentUser!.uid);

      try {
        _linkMessage = await value.data()!['refer_link'];
        rewardCount = await value.data()!['reward'];
        setState(() {
          rewardCount;
        });
      } catch (e) {
        print(e);
        _linkMessage = '';
      }
      print(_linkMessage);
      print('1');
      if (_linkMessage == '' || _linkMessage == null) {
        print('2');
        print(_linkMessage);
        updateReferaldata();
      } else {}
      ;
    });
  }

  void updateReferaldata() async {
    try {
      print('4');
      final deepLinkRepo = await DeepLinkService.instance;
      var referralCode = await deepLinkRepo?.referrerCode.value;
      print(
          "sddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd ${referralCode}");
      final referCode = await CodeGenerator().generateCode('refer');
      final referLink =
          await DeepLinkService.instance?.createReferLink(referCode);
      setState(() {
        if (referralCode != '') {
          rewardCount = 50;
        } else {
          rewardCount = 0;
        }
        _linkMessage = referLink;
        print(_linkMessage);
      });

      await FirebaseFirestore.instance
          .collection("Users_dataly")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'refer_link': referLink,
        'refer_code': referCode,
        "referral_code": referralCode,
        'reward': rewardCount,
      }).whenComplete(() =>
              print("send data to firebase uid: ${_auth.currentUser!.uid}"));

      Future<ReferalModel> getReferrerUser(String referCode) async {
        print("iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii ${referCode}");
        final docSnapshots = await FirebaseFirestore.instance
            .collection('Users_dataly')
            .where('refer_code', isEqualTo: referCode)
            .get();

        final userSnapshot = docSnapshots.docs.first;
        print(
            "iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii ${userSnapshot.exists}");
        if (userSnapshot.exists) {
          print(userSnapshot.data());
          return ReferalModel.fromJson(userSnapshot.data());
        } else {
          return ReferalModel.empty();
        }
      }

      Future<void> rewardUser(
          String currentUserUID, String referrerCode) async {
        try {
          final referer = await getReferrerUser(referrerCode);
          print("iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii ${referer.id}");

          final checkIfUserAlreadyExist = await FirebaseFirestore.instance
              .collection('Users_dataly')
              .doc(referer.id)
              .collection('referrers')
              .doc(currentUserUID)
              .get();

          if (!checkIfUserAlreadyExist.exists) {
            await FirebaseFirestore.instance
                .collection('Users_dataly')
                .doc(referer.id)
                .collection('referrers')
                .doc(currentUserUID)
                .set({
              "uid": currentUserUID,
              "createdAt": DateTime.now(),
            });

            await FirebaseFirestore.instance
                .collection('Users_dataly')
                .doc(referer.id)
                .update({
              "reward": FieldValue.increment(50),
            });
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      }

      if (referralCode != "") {
        print("iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii ${referralCode}");
        await rewardUser(_auth.currentUser!.uid, referralCode!);
      }
      ;
    } catch (e) {
      print(
          "................................................................................................................................${e}");
    }
  }

  // void getuserdetails() async {
  //   await FirebaseFirestore.instance
  //       .collection('Users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get()
  //       .then((value) {
  //     print(value.data());
  //     setState(() {
  //       userdetails = value.data();
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final userprovider = Provider.of<UserProvider>(context, listen: false);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // bool storyBadge =
    // Provider.of<StoryProvider>(context, listen: false).storyBadge;
    return Scaffold(
      key: _scaffoldKey,
      body: PageView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, index) {
            if (openPaymentHistory) {
              return PaymentHistory();
            } else {
              return screens()[_selectedIndex!];
            }
          }),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.only(top: 0),
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                userprovider.userModel?.name.toString() ?? 'Enter name',
              ),
              accountEmail: Text(
                userprovider.userModel?.email.toString() == ''
                    ? userprovider.userModel?.mobile.toString() ?? ''
                    : userprovider.userModel?.email.toString() ?? 'Enter email',
              ),
              currentAccountPicture: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyAccountPage()));
                },
                child: CircleAvatar(
                  foregroundColor: Colors.black,
                  //foregroundImage: NetworkImage('https://stratosphere.co.in/img/user.jpg'),
                  foregroundImage:
                      NetworkImage(userprovider.userModel?.image ?? ''),
                  backgroundColor: Colors.transparent,
                  backgroundImage: CachedNetworkImageProvider(
                    'https://stratosphere.co.in/img/user.jpg',
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: HexColor('7B62DF'),
              ),
            ),
            // Container(
            //     height: height * 0.27,
            //     //decoration: BoxDecoration(gradient: gradient),
            //     color: HexColor('7B62DF'),
            //     child: StreamBuilder<QuerySnapshot>(
            //       stream: FirebaseFirestore.instance
            //           .collection("Users")
            //           .snapshots(),
            //       builder: (BuildContext context,
            //           AsyncSnapshot<QuerySnapshot> snapshot) {
            //         if (!snapshot.hasData) return const SizedBox.shrink();
            //         return ListView.builder(
            //           itemCount: snapshot.data!.docs.length,
            //           itemBuilder: (BuildContext context, index) {
            //             DocumentSnapshot document = snapshot.data!.docs[index];
            //             Map<String, dynamic> map = snapshot.data!.docs[index]
            //                 .data() as Map<String, dynamic>;
            //             if (map["id"].toString() ==
            //                 FirebaseAuth.instance.currentUser!.uid) {
            //               return Padding(
            //                 padding: EdgeInsets.all(width * 0.05),
            //                 child: Container(
            //                   child: Column(
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     mainAxisSize: MainAxisSize.min,
            //                     children: [
            //                       CircleAvatar(
            //                         radius: width * 0.089,
            //                         backgroundImage:
            //                             AssetImage('assets/user.jpg'),
            //                       ),
            //                       SizedBox(
            //                         height: height * 0.01,
            //                       ),
            //                       map['name'] != null
            //                           ? Text(
            //                               map['name'],
            //                               style: TextStyle(
            //                                   color: Colors.white,
            //                                   fontWeight: FontWeight.w500,
            //                                   fontSize: width * 0.049),
            //                             )
            //                           : Text(
            //                               map['mobilenumber'],
            //                               style: TextStyle(
            //                                   color: Colors.white,
            //                                   fontWeight: FontWeight.w500,
            //                                   fontSize: width * 0.049),
            //                             ),
            //                       SizedBox(
            //                         height: height * 0.007,
            //                       ),
            //                       map['email'] != null
            //                           ? Text(
            //                               map['email'],
            //                               style: TextStyle(
            //                                   color: Colors.white,
            //                                   fontSize: width * 0.038),
            //                             )
            //                           : Container(),
            //                     ],
            //                   ),
            //                 ),
            //               );
            //             } else {
            //               return Container();
            //             }
            //           },
            //         );
            //       },
            //     )
            // ),
            InkWell(
              child: ListTile(
                title: Text('Home'),
                leading: Icon(
                  Icons.home,
                  color: HexColor('6153D3'),
                ),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
            ),
            InkWell(
              child: ListTile(
                title: Text('My Account'),
                leading: Icon(
                  Icons.person,
                  color: HexColor('6153D3'),
                ),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyAccountPage()));
              },
            ),
            InkWell(
              child: ListTile(
                title: Text('My Courses'),
                leading: Icon(
                  Icons.book,
                  color: HexColor('6153D3'),
                ),
              ),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              },
            ),
            InkWell(
              child: ListTile(
                title: Text('Reviews'),
                leading: Icon(
                  Icons.book_online,
                  color: HexColor('6153D3'),
                ),
              ),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewsScreen(),
                  ),
                );
              },
            ),
            // InkWell(
            //   onTap: () {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => PaymentHistory()));
            //   },
            //   child: ListTile(
            //     title: Text('Payment History'),
            //     leading: Icon(
            //       Icons.payment_rounded,
            //       color: HexColor('6153D3'),
            //     ),
            //   ),
            // ),
            // Divider(
            //   thickness: 2,
            // ),
            // InkWell(
            //   onTap: () {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => PrivacyPolicy()));
            //   },
            //   child: ListTile(
            //     title: Text('Privacy policy'),
            //     leading: Icon(
            //       Icons.privacy_tip,
            //       color: HexColor('6153D3'),
            //     ),
            //   ),
            // ),
            // InkWell(
            //   onTap: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => AllCertificateScreen()));
            //   },
            //   child: ListTile(
            //     title: Text('Certificates'),
            //     leading: Icon(
            //       Icons.card_membership_outlined,
            //       color: HexColor('6153D3'),
            //     ),
            //   ),
            // ),
            // InkWell(
            //   onTap: () {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => ReferScreen()));
            //   },
            //   child: ListTile(
            //     title: Text('Affiliate'),
            //     leading: Icon(
            //       Icons.monetization_on,
            //       color: HexColor('6153D3'),
            //     ),
            //   ),
            // ),
            // InkWell(
            //   child: ListTile(
            //     title: Text('About Us'),
            //     leading: Icon(
            //       Icons.info,
            //       color: HexColor('6153D3'),
            //     ),
            //   ),
            //   onTap: () async {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => AboutUs()));
            //   },
            // ),
            // InkWell(
            //   child: ListTile(
            //     title: Text('Share'),
            //     leading: Icon(
            //       Icons.share,
            //       color: HexColor('6153D3'),
            //     ),
            //   ),
            //   onTap: () {
            //     // AppInstalledCount();
            //     String? a = _linkMessage.toString();
            //     // ShareExtend.share("share text", a);
            //     ShareExtend.share(a, "text");
            //   },
            // ),
            // InkWell(
            //   child: ListTile(
            //     title: Text('Reward  $rewardCount'),
            //     leading: Icon(
            //       Icons.price_change,
            //       color: HexColor('6153D3'),
            //     ),
            //   ),
            //   onTap: () {},
            // ),
            InkWell(
              child: ListTile(
                title: Text('LogOut'),
                leading: Icon(
                  Icons.logout,
                  color: HexColor('6153D3'),
                ),
              ),
              onTap: () {
                logOut(context);
              },
            ),
            // InkWell(
            //   child: ListTile(
            //     title: Text('Notification Local'),
            //     leading: Icon(
            //       Icons.book,
            //       color: HexColor('6153D3'),
            //     ),
            //   ),
            //   ),
            //   onTap: () async {
            //
            //     await AwesomeNotifications().createNotification(
            //         content:NotificationContent(
            //             id:  1234,
            //             channelKey: 'image',
            //           title: 'Welcome to CloudyML',
            //           body: 'It\'s great to have you on CloudyML',
            //           bigPicture: 'asset://assets/HomeImage.png',
            //           largeIcon: 'asset://assets/logo2.png',
            //           notificationLayout: NotificationLayout.BigPicture,
            //           displayOnForeground: true
            //         )
            //     );
            //     // LocalNotificationService.showNotificationfromApp(
            //     //   title: 'Welcome to CloudyML',
            //     //   body: 'It\'s great to have you on CloudyML',
            //     //   payload: 'account'
            //     // );
            //   },
            // ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        height: 60,
        surfaceTintColor: Color.fromARGB(255, 173, 33, 243),
        // shadowColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        elevation: 1,
        // indicatorColor: Color.fromARGB(0, 22, 0, 58),
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
            openPaymentHistory = false;
          });
        },
        selectedIndex: _selectedIndex!,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(
              Icons.home,
              color: Color.fromARGB(189, 0, 34, 96),
              size: 28,
            ),
            icon: Icon(
              Icons.home_outlined,
              color: Color.fromARGB(189, 0, 34, 96),
            ),
            label: '',
          ),
          // NavigationDestination(
          //   selectedIcon: Icon(Icons.store,
          //       color: Color.fromARGB(189, 0, 34, 96), size: 28),
          //   icon: Icon(Icons.store_outlined,
          //       color: Color.fromARGB(189, 0, 34, 96)),
          //   label: '',
          // ),
          // NavigationDestination(
          //   selectedIcon: Icon(Icons.donut_large,
          //       color: Color.fromARGB(189, 0, 34, 96), size: 28),
          //   icon: Icon(Icons.donut_large_outlined,
          //       color: Color.fromARGB(189, 0, 34, 96)),
          //   label: '',
          // ),
          NavigationDestination(
            selectedIcon: Icon(Icons.chat_bubble_outline,
                color: Color.fromARGB(189, 0, 34, 96), size: 28),
            icon: Icon(
              Icons.chat_bubble_outline_sharp,
              color: Color.fromARGB(189, 0, 34, 96),
            ),
            label: '',
          ),
        ],
      ),
      // bottomNavigationBar: SizedBox(
      //   height: 70,
      //   child: BottomNavigationBar(
      //     iconSize: 24,
      //     backgroundColor: Colors.grey.shade50,
      //     elevation: 0,
      //     selectedItemColor: Colors.black,
      //     showSelectedLabels: false,
      //     showUnselectedLabels: false,
      //     onTap: (int index) {
      //       setState(() {
      //         _selectedIndex = index;
      //         openPaymentHistory = false;
      //       });
      //     },
      //     currentIndex: _selectedIndex!,
      //     items: [
      //       BottomNavigationBarItem(
      //         icon: Showcase(
      //           key: _three,
      //           description: 'Home Menu',
      //           disableDefaultTargetGestures: true,
      //           child: new Icon(Icons.home,
      //               color: Colors.black.withOpacity(0.5)),
      //         ),
      //         activeIcon: Showcase(
      //           key: _three,
      //           description: 'Home Menu',
      //           disableDefaultTargetGestures: true,
      //           child: Icon(
      //             Icons.home,
      //             color: Colors.black,
      //           ),
      //         ),
      //         label: '   ',
      //         //   icon: Showcase(
      //         //     key: _three,
      //         //     description: 'Home Menu',
      //         //     disableDefaultTargetGestures: true,
      //         //     child: new Icon(
      //         //       Icons.home_outlined,
      //         //       color: Colors.black.withOpacity(0.5),
      //         //     ),
      //         //   ),
      //         //   activeIcon: Showcase(
      //         //     key: _three,
      //         //     description: 'Home Menu',
      //         //     disableDefaultTargetGestures: true,
      //         //     child: Icon(
      //         //       Icons.home,
      //         //       color: Colors.black,
      //         //     ),
      //         //   ),
      //         //   label: ' ',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Showcase(
      //           key: _four,
      //           description: 'store',
      //           disableDefaultTargetGestures: true,
      //           child: new Icon(Icons.store_outlined,
      //               color: Colors.black.withOpacity(0.5)),
      //         ),
      //         activeIcon: Showcase(
      //           key: _four,
      //           description: 'store',
      //           disableDefaultTargetGestures: true,
      //           child: Icon(
      //             Icons.store,
      //             color: Colors.black,
      //           ),
      //         ),
      //         label: '   ',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Showcase(
      //           key: _five,
      //           description: 'status section',
      //           disableDefaultTargetGestures: true,
      //           child: new Icon(Icons.donut_large_outlined,
      //               color: Colors.black.withOpacity(0.5)),
      //         ),
      //         activeIcon: Showcase(
      //           key: _five,
      //           description: 'status section',
      //           disableDefaultTargetGestures: true,
      //           child: Icon(
      //             Icons.donut_large,
      //             color: Colors.black,
      //           ),
      //         ),
      //         label: '   ',
      //         // icon: storyBadge
      //         //     ? Badge(
      //         //       key: _five,
      //         //         child: Icon(Icons.donut_large_outlined,
      //         //             color: Colors.black.withOpacity(0.5)),
      //         //         shape: BadgeShape.circle,
      //         //         position: BadgePosition.topEnd(top: -5, end: -5),
      //         //         padding: EdgeInsets.all(3.5),
      //         //       )
      //         //     : Showcase(
      //         //         key: _five,
      //         //         description: 'Status Section',
      //         //         disableDefaultTargetGestures: true,
      //         //         child: new Icon(Icons.donut_large_outlined,
      //         //             color: Colors.black.withOpacity(0.5)),
      //         //       ),
      //         // activeIcon: Icon(
      //         //   Icons.donut_large,
      //         //   color: Colors.black,
      //         // ),
      //         // label: '   ',
      //       ),
      //       // BottomNavigationBarItem(
      //       //   icon: Showcase(
      //       //     key: _six,
      //       //     description: 'Downloaded videos here',
      //       //     disableDefaultTargetGestures: true,
      //       //     child: new Icon(Icons.download_for_offline_outlined,
      //       //         color: Colors.black.withOpacity(0.5)),
      //       //   ),
      //       //    activeIcon: Showcase(
      //       //     key: _six,
      //       //     description: 'Downloaded videos here',
      //       //     disableDefaultTargetGestures: true,
      //       //     child: Icon(
      //       //       Icons.download_for_offline,
      //       //       color: Colors.black,
      //       //     ),
      //       //   ),
      //       //   label: '   ',
      //       //   // icon: Showcase(
      //       //   //   key: _six,
      //       //   //   description: 'Downloaded videos here',
      //       //   //   disableDefaultTargetGestures: true,
      //       //   //   child: new Icon(Icons.download_for_offline_outlined,
      //       //   //       color: Colors.black.withOpacity(0.5)),
      //       //   // ),
      //       //   // activeIcon: Icon(

      //       //   //   Icons.download_for_offline,
      //       //   //   color: Colors.black,
      //       //   // ),
      //       //   // label: '   ',
      //       // ),
      //       BottomNavigationBarItem(
      //         // icon: Showcase(
      //         //   key: _seven,
      //         //   description: 'Chat with mentor',
      //         //   disableDefaultTargetGestures: true,
      //         //   child: new Icon(Icons.chat_bubble_outline_sharp,
      //         //       color: Colors.black.withOpacity(0.5)),
      //         // ),
      //         activeIcon: Icon(
      //           Icons.chat_bubble_outline_sharp,
      //           color: Colors.black,
      //         ),
      //         icon: Showcase(
      //           key: _seven,
      //           description: 'Chat with mentors',
      //           disableDefaultTargetGestures: true,
      //           child: Badge.Badge(
      //               child: Icon(Icons.chat_bubble_outline_sharp,
      //                   color: Colors.black.withOpacity(0.5)),
      //               badgeContent: Text("${count}",
      //                   style: TextStyle(
      //                       color: Colors.white, //badge font color
      //                       fontSize: 8 //badge font size
      //                       ))),
      //         ),
      //         label: '   ',
      //       ),
      //     ],
      //     type: BottomNavigationBarType.fixed,
      //   ),
      // ),
    );
  }
}

// StreamBuilder<QuerySnapshot>(
// stream: FirebaseFirestore.instance
//     .collection("Users")
// .snapshots(),
// builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
// if (!snapshot.hasData) return const SizedBox.shrink();
// return ListView.builder(
// itemCount: snapshot.data!.docs.length,
// itemBuilder: (BuildContext context, index) {
// DocumentSnapshot document =
// snapshot.data!.docs[index];
// Map<String, dynamic> map = snapshot.data!.docs[0]
//     .data() as Map<String, dynamic>;
// if (map["id"].toString() ==
// FirebaseAuth.instance.currentUser!.uid) {
// print('Printing map ${map}');
// return UserAccountsDrawerHeader(
// // accountEmail: userdetails!=null?Text(userdetails!['email']):Text(''),
// // accountName: userdetails!=null?Text(userdetails!['name']):Text(''),
// accountEmail: map['email'] != null ? Text(map['email']) : Text(' '),
// accountName: map['name'] != null ? Text(map['name']) : Text(' '),
// currentAccountPicture: GestureDetector(
// // onTap: (){
// //   Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountInfo()));
// // },
// child: CircleAvatar(
// backgroundColor: Colors.transparent,
// backgroundImage: NetworkImage(
// 'https://stratosphere.co.in/img/user.jpg'),
// ),
// ),
// decoration: BoxDecoration(
// color: HexColor('7B62DF'),
// ),
// );
// } else {
// return Container();
// }
// }
// );
// },
// ),

// // ignore_for_file: unused_local_variable

// import 'dart:async';
// import 'dart:convert';
// import 'package:badges/badges.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:badges/badges.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dataly_app/MyAccount/myaccount.dart';
// import 'package:dataly_app/Providers/UserProvider.dart';
// import 'package:dataly_app/aboutus.dart';
// import 'package:dataly_app/authentication/firebase_auth.dart';
// import 'package:dataly_app/combo/dropdown.dart';
// import 'package:dataly_app/models/course_details.dart';
// import 'package:is_first_run/is_first_run.dart';
// import 'package:showcaseview/showcaseview.dart';
// import 'catalogue_screen.dart';
// import 'global_variable.dart' as globals;
// import 'package:dataly_app/payments_history.dart';
// import 'package:dataly_app/my_Courses.dart';
// import 'package:dataly_app/homepage.dart';
// import 'package:dataly_app/offline/offline_videos.dart';
// import 'package:dataly_app/privacy_policy.dart';
// import 'package:dataly_app/screens/groups_list.dart';

// import 'package:dataly_app/screens/review.dart';
// import 'package:dataly_app/services/database_service.dart';
// import 'package:dataly_app/services/local_notificationservice.dart';
// import 'package:dataly_app/store.dart';
// import 'package:dataly_app/story/story_provider.dart';
// import 'package:dataly_app/story/story_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;

// import 'Services/code_generator.dart';
// import 'Services/deeplink_service.dart';
// import 'globals.dart';
// import 'models/referal_model.dart';
// import 'package:share_extend/share_extend.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final GlobalKey _one = GlobalKey();
//   final GlobalKey _two = GlobalKey();
//   final GlobalKey _three = GlobalKey();

//   final GlobalKey _four = GlobalKey();
//   final GlobalKey _five = GlobalKey();
//   final GlobalKey _six = GlobalKey();
//   final GlobalKey _seven = GlobalKey();
//   final GlobalKey _eight = GlobalKey();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   int? _selectedIndex = 0;
//   var authorizationToken;
//   var rewardCount = 0;
//   String? _linkMessage;
//   bool openPaymentHistory = false;
//   Map<String, dynamic>? userdetails = {};

//   List<String> titles = [
//     'Home',
//     'Store',
//     'Story',
//     'Offline Videos',
//     'Chat',
//   ];
//   var count = 0;

//   List<Widget> screens(){
//     return [
//         Home(one: _one,two: _two, three:  _eight,),
//         StoreScreen(),
//         StoryScreen(),
//         OfflinePage(),
//         GroupsList()
//     ];
//   }
//   @override
//   void initState() {
//     super.initState();

//     setShowCaseView();
//     insertToken();
//     // print('UID--${FirebaseAuth.instance.currentUser!.uid}');
//     getuserdetails();
//     // _getGroupListData();
//     checkrewardexpiry();
//     getgroupChatCountNew();

//     Provider.of<UserProvider>(context, listen: false).reloadUserModel();
//     if (storyTimer) {
//       //adding cron task for updating the status in every 5 minutes
//       //we can reduce the frequency later on
//       //run this timer only once after that it will run periodic
//       Timer.periodic(Duration(minutes: 5), (timer) {
//         Provider.of<StoryProvider>(context, listen: false).reloadStoryModel();
//       });
//       storyTimer = false;
//     }
//   }
//   setShowCaseView()async{
//     if(
//     await IsFirstRun.isFirstRun()){
//       WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback(
//             (_) => ShowCaseWidget.of(context).startShowCase([_one, _two, _three, _four, _five, _six, _seven, _eight]),
//       );
//     }
//   }

//   // getgroupChatCountNew() async {
//   //   try {
//   //     // var data = await FirebaseFirestore.instance
//   //     //     .collection("groups")
//   //     //     .where("groupChatCountNew",
//   //     //         arrayContains: FirebaseAuth.instance.currentUser!.uid)
//   //     //     .snapshots();
//   //     var items = <dynamic>[];

//   //     await FirebaseFirestore.instance
//   //         .collection("groups")
//   //         .orderBy("groupChatCountNew")
//   //         .where("groupChatCountNew")
//   //         .get()
//   //         .then((QuerySnapshot snapshot) {
//   //       snapshot.docs.forEach(
//   //         (f) => items.add(f.get("groupChatCountNew")),
//   //       );
//   //     });
//   //     print("sdifjoiejo${items}");
//   //     for (var i in items) {
//   //       try {
//   //         print(
//   //             "this is value:${FirebaseAuth.instance.currentUser!.uid.toString()} soseio  ${i["${FirebaseAuth.instance.currentUser!.uid.toString()}"]}");

//   //         if (i['${FirebaseAuth.instance.currentUser!.uid.toString()}'] !=
//   //             null) {
//   //           if (i['${FirebaseAuth.instance.currentUser!.uid.toString()}'] !=
//   //               0) {
//   //             count += 1;
//   //           }
//   //         }
//   //       } catch (e) {
//   //         print(e.toString());
//   //       }
//   //     }
//   //     print("value of count: ${count}");
//   //     setState(() {
//   //       count = count;
//   //       globals.chatcount = count;
//   //     });
//   //   } catch (e) {
//   //     print("this si ijeo${e.toString()}");
//   //   }

//     // var ele;
//     // data.forEach((element) {
//     //   print("this is element: ewe${element.docs.first.data()["groupChatCountNew"]}");
//     //   ele = element;
//     // });
//   }

//   // checkrewardexpiry() async {
//   //   var rewardvalidfrom;
//   //   var rewardexpireindays;
//   //   try {
//   //     await FirebaseFirestore.instance
//   //         .collection("Users")
//   //         .doc(FirebaseAuth.instance.currentUser!.uid)
//   //         .get()
//   //         .then((value) {
//   //       rewardvalidfrom = value.data()!['rewardvalidfrom'];
//   //     });
//   //     await FirebaseFirestore.instance
//   //         .collection("Controllers")
//   //         .doc("variables")
//   //         .get()
//   //         .then((value) {
//   //       rewardexpireindays = value.data()!['rewardexpireindays'];
//   //     });
//   //   } catch (e) {
//   //     print(e.toString());
//   //   }
//   //   if (rewardexpireindays == null) {
//   //     rewardexpireindays = 7;
//   //   }
//   //   if (rewardvalidfrom != null) {
//   //     var data = DateTime.now().difference(rewardvalidfrom.toDate());
//   //     if (data.inDays >= rewardexpireindays) {
//   //       await FirebaseFirestore.instance
//   //           .collection("Users")
//   //           .doc(FirebaseAuth.instance.currentUser!.uid)
//   //           .update({"reward": 0}).whenComplete(() {
//   //         print('success');
//   //       }).onError((error, stackTrace) => print(error));
//   //     }
//   //   }
//   // }

//   List<dynamic> listOfGroupListData = [];
//   String documentID = "";
//   _getGroupListData() async {
//     var headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer ${authorizationToken}'
//     };

//     try {
//       var response = await http.post(
//           Uri.parse(
//               "https://us-central1-cloudyml-app.cloudfunctions.net/Grouplist/groupList"),
//           headers: headers,
//           body: json.encode({"documentID": documentID}));
//       var responseData = await jsonDecode(response.body);
//       print(response.statusCode);
//       print(responseData["responseData"][0]["data"]["student_name"]);
//       if (response.statusCode == 200) {
//         documentID = responseData["responseData"]
//                 [responseData["responseData"].length - 1]["id"]
//             .toString();
//         listOfGroupListData.addAll(responseData["responseData"]);
//         print("added");
//         printWrapped("ggggggggggggggg${listOfGroupListData}");
//         print(listOfGroupListData.length);

//         for (var i = 0; i < listOfGroupListData.length; i++) {
//           try {
//             if (listOfGroupListData[i]['data']['groupChatCountNew']
//                     [FirebaseAuth.instance.currentUser!.uid] >
//                 0) {
//               setState(() {
//                 count += 1;
//               });
//             }
//           } catch (e) {
//             print(e);
//           }
//         }
//         print("this is count: ${count}");
//         globals.chatcount = count;
//         print(listOfGroupListData[0]['data']['time']);
//       } else {
//         print("Error in groupList");
//       }
//     } catch (err) {
//       print("GroupList error");
//       print(err);
//     }
//   }

//   void printWrapped(String text) {
//     final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
//     pattern.allMatches(text).forEach((match) => print(match.group(0)));
//   }

//   void insertToken() async {
//     print("insertToken");
//     final token = await FirebaseMessaging.instance.getToken();

//     await FirebaseFirestore.instance
//         .collection("Users")
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .update({"token": token});
//     final data = await FirebaseFirestore.instance
//         .collection("Users")
//         .doc(FirebaseAuth.instance.currentUser!.uid);
//     authorizationToken = await FirebaseAuth.instance.currentUser!.getIdToken();

//     final response = data.get().then((DocumentSnapshot doc) {
//       final data2 = doc.data() as Map<String, dynamic>;
//       print(data2);
//     });
//     print(response);
//     print("insertedToken");
//   }

//   void getuserdetails() async {
//     final deepLinkRepo = await DeepLinkService.instance;
//     var referralCode = await deepLinkRepo?.referrerCode.value;

//     print(
//         "sddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd $referralCode ddd");
//     await FirebaseFirestore.instance
//         .collection('Users')
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .get()
//         .then((value) async {
//       print(value.data());
//       print(FirebaseAuth.instance.currentUser!.uid);

//       try {
//         _linkMessage = await value.data()!['refer_link'];
//         rewardCount = await value.data()!['reward'];
//         setState(() {
//           rewardCount;
//         });
//       } catch (e) {
//         print(e);
//         _linkMessage = '';
//       }
//       print(_linkMessage);
//       print('1');
//       if (_linkMessage == '' || _linkMessage == null) {
//         print('2');
//         print(_linkMessage);
//         updateReferaldata();
//       } else {}
//       ;
//     });
//   }

//   void updateReferaldata() async {
//     try {
//       print('4');
//       final deepLinkRepo = await DeepLinkService.instance;
//       var referralCode = await deepLinkRepo?.referrerCode.value;
//       print(
//           "sddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd ${referralCode}");
//       final referCode = await CodeGenerator().generateCode('refer');
//       final referLink =
//           await DeepLinkService.instance?.createReferLink(referCode);
//       setState(() {
//         if (referralCode != '') {
//           rewardCount = 50;
//         } else {
//           rewardCount = 0;
//         }
//         _linkMessage = referLink;
//         print(_linkMessage);
//       });

//       await FirebaseFirestore.instance
//           .collection("Users")
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .update({
//         'refer_link': referLink,
//         'refer_code': referCode,
//         "referral_code": referralCode,
//         'reward': rewardCount,
//       }).whenComplete(() =>
//               print("send data to firebase uid: ${_auth.currentUser!.uid}"));

//       Future<ReferalModel> getReferrerUser(String referCode) async {
//         print("dokvsodpds ${referCode}");
//         final docSnapshots = await FirebaseFirestore.instance
//             .collection('Users')
//             .where('refer_code', isEqualTo: referCode)
//             .get();

//         final userSnapshot = docSnapshots.docs.first;
//         print("ssodjfiosdijofioew  ${userSnapshot['id']}");
//         print("ijvovodsivoidfio ${userSnapshot['id']}");
//         if (userSnapshot.exists) {
//           print(userSnapshot['id']);
//           await FirebaseFirestore.instance
//               .collection("Users")
//               .doc(userSnapshot['id'])
//               .update({
//             "rewardvalidfrom": DateTime.now(),
//             "reward": FieldValue.increment(50),
//           });
//           return ReferalModel.fromJson(userSnapshot.data());
//         } else {
//           return ReferalModel.empty();
//         }
//       }

//       Future<void> rewardUser(
//           String currentUserUID, String referrerCode) async {
//         try {
//           print("here it isdfosdjosij dfosijdoifjo");
//           print(referrerCode.toString().substring(0, 11));
//           print("here it isdfosdjosij jj");
//           if (referrerCode.toString().substring(0, 11) != "moneyreward") {
//             print("here it is dfosijdoifjo");
//             final referer = await getReferrerUser(referrerCode);
//             print("uniiiiiiiiiiiiiuuuuuuuuuuuuuuuu ${referer.id}");
//             // if (!checkIfUserAlreadyExist.exists) {
//             //   await FirebaseFirestore.instance
//             //       .collection('Users')
//             //       .doc(referer.id)
//             //       .collection('referrers')
//             //       .doc(currentUserUID)
//             //       .set({
//             //     "uid": currentUserUID,
//             //     "createdAt": DateTime.now(),
//             //   });
//             //   print("here fasaada isdfosdjosij dfosijdoifjo");
//             //   await FirebaseFirestore.instance
//             //       .collection('Users')
//             //       .doc(referer.id)
//             //       .update({
//             //     "reward": FieldValue.increment(50),
//             //     "rewardvalidfrom": DateTime.now()
//             //   });
//             // }
//             print("hesdsdsij dfosijdoifjo");
//           }
//         } catch (e) {
//           print("igerigjigjrigjirji:   ${e.toString()}");
//         }
//       }

//       if (referralCode != "") {
//         print("ttttttjosij dfosijdoifjo");
//         print("dsdsdsdew ${referralCode}");
//         print("here it rrr dfosijdoifjo");
//         await rewardUser(_auth.currentUser!.uid, referralCode!);
//       }
//       ;
//     } catch (e) {
//       print(
//           "................................................................................................................................${e}");
//     }
//   }

//   // void getuserdetails() async {
//   //   await FirebaseFirestore.instance
//   //       .collection('Users')
//   //       .doc(FirebaseAuth.instance.currentUser!.uid)
//   //       .get()
//   //       .then((value) {
//   //     print(value.data());
//   //     setState(() {
//   //       userdetails = value.data();
//   //     });
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final userprovider = Provider.of<UserProvider>(context);
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     bool storyBadge =
//         Provider.of<StoryProvider>(context, listen: true).storyBadge;
//     return Scaffold(
//       key: _scaffoldKey,
//       body: PageView.builder(
//           physics: NeverScrollableScrollPhysics(),
//           itemBuilder: (ctx, index) {
//             if (openPaymentHistory) {
//               return PaymentHistory();
//             } else {
//               return screens()[_selectedIndex!];
//             }
//           }),
//       drawer: Drawer(
//        child: ListView(
//           padding: EdgeInsets.only(top: 0),
//           children: [
//             UserAccountsDrawerHeader(
//               accountName: Text(
//                 userprovider.userModel?.name.toString() ?? 'Enter name',
//               ),
//               accountEmail: Text(
//                 userprovider.userModel?.email.toString() == ''
//                     ? userprovider.userModel?.mobile.toString() ?? ''
//                     : userprovider.userModel?.email.toString() ?? 'Enter email',
//               ),
//               currentAccountPicture: GestureDetector(
//                 onTap: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => MyAccountPage()));
//                 },
//                 child: CircleAvatar(
//                   foregroundColor: Colors.black,
//                   //foregroundImage: NetworkImage('https://stratosphere.co.in/img/user.jpg'),
//                   foregroundImage:
//                       NetworkImage(userprovider.userModel?.image ?? ''),
//                   backgroundColor: Colors.transparent,
//                   backgroundImage: CachedNetworkImageProvider(
//                     'https://stratosphere.co.in/img/user.jpg',
//                   ),
//                 ),
//               ),
//               decoration: BoxDecoration(
//                 color: HexColor('7B62DF'),
//               ),
//             ),
//             InkWell(
//               child: ListTile(
//                 title: Text('Home'),
//                 leading: Icon(
//                   Icons.home,
//                   color: HexColor('6153D3'),
//                 ),
//               ),
//               onTap: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => HomePage(),
//                   ),
//                 );
//               },
//             ),
//             InkWell(
//               child: ListTile(
//                 title: Text('My Account'),
//                 leading: Icon(
//                   Icons.person,
//                   color: HexColor('6153D3'),
//                 ),
//               ),
//               onTap: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => MyAccountPage()));
//               },
//             ),
//             InkWell(
//               child: ListTile(
//                 title: Text('My Courses'),
//                 leading: Icon(
//                   Icons.book,
//                   color: HexColor('6153D3'),
//                 ),
//               ),
//               onTap: () async {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => VideoPlayerApp(),
//                   ),
//                 );
//               },
//             ),
//             InkWell(
//               child: ListTile(
//                 title: Text('Reviews'),
//                 leading: Icon(
//                   Icons.book_online,
//                   color: HexColor('6153D3'),
//                 ),
//               ),
//               onTap: () async {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ReviewsScreen(),
//                   ),
//                 );
//               },
//             ),
//             InkWell(
//               onTap: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => PaymentHistory()));
//               },
//               child: ListTile(
//                 title: Text('Payment History'),
//                 leading: Icon(
//                   Icons.payment_rounded,
//                   color: HexColor('6153D3'),
//                 ),
//               ),
//             ),
//             Divider(
//               thickness: 2,
//             ),
//             InkWell(
//               onTap: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => PrivacyPolicy()));
//               },
//               child: ListTile(
//                 title: Text('Privacy policy'),
//                 leading: Icon(
//                   Icons.privacy_tip,
//                   color: HexColor('6153D3'),
//                 ),
//               ),
//             ),
//             InkWell(
//               child: ListTile(
//                 title: Text('About Us'),
//                 leading: Icon(
//                   Icons.info,
//                   color: HexColor('6153D3'),
//                 ),
//               ),
//               onTap: () async {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => AboutUs()));
//               },
//             ),
//             InkWell(
//               child: ListTile(
//                 title: Text('Share'),
//                 leading: Icon(
//                   Icons.share,
//                   color: HexColor('6153D3'),
//                 ),
//               ),
//               onTap: () {
//                 // AppInstalledCount();
//                 String? a = _linkMessage.toString();
//                 // ShareExtend.share("share text", a);
//                 ShareExtend.share(a, "text");
//               },
//             ),
//             InkWell(
//               child: ListTile(
//                 title: Text('Reward  $rewardCount'),
//                 leading: Icon(
//                   Icons.price_change,
//                   color: HexColor('6153D3'),
//                 ),
//               ),
//               onTap: () {},
//             ),
//             InkWell(
//               child: ListTile(
//                 title: Text('LogOut'),
//                 leading: Icon(
//                   Icons.logout,
//                   color: HexColor('6153D3'),
//                 ),
//               ),
//               onTap: () {
//                 logOut(context);
//               },
//             ),
//             // InkWell(
//             //   child: ListTile(
//             //     title: Text('Notification Local'),
//             //     leading: Icon(
//             //       Icons.book,
//             //       color: HexColor('6153D3'),
//             //     ),
//             //   ),
//             //   ),
//             //   onTap: () async {
//             //
//             //     await AwesomeNotifications().createNotification(
//             //         content:NotificationContent(
//             //             id:  1234,
//             //             channelKey: 'image',
//             //           title: 'Welcome to CloudyML',
//             //           body: 'It\'s great to have you on CloudyML',
//             //           bigPicture: 'asset://assets/HomeImage.png',
//             //           largeIcon: 'asset://assets/logo2.png',
//             //           notificationLayout: NotificationLayout.BigPicture,
//             //           displayOnForeground: true
//             //         )
//             //     );
//             //     // LocalNotificationService.showNotificationfromApp(
//             //     //   title: 'Welcome to CloudyML',
//             //     //   body: 'It\'s great to have you on CloudyML',
//             //     //   payload: 'account'
//             //     // );
//             //   },
//             // ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: SizedBox(
//         height: 70,
//         child: BottomNavigationBar(
//           iconSize: 24,
//           backgroundColor: Colors.grey.shade50,
//           elevation: 0,
//           selectedItemColor: Colors.black,
//           showSelectedLabels: false,
//           showUnselectedLabels: false,
//           onTap: (int index) {
//             setState(() {
//               _selectedIndex = index;
//               openPaymentHistory = false;
//             });
//           },
//           currentIndex: _selectedIndex!,
//           items: [
//             BottomNavigationBarItem(
//               icon: Showcase(
//                 key: _three,
//                 description: 'Home Menu',
//                 disableDefaultTargetGestures: true,
//                 child: new Icon(
//                   Icons.home_outlined,
//                   color: Colors.black.withOpacity(0.5),
//                 ),
//               ),
//               activeIcon: Showcase(
//                 key: _three,
//                 description: 'Home Menu',
//                 disableDefaultTargetGestures: true,
//                 child: Icon(
//                   Icons.home,
//                   color: Colors.black,
//                 ),
//               ),
//               label: ' ',
//             ),
//             BottomNavigationBarItem(
//               icon: Showcase(
//                 key: _four,
//                 description: 'store',
//                 disableDefaultTargetGestures: true,
//                 child: new Icon(Icons.store_outlined,
//                     color: Colors.black.withOpacity(0.5)),
//               ),
//                activeIcon: Showcase(
//                 key: _four,
//                 description: 'store',
//                 disableDefaultTargetGestures: true,
//                 child: Icon(
//                   Icons.store,
//                   color: Colors.black,
//                 ),
//               ),
//               label: '   ',
//             ),
//             BottomNavigationBarItem(
//               icon: storyBadge
//                   ? Badge(
//                       child: Icon(Icons.donut_large_outlined,
//                           color: Colors.black.withOpacity(0.5)),
//                       shape: BadgeShape.circle,
//                       position: BadgePosition.topEnd(top: -5, end: -5),
//                       padding: EdgeInsets.all(3.5),
//                     )
//                   : Showcase(
//                 key: _five,
//                 description: 'Status Section',
//                 disableDefaultTargetGestures: true,
//                     child: new Icon(Icons.donut_large_outlined,
//                         color: Colors.black.withOpacity(0.5)),
//                   ),
//               activeIcon: Icon(
//                 Icons.donut_large,
//                 color: Colors.black,
//               ),
//               label: '   ',
//             ),
//             BottomNavigationBarItem(
//               icon: Showcase(
//                 key: _six,
//                 description: 'Downloaded videos here',
//                 disableDefaultTargetGestures: true,
//                 child: new Icon(Icons.download_for_offline_outlined,
//                     color: Colors.black.withOpacity(0.5)),
//               ),
//               activeIcon: Icon(
//                 Icons.download_for_offline,
//                 color: Colors.black,
//               ),
//               label: '   ',
//             ),
//             BottomNavigationBarItem(
//               // icon: Showcase(
//               //   key: _seven,
//               //   description: 'Chat with mentor',
//               //   disableDefaultTargetGestures: true,
//               //   child: new Icon(Icons.chat_bubble_outline_sharp,
//               //       color: Colors.black.withOpacity(0.5)),
//               // ),
//               activeIcon: Icon(
//                 Icons.chat_bubble_outline_sharp,
//                 color: Colors.black,
//               ),
//               icon: Badge(
//                 key: _seven,
//                   child: Icon(Icons.chat_bubble_outline_sharp,
//                       color: Colors.black.withOpacity(0.5)),
//                   badgeContent: Text("${count}",
//                       style: TextStyle(
//                           color: Colors.white, //badge font color
//                           fontSize: 8 //badge font size
//                           ))),
//               label: '   ',
//             ),
//             // icon: new Icon(Icons.chat_bubble_outline_sharp,
//             //     color: Colors.black.withOpacity(0.5)),
//             // activeIcon: Icon(
//             //   Icons.chat_bubble_outline_sharp,
//             //   color: Colors.black,
//             // ),
//           ],
//           type: BottomNavigationBarType.fixed,
//         ),
//       ),
//     );
//   }
// }

// // StreamBuilder<QuerySnapshot>(
// // stream: FirebaseFirestore.instance
// //     .collection("Users")
// // .snapshots(),
// // builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
// // if (!snapshot.hasData) return const SizedBox.shrink();
// // return ListView.builder(
// // itemCount: snapshot.data!.docs.length,
// // itemBuilder: (BuildContext context, index) {
// // DocumentSnapshot document =
// // snapshot.data!.docs[index];
// // Map<String, dynamic> map = snapshot.data!.docs[0]
// //     .data() as Map<String, dynamic>;
// // if (map["id"].toString() ==
// // FirebaseAuth.instance.currentUser!.uid) {
// // print('Printing map ${map}');
// // return UserAccountsDrawerHeader(
// // // accountEmail: userdetails!=null?Text(userdetails!['email']):Text(''),
// // // accountName: userdetails!=null?Text(userdetails!['name']):Text(''),
// // accountEmail: map['email'] != null ? Text(map['email']) : Text(' '),
// // accountName: map['name'] != null ? Text(map['name']) : Text(' '),
// // currentAccountPicture: GestureDetector(
// // // onTap: (){
// // //   Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountInfo()));
// // // },
// // child: CircleAvatar(
// // backgroundColor: Colors.transparent,
// // backgroundImage: NetworkImage(
// // 'https://stratosphere.co.in/img/user.jpg'),
// // ),
// // ),
// // decoration: BoxDecoration(
// // color: HexColor('7B62DF'),
// // ),
// // );
// // } else {
// // return Container();
// // }
// // }
// // );
// // },
// // ),
