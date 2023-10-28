
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Providers/chat_screen_provider.dart';

// import 'package:swipe_to/swipe_to.dart';
String lastCurrentTag = '';

RegExp regExp = new RegExp(
    r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?',
    caseSensitive: false);
Widget showLinkInMessage(String message, context) {
// message = message.replaceAll("\n", " ");
  return
  // Wrap(
  //     children: List.generate(message.split(" ").length, (index) {
  //       return
  //         SelectableText.rich(
  //           regExp.firstMatch(message.split(" ")[index]) != null
  //               ? TextSpan(
  //             text: message.split(" ")[index].toString() + " ",
  //             recognizer: TapGestureRecognizer()
  //               ..onTap = () async {
  //                 if (await canLaunch(message.split(" ")[index])) {
  //                   await launch(message.split(" ")[index]);
  //                 } else {
  //                   throw 'Could not launch ${message.split(" ")[index]}';
  //                 }
  //               },
  //             style: TextStyle(color: HexColor("#0509f7"), fontSize: 18),
  //           )
  //               : TextSpan(
  //             text: message.split(" ")[index].toString(),
  //             recognizer: TapGestureRecognizer()
  //               ..onTap = () async {
  //                 if (await canLaunch(message.split(" ")[index])) {
  //                   await launch(message.split(" ")[index]);
  //                 } else {
  //                   throw 'Could not launch ${message.split(" ")[index]}';
  //                 }
  //               },
  //
  //             style: TextStyle(
  //               fontSize: 18,
  //               color: Colors.white,
  //             ),
  //           ),
  //         );
  //     }));
 SelectableText.rich(
     TextSpan(
         children: List.generate(message.split(" ").length, (index){

           return
             regExp.firstMatch(message.split(" ")[index]) != null
                 ? TextSpan(
               text: message.split(" ")[index].toString() + " ",
               recognizer: TapGestureRecognizer()
                 ..onTap = () async {
                   if (await canLaunch(message.split(" ")[index])) {
                     await launch(message.split(" ")[index]);
                   } else {
                     throw 'Could not launch ${message.split(" ")[index]}';
                   }
                 },
               style: TextStyle(color: HexColor("#0509f7"), fontSize: 18),
             )
                 : TextSpan(
               text: message.split(" ")[index].toString() + ' ',
               recognizer: TapGestureRecognizer()
                 ..onTap = () async {
                   if (await canLaunch(message.split(" ")[index])) {
                     await launch(message.split(" ")[index]);
                   } else {
                     throw 'Could not launch ${message.split(" ")[index]}';
                   }
                 },

               style: TextStyle(
                 fontSize: 18,
                 color: Colors.white,
               ),
             );
         }
         )
     ));

}

