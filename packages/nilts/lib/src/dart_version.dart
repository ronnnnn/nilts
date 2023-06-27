import 'package:meta/meta.dart';

/// 3.0.0-417.0.dev (dev) (Thu Apr 6 09:10:27 2023 -0700) on "macos_arm64"
/// 3.0.0-417.4.beta (beta) (Tue May 2 10:26:14 2023 +0000) on "macos_arm64"
/// 3.0.5 (stable) (Mon Jun 12 18:31:49 2023 +0000) on "macos_arm64"
@immutable
class DartVersion {
  const DartVersion({
    required this.major,
    required this.minor,
    required this.patch,
    this.pre,
    this.prePatch,
    this.channel,
  });

  factory DartVersion.fromString(String version) {
    final pattern = RegExp(
      r'^(?<major>0|[1-9]\d*)\.(?<minor>0|[1-9]\d*)\.(?<patch>0|[1-9]\d*)(-(?<pre>0|[1-9]\d*)\.(?<prePatch>0|[1-9]\d*)\.(?<channel>(beta|dev)?))?.*$',
    );
    final match = pattern.firstMatch(version);
    if (match == null) {
      throw ArgumentError('Invalid Dart versioning string');
    }

    final major = match.namedGroup('major');
    final minor = match.namedGroup('minor');
    final patch = match.namedGroup('patch');
    final pre = match.namedGroup('pre');
    final prePatch = match.namedGroup('prePatch');
    final channel = match.namedGroup('channel');
    if (major == null || minor == null || patch == null) {
      throw ArgumentError('Invalid Dart versioning string');
    }
    if (channel != null && channel != 'beta' && channel != 'dev') {
      throw ArgumentError('Invalid Dart versioning string');
    }
    if (channel != null && (pre == null || prePatch == null)) {
      throw ArgumentError('Invalid Dart versioning string');
    }
    if (channel == null && (pre != null || prePatch != null)) {
      throw ArgumentError('Invalid Dart versioning string');
    }

    return DartVersion(
      major: int.parse(major),
      minor: int.parse(minor),
      patch: int.parse(patch),
      pre: pre == null ? null : int.parse(pre),
      prePatch: prePatch == null ? null : int.parse(prePatch),
      channel: channel,
    );
  }

  final int major;
  final int minor;
  final int patch;
  final int? pre;
  final int? prePatch;
  final String? channel;

  bool get isStable => channel == null;

  bool get isBeta => channel == 'beta';

  bool get isDev => channel == 'dev';

  int compareTo(DartVersion other) {
    if (major != other.major) {
      return major.compareTo(other.major);
    }
    if (minor != other.minor) {
      return minor.compareTo(other.minor);
    }
    if (patch != other.patch) {
      return patch.compareTo(other.patch);
    }
    if (channel != other.channel) {
      if (channel == null) {
        return 1;
      } else if (channel == 'beta') {
        if (other.channel == null) {
          return -1;
        } else if (other.channel == 'dev') {
          return 1;
        }
      } else if (channel == 'dev') {
        if (other.channel == null) {
          return -1;
        } else if (other.channel == 'beta') {
          return -1;
        }
      }
    }
    if (pre != other.pre) {
      return pre!.compareTo(other.pre!);
    }
    if (prePatch != other.prePatch) {
      return prePatch!.compareTo(other.prePatch!);
    }
    return 0;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DartVersion &&
          runtimeType == other.runtimeType &&
          major == other.major &&
          minor == other.minor &&
          patch == other.patch &&
          pre == other.pre &&
          prePatch == other.prePatch &&
          channel == other.channel;

  @override
  int get hashCode =>
      major.hashCode ^
      minor.hashCode ^
      patch.hashCode ^
      patch.hashCode ^
      prePatch.hashCode ^
      channel.hashCode;

  bool operator <(DartVersion other) => compareTo(other) < 0;

  bool operator <=(DartVersion other) => compareTo(other) <= 0;

  bool operator >(DartVersion other) => compareTo(other) > 0;

  bool operator >=(DartVersion other) => compareTo(other) >= 0;

  @override
  String toString() {
    final mainVersion = '$major.$minor.$patch';
    if (channel == null) return mainVersion;

    return '$mainVersion-$pre.$prePatch.$channel';
  }
}
