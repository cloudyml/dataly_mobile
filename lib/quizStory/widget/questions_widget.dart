// import 'package:flutter/material.dart';
// import '../model/category.dart';
// import '../model/option.dart';
// import '../model/question.dart';
// import '../page/options_widget.dart';

// class QuestionsWidget extends StatelessWidget {
//   final Category category;
//   final PageController controller;
//   final ValueChanged<int> onChangedPage;
//   final ValueChanged<Option> onClickedOption;

//   const QuestionsWidget({
//     required this.category,
//     required this.controller,
//     required this.onChangedPage,
//     required this.onClickedOption,
//   });

//   @override
//   Widget build(BuildContext context) => PageView.builder(
//         onPageChanged: onChangedPage,
//         controller: controller,
//         itemCount: category.questions.length,
//         itemBuilder: (context, index) {
//           final question = category.questions[index];

//           return buildQuestion(question: question);
//         },
//       );

//   Widget buildQuestion({
//     required Question question,
//   }) =>
//       SafeArea(
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 32),
//               Text(
//                 question.text,
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 'Choose your answer from below',
//                 style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
//               ),
//               SizedBox(height: 32),
//               Expanded(
//                 child: OptionsWidget(
//                   question: question,
//                   onClickedOption: onClickedOption,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
// }
