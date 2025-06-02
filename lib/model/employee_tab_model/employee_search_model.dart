import 'dart:convert';

class EmployeeView {
  String? employeeID;
  String? employeeName;
  String? enrollID;
  String? companyID;
  String? companyName;
  String? departmentID;
  String? departmentName;
  String? designationID;
  String? designationName;
  String? locationID;
  String? locationName;
  int? employeeStatus;
  String? employeeType;
  String? employeeTypeID;
  String? mobileNumber;
  String? emailID;
  String? dateOfEmployment;
  String? seniorEmployeeID;
  String? seniorEmployeeName;

  EmployeeView({
    this.employeeID = "",
    this.employeeName = "",
    this.enrollID = "",
    this.companyID = "",
    this.companyName = "",
    this.departmentID = "",
    this.departmentName = "",
    this.designationID = "",
    this.designationName = "",
    this.locationID = "",
    this.locationName = "",
    this.employeeStatus = 1,
    this.employeeType = "",
    this.employeeTypeID = "",
    this.mobileNumber = "",
    this.emailID = "",
    this.dateOfEmployment = "",
    this.seniorEmployeeID = "",
    this.seniorEmployeeName = "",
  });

  Map<String, dynamic> toJson() {
    return {
      'EmployeeID': employeeID,
      'EmployeeName': employeeName,
      'EnrollID': enrollID,
      'CompanyID': companyID,
      'CompanyName': companyName,
      'DepartmentID': departmentID,
      'DepartmentName': departmentName,
      'DesignationID': designationID,
      'DesignationName': designationName,
      'LocationID': locationID,
      'LocationName': locationName,
      'EmployeeStatus': employeeStatus,
      'EmployeeType': employeeType,
      'EmployeeTypeID': employeeTypeID,
      'MobileNumber': mobileNumber,
      'EmailID': emailID,
      'DateOfEmployment': dateOfEmployment,
      'SeniorEmployeeID': seniorEmployeeID,
      'SeniorEmployeeName': seniorEmployeeName,
    };
  }

  factory EmployeeView.fromJson(Map<String, dynamic> json) {
    return EmployeeView(
      employeeID: json['EmployeeID'] ?? "",
      employeeName: json['EmployeeName'] ?? "",
      enrollID: json['EnrollID'] ?? "",
      companyID: json['CompanyID'] ?? "",
      companyName: json['CompanyName'] ?? "",
      departmentID: json['DepartmentID'] ?? "",
      departmentName: json['DepartmentName'] ?? "",
      designationID: json['DesignationID'] ?? "",
      designationName: json['DesignationName'] ?? "",
      locationID: json['LocationID'] ?? "",
      locationName: json['LocationName'] ?? "",
      employeeStatus: json['EmployeeStatus'] ?? 1,
      employeeType: json['EmployeeType'] ?? "",
      employeeTypeID: json['EmployeeTypeID'] ?? "",
      mobileNumber: json['MobileNumber'] ?? "",
      emailID: json['EmailID'] ?? "",
      dateOfEmployment: json['DateOfEmployment'] ?? "",
      seniorEmployeeID: json['SeniorEmployeeID'] ?? "",
      seniorEmployeeName: json['SeniorEmployeeName'] ?? "",
    );
  }
}

class EmployeeSearchRequest {
  EmployeeView employeeView;
  int iStartIndex;
  int iRecordsPerPage;

  EmployeeSearchRequest({
    required this.employeeView,
    this.iStartIndex = 0,
    this.iRecordsPerPage = 10,
  });

  Map<String, dynamic> toJson() {
    return {
      'EmployeeView': employeeView.toJson(),
      'iStartIndex': iStartIndex,
      'iRecordsPerPage': iRecordsPerPage,
    };
  }
}

class EmployeeSearchResponse {
  bool isMultipleRecordsInJson;
  bool isResultPass;
  int loginMode;
  int recordCount;
  String resultMessage;
  List<EmployeeView> employees;

  EmployeeSearchResponse({
    this.isMultipleRecordsInJson = false,
    this.isResultPass = false,
    this.loginMode = 0,
    this.recordCount = 0,
    this.resultMessage = "",
    this.employees = const [],
  });

  factory EmployeeSearchResponse.fromJson(Map<String, dynamic> json) {
    List<EmployeeView> parseEmployees(String jsonString) {
      List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => EmployeeView.fromJson(json)).toList();
    }

    return EmployeeSearchResponse(
      isMultipleRecordsInJson: json['IsMultipleRecordsInJson'] ?? false,
      isResultPass: json['IsResultPass'] ?? false,
      loginMode: json['LoginMode'] ?? 0,
      recordCount: json['RecordCount'] ?? 0,
      resultMessage: json['ResultMessage'] ?? "",
      employees: json['ResultRecordJson'] != null ? parseEmployees(json['ResultRecordJson']) : [],
    );
  }
}