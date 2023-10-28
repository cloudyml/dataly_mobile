import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloudyml_app2/api/firebase_api.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';
import 'package:cloudyml_app2/models/firebase_file.dart';
import 'package:cloudyml_app2/globals.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({Key? key}) : super(key: key);

  @override
  State<ReviewsScreen> createState() => _Review1State();
}

class _Review1State extends State<ReviewsScreen> {
  late Future<List<FirebaseFile>> futureFilesRR;
  late Future<List<FirebaseFile>> futureFilesCC;
  late Future<List<FirebaseFile>> futureFilesSMR;

  @override
  void initState() {
    super.initState();
    futureFilesRR = FirebaseApi.listAll('reviews/recent_review');
    futureFilesCC = FirebaseApi.listAll('reviews/combo_course_review');
    futureFilesSMR = FirebaseApi.listAll('reviews/social_media_review');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    double height = MediaQuery.of(context).size.height;
    var verticalScale = height / mockUpHeight;
    var horizontalScale = width / mockUpWidth;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Stack(
              children: [
                Container(
                  width: 414 * horizontalScale,
                  height: 180 * verticalScale,
                  decoration: BoxDecoration(
                    color: HexColor('7A62DE'),
                  ),
                ),
                Positioned(top:120 ,left: 75,
                  child: Container(alignment: Alignment.center,height: 40,width: 260,
                      decoration: BoxDecoration(
                          border: Border.fromBorderSide(
                              BorderSide(width: 1,color: Colors.deepPurple.shade700)),
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5)
                             )),
                      child: Text(
                        'Our learners speaks',textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.deepPurple.shade700,
                            fontWeight: FontWeight.bold),
                      )),
                ),
                Positioned(
                    top: 70 * verticalScale,
                    left: 160 * horizontalScale,
                    child: Container(
                      child: Row(
                        children: [
                          Text(
                            'Reviews',
                            textScaleFactor:
                                min(horizontalScale, verticalScale),
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    )),
                Positioned(
                    top: 55 * verticalScale,
                    left: 10 * horizontalScale,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        size: 40 * min(horizontalScale, verticalScale),
                        color: Colors.white,
                      ),
                    )),
              ],
            ),
          ),
          // SizedBox(
          //   height: 10,
          // ),
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              top: 10,
            ),
            child: Text(
              'Recent reviews',
              textScaleFactor: min(horizontalScale, verticalScale),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  height: 2),
            ),
          ),
          // SizedBox(
          //   height: 10,
          // ),
          Container(
            // height: screenHeight * 0.81 * verticalScale,
            height: 200,
            width: screenWidth,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: FutureBuilder<List<FirebaseFile>>(
              future: futureFilesRR,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError) {
                      return Center(
                          child: Text(
                        'Some error occurred!',
                        textScaleFactor: min(horizontalScale, verticalScale),
                      ));
                    } else {
                      final files = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              // physics: NeverScrollableScrollPhysics(),
                              itemCount: files.length,
                              itemBuilder: (context, index) {
                                final file = files[index];
                                return Container(
                                    decoration: BoxDecoration(
                                        color: HexColor("#FFFFFF"),
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey,
                                              blurRadius: 5,
                                              offset: Offset(0, 1))
                                        ]),
                                    margin: EdgeInsets.only(
                                        left: 10, top: 3, bottom: 3),
                                    padding: EdgeInsets.only(
                                        left: 5,
                                        right: 5,
                                        top: 5,
                                        bottom: 5),
                                    height: 180,
                                    width: 180,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  GestureDetector(
                                                      onTap: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        color:
                                                            Colors.transparent,
                                                        height: 400,
                                                        width: 300,
                                                        child: AlertDialog(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0),
                                                              side: BorderSide
                                                                  .none),
                                                          scrollable: true,
                                                          content:
                                                              CachedNetworkImage(
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
                                                            imageUrl: file.url,
                                                            fit: BoxFit.fill,
                                                            placeholder: (context,
                                                                    url) =>
                                                                Center(child: CircularProgressIndicator()),
                                                          ),
                                                        ),
                                                      )));
                                        },
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              Center(child: CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                          imageUrl: file.url,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ));
                                // buildFile(context, file);
                              },
                            ),
                          ),
                        ],
                      );
                    }
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              top: 10,
            ),
            child: Text(
              'Combo course reviews',
              textScaleFactor: min(horizontalScale, verticalScale),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  height: 2),
            ),
          ),
          // SizedBox(
          //   height: 10,
          // ),
          Container(

            height: 200,
            width: screenWidth,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: FutureBuilder<List<FirebaseFile>>(
              future: futureFilesCC,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError) {
                      return Center(
                          child: Text(
                        'Some error occurred!',
                        textScaleFactor: min(horizontalScale, verticalScale),
                      ));
                    } else {
                      final files = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              // physics: NeverScrollableScrollPhysics(),
                              itemCount: files.length,
                              itemBuilder: (context, index) {
                                final file = files[index];
                                return Container(
                                    decoration: BoxDecoration(
                                        color: HexColor("#FFFFFF"),
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey,
                                              blurRadius: 5,
                                              offset: Offset(0, 1))
                                        ]),
                                    margin: EdgeInsets.only(
                                        left: 15, top: 5, bottom: 5),
                                    padding: EdgeInsets.only(
                                        left: 5,
                                        right: 5,
                                        top: 5,
                                        bottom: 5),
                                    height: 180,
                                    width: 180,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  GestureDetector(
                                                      onTap: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        color:
                                                            Colors.transparent,
                                                        height: 400,
                                                        width: 300,
                                                        child: AlertDialog(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0),
                                                              side: BorderSide
                                                                  .none),
                                                          scrollable: true,
                                                          content:
                                                              CachedNetworkImage(
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
                                                            imageUrl: file.url,
                                                            fit: BoxFit.fill,
                                                            placeholder: (context,
                                                                    url) =>
                                                                Center(child: CircularProgressIndicator()),
                                                          ),
                                                        ),
                                                      )));
                                        },
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              Center(child: CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                          imageUrl: file.url,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ));
                                // buildFile(context, file);
                              },
                            ),
                          ),
                        ],
                      );
                    }
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              top: 10,
            ),
            child: Text(
              'Social media reviews',
              textScaleFactor: min(horizontalScale, verticalScale),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  height: 2),
            ),
          ),
          // SizedBox(height: 10),
          Container(
            height: 200,
            width: screenWidth,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: FutureBuilder<List<FirebaseFile>>(
              future: futureFilesSMR,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError) {
                      return Center(
                          child: Text(
                        'Some error occurred!',
                        textScaleFactor: min(horizontalScale, verticalScale),
                      ));
                    } else {
                      final files = snapshot.data!;
                     return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              // physics: NeverScrollableScrollPhysics(),
                              itemCount: files.length,
                              itemBuilder: (context, index) {
                                final file = files[index];
                                return Container(
                                    decoration: BoxDecoration(
                                        color: HexColor("#FFFFFF"),
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey,
                                              blurRadius: 5,
                                              offset: Offset(0, 1))
                                        ]),
                                    margin: EdgeInsets.only(
                                        left: 10, top: 3, bottom: 3),
                                    padding: EdgeInsets.only(
                                        left: 5,
                                        right:5,
                                        top: 5,
                                        bottom: 5),
                                    height: 180,
                                    width: 180,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  GestureDetector(
                                                      onTap: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        color:
                                                            Colors.transparent,
                                                        height: 400,
                                                        width: 300,
                                                        child: AlertDialog(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0),
                                                              side: BorderSide
                                                                  .none),
                                                          scrollable: true,
                                                          content:
                                                              CachedNetworkImage(
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
                                                            imageUrl: file.url,
                                                            fit: BoxFit.fill,
                                                            placeholder: (context,
                                                                    url) =>
                                                                Center(child: CircularProgressIndicator()),
                                                          ),
                                                        ),
                                                      )));
                                        },
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              Center(child: CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                          imageUrl: file.url,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ));
                                // buildFile(context, file);
                              },
                            ),
                          ),
                        ],
                      );
                    }
                }
              },
            ),
          )
        ],
      ),
    ));
  }
}
