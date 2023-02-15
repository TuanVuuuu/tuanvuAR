part of '../../../libary/one_libary.dart';

class OneCacheManager {
  OneCacheManager._();
  static final customCacheManager = CacheManager(
    Config(
      'customCacheKey',
      stalePeriod: const Duration(days: 15),
      maxNrOfCacheObjects: 100,
    ),
  );
}
