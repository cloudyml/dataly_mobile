import 'package:flutter/material.dart';

class StartFreeBottomsheet extends StatefulWidget {
   StartFreeBottomsheet({Key? key,this.onTap}) : super(key: key);
  VoidCallback? onTap;
  @override
  State<StartFreeBottomsheet> createState() => _StartFreeBottomsheetState();
}

class _StartFreeBottomsheetState extends State<StartFreeBottomsheet> {
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      builder: (BuildContext context) {
        return InkWell(
          onTap: widget.onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 80,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Center(
              child: Container(
                height: 40,
                color: Color(0xFF7860DC),
                child: Center(
                  child: Text(
                    'Enroll Now For Free',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Medium',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

      },
      onClosing: () {},
    );
  }
}
