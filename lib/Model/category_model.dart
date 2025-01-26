class CategoryModel {
  String categoryId;
  String categoryImageurl;
  String categoryName;

  CategoryModel({
    required this.categoryId,
    required this.categoryImageurl,
    required this.categoryName,
  });

  // from json
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId:
          json['categoryid'] ?? '', // Provide default empty string if null
      categoryImageurl: json['categoryimageurl'] ?? '', // Provide default value
      categoryName: json['categoryname'] ?? '', // Provide default value
    );
  }

  // to json
  Map<String, dynamic> toJson() => {
        'categoryid': categoryId,
        'categoryimageurl': categoryImageurl,
        'categoryname': categoryName,
      };
}
