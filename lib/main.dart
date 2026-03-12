import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wyrlo/map_screen.dart';

void main() {
  runApp(const WyrloApp());
}

class WyrloApp extends StatelessWidget {
  const WyrloApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTextTheme = GoogleFonts.poppinsTextTheme();

    final theme = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      primaryColor: Colors.white,
      colorScheme: const ColorScheme.dark(
        primary: Colors.white,
        secondary: Color(0xFF9B59FF),
        background: Colors.black,
        surface: Color(0xFF111111),
      ),
      textTheme: baseTextTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF050505),
        selectedItemColor: const Color(0xFF9B59FF),
        unselectedItemColor: Colors.white.withOpacity(0.5),
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wyrlo',
      theme: theme,
      home: const WyrloSplashScreen(),
    );
  }
}

class WyrloSplashScreen extends StatefulWidget {
  const WyrloSplashScreen({super.key});

  @override
  State<WyrloSplashScreen> createState() => _WyrloSplashScreenState();
}

class _WyrloSplashScreenState extends State<WyrloSplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AuthScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: const Center(
        child: Image(
          image: NetworkImage('https://example.com/your-wyrlo-w.png'),
          width: 120,
        ),
      ),
    );
  }
}

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              const Center(
                child: Image(
                  image: NetworkImage('https://example.com/your-wyrlo-w.png'),
                  width: 80,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Join us today.',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const WyrloShell()),
                  );
                },
                child: const Text('Continue with Google'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const WyrloShell()),
                  );
                },
                child: const Text('Continue with email'),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const WyrloShell()),
                  );
                },
                child: const Text('Already have an account? Sign in'),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class WyrloShell extends StatefulWidget {
  const WyrloShell({super.key});

  @override
  State<WyrloShell> createState() => _WyrloShellState();
}

class _WyrloShellState extends State<WyrloShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeScreen(),
      const MapScreen(),
      const Center(child: Text('Create')),
      const Center(child: Text('Messages')),
      const Center(child: Text('Profile')),
    ];

    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedCategory;

  List<Event> get _filteredEvents {
    if (_selectedCategory == null) return demoEvents;
    return demoEvents
        .where((e) => e.categories.contains(_selectedCategory))
        .toList();
  }

  List<String> get _allCategories {
    final set = <String>{};
    for (final e in demoEvents) {
      set.addAll(e.categories);
    }
    final list = set.toList()..sort();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your upcoming events'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: const CircleAvatar(
              radius: 16,
              backgroundImage:
                  NetworkImage('https://example.com/your-wyrlo-avatar.png'),
              backgroundColor: Colors.white,
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ..._filteredEvents.map(
            (event) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: EventCard(
                event: event,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => EventDetailScreen(event: event),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Find by categories',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _selectedCategory == null,
                  onSelected: (_) {
                    setState(() => _selectedCategory = null);
                  },
                ),
                const SizedBox(width: 8),
                ..._allCategories.map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(c),
                      selected: _selectedCategory == c,
                      onSelected: (_) {
                        setState(() => _selectedCategory = c);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback? onTap;

  const EventCard({
    super.key,
    required this.event,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                event.coverImageUrl,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.85),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${event.dateRange} · ${event.location}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      children: event.categories
                          .map(
                            (c) => Chip(
                              label: Text(c),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              backgroundColor: Colors.black.withOpacity(0.6),
                              labelStyle: const TextStyle(fontSize: 12),
                              visualDensity: VisualDensity.compact,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Event {
  final String id;
  final String title;
  final String dateRange;
  final String location;
  final String coverImageUrl;
  final List<String> categories; // e.g. Horror, Co-op, Roguelike
  final String description;
  final List<String> schedule;

  const Event({
    required this.id,
    required this.title,
    required this.dateRange,
    required this.location,
    required this.coverImageUrl,
    required this.categories,
    required this.description,
    required this.schedule,
  });
}

const List<Event> demoEvents = [
  Event(
    id: 'ggc-main',
    title: 'Gotland Game Conference',
    dateRange: 'June 22–26',
    location: 'Wisby Strand, Visby',
    coverImageUrl:
        'https://www.gotlandgameconference.com/wp-content/uploads/2022/06/GGC22_header-1024x576.jpg',
    categories: ['Co-op', 'Adventure', 'Indie'],
    description:
        'Play student-made games from horror roguelikes to cozy co-op adventures, all under one noisy roof.',
    schedule: [
      'Day 1 – Expo open, horror showcase, live judging',
      'Day 2 – Co-op & party games tournament',
      'Day 3 – Awards, networking, afterparty',
    ],
  ),
  Event(
    id: 'ggc-horror',
    title: 'Midnight Horror Showcase',
    dateRange: 'June 23 • 20:00',
    location: 'Dark Room, Wisby Strand',
    coverImageUrl:
        'https://images.pexels.com/photos/799118/pexels-photo-799118.jpeg',
    categories: ['Horror', 'Roguelike'],
    description:
        'A curated line-up of horror and roguelike games. Short runs, permadeath, big screams.',
    schedule: [
      '20:00 – Doors open, onboarding',
      '20:30 – Horror block A play session',
      '22:00 – Roguelike showdown',
    ],
  ),
  Event(
    id: 'ggc-coop',
    title: 'Co-op Couch Chaos',
    dateRange: 'June 24 • 14:00',
    location: 'Indie Stage, Wisby Strand',
    coverImageUrl:
        'https://images.pexels.com/photos/3165335/pexels-photo-3165335.jpeg',
    categories: ['Co-op', 'Party'],
    description:
        'Local multiplayer chaos – bring friends or match with other visitors for drop-in co-op sessions.',
    schedule: [
      '14:00 – Check-in & matchmaking',
      '14:30 – Co-op block A',
      '16:00 – Party game finals & prizes',
    ],
  ),
];

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              event.coverImageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 16, color: Colors.white70),
                    const SizedBox(width: 4),
                    Text(
                      event.dateRange,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.location_on,
                        size: 16, color: Colors.white70),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        event.location,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.white70),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(999)),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFE6B8B),
                          Color(0xFF9B59FF),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 24,
                      ),
                      child: Center(
                        child: Text(
                          'JOIN LIVE SPACE',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  event.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          _EventDetailTile(
            icon: Icons.info_outline,
            title: 'Info',
            subtitle: 'What this event is about',
          ),
          _EventDetailTile(
            icon: Icons.event,
            title: 'Schedule',
            subtitle: event.schedule.join(' • '),
          ),
          _EventDetailTile(
            icon: Icons.map_outlined,
            title: 'Event map',
            subtitle: 'Find the horror, co-op, and roguelike corners',
          ),
          const _EventDetailTile(
            icon: Icons.confirmation_number_outlined,
            title: 'Tickets',
            subtitle: 'External ticket site',
            trailing: Icon(Icons.open_in_new, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _EventDetailTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;

  const _EventDetailTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title),
      subtitle: Text(
        subtitle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}

