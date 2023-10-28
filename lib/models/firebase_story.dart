import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStory {
  final Reference ref;
  final String name;
  final String url;
  final DateTime timeCreated;

  FirebaseStory({
    required this.ref,
    required this.name,
    required this.url,
    required this.timeCreated,
  });
}
