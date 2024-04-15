import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:task_management/src/common_widgets/action_text_button.dart';
import 'package:task_management/src/common_widgets/alert_dialogs.dart';
import 'package:task_management/src/common_widgets/responsive_center.dart';
import 'package:task_management/src/common_widgets/responsive_scrollable_card.dart';
import 'package:task_management/src/constant/app_sizes.dart';
import 'package:task_management/src/features/authentication/data/auth_repository.dart';
import 'package:task_management/src/features/authentication/presentation/account/account/account_controller.dart';
import 'package:task_management/src/routing/app_router.dart';
import 'package:task_management/src/utils/async_value_ui.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      accountControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(accountControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: state.isLoading
            ? const CircularProgressIndicator()
            : const Text('Account'),
        actions: [
          ActionTextButton(
            text: 'Logout',
            onPressed: state.isLoading
                ? null
                : () async {
                    final logout = await showAlertDialog(
                      context: context,
                      title: 'Are you sure?',
                      cancelActionText: 'Cancel',
                      defaultActionText: 'Logout',
                    );
                    if (logout == true) {
                      ref.read(accountControllerProvider.notifier).signOut();
                      context.goNamed(AppRoute.signIn.name);
                    }
                  },
          ),
        ],
      ),
      body: const ResponsiveScrollableCard(
        child: UserDataTable(),
      ),
    );
  }
}

/// Simple user data table showing the uid and email
class UserDataTable extends ConsumerWidget {
  const UserDataTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = Theme.of(context).textTheme.titleSmall!;
    final user = ref.watch(authStateChangesProvider).value;
    return DataTable(
      columns: [
        DataColumn(
          label: Text(
            'Field',
            style: style,
          ),
        ),
        DataColumn(
          label: Text(
            'Value',
            style: style,
          ),
        ),
      ],
      rows: [
        _makeDataRow(
          'uid',
          user?.uid ?? '',
          style,
        ),
        _makeDataRow(
          'email',
          user?.email ?? '',
          style,
        ),
      ],
    );
  }

  DataRow _makeDataRow(String name, String value, TextStyle style) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            name,
            style: style,
          ),
        ),
        DataCell(
          Text(
            value,
            style: style,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
