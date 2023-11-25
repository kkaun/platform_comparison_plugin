@JS()
library comparison_plugin_web;

import 'dart:async';
import 'dart:js_util';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:platform_comparison_plugin/domain_models.dart';
import '../comparison_plugin_platform_interface.dart';
import 'package:js/js.dart';

@JS('callDart')
external set _callJSHandler(void Function(dynamic event) f);

@JS('invokeJSFunction')
external dynamic _invokeJSFunction(String method, String? param);

@JS('additionalWebLogic')
external _performAdditionalWebLogic();

class ComparisonPluginWeb extends ComparisonPluginPlatform {
  /// We need to register web plugin implementation with registrar
  /// specifically for web
  static void registerWith(Registrar registrar) {
    // we can perform additional actions with registrar here
  }

  @override
  void startPluginFlow(
      {required String id, required Function(DomainEvent) callback}) async {
    //first, we fire logic for base abstract class
    super.startPluginFlow(id: id, callback: callback);

    //then, we set up JS->Dart communication
    _callJSHandler = allowInterop((dynamic event) {
      handleDomainEvent(event);
    });

    //finally, we send method representing the start domain event & data to JS
    sendMethodForResult(DomainEventKeys.start, id);
  }

  @override
  Future<dynamic> sendMethodForResult(String method, dynamic arguments) async {
    // we'll fire our default starter shout to JS with a straight function call
    _invokeJSFunction(method, arguments);
    // we're also free to perform some additional web-specific logic
    // and therefore check Promises to Future conversion with an approach below
    final optionalFutureResult =
        await promiseToFuture(_performAdditionalWebLogic());
    debugPrint(optionalFutureResult);
  }

  @override
  void handleDomainEvent(dynamic event) async {
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
        //Stub; we don't want start to be handled in this direction
        break;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'Plugin for web doesn\'t implement \'$event\'',
        );
    }
  }
}
