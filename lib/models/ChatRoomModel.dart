import 'package:uniconnect/models/MessageModel.dart';

class ChatRoomModel {
  String? chatroomid;
  Map<String, dynamic>? participants;
  String? lastMessage;
  bool? isseen;
  String? lastuid;
  ChatRoomModel({this.chatroomid, this.participants, this.lastMessage,this.isseen,this.lastuid});

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    isseen=map["isseen"];
    lastuid=map["lastuid"];
    chatroomid = map["chatroomid"];
    participants = map["participants"];
    lastMessage = map["lastmessage"];
  }

  Map<String, dynamic> toMap() {
    return {
      "lastuid": lastuid,
      "isseen": isseen,
      "chatroomid": chatroomid,
      "participants": participants,
      "lastmessage": lastMessage,
    };
  }
}
