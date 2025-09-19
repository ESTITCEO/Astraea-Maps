import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  MapType _currentMapType = MapType.normal;

  final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(2.5142, -76.84939),
    zoom: 18,
  );
  final Set<Marker> _markers = {
    Marker(
      markerId: MarkerId("Brayan"),
      position: LatLng(2.5142, -76.84939),
      infoWindow: InfoWindow(title: "Mi CASA"),
    ),
  };
  void addMarket(LatLng latLong) async {
    TextEditingController _textController = TextEditingController();

    String? Title = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Añade un titulo"),
          content: TextField(
            controller: _textController,
            decoration: InputDecoration(hintText: "Casa..."),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(_textController.text),
              child: Text("Guardar"),
            ),
          ],
        );
      },
    );

    if (Title != null && Title.isNotEmpty) {
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId(latLong.toString()),
            position: latLong,
            infoWindow: InfoWindow(title: Title),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          "Astraea Maps",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<MapType>(
              value: _currentMapType,
              items: MapType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.toString().split('.').last.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _currentMapType = value!;
                });
              },
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: _initialPosition,
              onMapCreated: (controller) {
                _controller = controller;
              },
              mapType: _currentMapType,
              markers: _markers,
              onTap: (latLong) => addMarket(latLong),
            ),
          ),
        ],
      ),
    );
  }
}
