import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/router/app_router.dart';
import '../../../helper/secure_storage_helper/secure_storage_helper.dart';
import '../../login/domain/bloc/login_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _secureStorageHelper = GetIt.I<SecureStorageHelper>();

  late final Future? future;

  String name = '';
  String expiresIn = '';

  Future<void> _handleData() async {
    final idToken = await _secureStorageHelper.get(key: 'idToken');
    final _expiresIn = await _secureStorageHelper.get(key: 'expiresIn');
    final _isEmpty = idToken == null ||
        idToken.isEmpty ||
        _expiresIn == null ||
        _expiresIn.isEmpty;

    if (_isEmpty) return;

    Map<String, dynamic> payload = Jwt.parseJwt(idToken);

    setState(() {
      name = payload['name'];
      expiresIn = DateFormat('MM/dd/yyyy, hh:mm:ss aa')
          .format(DateTime.parse(_expiresIn));
    });
  }

  @override
  void initState() {
    super.initState();
    future = _handleData();
  }

  @override
  Widget build(BuildContext context) {
    final hasSafeArea = MediaQuery.of(context).viewPadding.bottom != 0;
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        return BlocListener<LoginBloc, LoginState>(
          listener: (context, state) => state.maybeWhen(
            logoutSuccess: () =>
                AutoRouter.of(context).replace(LoginPageRoute()),
            tokenRefreshSuccess: () => _handleData(),
            orElse: () => {},
          ),
          child: Scaffold(
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: hasSafeArea ? 0 : 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Flutter SSO Authentication',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        _buildLogoutButton(context),
                      ],
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Hey, $name!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          'Token Expires In: \n $expiresIn',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        _buildRefreshToken(context),
                      ],
                    ),
                    SizedBox(height: 16),
                    _buildHrWebButton(context),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRefreshToken(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleRefreshTokenPressed(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green[700],
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 2),
        child: Icon(
          Icons.refresh,
          color: Colors.white,
        ),
      ),
    );
  }

  void _handleRefreshTokenPressed(BuildContext context) {
    BlocProvider.of<LoginBloc>(context).add(
      LoginEvent.refreshToken(),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleLogoutPressed(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green[700],
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 2),
        child: Icon(
          Icons.logout,
          color: Colors.white,
        ),
      ),
    );
  }

  void _handleLogoutPressed(BuildContext context) {
    BlocProvider.of<LoginBloc>(context).add(
      LoginEvent.logout(),
    );
  }

  Widget _buildHrWebButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleOpenHr(context),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.green[700],
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Text(
          'Open Web',
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

  Future<void> _handleOpenHr(BuildContext context) async {
    final domainUrl = await _secureStorageHelper.get(key: 'domainUrl');
    final uri = Uri.parse('https://$domainUrl');
    await launch(uri.toString());
  }
}
