import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:platform_comparison_plugin/domain_models.dart';
import 'package:platform_comparison_plugin/platform_comparison_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _receivedToken = false;
  bool _tokenIsCorrect = false;
  bool _isProcessing = false;

  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ID async platform validator'),
        ),
        body: Center(
            child: Column(children: [
          const SizedBox(height: 120),
          _receivedToken
              ? (_tokenIsCorrect
                  ? const Text('Successfully validated!')
                  : const Text('Validation failed!'))
              : !_receivedToken && _isProcessing
                  ? const CircularProgressIndicator()
                  : const SizedBox(),
          const SizedBox(height: 40),
          !_isProcessing
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Enter platform ID',
                        hintText: getStringIdDependingOnPlatform(),
                        errorText: _receivedToken && !_tokenIsCorrect
                            ? 'Please enter a valid platform ID'
                            : null,
                      ),
                      controller: _textController,
                    ),
                  ),
                )
              : const SizedBox(),
          const SizedBox(height: 20),
          !_isProcessing
              ? CupertinoButton(
                  child: const Text('Validate', style: TextStyle(fontSize: 18)),
                  onPressed: () {
                    PlatformComparisonPlugin.instance.start(
                        id: _textController.text,
                        progressCallback: (event) {
                          _processDomainEvent(event);
                        });
                  })
              : const SizedBox(),
        ])),
      ),
    );
  }

  void _processDomainEvent(DomainEvent event) {
    setState(() {
      _receivedToken = false;
      _tokenIsCorrect = false;
      _isProcessing = false;
      switch (event) {
        case DomainEvent.success:
          _receivedToken = true;
          _tokenIsCorrect = true;
          break;
        case DomainEvent.error:
          _receivedToken = true;
          _tokenIsCorrect = false;
          break;
        case DomainEvent.processing:
          _receivedToken = false;
          _isProcessing = true;
          break;
        default:
          //We won't show any additional info in those cases
          break;
      }
    });
  }

  String getStringIdDependingOnPlatform() {
    if (kIsWeb) {
      return 'WEB';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return 'ANDROID';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'IOS';
    } else {
      throw UnsupportedError(
          "Unsupported platform ${defaultTargetPlatform.toString()}");
    }
  }
}
