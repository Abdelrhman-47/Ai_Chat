import 'package:ai_chat/core/utils/constatnts.dart';
import 'package:ai_chat/featuers/on_boarding/widgets/header_section.dart';
import 'package:ai_chat/featuers/on_boarding/widgets/on_boarding_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoardingView extends StatelessWidget {
  const OnBoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 25.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 69.h),
              Align(alignment: Alignment.center, child: HeaderSection()),
              SizedBox(height: 90.h),
              Image.asset(AppConstants.onBoardingImage),
              SizedBox(height: 70.h),
              OnBoardingButton(),
            ],
          ),
        ),
      ),
    );
  }
}
