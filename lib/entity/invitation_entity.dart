import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class InvitationCartEntity extends Equatable {
  String id;
  String name;
  String url;

  InvitationCartEntity(
      this.id,
      this.name,
      this.url,);

  @override
  List<Object> get props => [
    id,
    name,
    url,
  ];

  Map<String, Object> toJson(){
    return {
      "id": id,
      "name": name,
      "url": url,
    };
  }

  static InvitationCartEntity fromJson(Map<String, Object> json){
    return InvitationCartEntity(
        json["id"] as String,
        json["name "] as String,
        json["url"] as String,
    );
  }

  static InvitationCartEntity fromSnapshot(DocumentSnapshot snapshot){
    return InvitationCartEntity(
      snapshot.id,
      snapshot.get("name"),
      snapshot.get("url"),
    );
  }

  Map<String, Object> toDocument(){
    return {
      "name": name,
      "url": url,
    };
  }
}