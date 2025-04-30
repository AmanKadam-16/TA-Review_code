import 'dart:convert';

// import 'package:mta/Models/Masters/shiftPattern.dart';

import '../../Data/LoginInformation/AuthLogin.dart';
import '../../Data/LoginInformation/Constants.dart';
import '../../Data/ServerInteration/APIIntraction.dart';
import '../../Data/ServerInteration/Result.dart';
import '../../General/MTAResult.dart';
import 'shiftPattern.dart';

class ShiftPatternDetails {
//ToDo:  code optimization pending
  Future<List<ShiftPattern>> GetAllShiftPatternes(AuthLogin objAuthLogin,
      MTAResult objMTAResult) async {
    List<ShiftPattern> lstShiftPattern = [];

    try {
      Result objResult = await APIInteraction().GetAllObjects(
          objAuthLogin, ApiConstants.endpoint_ShiftPattern);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      if (objResult.IsResultPass) {
        if (objResult.IsMultipleRecordsInJson) {
          String strJson = objResult.ResultRecordJson;
          lstShiftPattern = parseShiftPatterns(objResult.ResultRecordJson);
        }
      }
    }
    on Exception catch (e) {
      lstShiftPattern = [];
      print('error caught: $e');
    }
    return lstShiftPattern;
  }

  List<ShiftPattern> parseShiftPatterns(String responseBody) {
    try {
      final parsed = (jsonDecode(responseBody) as List).cast<
          Map<String, dynamic>>();
      return parsed.map<ShiftPattern>((json) => ShiftPattern.fromJson(json))
          .toList();
    } catch (e) {
      //debugPrint(e.toString());
      return [];
    }
  }

  Future<ShiftPattern> GetShiftPatternByPatternID(AuthLogin objAuthLogin,
      String strPatternID, MTAResult objMTAResult) async {
    ShiftPattern objShiftPattern = new ShiftPattern();

    try {
      Result objResult = await APIInteraction().GetObjectByObjectID(
          objAuthLogin, strPatternID, ApiConstants.endpoint_ShiftPattern);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      if (objResult.IsResultPass) {
        if (!objResult.IsMultipleRecordsInJson) {
          String strJson = objResult.ResultRecordJson;
          Map<String, dynamic> valueMap = json.decode(
              objResult.ResultRecordJson);

          objShiftPattern = ShiftPattern.fromJson(valueMap);
        }
      }
    }
    on Exception catch (e) {
      objShiftPattern = new ShiftPattern(); // not sure in dart
      print('error caught: $e');
    }
    return objShiftPattern;
  }

  Future<bool> Save(AuthLogin objAuthLogin, ShiftPattern objShiftPattern,
      MTAResult objMTAResult) async {
    bool bResult = false;
    try {
      String strShiftPatternJson = jsonEncode(objShiftPattern);
      Result objResult = await APIInteraction().Save(
          objAuthLogin, strShiftPatternJson, ApiConstants.endpoint_ShiftPattern);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      bResult = objResult.IsResultPass;
    }
    on Exception catch (e) {
      bResult = false;
      print('error caught: $e');
    }
    return bResult;
  }

  Future<bool> Update(AuthLogin objAuthLogin, ShiftPattern objShiftPattern,
      MTAResult objMTAResult) async {
    bool bResult = false;
    try {
      String strShiftPatternJson = jsonEncode(objShiftPattern);
      Result objResult = await APIInteraction().Update(
          objAuthLogin, strShiftPatternJson, ApiConstants.endpoint_ShiftPattern);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      bResult = objResult.IsResultPass;
    }
    on Exception catch (e) {
      bResult = false;
      print('error caught: $e');
    }
    return bResult;
  }

  Future<bool> Delete(AuthLogin objAuthLogin, String strPatternID,
      MTAResult objMTAResult) async {
    bool bResult = false;
    try {
      ShiftPattern objShiftPattern = new ShiftPattern();
      objShiftPattern.PatternID = strPatternID;

      String strShiftPatternJson = jsonEncode(objShiftPattern);
      Result objResult = await APIInteraction().Delete(
          objAuthLogin, strShiftPatternJson, ApiConstants.endpoint_ShiftPattern);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      bResult = objResult.IsResultPass;
    }
    on Exception catch (e) {
      bResult = false;
      print('error caught: $e');
    }
    return bResult;
  }

}
