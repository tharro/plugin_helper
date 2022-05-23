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

  static Future<XFile?>? uploadSingleImage({
    required BuildContext context,
    required bool isCamera,
    required Function(String code) onError,
  }) async {
    try {
      final imageFile = await ImagePicker().pickImage(
          source: isCamera ? ImageSource.camera : ImageSource.gallery,
          imageQuality: 50,
          maxWidth: 800,
          maxHeight: 1024);
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
  }) async {
    try {
      if (onStartLoading != null) {
        onStartLoading();
      }
      final pickedFileList = await ImagePicker().pickMultiImage();
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
