class AdminAddProductDto {
  final String tittle;
  final String? description , image;
  final int count, price, sellerId;
  final List<String> colors;
  final bool isActive;

  AdminAddProductDto(
    this.description,
    this.image,
    this.colors, {
    required this.tittle,
    required this.count,
    required this.price,
    required this.sellerId,
  })  : isActive = true;

  Map<String, dynamic> toJson() {
    return {
      'tittle': tittle,
      'description': description,
      'count': count,
      'price': price,
      'sellerId': sellerId,
      'image': image,
      'colors': colors,
      'isActive': isActive,
    };
  }
}
