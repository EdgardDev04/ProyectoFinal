import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/flutter_map_widget.dart';
import '../../../core/widgets/general_app_bar.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final List<LatLng> storeBranches = [
      LatLng(18.5495, -69.9007), 
      LatLng(18.4550, -69.9800),
      LatLng(18.4850, -69.8000), 
      LatLng(18.5100, -70.0000), 
    ];

    return AppScaffold(
      appBar: GeneralAppBar(title: 'Ubicaciones de las tiendas', showBackIcon: false),
      padding: EdgeInsets.zero,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          FlutterMapWidget(
            center: LatLng(18.4861, -69.9312), 
            storeLocations: storeBranches,
          ),
        ],
      ),
    );
  }
}
