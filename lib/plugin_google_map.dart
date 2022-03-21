import 'package:plugin_helper/models/google_map/address_detail_model.dart';
import 'package:plugin_helper/models/google_map/address_model.dart';
import 'package:plugin_helper/plugin_api.dart';
import 'package:plugin_helper/plugin_app_config.dart';

class MyPluginGoogleMap {
  static Future<ListAddressModel> searchAddress(
      {required String input,
      String? language = 'en',
      String? components = 'country:au',
      String? type = 'address'}) async {
    String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?key=' +
            MyPluginAppConfig().googleAPIKey!;
    url =
        '$url&input=$input&language=$language&components=$components&types=$type';
    try {
      final res = await MyPluginApi.request(url, Method.get);
      return ListAddressModel.fromJson(res.data);
    } catch (e) {
      rethrow;
    }
  }

  static Future<AddressDetailModel> getAddressDetail(
      {required String placeId}) async {
    String url =
        'https://maps.googleapis.com/maps/api/place/details/json?key=' +
            MyPluginAppConfig().googleAPIKey!;
    url = '$url&place_id=$placeId';
    try {
      final res = await MyPluginApi.request(url, Method.get);
      return AddressDetailModel.fromJson(res.data);
    } catch (e) {
      rethrow;
    }
  }
}
