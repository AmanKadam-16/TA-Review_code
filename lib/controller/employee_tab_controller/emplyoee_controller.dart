import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/model/employee_tab_model/employee_model.dart';
// import '../models/employee_model.dart';

class EmployeeController extends GetxController {
  final employeeModel = Employee().obs;
  
  
  // Form field values
  final Rx<String?> selectedCompany = Rx<String?>(null);
  final Rx<String?> selectedDepartment = Rx<String?>(null);
  final Rx<String?> selectedStatus = Rx<String?>('Active');
  final Rx<String?> selectedDesignation = Rx<String?>(null);
  final Rx<String?> selectedLocation = Rx<String?>(null);
  final Rx<String?> selectedType = Rx<String?>(null);
  final shiftType = "Fix".obs;
  
  // Professional Details Controllers
  final employeeIdController = TextEditingController();
  final enrollIdController = TextEditingController();
  final employeeNameController = TextEditingController();
  final designationController = TextEditingController();
  final dateOfJoiningController = TextEditingController();
  final seniorReportingController = TextEditingController();
  final officeEmailController = TextEditingController();
  final dateOfLeavingController = TextEditingController();
  final employeeTypeController = TextEditingController();

  // Personal Details Controllers
  final genderController = TextEditingController();
  final bloodGroupController = TextEditingController();
  final nationalityController = TextEditingController();
  final personalEmailController = TextEditingController();
  final mobileNoController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final localAddressController = TextEditingController();
  final permanentAddressController = TextEditingController();
  final contactNoController = TextEditingController();

  final searchQuery = ''.obs;
  final RxList<Employee> filteredEmployees = <Employee>[].obs;
  
  // Sorting
  final sortColumn = ''.obs;
  final isAscending = true.obs;
 final List<String> headers = [
    'Employee ID',
    'Employee Name',
    'Enroll ID',
    'Company',
    'Department',
    'Designation',
    'Location',
    
    'Type',
    'Actions'
  ];
  // Dropdown options
  final List<String> companies = [
    'Insignia E Security Pvt. Ltd.',
    'Tech Solutions Inc.',
    'Global Systems Ltd.'
  ];

  final List<String> departments = [
    'IT',
    'HR',
    'Finance',
    'Operations',
    'Marketing'
  ];

  final List<String> statusOptions = [
    'Active',
    'Inactive'
  ];

  final List<String> designations = [
    'Software Engineer',
    'Project Manager',
    'Team Lead',
    'HR Manager',
    'Accountant'
  ];

  final List<String> locations = [
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Pune',
    'Chennai'
  ];

  final List<String> types = [
    'Full Time',
    'Part Time',
    'Contract',
    'Intern'
  ];

  final List<String> shiftOptions = ["Morning", "Evening", "Night"];

