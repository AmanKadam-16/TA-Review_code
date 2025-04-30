// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:time_attendance/controller/master_tab_controller/department_controller.dart';
// import 'package:time_attendance/controller/master_tab_controller/designation_controller.dart';
// import 'package:time_attendance/controller/master_tab_controller/location_controller.dart';
// import 'package:time_attendance/theme/font.dart';
// import 'package:time_attendance/util/router/go_router/router.dart';
// import 'theme/theme.dart';

// void main() {
//   runApp(const MyApp());
//    Get.put(DesignationController());
//    Get.put(DepartmentsController());4
//    Get.put(LocationController());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Create an instance of your MaterialTheme
//      TextTheme textTheme = createTextTheme(context, "Inter", "Roboto");
//     final MaterialTheme theme = MaterialTheme(textTheme);
//     return MaterialApp.router(
//       title: 'Time Attendance Project',
//       theme: theme.light(), // Use the light theme
//       routerConfig: router, // Use the GoRouter configuration
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/Data_entry_tab_controller/inventry_controller.dart';
import 'package:time_attendance/controller/employee_tab_controller/emp_practice_controller.dart';
import 'package:time_attendance/controller/employee_tab_controller/emplyoee_controller.dart';
import 'package:time_attendance/controller/master_tab_controller/company_controller.dart';
import 'package:time_attendance/controller/master_tab_controller/department_controller.dart';
import 'package:time_attendance/controller/master_tab_controller/designation_controller.dart';
import 'package:time_attendance/controller/master_tab_controller/emplyee_type_controller.dart';
import 'package:time_attendance/controller/master_tab_controller/holiday_controller.dart';
import 'package:time_attendance/controller/master_tab_controller/location_controller.dart';
import 'package:time_attendance/controller/reports_controller/master_reports_controller.dart';
// import 'package:time_attendance/controller/reusable_widget_controller/date_picker_controller.dart';
import 'package:time_attendance/controller/setting/setting_controller.dart';
import 'package:time_attendance/controller/shift_tab_controller/shift_details_controller.dart';
import 'package:time_attendance/controller/shift_tab_controller/shift_pattern_controller.dart';
import 'package:time_attendance/theme/font.dart';
import 'package:time_attendance/theme/theme.dart';
import 'package:time_attendance/util/router/go_router/router.dart';

void main() {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  // Configure SSL context (if needed)
  // final context = SecurityContext.defaultContext;
  // context.allowLegacyUnsafeRenegotiation = true;

  // Initialize controllers using GetX
  Get.put(DesignationController());
  Get.put(DepartmentController());
  Get.put(LocationController());
  Get.put(BranchController());
  Get.put(HolidaysController());
  Get.put(EmployeeController());
  Get.put(EmplyeeTypeController());
  Get.put(ShiftDetailsController());
  Get.put(ShiftPatternController());
  Get.put(EmployeePracticeController());
  Get.put(EmployeeSettingsController());
  Get.put(MasterReportController());
  Get.put(DeviceController());
  // Get.put(DatePickerController());
  Get.put(InventoryController());
  Get.put(DownloadDeviceController());
  

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create text theme
    TextTheme textTheme = createTextTheme(context, "Inter", "Roboto");
    final MaterialTheme theme = MaterialTheme(textTheme);

    // Return MaterialApp with router configuration
    return MaterialApp.router(
      title: 'Time Attendance',
      theme: theme.light(),
      // darkTheme: theme.dark(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}