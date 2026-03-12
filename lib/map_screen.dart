import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _accessToken = String.fromEnvironment('MAPBOX_ACCESS_TOKEN');

  PointAnnotationManager? _pointAnnotationManager;

  // TODO: Replace with your real events + presence counts source.
  final _events = const <_EventPresence>[
    _EventPresence(
      id: 'almedalen',
      name: 'Almedalsveckan',
      lat: 57.6409,
      lng: 18.2960,
      presentNow: 128,
    ),
    _EventPresence(
      id: 'event-2',
      name: 'Afterparty',
      lat: 57.6432,
      lng: 18.2892,
      presentNow: 42,
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (_accessToken.isNotEmpty) {
      MapboxOptions.setAccessToken(_accessToken);
    }
  }

  @override
  void dispose() {
    _pointAnnotationManager?.deleteAll();
    _pointAnnotationManager = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mapbox native SDK is not available for Windows desktop targets.
    if (Platform.isWindows) {
      return _UnsupportedPlatform(
        title: 'Map is not available on Windows',
        subtitle:
            'Run on Android/iOS to use Mapbox. (We can also add a desktop fallback later.)',
      );
    }

    if (_accessToken.isEmpty) {
      return _UnsupportedPlatform(
        title: 'Missing Mapbox access token',
        subtitle:
            'Run with: flutter run --dart-define=MAPBOX_ACCESS_TOKEN=YOUR_TOKEN',
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: MapWidget(
        key: const ValueKey('mapbox-map'),
        cameraOptions: CameraOptions(
          center: Point(
            coordinates: Position(_events.first.lng, _events.first.lat),
          ),
          zoom: 12.0,
        ),
        styleUri: MapboxStyles.MAPBOX_STREETS,
        onMapCreated: _onMapCreated,
      ),
    );
  }

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    final annotations = mapboxMap.annotations;
    _pointAnnotationManager =
        await annotations.createPointAnnotationManager();

    await _renderEvents();
  }

  Future<void> _renderEvents() async {
    final mgr = _pointAnnotationManager;
    if (mgr == null) return;

    await mgr.deleteAll();

    for (final e in _events) {
      await mgr.create(
        PointAnnotationOptions(
          geometry: Point(coordinates: Position(e.lng, e.lat)),
          textField: '${e.presentNow}',
          textSize: 14.0,
          textColor: Colors.white.toARGB32(),
          textHaloColor: Colors.black.toARGB32(),
          textHaloWidth: 2.0,
          iconImage: 'marker-15',
          iconSize: 2.0,
          iconColor: const Color(0xFF9B59FF).toARGB32(),
        ),
      );
    }
  }
}

class _UnsupportedPlatform extends StatelessWidget {
  final String title;
  final String subtitle;

  const _UnsupportedPlatform({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  subtitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EventPresence {
  final String id;
  final String name;
  final double lat;
  final double lng;
  final int presentNow;

  const _EventPresence({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.presentNow,
  });
}

