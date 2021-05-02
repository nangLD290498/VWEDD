import 'package:wedding_guest/model/category.dart';

abstract class CategoryRepository {
  Stream<List<Category>> getallCategory();
}
