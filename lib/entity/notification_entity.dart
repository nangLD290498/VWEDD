import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class NotificationEntity extends Equatable {
  final String docID;
  final String content;
  final bool read ;
  final int type;
  final DateTime date;
  final String detailsID;
  final bool isNew;
  final int number;

  @override
  List<Object> get props => [
    docID,
    content,
    read,
    type,
    date,
    detailsID,
    isNew,
    number
  ];

  const NotificationEntity(
      this.docID,
      this.content,
      this.read,
      this.type,
      this.date,
      this.detailsID,
      this.isNew,
      this.number
      );

  @override
  String toString() {
    return 'NotificationEntity{$docID $content $read $type $date $detailsID $isNew, $number}';
  }

  Map<String, Object> toJson() {
    return {
      "docID": docID,
      "content": content,
      "read": read,
      "type": type,
      "date": date,
      "details_id": detailsID,
      "is_new": isNew,
      "number": number,
    };
  }

  static NotificationEntity fromJson(Map<String, Object> json) {
    return NotificationEntity(
      json["docID"] as String,
      json["content"] as String,
      json["read"] as bool,
      json["type"] as int,
      json["date"] as DateTime,
      json["details_id"] as String,
      json["is_new"] as bool,
      json["number"] as int,
    );
  }

  static NotificationEntity fromSnapshot(DocumentSnapshot snapshot) {
    Timestamp timestamp = snapshot.get("date");
    DateTime tempDate = timestamp.toDate();
    return NotificationEntity(
      snapshot.id,
      snapshot.get("content"),
      snapshot.get("read"),
      snapshot.get("type"),
      tempDate,
      snapshot.get("details_id"),
      snapshot.get("is_new"),
      snapshot.get("number"),
    );
  }

  Map<String, Object> toDocument() {
    return {
      "content": content,
      "read": read,
      "type": type,
      "date":date,
      "details_id":detailsID,
      "is_new": isNew,
      "number": number,
    };
  }
}