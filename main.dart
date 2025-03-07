import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SOSMate',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    EmergencyPage(),
    AnalysisPage(),
    ContactsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crime Analysis App',
            style: TextStyle(fontSize: 24, color: Colors.blue)),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'Emergency',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analysis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigoAccent,
        unselectedItemColor: Colors.blue,
        backgroundColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> safetyTips = [
    "Always lock your doors when you get inside your car.",
    "Stay aware of your surroundings when walking alone.",
    "Keep emergency numbers saved in your phone.",
    "Trust your instincts if something feels off.",
    "Carry a whistle or pepper spray for safety.",
    "Always tell someone your whereabouts.",
    "Avoid talking to strangers in isolated areas.",
  ];

  String _currentTip = "Tap for a random safety tip!";

  void _changeTip() {
    setState(() {
      _currentTip =
          safetyTips[(safetyTips.indexOf(_currentTip) + 1) % safetyTips.length];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App title
            Text(
              'SOSMate',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            Text(
              'Your friend during SOS',
              style: TextStyle(fontSize: 18, color: Colors.blueGrey),
            ),
            SizedBox(height: 30),

            // Safety tip text
            GestureDetector(
              onTap: _changeTip,
              child: Text(
                _currentTip,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmergencyPage extends StatefulWidget {
  @override
  _EmergencyPageState createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;
  bool _isBlinking = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _shakeAnimation = Tween<double>(begin: -10, end: 10).animate(_controller);
  }

  void _triggerEmergency() {
    setState(() {
      _isBlinking = !_isBlinking;
    });

    Timer(Duration(seconds: 3), () {
      setState(() {
        _isBlinking = false;
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Emergency button has been pressed!')),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _shakeAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_shakeAnimation.value, 0),
            child: GestureDetector(
              onTap: _triggerEmergency,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isBlinking ? Colors.red : Colors.redAccent,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red,
                      blurRadius: _isBlinking ? 25 : 0,
                      spreadRadius: _isBlinking ? 5 : 0,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'SOS',
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AnalysisPage extends StatelessWidget {
  final List<String> imagePaths = [
    'assets/images/crime_by_city.png',
    'assets/images/closure_rate.png',
    'assets/images/violent_crimes_weapons.png',
    'assets/images/top_crimes.png',
    'assets/images/metro_vs_non_metro.png',
    'assets/images/crime_closure_rate.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crime Data Analysis')),
      body: Container(
        color: Colors.grey[100], // Subtle background for better contrast
        padding: EdgeInsets.all(12),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 images per row
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.3, // Smaller images
          ),
          itemCount: imagePaths.length,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4, // Lighter shadow for a cleaner look
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePaths[index],
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ContactsPage extends StatelessWidget {
  void _callNumber(String number) async {
    final Uri url = Uri.parse('tel:$number');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $number';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        _buildContactItem('NATIONAL EMERGENCY NUMBER', '112'),
        _buildContactItem('POLICE', '100 or 112'),
        _buildContactItem('FIRE', '101'),
        _buildContactItem('AMBULANCE', '102'),
        _buildContactItem('Disaster Management Services', '108'),
        _buildContactItem('Women Helpline', '1091'),
        _buildContactItem('Women Helpline - (Domestic Abuse)', '181'),
        _buildContactItem('Road Accident Emergency Service', '1073'),
        _buildContactItem(
            'Road Accident Emergency Service On National Highway For Private Operators',
            '1033'),
        _buildContactItem('Children In Difficult Situation', '1098'),
        _buildContactItem('CYBER CRIME HELPLINE', '1930'),
        _buildContactItem(
            'Poison Information Centre (CMC, Vellore)', '18004251213'),
      ],
    );
  }

  Widget _buildContactItem(String title, String number) {
    return Card(
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(number, style: TextStyle(color: Colors.blue)),
        trailing: IconButton(
          icon: Icon(Icons.call, color: Colors.green),
          onPressed: () => _callNumber(number),
        ),
      ),
    );
  }
}