import 'package:cv_camera/cv_camera.dart';
import 'package:image/image.dart';

class ImageBuilder {
  late Image _current;

  factory ImageBuilder.fromCameraImage(CameraImage source) {
    final image = Image.fromBytes(
      width: source.width,
      height: source.height,
      bytes: source.planes[0].bytes.buffer,
      order: ChannelOrder.bgra,
      numChannels: 4,
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
    _current = copyRotate(_current, angle: degrees);
    return this;
  }

  List<int> asJpg() {
    return encodeJpg(_current);
  }

  Image build() => _current;
}
