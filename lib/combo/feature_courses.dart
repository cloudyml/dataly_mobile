// Stack(
// children: [
// SingleChildScrollView(
// controller: _scrollController,
// child: Column(
// children: [
// SizedBox(
// height: 217,
// ),
//
// Padding(
// padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
// child: Align(
// alignment: Alignment.topLeft,
// child: Text(
// 'Courses you get(Scroll Down To See More)',
// textAlign: TextAlign.left,
// style: TextStyle(
// color: Color.fromRGBO(48, 48, 49, 1),
// fontFamily: 'Poppins',
// fontSize: 20,
// letterSpacing:
// 0 /*percentages not used in flutter. defaulting to zero*/,
// fontWeight: FontWeight.bold,
// height: 1),
// ),
// ),
// ),
// SizedBox(
// height: 10,
// ),
// Container(
// width: screenWidth,
// height: 350 * verticalScale,
// child: MediaQuery.removePadding(
// context: context,
// removeTop: true,
// child: ListView.builder(
// // controller: _scrollController,
// scrollDirection: Axis.vertical,
// // physics: NeverScrollableScrollPhysics(),
// itemCount: course.length,
// itemBuilder: (BuildContext context, index) {
// if (course[index].courseName == "null") {
// return Container();
// }
// var count = 0;
// List courseList = [];
// for (var i in widget.courses!) {
// for (var j in course) {
// if (i == j.courseId) {
// courseList.add(j);
// }
// }
// }
// print(
// "ttiititi${courseList[5].coursePrice}"); //widget.courses!.contains(course[index].courseId)
// if (courseList.length > index) {
// print(widget.courses);
// return Padding(
// padding: const EdgeInsets.only(
// bottom: 8.0, top: 8, left: 20.0, right: 20.0),
// child: InkWell(
// onTap: () {
// setState(() {
// courseId = courseList[index].courseDocumentId;
// });
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) =>
// const CatelogueScreen(),
// ),
// );
// },
// child: Container(
// width: 354 * horizontalScale,
// height: 133 * verticalScale,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.only(
// topLeft: Radius.circular(25),
// topRight: Radius.circular(25),
// bottomLeft: Radius.circular(25),
// bottomRight: Radius.circular(25),
// ),
// boxShadow: [
// BoxShadow(
// color: Color.fromRGBO(
// 58,
// 57,
// 60,
// 0.57,
// ),
// offset: Offset(2, 2),
// blurRadius: 3)
// ],
// color: Color.fromRGBO(233, 225, 252, 1),
// ),
// child: Row(
// //card on combopage
// mainAxisAlignment: MainAxisAlignment.start,
// crossAxisAlignment:
// CrossAxisAlignment.stretch,
// children: [
// SizedBox(width: 10),
// ClipRRect(
// borderRadius: BorderRadius.circular(25),
// child: Container(
// width: 130,
// height: 111,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.only(
// topLeft: Radius.circular(20),
// topRight: Radius.circular(20),
// bottomLeft: Radius.circular(20),
// bottomRight: Radius.circular(20),
// )),
// child: CachedNetworkImage(
// imageUrl:
// courseList[index].courseImageUrl,
// placeholder: (context, url) => Center(
// child:
// CircularProgressIndicator()),
// errorWidget: (context, url, error) =>
// Icon(Icons.error),
// ),
// ),
// ),
// SizedBox(width: 6),
// Column(
// crossAxisAlignment:
// CrossAxisAlignment.start,
// mainAxisAlignment:
// MainAxisAlignment.spaceEvenly,
// children: [
// // SizedBox(
// //   height: 10,
// // ),
// Container(
// width: 170,
// // height: 42,
// child: Text(
// courseList[index].courseName,
// overflow: TextOverflow.ellipsis,
// textScaleFactor: min(
// horizontalScale, verticalScale),
// style: TextStyle(
// color: Color.fromRGBO(0, 0, 0, 1),
// fontFamily: 'Poppins',
// fontSize: 18,
// letterSpacing: 0,
// fontWeight: FontWeight.bold,
// height: 1,
// ),
// ),
// ),
// // SizedBox(
// //   height: 5,
// // ),
// Container(
// width: 184 * horizontalScale,
// // height: 24.000001907348633,
// child: Text(
// courseList[index].courseDescription,
// // overflow: TextOverflow.ellipsis,
// textScaleFactor: min(
// horizontalScale, verticalScale),
// style: TextStyle(
// color:
// Color.fromRGBO(0, 0, 0, 1),
// fontFamily: 'Poppins',
// fontSize: 10,
// letterSpacing:
// 0 /*percentages not used in flutter. defaulting to zero*/,
// fontWeight: FontWeight.normal,
// height: 1),
// ),
// ),
// Row(
// children: [
// Text(
// '₹${courseList[index].coursePrice}',
// textAlign: TextAlign.left,
// textScaleFactor: min(
// horizontalScale,
// verticalScale),
// style: TextStyle(
// color: Color.fromRGBO(
// 155, 117, 237, 1),
// fontFamily: 'Poppins',
// fontSize: 25,
// letterSpacing:
// 0 /*percentages not used in flutter. defaulting to zero*/,
// fontWeight: FontWeight.bold,
// height: 1),
// ),
// SizedBox(
// width: 40 * horizontalScale,
// ),
// Container(
// width: 70 * horizontalScale,
// height: 25 * verticalScale,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.only(
// topLeft: Radius.circular(50),
// topRight: Radius.circular(50),
// bottomLeft:
// Radius.circular(50),
// bottomRight:
// Radius.circular(50),
// ),
// boxShadow: [
// BoxShadow(
// color: Color.fromRGBO(
// 48,
// 209,
// 151,
// 0.44999998807907104),
// offset: Offset(0, 10),
// blurRadius: 25)
// ],
// color: Color.fromRGBO(
// 48, 209, 151, 1),
// ),
// child: Center(
// child: Text(
// 'Enroll now',
// textAlign: TextAlign.left,
// textScaleFactor: min(
// horizontalScale,
// verticalScale),
// style: TextStyle(
// color: Color.fromRGBO(
// 255, 255, 255, 1),
// fontFamily: 'Poppins',
// fontSize: 10,
// letterSpacing:
// 0 /*percentages not used in flutter. defaulting to zero*/,
// fontWeight:
// FontWeight.normal,
// height: 1),
// ),
// ),
// )
// ],
// )
// ],
// ),
// ],
// ),
// ),
// ),
// );
// } else {
// return Container();
// }
// },
// ),
// ),
// ),
// SizedBox(
// height: 20,
// ),
// // includes(context),
// SizedBox(
// key: _positionKey,
// height: 20,
// ),
//
// // Container(
// //   key: _positionKey,
// // ),
// Ribbon(
// nearLength: 1,
// farLength: .5,
// title: ' ',
// titleStyle: TextStyle(
// color: Colors.black,
// // Colors.white,
// fontSize: 18,
// fontWeight: FontWeight.bold),
// color: Color.fromARGB(255, 11, 139, 244),
// location: RibbonLocation.topStart,
// child: Container(
// //  key:key,
// // width: width * .9,
// // height: height * .5,
// color: Color.fromARGB(255, 24, 4, 104),
// child: Padding(
// padding: const EdgeInsets.all(40.0),
// child: Column(
// //  key:Gkey,
// children: [
// SizedBox(
// height: screenHeight * .03,
// ),
// Text(
// 'Complete Course Fee',
// style: TextStyle(
// fontFamily: 'Bold',
// fontSize: 21,
// color: Colors.white),
// ),
// SizedBox(
// height: 5,
// ),
// Text(
// '( Everything with Lifetime Access )',
// style: TextStyle(
// fontFamily: 'Bold',
// fontSize: 11,
// color: Colors.white),
// ),
// SizedBox(
// height: 30,
// ),
// Text(
// '₹$coursePrice',
// style: TextStyle(
// fontFamily: 'Medium',
// fontSize: 30,
// color: Colors.white),
// ),
// SizedBox(height: 35),
// InkWell(
// onTap: () {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => PaymentScreen(
// map: comboMap,
// isItComboCourse: true,
// ),
// ),
// );
// },
// child: Container(
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(30),
// // boxShadow: [
// //   BoxShadow(
// //     color: Color.fromARGB(255, 176, 224, 250)
// //         .withOpacity(0.3),
// //     spreadRadius: 2,
// //     blurRadius: 3,
// //     offset: Offset(3,
// //         6), // changes position of shadow
// //   ),
// // ],
// color: Color.fromARGB(255, 119, 191, 249),
// gradient: gradient),
// height: screenHeight * .08,
// width: screenWidth * .6,
// child: Center(
// child: Text(
// 'Buy Now',
// textAlign: TextAlign.center,
// style: TextStyle(
// color: Colors.white, fontSize: 20),
// ),
// ),
// ),
// ),
// ],
// ),
// ),
// ),
// ),
// ],
// ),
// ),
// Container(
// width: 414 * horizontalScale,
// height: 217 * verticalScale,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.only(
// topLeft: Radius.circular(0),
// topRight: Radius.circular(0),
// bottomLeft: Radius.circular(25),
// bottomRight: Radius.circular(25),
// ),
// color: Color.fromRGBO(122, 98, 222, 1),
// ),
// child: Stack(
// children: [
// Positioned(
// top: -15 * verticalScale,
// right: -15 * horizontalScale,
// child: Container(
// width: 128 * min(horizontalScale, verticalScale),
// height: 128 * min(verticalScale, horizontalScale),
// decoration: BoxDecoration(
// color: Color.fromRGBO(129, 105, 229, 1),
// borderRadius: BorderRadius.all(
// Radius.elliptical(128, 128),
// ),
// ),
// ),
// ),
// Positioned(
// top: 80 * verticalScale,
// left: -31 * horizontalScale,
// child: Container(
// width: 62 * min(horizontalScale, verticalScale),
// height: 62 * min(verticalScale, horizontalScale),
// decoration: BoxDecoration(
// color: Color.fromRGBO(129, 105, 229, 1),
// borderRadius: BorderRadius.all(
// Radius.elliptical(62, 62),
// ),
// ),
// ),
// ),
// Positioned(
// top: 100 * verticalScale,
// left: 20 * horizontalScale,
// child: Container(
// // width: 60,
// // height: 81,
// child: Row(
// children: [
// InkWell(
// onTap: () {
// Navigator.pop(context);
// },
// child: Icon(
// Icons.arrow_back,
// color: Colors.white,
// size: 30 * min(horizontalScale, verticalScale),
// ),
// ),
// SizedBox(width: 7),
// Center(
// child: Container(
// width: 300,
// child: Text(
// name,
// textScaleFactor:
// min(horizontalScale, verticalScale),
// maxLines: 2,
// overflow: TextOverflow.ellipsis,
// style: TextStyle(
// overflow: TextOverflow.ellipsis,
// color: Color.fromRGBO(255, 255, 255, 1),
// fontFamily: 'Poppins',
// fontSize: 30,
// fontWeight: FontWeight.normal,
// ),
// ),
// ),
// ),
// ],
// ),
// ),
// ),
// ],
// ),
// ),
// ],
// )