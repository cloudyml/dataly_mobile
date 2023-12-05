import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dataly_app/Providers/chat_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helpers/file_handler.dart';
import 'dart:io';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../screens/image_page.dart';
// import 'package:swipe_to/swipe_to.dart';

class ImageMsgTile extends StatefulWidget {
  final Map<String, dynamic>? map;
  final String? displayName;
  final Directory? appStorage;
  var documentID;
  var groupID;
  var controller;
  var animation;
  ImageMsgTile(
      {this.map,
      this.displayName,
      this.appStorage,
      this.documentID,
      this.groupID,
      this.controller,
      this.animation});

  @override
  State<ImageMsgTile> createState() => _ImageMsgTileState();
}

class _ImageMsgTileState extends State<ImageMsgTile> {
  var filePath;

  checkImageExists(fileName) async {
    final file = File("${widget.appStorage!.path}/$fileName");
    final providerChatScreenNotifier =
        Provider.of<ChatScreenNotifier>(context, listen: false);
    if (!file.existsSync()) {
      final file = File("${widget.appStorage!.path}/$fileName");
      await downloadFile(widget.map!["link"], fileName, file);
      setState(() {
        filePath = file.path;
      });
    } else {
      // setState(() {
      filePath = file.path;
      print("Filepath==============${filePath}");
      providerChatScreenNotifier.filePath(filePath);
      // });
      return file.path;
    }
  }

