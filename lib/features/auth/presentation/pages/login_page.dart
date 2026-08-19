import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/brand_header.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _remember = true;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginSubmitted(_username.text.trim(), _password.text),
      );
    }
  }

  void _soon() => ScaffoldMessenger.of(
    context,
  ).showSnackBar(const SnackBar(content: Text('Coming soon')));

  @override
  Widget build(BuildContext context) => Scaffold(
    body: BlocListener<AuthBloc, AuthState>(
      listenWhen: (a, b) => a.error != b.error && b.error != null,
      listener: (context, state) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.error!))),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const BrandHeader(),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 30, 22, 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Welcome Back',
                        textAlign: TextAlign.center,
                        style: appTheme().textTheme.titleLarge?.copyWith(
                          fontSize: 28,
                          fontFamily: 'LexendDeca',
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        style: appTheme().textTheme.displayMedium?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                        controller: _username,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(hintText: 'Username'),
                        validator: Validators.username,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        style: appTheme().textTheme.displayMedium?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                        controller: _password,
                        obscureText: _obscure,
                        onFieldSubmitted: (_) => _submit(),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                        ),
                        validator: Validators.password,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: _remember,
                            activeColor: AppColors.primary,
                            onChanged: (value) =>
                                setState(() => _remember = value ?? false),
                          ),
                          const Text(
                            'Remember me',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'LexendDeca',
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: _soon,
                            child: const Text(
                              'Forgot password?',
                              style: TextStyle(
                                color: Color(0xFF2DC28D),
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'LexendDeca',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) => SizedBox(
                          height: 52,
                          child: FilledButton(
                            onPressed: state.status == AuthStatus.submitting
                                ? null
                                : _submit,
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.blueColor,
                              shape: const StadiumBorder(),
                            ),
                            child: state.status == AuthStatus.submitting
                                ? const SizedBox.square(
                                    dimension: 22,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontFamily: 'LexendDeca',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'or',
                        textAlign: TextAlign.center,
                        style: appTheme().textTheme.labelMedium?.copyWith(
                          fontSize: 16,
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 18),
                      OutlinedButton.icon(
                        onPressed: _soon,
                        icon: SvgPicture.asset(
                          'assets/svg/google.svg',
                          width: 20,
                          height: 20,
                        ),
                        label: const Text(
                          'Login with Google',
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            fontFamily: 'LexendDeca',
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          side: const BorderSide(color: AppColors.line),
                          shape: const StadiumBorder(),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Not a member? ',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'LexendDeca',
                            ),
                          ),
                          TextButton(
                            onPressed: _soon,
                            child: const Text(
                              'Sign up',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'LexendDeca',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
