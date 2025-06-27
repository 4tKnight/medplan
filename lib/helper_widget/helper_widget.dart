import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/helper_widget/view_full_image.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/global.dart';

//helperWidget

class HelperWidget {
  Widget handleFutureBuilderError(Function() retryFunction) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 80, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Something went wrong!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Unknown error occurred.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              retryFunction();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget myAppBar(
    BuildContext context,
    String title, {
    bool isBack = true,
    Color bgColor = const Color.fromRGBO(249, 251, 255, 1),
  }) {
    return AppBar(
      backgroundColor: bgColor,
      elevation: 0,
      title: Text(
        title,
        style:  TextStyle(
          color: Colors.black,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      centerTitle: true,
      leading:
          isBack
              ? IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  navigatorKey.currentState!.pop();
                },
              )
              : null,
    );
  }

  Widget cachedImage({required String url, double? height, double? width}) {
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      fit: BoxFit.cover,
      placeholder:
          (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(height: height, width: width, color: Colors.white),
          ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  showToast(String message, {bool isError = false}) {
    return showSimpleNotification(
      Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
      background: isError ? Colors.red : primaryColor,
      position: NotificationPosition.bottom,
      slideDismissDirection: DismissDirection.horizontal,
      duration: const Duration(seconds: 3),
    );
  }

  dynamic showSnackbar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: primaryColor, content: Text(text)),
    );
  }

  Widget emptyScreen(String text) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Center(child: Lottie.asset('assets/empty.json')),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 30.0),
            child: Text(
              "It's empty in here. Tap the \"+\" icon to add new $text",
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 70),
        ],
      ),
    );
  }

  Widget customEmptyScreen(
    String text,
    String json, {
    double lottie_height = 180,
    double lottie_width = 180,
    double height = 150,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: height),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SizedBox(
            //     height: lottie_height,
            //     width: lottie_width,
            //     child: Lottie.asset('assets/$json.json')),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 30.0),
              child: Text(text, textAlign: TextAlign.center),
            ),
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }

  Widget noInternetScreen(Function() function) {
    return Center(
      child: Column(
        children: [
           SizedBox(height: 50.h),
           Icon(Icons.wifi_off_rounded, size: 80.r),
           Text(
            'No internet connection',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
          ),
           SizedBox(height: 10.h),
           Text(
            'Please check your internet connection and try again',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w300),
          ),
           SizedBox(height: 50.h),
          ElevatedButton(
            style: ButtonStyle(
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              backgroundColor: WidgetStateProperty.all<Color>(Colors.blueGrey),
            ),
            onPressed: function,
            child: const Text("Try Again"),
          ),
        ],
      ),
    );
  }

  Widget errorScreen(Function() function) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 150),
          const Icon(Icons.error_outline_rounded, size: 80),
          const Text(
            'ERROR',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          const Text(
            'Something went wrong',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            style: ButtonStyle(
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              backgroundColor: WidgetStateProperty.all<Color>(Colors.blueGrey),
            ),
            onPressed: function,
            child: const Text("Try Again"),
          ),
        ],
      ),
    );
  }

  Widget buildLoadingButton() {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          backgroundColor: WidgetStateProperty.all<Color>(primaryColor),
        ),
        onPressed: () {},
        child: const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ),
    );
  }

  Widget errorWidget(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Image.asset('./assets/no_image.png'),
      ),
    );
  }

  Widget showProfilePicture(
    BuildContext context,
    String url, [
    double radius = 40.0,
  ]) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ViewFullImage(url, "hero")),
        );
      },
      child: CircleAvatar(
        backgroundColor: Colors.grey[200],
        radius: radius,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(360),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              placeholder:
                  (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.white,
                    ),
                  ),
              errorWidget:
                  (context, url, error) => Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset('./assets/avatar.png'),
                  ),
            ),
          ),
        ),
      ),
    );
  }

  buildProfilePicture(String url, double radius) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(0.8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(180),
          child: Container(
            height: 120,
            width: 120,
            color: Colors.black,
            child: CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              placeholder:
                  (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: double.infinity,
                      height: 120,
                      color: Colors.white,
                    ),
                  ),
              errorWidget:
                  (context, url, error) => Container(
                    color: Colors.grey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "./assets/avatar.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }

  Widget build_divider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Color.fromRGBO(0, 0, 0, 0.3),
    );
  }
}