  // Sample employee data
  final List<Employee> sampleEmployees = [
    Employee(
      employeeId: "EMP001",
      employeeName: "Rajesh Kumar",
      enrollId: "ENR001",
      company: "Tech Solutions Inc.",
      department: "IT",
      designation: "Software Engineer",
      location: "Mumbai",
      status: "Active",
      type: "Full Time"
    ),
    Employee(
      employeeId: "EMP002",
      employeeName: "Priya Sharma",
      enrollId: "ENR002",
      company: "Insignia E Security Pvt. Ltd.",
      department: "HR",
      designation: "HR Manager",
      location: "Delhi",
      status: "Active",
      type: "Full Time"
    ),
    Employee(
      employeeId: "EMP003",
      employeeName: "Amit Patel",
      enrollId: "ENR003",
      company: "Global Systems Ltd.",
      department: "Finance",
      designation: "Accountant",
      location: "Bangalore",
      status: "Active",
      type: "Full Time"
    ),
    Employee(
      employeeId: "EMP004",
      employeeName: "Sneha Reddy",
      enrollId: "ENR004",
      company: "Tech Solutions Inc.",
      department: "Marketing",
      designation: "Team Lead",
      location: "Chennai",
      status: "Active",
      type: "Full Time"
    ),
    Employee(
      employeeId: "EMP005",
      employeeName: "Vikram Singh",
      enrollId: "ENR005",
      company: "Insignia E Security Pvt. Ltd.",
      department: "Operations",
      designation: "Project Manager",
      location: "Pune",
      status: "Active",
      type: "Full Time"
    ),
    Employee(
      employeeId: "EMP006",
      employeeName: "Ananya Gupta",
      enrollId: "ENR006",
      company: "Tech Solutions Inc.",
      department: "IT",
      designation: "Software Engineer",
      location: "Mumbai",
      status: "Active",
      type: "Contract"
    ),
    Employee(
      employeeId: "EMP007",
      employeeName: "Arjun Malhotra",
      enrollId: "ENR007",
      company: "Global Systems Ltd.",
      department: "IT",
      designation: "Team Lead",
      location: "Bangalore",
      status: "Active",
      type: "Full Time"
    ),
    Employee(
      employeeId: "EMP008",
      employeeName: "Neha Verma",
      enrollId: "ENR008",
      company: "Tech Solutions Inc.",
      department: "HR",
      designation: "HR Manager",
      location: "Delhi",
      status: "On Leave",
      type: "Full Time"
    ),
    Employee(
      employeeId: "EMP009",
      employeeName: "Karthik Iyer",
      enrollId: "ENR009",
      company: "Insignia E Security Pvt. Ltd.",
      department: "Finance",
      designation: "Accountant",
      location: "Chennai",
      status: "Active",
      type: "Full Time"
    ),
    Employee(
      employeeId: "EMP010",
      employeeName: "Meera Krishnan",
      enrollId: "ENR010",
      company: "Global Systems Ltd.",
      department: "Marketing",
      designation: "Team Lead",
      location: "Pune",
      status: "Active",
      type: "Part Time"
    ),
    Employee(
      employeeId: "EMP011",
      employeeName: "Aditya Mehta",
      enrollId: "ENR011",
      company: "Tech Solutions Inc.",
      department: "Operations",
      designation: "Project Manager",
      location: "Mumbai",
      status: "Active",
      type: "Full Time"
    ),
    Employee(
      employeeId: "EMP012",
      employeeName: "Divya Nair",
      enrollId: "ENR012",
      company: "Insignia E Security Pvt. Ltd.",
      department: "IT",
      designation: "Software Engineer",
      location: "Bangalore",
      status: "Active",
      type: "Intern"
    ),
    Employee(
      employeeId: "EMP013",
      employeeName: "Rahul Kapoor",
      enrollId: "ENR013",
      company: "Global Systems Ltd.",
      department: "HR",
      designation: "HR Manager",
      location: "Delhi",
      status: "Active",
      type: "Full Time"
    ),
    Employee(
      employeeId: "EMP014",
      employeeName: "Pooja Desai",
      enrollId: "ENR014",
      company: "Tech Solutions Inc.",
      department: "Finance",
      designation: "Accountant",
      location: "Chennai",
      status: "Inactive",
      type: "Full Time"
    ),
    Employee(
      employeeId: "EMP015",
      employeeName: "Suresh Menon",
      enrollId: "ENR015",
      company: "Insignia E Security Pvt. Ltd.",
      department: "Marketing",
      designation: "Team Lead",
      location: "Pune",
      status: "Active",
      type: "Full Time"
    ),
    Employee(
      employeeId: "EMP016",
      employeeName: "Riya Chatterjee",
      enrollId: "ENR016",
      company: "Global Systems Ltd.",
      department: "IT",
      designation: "Software Engineer",
      location: "Mumbai",
      status: "Active",
      type: "Contract"
    ),
    Employee(
      employeeId: "EMP017",
      employeeName: "Sanjay Joshi",
      enrollId: "ENR017",
      company: "Tech Solutions Inc.",
      department: "Operations",
      designation: "Project Manager",
      location: "Bangalore",
      status: "Active",
      type: "Full Time"
    ),
    Employee(
      employeeId: "EMP018",
      employeeName: "Kavita Rao",
      enrollId: "ENR018",
      company: "Insignia E Security Pvt. Ltd.",
      department: "IT",
      designation: "Team Lead",
      location: "Delhi",
      status: "On Leave",
      type: "Full Time"
    ),
    Employee(
      employeeId: "EMP019",
      employeeName: "Deepak Shetty",
      enrollId: "ENR019",
      company: "Global Systems Ltd.",
      department: "HR",
      designation: "HR Manager",
      location: "Chennai",
      status: "Active",
      type: "Full Time"
    ),
    Employee(
      employeeId: "EMP020",
      employeeName: "Anjali Mathur",
      enrollId: "ENR020",
      company: "Tech Solutions Inc.",
      department: "Finance",
      designation: "Accountant",
      location: "Pune",
      status: "Active",
      type: "Part Time"
    ),
    Employee(
      employeeId: "EMP021",
      employeeName: "Vivek Khanna",
      enrollId: "ENR021",
      company: "Insignia E Security Pvt. Ltd.",
      department: "Marketing",
      designation: "Team Lead",
      location: "Mumbai",
      status: "Active",
      type: "Full Time"
    ),
    Employee(
      employeeId: "EMP022",
      employeeName: "Shweta Agarwal",
      enrollId: "ENR022",
      company: "Global Systems Ltd.",
      department: "IT",
      designation: "Software Engineer",
      location: "Bangalore",
      status: "Active",
      type: "Intern"
    ),
    Employee(
      employeeId: "EMP023",
      employeeName: "Nikhil Bhatia",
      enrollId: "ENR023",
      company: "Tech Solutions Inc.",
      department: "Operations",
      designation: "Project Manager",
      location: "Delhi",
      status: "Active",
      type: "Full Time"
    ),
    Employee(
      employeeId: "EMP024",
      employeeName: "Lakshmi Venkatesh",
      enrollId: "ENR024",
      company: "Insignia E Security Pvt. Ltd.",
      department: "HR",
      designation: "HR Manager",
      location: "Chennai",
      status: "Active",
      type: "Full Time"
    ),
    Employee(
      employeeId: "EMP025",
      employeeName: "Rohan Singhania",
      enrollId: "ENR025",
      company: "Global Systems Ltd.",
      department: "Finance",
      designation: "Accountant",
      location: "Pune",
      status: "Inactive",
      type: "Full Time"
    ),
    Employee(
      employeeId: "EMP026",
      employeeName: "Shreya Mishra",
      enrollId: "ENR026",
      company: "Tech Solutions Inc.",
      department: "IT",
      designation: "Software Engineer",
      location: "Mumbai",
      status: "Active",
      type: "Contract"
    ),
    Employee(
      employeeId: "EMP027",
      employeeName: "Gaurav Choudhury",
      enrollId: "ENR027",
      company: "Insignia E Security Pvt. Ltd.",
      department: "Marketing",
      designation: "Team Lead",
      location: "Bangalore",
      status: "Active",
      type: "Full Time"
    ),
    Employee(
      employeeId: "EMP028",
      employeeName: "Nandini Reddy",
      enrollId: "ENR028",
      company: "Global Systems Ltd.",
      department: "IT",
      designation: "Software Engineer",
      location: "Delhi",
      status: "Active",
      type: "Full Time"
    ),
    Employee(
      employeeId: "EMP029",
      employeeName: "Ashish Tiwari",
      enrollId: "ENR029",
      company: "Tech Solutions Inc.",
      department: "Operations",
      designation: "Project Manager",
      location: "Chennai",
      status: "On Leave",
      type: "Full Time"
    ),
    Employee(
      employeeId: "EMP030",
      employeeName: "Sarika Pillai",
      enrollId: "ENR030",
      company: "Insignia E Security Pvt. Ltd.",
      department: "HR",
      designation: "HR Manager",
      location: "Pune",
      status: "Active",
      type: "Full Time"
    ),
    // ... (other sample employees)
  ];

