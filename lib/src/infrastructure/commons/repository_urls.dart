class RepositoryUrls{

  static const String webBaseUrl = '127.0.0.1:3000';

  static const String getUser = '/users';
  static const String postUser = '/users';
  static const String getProduct = '/products';
  static const String postProduct = '/products';
  static const String postSelectedProduct = '/selectedProducts';
  static const String getSelectedProducts = '/selectedProducts';
  static String getUserById({required int id})  => '/users/$id';
  static String patchProduct({required int id}) => '/products/$id';
  static String getProductById({required int id})  => '/products/$id';
  static String patchSelectedProduct({required int id}) => '/selectedProducts/$id';
  static String deleteSelectedProductById({required int id})  => '/selectedProducts/$id';

}