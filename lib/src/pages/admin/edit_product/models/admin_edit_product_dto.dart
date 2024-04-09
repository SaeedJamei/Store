class AdminEditProductDto {
  final String tittle;
  final String? description, image;
  final int count, price, sellerId, id;
  final List<String> colors;
  final bool isActive;

  AdminEditProductDto(
    this.description,
    this.image,
    this.colors, {
    required this.id,
    required this.tittle,
    required this.count,
    required this.price,
    required this.sellerId,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
