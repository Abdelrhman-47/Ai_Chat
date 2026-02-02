import 'package:ai_chat/core/networking/api_service.dart';
import 'package:ai_chat/core/networking/dio_clint.dart';
import 'package:ai_chat/core/utils/app_colors.dart';
import 'package:ai_chat/core/utils/constatnts.dart';
import 'package:ai_chat/featuers/chat/cubit/cubit/chat_cubit.dart';
import 'package:ai_chat/featuers/chat/data/data_source/remote_data_source.dart';
import 'package:ai_chat/featuers/chat/data/repo/chat_repo.dart';
import 'package:ai_chat/featuers/chat/views/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class OnBoardingButton extends StatelessWidget {
  const OnBoardingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) {
            return BlocProvider(
              create: (context) => ChatCubit(
                chatRepository: ChatRepositoryImpl(
                  remoteDataSource: RemoteDataSource(
                    apiServices: ApiServices(dioClient: DioClient()),
                  ),
                ),
              ),
              child: ChatPage(),
            );
          },
        ),
      ),
      child: Container(
        width: double.infinity,
        height: 48.h,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 106.w),
              Text(
                "Continue",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secoundryColor,
                ),
              ),
              Spacer(),
              SvgPicture.asset(AppConstants.arrowRightSvg),
            ],
          ),
        ),
      ),
    );
  }
}
