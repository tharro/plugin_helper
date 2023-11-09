import 'dart:io';
import 'dart:typed_data';

/// Relative [MyWidgetPhotoViewCustom]
class ImageElementModel {
  final String? url;
  final Uint8List? bytes;
  final File? file;

  ImageElementModel({this.url, this.bytes, this.file});
}
