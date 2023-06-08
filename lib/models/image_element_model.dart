import 'dart:io';
import 'dart:typed_data';

class ImageElementModel {
  final String? url;
  final Uint8List? bytes;
  final File? file;

  ImageElementModel({this.url, this.bytes, this.file});
}
