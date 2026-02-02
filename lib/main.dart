import 'package:ai_chat/core/utils/app_colors.dart';
import 'package:ai_chat/featuers/on_boarding/views/on_boarding_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const AiChat());
}

class AiChat extends StatelessWidget {
  const AiChat({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
       designSize: const Size(357, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(scaffoldBackgroundColor: AppColors.secoundryColor,
        ),
        home: OnBoardingView(),
      ),
    );
  }
}

