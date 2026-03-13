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
      const CreateEventScreen(),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredEvents.length,
              itemBuilder: (context, index) {
                final event = _filteredEvents[index];
                return Padding(
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
                );
              },
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
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 130,
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
  final String hostName;
  final bool enableChat;

  const Event({
    required this.id,
    required this.title,
    required this.dateRange,
    required this.location,
    required this.coverImageUrl,
    required this.categories,
    required this.description,
    required this.schedule,
    required this.hostName,
    required this.enableChat,
  });
}

final List<Event> demoEvents = [
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
    hostName: 'Wyrlo Events',
    enableChat: true,
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
    hostName: 'GGC Horror Crew',
    enableChat: true,
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
    hostName: 'Co-op Arena Team',
    enableChat: true,
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 180,
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
                const SizedBox(height: 16),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white12,
                      child: Icon(Icons.person, size: 18),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      event.hostName,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Text(
                        'Host',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: Colors.white70),
                      ),
                    ),
                  ],
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
          if (event.enableChat)
            const _EventDetailTile(
              icon: Icons.chat_bubble_outline,
              title: 'Chat with host',
              subtitle: 'Real-time chat (coming soon, via sockets)',
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

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _titleController = TextEditingController();
  final _dateController = TextEditingController(text: 'June 25 • 18:00');
  final _locationController =
      TextEditingController(text: 'Wisby Strand, Visby');
  final _hostNameController = TextEditingController(text: 'You');

  String _selectedCategory = 'Co-op';
  String? _selectedImageUrl;
  bool _enableChat = true;

  static const Map<String, List<String>> _presetImagesByCategory = {
    'Co-op': [
      'https://images.pexels.com/photos/3165335/pexels-photo-3165335.jpeg',
      'https://images.pexels.com/photos/845413/pexels-photo-845413.jpeg',
    ],
    'Horror': [
      'https://images.pexels.com/photos/799118/pexels-photo-799118.jpeg',
      'https://images.pexels.com/photos/619420/pexels-photo-619420.jpeg',
    ],
    'Roguelike': [
      'https://images.pexels.com/photos/3165335/pexels-photo-3165335.jpeg',
    ],
    'Adventure': [
      'https://images.pexels.com/photos/21014/pexels-photo.jpg',
    ],
    'Party': [
      'https://images.pexels.com/photos/167404/pexels-photo-167404.jpeg',
    ],
    'Indie': [
      'https://images.pexels.com/photos/1462725/pexels-photo-1462725.jpeg',
    ],
  };

  List<String> get _allCategories =>
      _presetImagesByCategory.keys.toList()..sort();

  List<String> get _currentImages =>
      _presetImagesByCategory[_selectedCategory] ?? [];

  @override
  void initState() {
    super.initState();
    final images = _currentImages;
    if (images.isNotEmpty) {
      _selectedImageUrl = images.first;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _locationController.dispose();
    _hostNameController.dispose();
    super.dispose();
  }

  void _createEvent() {
    final title = _titleController.text.trim().isEmpty
        ? 'Untitled game session'
        : _titleController.text.trim();

    final cover = _selectedImageUrl ?? _currentImages.firstOrNull;

    if (cover == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please pick a cover image')),
      );
      return;
    }

    final event = Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      dateRange: _dateController.text.trim(),
      location: _locationController.text.trim(),
      coverImageUrl: cover,
      categories: [_selectedCategory],
      description:
          'Community-created session at Gotland Game Conference. Tailored for $_selectedCategory players.',
      schedule: [
        _dateController.text.trim(),
        'Player meetup & play session',
      ],
      hostName: _hostNameController.text.trim().isEmpty
          ? 'Host'
          : _hostNameController.text.trim(),
      enableChat: _enableChat,
    );

    demoEvents.insert(0, event);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EventDetailScreen(event: event),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create event'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _titleController,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: const InputDecoration(
              labelText: 'Event name',
              hintText: 'e.g. Roguelike Showcase',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _dateController,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: const InputDecoration(
              labelText: 'Date & time',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _locationController,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: const InputDecoration(
              labelText: 'Location',
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Game type',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _allCategories.map(
                (c) {
                  final selected = c == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(c),
                      selected: selected,
                      onSelected: (_) {
                        setState(() {
                          _selectedCategory = c;
                          final imgs = _currentImages;
                          if (imgs.isNotEmpty) {
                            _selectedImageUrl = imgs.first;
                          }
                        });
                      },
                    ),
                  );
                },
              ).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Cover image preset',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _currentImages.length,
              itemBuilder: (context, index) {
                final url = _currentImages[index];
                final selected = url == _selectedImageUrl;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedImageUrl = url;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            selected ? const Color(0xFF9B59FF) : Colors.white24,
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        url,
                        width: 140,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Host',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _hostNameController,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: const InputDecoration(
              labelText: 'Host name',
              hintText: 'e.g. Your nickname or studio',
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Allow chat with host'),
            subtitle:
                const Text('Enables a chat entry on the event page (backend later)'),
            value: _enableChat,
            onChanged: (v) {
              setState(() => _enableChat = v);
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _createEvent,
              child: const Text('Create event'),
            ),
          ),
        ],
      ),
    );
  }
}

extension _FirstOrNull<E> on List<E> {
  E? get firstOrNull => isEmpty ? null : first;
}

