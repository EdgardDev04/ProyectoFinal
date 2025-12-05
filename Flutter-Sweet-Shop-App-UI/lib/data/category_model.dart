class CategoryModel {
  final int? id;
  final String title;
  final String image;

  CategoryModel({
    this.id,
    required this.title,
    required this.image,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'image': image,
  };

  static CategoryModel fromMap(Map<String, dynamic> map) =>
      CategoryModel(
        id: map['id'],
        title: map['title'],
        image: map['image'],
      );
}
