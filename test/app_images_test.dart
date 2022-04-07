import 'dart:io';

import 'package:themoviedb/resources/resources.dart';
import 'package:test/test.dart';

void main() {
  test('app_images assets test', () {
    expect(File(AppImages.boss).existsSync(), true);
    expect(File(AppImages.hancock).existsSync(), true);
  });
}
