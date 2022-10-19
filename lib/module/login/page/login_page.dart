import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/router/app_router.dart';
import '../domain/bloc/login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String domainUrl = '';

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) => state.maybeWhen(
        loginSuccess: () => AutoRouter.of(context).replace(HomePageRoute()),
        orElse: () => {},
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'example.hrhub.ph',
                      labelText: 'Sprout HR URL',
                      focusColor: Colors.black,
                      floatingLabelStyle: TextStyle(color: Colors.black87),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green[700]!,
                          width: 1,
                        ),
                      ),
                    ),
                    onChanged: (text) => setState(() {
                      domainUrl = text;
                    }),
                  ),
                  SizedBox(height: 16),
                  _buildLoginButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleLoginPressed(context),
      child: Container(
        width: double.infinity,
        // height: ,
        decoration: BoxDecoration(
          color: Colors.green[700],
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _handleLoginPressed(BuildContext context) {
    if (domainUrl.isEmpty) return;
    BlocProvider.of<LoginBloc>(context).add(
      LoginEvent.login(domainUrl: domainUrl),
    );
  }
}
