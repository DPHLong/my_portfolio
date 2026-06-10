import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContactForm extends StatefulWidget {
  final ThemeData theme;
  const ContactForm({super.key, required this.theme});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      await FirebaseFirestore.instance.collection('messages').add({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'subject': _subjectController.text.trim(),
        'message': _messageController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Message sent successfully! I will get back to you soon.',
            ),
            backgroundColor: Colors.green,
          ),
        );
        _formKey.currentState!.reset();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send message: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: true,
        prefixIcon: maxLines == 1 ? Icon(icon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.1),
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _nameController,
                        label: 'Name',
                        icon: Icons.person_outline,
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if (val == null || val.isEmpty) return 'Required';
                          if (!val.contains('@')) return 'Invalid email';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _subjectController,
                  label: 'Subject',
                  icon: Icons.subject,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _messageController,
                  label: 'Message',
                  icon: Icons.message_outlined,
                  maxLines: 6,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitForm,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Send Message',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
