import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/employee_tab_controller/employee_search_controller.dart';
import 'package:time_attendance/controller/employee_tab_controller/emplyoee_controller.dart';
import 'package:time_attendance/model/employee_tab_model/employee_complete_model.dart';
// import 'package:time_attendance/model/employee_tab_model/employee_model.dart';
import 'package:time_attendance/model/employee_tab_model/employee_search_model.dart';
import 'package:time_attendance/model/master_tab_model/company_model.dart';
import 'package:time_attendance/model/master_tab_model/employee_type_model.dart';
import 'package:time_attendance/widget/reusable/button/custom_action_button.dart';
import 'package:time_attendance/widget/reusable/dialog/employee_selection_dialog.dart';
import 'package:time_attendance/widget/reusable/list/reusable_list.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';
import 'package:time_attendance/widget/reusable/search/reusable_search_field.dart';
import 'package:time_attendance/widget/reusable/pagination/pagination_widget.dart';
import 'package:time_attendance/model/master_tab_model/department_model.dart';
import 'package:time_attendance/model/master_tab_model/designation_model.dart';
import 'package:time_attendance/model/master_tab_model/location_model.dart';
import 'package:time_attendance/screen/employee_tab_screen/employee_screen/employee_form_screen.dart';
import 'package:time_attendance/widgets/mtaToast.dart';

class MainEmployeeScreen extends StatelessWidget {
  MainEmployeeScreen({super.key});

  final EmployeeSearchController controller =
      Get.put(EmployeeSearchController());
      final EmployeeController employeeController = Get.put(EmployeeController());
  final TextEditingController _searchController = TextEditingController();
  void showEmployeeSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EmployeeSelectionDialog(
        onEmployeeSelected: (selectedEmployee) {
          // Handle the selected employee here
          print('Selected Employee ID: ${selectedEmployee.employeeID}');
          print('Selected Employee Name: ${selectedEmployee.employeeName}');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          if (MediaQuery.of(context).size.width > 600)
            ReusableSearchField(
              searchController: _searchController,
              onSearchChanged: (value) =>
                  controller.updateSearchFilter(employeeName: value),
            ),
          const SizedBox(width: 20),
          CustomActionButton(
              label: 'Add Filter',
              onPressed: () => _showFilterDialog(context),
              icon: Icons.filter_list),
          CustomActionButton(
            label: 'Add Employee',
            onPressed: () {
              //  showEmployeeSelectionDialog(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmployeeForm()),
              );
            },
          ),
          HelpTooltipButton(
            tooltipMessage:
                'Manage employee information and records in this section.',
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
                responsiveWidth: false,
                searchController: _searchController,
                onSearchChanged: (value) =>
                    controller.updateSearchFilter(employeeName: value),
              ),
            ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!controller.hasSearched.value) {
                return const Center(
                    child: Text(
                        'Use the search or filter options to find employees'));
              }

              if (controller.filteredEmployees.isEmpty) {
                return const Center(child: Text('No employees found'));
              }

              return Column(
                children: [
                  Expanded(
                    child: ReusableTableAndCard(
                      data: List.generate(
                        controller.filteredEmployees.length,
                        (index) => {
                          'Employee ID':
                              controller.filteredEmployees[index].employeeID ??
                                  '',
                          'Name': controller
                                  .filteredEmployees[index].employeeName ??
                              '',
                          'Enroll ID':
                              controller.filteredEmployees[index].enrollID ??
                                  '',
                          'Company':
                              controller.filteredEmployees[index].companyName ??
                                  '',
                          'Department': controller
                                  .filteredEmployees[index].departmentName ??
                              '',
                          'Designation': controller
                                  .filteredEmployees[index].designationName ??
                              '',
                          'Type': controller
                                  .filteredEmployees[index].employeeType ??
                              '',
                        },
                      ),
                      headers: [
                        'Employee ID',
                        'Name',
                        'Enroll ID',
                        'Company',
                        'Department',
                        'Designation',
                        'Type',
                        'Actions'
                      ],
                      visibleColumns: [
                        'Employee ID',
                        'Name',
                        'Enroll ID',
                        'Company',
                        'Department',
                        'Designation',
                        'Type',
                        'Actions'
                      ],
                      onEdit: (row) async {
                        final employeeId = row['Employee ID'] ?? '';
                        if (employeeId.isNotEmpty) {
                          try {
                            final employee = await employeeController.getEmployeeDetailsById(employeeId);
                            if (employee.employeeProfessional != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EmployeeForm(employee: employee),
                                ),
                              );
                            }
                          } catch (e) {
                            MTAToast().ShowToast('Error loading employee details: ${e.toString()}');
                          }
                        }
                      },
                      onDelete: (row) {
                        final employee = controller.filteredEmployees.firstWhere(
                          (e) => e.employeeID == row['Employee ID'],
                        );
                        _showDeleteConfirmationDialog(context, employee);
                      },
                      onSort: (columnName, ascending) =>
                          controller.sortEmployees(columnName, ascending),
                    ),
                  ),
                  PaginationWidget(
                    currentPage: controller.currentPage.value + 1,
                    totalPages: (controller.totalRecords.value /
                            controller.recordsPerPage.value)
                        .ceil(),
                    onFirstPage: () => controller.goToPage(0),
                    onPreviousPage: () => controller.previousPage(),
                    onNextPage: () => controller.nextPage(),
                    onLastPage: () => controller.goToPage(
                        (controller.totalRecords.value /
                                    controller.recordsPerPage.value)
                                .ceil() -
                            1),
                    onItemsPerPageChange: (value) =>
                        controller.updateRecordsPerPage(value),
                    itemsPerPage: controller.recordsPerPage.value,
                    itemsPerPageOptions: const [10, 25, 50, 100],
                    totalItems: controller.totalRecords.value,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        titlePadding: const EdgeInsets.fromLTRB(24, 16, 8, 0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Filter Employees'),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                iconSize: 24,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: FilterDialogContent(),
        ),
      ),
    );
  }
}

