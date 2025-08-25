import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/authentication/login_screen/login_provider.dart';

class LoginFormWidget extends StatelessWidget {
  const LoginFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoginProvider>();

    return Form(
      key: provider.formKey,
      child: Column(
        children: [
          SizedBox(
            width: 400,
            child: TextFormField(
              controller: provider.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email),
                labelText: "E-Mail",
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              validator: provider.validateEmail,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 400,
            child: TextFormField(
              controller: provider.passwordController,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.password),
                labelText: "Password",
                suffixIcon: IconButton(
                  icon: Icon(provider.hidePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: provider.togglePasswordVisibility,
                ),
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              validator: provider.validatePassword,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              obscureText: provider.hidePassword,
            ),
          ),
        ],
      ),
    );
  }
}
