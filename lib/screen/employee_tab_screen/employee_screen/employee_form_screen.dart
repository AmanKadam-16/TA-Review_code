import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:time_attendance/controller/employee_tab_controller/emplyoee_controller.dart';
import 'package:time_attendance/widget/reusable/button/form_button.dart';

class EmployeeForm extends StatelessWidget {
  final EmployeeController controller = Get.put(EmployeeController());

  EmployeeForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employee Form')),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Professional'),
                Tab(text: 'Personal'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildProfessionalTab(context),
                  _buildPersonalTab(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormRow(
            children: [
              _buildTextField(
                controller: controller.employeeIdController,
                label: 'Employee ID',
              ),
              _buildTextField(
                controller: controller.enrollIdController,
                label: 'Device Enroll ID *',
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              _buildTextField(
                controller: controller.employeeNameController,
                label: 'Employee Name *',
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Professional Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildFormRow(
            children: [
              _buildDropdown(
                options: controller.companies,
                label: "Company *",
                onChanged: (value) => controller.selectedCompany.value = value!,
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              _buildDropdown(
                options: controller.departments,
                label: "Department *",
                onChanged: (value) => controller.selectedDepartment.value = value!,
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              _buildTextField(
                controller: controller.employeeTypeController,
                label: 'Employee Type',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFormRow(
            children: [
              _buildTextField(
                controller: controller.designationController,
                label: 'Designation *',
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              _buildDropdown(
                options: controller.locations,
                label: "Location *",
                onChanged: (value) => controller.selectedLocation.value = value!,
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              _buildDateField(
                controller: controller.dateOfJoiningController,
                label: 'Date of Joining',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFormRow(
            children: [
              _buildTextField(
                controller: controller.seniorReportingController,
                label: 'Senior Reporting Person',
              ),
              _buildTextField(
                controller: controller.officeEmailController,
                label: 'Office Email ID',
                keyboardType: TextInputType.emailAddress,
              ),
              _buildDateField(
                controller: controller.dateOfLeavingController,
                label: 'Date of Leaving',
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSaveCancelButtons(context),
        ],
      ),
    );
  }

  Widget _buildPersonalTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormRow(
            children: [
              _buildTextField(
                controller: controller.genderController,
                label: 'Gender *',
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              _buildTextField(
                controller: controller.bloodGroupController,
                label: 'Blood Group',
              ),
              _buildTextField(
                controller: controller.nationalityController,
                label: 'Nationality',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFormRow(
            children: [
              _buildTextField(
                controller: controller.personalEmailController,
                label: 'Personal Email Id',
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || !value.contains('@') ? 'Invalid email' : null,
              ),
              _buildTextField(
                controller: controller.mobileNoController,
                label: 'Mobile No.',
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              _buildDateField(
                controller: controller.dateOfBirthController,
                label: 'Date of Birth',
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFormRow(
            children: [
              _buildTextField(
                controller: controller.localAddressController,
                label: 'Local Address',
                maxLines: 3,
              ),
              _buildTextField(
                controller: controller.permanentAddressController,
                label: 'Permanent Address',
                maxLines: 3,
              ),
              _buildTextField(
                controller: controller.contactNoController,
                label: 'Contact No',
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSaveCancelButtons(context),
        ],
      ),
    );
  }

  Widget _buildFormRow({required List<Widget> children}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Mobile: width < 600 (1 item per row)
        // Laptop: width >= 600 && < 1200 (2 items per row)
        // PC: width >= 1200 (3 items per row)
        int itemsPerRow;
        if (constraints.maxWidth < 600) {
          itemsPerRow = 1;
        } else if (constraints.maxWidth < 1200) {
          itemsPerRow = 2;
        } else {
          itemsPerRow = 3;
        }

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: children.asMap().entries.map((entry) {
            return SizedBox(
              width: (constraints.maxWidth - (itemsPerRow - 1) * 16) / itemsPerRow,
              child: entry.value,
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
    FormFieldValidator<String>? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onTap: onTap,
      validator: validator,
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      onTap: () => _selectDate(Get.context!, controller),
      validator: validator,
    );
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Widget _buildDropdown({
    required List<String> options,
    required String label,
    required ValueChanged<String?> onChanged,
    FormFieldValidator<String>? validator,
  }) {
    return DropdownButtonFormField<String>(
      items: options
          .map((option) => DropdownMenuItem(
                value: option,
                child: Text(option),
              ))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      validator: validator,
    );
  }

  Widget _buildShiftTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Shift Type *', style: TextStyle(fontSize: 14)),
        Row(
          children: [
            _buildRadioButton("Fix"),
            _buildRadioButton("Rotation"),
            _buildRadioButton("Auto Assign Shift"),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioButton(String value) {
    return Obx(() => Row(
          children: [
            Radio(
              value: value,
              groupValue: controller.shiftType.value,
              onChanged: (value) => controller.updateShiftType(value as String),
            ),
            Text(value),
          ],
        ));
  }

  Widget _buildSaveCancelButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomButtons(
          onSavePressed: () {
            controller.saveEmployee();
            Navigator.pop(context);
          },
          onCancelPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}