import 'package:flutter/material.dart';
import 'package:flutter_sweet_shop_app_ui/core/theme/theme.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/bordered_container.dart';

import '../../../../core/theme/dimens.dart';

class SortAndFilterList extends StatefulWidget {
  final List<String> titles;
  final Function(String)? onChanged;

  const SortAndFilterList({
    super.key,
    required this.titles,
    this.onChanged,
  });

  @override
  State<SortAndFilterList> createState() => _SortAndFilterListState();
}

class _SortAndFilterListState extends State<SortAndFilterList> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final appColors = context.theme.appColors;

    return SizedBox(
      height: 34.0,
      child: ListView.builder(
        itemCount: widget.titles.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (final context, final index) {
          final bool isSelected = index == selectedIndex;

          return Padding(
            padding: const EdgeInsets.only(left: Dimens.largePadding),
            child: InkWell(
              onTap: () {
                setState(() => selectedIndex = index);
                widget.onChanged?.call(widget.titles[index]);
              },
              borderRadius: BorderRadius.circular(Dimens.corners),
              child: BorderedContainer(
                borderColor: isSelected ? appColors.primary : appColors.gray2,
                color: isSelected
                    ? appColors.primary.withValues(alpha: 0.15)
                    : null,
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.largePadding,
                ),
                child: Center(
                  child: Text(
                    widget.titles[index],
                    style: TextStyle(
                      color:
                          isSelected ? appColors.primary : appColors.black,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