  var documentId;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final providerChatScreenNotifier =
        Provider.of<ChatScreenNotifier>(context, listen: false);
    return Container(
      width: size.width,
      // color:
      // data.selectedDocumentID.length!=0?data.selectedDocumentID.contains(widget.documentID)?HexColor("#cafca2"):null:null,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      alignment: widget.map!['sendBy'] == widget.displayName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: InkWell(
        onTap: () {
          print("Clicked--------");
          print("onpressed");
          // print(
          //     "runtime ============== ${providerChatScreenNotifier.runTimeExpression}");
          // if(data.selectedDocumentID.length!=0)
          // {
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
          // }
          // else
          // {
            print("link is${widget.map!["link"]}");
          openFile(url: widget.map!["link"], fileName: widget.map!["message"]);
          // }
        },
        child: Container(
          width: size.width * 0.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: widget.map!["sendBy"] == widget.displayName
                ? HexColor("#6da2f7")
                : HexColor("#b3afb0"),
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
          child: widget.map!['link'] != ""
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
                    widget.map!["replySenderName"] != null
                        ? Container(
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10)),
                            height: 80,
                            alignment: Alignment.topLeft,
                            child: Expanded(
                              child: Row(
                                children: [
                                  // SizedBox(width: 5,),
                                  VerticalDivider(
                                    indent: 5,
                                    endIndent: 5,
                                    color: Colors.purple,
                                    width: 4,
                                    thickness: 4,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        ("@" +
                                            widget.map!['replySenderName']
                                                .toString()),
                                        style: TextStyle(
                                            color: Colors.purple,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            overflow: TextOverflow.ellipsis),
                                        textAlign: TextAlign.start,
                                      ),
                                      Text(
                                        (widget.map!['replyMessage']
                                            .toString()),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            overflow: TextOverflow.ellipsis),
                                        textAlign: TextAlign.start,
                                        maxLines: 3,
                                      ),
                                    ],
                                  ))
                                ],
                              ),
                            ),
                          )
                        : SizedBox(),
                    Container(
                      height: 250,
                      // constraints: BoxConstraints(minHeight: size.width * 0.5),
                      child:
                          // checkImageExists(widget.map!["message"]) != null
                          //     ? Image.file(
                          //   File(filepath),
                          //   fit: BoxFit.cover,
                          // )
                          //     :
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ImagePage(file:widget.map!["link"].toString()),
            ),
          );
          print("abc");
                            },
                            child: 
                            CachedNetworkImage(
                                                  placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(),
                            heightFactor: 30,
                            widthFactor: 30,
                                                  ),
                                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                                  imageUrl: widget.map!["link"],
                                                  fit: BoxFit.cover,
                                                  // loadingBuilder: (BuildContext context,
                                                  //     Widget child,
                                                  //     ImageChunkEvent? loadingProgress) {
                                                  //   if (loadingProgress == null) return child;
                                                  //   return Center(
                                                  //     child: CircularProgressIndicator(
                                                  //       color: Colors.white,
                                                  //       value: loadingProgress.expectedTotalBytes !=
                                                  //               null
                                                  //           ? loadingProgress
                                                  //                   .cumulativeBytesLoaded /
                                                  //               loadingProgress.expectedTotalBytes!
                                                  //           : null,
                                                  //     ),
                                                  //   );
                                                  // },
                                                ),
                          ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      alignment: Alignment.bottomRight,
                      child: Text(
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
                        minWidth: size.width * 0.2,
                      ),
                    )
                  ],
                )
              : Container(
                  height: size.width * 0.5,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
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
    //
    //   //     print(providerChatScreenNotifier.replyMessage);
    //   //     widget.controller.forward().whenComplete((){
    //   //       widget.controller.reverse();
    //   //       documentId = null;
    //   //     });
    //   //   }
    //   // },
    //   // onLongPress: (){
    //   //   print("long press");
    //   //   providerChatScreenNotifier.runTimeExpression?providerChatScreenNotifier.deleteChatText(ID: widget.documentID,expression: false,removeID: false,runTime: true):null;
    //   //   print("onTapped");
    //   //   // print(map["message"]);
    //   //   print("Deleted");
    //   // },
    //   //   onTap: (){
    //   //     print("runtime ============== ${providerChatScreenNotifier.runTimeExpression}");
    //   //     if(providerChatScreenNotifier.runTimeExpression && providerChatScreenNotifier.selectedDocumentID.length!=0)
    //   //     {
    //   //       if(providerChatScreenNotifier.selectedDocumentID.contains(widget.documentID) && providerChatScreenNotifier.selectedDocumentID.length!=0)
    //   //       {
    //   //         providerChatScreenNotifier.deleteChatText(ID: widget.documentID,expression: false,removeID: true,runTime: true);
    //   //         print(providerChatScreenNotifier.selectedDocumentID);
    //   //         print("removed");
    //   //       }
    //   //       else
    //   //       {
    //   //         providerChatScreenNotifier.deleteChatText(ID: widget.documentID,expression: false,removeID: false,runTime: true);
    //   //       }
    //   //     }
    //
    //   //   },
    //   child: Consumer<ChatScreenNotifier>(
    //     builder: (context, data, child) {
    //       print("Datafilepath = = = =${data.filepath}");
    //       return
    //           documentId!=null?
    //           SlideTransition(
    //         position: widget.animation,
    //         child: Container(
    //           width: size.width,
    //           // color:
    //           // data.selectedDocumentID.length!=0?data.selectedDocumentID.contains(widget.documentID)?HexColor("#cafca2"):null:null,
    //           padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
    //           alignment: widget.map!['sendBy'] == widget.displayName
    //               ? Alignment.centerRight
    //               : Alignment.centerLeft,
    //           child: InkWell(
    //             onTap: () {
    //               print("Clicked--------");
    //               print("onpressed");
    //               print(
    //                   "runtime ============== ${providerChatScreenNotifier.runTimeExpression}");
    //               // if(data.selectedDocumentID.length!=0)
    //               // {
    //               //   if(providerChatScreenNotifier.runTimeExpression && providerChatScreenNotifier.selectedDocumentID.length!=0)
    //               //   {
    //               //     if(providerChatScreenNotifier.selectedDocumentID.contains(widget.documentID) && providerChatScreenNotifier.selectedDocumentID.length!=0)
    //               //     {
    //               //       providerChatScreenNotifier.deleteChatText(ID: widget.documentID,expression: false,removeID: true,runTime: true);
    //               //       print(providerChatScreenNotifier.selectedDocumentID);
    //               //       print("removed");
    //               //     }
    //               //     else
    //               //     {
    //               //       providerChatScreenNotifier.deleteChatText(ID: widget.documentID,expression: false,removeID: false,runTime: true);
    //               //     }
    //               //   }
    //               // }
    //               // else
    //               // {
    //               openFile(
    //                   url: widget.map!["link"],
    //                   fileName: widget.map!["message"]);
    //               // }
    //             },
    //             child: Container(
    //               width: size.width * 0.5,
    //               decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.circular(25),
    //                 color: widget.map!["sendBy"] == widget.displayName
    //                     ? HexColor("#6da2f7")
    //                     : HexColor("#b3afb0"),
    //                 // gradient: const RadialGradient(
    //                 //     center: Alignment.topRight,
    //                 //     // near the top right
    //                 //     radius: 6,
    //                 //     colors: [
    //                 //       Colors.purple,
    //                 //       Colors.blue,
    //                 //     ]),
    //               ),
    //               alignment: Alignment.center,
    //               child: widget.map!['link'] != ""
    //                   ? Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Container(
    //                           padding: const EdgeInsets.symmetric(
    //                               vertical: 10, horizontal: 10),
    //                           child: Text(
    //                             widget.map!["sendBy"],
    //                             style: TextStyle(
    //                                 color: Colors.black,
    //                                 fontWeight: FontWeight.bold),
    //                           ),
    //                         ),
    //                         widget.map!["replySenderName"] != null
    //                             ? Container(
    //                                 decoration: BoxDecoration(
    //                                     color: Colors.blue,
    //                                     borderRadius:
    //                                         BorderRadius.circular(10)),
    //                                 height: 80,
    //                                 alignment: Alignment.topLeft,
    //                                 child: Expanded(
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
    //                                             maxLines: 3,
    //                                           ),
    //                                         ],
    //                                       ))
    //                                     ],
    //                                   ),
    //                                 ),
    //                               )
    //                             : SizedBox(),
    //                         Container(
    //                           constraints:
    //                               BoxConstraints(minHeight: size.width * 0.5),
    //                           child:
    //                               // checkImageExists(widget.map!["message"]) != null
    //                               //     ? Image.file(
    //                               //   File(data.filepath),
    //                               //   fit: BoxFit.cover,
    //                               // )
    //                               //     :
    //                               CachedNetworkImage(
    //                             placeholder: (context, url) => Center(
    //                               child: CircularProgressIndicator(),
    //                               heightFactor: 30,
    //                               widthFactor: 30,
    //                             ),
    //                             errorWidget: (context, url, error) =>
    //                                 Icon(Icons.error),
    //                             imageUrl: widget.map!["link"],
    //                             fit: BoxFit.cover,
    //                             // loadingBuilder: (BuildContext context,
    //                             //     Widget child,
    //                             //     ImageChunkEvent? loadingProgress) {
    //                             //   if (loadingProgress == null) return child;
    //                             //   return Center(
    //                             //     child: CircularProgressIndicator(
    //                             //       color: Colors.white,
    //                             //       value: loadingProgress.expectedTotalBytes !=
    //                             //               null
    //                             //           ? loadingProgress
    //                             //                   .cumulativeBytesLoaded /
    //                             //               loadingProgress.expectedTotalBytes!
    //                             //           : null,
    //                             //     ),
    //                             //   );
    //                             // },
    //                           ),
    //                         ),
    //                         Container(
    //                           padding: const EdgeInsets.symmetric(
    //                               vertical: 10, horizontal: 10),
    //                           alignment: Alignment.bottomRight,
    //                           child: Text(
    //                             DateFormat('hh:mm a')
    //                                 .format(widget.map!["time"].toDate())
    //                                 .toLowerCase(),
    //                             style: const TextStyle(
    //                                 fontSize: 12,
    //                                 color: Colors.white,
    //                                 fontWeight: FontWeight.bold),
    //                           ),
    //                           constraints: BoxConstraints(
    //                             minWidth: size.width * 0.2,
    //                           ),
    //                         )
    //                       ],
    //                     )
    //                   : Container(
    //                       height: size.width * 0.5,
    //                       child: const Center(
    //                         child: CircularProgressIndicator(),
    //                       ),
    //                     ),
    //             ),
    //           ),
    //         ),
    //       )
    //       :
    //       Container(
    //         width: size.width,
    //         color:
    //         data.selectedDocumentID.length!=0?data.selectedDocumentID.contains(widget.documentID)?HexColor("#cafca2"):null:null,
    //         padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
    //         alignment: widget.map!['sendBy'] == widget.displayName
    //             ? Alignment.centerRight
    //             : Alignment.centerLeft,
    //         child: InkWell(
    //           onTap: () {
    //             print("Clicked--------");
    //             print("onpressed");
    //             print("runtime ============== ${providerChatScreenNotifier.runTimeExpression}");
    //             if(data.selectedDocumentID.length!=0)
    //             {
    //               if(providerChatScreenNotifier.runTimeExpression && providerChatScreenNotifier.selectedDocumentID.length!=0)
    //               {
    //                 if(providerChatScreenNotifier.selectedDocumentID.contains(widget.documentID) && providerChatScreenNotifier.selectedDocumentID.length!=0)
    //                 {
    //                   providerChatScreenNotifier.deleteChatText(ID: widget.documentID,expression: false,removeID: true,runTime: true);
    //                   print(providerChatScreenNotifier.selectedDocumentID);
    //                   print("removed");
    //                 }
    //                 else
    //                 {
    //                   providerChatScreenNotifier.deleteChatText(ID: widget.documentID,expression: false,removeID: false,runTime: true);
    //                 }
    //               }
    //             }
    //             else
    //             {
    //               openFile(url: widget.map!["link"], fileName: widget.map!["message"]);
    //             }
    //           },
    //           child: Container(
    //             width: size.width * 0.5,
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(25),
    //               color: widget.map!["sendBy"] == widget.displayName
    //                   ? HexColor("#6da2f7")
    //                   : HexColor("#b3afb0"),
    //               // gradient: const RadialGradient(
    //               //     center: Alignment.topRight,
    //               //     // near the top right
    //               //     radius: 6,
    //               //     colors: [
    //               //       Colors.purple,
    //               //       Colors.blue,
    //               //     ]),
    //             ),
    //             alignment: Alignment.center,
    //             child: widget.map!['link'] != ""
    //                 ? Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Container(
    //                   padding: const EdgeInsets.symmetric(
    //                       vertical: 10, horizontal: 10),
    //                   child: Text(
    //                     widget.map!["sendBy"],
    //                     style: TextStyle(
    //                         color: Colors.black, fontWeight: FontWeight.bold),
    //                   ),
    //                 ),
    //
    //
    //                 widget.map!["replySenderName"]!=null?Container(
    //                   decoration: BoxDecoration(
    //                       color: Colors.blue,
    //                       borderRadius: BorderRadius.circular(10)
    //                   ),
    //                   height: 80,
    //                   alignment: Alignment.topLeft,
    //                   child: Expanded(
    //                     child: Row(
    //                       children: [
    //                         // SizedBox(width: 5,),
    //                         VerticalDivider(
    //                           indent: 5,
    //                           endIndent: 5,
    //                           color: Colors.purple,
    //                           width: 4,
    //                           thickness: 4,
    //                         ),
    //                         SizedBox(width: 5,),
    //                         Expanded(child:
    //                         Column(
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           children: [
    //                             Text(
    //                               ("@"+widget.map!['replySenderName'].toString()),
    //                               style: TextStyle(
    //                                   color: Colors.purple,
    //                                   fontWeight: FontWeight.bold,
    //                                   fontSize: 13,
    //                                   overflow: TextOverflow.ellipsis
    //                               ),
    //                               textAlign: TextAlign.start,
    //                             ),
    //                             Text(
    //                               (widget.map!['replyMessage'].toString()),
    //                               style: TextStyle(
    //                                   color: Colors.black,
    //                                   fontSize: 12,
    //                                   overflow: TextOverflow.ellipsis
    //                               ),
    //                               textAlign: TextAlign.start,
    //                               maxLines: 3,
    //                             ),
    //                           ],
    //                         ))
    //                       ],
    //                     ),
    //                   ),
    //                 ):SizedBox(),
    //
    //                 Container(
    //                   constraints: BoxConstraints(minHeight: size.width * 0.5),
    //                   child: checkImageExists(widget.map!["message"]) != null
    //                       ? Image.file(
    //                     File(data.filepath),
    //                     fit: BoxFit.cover,
    //                   )
    //                       : CachedNetworkImage(
    //                     placeholder: (context, url) =>
    //                                 Center(child: CircularProgressIndicator(),
    //                                 heightFactor: 30,
    //                                 widthFactor: 30,),
    //                     errorWidget: (context, url, error) =>
    //                         Icon(Icons.error),
    //                     imageUrl: widget.map!["link"],
    //                     fit: BoxFit.cover,
    //                     // loadingBuilder: (BuildContext context,
    //                     //     Widget child,
    //                     //     ImageChunkEvent? loadingProgress) {
    //                     //   if (loadingProgress == null) return child;
    //                     //   return Center(
    //                     //     child: CircularProgressIndicator(
    //                     //       color: Colors.white,
    //                     //       value: loadingProgress.expectedTotalBytes !=
    //                     //               null
    //                     //           ? loadingProgress
    //                     //                   .cumulativeBytesLoaded /
    //                     //               loadingProgress.expectedTotalBytes!
    //                     //           : null,
    //                     //     ),
    //                     //   );
    //                     // },
    //                   ),
    //                 ),
    //                 Container(
    //                   padding: const EdgeInsets.symmetric(
    //                       vertical: 10, horizontal: 10),
    //                   alignment: Alignment.bottomRight,
    //                   child: Text(
    //                     DateFormat.jm().format(Timestamp(widget.map!["time"]["_seconds"] ,widget.map!["time"]["_nanoseconds"]).toDate()),
    //                     style: const TextStyle(
    //                         fontSize: 12,
    //                         color: Colors.white,
    //                         fontWeight: FontWeight.bold),
    //                   ),
    //                   constraints: BoxConstraints(
    //                     minWidth: size.width * 0.2,
    //                   ),
    //                 )
    //               ],
    //             )
    //                 : Container(
    //               height: size.width * 0.5,
    //               child: const Center(
    //                 child: CircularProgressIndicator(),
    //               ),
    //             ),
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    // );
  }
}
