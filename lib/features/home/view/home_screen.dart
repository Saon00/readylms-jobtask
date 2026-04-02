import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readylms_jobtask/core/values/colors.dart';
import 'package:readylms_jobtask/core/widgets/bottom_nav/bottom_nav_bar.dart';
import 'package:readylms_jobtask/features/home/widgets/course_card.dart';
import 'package:readylms_jobtask/features/home/widgets/filter_modal.dart';
import 'package:readylms_jobtask/core/local_storage/hive_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  int _selectedTopRatedChip = 0;
  int _selectedFreeCourseChip = 0;

  final List<Map<String, String>> _courses = [
    {
      'title': 'UX Design for Businesses',
      'subtitle': 'Design | Sophia Khan',
      'price': '\$20.00',
      'imageUrl': '',
    },
    {
      'title': 'Flutter for Beginners',
      'subtitle': 'Development | John Doe',
      'price': '\$25.00',
      'imageUrl': '',
    },
    {
      'title': 'Advanced Python',
      'subtitle': 'Programming | Jane Smith',
      'price': '\$30.00',
      'imageUrl': '',
    },
  ];

  void _openFilter() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Filter',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, anim, _, child) {
        final curved = Curves.easeOutCubic.transform(anim.value);
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  color: Colors.black.withAlpha((0.4 * anim.value * 255).round()),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset((1 - curved) * MediaQuery.of(context).size.width, 0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Material(
                  color: Colors.transparent,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height,
                    child: const Center(child: FilterModal()),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.gradientMiddle : AppColors.grey.withAlpha(30),
          borderRadius: BorderRadius.circular(8.r),
          // border: Border.all(
          //   color: selected ? const Color(0xFF4F22E1) : const Color(0xFFE0E0E0),
          //   width: 1.2,
          // ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF8B8B8B),
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.h),

                        // ── Top bar ──
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(999),
                                child: Image.asset(
                                  'assets/images/young.jpg',
                                  width: 44.w,
                                  height: 44.w,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hello, ${HiveService.getUserName() ?? 'Fahmida'}',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      'Browse or search your courses.',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Color(0xFF4F22E1),
                                ),
                                onPressed: () {},
                              ),
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.notifications_outlined,
                                      color: Color(0xFF4F22E1),
                                    ),
                                    onPressed: () {},
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      width: 16,
                                      height: 16,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFE53935),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Center(
                                        child: Text(
                                          '2',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 16.h),

                        // ── Search + filter ──
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 46.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 12.w),
                                      Icon(
                                        Icons.search,
                                        color: Colors.grey[500],
                                        size: 20.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'Search',
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              GestureDetector(
                                onTap: _openFilter,
                                child: Container(
                                  width: 46.w,
                                  height: 46.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Icon(
                                    Icons.tune_rounded,
                                    color: Colors.grey,
                                    size: 20.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 16.h),

                        // ── Promo Banner (full width) ──
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4F22E1),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(20.w),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Discounted Courses',
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.yellow[200],
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        'Discount 50% for the first\npurchases',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.white.withAlpha((0.9 * 255).round()),
                                          height: 1.4,
                                        ),
                                      ),
                                      SizedBox(height: 12.h),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: const Color(0xFF4F22E1),
                                          elevation: 0,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 18.w,
                                            vertical: 8.h,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.r),
                                          ),
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          'Purchase Now',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20.r),
                                      bottomRight: Radius.circular(20.r),
                                    ),
                                    child: Image.asset(
                                      'assets/images/young.jpg',
                                      width: 120.w,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // ── Top Rated Courses ──
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            'Top Rated Courses',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        SizedBox(
                          height: 36.h,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            children: [
                              _buildChip('All', _selectedTopRatedChip == 0, () => setState(() => _selectedTopRatedChip = 0)),
                              _buildChip('UX Design', _selectedTopRatedChip == 1, () => setState(() => _selectedTopRatedChip = 1)),
                              _buildChip('Python', _selectedTopRatedChip == 2, () => setState(() => _selectedTopRatedChip = 2)),
                              _buildChip('Python', _selectedTopRatedChip == 3, () => setState(() => _selectedTopRatedChip = 3)),
                              _buildChip('Python', _selectedTopRatedChip == 4, () => setState(() => _selectedTopRatedChip = 4)),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            children: _courses.take(2).map((course) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 16.h),
                                child: CourseCard(
                                  title: course['title']!,
                                  subtitle: course['subtitle']!,
                                  price: course['price']!,
                                  imageUrl: course['imageUrl']!,
                                  isVertical: true,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Show More',
                              style: TextStyle(
                                color: const Color(0xFF4F22E1),
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // ── Free Courses ──
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            'Free Courses',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        SizedBox(
                          height: 36.h,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            children: [
                              _buildChip('All', _selectedFreeCourseChip == 0, () => setState(() => _selectedFreeCourseChip = 0)),
                              _buildChip('UX Design', _selectedFreeCourseChip == 1, () => setState(() => _selectedFreeCourseChip = 1)),
                              _buildChip('Python', _selectedFreeCourseChip == 2, () => setState(() => _selectedFreeCourseChip = 2)),
                              _buildChip('Python', _selectedFreeCourseChip == 3, () => setState(() => _selectedFreeCourseChip = 3)),
                              _buildChip('Python', _selectedFreeCourseChip == 4, () => setState(() => _selectedFreeCourseChip = 4)),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            children: _courses.take(2).map((course) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 16.h),
                                child: CourseCard(
                                  title: course['title']!,
                                  subtitle: course['subtitle']!,
                                  price: course['price']!,
                                  imageUrl: course['imageUrl']!,
                                  isVertical: true,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Show More',
                              style: TextStyle(
                                color: const Color(0xFF4F22E1),
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
