import 'package:flutter/material.dart';

void main() {
  runApp(CourseDashboardApp());
}

class CourseDashboardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: CourseDashboard(),
    );
  }
}

class Course {
  final String name;
  final String instructor;
  final IconData icon;

  Course({required this.name, required this.instructor, required this.icon});
}

class CourseDashboard extends StatefulWidget {
  @override
  _CourseDashboardState createState() => _CourseDashboardState();
}

class _CourseDashboardState extends State<CourseDashboard>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  String? _selectedCategory;
  bool _isButtonAnimated = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final List<String> _tabNames = ['Home', 'Courses', 'Profile'];
  final List<String> _categories = ['Science', 'Arts', 'Technology'];

  final List<Course> _courses = [
    Course(
      name: 'Mobile App Development',
      instructor: 'Dr. Smith',
      icon: Icons.phone_android,
    ),
    Course(
      name: 'Data Structures',
      instructor: 'Prof. Johnson',
      icon: Icons.storage,
    ),
    Course(
      name: 'Web Development',
      instructor: 'Dr. Brown',
      icon: Icons.web,
    ),
    Course(
      name: 'Database Systems',
      instructor: 'Prof. Wilson',
      icon: Icons.data_object,
    ),
    Course(
      name: 'Machine Learning',
      instructor: 'Dr. Davis',
      icon: Icons.psychology,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout Confirmation'),
          content: Text('Are you sure you want to exit the app?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // In a real app, you might navigate to login screen or close the app
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Logged out successfully!'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _animateEnrollButton() {
    setState(() {
      _isButtonAnimated = !_isButtonAnimated;
    });

    if (_isButtonAnimated) {
      _animationController.forward();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Enrollment process initiated!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      _animationController.reverse();
    }
  }

  Widget _buildHomeTab() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Icon(Icons.home, size: 60, color: Colors.blue),
                  SizedBox(height: 16),
                  Text(
                    'Welcome to Course Dashboard',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Manage your courses and track your progress',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),

          // Course Selection Dropdown
          Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Select Course Category',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Category',
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: _categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  if (_selectedCategory != null)
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Text(
                        'Selected Category: $_selectedCategory',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // Animated Action Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _animateEnrollButton,
                      child: Text('Enroll in Course'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        textStyle: TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesTab() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Available Courses',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _courses.length,
            itemBuilder: (context, index) {
              final course = _courses[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                child: ListTile(
                  key: Key('course_$index'),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(course.icon, color: Colors.white),
                  ),
                  title: Text(
                    course.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Instructor: ${course.instructor}'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Selected: ${course.name}'),
                        backgroundColor: Colors.blue,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProfileTab() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Profile Picture with network image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.network(
                      "https://picsum.photos/120/120?random=5",
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 120,
                          height: 120,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.person, size: 80, color: Colors.white),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Student Profile',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Esther Moaweni',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Information Technology Student',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _showLogoutDialog,
            child: Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              textStyle: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course Dashboard'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: Colors.blue[50],
            child: Text(
              'Current Tab: ${_tabNames[_currentIndex]}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                Container(key: Key('home_tab'), child: _buildHomeTab()),
                Container(key: Key('courses_tab'), child: _buildCoursesTab()),
                Container(key: Key('profile_tab'), child: _buildProfileTab()),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}