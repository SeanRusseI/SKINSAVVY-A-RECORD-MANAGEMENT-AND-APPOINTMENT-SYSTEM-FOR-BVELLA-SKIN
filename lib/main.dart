import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

extension Let<T> on T {
  R let<R>(R Function(T it) op) => op(this);
}

List<Map<String, dynamic>> appointments = [
  {
    'name': 'Demo User',
    'email': 'demo@bvella.com',
    'date': DateTime.now(),
    'time': TimeOfDay(hour: 14, minute: 0),
    'service': 'Facial Treatments',
    'status': 'Completed',
    'rating': null,
  },
];
List<Map<String, dynamic>> bookedAppointments = [];

class BookmarkService {
  static List<Map<String, String>> bookmarks = [];
}

class Appointment {
  final String name;
  final String contact;
  final DateTime date;
  final TimeOfDay time;
  final String service;

  Appointment({
    required this.name,
    required this.contact,
    required this.date,
    required this.time,
    required this.service,
  });
}

class AppointmentStore {
  static final List<Appointment> appointments = [];
}

class AppointmentData {
  final String name;
  final String contact;
  final String date;
  final String time;
  final String service;

  AppointmentData({
    required this.name,
    required this.contact,
    required this.date,
    required this.time,
    required this.service,
  });
}

class ServiceAppointment {
  final String name;
  final String contact;
  final String date;
  final String time;
  final String type;

  ServiceAppointment({
    required this.name,
    required this.contact,
    required this.date,
    required this.time,
    required this.type,
  });
}

// Temporary in-memory list for appointments
List<ServiceAppointment> bookedServices = [];

List<Map<String, String>> myServices = [];

String selectedService = '';

// Global in-memory list to store appointments
List<AppointmentData> myAppointments = [];

List<String> bookmarkedServices = [];

void main() {
  runApp(BvellaApp());
}

class BvellaApp extends StatefulWidget {
  @override
  State<BvellaApp> createState() => _BvellaAppState();
}

class _BvellaAppState extends State<BvellaApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bvella Skin',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        brightness: Brightness.light,
        primarySwatch: Colors.pink,
        pageTransitionsTheme: _pageTransitions(),
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.grey[900],
        pageTransitionsTheme: _pageTransitions(),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => LoginPage(toggleTheme: _toggleTheme),
        '/home': (_) => HomePage(toggleTheme: _toggleTheme),
        '/appointment': (_) => AppointmentPage(toggleTheme: _toggleTheme),
        '/services': (_) => ServicesPage(),
        '/bookmarks': (_) => BookmarksPage(),
        '/profile': (_) => PlaceholderPage(title: 'Profile'),
        '/about': (_) => AboutPage(),
        '/myservices': (_) => MyServicesPage(appointments: appointments),
        '/consult': (context) => ConsultPage(),
        '/products': (context) => ProductsPage(),
        '/signup': (context) => SignUpPage(),
        '/intro': (_) => IntroAnimationPage(),
        '/login': (context) => LoginPage(toggleTheme: _toggleTheme),
        '/profile': (_) => ProfilePage(),
      },
    );
  }

  PageTransitionsTheme _pageTransitions() => PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  );
}

