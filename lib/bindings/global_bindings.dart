import 'package:get/get.dart';
import 'package:speaky_chat/controllers/media_preview_controller.dart';
import '../controllers/camera_screen_cont.dart';
import '../controllers/chat_screen_cont.dart';
import '../controllers/media_view_controller.dart';

class GlobalBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ChatScreenController>(() => ChatScreenController(),fenix: true);
    Get.lazyPut<CameraScreenController>(() => CameraScreenController(),fenix: true);
    Get.lazyPut<MediaPreviewController>(() => MediaPreviewController(),fenix: true);
    Get.lazyPut<MediaViewController>(() => MediaViewController(),fenix: true);
  }
}