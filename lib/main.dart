import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riphah Flutter Assignment',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey[50],
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

// -----------------------------------------------------------------------------
// 1. SPLASH SCREEN WITH ANIMATION (3 Seconds Timer)
// -----------------------------------------------------------------------------
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    // Navigate automatically to Main Navigation Screen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainNavigationScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.school,
                    size: 80,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Riphah International University',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Flutter Multi-Screen Application',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 40),
                const CircularProgressIndicator(
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 2. MAIN NAVIGATION SCREEN (Drawer + Bottom Navigation Bar)
// -----------------------------------------------------------------------------
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ListScreen(),
    AboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 1
          ? null // ListScreen uses SliverAppBar
          : AppBar(
              title: Text(_currentIndex == 0 ? 'Home' : 'About Riphah'),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
      drawer: AppDrawer(
        onSelectScreen: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_city),
            label: 'Cities List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// DRAWER MENU WIDGET
// -----------------------------------------------------------------------------
class AppDrawer extends StatelessWidget {
  final Function(int) onSelectScreen;

  const AppDrawer({super.key, required this.onSelectScreen});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('Hamza'),
            accountEmail: Text('Hamza@gmail.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),
            decoration: BoxDecoration(
              color: Colors.green,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.green),
            title: const Text('Home Screen'),
            onTap: () {
              Navigator.pop(context);
              onSelectScreen(0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt, color: Colors.green),
            title: const Text('Cities List (SliverAppBar)'),
            onTap: () {
              Navigator.pop(context);
              onSelectScreen(1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.green),
            title: const Text('About Screen (Grid)'),
            onTap: () {
              Navigator.pop(context);
              onSelectScreen(2);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.photo_library, color: Colors.grey),
            title: const Text('Photo Gallery'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GalleryPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.grey),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SimplePage(title: 'Settings'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SCREEN 1: HOME SCREEN
// -----------------------------------------------------------------------------
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/profile.jpg'),
          ),
          const SizedBox(height: 12),
          const Text(
            'Welcome, Hamza!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Hamza@gmail.com',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Your Alarm & Reminders',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Card(
            elevation: 3,
            child: ListTile(
              leading: Icon(Icons.add_alarm, color: Colors.green, size: 30),
              title: Text(
                "Alarm",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Alarm at 10 o'clock"),
              trailing: Icon(Icons.access_alarm, color: Colors.green),
            ),
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Card(
                  color: Colors.green[50],
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(Icons.location_city, size: 40, color: Colors.green),
                        SizedBox(height: 8),
                        Text(
                          'Cities List',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '10+ Cities',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  color: Colors.green[50],
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(Icons.grid_view, size: 40, color: Colors.green),
                        SizedBox(height: 8),
                        Text(
                          'Campus Grid',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '6 Items Grid',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SCREEN 2: LIST SCREEN (10+ Items using CustomScrollView & SliverAppBar - Bonus!)
// -----------------------------------------------------------------------------
class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  final List<Map<String, String>> cities = const [
    {
      'name': 'Islamabad',
      'country': 'Pakistan',
      'desc': 'Capital city known for Faisal Mosque and Margalla Hills.',
      'image': 'https://picsum.photos/id/1015/400/200',
    },
    {
      'name': 'Lahore',
      'country': 'Pakistan',
      'desc': 'Cultural heart famous for Badshahi Mosque and food culture.',
      'image': 'https://picsum.photos/id/1016/400/200',
    },
    {
      'name': 'Karachi',
      'country': 'Pakistan',
      'desc': 'The economic hub and largest coastal city.',
      'image': 'https://picsum.photos/id/1018/400/200',
    },
    {
      'name': 'Peshawar',
      'country': 'Pakistan',
      'desc': 'Historic city famous for Qissa Khwani Bazaar.',
      'image': 'https://picsum.photos/id/1019/400/200',
    },
    {
      'name': 'Quetta',
      'country': 'Pakistan',
      'desc': 'The fruit garden of Pakistan surrounded by mountains.',
      'image': 'https://picsum.photos/id/1020/400/200',
    },
    {
      'name': 'Rawalpindi',
      'country': 'Pakistan',
      'desc': 'Twin city of Islamabad with rich history.',
      'image': 'https://picsum.photos/id/1021/400/200',
    },
    {
      'name': 'Multan',
      'country': 'Pakistan',
      'desc': 'City of Saints and famous blue pottery.',
      'image': 'https://picsum.photos/id/1022/400/200',
    },
    {
      'name': 'Faisalabad',
      'country': 'Pakistan',
      'desc': 'Industrial hub famous for textile industry.',
      'image': 'https://picsum.photos/id/1023/400/200',
    },
    {
      'name': 'Sialkot',
      'country': 'Pakistan',
      'desc': 'World-famous for sports goods manufacturing.',
      'image': 'https://picsum.photos/id/1024/400/200',
    },
    {
      'name': 'Murree',
      'country': 'Pakistan',
      'desc': 'Popular hill station surrounded by pine forests.',
      'image': 'https://picsum.photos/id/1025/400/200',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 180.0,
          floating: false,
          pinned: true,
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text(
              'Cities List (10 Items)',
              style: TextStyle(color: Colors.white),
            ),
            background: Container(
              color: Colors.green[700],
              child: const Center(
                child: Icon(
                  Icons.location_city,
                  size: 80,
                  color: Colors.white24,
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final city = cities[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 4,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green[100],
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      city['name']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(city['desc']!),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CityDetailPage(city: city),
                        ),
                      );
                    },
                  ),
                );
              },
              childCount: cities.length,
            ),
          ),
        ),
      ],
    );
  }
}

// Detail Page using Navigator.push & Navigator.pop
class CityDetailPage extends StatelessWidget {
  final Map<String, String> city;

  const CityDetailPage({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(city['name']!),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 220,
              child: buildNetworkImage(
                city['image']!,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city['name']!,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    city['country']!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    city['desc']!,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    label: const Text(
                      'Back to List',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SCREEN 3: ABOUT SCREEN (GridView with 6 Items + Captions)
// -----------------------------------------------------------------------------
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  final List<Map<String, String>> campusItems = const [
    {
      'title': 'Main Campus',
      'caption': 'Islamabad Campus',
      'image':
          'https://images.unsplash.com/photo-1562774053-701939374585?w=500&q=80',
    },
    {
      'title': 'Central Library',
      'caption': '100k+ Books',
      'image':
          'https://images.unsplash.com/photo-1521587760476-6c12a4b040da?w=500&q=80',
    },
    {
      'title': 'CS & IT Labs',
      'caption': 'Modern Computers',
      'image':
          'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=500&q=80',
    },
    {
      'title': 'Auditorium',
      'caption': 'Events & Seminars',
      'image':
          'https://images.unsplash.com/photo-1475721027785-f74eccf877e2?w=500&q=80',
    },
    {
      'title': 'Sports Complex',
      'caption': 'Indoor & Outdoor',
      'image':
          'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=500&q=80',
    },
    {
      'title': 'Cafeteria',
      'caption': 'Hygienic Dining',
      'image':
          'https://images.unsplash.com/photo-1567521464027-f127ff144326?w=500&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.green[50],
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.school, size: 40, color: Colors.green),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Riphah International University',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Islamabad Campus | CS & IT Department',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Campus Highlights (6 Items Grid)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: campusItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.95,
            ),
            itemBuilder: (context, index) {
              final item = campusItems[index];
              return Card(
                elevation: 3,
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: buildNetworkImage(
                        item['image']!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            item['caption']!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// HELPER NETWORK IMAGE WIDGET (With Loading & Error Builder)
// -----------------------------------------------------------------------------
Widget buildNetworkImage(
  String url, {
  BoxFit fit = BoxFit.cover,
  double? width,
  double? height,
}) {
  return Image.network(
    url,
    fit: fit,
    width: width,
    height: height,
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return Container(
        color: Colors.grey[200],
        child: Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
            strokeWidth: 2,
            color: Colors.green,
          ),
        ),
      );
    },
    errorBuilder: (context, error, stackTrace) {
      return Container(
        color: Colors.grey[300],
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.broken_image, color: Colors.grey, size: 28),
            SizedBox(height: 4),
            Text('Image Error',
                style: TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      );
    },
  );
}

// -----------------------------------------------------------------------------
// PREVIOUS GALLERY & SIMPLE PAGES (Retained for Drawer links)
// -----------------------------------------------------------------------------
class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final List<String> images = [
    'https://picsum.photos/id/10/300/300',
    'https://picsum.photos/id/20/300/300',
    'https://picsum.photos/id/30/300/300',
    'https://picsum.photos/id/40/300/300',
    'https://picsum.photos/id/50/300/300',
    'https://picsum.photos/id/60/300/300',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Gallery'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(6),
        itemCount: images.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    image: images[index],
                    tag: 'img-$index',
                  ),
                ),
              );
            },
            child: Hero(
              tag: 'img-$index',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: buildNetworkImage(images[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String image;
  final String tag;

  const DetailPage({super.key, required this.image, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Details'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Hero(
          tag: tag,
          child: buildNetworkImage(image, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

class SimplePage extends StatelessWidget {
  final String title;

  const SimplePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          '$title Page',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
