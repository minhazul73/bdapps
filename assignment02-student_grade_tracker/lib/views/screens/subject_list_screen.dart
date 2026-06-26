import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/grade_tracker_provider.dart';
import '../themes/app_themes.dart';

class SubjectListScreen extends StatelessWidget {
  const SubjectListScreen({super.key});

  Color _getGradeColor(BuildContext context, String grade) {
    final gradeColors = Theme.of(context).gradeColors;
    switch (grade) {
      case 'A':
        return gradeColors.gradeA;
      case 'B':
        return gradeColors.gradeB;
      case 'C':
        return gradeColors.gradeC;
      case 'F':
      default:
        return gradeColors.gradeF;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GradeTrackerProvider>();
    final subjects = provider.subjects;
    final theme = Theme.of(context);

    if (subjects.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.assignment_outlined,
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No Subjects Added Yet',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your recorded subjects and grades will appear here. Add a new subject to start tracking.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  provider.setCurrentIndex(0); // Switch to Add Subject screen
                },
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Add Your First Subject'),
                style: ButtonStyle(
                  padding: WidgetStatePropertyAll(
                    EdgeInsetsGeometry.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recorded Subjects',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${subjects.length} Total',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              final subject = subjects[index];

              return Dismissible(
                key: ValueKey(
                  subject,
                ), // Safe distinct key using the model instance reference
                direction: DismissDirection.endToStart,
                background: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Delete',
                        style: TextStyle(
                          color: theme.colorScheme.onError,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.delete, color: theme.colorScheme.onError),
                    ],
                  ),
                ),
                onDismissed: (direction) {
                  // Keep a reference to the subject for the undo action
                  final deletedSubject = subject;
                  final deletedIndex = index;
              
                  // Remove from Provider state
                  provider.deleteSubject(index);
              
                  // Show SnackBar with Undo action
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${deletedSubject.name} deleted'),
                      backgroundColor: theme.colorScheme.onSurface,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      action: SnackBarAction(
                        label: 'UNDO',
                        textColor: theme.colorScheme.primary,
                        onPressed: () {
                          provider.insertSubject(
                            deletedIndex,
                            deletedSubject,
                          );
                        },
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {}, // Add a subtle ripple effect
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Subject Icon
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.auto_stories_rounded,
                              color: theme.colorScheme.primary,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
              
                          // Subject Details & Progress
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  subject.name,
                                  style: theme.textTheme.titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            child: LinearProgressIndicator(
                                              value: subject.mark / 100.0,
                                              minHeight: 6,
                                              backgroundColor: theme
                                                  .colorScheme
                                                  .onSurface
                                                  .withValues(alpha: 0.1),
                                              valueColor:
                                                  AlwaysStoppedAnimation<
                                                    Color
                                                  >(
                                                    _getGradeColor(
                                                      context,
                                                      subject.grade,
                                                    ),
                                                  ),
                                            ),
                                          ),
                                          // Markers for grades: C (50%), B (65%), A (80%)
                                          Positioned.fill(
                                            child: Row(
                                              children: [
                                                const Spacer(flex: 50),
                                                Container(
                                                  width: 2,
                                                  color: theme
                                                      .colorScheme
                                                      .surface,
                                                ),
                                                const Spacer(flex: 15),
                                                Container(
                                                  width: 2,
                                                  color: theme
                                                      .colorScheme
                                                      .surface,
                                                ),
                                                const Spacer(flex: 15),
                                                Container(
                                                  width: 2,
                                                  color: theme
                                                      .colorScheme
                                                      .surface,
                                                ),
                                                const Spacer(flex: 20),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      '${subject.mark.toStringAsFixed(subject.mark % 1 == 0 ? 0 : 1)}%',
                                      style: theme.textTheme.labelLarge
                                          ?.copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withValues(alpha: 0.7),
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
              
                          // Grade Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: _getGradeColor(
                                context,
                                subject.grade,
                              ).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'GRADE',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: _getGradeColor(
                                      context,
                                      subject.grade,
                                    ),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                    fontSize: 8,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  subject.grade,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: _getGradeColor(
                                      context,
                                      subject.grade,
                                    ),
                                    fontWeight: FontWeight.w900,
                                    height: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
