import 'dart:async';
import 'package:flutter/services.dart';
import 'package:platform_comparison_plugin/domain_models.dart';
import '../comparison_plugin_platform_interface.dart';

/// Defining a channel for communication with native mobile platforms
/// The name of the channel must be the same as the one defined in native mobile platforms
const methodChannel = MethodChannel('platform_comparison_plugin');

class ComparisonPluginMobile extends ComparisonPluginPlatform {
  @override
  void startPluginFlow(
      {required String id, required Function(DomainEvent) callback}) async {
    // first, we fire logic for base abstract class
    super.startPluginFlow(id: id, callback: callback);

    // then, we set up method channel to handle calls from native mobile platforms
    methodChannel.setMethodCallHandler(handleMethodCall);

    // finally, we send method representing the start domain event & data
    // to native mobile platforms
    sendMethodForResult(
        DomainEventKeys.start, <String, dynamic>{DomainDataKeys.id: id});
  }

  @override
  Future<dynamic> sendMethodForResult(String method, dynamic arguments) async {
    methodChannel.invokeMethod<String>(method, arguments);
  }

  /// Platform->Dart communication handler specific for mobile platform implementation
  Future<dynamic> handleMethodCall(MethodCall call) async {
    handleDomainEvent(call.method);
  }

  @override
  void handleDomainEvent(String event) {
    switch (event) {
      case DomainEventKeys.success:
        externalFlowCallback(DomainEvent.success);
        break;
      case DomainEventKeys.error:
        externalFlowCallback(DomainEvent.error);
        break;
      case DomainEventKeys.processing:
        externalFlowCallback(DomainEvent.processing);
        break;
      case DomainEventKeys.start:
        // Stub; we don't want start to be handled in this direction
        break;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'Plugin for mobile doesn\'t implement \'$event\'',
        );
    }
  }
}
