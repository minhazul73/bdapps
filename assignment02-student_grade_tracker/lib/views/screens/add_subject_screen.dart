import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/grade_tracker_provider.dart';

class AddSubjectScreen extends StatefulWidget {
  const AddSubjectScreen({super.key});

  @override
  State<AddSubjectScreen> createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _markController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _markController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final mark = double.parse(_markController.text.trim());

      // Add to provider
      final provider = context.read<GradeTrackerProvider>();
      provider.addSubject(name, mark);

      // Clear the text fields
      _nameController.clear();
      _markController.clear();

      // Show success feedback
      final theme = Theme.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: theme.colorScheme.onSecondary,
              ),
              const SizedBox(width: 12),
              Text(
                '$name added successfully!',
                style: TextStyle(color: theme.colorScheme.onSecondary),
              ),
            ],
          ),
          backgroundColor: theme.colorScheme.secondary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      // Auto-navigate to Subject List (Tab 1) for a seamless UX
      provider.setCurrentIndex(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.75, 1],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.school,
                  size: 40,
                  color: theme.colorScheme.onPrimary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Record Your Progress',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add a subject and its mark to track your academic performance and calculate grades automatically.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Form Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Subject details',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Subject Name Field
                    TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Subject Name',
                        hintText: 'e.g., Mathematics, Physics, Art',
                        prefixIcon: Icon(Icons.book),
                      ),
                      style: TextStyle(color: theme.colorScheme.onSurface),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter the subject name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Mark Field
                    TextFormField(
                      controller: _markController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Mark Obtanied',
                        hintText: 'e.g., 85, 92.5',
                        prefixIcon: Icon(Icons.percent),
                      ),
                      style: TextStyle(color: theme.colorScheme.onSurface),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter the mark';
                        }
                        final mark = double.tryParse(value.trim());
                        if (mark == null) {
                          return 'Please enter a valid number';
                        }
                        if (mark < 0 || mark > 100) {
                          return 'Mark must be between 0 and 100';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    ElevatedButton.icon(
                      onPressed: _submitForm,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Subject'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
