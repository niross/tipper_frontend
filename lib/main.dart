import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'constants.dart' as constants;
import 'homepage.dart';
import 'location_denied.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: constants.appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
          "/": (context) => const App()
      }
    );
  }
}

class LocationCheckStatus<bool, String> {
  bool? enabled;
  String? message;
  LocationCheckStatus(this.enabled, this.message);
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<LocationCheckStatus> hasLocationPermissions() async {
      final GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
      bool serviceEnabled = await geolocatorPlatform.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return LocationCheckStatus(false,  "Please enable location services on your device");
      }
      LocationPermission permission = await geolocatorPlatform.checkPermission();
      if (permission == LocationPermission.denied) {
        return LocationCheckStatus(false, "Please give the app permission to access location services");
      }
      return LocationCheckStatus(true, "");
    }

    return Scaffold(
      body: FutureBuilder<LocationCheckStatus>(
        future: hasLocationPermissions(),
        builder: (BuildContext context, AsyncSnapshot<LocationCheckStatus> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            if (snapshot.data!.enabled) {
              return const Homepage();
            }
            return Center(
                child: LocationDenied(
                  message: snapshot.data!.message
                )
            );
          }
          else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          }
          else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator()
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Determining location'),
              )
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children
            )
          );
        }
      )
    );
  }
}
