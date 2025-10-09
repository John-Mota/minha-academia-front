import 'package:flutter/material.dart';

class TableColumn {
  final String title;
  final String dataKey;
  final bool isAction;
  final int flex;

  const TableColumn({
    required this.title,
    required this.dataKey,
    this.isAction = false,
    this.flex = 1,
  });
}

class CustomDataTable extends StatelessWidget {
  final String title;
  final List<TableColumn> columns;
  final List<Map<String, dynamic>> data;
  final bool hasActions;
  final void Function(Map<String, dynamic> item)? onEdit;
  final void Function(Map<String, dynamic> item)? onDelete;

  const CustomDataTable({
    super.key,
    required this.title,
    required this.columns,
    required this.data,
    this.hasActions = true,
    this.onEdit,
    this.onDelete,
  });

  static const Color _cardBackgroundColor = Color(0xFF1A2234);
  static const Color _dividerColor = Color(0xFF28324A);
  static const double _rowHeight = 60.0;
  static const double _headerHeight = 48.0;

  Widget _buildCell(dynamic item, ThemeData theme, TableColumn column) {
    if (column.isAction) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            color: Colors.white.withOpacity(0.8),
            onPressed: onEdit != null ? () => onEdit!(item) : null,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.delete, size: 20),
            color: Colors.redAccent,
            onPressed: onDelete != null ? () => onDelete!(item) : null,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      );
    }
    final cellValue = item[column.dataKey];
    if (column.dataKey == 'status' || column.dataKey == 'plano') {
      return _buildStatusOrPlanChip(cellValue, theme);
    } else {
      return Text(
        cellValue?.toString() ?? '',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
      );
    }
  }

  Widget _buildHeaderRow(ThemeData theme) {
    return Container(
      height: _headerHeight,
      decoration: const BoxDecoration(
        color: _cardBackgroundColor,
        border: Border(bottom: BorderSide(color: _dividerColor, width: 1.0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: columns.map((column) {
          int flexValue = column.flex;

          return Flexible(
            flex: flexValue,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                column.title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDataBody(ThemeData theme) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: ListView.builder(
          itemCount: data.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            final item = data[index];
            return Container(
              height: _rowHeight,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: _dividerColor, width: 1.0),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: columns.map((column) {
                  int flexValue = column.flex;

                  return Flexible(
                    flex: flexValue,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: _buildCell(item, theme, column),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusOrPlanChip(dynamic value, ThemeData theme) {
    if (value == null) return const Text('');

    Color color;
    Color textColor = Colors.white;

    if (value == 'Ativo') {
      color = Colors.green.shade600;
    } else if (value == 'Inativo' || value == 'Não Ativo') {
      color = Colors.red.shade600;
    } else if (value == 'Premium') {
      color = Colors.purple.shade600;
    } else if (value == 'Básico') {
      color = Colors.grey.shade600;
    } else if (value == 'Intermediário') {
      color = Colors.blue.shade600;
    } else {
      color = theme.colorScheme.secondary;
    }

    if (color.computeLuminance() > 0.5) {
      textColor = Colors.black;
    }

    return Chip(
      label: Text(
        value.toString(),
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      labelPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: -2),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: _cardBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
            child: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 6.0),
          _buildHeaderRow(theme),
          _buildDataBody(theme),
        ],
      ),
    );
  }
}
