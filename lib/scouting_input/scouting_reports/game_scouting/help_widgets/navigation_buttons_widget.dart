import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/game_scouting_page.dart";
import "package:trigon_scouting_app_2025/scouting_input/scouting_reports/game_scouting/game_scouting_report_provider.dart";

class NavigationButtonsWidget extends StatelessWidget {
  final GameScoutingPage currentPage;
  final double width;

  const NavigationButtonsWidget({
    super.key,
    required this.currentPage,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final reportProvider = context.watch<GameScoutingReportProvider>();
    final GameScoutingPage previousPage = currentPage.getPrevious();
    final GameScoutingPage nextPage;
    if (currentPage == GameScoutingPage.pregame && reportProvider.report.pregameReport.showedUp == false) {
      nextPage = GameScoutingPage.submit;
    } else {
      nextPage = currentPage.getNext();
    }

    return FittedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            currentPage.capitalizedName(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              NavigationButtonWidget(
                width: width,
                targetPage: previousPage,
                text: "← ${previousPage.capitalizedName()}",
              ),
              const SizedBox(width: 5),
              NavigationButtonWidget(
                width: width,
                targetPage: nextPage,
                text: "${nextPage.capitalizedName()} →",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NavigationButtonWidget extends StatelessWidget {
  final double width;
  final GameScoutingPage targetPage;
  final String text;

  const NavigationButtonWidget({
    super.key,
    required this.width,
    required this.targetPage,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final reportProvider = context.read<GameScoutingReportProvider>();

    return InkWell(
      onTap: () async {
        reportProvider.moveToPage(
          context,
          targetPage
        );
      },
      splashColor: Colors.indigo.withValues(alpha: 0.3),
      highlightColor: Colors.indigo.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: width,
        height: width * 0.5,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.grey,
          border: Border.all(color: Colors.indigo),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: FittedBox(
            child: Text(
              text,
              style: TextStyle(
                fontSize: (7) / (50 / width),
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
