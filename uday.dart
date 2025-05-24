import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Service {
  final IconData icon;
  final String title;
  final String description;

  Service(this.icon, this.title, this.description);
}

class MyApp extends StatelessWidget {
  final List<Service> services = [
    Service(Icons.music_note, "Music Production", "Create and edit music."),
    Service(Icons.video_camera_back, "Video Editing", "Craft compelling videos."),
    Service(Icons.design_services, "Graphic Design", "Design stunning visuals."),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Service Cards',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(services: services),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<Service> services;

  const HomeScreen({required this.services});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Our Services')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;
            return GridView.count(
              crossAxisCount: isWide ? 3 : 1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: services.map((service) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(serviceTitle: service.title),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(service.icon, size: 40, color: Colors.blue),
                          SizedBox(height: 12),
                          Text(service.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text(service.description, style: TextStyle(color: Colors.grey[700])),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String serviceTitle;

  const DetailScreen({required this.serviceTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(serviceTitle)),
      body: Center(
        child: Text(
          'You tapped on: $serviceTitle',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Ensure Firebase is initialized
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Service Cards',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class Service {
  final String title;
  final String description;
  final String iconName;

  Service({required this.title, required this.description, required this.iconName});

  factory Service.fromFirestore(Map<String, dynamic> data) {
    return Service(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      iconName: data['icon'] ?? 'help_outline',
    );
  }

  IconData get icon => IconsMap[iconName] ?? Icons.help_outline;
}

final Map<String, IconData> IconsMap = {
  'music_note': Icons.music_note,
  'video_camera_back': Icons.video_camera_back,
  'design_services': Icons.design_services,
  'support': Icons.support_agent,
  'analytics': Icons.analytics,
};

class HomeScreen extends StatelessWidget {
  Future<List<Service>> fetchServices() async {
    final snapshot = await FirebaseFirestore.instance.collection('services').get();
    return snapshot.docs.map((doc) => Service.fromFirestore(doc.data())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Services from Firestore')),
      body: FutureBuilder<List<Service>>(
        future: fetchServices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          if (snapshot.hasError)
            return Center(child: Text('Error loading services'));

          final services = snapshot.data ?? [];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;
                return GridView.count(
                  crossAxisCount: isWide ? 3 : 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: services.map((service) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailScreen(serviceTitle: service.title),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(service.icon, size: 40, color: Colors.blue),
                              SizedBox(height: 12),
                              Text(service.title,
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              Text(service.description,
                                  style: TextStyle(color: Colors.grey[700])),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String serviceTitle;

  const DetailScreen({required this.serviceTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(serviceTitle)),
      body: Center(
        child: Text(
          'You tapped on: $serviceTitle',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
