import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:plugin_helper/models/google_map/address_detail_model.dart';
import 'package:plugin_helper/models/google_map/address_model.dart';
import 'package:plugin_helper/plugin_api.dart';
import 'package:plugin_helper/plugin_app_config.dart';
import 'dart:ui' as ui;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

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

  static Future<BitmapDescriptor> getClusterBitmap(int size,
      {String? imageUrl}) async {
    try {
      final File markerImageFile =
          await DefaultCacheManager().getSingleFile(imageUrl!);
      final Uint8List markerImageBytes = await markerImageFile.readAsBytes();

      ui.Image image =
          await resizeAndConvertImage(markerImageBytes, size, size);
      return paintToCanvas(image, ui.Size.zero);
    } catch (e) {
      print(e);
      return defaultMarker(size);
    }
  }

  static ui.Canvas performCircleCrop(
      ui.Image image, ui.Size size, ui.Canvas canvas) {
    ui.Paint paint = ui.Paint();
    canvas.drawCircle(const ui.Offset(0, 0), 0, paint);

    double drawImageWidth = 0;
    double drawImageHeight = 0;

    ui.Path path = ui.Path()
      ..addOval(ui.Rect.fromLTWH(drawImageWidth, drawImageHeight,
          image.width.toDouble(), image.height.toDouble()));

    canvas.clipPath(path);
    canvas.drawImage(
        image, ui.Offset(drawImageWidth, drawImageHeight), Paint());
    return canvas;
  }

  static Future<ui.Image> loadUiImage(Uint8List list) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(list, (img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  static Future<ui.Image> resizeAndConvertImage(
    Uint8List data,
    int height,
    int width,
  ) async {
    img.Image baseSizeImage = img.decodeImage(data)!;
    img.Image resizeImage = img.copyResizeCropSquare(baseSizeImage, height);

    ui.Codec codec = await ui
        .instantiateImageCodec(Uint8List.fromList(img.encodePng(resizeImage)));
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  static Future<BitmapDescriptor> paintToCanvas(
      ui.Image image, ui.Size size) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = ui.Canvas(pictureRecorder);
    final paint = ui.Paint();
    paint.isAntiAlias = true;

    performCircleCrop(image, size, canvas);

    final recordedPicture = pictureRecorder.endRecording();
    ui.Image img = await recordedPicture.toImage(image.width, image.height);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(buffer);
  }

  static Future<BitmapDescriptor> defaultMarker(int size,
      {int? number, Color? colorMarker, TextStyle? textStyle}) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final ui.Canvas canvas = ui.Canvas(pictureRecorder);
    final ui.Paint paint1 = ui.Paint()..color = colorMarker ?? Colors.grey;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    if (number != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: '$number',
        style: textStyle ??
            TextStyle(
                fontSize: size / 3,
                color: Colors.white,
                fontWeight: FontWeight.normal),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }
}
