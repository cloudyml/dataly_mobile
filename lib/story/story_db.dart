// import 'package:cloudyml_app2/models/offline_model.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// import '../models/story_model.dart';

// class StoryDatabaseHelper {

//   final String TABLE_NAME = 'story_offline';
//   static final instance = StoryDatabaseHelper();

//   Future<Database> database() async {
//     return openDatabase(
//       join(await getDatabasesPath(), 'story_offline.db'),
//       onCreate: (db, version) async {
//         await db.execute(
//             "CREATE TABLE $TABLE_NAME (id INTEGER PRIMARY KEY AUTOINCREMENT, story TEXT, isViewed INTEGER,path TEXT, timestamp DATETIME DEFAULT CURRENT_TIMESTAMP )");
//         //return db;
//       },
//       version: 1,
//     );
//   }

//   Future<int> insertStory(StoryModel story) async {
//     int taskId = 0;
//     Database _db = await database();
//     await _db
//         .insert(TABLE_NAME, story.toMap(),
//         conflictAlgorithm: ConflictAlgorithm.replace)
//         .then((value) {
//       taskId = value;
//     });
//     return taskId;
//   }

//   Future<Map<String,StoryModel>> getStory() async {
//     Database _db = await database();
//     List<Map<String, dynamic>> taskMap = await _db.query(TABLE_NAME,orderBy: "timestamp desc");
//     return taskMap.asMap().map((key, value) {
//         return MapEntry(value['story'], StoryModel(
//           id: value['id'],
//           isViewed: value['isViewed'],
//           story: value['story'],
//           path: value['path'],
//         ));
//     }
//     );
//   }

//   Future<int> deleteStories() async{
//     Database _db = await database();
//     int isSuccess = await _db.delete(TABLE_NAME,where: 'timestamp < (?)',whereArgs: [DateTime.now().subtract(new Duration(days: 2)).millisecondsSinceEpoch]);
//     return isSuccess;
//   }

//   Future<void> updateStory(int id) async{
//     Database _db = await database();
//     _db.execute("UPDATE $TABLE_NAME SET isViewed = 1 where id = (?)",[id]);
//   }

//   static StoryDatabaseHelper getInstance() {
//     return instance;
//   }
// }
