import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sweet_shop_app_ui/core/theme/theme.dart';
import 'package:flutter_sweet_shop_app_ui/core/utils/check_theme_status.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/app_scaffold.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/bordered_container.dart';
import 'package:flutter_sweet_shop_app_ui/core/widgets/general_app_bar.dart';

import '../../../../../core/gen/assets.gen.dart';
import '../../../../../core/theme/dimens.dart';
import '../../../../../core/widgets/app_list_tile.dart';
import '../../../../../core/widgets/app_svg_viewer.dart';
import '../../../../../core/widgets/user_profile_image_widget.dart';
import '../../bloc/theme_cubit.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = context.theme.appColors;
    final appTypography = context.theme.appTypography;
    return AppScaffold(
      appBar: GeneralAppBar(title: 'Perfil', showBackIcon: false),
      body: SingleChildScrollView(
        child: Column(
          spacing: Dimens.largePadding,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BorderedContainer(
              child: ListTile(
                leading: UserProfileImageWidget(width: 56, height: 56),
                title: Text('Edgard Mendez', style: appTypography.bodyLarge),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: Dimens.padding),
                  child: Text(
                    'Edgard20231162@gmail.com',
                    style: appTypography.bodySmall.copyWith(
                      color:
                          checkDarkMode(context)
                              ? appColors.white
                              : appColors.gray4,
                    ),
                  ),
                ),
                trailing: AppSvgViewer(
                  Assets.icons.user,
                  width: 19,
                  color:
                      checkDarkMode(context)
                          ? appColors.white
                          : appColors.gray4,
                ),
              ),
            ),
            Text(
              'General',
              style: appTypography.bodyLarge.copyWith(fontSize: 20),
            ),
            BorderedContainer(
              child: Column(
                spacing: Dimens.largePadding,
                children: [

                  AppListTile(
                    onTap: () {
                      context.read<ThemeCubit>().toggleTheme();
                    },
                    title: 'Tema',
                    leadingIconPath: Assets.icons.moon,
                    trailing: Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        value: checkDarkMode(context),
                        onChanged: (final value) {
                          context.read<ThemeCubit>().toggleTheme();
                        },
                        activeTrackColor: appColors.primary,
                      ),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
