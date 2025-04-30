
import 'Shift.dart';

class ShiftPattern {
  String _PatternID=""  ;
  String _PatternName=""; 
  String _ShiftIDs='';
  List<Shift> _lstShift=[];  // testing and back end coding pending as ShiftNames are separated by comma used in old development
  
  String get PatternID => _PatternID;
  set PatternID(strPatternID){_PatternID=strPatternID;}
  String get PatternName => _PatternName;
  set PatternName(strPatternName){_PatternName=strPatternName;} 
  
  String get ShiftIDs => _ShiftIDs; // list of Shift IDs separated by comma
  set ShiftIDs(strShiftIDs) //for save update  - not mandatory
  {
    _ShiftIDs=strShiftIDs;
  }
  List<Shift> get ListOfShift => _lstShift;
  set ListOfShift(List<Shift> lstShift)
  {
    _lstShift=lstShift;
  }
  ShiftPattern()
  {
    _PatternID=PatternID  ;
    _PatternName=PatternName;  
    _lstShift=[];
    _ShiftIDs=ShiftIDs;
  }

  ShiftPattern.fromJson (dynamic json) {
    _PatternID=json['PatternID']  ;
    _PatternName=json['PatternName'];   
    _lstShift=json['ShiftsInPattern'];
    _ShiftIDs=json['Pattern'];
  }
  Map<String, dynamic> toJson()
  {
    final map = <String, dynamic>{};
    map['PatternID']= _PatternID ;
    map['PatternName']=_PatternName;    
    map['ShiftsInPattern']=_lstShift;
    map['Pattern']=_ShiftIDs;
    return map;
  }
}