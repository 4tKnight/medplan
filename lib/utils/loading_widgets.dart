import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingWidgets {
  Widget loadingHorizontalList() {
  return ListView.separated(
    scrollDirection: Axis.horizontal,
    itemCount: 5,
    shrinkWrap: true,
    separatorBuilder: (BuildContext context, int index) {
      return const SizedBox(width: 10);
    },
    itemBuilder: (BuildContext context, int index) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 150,
          width: 210,
          decoration: BoxDecoration(
            color: Colors.white, 
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    },
  );
  }

Widget loadingCategory() {
  return ListView.separated(
    scrollDirection: Axis.horizontal,
    itemCount: 5,
    shrinkWrap: true,
    separatorBuilder: (BuildContext context, int index) {
      return const SizedBox(width: 20);
    },
    itemBuilder: (BuildContext context, int index) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 70,
          width: 70, // Assuming circular category items
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(35), // Fully circular shape
          ),
        ),
      );
    },
  );
}
Widget loadingGrid() {
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 8,
      childAspectRatio: 0.72,
    ),
    itemCount: 6,
    itemBuilder: (BuildContext context, int index) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 210,
          width: 185,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      );
    },
  );
}
}
