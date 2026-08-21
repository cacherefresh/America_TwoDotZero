import 'package:flutter/widgets.dart';

/// An app package's self-description: everything the wrapper's nav needs to
/// list it, without the wrapper having to know anything about how the app
/// itself is built.
///
/// Each app package exports one of these (see `<package>/lib/<package>_config.dart`)
/// keyed by [id] in the wrapper's app registry. See `docs/nav-and-apps.md` for the
/// full picture of how these get discovered and ordered.
class AppMeta {
  /// Matches the id used in `flutter_app_wrapper/assets/list_of_apps_config.yaml`.
  final String id;

  final Widget icon;

  /// Short label: mobile slide-out panel row title, and the tooltip fallback.
  final String shortDescription;

  /// Longer sentence or two: shown as the desktop nav icon's hover tooltip.
  final String longDescription;

  final Widget page;

  const AppMeta({
    required this.id,
    required this.icon,
    required this.shortDescription,
    required this.longDescription,
    required this.page,
  });
}
