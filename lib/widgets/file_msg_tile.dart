import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dataly_app/Providers/chat_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../helpers/file_handler.dart';
import 'package:hexcolor/hexcolor.dart';
class FileMsgTile extends StatefulWidget {
  final size;
  final Map<String, dynamic>? map;
  final String? displayName;
  final Directory? appStorage;
var documentID;
var groupID;
  FileMsgTile({this.size, this.map, this.displayName, this.appStorage,this.documentID,this.groupID});

  @override
  State<FileMsgTile> createState() => _FileMsgTileState();
}

class _FileMsgTileState extends State<FileMsgTile> {
  var filePath;

  String? checkFileExists(fileName) {
    final file = File("${widget.appStorage!.path}/$fileName");

    if (!file.existsSync()) {
      final file = File("${widget.appStorage!.path}/$fileName");
      downloadFile(widget.map!["link"], fileName, file);
      return null;
    } else {
      setState(() {
        filePath = file.path;
      });
      return file.path;
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerChatScreenNotifier = Provider.of<ChatScreenNotifier>(context,listen: false);
    checkFileExists(widget.map!["message"]);
    return GestureDetector(
      // onLongPress: (){

      //   providerChatScreenNotifier.runTimeExpression?providerChatScreenNotifier.deleteChatText(ID: widget.documentID,
      //       expression: false,removeID: false,runTime: true):null;
      //   print("onTapped");
      // },
      // onTap: ()
      // {
      //   print("runtime ============== ${providerChatScreenNotifier.runTimeExpression}");
      //   if(providerChatScreenNotifier.runTimeExpression && providerChatScreenNotifier.selectedDocumentID.length!=0)
      //   {
      //     if(providerChatScreenNotifier.selectedDocumentID.contains(widget.documentID) && providerChatScreenNotifier.selectedDocumentID.length!=0)
      //     {
      //       providerChatScreenNotifier.deleteChatText(ID: widget.documentID,expression: false,removeID: true,runTime: true);
      //       print(providerChatScreenNotifier.selectedDocumentID);
      //       print("removed");
      //     }
      //     else
      //     {
      //       providerChatScreenNotifier.deleteChatText(ID: widget.documentID,expression: false,removeID: false,runTime: true);
      //     }
      //   }
      // },
      child: Consumer<ChatScreenNotifier>(
        builder: (context,data,child)
        {
          return Container(
            color:
            data.selectedDocumentID.length!=0?data.selectedDocumentID.contains(widget.documentID)?HexColor("#cafca2"):null:null,
            width: widget.size.width,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            alignment: widget.map!['sendBy'] == widget.displayName
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              width: widget.size.width * 0.5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: widget.map!["sendBy"] == widget.displayName
                      ? HexColor("#6da2f7")
                      : HexColor("#b3afb0")
                // gradient: RadialGradient(
                //     center: Alignment.topRight,
                //     // near the top right
                //     radius: 6,
                //     // colors: []
                // ),
              ),
              alignment: Alignment.center,
              child: widget.map!['link'] != ""
                  ? InkWell(
                onTap: () => openFile(
                    url: widget.map!["link"], fileName: widget.map!["message"]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Text(
                        widget.map!["sendBy"],
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      constraints:
                      BoxConstraints(minWidth: widget.size.width * 0.5),
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      height: 50,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: widget.size.width * 0.4,
                            child: Text(widget.map!["message"],
                                style: const TextStyle(fontSize: 15),
                                overflow: TextOverflow.ellipsis),
                          ),
                          // filePath == null
                          //     ? const CircleAvatar(
                          //         child: Icon(
                          //           Icons.download,
                          //           color: Colors.white,
                          //         ),
                          //         backgroundColor:
                          //             Color.fromARGB(255, 141, 5, 136),
                          //       )
                          //     : Container()
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200.withOpacity(0.5)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "File",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            DateFormat.jm().format(Timestamp(widget.map!["time"]["_seconds"],widget.map!["time"]["_nanoseconds"]).toDate()),
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      constraints: BoxConstraints(
                        minWidth: widget.size.width * 0.2,
                      ),
                    )
                  ],
                ),
              )
                  : Container(
                height: widget.size.height * 0.15,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
