import '../shared/test_resources.dart';

Object? mockInit(String methodName) {
  if (methodName == 'previewSize') {
    return TestResources.initialPreviewSizeJson;
  }
  return null;
}
