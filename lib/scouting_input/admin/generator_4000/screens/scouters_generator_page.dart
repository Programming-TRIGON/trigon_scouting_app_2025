import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/admin/generator_4000/generator_4000_provider.dart';
import 'package:trigon_scouting_app_2025/scouting_input/admin/generator_4000/screens/help_widgets/update_changes_widget.dart';
import 'package:trigon_scouting_app_2025/scouting_input/providers/scouters_data/scouter.dart';
import 'package:trigon_scouting_app_2025/scouting_input/providers/scouters_data/scouters_data_provider.dart';

import '../../../../authentication/user_data_provider.dart';

class ScoutersGeneratorPage extends StatelessWidget {
  const ScoutersGeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userDataProvider = context.watch<UserDataProvider>();
    final scoutersDataProvider = context.watch<ScoutersDataProvider>();
    final Generator4000Provider generator4000Provider = context
        .watch<Generator4000Provider>();

    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              createTopRowWidget(
                userDataProvider,
                scoutersDataProvider,
                generator4000Provider,
              ),
              SizedBox(height: 10),
              createScoutersDataTable(
                scoutersDataProvider,
                generator4000Provider,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget createTopRowWidget(
    UserDataProvider userDataProvider,
    ScoutersDataProvider scoutersDataProvider,
    Generator4000Provider generator4000Provider,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: SearchBar(
              onChanged: (_) => generator4000Provider.updateControllerValue(),
              hintText: "Search Users",
              controller:
                  generator4000Provider.scoutersGeneratorSearchController,
            ),
          ),
          SizedBox(width: 10),
          createAddUserWidget(userDataProvider, scoutersDataProvider),
          SizedBox(width: 10),
          UpdateChangesWidget(
            onUpdate: () => scoutersDataProvider.sendScoutersToFirebase(),
            onDiscard: () => scoutersDataProvider.discardScoutersChanges(),
            isUpdateAvailable: scoutersDataProvider.doesHaveUnsavedScoutersChanges,
          ),
        ],
      ),
    );
  }

  Widget createUploadingDataWidget(ScoutersDataProvider scoutersDataProvider) {
    return FloatingActionButton(
      onPressed: () {
        scoutersDataProvider.sendScoutersToFirebase();
      },
      shape: CircleBorder(),
      tooltip: "חלל אותי",
      child: const Icon(Icons.upload),
    );
  }

  Widget createAddUserWidget(
    UserDataProvider userDataProvider,
    ScoutersDataProvider scoutersDataProvider,
  ) {
    return MenuAnchor(
      builder: (context, controller, child) {
        return FloatingActionButton(
          onPressed: () {
            controller.open();
          },
          shape: CircleBorder(),
          tooltip: "Add Scouter",
          child: const Icon(Icons.add),
        );
      },
      menuChildren:
          userDataProvider.allUsers
              ?.where(
                (user) =>
                    scoutersDataProvider.scouters?.any(
                      (scouter) => scouter.uid == user.uid,
                    ) !=
                    true,
              )
              .map(
                (user) => MenuItemButton(
                  child: Text(user.name),
                  onPressed: () {
                    scoutersDataProvider.addUserWithoutSending(user);
                  },
                ),
              )
              .toList() ??
          [],
    );
  }

  Widget createScoutersDataTable(
    ScoutersDataProvider scoutersDataProvider,
    Generator4000Provider generator4000Provider,
  ) {
    return Container(
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: DataTable(
          columnSpacing: 0,
          columns: [
            DataColumn(
              label: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text("Action"),
              ),
            ),
            DataColumn(
              label: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Center(child: Text("Name")),
              ),
            ),
            DataColumn(
              label: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text("Game"),
              ),
            ),
            DataColumn(
              label: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text("Super"),
              ),
            ),
            DataColumn(
              label: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text("Picture"),
              ),
            ),
            DataColumn(
              label: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text("Day 1"),
              ),
            ),
            DataColumn(
              label: Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Text("Day 2"),
              ),
            ),
          ],
          rows:
              scoutersDataProvider.scouters?.reversed
                  .where(
                    (scouter) => scouter.name.toLowerCase().contains(
                      generator4000Provider.scoutersGeneratorSearchController.text
                          .toLowerCase(),
                    ),
                  )
                  .map(
                    (scouter) =>
                        createScouterDataRow(scouter, scoutersDataProvider),
                  )
                  .toList() ??
              [],
        ),
      ),
    );
  }

  DataRow createScouterDataRow(
    Scouter scouter,
    ScoutersDataProvider scoutersDataProvider,
  ) {
    return DataRow(
      key: ValueKey(scouter.uid),
      cells: [
        DataCell(
          Center(
            child: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              tooltip: "Remove Scouter",
              onPressed: () {
                scoutersDataProvider.removeScouterWithoutSending(scouter);
              },
            ),
          ),
        ),
        DataCell(
          Center(
            child: Text(
              scouter.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Checkbox(
              value: scouter.isGameScouter,
              onChanged: (value) {
                scouter.isGameScouter = value ?? false;
                scoutersDataProvider.notifyUpdate(doesUpdateScouters: true);
              },
            ),
          ),
        ),
        DataCell(
          Center(
            child: Checkbox(
              value: scouter.isSuperScouter,
              onChanged: (value) {
                scouter.isSuperScouter = value ?? false;
                scoutersDataProvider.notifyUpdate(doesUpdateScouters: true);
              },
            ),
          ),
        ),
        DataCell(
          Center(
            child: Checkbox(
              value: scouter.isPictureScouter,
              onChanged: (value) {
                scouter.isPictureScouter = value ?? false;
                scoutersDataProvider.notifyUpdate(doesUpdateScouters: true);
              },
            ),
          ),
        ),
        DataCell(
          Center(
            child: Checkbox(
              value: scouter.doesComeToDay1,
              onChanged: (value) {
                scouter.doesComeToDay1 = value ?? false;
                scoutersDataProvider.notifyUpdate(doesUpdateScouters: true);
              },
            ),
          ),
        ),
        DataCell(
          Center(
            child: Checkbox(
              value: scouter.doesComeToDay2,
              onChanged: (value) {
                scouter.doesComeToDay2 = value ?? false;
                scoutersDataProvider.notifyUpdate(doesUpdateScouters: true);
              },
            ),
          ),
        ),
      ],
    );
  }
}
