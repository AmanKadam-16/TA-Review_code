// main_department_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/employee_tab_controller/emp_practice_controller.dart';
import 'package:time_attendance/controller/master_tab_controller/department_controller.dart';
import 'package:time_attendance/controller/employee_tab_controller/settingprofile_controller.dart';
import 'package:time_attendance/model/employee_tab_model/settingprofile.dart';
import 'package:time_attendance/screen/employee_tab_screen/setting_profile/add_edit_setting_profile_screen.dart';
import 'package:time_attendance/widget/reusable/button/custom_action_button.dart';
import 'package:time_attendance/widget/reusable/filter/filter.dart';
import 'package:time_attendance/widget/reusable/list/reusable_list.dart';
import 'package:time_attendance/widget/reusable/pagination/pagination_widget.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';
import 'package:time_attendance/widget/reusable/search/reusable_search_field.dart';

class MainEmployeeSettingScreen extends StatefulWidget {
  const MainEmployeeSettingScreen({super.key});

  @override
  State<MainEmployeeSettingScreen> createState() => _MainEmployeeSettingScreenState();
}

class _MainEmployeeSettingScreenState extends State<MainEmployeeSettingScreen> {
  final DepartmentController controller = Get.put(DepartmentController());
  final EmployeePracticeController controller1 = Get.put(EmployeePracticeController());
  final SettingProfileController settingProfileController = Get.put(SettingProfileController());
  final TextEditingController _searchController = TextEditingController();
  int _currentPage = 1;
  int _itemsPerPage = 10;
  int _totalPages = 1;
  Set<String> selectedEmployees = {};
  bool selectAll = false;

  Map<String, List<String>> getFilterOptions() {
    final allOptions = controller1.filterOptions;
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
  void initState() {
    super.initState();
    controller.initializeAuthDept();
    settingProfileController.initializeAuthProfile();
  }

  void _handlePageChange(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _handleItemsPerPageChange(int value) {
    setState(() {
      _itemsPerPage = value;
      _currentPage = 1;
    });
  }

  void _showApplySettingsDialog(BuildContext context) {
    SettingProfileModel? selectedProfile;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Setting Profiles'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<SettingProfileModel>(
                    value: selectedProfile,
                    hint: const Text('Select Setting Profile'),
                    isExpanded: true,
                    items: settingProfileController.settingProfiles.map((profile) {
                      return DropdownMenuItem<SettingProfileModel>(
                        value: profile,
                        child: Text(profile.profileName),
                      );
                    }).toList(),
                    onChanged: (SettingProfileModel? value) {
                      setState(() {
                        selectedProfile = value;
                      });
                    },
                  ),
                  if (selectedProfile != null) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Description:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(selectedProfile!.description),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: selectedProfile == null ? null : () {
                    // TODO: Implement apply settings logic
                    Navigator.of(context).pop();
                  },
                  child: const Text('Apply Settings'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees Settings'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          SizedBox(
            width: 200,
            child: ReusableSearchField(
              searchController: _searchController,
              onSearchChanged: controller.updateSearchQuery,
            ),
          ),
          const SizedBox(width: 8),
          Obx(() => ExpandableFilter(
                filterOptions: getFilterOptions(),
                onApplyFilters: (filters) {},
                onClearFilters: controller1.clearFilters,
                isLoading: controller1.isLoading.value,
              )),
          CustomActionButton(
            label: 'Apply Profile',
            onPressed: () => _showApplySettingsDialog(context),
          ),
          const SizedBox(width: 8),
          HelpTooltipButton(
            tooltipMessage: 'Assign Setting Profiles to employees for managing their configurations.',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          if (MediaQuery.of(context).size.width <= 600)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ReusableSearchField(
                searchController: _searchController,
                onSearchChanged: controller.updateSearchQuery,
                responsiveWidth: false,
              ),
            ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                children: [
                  Expanded(
                    child: ReusableTableAndCard(
                      data: List.generate(
                        controller.filteredDepartments.length,
                        (index) {
                          final dept = controller.filteredDepartments[index];
                          return {
                            'Employee ID': dept.departmentId,
                            'Employee Name': dept.departmentName,
                            'Setting Profile': dept.masterDepartmentName,
                          };
                        },
                      ),
                      headers: const [
                        'Employee ID',
                        'Employee Name',
                        'Setting Profile',
                        'Actions'
                      ],
                      visibleColumns: const [
                        'Employee ID',
                        'Employee Name',
                        'Setting Profile',
                        'Actions'
                      ],
                      showCheckboxes: true,
                      selectedItems: selectedEmployees,
                      idField: 'Employee ID',
                      onSelectAll: (bool? value) {
                        setState(() {
                          if (value ?? false) {
                            selectedEmployees = controller.filteredDepartments
                                .map((dept) => dept.departmentId)
                                .toSet();
                          } else {
                            selectedEmployees.clear();
                          }
                        });
                      },
                      onSelectItem: (String id, bool selected) {
                        setState(() {
                          if (selected) {
                            selectedEmployees.add(id);
                          } else {
                            selectedEmployees.remove(id);
                          }
                        });
                      },
                      onEdit: (row) {
                        final employeeId = row['Employee ID'];
                        final settingProfile = settingProfileController.settingProfiles.firstWhere(
                          (profile) => profile.profileId == employeeId,
                          orElse: () => SettingProfileModel(
                            profileId: '',
                            profileName: '',
                            description: '',
                            isDefaultProfile: false,
                            isEmpWeeklyOffAdjustable: false,
                            isShiftStartFromJoiningDate: false,
                            changesDoneOn: '',
                            changesDoneOnDateTime: DateTime.now(),
                            changesDoneBy: '',
                          ),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddEditSettingProfileScreen(profile: settingProfile),
                          ),
                        );
                      },
                      onDelete: null,
                    ),
                  ),
                  PaginationWidget(
                    currentPage: _currentPage,
                    totalPages: _totalPages,
                    onFirstPage: () => _handlePageChange(1),
                    onPreviousPage: () => _handlePageChange(_currentPage - 1),
                    onNextPage: () => _handlePageChange(_currentPage + 1),
                    onLastPage: () => _handlePageChange(_totalPages),
                    onItemsPerPageChange: _handleItemsPerPageChange,
                    itemsPerPage: _itemsPerPage,
                    itemsPerPageOptions: const [10, 25, 50, 100],
                    totalItems: controller.filteredDepartments.length,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
