class CustomerDetailSelectedProductViewModel{
  final String tittle;
  final String? image, description;
  final List<dynamic> colors;
  final int price, count, selectedCount, id, userId, productId;

  CustomerDetailSelectedProductViewModel(
      this.image,
      this.description,
      this.colors, {
        required this.id,
        required this.userId,
        required this.productId,
        required this.tittle,
        required this.price,
        required this.count,
        required this.selectedCount,
      });

  factory CustomerDetailSelectedProductViewModel.fromJson(Map<String, dynamic> json) {
    return CustomerDetailSelectedProductViewModel(
      json['image'],
      json['description'],
      json['colors'],
      id: json['id'],
      tittle: json['tittle'],
      price: json['price'],
      count: json['count'],
      userId: json['userId'],
      productId: json['productId'],
      selectedCount: json['selectedCount'],
    );
  }
}