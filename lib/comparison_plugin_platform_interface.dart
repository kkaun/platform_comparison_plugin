import 'package:flutter/foundation.dart';
import 'package:platform_comparison_plugin/domain_models.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'comparison_plugin_mobile.dart';
import 'package:platform_comparison_plugin/web_stub.dart'
    if (dart.library.js) 'comparison_plugin_web.dart';

abstract class ComparisonPluginPlatform extends PlatformInterface {
  ComparisonPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static ComparisonPluginPlatform _instanceMobile = ComparisonPluginMobile();
  static ComparisonPluginPlatform _instanceWeb = ComparisonPluginWeb();

  static ComparisonPluginPlatform get mobile => _instanceMobile;
  static ComparisonPluginPlatform get web => _instanceWeb;

  /// Sets platform-specific implementation for mobile
  static set mobile(ComparisonPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instanceMobile = mobile;
  }

  /// Sets platform-specific implementation for web
  static set web(ComparisonPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instanceWeb = web;
  }

  /// Base callback for global business logic output (e.g. domain events)
  Function(DomainEvent)? _externalFlowCallback;

  Function(DomainEvent) get externalFlowCallback =>
      _externalFlowCallback ??
      (event) {
        debugPrint('Warning: externalFlowEndCallback is not set yet');
      };

  /// Base function to start platform plugin flow
  void startPluginFlow(
      {required String id, required Function(DomainEvent) callback}) {
    _externalFlowCallback = callback;
  }

  /// Base function to send a method & data which represent business logic input
  /// (e.g. domain event and id) to platform-specific implementation
  Future<dynamic> sendMethodForResult(String method, dynamic arguments);

  /// Base function to handle global business logic output (e.g. domain events),
  /// as well as unexpected platform interop structure changes/errors
  void handleDomainEvent(String event);
}
