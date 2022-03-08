import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PluginPickerFile {
  static Future<PickedFile?> pickerFileCustom() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PickedFile file = PickedFile(result.files.single.path!);
      return file;
    } else {
      return null;
    }
  }

  static Future<XFile?> uploadImage({
    required BuildContext context,
    required bool isCamera,
    required Function({String type}) onError,
  }) async {
    try {
      bool isGranted = true;
      if (isCamera) {
        isGranted = await requestPermissionsCamera();
      }
      if (isGranted) {
        final imageFile = await ImagePicker().pickImage(
            source: isCamera ? ImageSource.camera : ImageSource.gallery,
            imageQuality: 50,
            maxWidth: 800,
            maxHeight: 1024);
        return imageFile;
      } else {
        onError(type: 'camera_access_denied');
        return null;
      }
    } catch (error) {
      await requestPermissionsCamera();
      PlatformException e = error as PlatformException;
      onError(type: e.code);
      throw e;
    }
  }

  static Future<List<XFile>> uploadMultiImage({
    required BuildContext context,
    required bool isLoading,
    Function? onLoading,
    Function? onEndLoading,
    required Function({String type}) onError,
  }) async {
    try {
      if (isLoading) {
        onLoading!();
      }
      final pickedFileList = await ImagePicker().pickMultiImage();
      return pickedFileList!;
    } catch (error) {
      if (isLoading) {
        onEndLoading!();
      }
      PlatformException e = error as PlatformException;
      onError(type: e.code);
      throw e;
    }
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
