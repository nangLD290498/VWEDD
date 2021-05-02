import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String cateName;

  CategoryEntity(this.id, this.cateName);

  @override
  List<Object> get props => [id, cateName];
  Map<String, Object> toJson() {
    return {
      "id": id,
      "cate_name": cateName,
    };
  }

  static CategoryEntity fromJson(Map<String, Object> json) {
    return CategoryEntity(
      json["id"] as String,
      json["cate_name"] as String,
    );
  }

  static CategoryEntity fromSnapshot(DocumentSnapshot snapshot) {
    return CategoryEntity(
      snapshot.id,
      snapshot.get("cate_name"),
    );
  }

  Map<String, Object> toDocument() {
    return {
      "cate_name": cateName,
    };
  }
}
