import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;

const GOOGLE_API_KEY = 'AIzaSyBXijySHTv0mkJWFyxtCYn9VdLKeFs8Gdc';
const MY_SIGNATURE = 'Nej2NjVss3RsnvUfh2hdOP2q3_k=';

class LocationUtil {
  static String generateLocationPreviewImage({
    double? latitude,
    double? longitude,
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=Brooklyn+Bridge,New+York,NY&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C40.718217,-73.998284&key=$GOOGLE_API_KEY&signature=$MY_SIGNATURE';
  }

  static Future<String> getAdressFrom(LatLng position) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$GOOGLE_API_KEY');
    final response = await http.get(url);
    return json
        .decode(response.body)['results'][0]['formatted_address']
        .toString();
  }
}
