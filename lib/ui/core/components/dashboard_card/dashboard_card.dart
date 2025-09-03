import 'package:flutter/material.dart';
import 'package:minha_academia_front/ui/core/components/dashboard_card/dashboard_card_data.dart';

class DashboardCard extends StatelessWidget {
  final DashboardCardData data;

  const DashboardCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    data.title,
                    style: Theme.of(context).textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(data.icon, color: data.infoColor),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              data.quantity,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 32.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              data.info,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: data.infoColor),
            ),
          ],
        ),
      ),
    );
  }
}
