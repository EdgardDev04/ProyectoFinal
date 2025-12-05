import 'package:flutter/material.dart';
import 'package:flutter_sweet_shop_app_ui/core/theme/theme.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/shaded_container.dart';

import '../gen/assets.gen.dart';
import '../theme/dimens.dart';
import 'app_svg_viewer.dart';

class AppSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged; // <-- agregado

  const AppSearchBar({
    super.key,
    this.onChanged, // <-- agregado
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    return ShadedContainer(
      height: 50,
      child: Padding(
        padding: const EdgeInsets.only(top: Dimens.smallPadding),
        child: TextFormField(
          onChanged: onChanged, // <-- agregado
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: 'Buscar Postres',
            hintStyle: TextStyle(color: colors.gray2, fontSize: 13),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimens.mediumPadding,
              ),
              child: AppSvgViewer(Assets.icons.searchNormal1),
            ),
          ),
        ),
      ),
    );
  }
}
