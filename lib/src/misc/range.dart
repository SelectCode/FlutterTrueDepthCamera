class Range<T extends Comparable> {
  final T lowerBound;
  final T upperBound;

  const Range(this.lowerBound, this.upperBound);

  bool contains(T value) {
    return value.compareTo(lowerBound) >= 0 && value.compareTo(upperBound) <= 0;
  }
}
