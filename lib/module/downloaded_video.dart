import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Downloadlink extends ChangeNotifier {
  Future<bool> checkiffileexist(filename) async {
    final directory = await getApplicationDocumentsDirectory();
    File file = File("${directory.toString().split("'")[1]}/${filename}");
    // print(await file.exists());
    return await file.exists();
  }

//'/data/user/0/com.cloudyml.cloudymlapp/app_flutter/Python Intermediate ff Tutorial'
  Future<String> deleteFile(String filename) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      
        File file = File("${directory.toString().split("'")[1]}/${filename}");
        print(file.path);
        print(await file.exists());
        await file.delete();
        print("deleted");
        return "download";
      
    } catch (e) {
      print(e);
      return "error";
    }
  }

// Future<File> getLocalFile(String filename) async {
//   final path = await getLocalPath();
//   return File('$path/$filename');
// }

// Future<File> saveVideoToLocal(String filename, Uint8List videoData) async {
// final file = await getLocalFile(filename);
// return file.writeAsBytes(videoData);
// }

// Future<Uint8List> getVideoFromLocal(String filename) async {
//   final file = await getLocalFile(filename);
//   return file.readAsBytes();
// }

// class Downloadlink extends ChangeNotifier {
  CancelToken cancelToken = CancelToken();
  var value = 0.0;
  var progress = ValueNotifier(0.0);
  var container = ValueNotifier<List<String>>([]);
  List<String> values = [];

  ///data/user/0/com.cloudyml.cloudymlapp/app_flutter/Python Intermediate Tutorial
  Future<void> downloadvideotoPath(url, filename, BuildContext context) async {
    values.add(filename);
    container.value = values;

    final directory = await getApplicationDocumentsDirectory();
    // print("${directory.path.contains(filename)}");
    // print("$directory/$filename");
    await downloadVideo(url, "${directory.path}/${filename}", context);
    // return directory.path;
  }

  var progressdata = 0.0;
  notifyListeners();

  Future<void> downloadVideo(
      String url, String savePath, BuildContext context) async {
    Dio dio = Dio();
    var value;

    try {
      await dio.download(url, savePath, cancelToken: cancelToken,
          onReceiveProgress: (received, total) {
        print((received / total).toString());
        Future.delayed(const Duration(seconds: 1), () {
          progressdata =
              double.parse(((received / total) * 100).toStringAsFixed(0));

          print(progressdata);
          value = progress.value; // Prints after 1 second.
        });
        for (var i = 0; i < 100; i++) {
          Future.delayed(const Duration(seconds: 1), () {
            progressdata = progressdata + 1;
            progress.value = progressdata;
            notifyListeners();

            print(progressdata);
          });
        }

        // Toast.show('${progress.value}%', context: context,animDuration: Duration(seconds: 2), duration: Duration(seconds: 2));
        // showDialog(
        //     context: context,
        //     builder: (context) {
        //       return AlertDialog(
        //         title: Text('${progress.value}%'),
        //         content: Text('Hey! I am Coflutter!'),
        //         actions: <Widget>[
        //           TextButton(
        //               onPressed: () {
        //                 // _dismissDialog();
        //               },
        //               child: Text('Close')),
        //           TextButton(
        //             onPressed: () {
        //               print('HelloWorld!');
        //               // _dismissDialog();
        //             },
        //             child: Text('HelloWorld!'),
        //           )
        //         ],
        //       );
        //     });
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> cancelDownload() async {
    cancelToken.cancel("Cancelled by the user");
  }
}