class FilterDialogContent extends StatefulWidget {
  @override
  _FilterDialogContentState createState() => _FilterDialogContentState();
}

void _showDeleteConfirmationDialog(
    BuildContext context, EmployeeView employee) {
  final EmployeeController employeeController = Get.find<EmployeeController>();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text(employee.employeeStatus == 1
            ? 'Are you sure you want to mark "${employee.employeeName}" as "Inactive"?'
            : 'Are you sure you want to delete the employee "${employee.employeeName}"?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // EmployeeProfessional
              final EmployeeProfessional employeeProfessionalObj = EmployeeProfessional(
                enrollID: employee.enrollID ?? '',
                employeeID: employee.employeeID ?? '',
                employeeName: employee.employeeName ?? '',
                companyID: employee.companyID ?? '',
                departmentID: employee.departmentID ?? '',
                designationID: employee.designationID ?? '',
                locationID: employee.locationID ?? '',
                employeeTypeID: employee.employeeTypeID ?? '',
                employeeType: employee.employeeType ?? '',
                empStatus: employee.employeeStatus ?? 1,
                dateOfEmployment: employee.dateOfEmployment ?? '',
                dateOfLeaving:  '',
                seniorEmployeeID: employee.seniorEmployeeID ?? '',
                emailID: employee.emailID ?? '',
              );
              employeeController.deleteEmployee(employeeProfessionalObj);
              Navigator.of(context).pop();
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
        ],
      );
    },
  );
}

class _FilterDialogContentState extends State<FilterDialogContent> {
  final EmployeeSearchController controller = Get.find();

  // Text editing controllers
  final TextEditingController employeeIdController = TextEditingController();
  final TextEditingController enrollIdController = TextEditingController();
  final TextEditingController employeeNameController = TextEditingController();

