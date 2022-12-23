import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  final String id;
  final String email;
  final String image;
  final Timestamp lastSeen;
  final String name;
  final int depression;
  final int pornAddiction;

  Contact({this.id, this.email, this.image, this.name, this.lastSeen, this.depression, this.pornAddiction});

  factory Contact.fromFirestore(DocumentSnapshot _snapshot) {
    var _data = _snapshot.data;
    try {
      return Contact(
          id: _snapshot.documentID,
          lastSeen: _data["lastSeen"],
          email: _data["email"],
          name: _data["name"],
          image: _data["image"] ?? "",
          depression: _data["depression"].round(),
          pornAddiction: _data["pornAddiction"].round());
    }catch(e){
      print("in contact");
      print(e);
      return null;
    }
  }
}
