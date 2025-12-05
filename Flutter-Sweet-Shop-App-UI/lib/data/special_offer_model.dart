class SpecialOfferModel {
  final String bannerPath;
  final bool isFavorite;

  SpecialOfferModel({
    required this.bannerPath,
    required this.isFavorite,
  });

  factory SpecialOfferModel.fromMap(Map<String, dynamic> map) {
    return SpecialOfferModel(
      bannerPath: map['bannerPath'],
      isFavorite: map['isFavorite'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bannerPath': bannerPath,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  SpecialOfferModel copyWith({bool? isFavorite}) {
    return SpecialOfferModel(
      bannerPath: bannerPath,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
