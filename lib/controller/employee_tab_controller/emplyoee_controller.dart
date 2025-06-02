// emplyoee_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLogin.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLoginInfoDetails.dart';
import 'package:time_attendance/General/MTAResult.dart';
import 'package:time_attendance/controller/employee_tab_controller/employee_search_controller.dart';
import 'package:time_attendance/model/employee_tab_model/employee_complete_model.dart';
import 'package:time_attendance/model/employee_tab_model/settingprofile.dart';
// import 'package:time_attendance/model/employee_tab_model/employee_model.dart';
import 'package:time_attendance/model/employee_tab_model/employee_details.dart';
import 'package:time_attendance/widgets/mtaToast.dart';
import 'package:time_attendance/model/TALogin/session_manager.dart'
    if (dart.library.html) 'package:time_attendance/model/TALogin/session_manager_web.dart'
    if (dart.library.io) 'package:time_attendance/model/TALogin/session_manager_mobile.dart';
import 'package:time_attendance/controller/master_tab_controller/department_controller.dart';
import 'package:time_attendance/controller/master_tab_controller/designation_controller.dart';
import 'package:time_attendance/controller/master_tab_controller/location_controller.dart';
import 'package:time_attendance/controller/master_tab_controller/company_controller.dart';
import 'package:time_attendance/controller/master_tab_controller/emplyee_type_controller.dart';
import 'package:time_attendance/model/master_tab_model/company_model.dart';
import 'package:time_attendance/model/master_tab_model/department_model.dart';
import 'package:time_attendance/model/master_tab_model/designation_model.dart';
import 'package:time_attendance/model/master_tab_model/employee_type_model.dart';
import 'package:time_attendance/model/master_tab_model/location_model.dart';

class EmployeeController extends GetxController {
  // Lists for employees
  final employees = <Employee>[].obs;
  final filteredEmployees = <Employee>[].obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;

  // Setting profile variables
  final selectedSettingProfile = Rxn<SettingProfileModel>();

  // Sorting variables (adjust as needed for employee fields)
  final sortColumn = RxString('EmployeeName'); // Default sort column
  final isSortAscending = RxBool(true);

  // Authentication instance
  AuthLogin? _authLogin;

  // Form controllers - Professional Details
  final employeeIdController = TextEditingController();
  final enrollIdController = TextEditingController();
  final employeeNameController = TextEditingController();
  final designationFormController = TextEditingController();
  final employeeTypeFormController = TextEditingController();
  final dateOfJoiningController = TextEditingController();
  final dateOfLeavingController = TextEditingController();
  final seniorReportingController = TextEditingController();
  final seniorReportingNameController = TextEditingController();
  final officeEmailController = TextEditingController();

  // Form controllers - Personal Details
  final genderController = TextEditingController();
  final bloodGroupController = TextEditingController();
  final nationalityController = TextEditingController();
  final personalEmailController = TextEditingController();
  final mobileNoController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final localAddressController = TextEditingController();
  final permanentAddressController = TextEditingController();
  final contactNoController = TextEditingController();

  // Master data controllers
  final masterDepartmentController = Get.put(DepartmentController());
  final masterDesignationController = Get.put(DesignationController());
  final masterLocationController = Get.put(LocationController());
  final masterBranchController = Get.put(BranchController());
  final masterEmployeeTypeController = Get.put(EmplyeeTypeController());
  final employeeSearchController = Get.put(EmployeeSearchController());

  // Master data lists
  final companies = <BranchModel>[].obs;
  final departments = <DepartmentModel>[].obs;
  final locations = <Location>[].obs;
  final employeeStatuses = <String>['Active', 'Inactive'].obs;
  final employeeTypes = <EmployeeTypeModel>[].obs;
  final designations = <DesignationModel>[].obs;

  // Selected values
  final selectedCompany = RxString('');
  final selectedDepartment = RxString('');
  final selectedLocation = RxString('');
  final selectedEmployeeStatus = RxString('Active');
  final selectedEmployeeType = RxString('');

  // Radio button value
  final shiftType = RxString('Fix');

  void updateShiftType(String value) {
    shiftType.value = value;
  }

  @override
  void onInit() {
    super.onInit();
    initializeAuthEmployee().then((_) => fetchMasterData());
  }

  Future<void> initializeAuthEmployee() async {
    try {
      final userInfo = await PlatformSessionManager.getUserInfo();
      if (userInfo != null) {
        String companyCode = userInfo['CompanyCode'];
        String loginID = userInfo['LoginID'];
        String password = userInfo['Password'];
        _authLogin = await AuthLoginDetails()
            .LoginInformationForFirstLogin(companyCode, loginID, password);
        await fetchMasterData(); // Fetch master data after authentication
      } else {
        MTAToast()
            .ShowToast("User information not found. Please log in again.");
      }
    } catch (e) {
      MTAToast()
          .ShowToast("Error initializing authentication: ${e.toString()}");
    }
  }

