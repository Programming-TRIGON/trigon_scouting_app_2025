import "dart:convert";
import "dart:io";

import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:open_filex/open_filex.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:path_provider/path_provider.dart";

class UpdateService {
  static const String repoOwner = "Programming-TRIGON";
  static const String repoName = "trigon_scouting_app_2025";

  static void checkForUpdate(BuildContext context) async {
    if (!Platform.isAndroid) return;

    if (await UpdateService.isUpdateAvailable()) {
      if (!context.mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Update Available"),
          content: const Text(
            "A new version is available. Do you want to update?",
          ),
          actions: [
            TextButton(
              child: const Text("Later"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("Update"),
              onPressed: () {
                Navigator.pop(context);
                UpdateService.downloadAndInstallApk(context);
              },
            ),
          ],
        ),
      );
    }
  }

  /// Get the current app version from pubspec.yaml
  static Future<String> getCurrentVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version; // e.g. "1.2.3"
  }

  /// Fetch the latest release tag from GitHub
  static Future<String?> getLatestVersion() async {
    final url = Uri.parse(
      "https://api.github.com/repos/$repoOwner/$repoName/releases/latest",
    );
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      return json["tag_name"]?.toString().replaceAll("v", "");
    }
    return null;
  }

  /// Fetch download URL of the APK from GitHub release assets
  static Future<String?> getApkDownloadUrl() async {
    final url = Uri.parse(
      "https://api.github.com/repos/$repoOwner/$repoName/releases/latest",
    );
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      final assets = json["assets"] as List<dynamic>;
      final apkAsset = assets.firstWhere(
        (a) => (a["name"] as String).endsWith(".apk"),
        orElse: () => null,
      );
      return apkAsset?["browser_download_url"];
    }
    return null;
  }

  /// Check if update is needed
  static Future<bool> isUpdateAvailable() async {
    final current = await getCurrentVersion();
    final latest = await getLatestVersion();
    if (latest == null) return false;

    return _isNewer(latest, current);
  }

  /// Compare semantic versions (e.g. "1.2.3" vs "1.2.4")
  static bool _isNewer(String latest, String current) {
    final latestParts = latest.split(".").map(int.parse).toList();
    final currentParts = current.split(".").map(int.parse).toList();

    for (int i = 0; i < latestParts.length; i++) {
      if (i >= currentParts.length || latestParts[i] > currentParts[i]) {
        return true;
      } else if (latestParts[i] < currentParts[i]) {
        return false;
      }
    }
    return false;
  }

  /// Download and install APK
  static Future<void> downloadAndInstallApk(BuildContext context) async {
    final apkUrl = await getApkDownloadUrl();
    if (apkUrl == null) return;

    final res = await http.get(Uri.parse(apkUrl));
    if (res.statusCode == 200) {
      final dir = await getTemporaryDirectory();
      final apkFile = File("${dir.path}/update.apk");
      await apkFile.writeAsBytes(res.bodyBytes);

      // Open the APK → triggers Android package installer
      await OpenFilex.open(apkFile.path);
    }
  }
}
