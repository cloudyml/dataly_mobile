// import 'package:cloudyml_app2/story/story_constants.dart';
// import 'package:cloudyml_app2/story/story_page_view.dart';
// import 'package:cloudyml_app2/story/story_view_customised.dart';
// import 'package:flutter/material.dart';

// import '../models/story_model.dart';

// class StoryWidget extends StatelessWidget {
//   final String assetImageUrl;
//   final String title;
//   final controller;
//   final List<StoryItem> storyItems;
//   final Map<String, StoryModel> dbStories;
//   final bool isNew;

//   const StoryWidget(
//       {Key? key,
//       required this.assetImageUrl,
//       required this.title,
//       required this.controller,
//       required this.storyItems, required this.dbStories, required this.isNew})
//       : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       child: Container(
//         child: Row(
//           children: [
//             SizedBox(
//               height: STORY_HEIGHT,
//               child: CircleAvatar(
//               radius: STORY_BORDER_RADIUS,
//               backgroundColor: isNew ? Colors.greenAccent : Colors.grey,
//               child: CircleAvatar(
//                 backgroundImage: NetworkImage(assetImageUrl),
//                 radius: STORY_IMAGE_RADIUS,
//               ),
//             ),
//             ),
//             SizedBox(width: 10),
//             Text(
//               title,
//               style:
//                   TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 20),
//             )
//           ],
//         ),
//       ),
//       onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => StoryPageView(
//                     controller: controller,
//                     storyItems: storyItems,
//                     dbStories: dbStories,
//                   ))),
//     );
//   }
// }
