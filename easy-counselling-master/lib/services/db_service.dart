import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thehappyclub/models/contact.dart';
import 'package:thehappyclub/models/conversation.dart';
import 'package:thehappyclub/models/message.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
class DBService {
  Firestore _db;
  static DBService instance = DBService();
  String _usersCollection = "Users";
  String _conversationsCollection = "Conversations";

  DBService() {
    _db = Firestore.instance;
  }

  Future createUser(
      String _uid, String _name, String _email, String _imageURL, int depression, int pornAddiction) async {
    try {
      return await _db.collection(_usersCollection).document(_uid).setData({
        "name": _name,
        "email": _email,
        "image": _imageURL,
        "lastSeen": DateTime.now().toUtc(),
        "depression": depression,
        "pornAddiction": pornAddiction,
        "wantsCounsellor" : false,
        "counsellor" : false,
      });
    } catch (e) {
      print(e);
    }
  }

  Future setDepression(String uid, int depression) async {
    try {
      return await _db.collection(_usersCollection).document(uid).updateData({"depression": depression});
    } catch (e) {
      print(e);
    }
  }

  Future setPornAddiction(String uid, int pornAddiction) async {
    try {
      return await _db.collection(_usersCollection).document(uid).updateData({"pornAddiction": pornAddiction});
    } catch (e) {
      print(e);
    }
  }

  Future setCounsellor(String uid, bool wantsCounsellor) async {
    try {
      return await _db.collection(_usersCollection).document(uid).updateData({"wantsCounsellor": wantsCounsellor});
    } catch (e) {
      print(e);
    }
  }

  Future updateUserLastSeen(String _userID) {
    var _ref = _db.collection(_usersCollection).document(_userID);
    return _ref.updateData({"lastSeen": Timestamp.now()});
  }
  
  Future updateUnseenCount(String _userID, String _conversationID){
    var _ref = _db.collection(_usersCollection).document(_userID).collection(_conversationsCollection).document(_conversationID);
    return _ref.updateData({"unseenCount" : 0});
  }

  Future sendMessage(String _conversationID, Message _message) {
    var _ref = _db.collection(_conversationsCollection).document(_conversationID);
    var _messageType;
    if (_message.type == MessageType.Text)
      _messageType = "text";
    else
      _messageType = "image";

    final plainText = _message.content;
    final key = encrypt.Key.fromUtf8(_conversationID.substring(0,16));
    final iv = encrypt.IV.fromUtf8(_conversationID.substring(0,16));
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);

    return _ref.updateData({
      "messages": FieldValue.arrayUnion([
        {
          "message": encrypted.base64,
          "senderID": _message.senderID,
          "timestamp": _message.timestamp,
          "type": _messageType
        }
      ])
    });
  }

  Future createConversation(String _currentID, String _recipientID, Future _onSuccess(String _conversationID)) async {
    var _ref = _db.collection(_conversationsCollection);
    var _userConversationReference =
        _db.collection(_usersCollection).document(_currentID).collection(_conversationsCollection);
    try {
      var conversation = await _userConversationReference.document(_recipientID).get();
      if (conversation.data != null) {
        return _onSuccess(conversation.data["conversationID"]);
      } else {
        var _conversationRef = _ref.document();
        await _conversationRef.setData({
          "members": [_currentID, _recipientID],
          "ownerID": _currentID,
          "messages": []
        });
        return _onSuccess(_conversationRef.documentID);
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<Contact> getUserData(String _userID) {
    var _ref = _db.collection(_usersCollection).document(_userID);
    return _ref.get().asStream().map((_snapshot) {
      return Contact.fromFirestore(_snapshot);
    });
  }

  Stream<List<ConversationSnippet>> getUserConversations(String _userID) {
    var _ref = _db.collection(_usersCollection).document(_userID).collection(_conversationsCollection);
    return _ref.snapshots().map((_snapshot) {
      return _snapshot.documents.map((_doc) {
        return ConversationSnippet.fromFirestore(_doc);
      }).toList();
    });
  }

  Stream<List<Contact>> getUsers(String _searchName) {
    var _ref = _db
        .collection(_usersCollection)
        .where("name", isGreaterThanOrEqualTo: _searchName)
        .where("name", isLessThan: _searchName + 'z');
    return _ref.getDocuments().asStream().map((_snapshot) {
      return _snapshot.documents.map((_doc) {
        return Contact.fromFirestore(_doc);
      }).toList();
    });
  }

  Stream<Conversation> getConversation(String _conversationID) {
    var _ref = _db.collection(_conversationsCollection).document(_conversationID);
    return _ref.snapshots().map(
      (_doc) {
        return Conversation.fromFirestore(_doc, _conversationID);
      },
    );
  }
}
