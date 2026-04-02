import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'course_card.dart';

class HorizontalCourseList extends StatefulWidget {
  final List<Map<String, String>> courses;
  final VoidCallback? onSeeMore;
  final String title;

  const HorizontalCourseList({
    super.key,
    required this.courses,
    this.onSeeMore,
    required this.title,
  });

  @override
  State<HorizontalCourseList> createState() => _HorizontalCourseListState();
}

class _HorizontalCourseListState extends State<HorizontalCourseList> {
  int _selectedFilter = 1; // "UX Design" selected by default
  final List<String> _filters = ['All', 'UX Design', 'Python', 'Python', 'Python'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: widget.onSeeMore,
                  child: Text(
                    'Show More',
                    style: TextStyle(
                      color: const Color(0xFF4F22E1),
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (widget.title.isNotEmpty) SizedBox(height: 12.h),

        // Filter chips
        SizedBox(
          height: 36.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: _filters.length,
            itemBuilder: (context, index) {
              final selected = _selectedFilter == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedFilter = index),
                child: Container(
                  margin: EdgeInsets.only(right: 8.w),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFF4F22E1) : Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: selected
                          ? const Color(0xFF4F22E1)
                          : const Color(0xFFE0E0E0),
                    ),
                  ),
                  child: Text(
                    _filters[index],
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: selected ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        SizedBox(height: 12.h),

        SizedBox(
          height: 210.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: widget.courses.length,
            itemBuilder: (context, index) {
              final course = widget.courses[index];
              return CourseCard(
                title: course['title'] ?? '',
                subtitle: course['subtitle'] ?? '',
                price: course['price'] ?? '',
                imageUrl: course['imageUrl'] ?? '',
                onTap: () {},
              );
            },
          ),
        ),
      ],
    );
  }
}