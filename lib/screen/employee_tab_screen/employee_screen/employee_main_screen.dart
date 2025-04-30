import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/employee_tab_controller/emplyoee_controller.dart';
import 'package:time_attendance/screen/employee_tab_screen/employee_screen/employee_form_screen.dart';
import 'package:time_attendance/widget/reusable/button/custom_action_button.dart';
import 'package:time_attendance/widget/reusable/filter/filter.dart';
import 'package:time_attendance/widget/reusable/list/reusable_list.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';
import 'package:time_attendance/widget/reusable/search/reusable_search_field.dart';
import 'package:time_attendance/controller/employee_tab_controller/emp_practice_controller.dart';

class MainEmployeeScreen extends GetView<EmployeeController> {
  final EmployeePracticeController controller1 = Get.find<EmployeePracticeController>();
  final TextEditingController _searchController = TextEditingController();
  
  MainEmployeeScreen({super.key});

  // Function to get only the desired filter options
  Map<String, List<String>> getFilterOptions() {
    // Get all available options from controller
    final allOptions = controller1.filterOptions;
    
    // Create a new map with only the filters you want to show
    return {
      if (allOptions.containsKey('Department')) 
        'Department': allOptions['Department']!.map((option) => option.value).toList(),
      if (allOptions.containsKey('Designation')) 
        'Designation': allOptions['Designation']!.map((option) => option.value).toList(),
      if (allOptions.containsKey('Shift')) 
        'Shift': allOptions['Shift']!.map((option) => option.value).toList(),
        if (allOptions.containsKey('Branch')) 
        'Branch': allOptions['Branch']!.map((option) => option.value).toList(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width <= 600;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Employees Search',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          if (!isMobile) ...[
            Obx(() => ExpandableFilter(
              filterOptions: getFilterOptions(), // Use the custom filter options
              onApplyFilters: (filters) {
                // controller1.selectedBranch.value = filters['Branch'] ?? '';
                // controller1.selectedDepartment.value = filters['Department'] ?? '';
                // controller1.selectedDesignation.value = filters['Designation'] ?? '';
                // controller1.selectedShift.value = filters['Shift'] ?? '';
              },
              onClearFilters: controller1.clearFilters,
              isLoading: controller1.isLoading.value,
            )),
            const SizedBox(width: 8),
            SizedBox(
              width: 200,
              child: ReusableSearchField(
                searchController: _searchController,
                onSearchChanged: controller.updateSearchQuery,
              ),
            ),
            const SizedBox(width: 8),
            CustomActionButton(
              label: 'Add Employee',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmployeeForm(),
                  ),
                );
              },
            ),
          ],
          if (isMobile) ...[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() => ExpandableFilter(
                  filterOptions: getFilterOptions(), // Use the custom filter options
                  onApplyFilters: (filters) {
                    // controller1.selectedDepartment.value = filters['Department'] ?? '';
                    // controller1.selectedDesignation.value = filters['Designation'] ?? '';
                    // controller1.selectedShift.value = filters['Shift'] ?? '';
                  },
                  onClearFilters: controller1.clearFilters,
                  isLoading: controller1.isLoading.value,
                )),
                const SizedBox(width: 8),
                CustomActionButton(
                  label: 'Add',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmployeeForm(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
          const SizedBox(width: 8),
          HelpTooltipButton(
            tooltipMessage:
                'Employee management is a crucial aspect of any organization. It involves the recruitment, training, and management of employees to ensure their effective performance and contribution to the organization.',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              if (isMobile)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ReusableSearchField(
                      searchController: _searchController,
                      onSearchChanged: controller.updateSearchQuery,
                      responsiveWidth: false,
                    ),
                  ),
                ),
              Expanded(
                child: Obx(
                  () => ReusableTableAndCard(
                    data: controller.filteredEmployees
                        .map((e) => e.toMap())
                        .toList(),
                    headers: controller.headers,
                    onEdit: controller.onEdit,
                    onDelete: (id) async {
                      final result = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text('Are you sure you want to delete this employee?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                      if (result == true) {
                        controller.deleteEmployee(id);
                      }
                    },
                    onSort: controller.onSort,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}