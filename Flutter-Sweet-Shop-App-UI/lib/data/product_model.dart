class ProductModel {
  final int id;
  final String name;
  final double price;
  final double weight;
  final double rate;
  final String imageUrl;
  final String category;

  ProductModel({ 
    required this.id,
    required this.name,
    required this.price,
    required this.weight,
    required this.rate,
    required this.imageUrl,
    required this.category,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'price': price,
    'weight': weight,
    'rate': rate,
    'imageUrl': imageUrl,
  };

  factory ProductModel.fromMap(Map<String, dynamic> map) => ProductModel(
    id: map['id'],
    name: map['name'],
    price: map['price'],
    weight: map['weight'],
    rate: map['rate'],
    imageUrl: map['imageUrl'],
    category: map['category'],
  );

  get rating => null;
}
