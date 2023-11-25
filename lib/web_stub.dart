import 'package:platform_comparison_plugin/comparison_plugin_platform_interface.dart';

/// Stub/Dummy class for web platform implementation
class ComparisonPluginWeb extends ComparisonPluginPlatform {
  @override
  handleDomainEvent(dynamic event) {
    throw UnimplementedError();
  }

  @override
  Future sendMethodForResult(String method, dynamic arguments) {
    throw UnimplementedError();
  }

  @override
  void startPluginFlow({required String id, required Function callback}) {
    throw UnimplementedError();
  }
}
