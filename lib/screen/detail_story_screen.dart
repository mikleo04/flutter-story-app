import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:story_app/constant/result_state.dart';
import 'package:story_app/db/api_service.dart';
import 'package:story_app/model/list_story.dart';
import 'package:story_app/model/story.dart';
import 'package:story_app/provider/detail_story_provider.dart';
import 'package:geocoding/geocoding.dart' as geo;

class DetailStoryScreen extends StatefulWidget {
  final String storyId;
  const DetailStoryScreen({super.key, required this.storyId});

  @override
  State<DetailStoryScreen> createState() => _DetailStoryScreenState();
}

class _DetailStoryScreenState extends State<DetailStoryScreen> {
  late final ListStory listStory;
  late GoogleMapController mapController;
  final Set<Marker> markers = {};
  // String? adress;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetailStoryProvider>(
      create: (_) => DetailStoryProvider(
          apiService: ApiService(http.Client()), storyId: widget.storyId),
      child: Scaffold(body: Consumer<DetailStoryProvider>(
        builder: (context, provider, _) {
          if (provider.state == ResultState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.state == ResultState.hasData) {
            return buildDetailStory(context, provider);
          } else if (provider.state == ResultState.noData) {
            return const Center(
              child: Column(
                children: [
                  Icon(Icons.warning_rounded),
                  Text("Data tidak tersedia !"),
                ],
              ),
            );
          } else if (provider.state == ResultState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.warning_rounded),
                  const Text("Upps tidak terhubung ke error !"),
                  const SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      provider.fecthDeatilStory(widget.storyId);
                    },
                    child: const Text("Refresh"),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.warning_rounded),
                  const Text("Upps tidak terhubung ke internet !"),
                  const SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      provider.fecthDeatilStory(widget.storyId);
                    },
                    child: const Text("Refresh"),
                  ),
                ],
              ),
            );
          }
        },
      )),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Future<String> getAdreess(Story detailStory) async {
    if (detailStory.lat != null && detailStory.lon != null) {
      final location = await geo.placemarkFromCoordinates(
          detailStory.lat!, detailStory.lon!);
      final place = location[0];
      final adress =
          "${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
      return adress;
    }
    return "The Story do not have maps";
  }

  Scaffold buildDetailStory(
      BuildContext context, DetailStoryProvider provider) {
    var detailStory = provider.result.story;
    if (detailStory.lat != null && detailStory.lon != null) {
      final locationStory = LatLng(detailStory.lat!, detailStory.lon!);

      final marker = Marker(
        markerId: const MarkerId("location story"),
        position: locationStory,
        onTap: () {
          mapController.animateCamera(
            CameraUpdate.newLatLngZoom(locationStory, 18),
          );
        },
      );
      markers.add(marker);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Story"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Hero(
                  tag: detailStory.photoUrl,
                  child: Image.network(
                    detailStory.photoUrl,
                    height: 400,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(children: [
                const Icon(
                  Icons.person,
                  color: Colors.grey,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  detailStory.name,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
              const SizedBox(height: 8.0),
              Row(children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  color: Colors.grey,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  detailStory.createdAt.toString(),
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ]),
              const SizedBox(height: 8.0),
              Row(children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: const Icon(
                    Icons.note_alt_rounded,
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey, // Line color
                          width: 1.0, // Line width
                        ),
                      ),
                    ),
                    child: Text(
                      detailStory.description,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ]),
              Row(children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey, // Line color
                          width: 1.0, // Line width
                        ),
                      ),
                    ),
                    child: FutureBuilder<String>(
                      future: getAdreess(detailStory),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // Display a loading indicator while waiting for the future
                        } else if (snapshot.hasError) {
                          return Text(
                              'Error: ${snapshot.error}'); // Display an error message if the future fails
                        } else {
                          return Text(snapshot.data ??
                              ''); // Display the result if the future completes successfully
                        }
                      },
                    ),
                  ),
                ),
              ]),
              const SizedBox(
                height: 10,
              ),
              detailStory.lat != null && detailStory.lon != null
                  ? SizedBox(
                      height: 200,
                      child: GoogleMap(
                        markers: markers,
                        initialCameraPosition: CameraPosition(
                            zoom: 18,
                            target: LatLng(detailStory.lat!, detailStory.lon!)),
                        onMapCreated: (controller) {
                          setState(() {
                            mapController = controller;
                          });
                        },
                      ),
                    )
                  : const SizedBox(height: 5),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
