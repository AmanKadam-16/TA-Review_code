import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/shift_tab_controller/shift_details_controller.dart';
import 'package:time_attendance/model/sfift_tab_model/shift_details_model.dart';
import 'package:time_attendance/widget/reusable/button/form_button.dart';
import 'package:time_attendance/widget/reusable/cheakbox/reusable_checkbox.dart';

class ShiftConfigurationScreen extends StatefulWidget {
  final ShiftDetailsController controller;
  final SiftDetailsModel shiftdetails;

  const ShiftConfigurationScreen({
    super.key,
    required this.controller,
    required this.shiftdetails,
  });

  @override
  State<ShiftConfigurationScreen> createState() => _ShiftConfigurationScreenState();
}

class _ShiftConfigurationScreenState extends State<ShiftConfigurationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Text Controllers
  late TextEditingController _shiftNameController;
  late TextEditingController _inTimeController;
  late TextEditingController _outTimeController;
  late TextEditingController _fullDayMinutesController;
  late TextEditingController _halfDayMinutesController;
  late TextEditingController _lunchMinsController;
  late TextEditingController _otherBreakMinsController;
  late TextEditingController _oTStartMinutesController;
  late TextEditingController _oTGraceMinutesController;
  late TextEditingController _autoShiftLapseTimeController;
  late TextEditingController _lunchInTimeController;
  late TextEditingController _lunchOutTimeController;
  late TextEditingController _autoShiftInTimeStartController;
  late TextEditingController _autoShiftInTimeEndController;

  // Observable checkbox states
  final RxBool isAutoShift = false.obs;
  final RxBool isOTAllowed = false.obs;
  final RxBool isHalfDayAllowed = false.obs;
  final RxBool isLunchBreakMandatory = false.obs;
  final RxBool isLunchAutoDeduct = false.obs;
  final RxBool isDefaultShift = false.obs;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeCheckboxStates();
  }

  // Initialize controllers
  void _initializeControllers() {
    _shiftNameController = TextEditingController(text: widget.shiftdetails.shiftName);
    _inTimeController = TextEditingController(text: widget.shiftdetails.inTime);
    _outTimeController = TextEditingController(text: widget.shiftdetails.outTime);
    _fullDayMinutesController = TextEditingController(text: widget.shiftdetails.fullDayMinutes?.toString() ?? '');
    _halfDayMinutesController = TextEditingController(text: widget.shiftdetails.halfDayMinutes?.toString() ?? '');
    _lunchMinsController = TextEditingController(text: widget.shiftdetails.lunchMins?.toString() ?? '');
    _otherBreakMinsController = TextEditingController(text: widget.shiftdetails.otherBreakMins?.toString() ?? '');
    _oTStartMinutesController = TextEditingController(text: widget.shiftdetails.oTStartMinutes?.toString() ?? '');
    _oTGraceMinutesController = TextEditingController(text: widget.shiftdetails.oTGraceMinutes?.toString() ?? '');
    _autoShiftLapseTimeController = TextEditingController(text: widget.shiftdetails.autoShiftLapseTime?.toString() ?? '');
    _lunchInTimeController = TextEditingController(text: widget.shiftdetails.lunchInTime);
    _lunchOutTimeController = TextEditingController(text: widget.shiftdetails.lunchOutTime);
    _autoShiftInTimeStartController = TextEditingController(text: widget.shiftdetails.autoShiftInTimeStart);
    _autoShiftInTimeEndController = TextEditingController(text: widget.shiftdetails.autoShiftInTimeEnd);
  }

  void _initializeCheckboxStates() {
    isAutoShift.value = widget.shiftdetails.isShiftAutoAssigned ?? false;
    isOTAllowed.value = widget.shiftdetails.isOTAllowed ?? false;
    // isHalfDayAllowed.value = widget.shiftdetails.isHalfDayAllowed ?? false;
    // isLunchBreakMandatory.value = widget.shiftdetails.isLunchBreakMandatory ?? false;
    // isLunchAutoDeduct.value = widget.shiftdetails.isLunchAutoDeduct ?? false;
    isDefaultShift.value = widget.shiftdetails.isDefaultShift ?? false;
  }

  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
  }

  String? _validateNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter $fieldName';
    }
    if (int.tryParse(value) == null) {
      return 'Please enter a valid number for $fieldName';
    }
    return null;
  }

  String? _validateTime(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final updatedShift = SiftDetailsModel(
          shiftID: widget.shiftdetails.shiftID,
          shiftName: _shiftNameController.text,
          inTime: _inTimeController.text,
          outTime: _outTimeController.text,
          fullDayMinutes: int.tryParse(_fullDayMinutesController.text) ?? 0,
          halfDayMinutes: int.tryParse(_halfDayMinutesController.text) ?? 0,
          lunchMins: int.tryParse(_lunchMinsController.text) ?? 0,
          otherBreakMins: int.tryParse(_otherBreakMinsController.text) ?? 0,
          oTStartMinutes: int.tryParse(_oTStartMinutesController.text) ?? 0,
          oTGraceMinutes: int.tryParse(_oTGraceMinutesController.text) ?? 0,
          autoShiftLapseTime: int.tryParse(_autoShiftLapseTimeController.text) ?? 0,
          lunchInTime: _lunchInTimeController.text,
          lunchOutTime: _lunchOutTimeController.text,
          autoShiftInTimeStart: _autoShiftInTimeStartController.text,
          autoShiftInTimeEnd: _autoShiftInTimeEndController.text,
          isShiftAutoAssigned: isAutoShift.value,
          isOTAllowed: isOTAllowed.value,
          // isHalfDayAllowed: isHalfDayAllowed.value,
          // isLunchBreakMandatory: isLunchBreakMandatory.value,
          // isLunchAutoDeduct: isLunchAutoDeduct.value,
          isDefaultShift: isDefaultShift.value,
        );

        widget.controller.saveShift(updatedShift);
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving shift: ${e.toString()}')),
        );
      }
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    _shiftNameController.dispose();
    _inTimeController.dispose();
    _outTimeController.dispose();
    _fullDayMinutesController.dispose();
    _halfDayMinutesController.dispose();
    _lunchMinsController.dispose();
    _otherBreakMinsController.dispose();
    _oTStartMinutesController.dispose();
    _oTGraceMinutesController.dispose();
    _autoShiftLapseTimeController.dispose();
    _lunchInTimeController.dispose();
    _lunchOutTimeController.dispose();
    _autoShiftInTimeStartController.dispose();
    _autoShiftInTimeEndController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double dialogWidth = MediaQuery.of(context).size.width < 767
        ? MediaQuery.of(context).size.width * 0.9
        : MediaQuery.of(context).size.width * 0.5;
    double dialogHeight = MediaQuery.of(context).size.width < 767
        ? MediaQuery.of(context).size.height * 0.45
        : MediaQuery.of(context).size.height * 0.67;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: SizedBox(
        width: dialogWidth,
        height: dialogHeight,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      widget.shiftdetails.shiftID == null ? 'Add Shift' : 'Edit Shift',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black87),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomCheckbox(
                          label: 'Set This Shift As Default Shift',
                          value: isDefaultShift,
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _shiftNameController,
                          decoration: InputDecoration(
                            labelText: 'Shift Name *',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) => _validateNotEmpty(value, 'Shift name'),
                        ),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                         Expanded(
                           child: TextFormField(
                             controller: _inTimeController,
                             decoration: InputDecoration(
                               labelText: 'In Time *',
                               suffixIcon: IconButton(
                                 icon: const Icon(Icons.access_time),
                                 onPressed: () async {
                                   TimeOfDay? pickedTime = await showTimePicker(
                                     context: context,
                                     initialTime: TimeOfDay.now(),
                                   );
                         
                                   if (pickedTime != null) {
                                     String formattedTime = '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
                                     _inTimeController.text = formattedTime;
                                   }
                                 },
                               ),
                               border: OutlineInputBorder(
                                 borderRadius: BorderRadius.circular(8),
                               ),
                             ),
                             validator: (value) => _validateTime(value, 'in time'),
                           ),
                         ),
                            const SizedBox(width: 20),
                           Expanded(
                             child: TextFormField(
                               controller: _outTimeController,
                               decoration: InputDecoration(
                                 labelText: 'Out Time *',
                                 suffixIcon: IconButton(
                                   icon: const Icon(Icons.access_time),
                                   onPressed: () async {
                                     TimeOfDay? pickedTime = await showTimePicker(
                                       context: context,
                                       initialTime: TimeOfDay.now(),
                                     );
                           
                                     if (pickedTime != null) {
                                       String formattedTime = '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
                                       _outTimeController.text = formattedTime;
                                     }
                                   },
                                 ),
                                 border: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(8),
                                 ),
                               ),
                               validator: (value) => _validateTime(value, 'out time'),
                             ),
                           ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: CustomCheckbox(
                                label: 'Auto Shift',
                                value: isAutoShift,
                              ),
                            ),
                            Expanded(
                              child: CustomCheckbox(
                                label: 'OT Allowed',
                                value: isOTAllowed,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _fullDayMinutesController,
                                decoration: InputDecoration(
                                  labelText: 'Full Day Minutes *',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) => _validateNumber(value, 'full day minutes'),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: TextFormField(
                                controller: _halfDayMinutesController,
                                decoration: InputDecoration(
                                  labelText: 'Half Day Minutes *',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) => _validateNumber(value, 'half day minutes'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        CustomCheckbox(
                          label: 'Half Day Allowed',
                          value: isHalfDayAllowed,
                        ),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _lunchMinsController,
                                decoration: InputDecoration(
                                  labelText: 'Lunch Break Minutes',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) => _validateNumber(value, 'lunch break minutes'),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: TextFormField(
                                controller: _otherBreakMinsController,
                                decoration: InputDecoration(
                                  labelText: 'Other Break Minutes',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                // keyboardType: TextInputType.number,
                                // validator: (value)
                                // validator: (value) => _validateNumber(value, 'other break minutes'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: CustomCheckbox(
                                label: 'Lunch Break Mandatory',
                                value: isLunchBreakMandatory,
                              ),
                            ),
                            Expanded(
                              child: CustomCheckbox(
                                label: 'Auto Deduct Lunch Break',
                                value: isLunchAutoDeduct,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                       

                       
                       

                        if (isAutoShift.value) ...[
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _autoShiftInTimeStartController,
                                  decoration: InputDecoration(
                                    labelText: 'Auto Shift Start Time',
                                    suffixIcon: const Icon(Icons.access_time),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  validator: (value) => _validateTime(value, 'auto shift start time'),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: TextFormField(
                                  controller: _autoShiftInTimeEndController,
                                  decoration: InputDecoration(
                                    labelText: 'Auto Shift End Time',
                                    suffixIcon: const Icon(Icons.access_time),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  validator: (value) => _validateTime(value, 'auto shift end time'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _autoShiftLapseTimeController,
                            decoration: InputDecoration(
                              labelText: 'Auto Shift Lapse Time (minutes)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) => _validateNumber(value, 'auto shift lapse time'),
                          ),
                        ],

                        const SizedBox(height: 20),
                        CustomButtons(
                          onSavePressed: _handleSave,
                          onCancelPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}