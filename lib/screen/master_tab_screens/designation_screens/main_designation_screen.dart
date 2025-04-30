import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/master_tab_controller/designation_controller.dart';
import 'package:time_attendance/model/master_tab_model/designation_model.dart';
import 'package:time_attendance/screen/master_tab_screens/designation_screens/designation_dialog_screen.dart';
import 'package:time_attendance/widget/reusable/button/custom_action_button.dart';
import 'package:time_attendance/widget/reusable/dialog/dialogbox.dart';
import 'package:time_attendance/widget/reusable/list/reusable_list.dart';
import 'package:time_attendance/widget/reusable/pagination/pagination_widget.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';
import 'package:time_attendance/widget/reusable/search/reusable_search_field.dart';

class MainDesignationScreen extends StatelessWidget {
  MainDesignationScreen({super.key});

  final DesignationController controller = Get.find<DesignationController>();
  final TextEditingController _searchController = TextEditingController();
  int _currentPage = 1;
  int _itemsPerPage = 10;
  int _totalPages = 1;

  @override
  Widget build(BuildContext context) {
    // Ensure designations are fetched every time the screen is opened
    // controller.fetchDesignations();
    controller.initializeAuthDesignation();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Designation'),
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
            label: 'Add Designation',
            onPressed: () => _showDesignationDialog(context),
          ),
          const SizedBox(width: 8),
          HelpTooltipButton(
            tooltipMessage:
                'Manage designations for employees or roles in this section.',
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

              return Column(
                children: [
                  Expanded(
                    child: ReusableTableAndCard(
                      data: List.generate(
                        controller.filteredDesignations.length,
                        (index) => {
                          'Designation Name': controller.filteredDesignations[index].designationName.isEmpty ? 'N/A' : controller.filteredDesignations[index].designationName,
                          'Master Designation': controller.filteredDesignations[index].masterDesignationName.isEmpty ? 'N/A' : controller.filteredDesignations[index].masterDesignationName,
                        },
                      ),
                      headers: [
                        'Designation Name',
                        'Master Designation',
                        'Actions'
                      ],
                      visibleColumns: [
                        'Designation Name',
                        'Master Designation',
                        'Actions'
                      ],
                      onEdit: (row) {
                        final designation =
                            controller.filteredDesignations.firstWhere(
                          (d) => d.designationName == row['Designation Name'],
                        );
                        _showDesignationDialog(context, designation);
                      },
                      onDelete: (row) {
                        final designation =
                            controller.filteredDesignations.firstWhere(
                          (d) => d.designationName == row['Designation Name'],
                        );
                        _showDeleteConfirmationDialog(context, designation);
                      },
                      onSort: (columnName, ascending) =>
                          controller.sortDesignations(columnName, ascending),
                    ),
                  ),
                  PaginationWidget(
                    currentPage: _currentPage,
                    totalPages: _totalPages,
                    onFirstPage: () => _handlePageChange(1),
                    onPreviousPage: () => _handlePageChange(_currentPage - 1),
                    onNextPage: () => _handlePageChange(_currentPage + 1),
                    onLastPage: () => _handlePageChange(_totalPages),
                    onItemsPerPageChange: _handleItemsPerPageChange,
                    itemsPerPage: _itemsPerPage,
                    itemsPerPageOptions: [10, 25, 50, 100],
                    totalItems: controller.filteredDesignations.length,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showDesignationDialog(BuildContext context,
      [DesignationModel? designation]) {
    showCustomDialog(
      context: context,
      dialogContent: [
        DesignationDialog(
          controller: controller,
          designation: designation ?? DesignationModel(),
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, DesignationModel designation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content:
              const Text('Are you sure you want to delete this designation?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                controller.deleteDesignation(designation.designationId);
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _handlePageChange(int page) {
    _currentPage = page;
    controller.update();
  }

  void _handleItemsPerPageChange(int itemsPerPage) {
    _itemsPerPage = itemsPerPage;
    _currentPage = 1;
    controller.update();
  }
}