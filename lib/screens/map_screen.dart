import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isReadOnly;

  const MapScreen(
      {this.initialLocation = const PlaceLocation(
          latitude: 40.718217, 
          longitude: -73.998284,
        ),
        this.isReadOnly = false,
        super.key}
      );

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedPosition;

void _selectPosition(LatLng position) {
    setState(() {
      _pickedPosition = position;
    });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select...'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (!widget.isReadOnly)
          IconButton(
            onPressed: _pickedPosition == null
            ? null
            : () {
              Navigator.of(context).pop(_pickedPosition); //só clica no check quando tiver posicao selecionada
              }, 
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude
            ),
          zoom: 13,
        ),
        onTap: widget.isReadOnly ? null : _selectPosition,
        markers: (_pickedPosition == null && !widget.isReadOnly) //mostra o marcador se for readOnly
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('p1'), //seleciona só um marcador
                  position: _pickedPosition ?? widget.initialLocation.toLatLng(), //transforma em lat lgn (add na classe o metodo)
                )
              },
      ),
    );
  }
}
