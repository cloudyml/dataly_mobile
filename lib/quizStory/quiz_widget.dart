// import 'package:cloudyml_app2/quizStory/model/question.dart';
// import 'package:cloudyml_app2/quizStory/page/category_page.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:provider/provider.dart';
// import '../story/story_provider.dart';
// import 'model/category.dart';
// import 'quiz_constants.dart';

// class QuizWidget extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//     bool isNew = false;
//     // List<Question> questions = Provider.of<StoryProvider>(context,listen: true).quizData;
//     return InkWell(
//       child: Container(
//         child: Row(
//           children: [
//             SizedBox(
//               height: QUIZ_HEIGHT,
//               child: CircleAvatar(
//                 radius: QUIZ_BORDER_RADIUS,
//                 backgroundColor: isNew ? Colors.greenAccent : Colors.grey,
//                 child: CircleAvatar(
//                   backgroundImage: NetworkImage(QUIZ_ASSET_IMAGE_URL),
//                   radius: QUIZ_IMAGE_RADIUS,
//                 ),
//               ),
//             ),
//             SizedBox(width: 10),
//             Text(
//               QUIZ_TITLE,
//               style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                   fontSize: 20),
//             )
//           ],
//         ),
//       ),
//       onTap: () => {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => CategoryPage(
//                 category: Category(
//                 questions: questions,
//                 categoryName: 'Quiz',
//                 imageUrl: 'assets/quiz.jpg',
//                 backgroundColor: Colors.blue,
//                 icon: FontAwesomeIcons.rocket,
//                 description: 'Quiz Time',
//               ),),
//             ))
//       },
//     );
//   }
// }
