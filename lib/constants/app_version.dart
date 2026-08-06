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

/// `2026-08-06 14:16`, in the reader's own timezone.
///
/// No UTC offset on purpose: the value is ALREADY local, so printing
/// the offset back to the reader is noise. It would only earn its
/// space somewhere with room to spare, like SeekSparks' status bar.
///
/// Empty when the build did not stamp a time, so callers can omit the
/// line rather than print a placeholder that looks like a bug.
String formatReleaseTimeShort() {
  if (kAppReleaseTime.isEmpty) return '';
  final parsed = DateTime.tryParse(kAppReleaseTime);
  if (parsed == null) return kAppReleaseTime;
  final l = parsed.toLocal();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${l.year}-${two(l.month)}-${two(l.day)} '
      '${two(l.hour)}:${two(l.minute)}';
}
