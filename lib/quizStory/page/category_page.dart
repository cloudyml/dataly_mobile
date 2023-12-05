// import 'package:dataly_app/homepage.dart';
// import 'package:flutter/material.dart';
// import '../../models/quiz_model.dart';
// import '../model/category.dart';
// import '../model/option.dart';
// import '../model/question.dart';
// import '../quiz_db.dart';
// import '../widget/questions_widget.dart';
// import 'package:dataly_app/home.dart';

// class CategoryPage extends StatefulWidget {
//   final Category category;

//   const CategoryPage({required this.category});

//   @override
//   _CategoryPageState createState() => _CategoryPageState();
// }

// class _CategoryPageState extends State<CategoryPage> {
//   late PageController controller;
//   late Question question;
//   late QuizDatabaseHelper quizHelper;

//   @override
//   void initState() {
//     super.initState();
//     controller = PageController();
//     if(widget.category.questions.isNotEmpty) {
//       question = widget.category.questions!.first;
//     }
//     quizHelper = QuizDatabaseHelper.getInstance();
//   }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//     // appBar: AppBar(),
//         body:
//             QuestionsWidget(
//               category: widget.category,
//               controller: controller,
//               onChangedPage: (index) => nextQuestion(index: index),
//               onClickedOption: selectOption,
//             ),
         
//       );

//   void selectOption(Option option) {
//     if (question.isLocked) {
//       return;
//     } else {
//       setState(() {
//         question.isLocked = true;
//         question.selectedOption = option;
//         quizHelper.insertQuiz(QuizModel(isAnswered: 1,option: option.code,id: question.id));
//       });
//     }
//   }

//   void nextQuestion({required int index}) {
//     final nextPage = controller.page! + 1;
//     final indexPage = index ?? nextPage.toInt();

//     setState(() {
//       question = widget.category.questions[indexPage];
//     });
//   }
// }
