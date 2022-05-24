import 'package:image_picker/image_picker.dart';

Future<String?> pickMedia({bool isVideo = false, bool isCamera = false}) async {
  final ImagePicker _picker = ImagePicker();
  final XFile? _pickedFile = isVideo
      ? await _picker.pickVideo(source: ImageSource.gallery)
      : await _picker.pickImage(
          source: isCamera ? ImageSource.camera : ImageSource.gallery);

  return _pickedFile?.path;
}
