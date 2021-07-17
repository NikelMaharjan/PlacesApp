
import 'package:location/location.dart';
import 'package:places/src/api/dashboard/profile_api.dart';
import 'package:places/src/services/auth_rx_provider.dart';
import 'package:places/src/services/local/cache_provider.dart';
import 'package:places/src/services/local/db_provider.dart';

class DashBoardService{
  final AuthRxProvider authRxProvider;
  final DbProvider dbProvider;
  final CacheProvider cacheProvider;
  final ProfileApi api;


  DashBoardService({required this.authRxProvider, required this.dbProvider, required this.cacheProvider, required this.api});

  void setLocation(LocationData locationData){
    authRxProvider.addLocation(locationData);  //we add here locationData in authRx provider and we use that in explore service
  }
  void updateToken(String token) {
    api.updateToken(token);
  }
  Future<bool> logout() async {
    await dbProvider.clear();
    await cacheProvider.clear();
    authRxProvider.clear();
    return true;

  }
}