
import 'package:themoviedb/configuration/configuration.dart';

class ImageDownloader{
  static String imageUrl(String path) {
    return Configuration.imageUrl + path;
  }
}