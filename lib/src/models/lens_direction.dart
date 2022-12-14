enum LensDirection {
  front,
  back,
}

extension LensDirectionX on LensDirection {
  String get value {
    switch (this) {
      case LensDirection.front:
        return 'front';
      case LensDirection.back:
        return 'back';
    }
  }
}
