
class NetworkResponseModel {

  final bool status;
  final String? message;   //may be null since error message can come or not
  dynamic data;   //dynamic one. can be string, model class, integer. inour case placemodel
  // or we can use final List<PlaceModel> instead of dynamic data. in this case UI code will be bit different

  NetworkResponseModel(
      {required this.status, this.message, this.data});
}
