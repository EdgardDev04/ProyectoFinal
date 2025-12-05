import 'package:flutter/material.dart';
import 'package:flutter_sweet_shop_app_ui/core/theme/theme.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/app_divider.dart';
import 'package:flutter_sweet_shop_app_ui/features/home_feature/presentation/widgets/filters_title.dart';
import 'package:flutter_sweet_shop_app_ui/features/home_feature/repo/filter_repository.dart';

import '../../../../core/theme/dimens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/general_app_bar.dart';
import '../../../../data/sample_data.dart';
import '../widgets/sort_and_filter_list.dart';

class SortAndFilterScreen extends StatefulWidget {
  const SortAndFilterScreen({super.key});

  @override
  State<SortAndFilterScreen> createState() => _SortAndFilterScreenState();
}

class _SortAndFilterScreenState extends State<SortAndFilterScreen> {
  String _selectedSort = 'Mejor Puntuación';
  String _selectedCategory = 'Todos';

  final repo = FilterRepository();

  @override
  void initState() {
    super.initState();
    _loadFilters();
  }

  Future<void> _loadFilters() async {
    final data = await repo.loadFilters();
    setState(() {
      _selectedSort = data['sort']!;
      _selectedCategory = data['category']!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appTypography = context.theme.appTypography;

    return AppScaffold(
      appBar: GeneralAppBar(title: 'Filtro'),
      padding: EdgeInsets.zero,
      body: SingleChildScrollView(
        child: Column(
          spacing: Dimens.largePadding,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox.shrink(),

            FiltersTitle(title: 'Sort'),

            SortAndFilterList(
              titles: [
                'Mejor Puntuación',
                'Menor Puntuación',
                'Màs Baratos',
              ],
              onChanged: (value) => _selectedSort = value,
            ),

            AppDivider(
              indent: Dimens.largePadding,
              endIndent: Dimens.largePadding,
            ),

            FiltersTitle(title: 'Categorias'),

            SortAndFilterList(
              titles: ['Todos', ...titlesOfCategories],
              onChanged: (value) => _selectedCategory = value,
            ),

            AppDivider(
              indent: Dimens.largePadding,
              endIndent: Dimens.largePadding,
            ),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: Dimens.largePadding,
          right: Dimens.largePadding,
          bottom: Dimens.padding,
        ),
        child: AppButton(
          onPressed: () async {
            await repo.saveFilters(_selectedSort, _selectedCategory);

            if (mounted) {
              Navigator.pop(context, {
                'sort': _selectedSort,
                'category': _selectedCategory
              });
            }
          },
          title: 'Aplicar filtros',
          textStyle: appTypography.bodyLarge,
          borderRadius: Dimens.corners,
          margin: EdgeInsets.symmetric(vertical: Dimens.largePadding),
        ),
      ),
    );
  }
}
