import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class MyPluginPickerFile {
  static Future<PickedFile?>? pickerFileCustom() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PickedFile file = PickedFile(result.files.single.path!);
      return file;
    }
    return null;
  }

  static Future<XFile?>? uploadSingleVideo(
      {required BuildContext context,
      required bool isCamera,
      required Function(String code) onError}) async {
    try {
      final videoFile = await ImagePicker().pickVideo(
          source: isCamera ? ImageSource.camera : ImageSource.gallery,
          preferredCameraDevice: CameraDevice.front);
      return videoFile;
    } catch (error) {
      if (error is PlatformException) {
        onError(error.code);
      } else {
        onError('-1');
      }
    }
    return null;
  }

  static Future<XFile?>? uploadSingleImage({
    required BuildContext context,
    required bool isCamera,
    required Function(String code) onError,
    double maxWidth = 1024,
    double maxHeight = 1024,
    int? imageQuality,
  }) async {
    try {
      final imageFile = await ImagePicker().pickImage(
          source: isCamera ? ImageSource.camera : ImageSource.gallery,
          imageQuality: imageQuality,
          maxWidth: maxWidth,
          maxHeight: maxHeight);
      return imageFile;
    } catch (error) {
      if (error is PlatformException) {
        onError(error.code);
      } else {
        onError('-1');
      }
    }
    return null;
  }

  static Future<List<XFile>?>? uploadMultiImage({
    required BuildContext context,
    Function()? onStartLoading,
    Function()? onEndLoading,
    required Function(String code) onError,
    double maxWidth = 1024,
    double maxHeight = 1024,
    int? imageQuality,
  }) async {
    try {
      if (onStartLoading != null) {
        onStartLoading();
      }
      final pickedFileList = await ImagePicker().pickMultiImage(
          imageQuality: imageQuality, maxWidth: maxWidth, maxHeight: maxHeight);
      return pickedFileList;
    } catch (error) {
      if (error is PlatformException) {
        onError(error.code);
      } else {
        onError('-1');
      }
    }
    if (onEndLoading != null) {
      onEndLoading();
    }
    return null;
  }

  static Future<bool> requestPermissionsCamera() async {
    var permission = await Permission.camera.status;

    if (permission != PermissionStatus.granted) {
      await Permission.camera.request();
      permission = await Permission.camera.status;
    }

    return permission == PermissionStatus.granted;
  }
}
