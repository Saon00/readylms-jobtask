import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterModal extends StatefulWidget {
  const FilterModal({super.key});

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  final List<String> _topics = [
    'Web Design',
    'Graphics',
    'Art & Media',
    'Product Design',
    'Web Design',
    'Graphics',
    'Product Design',
  ];
  final Set<int> _selectedTopics = {};

  final List<String> _moreFilters = [
    'Popular',
    'Free',
    'Discounted',
    'New',
    'Denim',
    'Free',
    'Free',
    'Discounted',
    'New',
    'Popular',
  ];
  final Set<int> _selectedMore = {0, 9}; // Popular selected by default

  RangeValues _priceRange = const RangeValues(75, 150);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF5D3A1A),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  child: Icon(
                    Icons.close,
                    color: Colors.black87,
                    size: 22.sp,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // By Topic section
                  _SectionHeader(title: 'By Topic'),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: List.generate(_topics.length, (i) {
                      final selected = _selectedTopics.contains(i);
                      return _FilterChip(
                        label: _topics[i],
                        selected: selected,
                        onTap: () {
                          setState(() {
                            if (selected) {
                              _selectedTopics.remove(i);
                            } else {
                              _selectedTopics.add(i);
                            }
                          });
                        },
                      );
                    }),
                  ),

                  SizedBox(height: 24.h),

                  // More section
                  _SectionHeader(title: 'More'),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: List.generate(_moreFilters.length, (i) {
                      final selected = _selectedMore.contains(i);
                      return _FilterChip(
                        label: _moreFilters[i],
                        selected: selected,
                        showCheck: selected,
                        onTap: () {
                          setState(() {
                            if (selected) {
                              _selectedMore.remove(i);
                            } else {
                              _selectedMore.add(i);
                            }
                          });
                        },
                      );
                    }),
                  ),

                  SizedBox(height: 24.h),

                  // Price Range section
                  _SectionHeader(title: 'Price Range'),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'USD',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '\$${_priceRange.start.toInt()}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '\$${_priceRange.end.toInt()}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.black87,
                      inactiveTrackColor: const Color(0xFFE0E0E0),
                      thumbColor: Colors.white,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 10,
                        elevation: 3,
                      ),
                      overlayColor: Colors.black.withAlpha((0.08 * 255).round()),
                      trackHeight: 3,
                    ),
                    child: RangeSlider(
                      values: _priceRange,
                      min: 0,
                      max: 300,
                      onChanged: (values) {
                        setState(() => _priceRange = values);
                      },
                    ),
                  ),

                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),

          // Bottom buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF4F22E1)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedTopics.clear();
                      _selectedMore.clear();
                      _priceRange = const RangeValues(75, 150);
                    });
                  },
                  child: Text(
                    'Reset Filter',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F22E1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    elevation: 0,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Search',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Icon(Icons.keyboard_arrow_up, color: Colors.black54, size: 20.sp),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool showCheck;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    this.showCheck = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: selected
                    ? Colors.black87
                    : const Color(0xFFE0E0E0),
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          if (showCheck)
            Positioned(
              top: -6,
              right: -6,
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}