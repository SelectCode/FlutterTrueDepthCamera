import 'package:cv_camera/cv_camera.dart';
import 'package:image/image.dart';

class ImageBuilder {
  late Image _current;

  factory ImageBuilder.fromCameraImage(CameraImage source) {
    final image = Image.fromBytes(
      source.width,
      source.height,
      source.getBytes(),
      format: Format.bgra,
      channels: Channels.rgba,
    );
    return ImageBuilder(image);
  }

  ImageBuilder(Image initial) {
    _current = initial;
  }

  ImageBuilder flipHorizontally() {
    _current = flipHorizontal(_current);
    return this;
  }

  ImageBuilder rotate(int degrees) {
    _current = copyRotate(_current, degrees);
    return this;
  }

  List<int> asJpg() {
    return encodeJpg(_current);
  }

  Image build() => _current;
}
