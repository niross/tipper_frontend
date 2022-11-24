import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'constants.dart' as constants;
import 'logo.dart';
import 'main.dart';

class LocationDenied extends StatefulWidget {
  const LocationDenied({
    Key? key,
    required this.message
  }) : super(key: key);
  final String message;

  @override
  State<LocationDenied> createState() => _LocationDeniedState();
}

class _LocationDeniedState extends State<LocationDenied> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Reroute back to the home page if the user has switched back to this page
    // from somewhere else
    if (state == AppLifecycleState.resumed) {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 18),
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15)
    );

    return Scaffold(
        appBar: AppBar(
          title: const Text(constants.appTitle),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Logo(),
              const Text(
                constants.mainSubHeader,
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  widget.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 17),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                  style: style,
                  onPressed: () {
                    openAppSettings();
                  },
                  child: const Text('Update location settings')
              ),
            ],
          ),
        )
    );
  }
}
