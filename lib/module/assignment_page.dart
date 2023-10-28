import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/firebase_file.dart';
import '../theme.dart';

class AssignmentScreen extends StatefulWidget {
  var link;
  var refUrl;

  AssignmentScreen(
    this.link,
    this.refUrl, {
    Key? key,
    this.courseData,
    this.courseName,
    this.selectedSection,
    this.assignmentUrl,
    this.assignmentName,
    this.solutionUrl,
    this.dataSetName,
    this.dataSetUrl,
    this.pdfUrl,
  }) : super(key: key);

  final courseData;
  final courseName;
  final selectedSection;
  final assignmentUrl;
  final solutionUrl;
  final dataSetUrl;
  final dataSetName;
  final assignmentName;
  final pdfUrl;

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  TextEditingController noteText = TextEditingController();

  Uint8List? uploadedFile;

  FirebaseFirestore _reference = FirebaseFirestore.instance;
  FirebaseFile? file;

  String? fileName;

  var ref;

  Future getFile() async {
    FilePickerResult? result;

    try {
      result = await FilePicker.platform.pickFiles(type: FileType.any);
    } catch (e) {
      print(e.toString());
    }

    if (result != null && result.files.isNotEmpty) {
      try {
        Uint8List? uploadFile = result.files.single.bytes;

        // final String filepath = path.basename(uploadFile.toString());
        String pickedFileName = result.files.first.name;

        setState(() {
          uploadedFile = uploadFile;
          fileName = pickedFileName;
        });

        if (uploadedFile != null) {
          Fluttertoast.showToast(msg: 'Your file is attached');
        }
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
        print(e.toString());
      }
    }
  }

  void getModuleId() async {
    ref = await FirebaseFirestore.instance
        .collection('courses')
        .doc('lLorGjaJf2m6hTzCdIxU')
        .get();
  }

  Future downloadFile(String fileUrl) async {
    FirebaseStorage _storage = FirebaseStorage.instance;

    await _storage.ref('Assignments/${fileUrl}');
  }

  @override
  void initState() {
    super.initState();
    print(
        'widget.dataSetUrl ${widget.dataSetUrl.containsKey(widget.assignmentName)} ${widget.assignmentName}');
    getModuleId();
  }

