// import 'package:dataly_app/quizStory/quiz_widget.dart';
// import 'package:dataly_app/story/story_constants.dart';
// import 'package:dataly_app/story/story_provider.dart';
// import 'package:dataly_app/story/story_view_customised.dart';
// import 'package:dataly_app/story/story_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:loading_animations/loading_animations.dart';
// import 'package:provider/provider.dart';
// import 'package:story_view/controller/story_controller.dart';

// import 'package:dataly_app/globals.dart';
// import 'package:dataly_app/home.dart';

// import '../models/story_model.dart';
// import '../quizStory/model/question.dart';

// class StoryScreen extends StatefulWidget {

//   @override
//   _StoryScreenState createState() => _StoryScreenState();
// }
// class _StoryScreenState extends State<StoryScreen> {

//   late final StoryController storyController;

//   @override
//   void initState() {
//     storyController = StoryProvider.storyController;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     var verticalScale = screenHeight / mockUpHeight;
//     List<StoryItem> storyItemsQnA = Provider.of<StoryProvider>(context,listen: true).storyItemsQnA;
//     List<StoryItem> storyItemsPostNReels = Provider.of<StoryProvider>(context,listen: true).storyItemsPostNReels;
//     Map<String, StoryModel> dbStories = Provider.of<StoryProvider>(context,listen: true).dbStories;
//     bool isLoading = Provider.of<StoryProvider>(context,listen: false).isLoading;
//     bool qNaNew = Provider.of<StoryProvider>(context,listen: true).qNaBadge;
//     bool postNReelsNew = Provider.of<StoryProvider>(context,listen: true).postNreelBadge;
//     return  isLoading ? LoadingFlipping.circle(
//       backgroundColor: Colors.white,
//     ) : Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.white,
//         toolbarHeight: 150 * verticalScale,
//         centerTitle: true,
//         title: Row(children: [
//           InkWell(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => HomePage()),
//               );
//             },
//             child: Icon(
//               Icons.arrow_back,
//               color: Colors.white,
//               size: 40.0,
//             ),
//           ),
//           SizedBox(width: 15),
//           Text(
//             'Status Section',
//             style: TextStyle(
//               color: Color.fromRGBO(255, 255, 255, 1),
//               fontFamily: 'Poppins',
//               letterSpacing: 2,
//               fontWeight: FontWeight.bold,
//               height: 1,
//               fontSize: 30.0,
//             ),
//           ),
//         ]),
//         flexibleSpace: FlexibleSpaceBar(
//           background: Container(
//             color: Color.fromRGBO(122, 98, 222, 1),
//           ),
//         ),
//       ),
//       body: Container(
//         child: ListView(
//           padding: EdgeInsets.only(left: 20, top: 30),
//           children: <Widget>[
//             StoryWidget(
//                 assetImageUrl: QnA_ASSET_IMAGE_URL,
//                 title: QnA_TITLE,
//                 controller: storyController,
//                 storyItems: storyItemsQnA,
//                 dbStories: dbStories,
//                 isNew: qNaNew,
//                 ),
//             StoryWidget(
//                 assetImageUrl: POST_N_REELS_ASSET_IMAGE_URL,
//                 title: POST_N_REELS_TITLE,
//                 controller: storyController,
//                 storyItems: storyItemsPostNReels,
//                 dbStories: dbStories,
//                 isNew: postNReelsNew,
//             ),
//             QuizWidget(),
//           ],
//         ),
//       ),
//     );
//   }
// }
