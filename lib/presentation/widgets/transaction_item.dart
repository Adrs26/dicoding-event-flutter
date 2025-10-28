import 'package:flutter/material.dart';
import 'package:test_project/core/theme/color_scheme.dart';

class TransactionItem extends StatelessWidget {
  final String title;
  final String date;
  final String amount;

  const TransactionItem({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: orange600,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.restaurant,
                size: 24,
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      date,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              amount,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: green600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
