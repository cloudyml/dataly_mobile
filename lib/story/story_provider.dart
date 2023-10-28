// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloudyml_app2/quizStory/model/option.dart';
// import 'package:cloudyml_app2/story/story_constants.dart';
// import 'package:cloudyml_app2/story/story_db.dart';
// import 'package:cloudyml_app2/story/story_view_customised.dart';
// import 'package:cloudyml_app2/story/story_item_text.dart';
// import 'package:flutter/material.dart';
// import 'package:story_view/controller/story_controller.dart';
// import '../api/firebase_api.dart';
// import '../models/firebase_story.dart';
// import '../models/quiz_model.dart';
// import '../models/story_model.dart';
// import '../quizStory/model/question.dart';
// import '../quizStory/quiz_db.dart';
// import '../utils/utils.dart';

// class StoryProvider extends ChangeNotifier {
//   static final storyController = StoryController();
//   List<StoryItem> _storyItemsQnA = [];
//   bool isLoading = true;
//   bool storyBadge = false;
//   bool qNaBadge = false;
//   bool postNreelBadge = false;
//   List<StoryItem> get storyItemsQnA => _storyItemsQnA;
//   late StoryDatabaseHelper _dbhelper;
//   late QuizDatabaseHelper quizHelper;

//   Map<String, StoryModel> _dbStories = {};

//   Map<String, StoryModel> get dbStories => _dbStories;
//   List<StoryItem> _storyItemsPostNReels = [];

//   List<StoryItem> get storyItemsPostNReels => _storyItemsPostNReels;
//   static const String delimiter = "--";
//   List<Question> _quizData = [];

//   List<Question> get quizData => _quizData;

//   StoryProvider.initialize() {
//     _dbhelper = StoryDatabaseHelper.getInstance();
//     quizHelper = QuizDatabaseHelper.getInstance();
//     initialQuizData();
//     initializeStoryData();
//   }

//   Future<void> initialQuizData() async {
//     Map<String,QuizModel> offlineQuiz = {};
//     Option? selectedOption = null;
//     offlineQuiz = await quizHelper.getQuiz();
//     var firestore = FirebaseFirestore.instance;
//     var quizData = firestore.collection('Quiz').get();
//     await quizData.then((value) => value.docs.forEach((element) async {
//       List<Option> options = [];
//       int idx = 1;
//       await element.get("choice").forEach((key, value) {
//         options.add(Option(text: key, code: idx.toString(), isCorrect: value));
//           if (offlineQuiz.isNotEmpty && offlineQuiz.containsKey(element.id) && offlineQuiz[element.id]!.option == idx.toString()) {
//               selectedOption = options.last;
//         }
//         idx++;
//       });
//       _quizData.add(Question(text: element.get("text"), options: options, solution: element.get("solution"),
//           selectedOption: selectedOption,
//           isLocked: (selectedOption != null ? true : false),id: element.id));
//     }));
//   }

//   Future<void> initializeStoryData() async {
//     Map<String, String> viewCountMap = {};
//     //GET Stories from Local DB
//     _dbStories = await _dbhelper.getStory();
//     await getStoryViewCount(viewCountMap);
//     //GET QNA STATUS DATA
//     await getStoryData(storyController, _storyItemsQnA, QnA_PATH, STORY_BUCKET,
//         QNA_TEXT_STORY_DOCUMENT, "QnA", viewCountMap);
//     if(storyBadge) {
//       qNaBadge = true;
//     }
//     //GET POSTANDREELS DATA
//     await getStoryData(
//         storyController,
//         _storyItemsPostNReels,
//         POST_N_REELS_PATH,
//         STORY_BUCKET,
//         POST_N_REELS_TEXT_STORY_DOCUMENT,
//         "PostNReels",
//         viewCountMap);
//     if(storyBadge) {
//       postNreelBadge = true;
//     }
//     isLoading = false;
//     notifyListeners();
//   }

//   Duration getTimeDurationFromFileName(String name) {
//     String time = name.substring(name.lastIndexOf('_') + 1, name.lastIndexOf('.'));
//     return (time.isNotEmpty && int.tryParse(time) != null)
//         ? Duration(seconds: int.parse(time))
//         : Duration(seconds: 5);
//   }

