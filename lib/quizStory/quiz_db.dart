// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';import '../models/quiz_model.dart';


// class QuizDatabaseHelper {

//   final String TABLE_NAME = 'quiz_offline';
//   static final instance = QuizDatabaseHelper();

//   Future<Database> database() async {
//     return openDatabase(
//       join(await getDatabasesPath(), '$TABLE_NAME.db'),
//       onCreate: (db, version) async {
//         await db.execute(
//             "CREATE TABLE $TABLE_NAME (id TEXT PRIMARY KEY, option INTEGER, isAnswered INTEGER, timestamp DATETIME DEFAULT CURRENT_TIMESTAMP )");
//         //return db;
//       },
//       version: 1,
//     );
//   }

//   Future<int> insertQuiz(QuizModel quiz) async {
//     int taskId = 0;
//     Database _db = await database();
//     await _db
//         .insert(TABLE_NAME, quiz.toMap(),
//         conflictAlgorithm: ConflictAlgorithm.replace)
//         .then((value) {
//       taskId = value;
//     });
//     return taskId;
//   }

//   Future<Map<String,QuizModel>> getQuiz() async {
//     Database _db = await database();
//     List<Map<String, dynamic>> taskMap = await _db.query(TABLE_NAME,orderBy: "timestamp desc");
//     return taskMap.asMap().map((key, value) {
//       return MapEntry(value['id'], QuizModel(
//         id: value['id'],
//         isAnswered: int.tryParse(value['isAnswered']!.toString()),
//         option: value['option'].toString(),
//       ));
//     }
//     );
//   }

//   Future<int> deleteQuiz() async{
//     Database _db = await database();
//     int isSuccess = await _db.delete(TABLE_NAME);
//     return isSuccess;
//   }

//   Future<void> updateStory(int id,int option) async{
//     Database _db = await database();
//     _db.execute("UPDATE $TABLE_NAME SET isAnswered = 1, option = (?)  where id = (?)",[option,id]);
//   }

//   static QuizDatabaseHelper getInstance() {
//     return instance;
//   }
// }
