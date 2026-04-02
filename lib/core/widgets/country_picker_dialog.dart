import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/country_list.dart';
import '../values/app_fonts.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import 'custom_button_widget.dart';

class Country {
  final String name;
  final String dialCode;
  final String flag;

  const Country({
    required this.name,
    required this.dialCode,
    required this.flag,
  });

  factory Country.fromMap(Map<String, String> map) {
    return Country(
      name: map['name'] ?? '',
      dialCode: map['code'] ?? '',
      flag: map['icon'] ?? '',
    );
  }

  static Country defaultCountry() {
    // Defaults to Indonesia (+62) because the UI mock uses it.
    // Falls back to the first item if not found.
    final List<Country> all = CountryData.all;
    return all.firstWhere(
      (c) => c.dialCode == '+880',
      orElse: () => all.isNotEmpty
          ? all.first
          : const Country(name: 'Unknown', dialCode: '+', flag: ''),
    );
  }
}

class CountryData {
  static final List<Country> all =
      countryList.map(Country.fromMap).toList(growable: false)
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
}

class CountryPickerDialog extends StatefulWidget {
  final Country initial;

  const CountryPickerDialog({super.key, required this.initial});

  @override
  State<CountryPickerDialog> createState() => _CountryPickerDialogState();
}

class _CountryPickerDialogState extends State<CountryPickerDialog> {
  final TextEditingController _searchController = TextEditingController();

  late Country _selected;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _selected = widget.initial;
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Country> _filteredCountries() {
    if (_query.isEmpty) return CountryData.all;
    final q = _query.toLowerCase();
    return CountryData.all
        .where((c) {
          return c.name.toLowerCase().contains(q) ||
              c.dialCode.toLowerCase().contains(q);
        })
        .toList(growable: false);
  }

  void _close() => Navigator.of(context).pop();

  void _save() => Navigator.of(context).pop(_selected);

  @override
  Widget build(BuildContext context) {
    final countries = _filteredCountries();

    return Dialog(
      backgroundColor: AppColors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 0.8.sh, minHeight: 0.6.sh),
        child: Padding(
          padding: EdgeInsets.all(AppDimens.lg_24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: _close,
                    borderRadius: BorderRadius.circular(999),
                    child: Padding(
                      padding: EdgeInsets.all(6.w),
                      child: Icon(
                        Icons.close_rounded,
                        size: 22.sp,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Select country',
                      textAlign: TextAlign.center,
                      style: publicSansTextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: 34.w),
                ],
              ),
              SizedBox(height: 14.h),
              _SearchField(controller: _searchController),
              SizedBox(height: 12.h),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14.r),
                  child: Material(
                    color: AppColors.grey.withAlpha(12),
                    child: countries.isEmpty
                        ? Center(
                            child: Text(
                              'No countries found',
                              style: publicSansTextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.grey,
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: countries.length,
                            separatorBuilder: (_, __) => Divider(
                              height: 1,
                              thickness: 1,
                              color: AppColors.grey.withAlpha(30),
                            ),
                            itemBuilder: (context, index) {
                              final c = countries[index];
                              final isSelected =
                                  c.dialCode == _selected.dialCode &&
                                  c.name == _selected.name;

                              return InkWell(
                                onTap: () => setState(() => _selected = c),
                                child: Container(
                                  color: isSelected
                                      ? AppColors.gradientMiddle.withAlpha(150)
                                      : Colors.transparent,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                    vertical: 12.h,
                                  ),
                                  child: Row(
                                    children: [
                                      if (c.flag.isNotEmpty) ...[
                                        Text(
                                          c.flag,
                                          style: publicSansTextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.black,
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                      ],
                                      Expanded(
                                        child: Text(
                                          c.name,
                                          style: publicSansTextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.black,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        c.dialCode,
                                        style: publicSansTextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              CustomButtonWidget(label: 'Save', onPressed: _save, radius: 28.r),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;

  const _SearchField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey.withAlpha(12),
        borderRadius: BorderRadius.circular(999.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      child: Row(
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            decoration: const BoxDecoration(
              color: AppColors.textPrimary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_rounded,
              size: 18.sp,
              color: AppColors.white,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.search,
              style: publicSansTextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
              decoration: InputDecoration(
                hintText: 'Search country',
                hintStyle: publicSansTextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}