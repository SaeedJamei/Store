class AdminHomeDto{
  final String tittle;
  final String? image, description;
  final List<String> colors;
  final int price, count, sellerId, id;
  final bool isActive;

  AdminHomeDto(
      this.image,
      this.description,
      this.colors, {
        required this.id,
        required this.tittle,
        required this.price,
        required this.sellerId,
        required this.count,
        required this.isActive,
      });

  Map<String , dynamic> toJson(){
    return {
      'id' : id ,
      'image' : image ,
      'description' : description ,
      'colors' : colors ,
      'tittle' : tittle ,
      'price' : price ,
      'sellerId' : sellerId ,
      'count' : count ,
      'isActive' : isActive ,
    };
  }
}