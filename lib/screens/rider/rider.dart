import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riteway/app_routes.dart';
import 'package:riteway/configs/app.dart';
import 'package:riteway/configs/configs.dart';
import 'package:riteway/widgets/custom_text_field.dart';

class Rider extends StatefulWidget {
  const Rider({super.key});

  @override
  State<Rider> createState() => _RiderState();
}

class _RiderState extends State<Rider> {
  static const LatLng initPosition = LatLng(33.5467786, 73.181423);
  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Rider',
          style: AppText.b1!.cl(Colors.black),
        ),
      ),
      bottomSheet: const BottomSheet(),
      body: Column(
        children: [
          SizedBox(
            height: AppDimensions.normalize(200),
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: initPosition,
                zoom: 14.5,
              ),
              markers: {
                const Marker(
                  markerId: MarkerId("source"),
                  position: initPosition,
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BottomSheet extends StatelessWidget {
  const BottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Space.all(),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(
            thickness: 2,
            color: Colors.grey,
            indent: 165,
            endIndent: 165,
          ),
          Space.y!,
          Padding(
            padding: Space.h1!,
            child: Text(
              'Pickup Location',
              style: AppText.b1b,
            ),
          ),
          Padding(
            padding: Space.h!,
            child: Row(
              children: const [
                Icon(
                  Icons.location_on_sharp,
                  color: Colors.red,
                ),
                Expanded(
                  child: CustomTextField(
                    name: 'pickup location',
                    hint: 'Capital University of Science and Technology',
                    textInputType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                    enabled: false,
                  ),
                ),
              ],
            ),
          ),
          Space.y!,
          const Divider(
            thickness: 1,
            color: Colors.grey,
            indent: 50,
            endIndent: 50,
          ),
          Space.y!,
          Padding(
            padding: Space.h1!,
            child: Text(
              'Dropoff Location',
              style: AppText.b1b,
            ),
          ),
          Space.y1!,
          Padding(
            padding: Space.h!,
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_sharp,
                  color: Colors.red,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.routesNameScreen,
                    ),
                    child: const CustomTextField(
                      name: 'dropOff location',
                      hint: 'Choose Dropoff Location',
                      textInputType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      enabled: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Space.y2!,
        ],
      ),
    );
  }
}
