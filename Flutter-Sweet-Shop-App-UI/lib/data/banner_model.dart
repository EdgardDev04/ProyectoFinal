class BannerModel {
  final int? id;
  final String image;

  BannerModel({this.id, required this.image});

  Map<String, dynamic> toMap() => {
    'id': id,
    'image': image,
  };

  static BannerModel fromMap(Map<String, dynamic> map) => BannerModel(
    id: map['id'],
    image: map['image'],
  );
}
