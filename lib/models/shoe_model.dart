class Shoe {
  final int id;
  final String name;
  final String brand;
  final double price;
  final String category;
  final String description;
  final List<String> sizes;
  final List<String> colors;
  final List<String> images;
  final bool isFeatured;
  final bool isNewArrival;

  Shoe({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.category,
    required this.description,
    required this.sizes,
    required this.colors,
    required this.images,
    this.isFeatured = false,
    this.isNewArrival = false,
  });

  factory Shoe.fromMap(Map<String, dynamic> map) {
    return Shoe(
      id: map['id'],
      name: map['name'],
      brand: map['brand'],
      price: map['price'],
      category: map['category'],
      description: map['description'],
      sizes: List<String>.from((map['sizes'] as String).split(',')),
      colors: List<String>.from((map['colors'] as String).split(',')),
      images: List<String>.from((map['images'] as String).split(',')),
      isFeatured: map['is_featured'] == 1,
      isNewArrival: map['is_new_arrival'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'price': price,
      'category': category,
      'description': description,
      'sizes': sizes.join(','),
      'colors': colors.join(','),
      'images': images.join(','),
      'is_featured': isFeatured ? 1 : 0,
      'is_new_arrival': isNewArrival ? 1 : 0,
    };
  }
}