  @override
  void onInit() {
    super.onInit();
    loadEmployees();
  }

  void loadEmployees() {
    filteredEmployees.assignAll(sampleEmployees);
  }

  void updateShiftType(String value) {
    shiftType.value = value;
  }

  Future<void> selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = "${picked.toLocal()}".split(' ')[0];
    }
  }

  void saveEmployee() {
    employeeModel.update((model) {
      model?.employeeId = employeeIdController.text;
      model?.enrollId = enrollIdController.text;
      model?.employeeName = employeeNameController.text;
      model?.designation = designationController.text;
      model?.dateOfJoining = dateOfJoiningController.text;
      model?.seniorReporting = seniorReportingController.text;
      model?.officeEmail = officeEmailController.text;
      model?.dateOfLeaving = dateOfLeavingController.text;
      model?.employeeType = employeeTypeController.text;
      model?.company = selectedCompany.value;
      model?.department = selectedDepartment.value;
      model?.location = selectedLocation.value;
      model?.shift = selectedType.value;
      model?.shiftType = shiftType.value;
      model?.gender = genderController.text;
      model?.bloodGroup = bloodGroupController.text;
      model?.nationality = nationalityController.text;
      model?.personalEmail = personalEmailController.text;
      model?.mobileNo = mobileNoController.text;
      model?.dateOfBirth = dateOfBirthController.text;
      model?.localAddress = localAddressController.text;
      model?.permanentAddress = permanentAddressController.text;
      model?.contactNo = contactNoController.text;
      model?.status = selectedStatus.value;
    });

    // Add the new employee to the list
    sampleEmployees.add(employeeModel.value);
    filteredEmployees.add(employeeModel.value);

    // Show success message
    Get.snackbar(
      'Success',
      'Employee added successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green[200],
    );

    clearForm();
  }

  void clearForm() {
    selectedCompany.value = null;
    selectedDepartment.value = null;
    selectedStatus.value = 'Active';
    selectedDesignation.value = null;
    selectedLocation.value = null;
    selectedType.value = null;
    shiftType.value = "Fix";
    
    employeeIdController.clear();
    enrollIdController.clear();
    employeeNameController.clear();
    designationController.clear();
    dateOfJoiningController.clear();
    seniorReportingController.clear();
    officeEmailController.clear();
    dateOfLeavingController.clear();
    employeeTypeController.clear();
    genderController.clear();
    bloodGroupController.clear();
    nationalityController.clear();
    personalEmailController.clear();
    mobileNoController.clear();
    dateOfBirthController.clear();
    localAddressController.clear();
    permanentAddressController.clear();
    contactNoController.clear();
  }
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    
    // Filter employees based on search query
    if (query.isEmpty) {
      // If search is empty, show all employees (respecting other filters)
      searchEmployees();
      return;
    }
    
    // Convert query to lowercase for case-insensitive search
    final lowercaseQuery = query.toLowerCase();
    
    // Filter employees based on search query
    var searchResults = sampleEmployees.where((employee) {
      // Check if any of the employee fields contain the search query
      return (employee.employeeId?.toLowerCase().contains(lowercaseQuery) == true) ||
             (employee.employeeName?.toLowerCase().contains(lowercaseQuery) == true) ||
             (employee.enrollId?.toLowerCase().contains(lowercaseQuery) == true) ||
             (employee.company?.toLowerCase().contains(lowercaseQuery) == true) ||
             (employee.department?.toLowerCase().contains(lowercaseQuery) == true) ||
             (employee.designation?.toLowerCase().contains(lowercaseQuery) == true) ||
             (employee.location?.toLowerCase().contains(lowercaseQuery) == true) ||
             (employee.type?.toLowerCase().contains(lowercaseQuery) == true);
    }).toList();
    
    // Apply other filters to search results
    if (selectedCompany.value != null) {
      searchResults = searchResults.where((e) => e.company == selectedCompany.value).toList();
    }
    if (selectedDepartment.value != null) {
      searchResults = searchResults.where((e) => e.department == selectedDepartment.value).toList();
    }
    if (selectedDesignation.value != null) {
      searchResults = searchResults.where((e) => e.designation == selectedDesignation.value).toList();
    }
    if (selectedLocation.value != null) {
      searchResults = searchResults.where((e) => e.location == selectedLocation.value).toList();
    }
    if (selectedType.value != null) {
      searchResults = searchResults.where((e) => e.type == selectedType.value).toList();
    }
    if (selectedStatus.value != null) {
      searchResults = searchResults.where((e) => e.status == selectedStatus.value).toList();
    }
    
    // Update the filtered employees list
    filteredEmployees.assignAll(searchResults);
  }

  void searchEmployees() {
    var filteredList = sampleEmployees.where((employee) {
      bool matchesFilters = true;
      
      if (selectedCompany.value != null) {
        matchesFilters = matchesFilters && employee.company == selectedCompany.value;
      }
      if (selectedDepartment.value != null) {
        matchesFilters = matchesFilters && employee.department == selectedDepartment.value;
      }
      if (selectedDesignation.value != null) {
        matchesFilters = matchesFilters && employee.designation == selectedDesignation.value;
      }
      if (selectedLocation.value != null) {
        matchesFilters = matchesFilters && employee.location == selectedLocation.value;
      }
      if (selectedType.value != null) {
        matchesFilters = matchesFilters && employee.type == selectedType.value;
      }
      if (selectedStatus.value != null) {
        matchesFilters = matchesFilters && employee.status == selectedStatus.value;
      }
      
      // Text field searches
      if (employeeIdController.text.isNotEmpty) {
        matchesFilters = matchesFilters && 
            employee.employeeId?.toLowerCase().contains(employeeIdController.text.toLowerCase()) == true;
      }
      if (enrollIdController.text.isNotEmpty) {
        matchesFilters = matchesFilters && 
            employee.enrollId?.toLowerCase().contains(enrollIdController.text.toLowerCase()) == true;
      }
      if (employeeNameController.text.isNotEmpty) {
        matchesFilters = matchesFilters && 
            employee.employeeName?.toLowerCase().contains(employeeNameController.text.toLowerCase()) == true;
      }
      
      return matchesFilters;
    }).toList();

    filteredEmployees.assignAll(filteredList);
  }

  void onSort(String column, bool ascending) {
    sortColumn.value = column;
    isAscending.value = ascending;
    
    filteredEmployees.sort((a, b) {
      var aValue = a.toMap()[column] ?? '';
      var bValue = b.toMap()[column] ?? '';
      return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
    });
  }

  void onEdit(Map<String, String> employeeData) {
    print('Editing employee: ${employeeData['Employee ID']}');
    // Implement edit logic
  }

  void deleteEmployee(Map<String, String> employeeData) {
    print('Deleting employee: ${employeeData['Employee ID']}');
    // Implement delete logic
    sampleEmployees.removeWhere((employee) => employee.employeeId == employeeData['Employee ID']);
    filteredEmployees.removeWhere((employee) => employee.employeeId == employeeData['Employee ID']);
  }

  @override
  void onClose() {
    // Dispose all controllers
    employeeIdController.dispose();
    enrollIdController.dispose();
    employeeNameController.dispose();
    designationController.dispose();
    dateOfJoiningController.dispose();
    seniorReportingController.dispose();
    officeEmailController.dispose();
    dateOfLeavingController.dispose();
    employeeTypeController.dispose();
    genderController.dispose();
    bloodGroupController.dispose();
    nationalityController.dispose();
    personalEmailController.dispose();
    mobileNoController.dispose();
    dateOfBirthController.dispose();
    localAddressController.dispose();
    permanentAddressController.dispose();
    contactNoController.dispose();
    super.onClose();
  }
}