  // Selected values
  String? selectedCompany;
  String? selectedDepartment;
  String? selectedLocation;
  String? selectedDesignation;
  String? selectedType;
  int selectedStatus = 1; // Default Active
  @override
  void initState() {
    super.initState();
    // Initialize text controllers with current filter values if any
    employeeIdController.text =
        controller.searchEmployeeView.value.employeeID ?? '';
    enrollIdController.text =
        controller.searchEmployeeView.value.enrollID ?? '';
    employeeNameController.text =
        controller.searchEmployeeView.value.employeeName ?? '';
    selectedStatus = controller.searchEmployeeView.value.employeeStatus ?? 1;

    // Initialize dropdown values with empty string as default
    selectedCompany = '';
    selectedDepartment = '';
    selectedLocation = '';
    selectedDesignation = '';
    selectedType = '';

    // Set values from searchEmployeeView if they exist
    if (controller.searchEmployeeView.value.departmentID?.isNotEmpty == true) {
      selectedDepartment = controller.searchEmployeeView.value.departmentID;
    }
    if (controller.searchEmployeeView.value.designationID?.isNotEmpty == true) {
      selectedDesignation = controller.searchEmployeeView.value.designationID;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: Company and Department
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Obx(() {
                    final companies = controller.branches;
                    return _buildDropdown(
                      'Company',
                      selectedCompany,
                      companies.toList(),
                      (value) => setState(() => selectedCompany = value),
                      labelMap: {'': 'Select Company'},
                    );
                  }),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Obx(() {
                    final depts = controller.departments;
                    return _buildDropdown(
                      'Department',
                      selectedDepartment,
                      depts.toList(),
                      (value) => setState(() => selectedDepartment = value),
                    );
                  }),
                ),
              ),
            ],
          ),

          // Row 2: Location and Designation
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Obx(() {
                    final locs = controller.locations;
                    return _buildDropdown(
                      'Location',
                      selectedLocation,
                      locs,
                      (value) => setState(() => selectedLocation = value),
                    );
                  }),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Obx(() {
                    final desigs = controller.designations;
                    return _buildDropdown(
                      'Designation',
                      selectedDesignation,
                      desigs.toList(),
                      (value) => setState(() => selectedDesignation = value),
                    );
                  }),
                ),
              ),
            ],
          ),

          // Row 3: Type and Status
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Obx(() {
                    final empType = controller.employeeTypes;
                    return _buildDropdown(
                      'Employee Type',
                      selectedType,
                      empType.toList(),
                      (value) => setState(() => selectedType = value),
                    );
                  }),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: _buildDropdown(
                    'Status',
                    selectedStatus.toString(),
                    ['1', '0'],
                    (value) =>
                        setState(() => selectedStatus = int.parse(value!)),
                    labelMap: {'1': 'Active', '0': 'Inactive'},
                  ),
                ),
              ),
            ],
          ),

          // Row 4: Employee ID and Enroll ID
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: _buildTextField('Employee ID', employeeIdController),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: _buildTextField('Enroll ID', enrollIdController),
                ),
              ),
            ],
          ),

          // Row 5: Employee Name (full width)
          _buildTextField('Employee Name', employeeNameController),

          // Buttons
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {
                  controller.updateSearchFilter(
                    employeeId: employeeIdController.text,
                    enrollId: enrollIdController.text,
                    employeeName: employeeNameController.text,
                    companyId: selectedCompany,
                    departmentId: selectedDepartment,
                    locationId: selectedLocation,
                    designationId: selectedDesignation,
                    employeeTypeId: selectedType,
                    employeeStatus: selectedStatus,
                  );
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.search, size: 20),
                label: const Text('Search'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List<dynamic> items,
    void Function(String?) onChanged, {
    Map<String, String>? labelMap,
  }) {
    // Ensure we have items to show
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          enabled: false,
          decoration: InputDecoration(
            labelText: '$label (Loading...)',
            border: const OutlineInputBorder(),
          ),
        ),
      );
    }

    // For department and designation, make sure we have valid items
    List<DropdownMenuItem<String>> dropdownItems = [];
    try {
      // Create a set to track used values and prevent duplicates
      final Set<String> usedValues = {};

      dropdownItems = items
          .map((item) {
            String itemValue;
            String itemLabel;

            if (item is DepartmentModel) {
              itemValue = item.departmentId;
              itemLabel = item.departmentName;
            } else if (item is DesignationModel) {
              itemValue = item.designationId;
              itemLabel = item.designationName;
            } else if (item is Location) {
              itemValue = item.locationID ?? '';
              itemLabel = item.locationName ?? '';
            } else if (item is BranchModel) {
              itemValue = item.branchId ?? '';
              itemLabel = item.branchName ?? '';
            } else if (item is EmployeeTypeModel) {
              itemValue = item.employeeTypeId;
              itemLabel = item.employeeTypeName;
            } else if (item is String) {
              itemValue = item;
              itemLabel = labelMap?[item] ?? item;
            } else {
              itemValue = item.toString();
              itemLabel = item.toString();
            }

            // Skip if this value is already used
            if (usedValues.contains(itemValue)) {
              return null;
            }
            usedValues.add(itemValue);

            return DropdownMenuItem<String>(
              value: itemValue,
              child: Text(itemLabel),
            );
          })
          .whereType<DropdownMenuItem<String>>() // Remove null items
          .toList(); // Add an initial "Select" item only for non-Status dropdowns
      if (label != 'Status') {
        dropdownItems.insert(
            0,
            DropdownMenuItem<String>(
              value: '',
              child: Text('All'),
            ));
      }
    } catch (e) {
      print('Error building dropdown items for $label: $e');
      dropdownItems = [
        DropdownMenuItem<String>(
          value: label == 'Status' ? '1' : '',
          child: Text(label == 'Status' ? 'Active' : 'All'),
        )
      ];
    }

    // Make sure the current value exists in the items
    bool valueExists =
        value == '' || dropdownItems.any((item) => item.value == value);
    String? effectiveValue = valueExists ? value : '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: effectiveValue,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: dropdownItems,
        onChanged: onChanged,
        isExpanded: true,
      ),
    );
  }

  @override
  void dispose() {
    employeeIdController.dispose();
    enrollIdController.dispose();
    employeeNameController.dispose();
    super.dispose();
  }
}
