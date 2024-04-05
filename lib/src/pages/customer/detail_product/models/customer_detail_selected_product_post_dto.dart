class CustomerDetailSelectedProductPostDto{
  final String tittle;
  final String? image, description;
  final List<String> colors;
  final int price, count, selectedCount, userId, productId;

  CustomerDetailSelectedProductPostDto(
      this.image,
      this.description,
      this.colors, {
        required this.userId,
        required this.productId,
        required this.tittle,
        required this.price,
        required this.count,
        required this.selectedCount,
      });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'productId': productId,
      'tittle': tittle,
      'description': description,
      'count': count,
      'price': price,
      'image': image,
      'colors': colors,
      'selectedCount': selectedCount,
    };
  }
}