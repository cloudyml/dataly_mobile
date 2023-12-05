import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dataly_app/Providers/chat_screen_provider.dart';
import 'package:dataly_app/widgets/audio_bubble.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helpers/file_handler.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class AudioMsgTile extends StatefulWidget {
  final size;
  final Map<String, dynamic>? map;
  final appStorage;
  final displayName;
  var documentID;
  var groupID;
  var controller;
  var animation;
  AudioMsgTile(
      {this.size,
      this.map,
      this.appStorage,
      this.displayName,
      this.documentID,
      this.groupID,
      this.controller,
      this.animation});

  @override
  State<AudioMsgTile> createState() => _AudioMsgTileState();
}

class _AudioMsgTileState extends State<AudioMsgTile> {
  var filePath = null;

  checkFileExists(fileName) async {
    final file = await File("${widget.appStorage!.path}/$fileName");

    if (!file.existsSync()) {
      final file = await File("${widget.appStorage!.path}/$fileName");
      await downloadFile(widget.map!["link"], fileName, file);
      setState(() {
        filePath = file.path;
      });
    } else {
      setState(() {
        filePath = file.path;
      });
    }
    // print("Successfull");
  }

  var documentId = null;
  @override
  Widget build(BuildContext context) {
    // final providerChatScreenNotifier =
    //     Provider.of<ChatScreenNotifier>(context, listen: false);

    widget.map!["type"] == "audio" || widget.map!["type"] == "image"
        ? checkFileExists(widget.map!["message"])
        : null;
    return Container(
      // color:
      // data.selectedDocumentID.length!=0?data.selectedDocumentID.contains(widget.documentID)?HexColor("#cafca2"):null:null,
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
            // gradient: const RadialGradient(
            //     center: Alignment.topRight,
            //     // near the top right
            //     radius: 6,
            //     colors: [
            //       Colors.purple,
            //       Colors.blue,
            //     ]),
            ),
        alignment: Alignment.center,
        child: widget.map!["link"] != ""
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Text(
                      widget.map!["sendBy"],
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // widget.map!["replySenderName"] != null
                  //     ? Container(
                  //         decoration: BoxDecoration(
                  //             color: Colors.blue,
                  //             borderRadius: BorderRadius.circular(10)),
                  //         height: 60,
                  //         alignment: Alignment.topLeft,
                  //         child: Row(
                  //           children: [
                  //             // SizedBox(width: 5,),
                  //             VerticalDivider(
                  //               indent: 5,
                  //               endIndent: 5,
                  //               color: Colors.purple,
                  //               width: 4,
                  //               thickness: 4,
                  //             ),
                  //             SizedBox(
                  //               width: 5,
                  //             ),
                  //             Expanded(
                  //                 child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 Text(
                  //                   ("@" +
                  //                       widget.map!['replySenderName']
                  //                           .toString()),
                  //                   style: TextStyle(
                  //                       color: Colors.purple,
                  //                       fontWeight: FontWeight.bold,
                  //                       fontSize: 13,
                  //                       overflow: TextOverflow.ellipsis),
                  //                   textAlign: TextAlign.start,
                  //                 ),
                  //                 Text(
                  //                   (widget.map!['replyMessage'].toString()),
                  //                   style: TextStyle(
                  //                       color: Colors.black,
                  //                       fontSize: 12,
                  //                       overflow: TextOverflow.ellipsis),
                  //                   textAlign: TextAlign.start,
                  //                   maxLines: 2,
                  //                 ),
                  //               ],
                  //             ))
                  //           ],
                  //         ),
                  //       )
                  //     : SizedBox(),
                  filePath != null
                      ? Container(
                          child: AudioBubble(filepath: filePath),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200.withOpacity(0.5)),
                        )
                      : SizedBox(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    alignment: Alignment.bottomRight,
                    child: Text(
                      // "",
                      DateFormat.jm().format(Timestamp(
                              widget.map!["time"]["_seconds"],
                              widget.map!["time"]["_nanoseconds"])
                          .toDate()),
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    constraints: BoxConstraints(
                      minWidth: widget.size.width * 0.2,
                    ),
                  )
                ],
              )
            : Container(
                height: widget.size.height * 0.15,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
    //   GestureDetector(
    //   // onHorizontalDragUpdate: (details) {
    //   //   if (details.delta.dx > -100) {
    //   //     print("Hello");
    //   //     print("RightSide");
    //   //     // print(map["message"]);
    //   //     documentId = widget.documentID;
    //   //     print("on right Swipe");
    //   //     print(widget.map!["message"]);
    //   //     print(widget.map!["replyMessage"].toString());
    //   //     providerChatScreenNotifier.focusNodeField(true);
    //   //     providerChatScreenNotifier.addReplyMessage(Expression: true,ReplySenderName: widget.map!['sendBy'],ReplySenderMessage:
    //   //     widget.map!["message"],
    //   //         SenderName: widget.displayName);
    //   //     print(providerChatScreenNotifier.replyMessage);
    //   //     widget.controller.forward().whenComplete((){
    //   //       widget.controller.reverse();
    //   //       documentId = null;
    //   //     });
    //   //   }
    //   // },
    //   // onLongPress: (){
    //
    //   //   providerChatScreenNotifier.runTimeExpression?providerChatScreenNotifier.deleteChatText(ID: widget.documentID,
    //   //       expression: false,removeID: false,runTime: true):null;
    //   //   print("onTapped");
    //   // },
    //   // onTap: ()
    //   // {
    //   //   print("runtime ============== ${providerChatScreenNotifier.runTimeExpression}");
    //   //   if(providerChatScreenNotifier.runTimeExpression && providerChatScreenNotifier.selectedDocumentID.length!=0)
    //   //   {
    //   //     if(providerChatScreenNotifier.selectedDocumentID.contains(widget.documentID) && providerChatScreenNotifier.selectedDocumentID.length!=0)
    //   //     {
    //   //       providerChatScreenNotifier.deleteChatText(ID: widget.documentID,expression: false,removeID: true,runTime: true);
    //   //       print(providerChatScreenNotifier.selectedDocumentID);
    //   //       print("removed");
    //   //     }
    //   //     else
    //   //     {
    //   //       providerChatScreenNotifier.deleteChatText(ID: widget.documentID,expression: false,removeID: false,runTime: true);
    //   //     }
    //   //   }
    //   // },
    //   child: Consumer<ChatScreenNotifier>(
    //     builder: (context, data, child) {
    //       return documentId != null
    //           ? SlideTransition(
    //               position: widget.animation,
    //               child: Container(
    //                 // color:
    //                 // data.selectedDocumentID.length!=0?data.selectedDocumentID.contains(widget.documentID)?HexColor("#cafca2"):null:null,
    //                 width: widget.size.width,
    //                 padding:
    //                     const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
    //                 alignment: widget.map!['sendBy'] == widget.displayName
    //                     ? Alignment.centerRight
    //                     : Alignment.centerLeft,
    //                 child: Container(
    //                   width: widget.size.width * 0.5,
    //                   decoration: BoxDecoration(
    //                       borderRadius: BorderRadius.circular(25),
    //                       color: widget.map!["sendBy"] == widget.displayName
    //                           ? HexColor("#6da2f7")
    //                           : HexColor("#b3afb0")
    //                       // gradient: const RadialGradient(
    //                       //     center: Alignment.topRight,
    //                       //     // near the top right
    //                       //     radius: 6,
    //                       //     colors: [
    //                       //       Colors.purple,
    //                       //       Colors.blue,
    //                       //     ]),
    //                       ),
    //                   alignment: Alignment.center,
    //                   child: widget.map!["link"] != ""
    //                       ? Column(
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: [
    //                             Container(
    //                               padding: const EdgeInsets.symmetric(
    //                                   vertical: 10, horizontal: 10),
    //                               child: Text(
    //                                 widget.map!["sendBy"],
    //                                 style: TextStyle(
    //                                     color: Colors.black,
    //                                     fontWeight: FontWeight.bold),
    //                               ),
    //                             ),
    //                             widget.map!["replySenderName"] != null
    //                                 ? Container(
    //                                     decoration: BoxDecoration(
    //                                         color: Colors.blue,
    //                                         borderRadius:
    //                                             BorderRadius.circular(10)),
    //                                     height: 60,
    //                                     alignment: Alignment.topLeft,
    //                                     child: Row(
    //                                       children: [
    //                                         // SizedBox(width: 5,),
    //                                         VerticalDivider(
    //                                           indent: 5,
    //                                           endIndent: 5,
    //                                           color: Colors.purple,
    //                                           width: 4,
    //                                           thickness: 4,
    //                                         ),
    //                                         SizedBox(
    //                                           width: 5,
    //                                         ),
    //                                         Expanded(
    //                                             child: Column(
    //                                           crossAxisAlignment:
    //                                               CrossAxisAlignment.start,
    //                                           mainAxisAlignment:
    //                                               MainAxisAlignment.center,
    //                                           children: [
    //                                             Text(
    //                                               ("@" +
    //                                                   widget.map![
    //                                                           'replySenderName']
    //                                                       .toString()),
    //                                               style: TextStyle(
    //                                                   color: Colors.purple,
    //                                                   fontWeight:
    //                                                       FontWeight.bold,
    //                                                   fontSize: 13,
    //                                                   overflow: TextOverflow
    //                                                       .ellipsis),
    //                                               textAlign: TextAlign.start,
    //                                             ),
    //                                             Text(
    //                                               (widget.map!['replyMessage']
    //                                                   .toString()),
    //                                               style: TextStyle(
    //                                                   color: Colors.black,
    //                                                   fontSize: 12,
    //                                                   overflow: TextOverflow
    //                                                       .ellipsis),
    //                                               textAlign: TextAlign.start,
    //                                               maxLines: 2,
    //                                             ),
    //                                           ],
    //                                         ))
    //                                       ],
    //                                     ),
    //                                   )
    //                                 : SizedBox(),
    //                             Container(
    //                               child: AudioBubble(filepath: filePath),
    //                               decoration: BoxDecoration(
    //                                   color: Colors.grey.shade200
    //                                       .withOpacity(0.5)),
    //                             ),
    //                             // Container(
    //                             //   padding: const EdgeInsets.symmetric(
    //                             //       vertical: 10, horizontal: 10),
    //                             //   alignment: Alignment.bottomRight,
    //                             //   child: Text(
    //                             //     DateFormat('hh:mm a')
    //                             //         .format(widget.map!["time"].toDate())
    //                             //         .toLowerCase(),
    //                             //     style: const TextStyle(
    //                             //         fontSize: 12,
    //                             //         color: Colors.white,
    //                             //         fontWeight: FontWeight.bold),
    //                             //   ),
    //                             //   constraints: BoxConstraints(
    //                             //     minWidth: widget.size.width * 0.2,
    //                             //   ),
    //                             // )
    //                           ],
    //                         )
    //                       : Container(
    //                           height: widget.size.height * 0.15,
    //                           child: Center(
    //                             child: CircularProgressIndicator(),
    //                           ),
    //                         ),
    //                 ),
    //               ),
    //             )
    //           : Container(
    //               // color:
    //               // data.selectedDocumentID.length!=0?data.selectedDocumentID.contains(widget.documentID)?HexColor("#cafca2"):null:null,
    //               width: widget.size.width,
    //               padding:
    //                   const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
    //               alignment: widget.map!['sendBy'] == widget.displayName
    //                   ? Alignment.centerRight
    //                   : Alignment.centerLeft,
    //               child: Container(
    //                 width: widget.size.width * 0.5,
    //                 decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(25),
    //                     color: widget.map!["sendBy"] == widget.displayName
    //                         ? HexColor("#6da2f7")
    //                         : HexColor("#b3afb0")
    //                     // gradient: const RadialGradient(
    //                     //     center: Alignment.topRight,
    //                     //     // near the top right
    //                     //     radius: 6,
    //                     //     colors: [
    //                     //       Colors.purple,
    //                     //       Colors.blue,
    //                     //     ]),
    //                     ),
    //                 alignment: Alignment.center,
    //                 child: widget.map!["link"] != ""
    //                     ? Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           Container(
    //                             padding: const EdgeInsets.symmetric(
    //                                 vertical: 10, horizontal: 10),
    //                             child: Text(
    //                               widget.map!["sendBy"],
    //                               style: TextStyle(
    //                                   color: Colors.black,
    //                                   fontWeight: FontWeight.bold),
    //                             ),
    //                           ),
    //                           widget.map!["replySenderName"] != null
    //                               ? Container(
    //                                   decoration: BoxDecoration(
    //                                       color: Colors.blue,
    //                                       borderRadius:
    //                                           BorderRadius.circular(10)),
    //                                   height: 60,
    //                                   alignment: Alignment.topLeft,
    //                                   child: Row(
    //                                     children: [
    //                                       // SizedBox(width: 5,),
    //                                       VerticalDivider(
    //                                         indent: 5,
    //                                         endIndent: 5,
    //                                         color: Colors.purple,
    //                                         width: 4,
    //                                         thickness: 4,
    //                                       ),
    //                                       SizedBox(
    //                                         width: 5,
    //                                       ),
    //                                       Expanded(
    //                                           child: Column(
    //                                         crossAxisAlignment:
    //                                             CrossAxisAlignment.start,
    //                                         mainAxisAlignment:
    //                                             MainAxisAlignment.center,
    //                                         children: [
    //                                           Text(
    //                                             ("@" +
    //                                                 widget
    //                                                     .map!['replySenderName']
    //                                                     .toString()),
    //                                             style: TextStyle(
    //                                                 color: Colors.purple,
    //                                                 fontWeight: FontWeight.bold,
    //                                                 fontSize: 13,
    //                                                 overflow:
    //                                                     TextOverflow.ellipsis),
    //                                             textAlign: TextAlign.start,
    //                                           ),
    //                                           Text(
    //                                             (widget.map!['replyMessage']
    //                                                 .toString()),
    //                                             style: TextStyle(
    //                                                 color: Colors.black,
    //                                                 fontSize: 12,
    //                                                 overflow:
    //                                                     TextOverflow.ellipsis),
    //                                             textAlign: TextAlign.start,
    //                                             maxLines: 2,
    //                                           ),
    //                                         ],
    //                                       ))
    //                                     ],
    //                                   ),
    //                                 )
    //                               : SizedBox(),
    //                           Container(
    //                             child: AudioBubble(filepath: filePath),
    //                             decoration: BoxDecoration(
    //                                 color:
    //                                     Colors.grey.shade200.withOpacity(0.5)),
    //                           ),
    //                           Container(
    //                             padding: const EdgeInsets.symmetric(
    //                                 vertical: 10, horizontal: 10),
    //                             alignment: Alignment.bottomRight,
    //                             child: Text(
    //                               "",
    //                               // DateFormat.jm().format(Timestamp(
    //                               //         widget.map!["time"]["_seconds"],
    //                               //         widget.map!["time"]["_nanoseconds"])
    //                               //     .toDate()),
    //                               style: const TextStyle(
    //                                   fontSize: 12,
    //                                   color: Colors.white,
    //                                   fontWeight: FontWeight.bold),
    //                             ),
    //                             constraints: BoxConstraints(
    //                               minWidth: widget.size.width * 0.2,
    //                             ),
    //                           )
    //                         ],
    //                       )
    //                     : Container(
    //                         height: widget.size.height * 0.15,
    //                         child: Center(
    //                           child: CircularProgressIndicator(),
    //                         ),
    //                       ),
    //               ),
    //             );
    //     },
    //   ),
    // );
  }
}
