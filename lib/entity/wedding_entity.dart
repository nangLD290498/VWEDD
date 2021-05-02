import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class WeddingEntity extends Equatable {
  String id;
  final DateTime weddingDate;

  WeddingEntity(this.id,this.weddingDate);

  @override
  List<Object> get props => [id, weddingDate];

  Map<String, Object> toJson() {
    return {"id": id,"wedding_date": weddingDate};
  }

  static WeddingEntity fromJson(Map<String, Object> json) {
    return WeddingEntity(json["id"] as String,
      DateTime.fromMillisecondsSinceEpoch((json["wedding_date"])),
    );
  }

  static WeddingEntity fromSnapshot(DocumentSnapshot snapshot) {
    return WeddingEntity(snapshot.id,
      snapshot.get("wedding_date") == null
          ? null
          : (snapshot.get("wedding_date") as Timestamp).toDate(),
    );
  }
}
