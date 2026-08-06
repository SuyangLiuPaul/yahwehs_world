/// 2026-08-06: build identity for News Insights.
///
/// Mirrors the pattern SeekSparks uses, deliberately — the two apps are
/// maintained together and a second, different scheme would be one more
/// thing to remember.
///
/// Both values are injected at build time by `tools/release_web.sh`.
/// The fallbacks only apply to a build that skipped the script, which
/// in practice means local `flutter run`.
library;

/// Semantic version, injected from pubspec by the release script.
const String kAppVersion = String.fromEnvironment(
  'APP_VERSION',
  defaultValue: '1.1.6',
);

/// ISO-8601 UTC build time. Rendered in the READER's timezone, never
/// the build machine's — "updated 2 hours ago" is only useful if it is
/// two hours ago where the reader is.
const String kAppReleaseTime = String.fromEnvironment(
  'APP_RELEASE_TIME',
  defaultValue: '',
);

/// `2026-08-06 21:14 UTC+10`, in local time. Empty when the build did
/// not stamp one, so callers can omit the line rather than print a
/// placeholder that looks like a bug.
String formatReleaseTimeLocal() {
  if (kAppReleaseTime.isEmpty) return '';
  final parsed = DateTime.tryParse(kAppReleaseTime);
  if (parsed == null) return kAppReleaseTime;
  final local = parsed.toLocal();
  String two(int n) => n.toString().padLeft(2, '0');
  final off = local.timeZoneOffset;
  final sign = off.isNegative ? '-' : '+';
  final hours = off.inHours.abs();
  final mins = off.inMinutes.abs() % 60;
  final offset =
      'UTC$sign$hours${mins == 0 ? '' : ':${two(mins)}'}';
  return '${local.year}-${two(local.month)}-${two(local.day)} '
      '${two(local.hour)}:${two(local.minute)} $offset';
}
