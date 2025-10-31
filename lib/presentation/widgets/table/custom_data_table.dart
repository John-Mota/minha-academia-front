import 'package:flutter/material.dart';

class TableColumn {
  final String title;
  final String dataKey;
  final bool isAction;
  final int flex;
  final double? minWidth;

  const TableColumn({
    required this.title,
    required this.dataKey,
    this.isAction = false,
    this.flex = 1,
    this.minWidth,
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
  static const double _minScrollWidth = 700.0;

  Widget _buildCell(dynamic item, ThemeData theme, TableColumn column) {
    final Widget content;

    if (column.isAction) {
      content = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            color: Colors.white.withOpacity(0.8),
            onPressed: onEdit != null ? () => onEdit!(item) : null,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 30, height: 32),
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 20),
            color: Colors.redAccent,
            onPressed: onDelete != null ? () => onDelete!(item) : null,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 30, height: 32),
          ),
        ],
      );
    } else {
      final cellValue = item[column.dataKey];
      if (column.dataKey == 'status' || column.dataKey == 'plano') {
        content = _buildStatusOrPlanChip(cellValue, theme);
      } else {
        content = Text(
          cellValue?.toString() ?? '',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        );
      }
    }

    return column.isAction
        ? Align(alignment: Alignment.center, child: content)
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(alignment: Alignment.centerLeft, child: content),
          );
  }

  Widget _buildHeaderRow(ThemeData theme, double contentWidth) {
    return Container(
      width: contentWidth,
      height: _headerHeight,
      decoration: const BoxDecoration(
        color: _cardBackgroundColor,
        border: Border(bottom: BorderSide(color: _dividerColor, width: 1.0)),
      ),
      child: Row(
        children: columns.map((column) {
          final Widget headerContent = Text(
            column.title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
            overflow: TextOverflow.ellipsis,
          );

          final Widget finalContent = column.isAction
              ? Align(alignment: Alignment.center, child: headerContent)
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: headerContent,
                  ),
                );

          return Flexible(flex: column.flex, child: finalContent);
        }).toList(),
      ),
    );
  }

  Widget _buildDataRow(
    Map<String, dynamic> item,
    ThemeData theme,
    double contentWidth,
  ) {
    return Container(
      width: contentWidth,
      height: _rowHeight,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _dividerColor, width: 1.0)),
      ),
      child: Row(
        children: columns.map((column) {
          return Flexible(
            flex: column.flex,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _buildCell(item, theme, column),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatusOrPlanChip(dynamic value, ThemeData theme) {
    if (value == null) return const Text('');

    Color color;
    Color textColor = Colors.white;

    if (value == 'Ativo') {
      color = Colors.green.shade600;
    } else if (value == 'Inativo' ||
        value == 'Não Ativo' ||
        value == 'Licença' ||
        value == 'Férias') {
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
      label: SizedBox(
        width: 65.0,
        child: Text(
          value.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      labelPadding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth;
        final bool requiresScrolling = availableWidth < _minScrollWidth;
        final double contentWidth = requiresScrolling
            ? _minScrollWidth
            : availableWidth;

        Widget tableContent = Column(
          children: [
            _buildHeaderRow(theme, contentWidth),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: ListView.builder(
                  itemCount: data.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return _buildDataRow(item, theme, contentWidth);
                  },
                ),
              ),
            ),
          ],
        );

        if (requiresScrolling) {
          tableContent = SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(width: contentWidth, child: tableContent),
          );
        }

        return Container(
          width: availableWidth,
          decoration: BoxDecoration(
            color: _cardBackgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 2.0,
            ),
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
              Expanded(child: tableContent),
            ],
          ),
        );
      },
    );
  }
}
