import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/screens/map_screen.dart';
import 'package:great_places/utils/location_util.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPosition;

  const LocationInput(this.onSelectPosition, {super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  void _showPreview(double lat, double lng) {
    final staticMapImageUrl = LocationUtil.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    try {
    final locData = await Location().getLocation();

    _showPreview(locData.latitude!,locData.longitude!);

    widget.onSelectPosition(LatLng(
      locData.latitude!, 
      locData.longitude!
      ) //setar a localizacao atual quando selecionada
      );
    } catch (e) {
      return;
    }
  }
 
  Future<void> _selectOnMap() async {
    final LatLng selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => const MapScreen(), //é o .pop(), espera até retornar uma lat e long 
      ),
    );

     _showPreview(selectedLocation.latitude,selectedLocation.longitude);

    widget.onSelectPosition(selectedLocation); //seta a localizacao quando for selecionada
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 175,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _previewImageUrl == null 
          ? const Text('Location not informed')
          : Image.network(
            _previewImageUrl!,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _getCurrentUserLocation, 
              icon: const Icon(Icons.location_on), 
              label: const Text('Current location'),
              ),
              TextButton.icon(
              onPressed: _selectOnMap, 
              icon: const Icon(Icons.map), 
              label: const Text('Select on map'),
              ),
          ],
        )
      ],
    );
  }
}