Widget MessageTile(size, map, displayName, currentTag, documentID, groupID,
    context, animation, _controller) {
  final providerChatScreenNotifier =
      Provider.of<ChatScreenNotifier>(context, listen: false);
  // var list = [];
  var listOfReplyMessageLink = [];
  var link = "";
  print("Mapmessage-----------------------${map}");

  print(map["message"]);

  // if(map["replyMessage"]!=null)
  //   {
  //     if(map["replyMessage"].contains("https"))
  //     {
  //       for(int i=0;i<map["replyMessage"].length;i++)
  //       {
  //         if(map["replyMessage"][i]!=" ")
  //         {
  //           link+=map["replyMessage"][i];
  //           if(i==map["replyMessage"].length-1)
  //           {
  //             listOfReplyMessageLink.add(link);
  //           }
  //         }
  //         else{
  //           listOfReplyMessageLink.add(link);
  //           link = "";
  //         }
  //       }
  //     }
  //   }
  // link = "";
  // if (map["message"].contains("https")) {
  //   for (int i = 0; i < map["message"].length; i++) {
  //     if (map["message"][i] != " ") {
  //       link += map["message"][i];
  //       if (i == map["message"].length - 1) {
  //         list.add(link);
  //       }
  //     } else {
  //       list.add(link);
  //       link = "";
  //     }
  //   }
  // }
  // String taggedNameText = '';
  // String untaggedText = '';
  // if (currentTag.toString().contains('@')) {
  //   taggedNameText = '$currentTag ';
  //   if (map['message'].toString().contains('@')) {
  //     untaggedText = map['message'].toString().replaceFirst(RegExp(r'@'),'');
  //   } else {
  //     untaggedText = map['message'].toString().replaceAll('$currentTag', '');
  //   }
  // } else {
  //   untaggedText = map['message'].toString();
  // }
  // lastCurrentTag = currentTag;
  var documentId;
  print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');

  return Container(
    // color:
    // data.selectedDocumentID.length!=0?data.selectedDocumentID.contains(documentID)?HexColor("#cafca2"):null:null,
    width: size.width,
    alignment: map!['sendBy'] == displayName
        ? Alignment.centerRight
        : Alignment.centerLeft,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.only(
        //   topLeft: map!["sendBy"] == displayName
        //       ? const Radius.circular(20)
        //       : const Radius.circular(0),
        //   bottomRight: const Radius.circular(20),
        //   bottomLeft: const Radius.circular(20),
        //   topRight: map!["sendBy"] == displayName
        //       ? const Radius.circular(0)
        //       : const Radius.circular(20),
        // ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.7),
        //     spreadRadius: 5,
        //     blurRadius: 5,
        //     offset: Offset(10, 10), // changes position of shadow
        //   ),
        // ],
        borderRadius: BorderRadius.circular(25),
        // gradient: const RadialGradient(
        //     center: Alignment.topRight,
        //     // near the top right
        //     radius: 6,
        //     colors: [
        //       Colors.purple,
        //       Colors.blue,
        //     ]),
        color: map!["sendBy"] == displayName
            ? HexColor("#6da2f7")
            : HexColor("#b3afb0"),
      ),
      constraints: BoxConstraints(
        maxWidth: size.width * 0.7,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              (map['sendBy']),
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          map["replySenderName"] != null
              ? Container(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  height: 60,
                  alignment: Alignment.topLeft,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ("@" + map['replySenderName'].toString()),
                            style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                overflow: TextOverflow.ellipsis),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            (map!['replyMessage'].toString()),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                overflow: TextOverflow.ellipsis),
                            textAlign: TextAlign.start,
                            maxLines: 2,
                          ),
                        ],
                      ))
                    ],
                  ),
                )
              : SizedBox(),
          Align(
              alignment: Alignment.topLeft,
              child: showLinkInMessage(map["message"].toString(), context)
              // SelectableText.rich(map["message"].contains("https")
              //     ? TextSpan(
              //         children: List.generate(list.length, (index) {
              //         return TextSpan(
              //           text: list[index] + " ",
              //           recognizer: TapGestureRecognizer()
              //             ..onTap = () async {
              //               if (list[index].contains("https")) {
              //                 if (await canLaunch(list[index])) {
              //                   await launch(list[index]);
              //                 } else {
              //                   throw 'Could not launch ${list[index]}';
              //                 }
              //               }
              //             },
              //           style: TextStyle(
              //             decoration: list[index].contains("https")
              //                 ? TextDecoration.underline
              //                 : null,
              //             color: list[index].contains("https")
              //                 ? HexColor("#0509f7")
              //                 : Colors.white,
              //             // fontWeight: FontWeight.bold,
              //             fontSize: 18,
              //           ),
              //         );
              //       }))
              //     : TextSpan(children: [
              //         TextSpan(
              //             text: map["message"],
              //             style: TextStyle(
              //               // decoration: list[index].contains("https")?TextDecoration.underline:null,
              //               color: Colors.white,
              //               // fontWeight: FontWeight.bold,
              //               fontSize: 18,
              //             )),
              //       ])),
              ///
              // SelectableText(
              //   map['message'],
              //   textWidthBasis: TextWidthBasis.parent,
              //   style: GoogleFonts.archivo(
              //     color: Colors.white,
              //     fontSize: 15,
              //   ),
              // ),
              ),
          SizedBox(
            height: 2,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              // "",
              DateFormat.jm().format(Timestamp(
                      map!["time"]["_seconds"], map!["time"]["_nanoseconds"])
                  .toDate()),
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    ),
  );
  // GestureDetector(
  // onHorizontalDragUpdate: (details) {
  //   if (details.delta.dx > -100) {
  //     print("Hello");
  //     print("RightSide");
  //     print(map["message"]);
  //     documentId = documentID;
  //     print("on right Swipe");
  //     print(map["message"]);
  //     print(map["replyMessage"].toString());
  //     providerChatScreenNotifier.focusNodeField(true);
  //     providerChatScreenNotifier.addReplyMessage(Expression: true,ReplySenderName: map!['sendBy'],ReplySenderMessage:
  //     map["message"],
  //         SenderName: displayName);

  //     print(providerChatScreenNotifier.replyMessage);
  //     _controller.forward().whenComplete((){
  //       _controller.reverse();
  //       documentId = null;
  //     });
  //   }
  // },
  // onHorizontalDragEnd: (DragEndDetails details) {
  // if (details.primaryVelocity! > 0) {
  //   // User swiped Left
  //
  //   print("LeftSide");
  //   print(map["message"]);
  // } else if (details.primaryVelocity! < 0) {
  //   // User swiped Right
  //
  // }

  // onLongPress: (){
  //   providerChatScreenNotifier.runTimeExpression?providerChatScreenNotifier.deleteChatText(ID: documentID,expression: false,removeID: false,runTime: true):null;
  //   print("onTapped");
  //   print(map["message"]);
  //   print("Deleted");
  // },
  // onTap: (){
  //   print("runtime ============== ${providerChatScreenNotifier.runTimeExpression}");
  //   if(providerChatScreenNotifier.runTimeExpression && providerChatScreenNotifier.selectedDocumentID.length!=0)
  //     {
  //       if(providerChatScreenNotifier.selectedDocumentID.contains(documentID) && providerChatScreenNotifier.selectedDocumentID.length!=0)
  //       {
  //         providerChatScreenNotifier.deleteChatText(ID: documentID,expression: false,removeID: true,runTime: true);
  //         print(providerChatScreenNotifier.selectedDocumentID);
  //         print("removed");
  //       }
  //       else
  //       {
  //         providerChatScreenNotifier.deleteChatText(ID: documentID,expression: false,removeID: false,runTime: true);
  //       }
  //     }

  // },
  // child:
  ///
  //     Consumer<ChatScreenNotifier>(
  //   builder: (context, data, child) {
  //     return
  //         SwipeTo(
  //         animationDuration: Duration(milliseconds: 10),
  //         onRightSwipe: (){
  //           print("on right Swipe");
  //           print(map["message"]);
  //           print(map["replyMessage"].toString());
  //           providerChatScreenNotifier.focusNodeField(true);
  //           providerChatScreenNotifier.addReplyMessage(Expression: true,ReplySenderName: map!['sendBy'],ReplySenderMessage:
  //           map["message"],
  //           SenderName: displayName);
  //           print(providerChatScreenNotifier.replyMessage);
  //         },
  //           child:
  //         SlideTransition(position: animation,
  //         child:
  //         documentId!=null?
  //         SlideTransition(
  //       position: animation,
  //       child: Container(
  //         color: data.selectedDocumentID.length != 0
  //             ? data.selectedDocumentID.contains(documentID)
  //                 ? HexColor("#cafca2")
  //                 : null
  //             : null,
  //         width: size.width,
  //         alignment: map!['sendBy'] == displayName
  //             ? Alignment.centerRight
  //             : Alignment.centerLeft,
  //         child: Container(
  //           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
  //           margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
  //           decoration: BoxDecoration(
  //             // borderRadius: BorderRadius.only(
  //             //   topLeft: map!["sendBy"] == displayName
  //             //       ? const Radius.circular(20)
  //             //       : const Radius.circular(0),
  //             //   bottomRight: const Radius.circular(20),
  //             //   bottomLeft: const Radius.circular(20),
  //             //   topRight: map!["sendBy"] == displayName
  //             //       ? const Radius.circular(0)
  //             //       : const Radius.circular(20),
  //             // ),
  //             // boxShadow: [
  //             //   BoxShadow(
  //             //     color: Colors.grey.withOpacity(0.7),
  //             //     spreadRadius: 5,
  //             //     blurRadius: 5,
  //             //     offset: Offset(10, 10), // changes position of shadow
  //             //   ),
  //             // ],
  //             borderRadius: BorderRadius.circular(25),
  //             // gradient: const RadialGradient(
  //             //     center: Alignment.topRight,
  //             //     // near the top right
  //             //     radius: 6,
  //             //     colors: [
  //             //       Colors.purple,
  //             //       Colors.blue,
  //             //     ]),
  //             color: map!["sendBy"] == displayName
  //                 ? HexColor("#6da2f7")
  //                 : HexColor("#b3afb0"),
  //           ),
  //           constraints: BoxConstraints(
  //             maxWidth: size.width * 0.7,
  //           ),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Align(
  //                 alignment: Alignment.topLeft,
  //                 child: Text(
  //                   (map['sendBy']),
  //                   style: TextStyle(
  //                       color: Colors.black,
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 13),
  //                   textAlign: TextAlign.start,
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 4,
  //               ),
  //               map["replySenderName"] != null
  //                   ? Container(
  //                       decoration: BoxDecoration(
  //                           color: Colors.blue,
  //                           borderRadius: BorderRadius.circular(10)),
  //                       height: 60,
  //                       alignment: Alignment.topLeft,
  //                       child: Row(
  //                         children: [
  //                           // SizedBox(width: 5,),
  //                           VerticalDivider(
  //                             indent: 5,
  //                             endIndent: 5,
  //                             color: Colors.purple,
  //                             width: 4,
  //                             thickness: 4,
  //                           ),
  //                           SizedBox(
  //                             width: 5,
  //                           ),
  //                           Expanded(
  //                               child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             children: [
  //                               Text(
  //                                 ("@" + map['replySenderName'].toString()),
  //                                 style: TextStyle(
  //                                     color: Colors.purple,
  //                                     fontWeight: FontWeight.bold,
  //                                     fontSize: 13,
  //                                     overflow: TextOverflow.ellipsis),
  //                                 textAlign: TextAlign.start,
  //                               ),
  //                               Text(
  //                                 (map!['replyMessage'].toString()),
  //                                 style: TextStyle(
  //                                     color: Colors.black,
  //                                     fontSize: 12,
  //                                     overflow: TextOverflow.ellipsis),
  //                                 textAlign: TextAlign.start,
  //                                 maxLines: 2,
  //                               ),
  //                             ],
  //                           ))
  //                         ],
  //                       ),
  //                     )
  //                   : SizedBox(),
  //               Align(
  //                 alignment: Alignment.topLeft,
  //                 child: SelectableText.rich(map["message"].contains("https")
  //                     ? TextSpan(
  //                         children: List.generate(list.length, (index) {
  //                         return TextSpan(
  //                           text: list[index] + " ",
  //                           recognizer: TapGestureRecognizer()
  //                             ..onTap = () async {
  //                               if (list[index].contains("https")) {
  //                                 if (await canLaunch(list[index])) {
  //                                   await launch(list[index]);
  //                                 } else {
  //                                   throw 'Could not launch ${list[index]}';
  //                                 }
  //                               }
  //                             },
  //                           style: TextStyle(
  //                             decoration: list[index].contains("https")
  //                                 ? TextDecoration.underline
  //                                 : null,
  //                             color: list[index].contains("https")
  //                                 ? HexColor("#0509f7")
  //                                 : Colors.white,
  //                             // fontWeight: FontWeight.bold,
  //                             fontSize: 18,
  //                           ),
  //                         );
  //                       }))
  //                     : TextSpan(children: [
  //                         TextSpan(
  //                             text: map["message"],
  //                             style: TextStyle(
  //                               // decoration: list[index].contains("https")?TextDecoration.underline:null,
  //                               color: Colors.white,
  //                               // fontWeight: FontWeight.bold,
  //                               fontSize: 18,
  //                             )),
  //                       ])),
  //
  //                 // SelectableText(
  //                 //   map['message'],
  //                 //   textWidthBasis: TextWidthBasis.parent,
  //                 //   style: GoogleFonts.archivo(
  //                 //     color: Colors.white,
  //                 //     fontSize: 15,
  //                 //   ),
  //                 // ),
  //               ),
  //               SizedBox(
  //                 height: 2,
  //               ),
  //               // Align(
  //               //   alignment: Alignment.bottomRight,
  //               //   child: Text(
  //               //     DateFormat('hh:mm a')
  //               //         .format(map!["time"] != null
  //               //         ? map!["time"].toDate()
  //               //         : DateTime.now())
  //               //         .toLowerCase(),
  //               //     style: TextStyle(
  //               //         fontSize: 12,
  //               //         color: Colors.white,
  //               //         fontWeight: FontWeight.bold),
  //               //   ),
  //               // )
  //             ],
  //           ),
  //         ),
  //       ),
  //     )
  //         :
  //     Container(
  //       color:
  //       data.selectedDocumentID.length!=0?data.selectedDocumentID.contains(documentID)?HexColor("#cafca2"):null:null,
  //       width: size.width,
  //       alignment: map!['sendBy'] == displayName
  //           ? Alignment.centerRight
  //           : Alignment.centerLeft,
  //       child: Container(
  //         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
  //         margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
  //         decoration: BoxDecoration(
  //           // borderRadius: BorderRadius.only(
  //           //   topLeft: map!["sendBy"] == displayName
  //           //       ? const Radius.circular(20)
  //           //       : const Radius.circular(0),
  //           //   bottomRight: const Radius.circular(20),
  //           //   bottomLeft: const Radius.circular(20),
  //           //   topRight: map!["sendBy"] == displayName
  //           //       ? const Radius.circular(0)
  //           //       : const Radius.circular(20),
  //           // ),
  //           // boxShadow: [
  //           //   BoxShadow(
  //           //     color: Colors.grey.withOpacity(0.7),
  //           //     spreadRadius: 5,
  //           //     blurRadius: 5,
  //           //     offset: Offset(10, 10), // changes position of shadow
  //           //   ),
  //           // ],
  //           borderRadius: BorderRadius.circular(25),
  //           // gradient: const RadialGradient(
  //           //     center: Alignment.topRight,
  //           //     // near the top right
  //           //     radius: 6,
  //           //     colors: [
  //           //       Colors.purple,
  //           //       Colors.blue,
  //           //     ]),
  //           color: map!["sendBy"] == displayName
  //               ? HexColor("#6da2f7")
  //               : HexColor("#b3afb0"),
  //         ),
  //         constraints: BoxConstraints(
  //           maxWidth: size.width * 0.7,
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Align(
  //               alignment: Alignment.topLeft,
  //               child: Text(
  //                 (map['sendBy']),
  //                 style: TextStyle(
  //                     color: Colors.black,
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 13
  //                 ),
  //                 textAlign: TextAlign.start,
  //               ),
  //             ),
  //             SizedBox(
  //               height: 4,
  //             ),
  //             map["replySenderName"]!=null?Container(
  //               decoration: BoxDecoration(
  //                   color: Colors.blue,
  //                   borderRadius: BorderRadius.circular(10)
  //               ),
  //               height: 60,
  //               alignment: Alignment.topLeft,
  //               child: Row(
  //                 children: [
  //                   // SizedBox(width: 5,),
  //                   VerticalDivider(
  //                     indent: 5,
  //                     endIndent: 5,
  //                     color: Colors.purple,
  //                     width: 4,
  //                     thickness: 4,
  //                   ),
  //                   SizedBox(width: 5,),
  //                   Expanded(child:
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Text(
  //                         ("@"+map['replySenderName'].toString()),
  //                         style: TextStyle(
  //                             color: Colors.purple,
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 13,
  //                             overflow: TextOverflow.ellipsis
  //                         ),
  //                         textAlign: TextAlign.start,
  //                       ),
  //                       Text(
  //                         (map!['replyMessage'].toString()),
  //                         style: TextStyle(
  //                             color: Colors.black,
  //                             fontSize: 12,
  //                             overflow: TextOverflow.ellipsis
  //                         ),
  //                         textAlign: TextAlign.start,
  //                         maxLines: 2,
  //                       ),
  //                     ],
  //                   ))
  //                 ],
  //               ),
  //             ):SizedBox(),
  //             Align(
  //               alignment: Alignment.topLeft,
  //               child:
  //               SelectableText.rich(
  //                   map["message"].contains("https")?
  //                   TextSpan(children:
  //                   List.generate(list.length, (index) {
  //                     return TextSpan(
  //                       text: list[index]+" ",
  //                       recognizer: TapGestureRecognizer()
  //                         ..onTap = () async{
  //                           if(list[index].contains("https"))
  //                           {
  //                             if (await canLaunch(list[index])) {
  //                               await launch(list[index]);
  //                             } else {
  //                               throw 'Could not launch ${list[index]}';
  //                             }
  //                           }
  //                         },
  //                       style: TextStyle(
  //                         decoration: list[index].contains("https")?TextDecoration.underline:null,
  //                         color: list[index].contains("https")?HexColor("#0509f7"):Colors.white,
  //                         // fontWeight: FontWeight.bold,
  //                         fontSize: 18,
  //                       ),
  //                     );
  //                   })
  //                   ):TextSpan(
  //                       children: [
  //                         TextSpan(
  //                             text: map["message"],
  //                             style: TextStyle(
  //                               // decoration: list[index].contains("https")?TextDecoration.underline:null,
  //                               color: Colors.white,
  //                               // fontWeight: FontWeight.bold,
  //                               fontSize: 18,
  //                             )),
  //                       ]
  //                   )
  //
  //               ),
  //
  //               // SelectableText(
  //               //   map['message'],
  //               //   textWidthBasis: TextWidthBasis.parent,
  //               //   style: GoogleFonts.archivo(
  //               //     color: Colors.white,
  //               //     fontSize: 15,
  //               //   ),
  //               // ),
  //             ),
  //             SizedBox(
  //               height: 2,
  //             ),
  //             Align(
  //               alignment: Alignment.bottomRight,
  //               child: Text(
  //                 DateFormat.jm().format(Timestamp(map!["time"]["_seconds"],map!["time"]["_nanoseconds"]).toDate()),
  //                 style: TextStyle(
  //                     fontSize: 12,
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.bold),
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //     )
  //     )
  //     )
  //     ;
  //   },
  // );
  // );
}
