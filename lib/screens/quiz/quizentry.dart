import 'package:dataly_app/screens/quiz/quizinstructions.dart';
import 'package:go_router/go_router.dart';
import 'package:dataly_app/global_variable.dart' as globals;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../flutter_flow/flutter_flow_theme.dart';

class QuizentrypageWidget extends StatefulWidget {
  var quizdata;
  QuizentrypageWidget(this.quizdata, {Key? key,}) : super(key: key);

  @override
  _QuizentrypageWidgetState createState() => _QuizentrypageWidgetState();
}

class _QuizentrypageWidgetState extends State<QuizentrypageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  num quizScore = 0;
  bool quizNameExistsInList = false;
  checkQuizScore(String quizName) async {
    try{
      for (var item in globals.quiztrack) {
        if (item['quizname'] == quizName) {
          setState(() {
            quizScore = item['quizScore'];
            quizNameExistsInList = true;
          });
          break;
        } else {
          quizScore = 0;
          quizNameExistsInList = false;
        }
      }
      print('quizScore $quizScore quizNameExistsInList $quizNameExistsInList');

    }catch(e){
      print('quizNameExistsInList error $e');
    }


  }

  @override
  void initState() {
    checkQuizScore(widget.quizdata['name']);
    super.initState();
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
          child: Container(
            height: MediaQuery.of(context).size.height * 6,
            width: MediaQuery.of(context).size.width * 6,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional(0, 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.9,
                      height: 400,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: AlignmentDirectional(0, -0.45),
                              child: Text(
                                '${widget.quizdata['name']}',
                                style: FlutterFlowTheme.of(context)
                                    .bodyText1
                                    .override(
                                  fontFamily: 'Poppins',
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  fontSize: 37,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(0, 0.45),
                                  child: Text(
                                    'Test Questions: ',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                      fontFamily: 'Poppins',
                                      fontSize: 19,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(0, 0.45),
                                  child: Text(
                                    '${widget.quizdata['questionbucket'].length}',
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                      fontFamily: 'Poppins',
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0, 0.05),
                            child: Padding(
                              padding:
                              EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(0, -0.9),
                                    child: Text(
                                      'Total Time: ',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                        fontFamily: 'Poppins',
                                        fontSize: 19,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(0, -0.9),
                                    child: Text(
                                      ' ${widget.quizdata['quiztiming']} minutes',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                        fontFamily: 'Poppins',
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          quizNameExistsInList ? Align(
                            alignment: AlignmentDirectional(0, 0.05),
                            child: Padding(
                              padding:
                              EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(0, -0.9),
                                    child: Text(
                                      'Previous attempt score: ',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                        fontFamily: 'Poppins',
                                        fontSize: 19,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(0, -0.9),
                                    child: Text(
                                      '${quizScore}',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                        fontFamily: 'Poppins',
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ) : Container(),
                          Expanded(
                            child: Align(
                              alignment: AlignmentDirectional(0, 0.35),
                              child: GestureDetector(
                                onTap: () {
                                  print("dlksl");
                                  // Navigator.pushReplacement(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => Certificate()));

                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => Certificate()),
                                  // );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          InstructionspageWidget(
                                              widget.quizdata),
                                    ),
                                  );
                                  // GoRouter.of(context).pushNamed('/quizpage', queryParams: "${widget.quizdata}");
                                },
                                child: Container(
                                  width: 150,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryColor,
                                  ),
                                  child: Align(
                                    alignment: AlignmentDirectional(0, 0),
                                    child: Text(
                                      quizNameExistsInList ? 'Re-take Quiz' :
                                      'Start Quiz',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                        fontFamily: 'Poppins',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBtnText,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
