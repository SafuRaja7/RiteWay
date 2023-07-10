// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

import 'package:riteway/configs/app.dart';
import 'package:riteway/configs/configs.dart';
import 'package:riteway/models/routes.dart';
import 'package:riteway/widgets/app_button.dart';

class ConfirmRideScreen extends StatefulWidget {
  final List<Map<String, dynamic>> drivers;
  final Routes routes;
  const ConfirmRideScreen({
    Key? key,
    required this.drivers,
    required this.routes,
  }) : super(key: key);

  @override
  State<ConfirmRideScreen> createState() => _ConfirmRideScreenState();
}

class _ConfirmRideScreenState extends State<ConfirmRideScreen> {
  String imageUrl = '';
  final Completer<GoogleMapController> _completer = Completer();
  // Points

  static const LatLng initPosition = LatLng(33.5467786, 73.181423);
  static const LatLng destination = LatLng(
    33.6291327,
    73.1135555,
  );

  List<LatLng> polyLine = [];
  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyALq9IYNlMduZ3__pwr4gWDBZf_h3wqSVA',
      PointLatLng(initPosition.latitude, initPosition.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    if (result.points.isNotEmpty) {
      // ignore: avoid_function_literals_in_foreach_calls
      result.points.forEach(
        (PointLatLng element) {
          polyLine.add(
            LatLng(element.latitude, element.longitude),
          );
        },
      );

      setState(() {});
    }
  }

  // currentLocation

  LocationData? currentLocation;
  void getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then((location) {
      currentLocation = location;
    });
    GoogleMapController googleMapController = await _completer.future;

    location.onLocationChanged.listen(
      (event) {
        currentLocation = event;
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 13.5,
              target: LatLng(
                event.latitude!,
                event.longitude!,
              ),
            ),
          ),
        );

        setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getPolyPoints();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.black,
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          currentLocation == null
              ? const Center(
                  child: Text("Loading"),
                )
              : SizedBox(
                  height: AppDimensions.normalize(300),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        currentLocation!.latitude!,
                        currentLocation!.longitude!,
                      ),
                      zoom: 14.5,
                    ),
                    polylines: {
                      Polyline(
                        polylineId: const PolylineId("route"),
                        points: polyLine,
                        color: AppTheme.c!.primary!,
                      ),
                    },
                    markers: {
                      Marker(
                        markerId: const MarkerId("currentLocation"),
                        position: LatLng(
                          currentLocation!.latitude!,
                          currentLocation!.longitude!,
                        ),
                      ),
                      const Marker(
                        markerId: MarkerId("source"),
                        position: initPosition,
                      ),
                      const Marker(
                        markerId: MarkerId("destination"),
                        position: destination,
                      ),
                    },
                    onMapCreated: (controller) {
                      _completer.complete(controller);
                    },
                  ),
                ),
          Container(
            color: Colors.white,
            height: AppDimensions.normalize(130),
            child: Column(
              children: [
                Space.y!,
                Text(
                  "Driver's Information",
                  style: AppText.b1,
                ),
                Space.y1!,
                ...widget.drivers.asMap().entries.map(
                  (e) {
                    final driverName = e.value['name'];
                    final cnic = e.value['cnic'];
                    final vehicleNumber = e.value['vehicleNumber'];
                    return Column(
                      children: [
                        Text(
                          'Name',
                          style: AppText.b1b,
                        ),
                        Space.y!,
                        Text(driverName.toString()),
                        Space.y!,
                        if (cnic != null)
                          const Text(
                            'CNIC',
                          ),
                        Space.y!,
                        Text(
                          cnic.toString(),
                        ),
                        Space.y!,
                        Text(
                          'Ride Fare',
                          style: AppText.b1b,
                        ),
                        Space.y!,
                        Text(widget.routes.fare.toString()),
                        Space.y!,
                        if (vehicleNumber != null) ...[
                          Text(
                            'Vehicle Number',
                            style: AppText.b1b,
                          ),
                          Space.y!,
                          Text(
                            vehicleNumber.toString(),
                          ),
                        ],
                      ],
                    );
                  },
                ).toList(),
                Space.y!,
                AppButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                          contentPadding: EdgeInsets.zero,
                          content: SizedBox(
                            height: AppDimensions.normalize(100),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                  ),
                                ),
                                const Image(
                                  image: AssetImage('assets/Easypaisa.png'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: const Text('View Payment Options'),
                ),
                Space.y!,
                AppButton(
                  child: const Text('Upload Reciept'),
                  onPressed: () async {
                    ImagePicker imagePicker = ImagePicker();
                    XFile? file = await imagePicker.pickImage(
                        source: ImageSource.gallery);

                    String uniqueFileName =
                        DateTime.now().millisecondsSinceEpoch.toString();

                    Reference reference = FirebaseStorage.instance.ref();
                    Reference reference2 = reference.child('images');
                    Reference finalRef = reference2.child(uniqueFileName);

                    try {
                      await finalRef.putFile(
                        File(file!.path),
                      );
                      imageUrl = await finalRef.getDownloadURL();
                      await FirebaseFirestore.instance
                          .collection('proofReciept')
                          .add({'image_url': imageUrl});
                    } catch (e) {
                      Text(e.toString());
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
