import 'package:dataly_app/fun.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RefHistory extends StatefulWidget {
  var reflist;
  RefHistory({Key? key, this.reflist}) : super(key: key);

  @override
  State<RefHistory> createState() => _RefHistoryState();
}

class _RefHistoryState extends State<RefHistory> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: widget.reflist.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  // index == 0
                  //     ? Row(children: [
                  //         Text("Email",
                  //             style: TextStyle(
                  //                 fontSize: 15.sp,
                  //                 fontWeight: FontWeight.bold,
                  //                 fontFamily: 'InriaSans',
                  //                 color: Color.fromARGB(255, 108, 77, 122))),
                  //                 Spacer(),
                  //         // Text("Date",
                  //         //     style: TextStyle(
                  //         //         fontSize: 15.sp,
                  //         //         fontWeight: FontWeight.bold,
                  //         //         fontFamily: 'InriaSans',
                  //         //         color: Color.fromARGB(255, 108, 77, 122))),
                  //         // Spacer(),
                  //         Text("Amount",
                  //             style: TextStyle(
                  //                 fontSize: 15.sp,
                  //                 fontWeight: FontWeight.bold,
                  //                 fontFamily: 'InriaSans',
                  //                 color: Color.fromARGB(255, 108, 77, 122))),
                  //         Spacer(),
                  //         SizedBox(
                  //             height: 2.h,
                  //             child: Text("Status"))
                  //       ])
                  //     : Container(),
                  Row(
                    children: [
                      Text("${widget.reflist[index]['email']}",
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'InriaSans',
                              color: Color.fromARGB(255, 108, 77, 122))),
                      Spacer(),
                      // Text("${widget.reflist[index]['date'].toDate()}",
                      //     style: TextStyle(
                      //         fontSize: 15.sp,
                      //         fontWeight: FontWeight.bold,
                      //         fontFamily: 'InriaSans',
                      //         color: Color.fromARGB(255, 108, 77, 122))),
                      Text("\ ${widget.reflist[index]['price']}",
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'InriaSans',
                              color: Color.fromARGB(255, 108, 77, 122))),
                      Spacer(),
                      SizedBox(
                          height: 2.h, child: Image.asset("assets/minus.png"))
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
