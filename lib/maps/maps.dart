import 'package:url_launcher/url_launcher.dart';

class MapsUtils {
  MapsUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    final Uri googleMapUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');

    if (await canLaunchUrl(googleMapUrl)) {
      await launchUrl(
        googleMapUrl,
      );
    } else {
      throw 'Could not Open map';
    }
  }

  // text address

  static Future<void> openMapWithAddress(String fullAddress) async {
    String query = Uri.encodeQueryComponent(fullAddress);
    String googleMapUrl =
        'https://www.google.com/maps/search/?api=1&query=$fullAddress';
    if (await canLaunch(googleMapUrl)) {
      await launch(googleMapUrl);
    } else {
      throw 'Could not Open map';
    }
  }
}