//   Future<void> getStoryData(
//       final controller,
//       List<StoryItem> storyItems,
//       String path,
//       String bucket,
//       String textStatusDocument,
//       String storyContext,
//       Map<String, String> viewCountMap) async {
//     List<dynamic> futureList = [];
//     futureList
//         .addAll(await FirebaseApi.listAllFilesWithDiffBucket(path, bucket));
//     /*futureList.removeWhere(
//           (file) =>
//       file.timeCreated.isBefore(DateTime.now().subtract(Duration(hours: 24))));*/
//     await getTextStory(textStatusDocument, futureList);
//     futureList.sort(storyComparator);
//     for (var file in futureList) {
//       if (file is FirebaseStory) {
//         //it means it's a new story which is not yet viewed
//         if(viewCountMap[storyContext + delimiter + file.name] == null || viewCountMap[storyContext + delimiter + file.name]!.isEmpty) {
//           storyBadge = true;
//         }
//         if (REGEX_IMAGE.hasMatch(file.name)) {
//           Duration duration = getTimeDurationFromFileName(file.name);
//           storyItems.add(StoryItem.pageImage(
//               url: file.url,
//               controller: controller,
//               imageFit: BoxFit.contain,
//               duration: duration,
//               name: storyContext + delimiter + file.name,
//               viewedCount: viewCountMap[storyContext + delimiter + file.name]));
//         } else {
//           Duration duration = getTimeDurationFromFileName(file.name);
//           storyItems.add(StoryItem.pageVideo(file.url,
//               controller: controller,
//               duration: duration,
//               name: storyContext + delimiter + file.name,
//               viewedCount: viewCountMap[storyContext + delimiter + file.name]));
//         }
//       } else {
//         if(viewCountMap[textStatusDocument + delimiter + file.get('prefix')] == null || viewCountMap[textStatusDocument + delimiter + file.get('prefix')]!.isEmpty) {
//           storyBadge = true;
//         }
//         storyItems.add(StoryItemText.text(
//             prefix: file.get('prefix'),
//             backgroundColor: HexColor.fromHex(file.get('bg_color')),
//             textStyle: TextStyle(
//                 fontSize: 24, color: HexColor.fromHex(file.get('text_color'))),
//             clickableText: file.get('clickable_text'),
//             link: file.get('link'),
//             suffix: file.get('suffix'),
//             name: textStatusDocument + delimiter + file.get('prefix'),
//             viewedCount: viewCountMap[textStatusDocument + delimiter + file.get('prefix')]));
//       }
//     }
//   }

//   int storyComparator(a, b) {
//     if (a is FirebaseStory && b is FirebaseStory) {
//       return a.timeCreated.compareTo(b.timeCreated);
//     }
//     if (a is QueryDocumentSnapshot && b is QueryDocumentSnapshot) {
//       return a.get('create_date').compareTo(b.get('create_date'));
//     }
//     if (a is FirebaseStory && b is QueryDocumentSnapshot) {
//       return a.timeCreated.compareTo(b.get('create_date').toDate());
//     }
//     if (a is QueryDocumentSnapshot && b is FirebaseStory) {
//       return a.get('create_date').toDate().compareTo(b.timeCreated);
//     }
//     return 0;
//   }

//   Future<void> getTextStory(String textStatusDocument, futureList) async {
//     if (textStatusDocument.isNotEmpty) {
//       final Future<QuerySnapshot<Map<String, dynamic>>> textStatus =
//           FirebaseFirestore.instance
//               .collection(textStatusDocument)
//               .where('expiry_date', isGreaterThanOrEqualTo: DateTime.now())
//               .get();
//       await textStatus.then((value) => {futureList.addAll(value.docs)});
//     }
//   }

//   Future<void> getStoryViewCount(Map<String, String> viewCountMap) async {
//     var firestore = FirebaseFirestore.instance;
//     var storyViewedData = firestore.collection('StoryViewCount').get();
//     await storyViewedData.then((value) => value.docs!.forEach((element) async {
//           await viewCountMap.putIfAbsent(
//               element.id, () => element.get("view_count").toString());
//         }));
//   }
//   Future<void> reloadStoryModel() async {
//     _storyItemsPostNReels = [];
//     _storyItemsQnA = [];
//     storyBadge = false;
//     postNreelBadge = false;
//     qNaBadge = false;
//     _quizData = [];
//     await initializeStoryData();
//   }

// }
