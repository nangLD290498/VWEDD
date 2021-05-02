import 'package:wedding_guest/entity/category_entity.dart';

class Category {
  final String id;
  final String cateName;

  Category(this.id, this.cateName);

  Category copyWith({
    String id,
    String cateName,
  }) {
    return Category(cateName ?? this.cateName, id ?? this.id);
  }

  CategoryEntity toEntity() {
    return CategoryEntity(id, cateName);
  }

  @override
  String toString() {
    return 'Category{id: $id, cateName: $cateName}';
  }

  bool operator ==(o) => o is Category && o.cateName == cateName && o.id == id;

  static Category fromEntity(CategoryEntity entity) {
    return Category(
      entity.id,
      entity.cateName,
    );
  }
}
