import 'package:get/get.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLogin.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLoginInfoDetails.dart';
import 'package:time_attendance/General/MTAResult.dart';
import 'package:time_attendance/controller/master_tab_controller/company_controller.dart';
import 'package:time_attendance/controller/master_tab_controller/emplyee_type_controller.dart';
import 'package:time_attendance/model/employee_tab_model/employee_search_model.dart';
import 'package:time_attendance/model/employee_tab_model/employee_search_details.dart';
import 'package:time_attendance/model/master_tab_model/company_model.dart';
import 'package:time_attendance/model/master_tab_model/employee_type_model.dart';
import 'package:time_attendance/widgets/mtaToast.dart';
import 'package:time_attendance/model/TALogin/session_manager.dart'
    if (dart.library.html) 'package:time_attendance/model/TALogin/session_manager_web.dart'
    if (dart.library.io) 'package:time_attendance/model/TALogin/session_manager_mobile.dart';
import 'package:time_attendance/controller/master_tab_controller/department_controller.dart';
import 'package:time_attendance/controller/master_tab_controller/designation_controller.dart';
import 'package:time_attendance/controller/master_tab_controller/location_controller.dart';
import 'package:time_attendance/model/master_tab_model/department_model.dart';
import 'package:time_attendance/model/master_tab_model/designation_model.dart';
import 'package:time_attendance/model/master_tab_model/location_model.dart';

class EmployeeSearchController extends GetxController {
  // Lists for employees
  final employees = <EmployeeView>[].obs;
  final filteredEmployees = <EmployeeView>[].obs;
  
  // Pagination variables
  final currentPage = 0.obs;
  final totalRecords = 0.obs;
  final recordsPerPage = 10.obs;
  final isLoading = false.obs;
  
  // Search state
  final hasSearched = false.obs;
  
  // Search filters
  final searchEmployeeView = EmployeeView().obs;
  
  // Sorting variables
  final sortColumn = RxString('EmployeeName');
  final isSortAscending = RxBool(true);

  // Master data controllers
  final departmentController = Get.put(DepartmentController());
  final designationController = Get.put(DesignationController());
  final locationController = Get.put(LocationController());
  final branchController = Get.put(BranchController());
  final employeeTypeController = Get.put(EmplyeeTypeController());

  // Master data lists
  final departments = <DepartmentModel>[].obs;
  final designations = <DesignationModel>[].obs;
  final locations = <Location>[].obs;
  final branches = <BranchModel>[].obs;
  final employeeTypes = <EmployeeTypeModel>[].obs;

  // Authentication instance
  AuthLogin? _authLogin;

  @override
  void onInit() {
    super.onInit();
    initializeAuth();
    fetchMasterData();
  }

