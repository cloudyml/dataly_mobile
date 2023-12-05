import 'dart:io';

import 'package:dataly_app/models/firebase_file.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

import 'package:dataly_app/models/firebase_story.dart';

class FirebaseApi {
  static Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
      Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());

  static Future<List<FirebaseFile>> listAll(String path) async {
    final ref = FirebaseStorage.instance.ref(path);
    final result = await ref.listAll();

    final urls = await _getDownloadLinks(result.items);

    return urls
        .asMap()
        .map((index, url) {
          final ref = result.items[index];
          final name = ref.name;
          final file = FirebaseFile(ref: ref, name: name, url: url);

          return MapEntry(index, file);
        })
        .values
        .toList();
  }

  static Future downloadFile(Reference ref) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${ref.name}');

    await ref.writeToFile(file);
  }
  static FirebaseStorage getFirebaseInstanceOtherThanDefault(String bucketName) {
    final storage = FirebaseStorage.instanceFor(bucket: bucketName);
    return storage;
  }

  static Future<List<FirebaseStory>> listAllFilesWithDiffBucket(String path,String bucketName) async {
    final storage = getFirebaseInstanceOtherThanDefault(bucketName);
    final ref = storage.ref(path);
    final result = await ref.listAll();
    var urls = await _getDownloadLinks(result.items);
    final List<DateTime> resultTimestamp = [];
    await Future.forEach(result.items,(Reference element) async {
      await element.getMetadata().then((value) => resultTimestamp.add(value.timeCreated!));
    });
    return urls
        .asMap()
        .map((index, url) {
      final ref = result.items[index];
      final name = ref.name;
      DateTime timeStamp = resultTimestamp[index];
      final file = FirebaseStory(ref: ref, name: name, url: url,timeCreated: timeStamp);
      return MapEntry(index, file);
    })
        .values
        .toList();
  }
}