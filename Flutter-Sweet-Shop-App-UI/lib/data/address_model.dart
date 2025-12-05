class AddressModel {
  final int? id;
  final String title;
  final String fullAddress;
  final bool isSelected;

  AddressModel({
    this.id,
    required this.title,
    required this.fullAddress,
    required this.isSelected,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'fullAddress': fullAddress,
      'isSelected': isSelected ? 1 : 0,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'],
      title: map['title'],
      fullAddress: map['fullAddress'],
      isSelected: map['isSelected'] == 1,
    );
  }
}
