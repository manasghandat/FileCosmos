import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Center(
        child:InkWell(
          child: Container(
            height: 54,
            width: 280,
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF000000).withOpacity(0.084),
                  blurRadius: 3,
                ),
                BoxShadow(
                  color: const Color(0xFF000000).withOpacity(0.168),
                  offset: const Offset(0, 2),
                  blurRadius: 3,
                ),
              ],
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: SvgPicture.asset(
                  'assets/logo/googleIcon.svg',
                  height: 24,
                  width: 24,
                ),
                  ),
                Text(
                  'Sign In with Google',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF000000).withOpacity(0.54),
                  ),
                  ),
              ]
            )
          ),
        )
      ),
    );
  }
}