  Future<void> initializeAuth() async {
    try {
      final userInfo = await PlatformSessionManager.getUserInfo();
      if (userInfo != null) {
        String companyCode = userInfo['CompanyCode'];
        String loginID = userInfo['LoginID'];
        String password = userInfo['Password'];
        _authLogin = await AuthLoginDetails().LoginInformationForFirstLogin(
            companyCode, loginID, password);
      }
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    }
  }  Future<void> fetchMasterData() async {
    try {
      if (_authLogin == null) {
        // Wait for authentication to be initialized
        await initializeAuth();
      }
      
      isLoading.value = true;

      // Employee Types
      await employeeTypeController.fetchEmployeeTypes();
      employeeTypes.assignAll(employeeTypeController.empTypeDetails);

      // Fetch Company / Branch
      await branchController.fetchBranches();
      // print('Branches fetched: ${branchController.branches.length}');
      branches.assignAll(branchController.branches);
      // print('Branches assigned: ${branches.length}');
      
      // Fetch departments
      await departmentController.fetchDepartments();
      // print('Departments fetched: ${departmentController.departments.length}');
      departments.assignAll(departmentController.departments);
      // print('Departments assigned: ${departments.length}');

      // Fetch designations
      await designationController.fetchDesignations();
      // print('Designations fetched: ${designationController.designations.length}');
      designations.assignAll(designationController.designations);
      // print('Designations assigned: ${designations.length}');

      // Fetch locations
      await locationController.fetchLocation();
      // print('Locations fetched: ${locationController.locations.length}');
      locations.assignAll(locationController.locations);
      // print('Locations assigned: ${locations.length}');

    } catch (e) {
      // print('Error fetching master data: $e');
      MTAToast().ShowToast('Error fetching master data: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchEmployees({bool resetPage = false}) async {
    try { 
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }

      isLoading.value = true;
      hasSearched.value = true;  // Set the flag when search is performed

      if (resetPage) {
        currentPage.value = 0;
      }

      MTAResult result = MTAResult();
      
      // Create search request
      final searchRequest = EmployeeSearchRequest(
        employeeView: searchEmployeeView.value,
        iStartIndex: currentPage.value * recordsPerPage.value,
        iRecordsPerPage: recordsPerPage.value
      );

      // Get employees from API
      final response = await EmployeeSearchDetails().getEmployeesByRange(
        _authLogin!,
        searchRequest,
        result
      );

        employees.value = response.employees;
        filteredEmployees.value = response.employees;
        totalRecords.value = 50;  // response.recordCount;
        hasSearched.value = true;
     

    } catch (e) {
      MTAToast().ShowToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Navigation methods
  void nextPage() {
    if ((currentPage.value + 1) * recordsPerPage.value < totalRecords.value) {
      currentPage.value++;
      fetchEmployees();
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
      fetchEmployees();
    }
  }

  void goToPage(int page) {
    if (page >= 0 && page * recordsPerPage.value < totalRecords.value) {
      currentPage.value = page;
      fetchEmployees();
    }
  }

  // Search methods
  void updateSearchFilter({
    String? employeeId,
    String? employeeName,
    String? enrollId,
    String? companyId,
    String? departmentId,
    String? designationId,
    String? locationId,
    int? employeeStatus,
    String? employeeTypeId,
  }) {
    if (employeeId != null) searchEmployeeView.value.employeeID = employeeId;
    if (employeeName != null) searchEmployeeView.value.employeeName = employeeName;
    if (enrollId != null) searchEmployeeView.value.enrollID = enrollId;
    if (companyId != null) searchEmployeeView.value.companyID = companyId;
    if (departmentId != null) searchEmployeeView.value.departmentID = departmentId;
    if (designationId != null) searchEmployeeView.value.designationID = designationId;
    if (locationId != null) searchEmployeeView.value.locationID = locationId;
    if (employeeStatus != null) searchEmployeeView.value.employeeStatus = employeeStatus;
    if (employeeTypeId != null) searchEmployeeView.value.employeeTypeID = employeeTypeId;
    
    // Reset page and fetch with new filters
    fetchEmployees(resetPage: true);
  }

  void clearFilters() {
    searchEmployeeView.value = EmployeeView();
    fetchEmployees(resetPage: true);
  }

  // Sorting method
  void sortEmployees(String columnName, bool? ascending) {
    if (ascending != null) {
      isSortAscending.value = ascending;
    } else if (sortColumn.value == columnName) {
      isSortAscending.value = !isSortAscending.value;
    } else {
      isSortAscending.value = true;
    }
    
    sortColumn.value = columnName;

    filteredEmployees.sort((a, b) {
      int comparison;
      switch (columnName) {
        case 'EmployeeName':
          comparison = (a.employeeName ?? '').compareTo(b.employeeName ?? '');
          break;
        case 'EnrollID':
          comparison = (a.enrollID ?? '').compareTo(b.enrollID ?? '');
          break;
        case 'DepartmentName':
          comparison = (a.departmentName ?? '').compareTo(b.departmentName ?? '');
          break;
        case 'DesignationName':
          comparison = (a.designationName ?? '').compareTo(b.designationName ?? '');
          break;
        case 'LocationName':
          comparison = (a.locationName ?? '').compareTo(b.locationName ?? '');
          break;
        default:
          comparison = 0;
      }
      return isSortAscending.value ? comparison : -comparison;
    });
  }

  // Update records per page
  void updateRecordsPerPage(int newRecordsPerPage) {
    recordsPerPage.value = newRecordsPerPage;
    fetchEmployees(resetPage: true);
  }
}
