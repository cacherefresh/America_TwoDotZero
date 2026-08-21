import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:yaml/yaml.dart';
import 'package:core/core.dart';
import 'package:web_2/web_2_config.dart';
import 'package:we_the_people/we_the_people_config.dart';
import 'package:poe/poe_config.dart';
import 'package:abe/abe_config.dart';
import 'package:about/about_config.dart';
import 'package:game/game_config.dart';

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: Center(
        child: Text(
          'Select an app from the menu above! Have Fun!\n\n 🚧 UNDER CONSTRUCTION 🚧\n🦺not concepts of a plan 😂, \n🏗️ Everything is WELL DETAILED. ^_~ just not on the site yet. \n\n🏗️ I\'m a one man show🎶 at the moment ^_~\n----------------------------------- \n\n~I need funding, DONATIONS go a long way~\n\nDonate to:\n 💸 paypal.me/cacherefresh \n 💸 cashapp: @cacherefresh\n\n - 52% of all donations will go to resolving the actual problem. \nCould you IMAGINE AMERICA if every Political Candidate did this?\nWe would have every child fed, teachers paid well, AMAZING Infrastructure, the Border Walls of Troy, AND Free Healthcare, flying cars, etc etc... \n... but we got rallys, bumperstickers, ads, lawn ornaments of your favorite candidate and some half billion worth of political concerts.\n\n So I\'ll trendset and post receipts (give me time, I\'m human)',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

/// Home isn't an installed "app" -- it's the OS's own start screen, so
/// unlike the rest it isn't in the registry/YAML list, just always shown first.
final AppMeta homeMeta = AppMeta(
  id: 'home',
  icon: const Icon(Icons.home),
  shortDescription: 'Home',
  longDescription: 'Back to the start screen.',
  page: const _HomeView(),
);

/// Every installed app, keyed by the id used in `list_of_apps_config.yaml`.
/// This map is the one place the wrapper has to know each app package
/// exists -- Dart has no runtime plugin discovery. Which of these actually
/// show up, and in what order, is controlled entirely by the YAML file.
final Map<String, AppMeta> _registry = {
  web2Meta.id: web2Meta,
  weThePeopleMeta.id: weThePeopleMeta,
  poeMeta.id: poeMeta,
  abeMeta.id: abeMeta,
  aboutMeta.id: aboutMeta,
  gameMeta.id: gameMeta,
};

/// Reads `assets/list_of_apps_config.yaml` and resolves its ordered id list
/// against [_registry], returning the apps to show in the nav, in order.
/// See `docs/nav-and-apps.md` for how to add a new one.
Future<List<AppMeta>> loadInstalledApps() async {
  final yamlString =
      await rootBundle.loadString('assets/list_of_apps_config.yaml');
  final doc = loadYaml(yamlString) as YamlMap;
  final ids = (doc['apps'] as YamlList)
      .map((entry) => (entry as YamlMap)['id'] as String);

  return [
    for (final id in ids)
      _registry[id] ??
          (throw StateError(
              'list_of_apps_config.yaml references unknown app id "$id"')),
  ];
}
