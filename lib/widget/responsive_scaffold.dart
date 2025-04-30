import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:time_attendance/model/TALogin/session_manager.dart'
    if (dart.library.html) 'package:time_attendance/model/TALogin/session_manager_web.dart'
    if (dart.library.io) 'package:time_attendance/model/TALogin/session_manager_mobile.dart';

class ResponsiveScaffold extends StatelessWidget {
  final Widget child;

  const ResponsiveScaffold({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        title: const Text('Time Attendance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              context.go('/employeesettingss');
            },
          ),
          if (MediaQuery.of(context).size.width > 600) 
            IconButton(
              icon: const Icon(Icons.notifications),
              tooltip: 'Notifications',
              onPressed: () {},
            ),
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/user_avatar.png'),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            offset: Offset(0, 50),
            onSelected: (value) {
              if (value == 'logout') {
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => const SignInScreen()),
                // );
              } else if (value == 'view_profile') {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => const GuestProfileScreen()),
                // );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              if (MediaQuery.of(context).size.width <= 600) ...[
                PopupMenuItem<String>(
                  value: 'settings',
                  onTap: () {
                    context.go('/employeesettingss');
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.settings),
                      SizedBox(width: 8),
                      Text('Settings'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'notifications',
                  child: Row(
                    children: [
                      Icon(Icons.notifications),
                      SizedBox(width: 8),
                      Text('Notifications'),
                    ],
                  ),
                ),
              ],
              const PopupMenuItem<String>(
                value: 'view_profile',
                child: Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 8),
                    Text('View Profile'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'logout',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context); // Close the dialog first
                              await PlatformSessionManager.clearSession();
                              context.go('/login'); // Redirect to login page
                            },
                            child: const Text('Logout'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                children: [
                  FutureBuilder<Map<String, dynamic>?>(
                    future: PlatformSessionManager.getLoginDetails(),
                    builder: (context, snapshot) {
                      return Text(snapshot.data?['UserName'] ?? 'User');
                    },
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: child,
    );
  }

  // Drawer for mobile view
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              'Time Attendance',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          _buildDrawerItem(context, '/home', 'Home', Icons.home),
          ExpansionTile(
            leading: Icon(Icons.settings),
            title: Text('Master'),
            shape: Border.all(color: Colors.transparent),
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: _buildDrawerItem(
                    context, '/designation', 'Designation', Icons.badge),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: _buildDrawerItem(
                    context, '/department', 'Department', Icons.business),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: _buildDrawerItem(
                    context, '/company', 'Company', Icons.business),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: _buildDrawerItem(
                    context, '/location', 'Location', Icons.location_on),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: _buildDrawerItem(
                    context, '/holiday', 'Holiday', Icons.calendar_today),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: _buildDrawerItem(context, '/employeeType',
                    'Employee Type', Icons.work_history),
              ),
              // _buildDrawerItem(context, '/employee', 'Employee', Icons.business),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.punch_clock_rounded),
            title: Text('Shift'),
            shape: Border.all(color: Colors.transparent),
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: _buildDrawerItem(
                    context, '/shiftdetail', 'Shift Details', Icons.lock_clock),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: _buildDrawerItem(
                    context, '/shiftpattern', 'Shift Pattern', Icons.lock_clock),
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.people),
            title: Text('Employee'),
            shape: Border.all(color: Colors.transparent),
            children: [
              
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: _buildDrawerItem(
                    context, '/employee', 'Employee', Icons.people),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: _buildDrawerItem(
                    context, '/employeefilter', 'Employee Filter', Icons.people),
              ),
            ],
          ),
          // ExpansionTile(
          //   leading: Icon(Icons.laptop_mac),
          //   title: Text('Device Management'),
          //   shape: Border.all(color: Colors.transparent),
          //   children: [
              
          //     Padding(
          //       padding: EdgeInsets.only(left: 16.0),
          //       child: _buildDrawerItem(
          //           context, '/device', 'Device', Icons.laptop),
          //     ),
             
          //   ],
          // ),
          ExpansionTile(
            leading: Icon(Icons.house),
            title: Text('Housekeeping'),
            shape: Border.all(color: Colors.transparent),
            children: [
              
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: _buildDrawerItem(
                    context, '/device1', 'Device', Icons.laptop),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: _buildDrawerItem(
                    context, '/downoaddevice',
                    'Download Device', Icons.download),
              ),
             
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.data_usage),
            title: Text('Data Entry'),
            shape: Border.all(color: Colors.transparent),
            children: [
              
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: _buildDrawerItem(
                    context, '/inventory', 'Inventory', Icons.track_changes),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: _buildDrawerItem(
                    context, '/dataprocess', 'Data Process', Icons.track_changes),
              ),
             
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.assignment),
            title: Text('Reports'),
            shape: Border.all(color: Colors.transparent),
            children: [
              
              // Padding(
              //   padding: EdgeInsets.only(left: 16.0),
              //   child: _buildDrawerItem(
              //       context, '/inventry', 'Inventry', Icons.track_changes),
              // ),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: _buildDrawerItem(
                    context, '/masterreport', 'Master Report', Icons.analytics),
              ),
             
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, String path, String label, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected:
          GoRouter.of(context).routeInformationProvider.value.uri.path == path,
      onTap: () {
        Navigator.pop(context);
        context.go(path);
      },
    );
  }

  // Horizontal NavBar for tablet and desktop
  List<Widget> _buildHorizontalNavBar(BuildContext context) {
    return [
      _buildNavItem(context, '/home', 'Home'),
      _buildNavItem(context, '/designation', 'Designation'),
      _buildNavItem(context, '/department', 'Department'),
      _buildNavItem(context, '/company', 'Company'),
      _buildNavItem(context, '/location', 'Location'),
      _buildNavItem(context, '/holiday', 'Holiday'),
      _buildNavItem(context, '/employeeType', 'Employee Type'),
      _buildNavItem(context, '/employee', 'Employee'),
      _buildNavItem(context, '/shiftdetail', 'Shift Details'),
      _buildNavItem(context, '/shiftpattern', 'Shift Pattern'),
      _buildNavItem(context, '/employeefilter', 'Employee Filter'),
      // _buildNavItem(context, '/device', 'device'),
      _buildNavItem(context, '/device1', 'device'),
      _buildNavItem(context, '/masterreport', 'Master Report'),
      _buildNavItem(context, '/inventory', 'Inventory'),
      _buildNavItem(context, '/downoaddevice', 'Download Device'),
    ];
  }

  Widget _buildNavItem(BuildContext context, String path, String label) {
    final isSelected =
        GoRouter.of(context).routeInformationProvider.value.uri.path == path;
    return TextButton(
      onPressed: () => context.go(path),
      style: ButtonStyle(
        // backgroundColor: WidgetStateProperty.all(
        //   isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : Colors.transparent,
        // ),
        padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color:
              isSelected ? Theme.of(context).colorScheme.primary : Colors.black,
        ),
      ),
    );
  }
}
