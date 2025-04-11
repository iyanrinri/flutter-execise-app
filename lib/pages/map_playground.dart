import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';


class MapPlayground extends StatefulWidget {
  const MapPlayground({super.key});

  @override
  MapPlaygroundState createState() => MapPlaygroundState();
}

class MapPlaygroundState extends State<MapPlayground> with TickerProviderStateMixin {
  LatLng? currentLocation;
  final MapController _mapController = MapController();
  final LatLng _currentMapCenter = LatLng(0, 0);
  final double _currentMapZoom = 15.0;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) moveToCurrentLocation();
    });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void animatedMapMove(LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(
      begin: _currentMapCenter.latitude,
      end: destLocation.latitude,
    );

    final lngTween = Tween<double>(
      begin: _currentMapCenter.longitude,
      end: destLocation.longitude,
    );

    final zoomTween = Tween<double>(
      begin: _currentMapZoom,
      end: destZoom,
    );

    // Buat instance baru dan simpan ke variabel lokal
    final controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Simpan ke state jika perlu dispose nanti
    _animationController?.dispose(); // Dispose yang lama kalau ada
    _animationController = controller;

    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
    );

    controller.addListener(() {
      final lat = latTween.evaluate(animation);
      final lng = lngTween.evaluate(animation);
      final zoom = zoomTween.evaluate(animation);

      _mapController.move(LatLng(lat, lng), zoom);
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose(); // Dispose langsung, karena pakai variabel lokal
        if (identical(_animationController, controller)) {
          _animationController = null; // Clear kalau masih sama
        }
      }
    });

    controller.forward();
  }


  Future<void> moveToCurrentLocation() async {
    await _determinePosition();
    if (!mounted || currentLocation == null) return;
    animatedMapMove(currentLocation!, 15.0);
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Cek apakah layanan lokasi aktif
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Layanan lokasi tidak aktif.');
    }

    // Cek & minta permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permission lokasi ditolak.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Permission lokasi ditolak permanen.');
    }

    // Ambil lokasi sekarang
    Position position = await Geolocator.getCurrentPosition();
    if (!mounted) return; // 👈 Tambahkan ini

    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });

    // Delay sebentar untuk pastikan peta sudah render
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return; // 👈 Tambahkan ini
      animatedMapMove(currentLocation!, 15.0);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lokasi Saya")),
      body:
          currentLocation == null
              ? Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: currentLocation!,
                      initialZoom: 15.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c'],
                        userAgentPackageName: 'com.testing.app',
                        tileProvider: CancellableNetworkTileProvider(),
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: currentLocation!,
                            width: 80.0,
                            height: 80.0,
                            child: Icon(
                              Icons.location_pin,
                              color: Colors.blue,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: FloatingActionButton(
                      heroTag: "btnLocation",
                      backgroundColor: Colors.white,
                      onPressed: moveToCurrentLocation,
                      child: const Icon(Icons.my_location, color: Colors.black),
                    ),
                  )
                ],
              ),
    );
  }
}
