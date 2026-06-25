import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/grade_tracker_provider.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  Color _getGradeColor(BuildContext context, String grade) {
    final theme = Theme.of(context);
    switch (grade) {
      case 'A':
        return theme.colorScheme.primary;
      case 'B':
        return theme.colorScheme.secondary;
      case 'C':
        return theme.colorScheme.onSurface.withOpacity(0.6);
      case 'F':
      default:
        return theme.colorScheme.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GradeTrackerProvider>();
    final theme = Theme.of(context);

    final total = provider.totalSubjects;
    final passing = provider.passingSubjectsCount; // Uses .where()
    final failing = provider.failingSubjectsCount; // Uses .where()
    final average = provider.averageMark;          // Uses .map()
    final overallGrade = provider.overallGrade;

    final passingRate = total == 0 ? 0.0 : (passing / total) * 100.0;

    if (total == 0) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.insert_chart_outlined_outlined,
                  size: 80,
                  color: theme.colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No Performance Data',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Add subjects with marks to generate your performance report cards and overall average grade.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onBackground.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  provider.setCurrentIndex(0); // Switch to Add Subject screen
                },
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Add Subject Now'),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Circular progress / Overall status card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(
                    'Overall Performance',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Radial progress layout
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: CircularProgressIndicator(
                          value: average / 100.0,
                          strokeWidth: 12,
                          backgroundColor: theme.colorScheme.onSurface.withOpacity(0.1),
                          color: _getGradeColor(context, overallGrade),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            overallGrade,
                            style: theme.textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.black,
                              color: _getGradeColor(context, overallGrade),
                            ),
                          ),
                          Text(
                            'Grade',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  Text(
                    'Average Mark: ${average.toStringAsFixed(1)}%',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  Text(
                    passingRate == 100.0 
                        ? 'Excellent job! You are passing all courses.'
                        : 'Passing ${passingRate.toStringAsFixed(0)}% of your courses.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 2x2 grid of details using Row/Column
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  title: 'Total Subjects',
                  value: '$total',
                  icon: Icons.book,
                  cardColor: theme.colorScheme.primary.withOpacity(0.1),
                  iconColor: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  context,
                  title: 'Passing Rate',
                  value: '${passingRate.toStringAsFixed(0)}%',
                  icon: Icons.speed,
                  cardColor: theme.colorScheme.secondary.withOpacity(0.1),
                  iconColor: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  title: 'Passing',
                  value: '$passing',
                  icon: Icons.check_circle_outline,
                  cardColor: theme.colorScheme.primary.withOpacity(0.1),
                  iconColor: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  context,
                  title: 'Failing',
                  value: '$failing',
                  icon: Icons.error_outline,
                  cardColor: theme.colorScheme.error.withOpacity(0.1),
                  iconColor: theme.colorScheme.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color cardColor,
    required Color iconColor,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: theme.cardTheme.shape is RoundedRectangleBorder
            ? (theme.cardTheme.shape as RoundedRectangleBorder).side
            : Border.all(color: theme.colorScheme.onSurface.withOpacity(0.08)),
        boxShadow: theme.cardTheme.elevation != null && theme.cardTheme.elevation! > 0
            ? [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
