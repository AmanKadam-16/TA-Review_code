import 'package:get/get.dart';
import 'package:time_attendance/model/sfift_tab_model/shift_pattern_model.dart';

class ShiftPatternController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<ShiftPatternModel> shiftPatterns = <ShiftPatternModel>[].obs;
  final RxList<ShiftPatternModel> filteredShiftPatterns = <ShiftPatternModel>[].obs;
  final RxList<ListOfShift> shifts = <ListOfShift>[].obs;

  @override
  void onInit() {
    super.onInit();
    initializeShiftPatterns();
    loadDummyShifts();
  }

  void loadDummyShifts() {
    shifts.value = [
      ListOfShift(shiftId: '1', shiftName: 'Morning Shift', shiftType: 'Regular'),
      ListOfShift(shiftId: '2', shiftName: 'Night Shift', shiftType: 'Night'),
      ListOfShift(shiftId: '3', shiftName: 'General Shift', shiftType: 'Regular'),
      ListOfShift(shiftId: '4', shiftName: 'Evening Shift', shiftType: 'Evening'),
    ];
  }

  void initializeShiftPatterns() {
    isLoading.value = true;
    // Dummy data initialization
    shiftPatterns.value = [
      ShiftPatternModel(
        patternId: '1',
        patternName: 'Standard Pattern',
        listOfShifts: [
          ListOfShift(shiftId: '1', shiftName: 'Morning Shift', shiftType: 'Regular'),
          ListOfShift(shiftId: '2', shiftName: 'Night Shift', shiftType: 'Night'),
        ],
      ),
      ShiftPatternModel(
        patternId: '2',
        patternName: 'Flexible Pattern',
        listOfShifts: [
          ListOfShift(shiftId: '3', shiftName: 'General Shift', shiftType: 'Regular'),
        ],
      ),
    ];
    filteredShiftPatterns.value = List.from(shiftPatterns);
    isLoading.value = false;
  }

  void updateSearchQuery(String query) {
    filteredShiftPatterns.value = shiftPatterns
        .where((pattern) =>
            pattern.patternName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void saveShiftPattern(ShiftPatternModel pattern) {
    final index = shiftPatterns
        .indexWhere((element) => element.patternId == pattern.patternId);
    if (index >= 0) {
      shiftPatterns[index] = pattern;
    } else {
      shiftPatterns.add(pattern);
    }
    filteredShiftPatterns.value = List.from(shiftPatterns);
  }

  void deleteShiftPattern(String patternId) {
    shiftPatterns.removeWhere((pattern) => pattern.patternId == patternId);
    filteredShiftPatterns.value = List.from(shiftPatterns);
  }
}