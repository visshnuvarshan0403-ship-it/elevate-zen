import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _signIn() {
    final username = emailController.text.trim().toLowerCase();

    // Prototype role routing.
    //
    // chinmayi -> Doctor
    // vet / veterinary -> Veterinary
    // anything else -> Patient

    if (username.contains('chinmayi')) {
      Navigator.pushReplacementNamed(
        context,
        '/doctor',
      );
    } else if (username.contains('vet') ||
        username.contains('veterinary')) {
      Navigator.pushReplacementNamed(
        context,
        '/veterinary',
      );
    } else {
      Navigator.pushReplacementNamed(
        context,
        '/patient',
      );
    }
  }

  void _continueWithGoogle() {
    // Prototype only.
    // Replace with Google authentication later.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Google sign-in will be connected here.',
        ),
      ),
    );
  }

  void _forgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Password recovery will be connected here.',
        ),
      ),
    );
  }

  void _createAccount() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Account creation will be added here.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(colorScheme),

            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 26,
                      vertical: 24,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 48,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 520,
                          ),
                          child: _buildContent(colorScheme),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ColorScheme colorScheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildBrand(colorScheme),

        const SizedBox(height: 42),

        _buildLoginForm(colorScheme),

        const SizedBox(height: 24),

        _buildDivider(colorScheme),

        const SizedBox(height: 20),

        _buildGoogleButton(colorScheme),

        const SizedBox(height: 24),

        _buildCreateAccount(colorScheme),

        const SizedBox(height: 20),

        _buildSecurityNote(colorScheme),
      ],
    );
  }

  // ------------------------------------------------------------
  // TOP BAR
  // ------------------------------------------------------------

  Widget _buildHeader(ColorScheme colorScheme) {
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.health_and_safety_outlined,
              size: 24,
              color: colorScheme.onPrimaryContainer,
            ),
          ),

          const SizedBox(width: 11),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ELEVATE ZEN',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
              ),
              Text(
                'Healthcare, made simpler',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),

          const Spacer(),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colorScheme.outlineVariant,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  size: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 5),
                Text(
                  'Secure',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // BRAND
  // ------------------------------------------------------------

  Widget _buildBrand(ColorScheme colorScheme) {
    return Column(
      children: [
        Container(
          width: 104,
          height: 104,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.health_and_safety_outlined,
                color: colorScheme.primary,
                size: 34,
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        Text(
          'Welcome back',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
                letterSpacing: -0.6,
              ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        Text(
          'Sign in to continue your healthcare journey.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // LOGIN FORM
  // ------------------------------------------------------------

  Widget _buildLoginForm(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Email or mobile number',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            hintText: 'Enter your email or mobile number',
            prefixIcon: Icon(
              Icons.person_outline_rounded,
            ),
          ),
        ),

        const SizedBox(height: 18),

        Text(
          'Password',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: passwordController,
          obscureText: obscurePassword,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _signIn(),
          decoration: InputDecoration(
            hintText: 'Enter your password',
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
            ),
            suffixIcon: IconButton(
              tooltip: obscurePassword
                  ? 'Show password'
                  : 'Hide password',
              onPressed: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
          ),
        ),

        const SizedBox(height: 6),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: _forgotPassword,
            child: const Text(
              'Forgot password?',
            ),
          ),
        ),

        const SizedBox(height: 8),

        SizedBox(
          height: 56,
          child: FilledButton.icon(
            onPressed: _signIn,
            icon: const Icon(
              Icons.arrow_forward_rounded,
            ),
            label: const Text(
              'Sign in',
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // DIVIDER
  // ------------------------------------------------------------

  Widget _buildDivider(ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: colorScheme.outlineVariant,
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
          ),
          child: Text(
            'OR',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),

        Expanded(
          child: Divider(
            color: colorScheme.outlineVariant,
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // GOOGLE
  // ------------------------------------------------------------

  Widget _buildGoogleButton(ColorScheme colorScheme) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton.icon(
        onPressed: _continueWithGoogle,
        icon: const _GoogleIcon(),
        label: const Text(
          'Continue with Google',
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // CREATE ACCOUNT
  // ------------------------------------------------------------

  Widget _buildCreateAccount(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            'New to Elevate Zen?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ),

        TextButton(
          onPressed: _createAccount,
          child: const Text(
            'Create account',
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // SECURITY NOTE
  // ------------------------------------------------------------

  Widget _buildSecurityNote(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.lock_outline_rounded,
          size: 15,
          color: colorScheme.onSurfaceVariant,
        ),

        const SizedBox(width: 6),

        Flexible(
          child: Text(
            'Your health information stays under your control.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ),
      ],
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'G',
      style: TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}