  Future submissionTask() async {
    try {
      var storageRef =
          FirebaseStorage.instance.ref().child('Assignments').child(fileName!);

      var sentData = await _reference.collection('assignment_dataly').add({
        "email": FirebaseAuth.instance.currentUser?.email,
        "name": FirebaseAuth.instance.currentUser?.displayName,
        "student id": FirebaseAuth.instance.currentUser?.uid,
        "date of submission": FieldValue.serverTimestamp(),
        "filename": fileName!,
        "link": '',
        "note": noteText.text,
      });

      final UploadTask uploadTask = storageRef.putData(uploadedFile!);

      final TaskSnapshot downloadUrl = await uploadTask;
      final String fileURL = (await downloadUrl.ref.getDownloadURL());
      await sentData.update({"link": fileURL});
      print('Assignment file link is here: $fileURL');

      Fluttertoast.showToast(msg: "Your file has been uploaded successfully");
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // shadowColor: Color.fromARGB(255, 129, 31, 194),
          backgroundColor: MyColors.primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: widget.dataSetUrl.containsKey(widget.assignmentName)
                      ? Center(
                          child: Column(
                            children: [
                              Text(
                                  'Please click on the link below to download.'),
                              TextButton(
                                  onPressed: () {
                                    launch(widget
                                        .dataSetUrl[widget.assignmentName]);
                                  },
                                  child: Text(widget.dataSetName))
                            ],
                          ),
                        )
                      : widget.refUrl != null
                          ? Center(
                              child: Column(
                                children: [
                                  Text(
                                      'Please click on the link below to download pdf.'),
                                  TextButton(
                                      onPressed: () {
                                        launch(widget.refUrl);
                                      },
                                      child: Text(widget.assignmentName))
                                ],
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          'Assignment Instructions',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,
                                          ),
                                        ),
                                      ),
                                      // Text('${widget.selectedSection}',
                                      //   style: TextStyle(
                                      //   color: Colors.grey,
                                      //   fontWeight: FontWeight.bold,
                                      //   fontSize: 22,
                                      // ),),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey,
                                            width: 0.2,
                                            style: BorderStyle.solid)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Please download the assignment, watch videos as instructed and answer all questions accordingly. Open colab by clicking here : ",
                                              textAlign: TextAlign.left,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "",
                                                  textAlign: TextAlign.left,
                                                ),
                                                InkWell(
                                                    onTap: () => launch(
                                                        'https://colab.research.google.com/'),
                                                    child: Text(
                                                      "https://colab.research.google.com/",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .deepPurpleAccent),
                                                    )),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    "Reference PDF for output "),
                                                InkWell(
                                                    onTap: () {
                                                      launch(widget.refUrl);
                                                    },
                                                    child: Text(
                                                      'Reference pdf.',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .deepPurpleAccent),
                                                    )),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            //for assignments
                                            Row(
                                              children: [
                                                Text(
                                                  'Click to download ',
                                                  style: TextStyle(),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    launch(widget.link);
                                                  },
                                                  child: Text(
                                                    'Assignment file.',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .deepPurpleAccent),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            //future builder for DataSets
                                            // widget.dataSetUrl.length != 0
                                            //     ? Column(
                                            //   children: List.generate(
                                            //       widget.dataSetUrl.length, (index) {
                                            //     return Padding(
                                            //       padding:
                                            //       const EdgeInsets.only(top: 0.0),
                                            //       child: Row(
                                            //         children: [
                                            //           Text(
                                            //             'Click to download ',
                                            //           ),
                                            //           InkWell(
                                            //             onTap: () {
                                            //               launch(
                                            //                   widget.dataSetUrl[index]
                                            //                   ["url"]);
                                            //               // print(
                                            //               //     'dataset = ${widget.dataSetUrl} ${widget.dataSetUrl.toString()}');
                                            //             },
                                            //             child: Text(
                                            //               'DataSet file. ${widget.dataSetUrl[index]["name"]}',
                                            //               style: TextStyle(
                                            //                   color: Colors
                                            //                       .deepPurpleAccent),
                                            //             ),
                                            //           ),
                                            //         ],
                                            //       ),
                                            //     );
                                            //   }),
                                            // )
                                            //     : SizedBox()
                                          ]),
                                    ),
                                  ),
                                ),
                                // main grey container
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white12, width: 0.5),
                                    color: Colors.black12,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              "Upload Assignment",
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "(You can upload maximum 200 MB of file size)",
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        //button container
                                        Container(
                                          padding: EdgeInsets.only(left: 20),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          color: Colors.black12,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    await getFile();
                                                    if (fileName!.isNotEmpty) {
                                                      print(fileName);
                                                    }
                                                  },
                                                  child: Text("Choose file",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black26)),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.white),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              uploadedFile != null
                                                  ? Text(
                                                      fileName.toString(),
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    )
                                                  : Text(
                                                      "No file chosen",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black26),
                                                    )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Notes",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          padding: EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.white12,
                                                  width: 0.5),
                                              borderRadius:
                                                  BorderRadius.circular(5.0)),
                                          child: TextField(
                                            controller: noteText,
                                            decoration: InputDecoration(
                                              hintText:
                                                  'Please write note here...',
                                              border: InputBorder.none,
                                            ),
                                            maxLines: 10,
                                            minLines: 5,
                                            autocorrect: true,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            if (uploadedFile == null) {
                                              Fluttertoast.showToast(
                                                  msg: 'Please upload a file');
                                            } else {
                                              await submissionTask();
                                              noteText.clear();
                                              uploadedFile!.clear();
                                            }
                                          },
                                          child: Text("Submit"),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                uploadedFile == null
                                                    ? Colors.grey
                                                    : Colors.deepPurpleAccent,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                )),
          ),
        ));
  }
}
