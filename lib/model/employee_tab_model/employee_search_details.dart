import 'dart:convert';
import 'package:time_attendance/widgets/mtaToast.dart';
import '../../Data/LoginInformation/AuthLogin.dart';
import '../../Data/LoginInformation/Constants.dart';
import '../../Data/ServerInteration/APIIntraction.dart';
import '../../Data/ServerInteration/Result.dart';
import '../../General/MTAResult.dart';
import 'employee_search_model.dart';

class EmployeeSearchDetails {
  Future<EmployeeSearchResponse> getEmployeesByRange(AuthLogin objAuthLogin,
      EmployeeSearchRequest searchRequest, MTAResult objMTAResult) async {
    EmployeeSearchResponse response = EmployeeSearchResponse();
    List<EmployeeView> lstEmployeeView = [];
    try {
      String searchJson = jsonEncode(searchRequest);
      Result objResult = await APIInteraction().Save(
          objAuthLogin,
          searchJson,
          ApiConstants.endpoint_EmployeeViewSeachViaRange); // Map the Result to EmployeeSearchResponse
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;
      if (objResult.IsResultPass) {
        if (objResult.IsMultipleRecordsInJson) {
          lstEmployeeView = parseEmployeeList(objResult.ResultRecordJson);
          response.isMultipleRecordsInJson = objResult.IsMultipleRecordsInJson;
          response.isResultPass = objResult.IsResultPass;
          response.recordCount = objResult.RecordCount;
          response.resultMessage = objResult.ResultMessage;
          response.employees = lstEmployeeView;
        }
      }
    } on Exception catch (e) {
      MTAToast().ShowToast(e.toString());
    }

    return response;
  }

  List<EmployeeView> parseEmployeeList(String responseBody) {
    try {
      final parsed =
          (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();
      return parsed
          .map<EmployeeView>((json) => EmployeeView.fromJson(json))
          .toList();
    } catch (e) {
      //debugPrint(e.toString());
      return [];
    }
  }
}
