class Employee {
  String? employeeId;
  String? enrollId;
  String? employeeName;
  String? designation;
  String? dateOfJoining;
  String? seniorReporting;
  String? officeEmail;
  String? dateOfLeaving;
  String? employeeType;
  String? company;
  String? department;
  String? location;
  String? shift;
  String? shiftType;
  String? status;
  String? type;

  // Personal Details
  String? gender;
  String? bloodGroup;
  String? nationality;
  String? personalEmail;
  String? mobileNo;
  String? dateOfBirth;
  String? localAddress;
  String? permanentAddress;
  String? contactNo;

  Employee({
    this.employeeId,
    this.enrollId,
    this.employeeName,
    this.designation,
    this.dateOfJoining,
    this.seniorReporting,
    this.officeEmail,
    this.dateOfLeaving,
    this.employeeType,
    this.company,
    this.department,
    this.location,
    this.shift,
    this.shiftType,
    this.status,
    this.type,
    this.gender,
    this.bloodGroup,
    this.nationality,
    this.personalEmail,
    this.mobileNo,
    this.dateOfBirth,
    this.localAddress,
    this.permanentAddress,
    this.contactNo,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      employeeId: json['employeeId'] ?? '',
      enrollId: json['enrollId'] ?? '',
      employeeName: json['employeeName'] ?? '',
      designation: json['designation'] ?? '',
      dateOfJoining: json['dateOfJoining'],
      seniorReporting: json['seniorReporting'],
      officeEmail: json['officeEmail'],
      dateOfLeaving: json['dateOfLeaving'],
      employeeType: json['employeeType'],
      company: json['company'] ?? '',
      department: json['department'] ?? '',
      location: json['location'] ?? '',
      shift: json['shift'],
      shiftType: json['shiftType'],
      status: json['status'] ?? '',
      type: json['type'] ?? '',
      gender: json['gender'],
      bloodGroup: json['bloodGroup'],
      nationality: json['nationality'],
      personalEmail: json['personalEmail'],
      mobileNo: json['mobileNo'],
      dateOfBirth: json['dateOfBirth'],
      localAddress: json['localAddress'],
      permanentAddress: json['permanentAddress'],
      contactNo: json['contactNo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeeId': employeeId,
      'enrollId': enrollId,
      'employeeName': employeeName,
      'designation': designation,
      'dateOfJoining': dateOfJoining,
      'seniorReporting': seniorReporting,
      'officeEmail': officeEmail,
      'dateOfLeaving': dateOfLeaving,
      'employeeType': employeeType,
      'company': company,
      'department': department,
      'location': location,
      'shift': shift,
      'shiftType': shiftType,
      'status': status,
      'type': type,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'nationality': nationality,
      'personalEmail': personalEmail,
      'mobileNo': mobileNo,
      'dateOfBirth': dateOfBirth,
      'localAddress': localAddress,
      'permanentAddress': permanentAddress,
      'contactNo': contactNo,
    };
  }

  Map<String, String> toMap() {
    return {
      'Employee ID': employeeId ?? '',
      'Employee Name': employeeName ?? '',
      'Enroll ID': enrollId ?? '',
      'Company': company ?? '',
      'Department': department ?? '',
      'Designation': designation ?? '',
      'Location': location ?? '',
      'Status': status ?? '',
      'Type': type ?? '',
    };
  }
}

