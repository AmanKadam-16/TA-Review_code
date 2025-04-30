import 'package:flutter/material.dart';

class ReusableTableAndCard extends StatefulWidget {
  final List<Map<String, String>> data;
  final List<String> headers;
  final List<String> visibleColumns;
  final Function(Map<String, String>)? onEdit;
  final Function(Map<String, String>)? onDelete;
  final Function(Map<String, String>)? onGeoFence;
  final Function(String columnName, bool isAscending)? onSort;

  const ReusableTableAndCard({
    super.key,
    required this.data,
    required this.headers,
    this.visibleColumns = const [],
    this.onEdit,
    this.onDelete,
    this.onGeoFence,
    this.onSort,
  });

  @override
  _ReusableTableAndCardState createState() => _ReusableTableAndCardState();
}

class _ReusableTableAndCardState extends State<ReusableTableAndCard> {
  String? _currentSortColumn;
  bool _isAscending = true;

  void _onSort(String column) {
    setState(() {
      if (_currentSortColumn == column) {
        _isAscending = !_isAscending;
      } else {
        _currentSortColumn = column;
        _isAscending = true;
      }
      widget.onSort?.call(column, _isAscending);
    });
  }

  Widget _buildSortableHeader(String header) {
    return Expanded(
      child: InkWell(
        onTap: header != "Actions" && header != "GeoFence" ? () => _onSort(header) : null,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Row(
            mainAxisAlignment: header == "GeoFence" ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Text(
                header,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              if (_currentSortColumn == header)
                Icon(
                  _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGeoFenceIcon(Map<String, String> row) {
    final isGeoFenceEnabled = row['GeoFence'] == 'Yes';
    return InkWell(
      onTap: () => widget.onGeoFence?.call(row),
      child: Icon(
        isGeoFenceEnabled ? Icons.location_on : Icons.location_off,
        color: isGeoFenceEnabled ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 600) {
          return _buildCardView(context, 1);
        } else if (constraints.maxWidth <= 920) {
          return _buildCardView(context, 2);
        } else {
          return _buildTableView(context);
        }
      },
    );
  }

  Widget _buildTableView(BuildContext context) {
    final regularHeaders = widget.headers
        .where((header) =>
            header != widget.headers.last &&
            (widget.visibleColumns.isEmpty || widget.visibleColumns.contains(header)))
        .toList();
    final lastHeader = widget.headers.last;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Row(
              children: [
                Expanded(
                  flex: 9,
                  child: Row(
                    children: regularHeaders
                        .map((header) => _buildSortableHeader(header))
                        .toList(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      lastHeader,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: widget.data.map((row) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFDEE2E6),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 9,
                          child: Row(
                            children: regularHeaders.map((header) {
                              if (header == "GeoFence") {
                                return Expanded(
                                  child: Center(
                                    child: _buildGeoFenceIcon(row),
                                  ),
                                );
                              }
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                                  child: Tooltip(
                                    message: (row[header]?.length ?? 0) > 12 ? row[header]! : '',
                                    child: Text(
                                      (row[header]?.length ?? 0) > 20
                                          ? '${row[header]!.substring(0, 20)}...'
                                          : row[header] ?? '',
                                      style: const TextStyle(
                                        color: Color(0xFF495057),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (widget.onEdit != null)
                                IconButton(
                                  icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
                                  onPressed: () => widget.onEdit!(row),
                                ),
                              if (widget.onDelete != null)
                                IconButton(
                                  icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                                  onPressed: () => widget.onDelete!(row),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardView(BuildContext context, int cardsPerRow) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: List.generate(
            (widget.data.length / cardsPerRow).ceil(),
            (rowIndex) {
              return Row(
                children: List.generate(cardsPerRow, (colIndex) {
                  final index = rowIndex * cardsPerRow + colIndex;
                  if (index >= widget.data.length) {
                    return Expanded(child: Container());
                  }
                  final row = widget.data[index];
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => _showFullInfoDialog(context, row),
                      child: Card(
                        margin: const EdgeInsets.all(4.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: widget.headers
                                      .where((header) =>
                                          header != "Actions" &&
                                          header != "City" &&
                                          header != "State")
                                      .take(2)
                                      .map((header) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Tooltip(
                                        message: (row[header]?.length ?? 0) > 12
                                            ? row[header]!
                                            : '',
                                        child: GestureDetector(
                                          onTap: () => _showFullTextDialog(
                                              context, header, row[header]),
                                          child: Text(
                                            (row[header]?.length ?? 0) > 20
                                                ? '${row[header]!.substring(0, 20)}...'
                                                : row[header] ?? '',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (widget.headers.contains('GeoFence'))
                                      InkWell(
                                        onTap: () => widget.onGeoFence?.call(row),
                                        child: row['GeoFence'] == 'Yes'
                                          ? const Icon(Icons.location_on, color: Colors.green)
                                          : const Icon(Icons.location_off, color: Colors.red),
                                      ),
                                    if (widget.onEdit != null)
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        color: Theme.of(context).colorScheme.primary,
                                        onPressed: () => widget.onEdit!(row),
                                      ),
                                    if (widget.onDelete != null)
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Theme.of(context).colorScheme.error),
                                        onPressed: () => widget.onDelete!(row),
                                      ),
                                  ],                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showFullTextDialog(BuildContext context, String? header, String? text) {
    if (text == null || text.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(header ?? 'Details'),
          content: Text(text),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void _showFullInfoDialog(BuildContext context, Map<String, String> row) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Full Information'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: row.entries.map((entry) {
                if (entry.key == 'longitude' || entry.key == 'latitude' || entry.key == 'distance' || (entry.key != 'Actions' && entry.value.isNotEmpty)) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      '${entry.key}: ${entry.value}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}