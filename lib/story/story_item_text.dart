// import 'package:cloudyml_app2/story/story_view_customised.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class StoryItemText extends StoryItem {
//   StoryItemText(Widget view, {required Duration duration, required String uniqueKey})
//       : super(view, duration: duration,uniqueKey: uniqueKey,viewedCount: "1");

//   static StoryItem text({
//     required String prefix,
//     required Color backgroundColor,
//     required String clickableText,
//     required String link,
//     Key? key,
//     String suffix = '',
//     TextStyle? textStyle,
//     bool shown = false,
//     bool roundedTop = false,
//     bool roundedBottom = false,
//     Duration? duration,
//     required String name,
//     String? viewedCount,
//   }) {
//     double contrast = ContrastHelper.contrast([
//       backgroundColor.red,
//       backgroundColor.green,
//       backgroundColor.blue,
//     ], [
//       255,
//       255,
//       255
//     ] /** white text */);

//     return StoryItem(
//       Container(
//         key: key,
//         decoration: BoxDecoration(
//           color: backgroundColor,
//           borderRadius: BorderRadius.vertical(
//             top: Radius.circular(roundedTop ? 8 : 0),
//             bottom: Radius.circular(roundedBottom ? 8 : 0),
//           ),
//         ),
//         padding: EdgeInsets.symmetric(
//           horizontal: 24,
//           vertical: 16,
//         ),
//         child: Center(
//           child: DefaultTextStyle(
//             style: textStyle?.copyWith(
//                   color: contrast > 1.8 ? Colors.white : Colors.black,
//                 ) ??
//                 TextStyle(
//                   color: contrast > 1.8 ? Colors.white : Colors.black,
//                   fontSize: 18,
//                 ),
//             textAlign: TextAlign.center,
//             child: Wrap(
//               children: [
//                 Text(prefix),
//                 InkWell(
//                   child: Text(
//                     clickableText,
//                     style: TextStyle(
//                         color: Colors.blue, decoration: TextDecoration.underline),
//                   ),
//                   onLongPress: () {
//                     debugPrint("Link is clicked");
//                     launchUrl(link as Uri);
//                   },
//                 ),
//                 Text(suffix)
//               ],
//             ),
//           ),
//         ),
//         //color: backgroundColor,
//       ),
//       duration: duration ?? Duration(seconds: 3),
//       uniqueKey: name,
//       viewedCount: viewedCount ?? "1",
//     );
//   }
// }
