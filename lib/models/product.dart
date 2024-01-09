class Product {
  String libele;
  double prix;
  int quantite;
  String imageURL;

  Product({
    required this.libele,
    required this.prix,
    required this.quantite,
    required this.imageURL,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      libele: map['libele'] ?? '',
      prix: map['prix'] ?? 0.0,
      quantite: map['quantite'] ?? 0,
      imageURL: map['imageURL'] ?? '',
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'libele': libele,
      'prix': prix,
      'quantite': quantite,
      'imageURL': imageURL,
    };
  }
}
