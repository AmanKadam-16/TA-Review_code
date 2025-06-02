import 'dart:convert';

import '../../Data/LoginInformation/AuthLogin.dart';
import '../../Data/LoginInformation/Constants.dart';
import '../../Data/ServerInteration/APIIntraction.dart';
import '../../Data/ServerInteration/Result.dart';
import '../../General/MTAResult.dart';
import 'settingprofile.dart';

class SettingProfileDetails {
  Future<List<SettingProfileModel>> GetAllSettingProfiles(AuthLogin objAuthLogin, MTAResult objMTAResult) async {
    List<SettingProfileModel> lstSettingProfile = [];

    try {
      Result objResult = await APIInteraction().GetAllObjects(
          objAuthLogin, ApiConstants.endpoint_SettingProfile);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      if (objResult.IsResultPass) {
        if (objResult.IsMultipleRecordsInJson) {
          String strJson = objResult.ResultRecordJson;
          lstSettingProfile = settingProfileModelFromJson(strJson);
        }
      }
    } on Exception catch (e) {
      lstSettingProfile = [];
      print('error caught: $e');
    }
    return lstSettingProfile;
  }
  Future<bool> Delete(AuthLogin objAuthLogin, String strProfileID, MTAResult objMTAResult) async {
    bool bResult = false;
    try {
      Map<String, dynamic> deleteData = {
        "ProfileID": strProfileID
      };

      String strSettingProfileJson = jsonEncode(deleteData);
      Result objResult = await APIInteraction().Delete(
          objAuthLogin, strSettingProfileJson, ApiConstants.endpoint_SettingProfile);
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