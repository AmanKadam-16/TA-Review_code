import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/shift_tab_controller/shift_details_controller.dart';
import 'package:time_attendance/model/sfift_tab_model/shift_details_model.dart';
import 'package:time_attendance/screen/shift_tab_screen/shift_details_screen/shift_details_dialog_screen.dart';
import 'package:time_attendance/widget/reusable/button/custom_action_button.dart';
import 'package:time_attendance/widget/reusable/dialog/dialogbox.dart';
import 'package:time_attendance/widget/reusable/list/reusable_list.dart';
import 'package:time_attendance/widget/reusable/pagination/pagination_widget.dart';
import 'package:time_attendance/widget/reusable/search/reusable_search_field.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';

class MainShiftDetailsScreen extends StatelessWidget {
  MainShiftDetailsScreen({Key? key}) : super(key: key);

  final ShiftDetailsController controller = Get.put(ShiftDetailsController());
  final TextEditingController _searchController = TextEditingController();
  final RxInt _currentPage = 1.obs;
  final RxInt _itemsPerPage = 10.obs;
  final RxInt _totalPages = 1.obs;

  void _handlePageChange(int page) {
    _currentPage.value = page;
  }

  void _handleItemsPerPageChange(int value) {
    _itemsPerPage.value = value;
    _currentPage.value = 1;
    _calculateTotalPages();
  }

  void _calculateTotalPages() {
    _totalPages.value = (controller.filteredShifts.length / _itemsPerPage.value).ceil();
  }

  List<SiftDetailsModel> _getPaginatedData() {
    final startIndex = (_currentPage.value - 1) * _itemsPerPage.value;
    final endIndex = startIndex + _itemsPerPage.value;
    if (startIndex >= controller.filteredShifts.length) return [];
    return controller.filteredShifts.sublist(
      startIndex,
      endIndex > controller.filteredShifts.length 
          ? controller.filteredShifts.length 
          : endIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.initializeAuthShift();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shift Details'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          if (MediaQuery.of(context).size.width > 600)
            ReusableSearchField(
              searchController: _searchController,
              onSearchChanged: controller.updateSearchQuery,
            ),
          const SizedBox(width: 20),
          CustomActionButton(
            label: 'Add Shift',
            onPressed: () => _showShiftDetailsDialog(context),
          ),
          const SizedBox(width: 8),
          HelpTooltipButton(
            tooltipMessage: 'Manage shift details for your organization.',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          if (MediaQuery.of(context).size.width <= 600)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ReusableSearchField(
                searchController: _searchController,
                onSearchChanged: controller.updateSearchQuery,
                responsiveWidth: false,
              ),
            ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              _calculateTotalPages();
              final paginatedData = _getPaginatedData();

              return Column(
                children: [
                  Expanded(
                    child: ReusableTableAndCard(
                      data: List.generate(paginatedData.length, (index) {
                        final shift = paginatedData[index];
                        return {
                          'Shift Name': shift.shiftName ?? 'N/A',
                          'In Time': shift.inTime ?? 'N/A',
                          'Out Time': shift.outTime ?? 'N/A',
                          'Full Day': shift.fullDayMinutes?.toString() ?? 'N/A',
                          'Half Day': shift.halfDayMinutes?.toString() ?? 'N/A',
                          'OT Allowed': shift.isOTAllowed == true ? 'Yes' : 'No',
                          'Lunch Minutes': shift.lunchMins?.toString() ?? 'N/A',
                          'Other Break': shift.otherBreakMins?.toString() ?? 'N/A',
                          'Default Shift': shift.isDefaultShift == true ? 'Yes' : 'No',
                          'Actions': 'Edit/Delete',
                        };
                      }),
                      headers: const [
                        'Shift Name',
                        'In Time',
                        'Out Time',
                        'Full Day',
                        'Half Day',
                        'OT Allowed',
                        'Lunch Minutes',
                        'Other Break',
                        'Default Shift',
                        'Actions'
                      ],
                      visibleColumns: const [
                        'Shift Name',
                        'In Time',
                        'Out Time',
                        'Full Day',
                        'Half Day',
                        'OT Allowed',
                        'Lunch Minutes',
                        'Other Break',
                        'Default Shift',
                        'Actions'
                      ],
                      onEdit: (row) {
                        final shift = paginatedData.firstWhere(
                          (s) => s.shiftName == row['Shift Name'],
                        );
                        _showShiftDetailsDialog(context, shift);
                      },
                      onDelete: (row) {
                        final shift = paginatedData.firstWhere(
                          (s) => s.shiftName == row['Shift Name'],
                          orElse: () => SiftDetailsModel(),
                        );
                        if (shift.shiftID != null) {
                          _showDeleteConfirmationDialog(context, shift);
                        }
                      },
                      onSort: (columnName, ascending) {
                        controller.sortShifts(columnName, ascending);
                      },
                    ),
                  ),
                  Obx(() => PaginationWidget(
                    currentPage: _currentPage.value,
                    totalPages: _totalPages.value,
                    onFirstPage: () => _handlePageChange(1),
                    onPreviousPage: () => _handlePageChange(_currentPage.value - 1),
                    onNextPage: () => _handlePageChange(_currentPage.value + 1),
                    onLastPage: () => _handlePageChange(_totalPages.value),
                    onItemsPerPageChange: _handleItemsPerPageChange,
                    itemsPerPage: _itemsPerPage.value,
                    itemsPerPageOptions: const [10, 25, 50, 100],
                    totalItems: controller.filteredShifts.length,
                  )),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showShiftDetailsDialog(BuildContext context, [SiftDetailsModel? shift]) {
    showCustomDialog(
      context: context,
      dialogContent: [
        ShiftConfigurationScreen(
          controller: controller,
          shiftdetails: shift ?? SiftDetailsModel(),
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, SiftDetailsModel shift) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete ${shift.shiftName}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await controller.deleteShift(shift.shiftID ?? '');
                if (context.mounted) Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}