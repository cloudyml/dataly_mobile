import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class ChatScreenNotifier extends ChangeNotifier{
  String text = "";
  bool ShouldShowTags = false;
  bool deleteChat = false;
  List selectedDocumentID = [];
  bool runTimeExpression = true;
  bool removeId = false;
  var filepath;
  var focusNode = FocusNode();
  bool focusNodeExpression = false;
  bool replyMessage = false;
  var replySenderName,replySenderMessageText,senderMessage,senderName;

  focusNodeField(bool expression){
    expression?focusNode.requestFocus():focusNode.unfocus();
    focusNodeExpression = expression;
    notifyListeners();
  }

  addReplyMessage({Expression,ReplySenderName,ReplySenderMessage,SenderMessage,SenderName})
  {
    replyMessage = Expression;
    replySenderName = ReplySenderName;
    replySenderMessageText = ReplySenderMessage;
    senderMessage = SenderMessage;
    senderName = SenderName;
    notifyListeners();
  }

  String sendTextMessage(str)
  {
    text = str;
    notifyListeners();
    return text;
  }

  bool showTags(bool expression)
  {
    ShouldShowTags = expression;
    notifyListeners();
    return ShouldShowTags;
  }

  filePath(imageFilePath)
  {
    filepath = imageFilePath;
    notifyListeners();
  }

  deleteChatText({ID,expression,removeID,runTime})
  {
    deleteChat = expression;
    runTimeExpression = runTime;
    removeId = removeID;
    if(deleteChat)
      {
        selectedDocumentID = [];
      }
    else {
      removeId?selectedDocumentID.remove(ID):null;
      runTimeExpression && !removeID?selectedDocumentID.add(ID):null;
    }
    notifyListeners();
  }

}
