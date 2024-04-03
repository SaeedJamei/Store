class AdminAddProductDto {
  final String tittle;
  final String? description , image;
  final int count, price;
  final List<dynamic> colors;
  final bool isActive;

  AdminAddProductDto(
    this.description,
    this.image,
    this.colors, {
    required this.tittle,
    required this.count,
    required this.price,
  })  : isActive = true;

  Map<String, dynamic> toJson() {
    return {
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
