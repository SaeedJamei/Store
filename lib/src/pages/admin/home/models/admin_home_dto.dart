class AdminHomeDto{
  final String tittle;
  final String? image, description;
  final List<dynamic> colors;
  final int price, count, id;
  final bool isActive;

  AdminHomeDto(
      this.image,
      this.description,
      this.colors, {
        required this.id,
        required this.tittle,
        required this.price,
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
      'count' : count ,
      'isActive' : isActive ,
    };
  }
}