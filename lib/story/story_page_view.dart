// import 'package:auto_orientation/auto_orientation.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dataly_app/models/story_model.dart';
// import 'package:dataly_app/story/story_db.dart';
// import 'package:dataly_app/story/story_provider.dart';
// import 'package:dataly_app/story/story_view_customised.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// const String delimiter = "--";

// class StoryPageView extends StatefulWidget {
//   final dynamic controller;
//   final List<StoryItem> storyItems;
//   final Map<String, StoryModel> dbStories;

//   StoryPageView({required this.storyItems, required this.controller, required this.dbStories});

//   @override
//   _StoryPageViewState createState() => _StoryPageViewState();
// }

// class _StoryPageViewState extends State<StoryPageView> {
//    late StoryDatabaseHelper _dbhelper ;
//    late FirebaseFirestore _firestore ;

//   Future<void> getDbStories() async {
//     _dbhelper = StoryDatabaseHelper.getInstance();
//     _dbhelper.deleteStories();
//     setState(() {});
//   }

//   Future<void> updateOrInsertStoryById(String id) async {
//       var doc = await _firestore.collection('StoryViewCount').doc(id).get();
//       //if exist then update the count
//       if(doc.exists) {
//         int currentCount = doc.get("view_count");
//         _firestore.collection('StoryViewCount').doc(id).update({"view_count":currentCount + 1});
//       } else {
//         _firestore.collection('StoryViewCount').doc(id).set({"view_count":1,
//           "context":id.substring(0,id.indexOf(delimiter)),
//           "id":id.substring(id.indexOf(delimiter) + 1),
//           "create_date": DateTime.now()});
//       }
//   }


//   @override
//   void initState() {
//     AutoOrientation.portraitUpMode();
//     getDbStories();
//     _firestore=FirebaseFirestore.instance;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Provider.of<StoryProvider>(context,listen: false).reloadStoryModel();
//     return Material(
//         child: widget.storyItems.isNotEmpty
//             ? StoryView(
//                 storyItems: widget.storyItems,
//                 controller: widget.controller,
//                 inline: false,
//                 repeat: false,
//                 onComplete: () => Navigator.pop(context),
//                 onStoryShow: (item) {
//                   //check if item is already viewed
//                   //if not then increase the count in firebase
//                   //and store it in local db
//                   if(widget.dbStories[item.uniqueKey] == null) {
//                     _dbhelper.insertStory(StoryModel(story:item.uniqueKey,isViewed: 1));
//                     widget.dbStories.putIfAbsent(item.uniqueKey, () => StoryModel(story:item.uniqueKey,isViewed: 1));
//                     updateOrInsertStoryById(item.uniqueKey);
//                   }
//                 },
//               )
//             : Stack(children: [
//                 SafeArea(
//                   child: Container(
//                     padding: EdgeInsets.only(
//                       top: 20.0,
//                       left: 5.0,
//                     ),
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Icon(
//                         Icons.arrow_back,
//                         color: Colors.black,
//                         size: 35.0,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Center(
//                   child: Text(
//                     'No stories to watch',
//                     style: TextStyle(
//                         fontFamily: 'Medium',
//                         fontSize: 20,
//                         color: Colors.black.withOpacity(0.4)),
//                   ),
//                 ),
//               ]));
//   }
// }
