import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/grade_tracker_provider.dart';
import '../../models/subject.dart';

class SubjectListScreen extends StatelessWidget {
  const SubjectListScreen({super.key});

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

  Color _getGradeTextColor(BuildContext context, String grade) {
    final theme = Theme.of(context);
    switch (grade) {
      case 'A':
        return theme.colorScheme.onPrimary;
      case 'B':
        return theme.colorScheme.onSecondary;
      case 'C':
        return theme.colorScheme.surface;
      case 'F':
      default:
        return theme.colorScheme.onError;
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
                  color: theme.colorScheme.primary.withOpacity(0.1),
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
                  color: theme.colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your recorded subjects and grades will appear here. Add a new subject to start tracking.',
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
                label: const Text('Add Your First Subject'),
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
                  color: theme.colorScheme.onBackground,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
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
                key: ValueKey(subject), // Safe distinct key using the model instance reference
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
                      Icon(
                        Icons.delete,
                        color: theme.colorScheme.onError,
                      ),
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
                  ScaffoldMessenger.of(context).clearSnacks();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${deletedSubject.name} deleted'),
                      backgroundColor: theme.colorScheme.onBackground,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      action: SnackBarAction(
                        label: 'UNDO',
                        textColor: theme.colorScheme.primary,
                        onPressed: () {
                          provider.insertSubject(deletedIndex, deletedSubject);
                        },
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Subject Icon
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.book_outlined,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Subject Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                subject.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Mark: ${subject.mark.toStringAsFixed(subject.mark % 1 == 0 ? 0 : 1)}%',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Grade Badge
                        Container(
                          width: 44,
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _getGradeColor(context, subject.grade),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: _getGradeColor(context, subject.grade).withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            subject.grade,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: _getGradeTextColor(context, subject.grade),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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