Drawer buildAppDrawer(BuildContext context, VoidCallback toggleTheme) {
  return Drawer(
    child: Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.pink[100]),
                child: Image.asset('assets/bvella_logo.png'),
              ),
              ListTile(
                leading: Icon(Icons.person, color: Colors.pink[800]),
                title: Text("Profile"),
                onTap: () => Navigator.pushNamed(context, '/profile'),
              ),
              ListTile(
                leading: Icon(Icons.info, color: Colors.pink[800]),
                title: Text("About Bvella Skin"),
                onTap: () => Navigator.pushNamed(context, '/about'),
              ),
              ListTile(
                leading: Icon(Icons.medical_services, color: Colors.pink[800]),
                title: Text('My Services'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MyServicesPage(appointments: appointments),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.bookmark, color: Colors.pink[800]),
                title: Text("Bookmarks"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookmarksPage()),
                  );
                },
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12,
                ),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    backgroundColor: Colors.pink[100],
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  ),
                  icon: Icon(Icons.brightness_6),
                  label: Text(
                    '',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: toggleTheme,
                ),
              ),
            ],
          ),
        ),

        // 🔻 Logout button pinned to bottom
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: Icon(Icons.logout, color: Colors.white),
              label: Text(
                'Log Out',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.all(20),
            children: [
              SizedBox(height: 50),
              Center(child: Image.asset('assets/bvella_logo.png', height: 250)),
              SizedBox(height: 30),
              Center(
                child: Text(
                  'This is the $title page.',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: Colors.pink[800],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 30,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: Colors.pink[700]),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.all(20),
            children: [
              SizedBox(height: 50),
              Center(child: Image.asset('assets/bvella_logo.png', height: 250)),
              SizedBox(height: 30),
              Text(
                "Bvella Skin is a premier aesthetic clinic located in Poblacion 1, Bauan, Batangas. With a team of expert aestheticians and committed professionals, the clinic specializes in advanced skincare treatments tailored to individual needs. Whether it's facials, body contouring, slimming, laser therapies, or rejuvenating procedures, Bvella Skin ensures clients receive luxurious, effective, and personalized care. The clinic combines modern dermatological technology with a relaxing environment to deliver a holistic beauty experience. Bvella Skin continues to be a trusted destination for clients seeking radiant skin and confident transformations.",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  color: Colors.pink[900],
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
          Positioned(
            top: 30,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: Colors.pink[700]),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  final VoidCallback toggleTheme;
  LoginPage({required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    final u = TextEditingController(), p = TextEditingController();
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/loginpic.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              color: Colors.pink[700],
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                children: [
                  Text(
                    "Welcome",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 36,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  _customInput("Email", u),
                  SizedBox(height: 10),
                  _customInput("Password", p, obscure: true),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/intro'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[200],
                      shape: StadiumBorder(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      "Log In",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("Or", style: TextStyle(color: Colors.white)),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[200],
                      shape: StadiumBorder(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white),
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

  Widget _customInput(
    String hint,
    TextEditingController c, {
    bool obscure = false,
  }) {
    return TextField(
      controller: c,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  HomePage({required this.toggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _promoIndex = 0;
  late Timer _timer;
  final List<String> promoImages = [
    'assets/your.jpg',
    'assets/exclusive.jpg',
    'assets/valentines.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 5000), (_) {
      setState(() => _promoIndex = (_promoIndex + 1) % promoImages.length);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildAppDrawer(context, widget.toggleTheme),
      body: Stack(
        children: [
          ListView(
            children: [
              Container(
                width: double.infinity,
                color: Colors.pink[100],
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 20,
                ), // reduced vertical padding
                child: Column(
                  children: [
                    Image.asset(
                      'assets/bvella_logo.png',
                      height: 230,
                      width: 700,
                    ), // keep logo big
                    SizedBox(
                      height: 2,
                    ), // minimal spacing between logo and search bar
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Browse Services",
                        prefixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onChanged: (q) {
                        Navigator.pushNamed(context, '/services', arguments: q);
                      },
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _homeButton(
                          Icons.calendar_month,
                          'Appointment',
                          '/appointment',
                        ),
                        _homeButton(Icons.video_call, 'Consult', '/consult'),

                        _homeButton(
                          Icons.medical_services,
                          'Services',
                          '/services',
                        ),
                        _homeButton(
                          Icons.shopping_bag,
                          'Products',
                          '/products',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 600),
                transitionBuilder: (c, a) =>
                    ScaleTransition(scale: a, child: c),
                child: Container(
                  key: ValueKey(_promoIndex),
                  margin: EdgeInsets.all(10),
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.pink[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      promoImages[_promoIndex],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 180,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Bvella Skin’s Top Picks",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: Colors.pinkAccent, // Hot pink color
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _serviceCard("Full Facial Cleansing", "assets/cleansing.jpg"),
                  _serviceCard("Gluta Drips", "assets/gluta.png"),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
          // Burger button only on home
          Positioned(
            top: 30,
            left: 20,
            child: Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu, size: 30, color: Colors.pink[700]),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _homeButton(IconData icon, String label, String route) => Column(
    children: [
      InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: CircleAvatar(
          backgroundColor: Colors.pink[700],
          child: Icon(icon, color: Colors.white),
        ),
      ),
      SizedBox(height: 5),
      Text(label, style: TextStyle(fontSize: 12)),
    ],
  );

  Widget _serviceCard(String title, String image) => Container(
    width: MediaQuery.of(context).size.width * 0.44,
    height: 180,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
    ),
    alignment: Alignment.bottomCenter,
    child: Container(
      padding: EdgeInsets.all(8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}

class AppointmentPage extends StatefulWidget {
  final VoidCallback toggleTheme;

  AppointmentPage({required this.toggleTheme});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  DateTime? _dt;
  TimeOfDay? _tm;
  final types = [
    "Facial Treatments",
    "Laser Treatments",
    "Body Treatments",
    "Gluta Treatments",
    "Slimming Treatments",
  ];
  int sel = 0;
  int? tappedIndex;

  @override
  Widget build(BuildContext context) {
    final List<String> images = [
      'assets/cleansing.jpg',
      'assets/Laser.jpg',
      'assets/bodytreatment.jpg',
      'assets/gluta.png',
      'assets/slimming.png',
    ];

    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.all(20),
            children: [
              Center(child: Image.asset('assets/bvella_logo.png', height: 250)),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.pink[700],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Form(
                  key: _form,
                  child: Column(
                    children: [
                      _field("Name", _name),
                      SizedBox(height: 10),
                      _field("Email", _email),
                      SizedBox(height: 10),
                      _pickerTile(
                        label: _dt == null
                            ? "Date of Appointment"
                            : DateFormat('yyyy-MM-dd').format(_dt!),
                        icon: Icons.calendar_today,
                        onTap: _pickDate,
                      ),
                      SizedBox(height: 10),
                      _pickerTile(
                        label: _tm == null ? "Time" : _tm!.format(context),
                        icon: Icons.access_time,
                        onTap: _pickTime,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Type of Service",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Colors.pink[800],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/services');
                    },
                    child: Text("View All"),
                  ),
                ],
              ),
              Container(
                height: 150,
                child: PageView.builder(
                  controller: PageController(viewportFraction: 0.6),
                  itemCount: types.length,
                  onPageChanged: (i) => setState(() => sel = i),
                  itemBuilder: (_, i) => Transform.scale(
                    scale: i == sel ? 1 : 0.9,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        border: i == sel
                            ? Border.all(color: Colors.pink.shade700, width: 4)
                            : null,
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage(images[i]),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: i == sel
                            ? [
                                BoxShadow(
                                  color: Colors.pink.shade100,
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ]
                            : [],
                      ),
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(20),
                          ),
                        ),
                        child: Text(
                          types[i],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),
              Center(
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[700],
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: Text(
                    "Confirm Appointment",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
          Positioned(
            top: 30,
            left: 20,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 24,
                color: Colors.pink[700],
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController c) => TextFormField(
    controller: c,
    validator: (v) {
      if (v == null || v.isEmpty) return "$label required";
      if (label == "Name" && !RegExp(r"^[a-zA-Z\s]+$").hasMatch(v))
        return "Enter a valid name";
      if (label == "Email" &&
          !RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(v))
        return "Enter a valid email";
      return null;
    },
    decoration: InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
    ),
  );

  Widget _pickerTile({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.pink[700]),
            SizedBox(width: 10),
            Text(label),
          ],
        ),
      ),
    );
  }

  void _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => _dt = d);
  }

  void _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (t != null) setState(() => _tm = t);
  }

  void _submit() {
    if (_form.currentState!.validate() && _dt != null && _tm != null) {
      appointments.add({
        'name': _name.text,
        'email': _email.text,
        'date': _dt!,
        'time': _tm!,
        'service': types[sel],
        'status': 'Pending',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Appointment booked successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      _form.currentState!.reset();
      setState(() {
        _dt = null;
        _tm = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all fields."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class ConsultPage extends StatefulWidget {
  @override
  _ConsultPageState createState() => _ConsultPageState();
}

class _ConsultPageState extends State<ConsultPage> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  DateTime? _dt;
  TimeOfDay? _tm;

  void _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => _dt = d);
  }

  void _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (t != null) setState(() => _tm = t);
  }

  void _submit() {
    if (_form.currentState!.validate() && _dt != null && _tm != null) {
      // You can add logic here to save the consultation appointment
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Consultation booked! Google Meet link will be sent soon.",
          ),
          backgroundColor: Colors.green,
        ),
      );
      _form.currentState!.reset();
      setState(() {
        _dt = null;
        _tm = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all fields."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _field(String label, TextEditingController c) => TextFormField(
    controller: c,
    validator: (v) => v == null || v.isEmpty ? "$label required" : null,
    decoration: InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
    ),
  );

  Widget _pickerTile({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.pink[700]),
            SizedBox(width: 10),
            Text(label),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.all(20),
            children: [
              Center(child: Image.asset('assets/bvella_logo.png', height: 250)),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.pink[700],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Form(
                  key: _form,
                  child: Column(
                    children: [
                      _field("Name", _name),
                      SizedBox(height: 10),
                      _field("Email", _email),
                      SizedBox(height: 10),
                      _pickerTile(
                        label: _dt == null
                            ? "Date of Consultation"
                            : DateFormat('yyyy-MM-dd').format(_dt!),
                        icon: Icons.calendar_today,
                        onTap: _pickDate,
                      ),
                      SizedBox(height: 10),
                      _pickerTile(
                        label: _tm == null ? "Time" : _tm!.format(context),
                        icon: Icons.access_time,
                        onTap: _pickTime,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 25),
              Center(
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[700],
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: Text(
                    "Confirm Consultation",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  "A Google Meet link will be sent to your email after confirmation.",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    color: Colors.pink[900],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Positioned(
            top: 30,
            left: 20,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 24,
                color: Colors.pink[700],
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

class ServicesPage extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {"name": "Facials", "img": "assets/cleansing.jpg"},
    {"name": "Body Treatments", "img": "assets/bodytreatment.jpg"},
    {"name": "Slimming Treatments", "img": "assets/slimming.png"},
    {"name": "Laser Treatments", "img": "assets/laser.jpg"},
    {"name": "Gluta Treatments", "img": "assets/gluta.png"},
  ];

  final Map<String, List<Map<String, dynamic>>> serviceCategories = {
    "Facials": [
      {"name": "Cleansing Facial", "price": 400},
      {"name": "Acne Treatment Facial", "price": 600},
      {"name": "Diamond Peel Facial", "price": 1500},
      {"name": "Oxypeel Facial", "price": 1500},
      {"name": "Angel White Laser Facial", "price": 1500},
      {"name": "Vitamin C Galvanic Facial", "price": 800},
      {"name": "Gold Mask Facial", "price": 800},
      {"name": "Green Tea Gel Mask Facial", "price": 800},
      {"name": "Collagen Gel Mask Facial", "price": 800},
      {"name": "Crystal Collagen Gel Mask Facial", "price": 800},
    ],
    "Body Treatments": [
      {"name": "Body Scrub", "price": 800},
      {"name": "Body Bleaching", "price": 800},
      {"name": "Thai Massage", "price": 500},
      {"name": "Thai Massage", "price": 500},
      {"name": "Swedish Massage", "price": 500},
      {"name": "Warts Removal", "price": 1500},
    ],
    "Slimming Treatments": [
      {"name": "RF Slimming Face", "price": 1100},
      {"name": "RF Slimming Arms", "price": 1100},
      {"name": "RF Slimming Abdomen", "price": 1200},
      {"name": "RF Slimming Thigh", "price": 1200},
      {"name": "Cavitation Arms", "price": 1000},
      {"name": "Cavitation Abdomen", "price": 1000},
      {"name": "Cavitation Thigh", "price": 1000},
      {"name": "Lipo Laser Face", "price": 900},
      {"name": "Lipo Laser Arms", "price": 900},
      {"name": "Lipo Laser Abdomen", "price": 1000},
      {"name": "Lipo Laser Thigh", "price": 1000},
    ],
    "Laser Treatments": [
      {"name": "Carbon Laser Face", "price": 5000},
      {"name": "Carbon Laser Underarm", "price": 4500},
      {"name": "Diode Laser Underarm", "price": 4000},
      {"name": "Diode Laser Lower Leg", "price": 5000},
      {"name": "Diode Laser Whole Leg", "price": 9000},
      {"name": "Oxydome Face", "price": 3000},
      {"name": "10 in 1 Oxydome Face", "price": 3500},
      {"name": "Exilift Face", "price": 5000},
      {"name": "Exilift Neck", "price": 4000},
      {"name": "Exilift Arms", "price": 4000},
      {"name": "Exilift Abdomen", "price": 6000},
      {"name": "Exilift Thigh", "price": 6000},
      {"name": "HIFU Face & Neck", "price": 7000},
      {"name": "HIFU Arms", "price": 6000},
      {"name": "HIFU Abdomen", "price": 7000},
      {"name": "HIFU Thigh", "price": 7000},
    ],
    "Gluta Treatments": [
      {"name": "Gluta Glow Push", "price": 800},
      {"name": "Bvella Skin Drip", "price": 1000},
      {"name": "Bvella Skin Collagen add-on", "price": 500},
      {"name": "Bvella Skin Placenta add-on", "price": 800},
      {"name": "Bvella Skin Vitamin C add-on", "price": 500},
      {"name": "Bvella Skin L-Carnitine add-on", "price": 800},
    ],
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: Text('Services'),
        backgroundColor: Colors.pink[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryServicesPage(
                        category: cat["name"]!,
                        services: serviceCategories[cat["name"]!]!,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.shade100.withOpacity(0.5),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                    border: Border.all(color: Colors.pink.shade100),
                    image: DecorationImage(
                      image: AssetImage(cat["img"]!),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.25),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      cat["name"]!,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        shadows: [
                          Shadow(
                            blurRadius: 8,
                            color: Colors.black54,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CategoryServicesPage extends StatelessWidget {
  final String category;
  final List<Map<String, dynamic>> services;

  const CategoryServicesPage({
    super.key,
    required this.category,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(title: Text(category), backgroundColor: Colors.pink[100]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: services.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 3 / 2,
          ),
          itemBuilder: (context, index) {
            final service = services[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.pink.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.shade100.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.hardEdge,
              padding: EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          service["name"],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.pink[800],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.bookmark_add_outlined,
                          color: Colors.pink[400],
                        ),
                        tooltip: "Bookmark",
                        onPressed: () {
                          BookmarkService.bookmarks.add({
                            'name': service["name"].toString(),
                            'img': getServiceImage(category),
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Bookmarked!")),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    "₱${service["price"]}",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.pink[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class BookmarksPage extends StatefulWidget {
  @override
  _BookmarksPageState createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  @override
  Widget build(BuildContext context) {
    final marks = BookmarkService.bookmarks;

    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Stack(
        children: [
          marks.isEmpty
              ? Center(
                  child: Text(
                    "No bookmarks added.",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.only(top: 80),
                  itemCount: marks.length,
                  itemBuilder: (c, i) => Dismissible(
                    key: Key(marks[i]['name']!),
                    onDismissed: (_) {
                      setState(() => marks.removeAt(i));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Removed from bookmarks")),
                      );
                    },
                    background: Container(color: Colors.red),
                    child: ListTile(
                      leading: Image.asset(marks[i]['img']!, width: 60),
                      title: Text(marks[i]['name']!),
                      trailing: Icon(Icons.bookmark),
                    ),
                  ),
                ),
          Positioned(
            top: 30,
            left: 20,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 24,
                color: Colors.pink[700],
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

class MyServicesPage extends StatefulWidget {
  final List<Map<String, dynamic>> appointments;

  MyServicesPage({required this.appointments});

  @override
  _MyServicesPageState createState() => _MyServicesPageState();
}

class _MyServicesPageState extends State<MyServicesPage> {
  void _cancelAppointment(int index, String status) {
    if (status == 'Confirmed') {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Cancel Confirmed Appointment"),
          content: Text(
            "Cancelling a confirmed appointment may incur charges. Do you want to proceed?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.appointments[index]['status'] = 'Cancelled';
                });
                Navigator.pop(context);
              },
              child: Text("Yes, Cancel"),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        widget.appointments[index]['status'] = 'Cancelled';
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Appointment cancelled.")));
    }
  }

  void _rescheduleAppointment(int index) async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (newDate != null) {
      TimeOfDay? newTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (newTime != null) {
        setState(() {
          widget.appointments[index]['date'] = newDate;
          widget.appointments[index]['time'] = newTime;
          widget.appointments[index]['status'] = 'Confirmed';
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Appointment rescheduled.")));
      }
    }
  }

  void _rateAppointment(int index) {
    int selectedStars = 0;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Rate This Service"),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (star) {
            return IconButton(
              icon: Icon(
                Icons.star,
                color: star < selectedStars ? Colors.amber : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  selectedStars = star + 1;
                  widget.appointments[index]['rating'] = selectedStars;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("You rated $selectedStars star(s).")),
                );
              },
            );
          }),
        ),
      ),
    );
  }

  void _rebookService(int index) {
    setState(() {
      widget.appointments.add({
        ...widget.appointments[index],
        'status': 'Pending',
        'date': DateTime.now(),
      });
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Service rebooked.")));
  }

  Widget _buildServiceCard(Map<String, dynamic> appt, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink.shade100, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.shade100,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.spa, color: Colors.pink[700], size: 28),
                SizedBox(width: 10),
                Text(
                  appt['service'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Colors.pink[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              "Date: ${appt['date'] is DateTime ? DateFormat('yyyy-MM-dd').format(appt['date']) : appt['date']} at ${appt['time'] is TimeOfDay ? appt['time'].format(context) : appt['time']}",
            ),
            Text(
              "Status: ${appt['status']}",
              style: TextStyle(
                color: Colors.pink[900],
                fontWeight: FontWeight.w600,
              ),
            ),
            if (appt['rating'] != null)
              Row(
                children: List.generate(
                  appt['rating'],
                  (i) => Icon(Icons.star, color: Colors.amber, size: 18),
                ),
              ),
            SizedBox(height: 14),
            Row(children: _buildActions(appt['status'], index)),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActions(String status, int index) {
    List<Widget> buttons = [];
    if (status == 'Pending') {
      buttons.addAll([
        _actionBtn("Reschedule", () => _rescheduleAppointment(index)),
        SizedBox(width: 10),
        _actionBtn("Cancel", () => _cancelAppointment(index, status)),
      ]);
    } else if (status == 'Confirmed') {
      buttons.add(
        _actionBtn("Cancel", () => _cancelAppointment(index, status)),
      );
    } else if (status == 'Completed') {
      buttons.addAll([
        _actionBtn("Rebook", () => _rebookService(index)),
        SizedBox(width: 10),
        _actionBtn("Rate", () => _rateAppointment(index)),
      ]);
    }
    return buttons;
  }

  Widget _actionBtn(String label, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pink[300],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        textStyle: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }

  Widget _buildStatusSection(String title, List<Map<String, dynamic>> data) {
    if (data.isEmpty) return SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.pink[800],
              fontFamily: 'Poppins',
            ),
          ),
        ),
        ...data
            .asMap()
            .entries
            .map(
              (entry) => _buildServiceCard(
                entry.value,
                widget.appointments.indexOf(entry.value),
              ),
            )
            .toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final pending = widget.appointments
        .where((a) => a['status'] == 'Pending')
        .toList();
    final confirmed = widget.appointments
        .where((a) => a['status'] == 'Confirmed')
        .toList();
    final completed = widget.appointments
        .where((a) => a['status'] == 'Completed')
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        leading: BackButton(color: Colors.pink[900]),
        title: Text(
          "My Services",
          style: TextStyle(color: Colors.pink[900], fontFamily: 'Poppins'),
        ),
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildStatusSection("Pending", pending),
          _buildStatusSection("Confirmed", confirmed),
          _buildStatusSection("Completed", completed),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}

class ProductsPage extends StatelessWidget {
  final List<Map<String, String>> products = [
    // Fill these manually with your actual data
    {
      "name": "Acne Gel",
      "img": "assets/acnegel.jpg",
      "price": "₱200",
      "desc":
          "Acne gel is a topical treatment that helps reduce breakouts by targeting acne-causing bacteria, unclogging pores, and calming inflammation.",
    },
    {
      "name": "Acne Solution",
      "img": "assets/acnesolution.jpg",
      "price": "₱200",
      "desc":
          "Acne Solution is a skincare product designed to treat and prevent breakouts by targeting acne-causing bacteria, reducing excess oil, and soothing inflamed skin.",
    },
    {
      "name": "Acne Tret",
      "img": "assets/acnetret.jpg",
      "price": "₱200",
      "desc":
          "Acne Tret is a topical treatment that helps reduce breakouts by targeting acne-causing bacteria, unclogging pores, and calming inflammation.",
    },
    {
      "name": "Age Defy",
      "img": "assets/agedefy.jpg",
      "price": "₱200",
      "desc":
          "Age Defy is a skincare product that helps reduce the appearance of fine lines and wrinkles, promoting a youthful and radiant complexion.",
    },
    {
      "name": "Deo Roll",
      "img": "assets/deoroll.jpg",
      "price": "₱200",
      "desc":
          "Deo Roll is a long-lasting roll-on deodorant that provides effective odor protection while being gentle on the skin.",
    },
    {
      "name": "E-Cream",
      "img": "assets/ecream.jpg",
      "price": "₱200",
      "desc":
          "ER Cream is a specialized skincare product designed to provide intensive moisture and repair for dry, damaged skin.",
    },
    {
      "name": "Ery Solution",
      "img": "assets/ery.jpg",
      "price": "₱200",
      "desc":
          "Ery Solution is a targeted treatment for erythema that helps reduce redness and inflammation.",
    },
    {
      "name": "Facial Scrub",
      "img": "assets/facialscrub.jpg",
      "price": "₱200",
      "desc":
          "Facial Scrub is a gentle exfoliating scrub that helps remove dead skin cells, unclog pores, and promote a smoother, brighter complexion.",
    },
    {
      "name": "Gluta Soap",
      "img": "assets/glutasoap.jpg",
      "price": "₱200",
      "desc":
          "Gluta Soap is a skin-brightening soap that helps reduce dark spots and evens out skin tone.",
    },
    {
      "name": "Hydrocort Cream",
      "img": "assets/hydrocort.jpg",
      "price": "₱200",
      "desc":
          "Hydrocort Cream is a topical corticosteroid that helps reduce inflammation and relieve itching.",
    },
    {
      "name": "Kojic Soap",
      "img": "assets/kojic.jpg",
      "price": "₱200",
      "desc":
          "Kojic Soap is a skin-lightening soap that helps reduce the appearance of dark spots and evens out skin tone.",
    },
    {
      "name": "Lemon Soap",
      "img": "assets/lemonsoap.jpg",
      "price": "₱200",
      "desc":
          "Lemon Soap is a refreshing soap that helps brighten the skin and reduce excess oil.",
    },
    {
      "name": "Lightening Cream",
      "img": "assets/lighteningcream.jpg",
      "price": "₱200",
      "desc":
          "Lightening Cream is a specialized cream that helps reduce dark spots and even out skin tone.",
    },
    {
      "name": "Macrolide Solution",
      "img": "assets/macrolide.jpg",
      "price": "₱200",
      "desc":
          "Macrolide Solution is a topical treatment that helps reduce inflammation and redness associated with acne.",
    },
    {
      "name": "Pore Minimizer Solution",
      "img": "assets/poremini.jpg",
      "price": "₱200",
      "desc":
          "Pore Minimizer Solution is a skincare product that helps refine and tighten the appearance of pores while controlling excess oil for a smoother, more even complexion.",
    },

    {
      "name": "Skin Brightening Toner",
      "img": "assets/skinbright.jpg",
      "price": "₱200",
      "desc":
          "Skin Brightening Toner is a skincare product that helps even out skin tone, reduce dullness, and enhance radiance by gently exfoliating and refreshing the skin.",
    },
    {
      "name": "Skin Nutrient Gel",
      "img": "assets/skinnutrientgel.jpg",
      "price": "₱200",
      "desc":
          "Skin Nutrient Gel is a lightweight gel that provides intense hydration and nourishment to the skin, leaving it soft and supple.",
    },
    {
      "name": "Sunblock Foundation Beige",
      "img": "assets/sunblockbeige.jpg",
      "price": "₱200",
      "desc":
          "Sunblock Foundation Beige is a lightweight foundation with SPF 30 that provides natural coverage while protecting the skin from UV rays.",
    },
    {
      "name": "Sunblock Gel",
      "img": "assets/sunblockgel.jpg",
      "price": "₱200",
      "desc":
          "Sunblock Gel is a lightweight, non-greasy gel that provides broad-spectrum SPF 50 protection while keeping the skin hydrated.",
    },
    {
      "name": "Sunblock Foundation Pink",
      "img": "assets/sunblockpink.jpg",
      "price": "₱200",
      "desc":
          "Sunblock Foundation Pink is a lightweight foundation with SPF 30 that provides natural coverage while protecting the skin from UV rays.",
    },
    {
      "name": "Tea Tree Soap",
      "img": "assets/teatree.jpg",
      "price": "₱200",
      "desc":
          "Tea Tree Soap is a natural antibacterial soap that helps cleanse the skin and reduce acne breakouts.",
    },
    {
      "name": "Triple Whitening",
      "img": "assets/triplewhitening.jpg",
      "price": "₱200",
      "desc":
          "Triple Whitening is a powerful whitening soap that helps reduce dark spots, even out skin tone, and brighten the complexion.",
    },
    // ... Add up to 22 products
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: Text(
          'Products',
          style: TextStyle(fontFamily: 'Poppins', color: Colors.pink[900]),
        ),
        backgroundColor: Colors.pink[100],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 18,
            crossAxisSpacing: 18,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, i) {
            final item = products[i];
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.asset(
                              item["img"]!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            item["name"]!,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.pink[800],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            item["desc"]!,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w300,
                              fontSize: 15,
                              color: Colors.grey[800],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 12),
                          Text(
                            item["price"]!,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.pink[600],
                            ),
                          ),
                          SizedBox(height: 18),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink[700],
                              shape: StadiumBorder(),
                              padding: EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Reserved for pickup!")),
                              );
                            },
                            child: Text(
                              "Reserve for Pickup",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.shade100.withOpacity(0.3),
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                  border: Border.all(color: Colors.pink.shade100, width: 2),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(22),
                      ),
                      child: Image.asset(
                        item["img"]!,
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Text(
                        item["name"]!,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.pink[800],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        item["desc"]!,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w300,
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Text(
                        item["price"]!,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.pink[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class IntroAnimationPage extends StatefulWidget {
  @override
  State<IntroAnimationPage> createState() => _IntroAnimationPageState();
}

class _IntroAnimationPageState extends State<IntroAnimationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _scale = Tween<double>(
      begin: 0.8,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
    Future.delayed(Duration(seconds: 4), () {
      // changed from 2 to 6
      Navigator.pushReplacementNamed(context, '/home');
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
      backgroundColor: Colors.pink[50],
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pinkAccent.withOpacity(0.4),
                    blurRadius: 60,
                    spreadRadius: 18,
                  ),
                ],
              ),
              child: Image.asset(
                'assets/bvella_logo.png',
                height: 500, // Bigger logo
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  void _submit() {
    if (_form.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Sign up successful!")));
      Navigator.pushReplacementNamed(context, '/intro');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all fields correctly."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        title: Text(
          "Sign Up",
          style: TextStyle(color: Colors.pink[900], fontFamily: 'Poppins'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                controller: _email,
                validator: (v) {
                  if (v == null || v.isEmpty) return "Email required";
                  if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(v))
                    return "Enter a valid email";
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Email",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _password,
                obscureText: true,
                validator: (v) {
                  if (v == null || v.isEmpty) return "Password required";
                  if (v.length < 6)
                    return "Password must be at least 6 characters";
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Password",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _confirmPassword,
                obscureText: true,
                validator: (v) {
                  if (v == null || v.isEmpty)
                    return "Confirm password required";
                  if (v != _password.text) return "Passwords do not match";
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              SizedBox(height: 25),
              Center(
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[700],
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String getServiceImage(String category) {
  switch (category) {
    case "Facials":
      return "assets/cleansing.jpg";
    case "Body Treatments":
      return "assets/bodytreatment.jpg";
    case "Slimming Treatments":
      return "assets/slimming.png";
    case "Laser Treatments":
      return "assets/Laser.jpg";
    case "Gluta Treatments":
      return "assets/gluta.png";
    default:
      return "assets/cleansing.jpg";
  }
}

class ProfilePage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: Text("My Profile"),
        backgroundColor: Colors.pink[300],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.pink[100],
              child: Icon(Icons.person, size: 60, color: Colors.pink[700]),
            ),
            SizedBox(height: 30),
            _buildTextField(
              controller: nameController,
              label: 'Name',
              icon: Icons.person,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: emailController,
              label: 'Email',
              icon: Icons.email,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: contactController,
              label: 'Contact Number',
              icon: Icons.phone,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: addressController,
              label: 'Address',
              icon: Icons.home,
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                // 🔒 Future logic for saving profile
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Successful update!"),
                    backgroundColor: Colors.pink[300],
                  ),
                );
              },
              icon: Icon(Icons.save),
              label: Text("Save"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[400],
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.pink[700]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      ),
    );
  }
}
