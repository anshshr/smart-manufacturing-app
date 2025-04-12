import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:smart_manufacturing/services/multilingual_chat_bot/services/langchain_service.dart';
import 'package:smart_manufacturing/services/notification_service.dart';

class InventoryAssetsMap extends StatefulWidget {
  @override
  _InventoryAssetsMapState createState() => _InventoryAssetsMapState();
}

class _InventoryAssetsMapState extends State<InventoryAssetsMap> {
  final MapController _mapController = MapController();
  LatLng? _userLocation;
  bool _isLoading = true;
  final List<Map<String, dynamic>> _allAssets = [
    {
      "name": "Motor 1",
      "location": LatLng(23.1868734, 72.6283038),
      "type": "motor",
      "status": "operational",
      "lastMaintenance": "2023-05-15",
      "nextMaintenance": "2023-11-15",
    },
    {
      "name": "Pump Station A",
      "location": LatLng(23.1866139, 72.6283417),
      "type": "pump",
      "status": "maintenance",
      "lastMaintenance": "2023-04-20",
      "nextMaintenance": "2023-10-20",
    },
    {
      "name": "Cooling Fan Unit",
      "location": LatLng(23.1864977, 72.6286408),
      "type": "fan",
      "status": "operational",
      "lastMaintenance": "2023-06-10",
      "nextMaintenance": "2023-12-10",
    },
    {
      "name": "Air Compressor",
      "location": LatLng(23.1866767, 72.6285754),
      "type": "compressor",
      "status": "operational",
      "lastMaintenance": "2023-05-01",
      "nextMaintenance": "2023-11-01",
    },
    {
      "name": "CNC Machine 5",
      "location": LatLng(23.1868410, 72.6287876),
      "type": "cnc",
      "status": "idle",
      "lastMaintenance": "2023-03-25",
      "nextMaintenance": "2023-09-25",
    },
    {
      "name": "Industrial Refrigeration Unit",
      "location": LatLng(23.1865840, 72.6294210),
      "type": "refrigeration",
      "status": "maintenance",
      "lastMaintenance": "2023-02-18",
      "nextMaintenance": "2023-08-18",
    },
    {
      "name": "Cold Storage Room",
      "location": LatLng(23.1865932, 72.6279951),
      "type": "coldstorage",
      "status": "operational",
      "lastMaintenance": "2023-01-30",
      "nextMaintenance": "2023-07-30",
    },
    {
      "name": "Motor 2",
      "location": LatLng(23.1875495, 72.6282760),
      "type": "motor",
      "status": "operational",
      "lastMaintenance": "2023-06-05",
      "nextMaintenance": "2023-12-05",
    },
  ];
  List<Map<String, dynamic>> _filteredAssets = [];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    loc.Location location = loc.Location();

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    loc.PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        _filterNearbyAssets();
        _isLoading = false;
      });
      _mapController.move(_userLocation ?? LatLng(23.1868734, 72.6283038), 17);
    } catch (e) {
      print("Error getting location: $e");
      // Fallback to default location if GPS fails
      setState(() {
        _userLocation = LatLng(23.1868734, 72.6283038);
        _filterNearbyAssets();
        _isLoading = false;
      });
      _mapController.move(_userLocation!, 17);
    }
  }

  void _filterNearbyAssets() {
    if (_userLocation == null) return;

    // Filter assets within 500m radius (factory premises)
    _filteredAssets =
        _allAssets.where((asset) {
          final distance = Geolocator.distanceBetween(
            _userLocation!.latitude,
            _userLocation!.longitude,
            asset["location"].latitude,
            asset["location"].longitude,
          );
          return distance <= 500; // 500m in meters
        }).toList();

    setState(() {});
  }

  IconData _getAssetIcon(String type) {
    switch (type) {
      case "motor":
        return Icons.electric_bolt;
      case "pump":
        return Icons.invert_colors;
      case "fan":
        return Icons.air;
      case "compressor":
        return Icons.compress;
      case "cnc":
        return Icons.precision_manufacturing;
      case "refrigeration":
      case "coldstorage":
        return Icons.ac_unit;
      default:
        return Icons.engineering;
    }
  }

  Color _getAssetColor(String status) {
    switch (status) {
      case "operational":
        return Colors.green;
      case "maintenance":
        return Colors.orange;
      case "idle":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter:
                          _userLocation ?? LatLng(23.1868734, 72.6283038),
                      initialZoom: 17,
                      minZoom: 15,
                      maxZoom: 30,
                      onMapReady: () {
                        setState(() {
                          _isLoading = false;
                        });
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      CurrentLocationLayer(
                        style: LocationMarkerStyle(
                          marker: DefaultLocationMarker(
                            color: Colors.blue,
                            child: Icon(
                              Icons.person_pin_circle,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          markerSize: Size(40, 40),
                          markerDirection: MarkerDirection.heading,
                        ),
                      ),
                      MarkerLayer(
                        markers: [
                          if (_userLocation != null)
                            Marker(
                              width: 50,
                              height: 50,
                              point: _userLocation!,
                              child: Icon(
                                Icons.person_pin_circle,
                                color: Colors.transparent,
                                size: 50,
                              ),
                            ),
                          ..._filteredAssets
                              .map(
                                (asset) => Marker(
                                  width: 40,
                                  height: 40,
                                  point: asset["location"],
                                  child: GestureDetector(
                                    onTap: () {
                                      _showAssetDetails(context, asset);
                                    },
                                    child: Icon(
                                      _getAssetIcon(asset["type"]),
                                      color: _getAssetColor(asset["status"]),
                                      size: 40,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search industrial assets...',
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _filteredAssets =
                                      _allAssets
                                          .where(
                                            (asset) => asset["name"]
                                                .toLowerCase()
                                                .contains(value.toLowerCase()),
                                          )
                                          .toList();
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _filteredAssets.length,
                              itemBuilder: (context, index) {
                                final asset = _filteredAssets[index];
                                final distance =
                                    _userLocation != null
                                        ? Geolocator.distanceBetween(
                                          _userLocation!.latitude,
                                          _userLocation!.longitude,
                                          asset["location"].latitude,
                                          asset["location"].longitude,
                                        ).toStringAsFixed(0)
                                        : 'N/A';

                                return ListTile(
                                  leading: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: _getAssetColor(
                                        asset["status"],
                                      ).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      _getAssetIcon(asset["type"]),
                                      color: _getAssetColor(asset["status"]),
                                    ),
                                  ),
                                  title: Text(
                                    asset["name"],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${distance}m • ${_formatType(asset["type"])} • ${asset["status"]}',
                                  ),
                                  trailing: Icon(Icons.chevron_right),
                                  onTap: () {
                                    _mapController.move(asset["location"], 18);
                                    _showAssetDetails(context, asset);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  String _formatType(String type) {
    switch (type) {
      case "motor":
        return "Motor";
      case "pump":
        return "Pump";
      case "fan":
        return "Fan";
      case "compressor":
        return "Compressor";
      case "cnc":
        return "CNC Machine";
      case "refrigeration":
        return "Refrigeration";
      case "coldstorage":
        return "Cold Storage";
      default:
        return type;
    }
  }

  void _showAssetDetails(BuildContext context, Map<String, dynamic> asset) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(asset["name"]),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Icon(_getAssetIcon(asset["type"])),
                  title: Text("Type"),
                  subtitle: Text(_formatType(asset["type"])),
                ),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getAssetColor(asset["status"]).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.circle,
                      color: _getAssetColor(asset["status"]),
                      size: 20,
                    ),
                  ),
                  title: Text("Status"),
                  subtitle: Text(asset["status"]),
                ),
                ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text("Last Maintenance"),
                  subtitle: Text(asset["lastMaintenance"] ?? "Not available"),
                ),
                ListTile(
                  leading: Icon(Icons.update),
                  title: Text("Next Maintenance"),
                  subtitle: Text(asset["nextMaintenance"] ?? "Not scheduled"),
                ),
                ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text("Coordinates"),
                  subtitle: Text(
                    "${asset["location"].latitude.toStringAsFixed(6)}, "
                    "${asset["location"].longitude.toStringAsFixed(6)}",
                  ),
                ),
              ],
            ),
            actions: [
              if (asset["status"] == "maintenance")
                TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      builder: (context) {
                        return FutureBuilder(
                          future:
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .where('role', isEqualTo: 'worker')
                                  .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Center(child: Text("Error loading users"));
                            }
                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(child: Text("No workers found"));
                            }
                            final users = snapshot.data!.docs;
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    "Assign Task to Worker",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: users.length,
                                    itemBuilder: (context, index) {
                                      final user = users[index].data();
                                      return Card(
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage:
                                                user['photoUrl'] != null
                                                    ? NetworkImage(
                                                      user['photoUrl'],
                                                    )
                                                    : null,
                                            child:
                                                user['photoUrl'] == null
                                                    ? Icon(Icons.person)
                                                    : null,
                                          ),
                                          title: Text(
                                            user['name'] ?? 'Worker',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(
                                            user['email'] ?? 'No email',
                                          ),
                                          trailing: Icon(Icons.arrow_forward),
                                          onTap: () async {
                                            try {
                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(users[index].id)
                                                  .collection('assignedTasks')
                                                  .add({
                                                    'assetName': asset['name'],
                                                    'assetType': asset['type'],
                                                    'status': asset['status'],
                                                    'lastMaintenance':
                                                        asset['lastMaintenance'],
                                                    'nextMaintenance':
                                                        asset['nextMaintenance'],
                                                    'coordinates': {
                                                      'latitude':
                                                          asset['location']
                                                              .latitude,
                                                      'longitude':
                                                          asset['location']
                                                              .longitude,
                                                    },
                                                    'assignedAt':
                                                        FieldValue.serverTimestamp(),
                                                  });

                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "Task assigned to ${user['email']}",
                                                  ),
                                                ),
                                              );
                                              await sendPushNotification(
                                                "You have been assigned a new task for ${asset['name']}",
                                              );
                                              // Send notification to the worker
                                              Navigator.pop(context);
                                            } catch (e) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "Failed to assign task: $e",
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Text("ASSIGN TASK"),
                ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("CLOSE"),
              ),
            ],
          ),
    );
  }
}
