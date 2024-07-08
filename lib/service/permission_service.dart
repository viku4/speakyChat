import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.contacts,
      Permission.photos,
      Permission.location,
      Permission.storage,
      Permission.camera,
      Permission.microphone,
      Permission.notification,
      Permission.audio,
      Permission.videos,
      Permission.manageExternalStorage,
      Permission.accessMediaLocation,
    ].request();

    // Handle the permission statuses
    statuses.forEach((permission, status) {
      if (status.isDenied) {
        // Handle permission denial
        print('${permission.toString()} permission denied');
      }
      if (status.isPermanentlyDenied) {
        // Handle permission permanently denied
        print('${permission.toString()} permission permanently denied');
      }
    });

    // Check for individual permissions
    if (await Permission.contacts.isGranted) {
      // The contact permission is granted
    }
    if (await Permission.photos.isGranted) {
      // The photos permission is granted
    }
    if (await Permission.location.isGranted) {
      // The location permission is granted
    }
    if (await Permission.storage.isGranted) {
      // The storage permission is granted
    }
    if (await Permission.camera.isGranted) {
      // The camera permission is granted
    }
    if (await Permission.microphone.isGranted) {
      // The microphone permission is granted
    }
    if (await Permission.notification.isGranted) {
      // The notification permission is granted
    }
    if (await Permission.audio.isGranted) {
      // The audio permission is granted
    }
    if (await Permission.accessMediaLocation.isGranted) {
      // The media location permission is granted
    }
    if (await Permission.mediaLibrary.isGranted) {
      // The media library permission is granted
    }
    if (await Permission.phone.isGranted) {
      // The phone permission is granted
    }
    if (await Permission.videos.isGranted) {
      // The videos permission is granted
    }
    if (await Permission.manageExternalStorage.isGranted) {
      // The manage external storage permission is granted
    }
    if (await Permission.accessMediaLocation.isGranted) {
      // The manage external storage permission is granted
    }
  }
}