  Future<void> fetchMasterData() async {
    try {
      if (_authLogin == null) {
        await initializeAuthEmployee();
        if (_authLogin == null) throw Exception('Authentication failed');
      }

      isLoading.value = true;

      // Fetch Employee Types
      await masterEmployeeTypeController.fetchEmployeeTypes();
      employeeTypes.assignAll(masterEmployeeTypeController.empTypeDetails);

      // Fetch Company / Branch
      await masterBranchController.fetchBranches();
      companies.assignAll(masterBranchController.branches);

      // Fetch departments
      await masterDepartmentController.fetchDepartments();
      departments.assignAll(masterDepartmentController.departments);

      // Fetch designations
      await masterDesignationController.fetchDesignations();
      designations.assignAll(masterDesignationController.designations);

      // Fetch locations
      await masterLocationController.fetchLocation();
      locations.assignAll(masterLocationController.locations);
    } catch (e) {
      MTAToast().ShowToast('Error fetching master data: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> saveEmployee() async {
    try {
      if (_authLogin == null) {
        MTAToast()
            .ShowToast('Authentication not initialized. Cannot save employee.');
        // Attempt to re-initialize auth if it's null
        await initializeAuthEmployee();
        if (_authLogin == null) {
          throw Exception('Authentication failed to initialize.');
        }
        return false;
      }

      isLoading.value = true;
      MTAResult result = MTAResult();
      bool success = false;

      // Create employee object from form data      // Get the selected setting profile
      final settingProfile = selectedSettingProfile.value;
      if (settingProfile == null) {
        MTAToast().ShowToast('Please select a setting profile before saving.');
        return false;
      }

      Employee employee = Employee(
          employeeProfessional: EmployeeProfessional(
            enrollID: enrollIdController.text,
            employeeID: employeeIdController.text,
            employeeName: employeeNameController.text,
            companyID: selectedCompany.value,
            departmentID: selectedDepartment.value,
            designationID: designationFormController.text,
            locationID: selectedLocation.value,
            employeeTypeID: selectedEmployeeType.value,
            employeeType: employeeTypeFormController.text,
            empStatus: selectedEmployeeStatus.value == 'Active' ? 1 : 0,
            dateOfEmployment: dateOfJoiningController.text,
            dateOfLeaving: dateOfLeavingController.text,
            seniorEmployeeID: seniorReportingController.text,
            emailID: officeEmailController.text,
          ),
          employeePersonal: EmployeePersonal(
            employeeID: employeeIdController.text,
            employeeName: employeeNameController.text,
            localAddress: localAddressController.text,
            permanentAddress: permanentAddressController.text,
            gender: genderController.text,
            dateOfBirth: dateOfBirthController.text,
            contactNo: contactNoController.text,
            mobileNumber: mobileNoController.text,
            nationality: nationalityController.text,
            emailID: personalEmailController.text,
            bloodGroup: bloodGroupController.text,
          ),
          // employeeRegularShift: null,  //settingProfile.employeeRegularShift,
          employeeWOFF: settingProfile.employeeWOFF,
          employeeSetting: settingProfile.employeeSetting,
          employeeGeneralSetting: settingProfile.employeeGeneralSetting,
          employeeLogin: settingProfile.employeeLogin
          );

      success = await EmployeeDetails().Save(_authLogin!, employee, result);
      if (success) {
        MTAToast().ShowToast(result.ResultMessage.isNotEmpty
            ? result.ResultMessage
            : "Employee saved successfully.");
        // await fetchEmployees(); // Refresh the list after saving
        return true;
      } else {
        MTAToast().ShowToast(result.ResultMessage.isNotEmpty
            ? result.ResultMessage
            : "Failed to save employee.");
        if (result.ErrorMessage.isNotEmpty) {
          throw Exception(result.ErrorMessage);
        }
        return false;
      }
    } catch (e) {
      MTAToast().ShowToast("Error saving employee: ${e.toString()}");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteEmployee(EmployeeProfessional employeeProfessional) async {
    try {
      if (_authLogin == null) {
        MTAToast().ShowToast('Authentication not initialized');
        await initializeAuthEmployee();
        if (_authLogin == null) {
          throw Exception('Authentication failed to initialize');
        }
      }

      isLoading.value = true;
      MTAResult result = MTAResult();

      bool success = await EmployeeDetails()
          .Delete(_authLogin!, employeeProfessional, result);

      if (success) {
        MTAToast().ShowToast(result.ResultMessage.isNotEmpty
            ? result.ResultMessage
            : 'Employee deleted successfully');
        // Refresh the employee list after deletion
        await employeeSearchController.fetchEmployees(resetPage: true);
      } else {
        MTAToast().ShowToast(result.ResultMessage.isNotEmpty
            ? result.ResultMessage
            : 'Failed to delete employee');
        if (result.ErrorMessage.isNotEmpty) {
          throw Exception(result.ErrorMessage);
        }
      }
    } catch (e) {
      MTAToast().ShowToast('Error deleting employee: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Method to get employee details by ID
  Future<Employee> getEmployeeDetailsById(String employeeId) async {
    try {
      if (_authLogin == null) {
        MTAToast().ShowToast('Authentication not initialized');
        await initializeAuthEmployee();
        if (_authLogin == null) {
          throw Exception('Authentication failed to initialize');
        }
      }
      isLoading.value = true;
      MTAResult result = MTAResult();

      Employee employee = await EmployeeDetails()
          .GetEmployeeDetailsByID(_authLogin!, employeeId, result);

      if (result.IsResultPass) {
        return employee;
      } else {
        MTAToast().ShowToast(result.ResultMessage.isNotEmpty
            ? result.ResultMessage
            : 'Failed to fetch employee details');
        if (result.ErrorMessage.isNotEmpty) {
          throw Exception(result.ErrorMessage);
        }
        return Employee(); // Return an empty Employee object on failure
      }
    } catch (e) {
      MTAToast().ShowToast('Error fetching employee details: ${e.toString()}');
      return Employee(); // Return an empty Employee object on error
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Dispose all controllers
    employeeIdController.dispose();
    enrollIdController.dispose();
    employeeNameController.dispose();
    designationFormController.dispose();
    employeeTypeFormController.dispose();
    dateOfJoiningController.dispose();
    dateOfLeavingController.dispose();
    seniorReportingController.dispose();
    officeEmailController.dispose();
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
