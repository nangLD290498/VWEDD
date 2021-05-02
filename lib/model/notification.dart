import 'package:flutter/cupertino.dart';
import 'package:equatable/equatable.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wedding_guest/entity/notification_entity.dart';

@immutable
class NotificationModel extends Equatable{
  String docID;
  String content;
  bool read;
  int type;
  DateTime date;
  String detailsID;
  bool isNew;
  int number;
//<editor-fold desc="Data Methods" defaultstate="collapsed">
  String getDate(){
    return "${date.day}/${date.month}/${date.year}";
  }
  // đã hoàn thành: type =0
  // chưa hoàn thành: type =1
  // guest type=2


  NotificationModel({this.docID,
    @required this.content,
    @required this.read,
    @required this.type,
    @required this.date,
    @required this.detailsID,
    @required this.isNew,
    @required this.number,
  });

  NotificationModel copyWith({
    String docID,
    String content,
    bool read,
    int type,
    String category,
    DateTime date,
    String detailsID,
    bool isNew,
    int number,
  }) {
    if ((docID == null || identical(docID, this.docID)) &&
        (content == null || identical(content, this.content)) &&
        (read == null || identical(read, this.read)) &&
        (type == null || identical(type, this.type)) &&
        (date == null || identical(date, this.date)) &&
        (detailsID == null || identical(detailsID, this.detailsID)) &&
        (isNew == null || identical(isNew, this.isNew)) &&
        (number == null || identical(number, this.number))
    ) {
      return this;
    }

    return new NotificationModel(
      docID: docID ?? this.docID,
      content: content ?? this.content,
      read: read ?? this.read,
      type: type ?? this.type,
      date: date ?? this.date,
      detailsID: detailsID ?? this.detailsID,
      isNew: isNew ?? this.isNew,
      number: number ?? this.number,
    );
  }

  @override
  String toString() {
    return 'Notification{$docID $content $read $type $date $detailsID $isNew, $number}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is NotificationModel &&
              runtimeType == other.runtimeType &&
              docID == other.docID &&
              content == other.content &&
              read == other.read &&
              type == other.type &&
              date == other.date &&
              detailsID == other.detailsID &&
              isNew == other.isNew &&
              number == other.number
          );

  @override
  int get hashCode =>
      docID.hashCode ^
      content.hashCode ^
      read.hashCode ^
      type.hashCode ^
      date.hashCode ^
      detailsID.hashCode ^
      isNew.hashCode ^
      number.hashCode ;

  NotificationEntity toEntity() {
    return NotificationEntity(docID, content, read, type, date, detailsID, isNew,number);
  }

  static NotificationModel fromEntity(NotificationEntity entity) {
    return NotificationModel(
      docID: entity.docID,
      content: entity.content,
      read: entity.read,
      type: entity.type,
      date: entity.date,
      detailsID: entity.detailsID,
      isNew: entity.isNew,
      number: entity.number,
    );
  }

  @override
  List<Object> get props => [docID,content,read,type,date,detailsID,isNew,number];

}