import 'package:flutter/material.dart';

void main() => runApp(const RegistrationApp());

class RegistrationApp extends StatelessWidget {
  const RegistrationApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = ColorScheme.fromSeed(seedColor: const Color(0xFF4169C1));
    return MaterialApp(
      title: 'User Registration & Profile Setup',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colors,
        scaffoldBackgroundColor: const Color(0xFFF5F7FC),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE0E5EF)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: colors.primary, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        ),
      ),
      home: const RegistrationScreen(),
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  bool _hidePassword = true;
  bool _submitted = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Please enter your full name.';
    if (v.length < 2) return 'Name must contain at least 2 characters.';
    if (RegExp(r'\d').hasMatch(v)) return 'Name cannot contain numbers.';
    return null;
  }

  String? _validateEmail(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Please enter your email address.';
    if (!RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$').hasMatch(v)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Please enter your phone number.';
    final digits = v.replaceAll(RegExp(r'[\\s()+-]'), '');
    if (!RegExp(r'^\d{9,15}$').hasMatch(digits)) {
      return 'Enter 9–15 digits; +, spaces and hyphens are allowed.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Please create a password.';
    if (v.length < 8) return 'Use at least 8 characters.';
    if (!RegExp(r'[A-Z]').hasMatch(v)) return 'Add an uppercase letter.';
    if (!RegExp(r'[a-z]').hasMatch(v)) return 'Add a lowercase letter.';
    if (!RegExp(r'\d').hasMatch(v)) return 'Add at least one number.';
    return null;
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      setState(() => _submitted = false);
      return;
    }
    setState(() => _submitted = true);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('Validation successful for ${_name.text.trim()}'),
        behavior: SnackBarBehavior.floating,
      ));
  }

  void _reset() {
    _formKey.currentState?.reset();
    _name.clear();
    _email.clear();
    _phone.clear();
    _password.clear();
    FocusScope.of(context).unfocus();
    setState(() {
      _hidePassword = true;
      _submitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create your profile'),
        actions: [
          IconButton(
            tooltip: 'Reset form',
            onPressed: _reset,
            icon: const Icon(Icons.restart_alt_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            final landscape = orientation == Orientation.landscape;
            final form = _formPanel(theme);
            final preview = _profilePanel(theme);
            if (landscape) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 6, child: form),
                        const SizedBox(width: 20),
                        Expanded(flex: 5, child: preview),
                      ],
                    ),
                  ),
                ),
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _intro(theme),
                      const SizedBox(height: 18),
                      form,
                      const SizedBox(height: 18),
                      preview,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _intro(ThemeData theme) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/profile_illustration.png',
              height: 145,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 15),
          Text('Let’s get you started',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 5),
          Text('Add your details to set up your profile.',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ],
      );

  Widget _formPanel(ThemeData theme) {
    final colors = theme.colorScheme;
    return Card(
      elevation: 1,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Personal information', style: theme.textTheme.titleLarge),
              const SizedBox(height: 18),
              TextFormField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                validator: _validateName,
                decoration: const InputDecoration(
                  labelText: 'Full name',
                  hintText: 'e.g. Arian Rahmani',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: _validateEmail,
                decoration: const InputDecoration(
                  labelText: 'Email address',
                  hintText: 'you@example.com',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                validator: _validatePhone,
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                  hintText: '+93 700 123 456',
                  prefixIcon: Icon(Icons.phone_iphone_rounded),
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _password,
                obscureText: _hidePassword,
                textInputAction: TextInputAction.done,
                validator: _validatePassword,
                onFieldSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'At least 8 characters',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    tooltip: _hidePassword ? 'Show password' : 'Hide password',
                    onPressed: () => setState(() => _hidePassword = !_hidePassword),
                    icon: Icon(_hidePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text('Use 8+ characters with uppercase, lowercase and a number.',
                  style: theme.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant)),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  label: const Text('Submit registration'),
                ),
              ),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _reset,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => showAboutDialog(
                      context: context,
                      applicationName: 'Profile Setup',
                      applicationVersion: '1.0.0',
                      children: const [
                        Text('This demo validates fields locally and does not send or save your data.'),
                      ],
                    ),
                    icon: const Icon(Icons.help_outline_rounded),
                    label: const Text('Help'),
                  ),
                ),
              ]),
              if (_submitted) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(children: [
                    Icon(Icons.verified_user_outlined, color: colors.onPrimaryContainer),
                    const SizedBox(width: 10),
                    Expanded(child: Text('Validation successful. Profile preview updated.',
                        style: TextStyle(color: colors.onPrimaryContainer))),
                  ]),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _profilePanel(ThemeData theme) {
    final colors = theme.colorScheme;
    final displayName = _name.text.trim().isEmpty ? 'Your name' : _name.text.trim();
    final displayEmail = _email.text.trim().isEmpty ? 'you@example.com' : _email.text.trim();
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Profile preview', style: theme.textTheme.titleLarge),
          const SizedBox(height: 18),
          Center(
            child: Column(children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: colors.primaryContainer,
                child: ClipOval(
                  child: Image.network(
                    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&auto=format&fit=crop',
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 96,
                      height: 96,
                      color: colors.primaryContainer,
                      alignment: Alignment.center,
                      child: Icon(Icons.person_rounded, size: 48, color: colors.onPrimaryContainer),
                    ),
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const SizedBox(
                        width: 96,
                        height: 96,
                        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(displayName, textAlign: TextAlign.center, style: theme.textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(displayEmail, textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
              const SizedBox(height: 12),
              Chip(
                avatar: Icon(_submitted ? Icons.check_circle : Icons.edit_note, size: 18),
                label: Text(_submitted ? 'Ready for review' : 'Draft profile'),
              ),
            ]),
          ),
          const Divider(height: 28),
          const _PreviewRow(icon: Icons.security_outlined, text: 'Your password is never shown in the preview.'),
          const SizedBox(height: 10),
          const _PreviewRow(icon: Icons.privacy_tip_outlined, text: 'Demo only: information stays on this screen.'),
        ]),
      ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: colors.primary, size: 20),
      const SizedBox(width: 10),
      Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
    ]);
  }
}
