class AdminEditProductDto {
  final String tittle;
  final String? description, image;
  final int count, price, id;
  final List<dynamic> colors;
  final bool isActive;

  AdminEditProductDto(
    this.description,
    this.image,
    this.colors, {
    required this.id,
    required this.tittle,
    required this.count,
    required this.price,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tittle': tittle,
      'description': description,
      'count': count,
      'price': price,
      'image': image,
      'colors': colors,
      'isActive': isActive,
    };
  }
}