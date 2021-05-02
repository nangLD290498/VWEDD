import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class GuestEntity extends Equatable {
  String id;
  String name;
  String description;
  int status;
  String phone;
  int companion;
  String congrat;
  int money;
  int type;

  GuestEntity(
      this.id,
      this.name,
      this.description,
      this.status,
      this.phone,
      this.companion,
      this.congrat,
      this.money,
      this.type);

  @override
  List<Object> get props => [
    id,
    name,
    description,
    status,
    phone,
    companion,
    congrat,
    money,
    type
  ];

  Map<String, Object> toJson(){
    return {
      "id": id,
      "name": name,
      "description": description,
      "status": status,
      "phone": phone,
      "companion": companion,
      "congrat": congrat,
      "money": money,
      "type": type
    };
  }

  static GuestEntity fromJson(Map<String, Object> json){
    return GuestEntity(
        json["id"] as String,
        json["name "] as String,
        json["description"] as String,
        json["status"] as int,
        json["phone"] as String,
        json["companiton"] as int,
        json["congrat"] as String,
        json["money"] as int,
        json["type"] as int
    );
  }

  static GuestEntity fromSnapshot(DocumentSnapshot snapshot){
    return GuestEntity(
        snapshot.id,
        snapshot.get("name"),
        snapshot.get("description"),
        snapshot.get("status"),
        snapshot.get("phone"),
        snapshot.get("companion"),
        snapshot.get("congrat"),
        snapshot.get("money"),
        snapshot.get("type"),
    );
  }

  Map<String, Object> toDocument(){
    return {
      "name": name,
      "description": description,
      "status": status,
      "phone": phone,
      "companion": companion,
      "congrat": congrat,
      "money": money,
      "type": type,
    };
  }
}