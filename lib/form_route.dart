import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:tipper_frontend/location_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class FormRoute extends StatefulWidget {
  const FormRoute({Key? key}) : super(key: key);

  @override
  State<FormRoute> createState() => _FormRouteState();
}

class _FormRouteState extends State<FormRoute> {
  int _activeCurrentStep = 0;

  LatLng? position;
  bool isHazardous = false;

  String numItems = "";
  final TextEditingController _numItemsController = TextEditingController();

  String description = "";
  final TextEditingController _descriptionController = TextEditingController();

  // dispose it when the widget is unmounted
  @override
  void dispose() {
    _numItemsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<LatLng> getCurrentLocation() async {
      final GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
      bool serviceEnabled = await geolocatorPlatform.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception("Please enable location services on your device");
      }
      LocationPermission permission = await geolocatorPlatform.checkPermission();
      if (permission == LocationPermission.denied) {
        openAppSettings();
        throw Exception("Please give the app permission to access location services");
      }
      Position currentLoc = await Geolocator.getCurrentPosition();
      position = LatLng(currentLoc.latitude, currentLoc.longitude);
      return LatLng(currentLoc.latitude, currentLoc.longitude);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a tip report')
      ),
      body:
        FutureBuilder<LatLng>(
          future: getCurrentLocation(),
          builder: (BuildContext context, AsyncSnapshot<LatLng> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              print(snapshot.data);
              return Stepper(
                  currentStep: _activeCurrentStep,
                  onStepContinue: () {
                    if (_activeCurrentStep < 2) {
                      setState(() {
                        _activeCurrentStep += 1;
                      });
                    }
                  },
                  onStepCancel: () {
                    if (_activeCurrentStep == 0) {
                      Navigator.pop(context);
                      return;
                    }
                    setState(() {
                      _activeCurrentStep -= 1;
                    });
                  },
                  steps: [
                    Step(
                        title: const Text('Location'),
                        content: SizedBox(
                            height: MediaQuery.of(context).size.height - 250,
                            child: LocationPicker(
                              currentLocation: position!,
                              onLocationChange: (LatLng point) {
                                print('**** Location has has been picked');
                                setState(() {
                                  position = point;
                                });
                              }
                            )
                        )
                    ),
                    Step(
                      title: const Text('Details'),
                      content: Column(
                        children: [
                          TextField(
                            controller: _numItemsController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (v) => {
                              setState(() {
                                numItems = _numItemsController.text;
                              })
                            },
                            decoration: const InputDecoration(
                              labelText: "Number of items (optional)",
                              hintText: "Number of items",
                                // border: InputBorder.none
                            )
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _descriptionController,
                            minLines: 4,
                            maxLines: 6,
                            decoration: const InputDecoration(
                              labelText: "Description (optional)",
                              hintText: "A few words about the fly tipping",
                              // border: InputBorder.none
                            ),
                            onChanged: (v) => {
                              setState(() {
                                description = v;
                              })
                            },

                          ),
                          const SizedBox(height: 20),
                          CheckboxListTile(
                            title: const Text("Contains hazardous items"),
                            value: isHazardous,
                            onChanged: (v) {
                              setState(() {
                                isHazardous = v!;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          )
                        ]
                      )
                    ),
                    const Step(title: Text('Photo'), content: Center(child: Text('Photo'))),
                  ],
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
