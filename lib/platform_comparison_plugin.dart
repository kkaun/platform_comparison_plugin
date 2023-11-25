import 'package:flutter/foundation.dart';
import 'comparison_plugin_platform_interface.dart';
import 'domain_models.dart';

class PlatformComparisonPlugin {
  PlatformComparisonPlugin._privateConstructor();

  /// Creating a singleton instance of the plugin regardless of the platform
  static final PlatformComparisonPlugin instance =
      PlatformComparisonPlugin._privateConstructor();

  /// Starting plugin flow and checking for supported platforms
  void start(
      {required String id, required Function(DomainEvent) progressCallback}) {
    if (kIsWeb) {
      ComparisonPluginPlatform.web
          .startPluginFlow(id: id, callback: progressCallback);
    } else if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      ComparisonPluginPlatform.mobile
          .startPluginFlow(id: id, callback: progressCallback);
    } else {
      throw UnsupportedError(
          "Unsupported platform ${defaultTargetPlatform.toString()}");
    }
  }
}
