import 'package:flutter_test/flutter_test.dart';
import 'package:nilts/src/dart_version.dart';

void main() {
  test('Test regex match', () async {
    final stable = DartVersion.fromString(
      '3.0.5 (stable) (Mon Jun 12 18:31:49 2023 +0000) on "macos_arm64"',
    );
    expect(stable.major, equals(3));
    expect(stable.minor, equals(0));
    expect(stable.patch, equals(5));
    expect(stable.pre, isNull);
    expect(stable.prePatch, isNull);
    expect(stable.channel, equals(DartReleaseChannel.stable));

    final stableShort = DartVersion.fromString('0.1.0');
    expect(stableShort.major, equals(0));
    expect(stableShort.minor, equals(1));
    expect(stableShort.patch, equals(0));
    expect(stableShort.pre, isNull);
    expect(stableShort.prePatch, isNull);
    expect(stable.channel, equals(DartReleaseChannel.stable));

    final beta = DartVersion.fromString(
      '3.0.0-417.4.beta (beta) (Tue May 2 10:26:14 2023 +0000) on '
      '"macos_arm64"',
    );
    expect(beta.major, equals(3));
    expect(beta.minor, equals(0));
    expect(beta.patch, equals(0));
    expect(beta.pre, equals(417));
    expect(beta.prePatch, equals(4));
    expect(beta.channel, equals(DartReleaseChannel.beta));

    final betaShort = DartVersion.fromString('3.1.2-0.0.beta (beta) ');
    expect(betaShort.major, equals(3));
    expect(betaShort.minor, equals(1));
    expect(betaShort.patch, equals(2));
    expect(betaShort.pre, equals(0));
    expect(betaShort.prePatch, equals(0));
    expect(betaShort.channel, equals(DartReleaseChannel.beta));

    final dev = DartVersion.fromString(
      '3.0.0-417.0.dev (dev) (Thu Apr 6 09:10:27 2023 -0700) on "macos_arm64"',
    );
    expect(dev.major, equals(3));
    expect(dev.minor, equals(0));
    expect(dev.patch, equals(0));
    expect(dev.pre, equals(417));
    expect(dev.prePatch, equals(0));
    expect(dev.channel, equals(DartReleaseChannel.dev));

    final devShort = DartVersion.fromString(
      '0.0.0-0.1.dev (dev) (Thu Apr 6 09:10:27 2023 -0700)',
    );
    expect(devShort.major, equals(0));
    expect(devShort.minor, equals(0));
    expect(devShort.patch, equals(0));
    expect(devShort.pre, equals(0));
    expect(devShort.prePatch, equals(1));
    expect(devShort.channel, equals(DartReleaseChannel.dev));
  });

  test('Test invalid versioning', () async {
    expect(() => DartVersion.fromString('03.0.5'), throwsArgumentError);
    expect(() => DartVersion.fromString('0.00.5'), throwsArgumentError);
    expect(() => DartVersion.fromString('0.0.'), throwsArgumentError);
    expect(() => DartVersion.fromString('0.1'), throwsArgumentError);
    expect(() => DartVersion.fromString('0'), throwsArgumentError);
    expect(() => DartVersion.fromString(''), throwsArgumentError);
    expect(() => DartVersion.fromString('dart 3.0.5'), throwsArgumentError);
    expect(
      () => DartVersion.fromString('3.0.5-0.0.stable'),
      throwsArgumentError,
    );
    expect(
      () => DartVersion.fromString('3.0.5-0.0.'),
      throwsArgumentError,
    );
  });

  test('Test equals', () async {
    final stable = DartVersion.fromString('3.0.5');
    expect(stable, equals(DartVersion.fromString('3.0.5')));

    final beta = DartVersion.fromString('3.0.0-417.4.beta');
    expect(beta, equals(DartVersion.fromString('3.0.0-417.4.beta')));

    final dev = DartVersion.fromString('3.0.0-417.0.dev');
    expect(dev, equals(DartVersion.fromString('3.0.0-417.0.dev')));
  });

  test('Test compare (stable)', () async {
    final stable = DartVersion.fromString('3.1.5');
    final stableMajor = DartVersion.fromString('2.1.5');
    final stableMinor = DartVersion.fromString('3.0.5');
    final stablePatch = DartVersion.fromString('3.1.4');
    final stableFuture = DartVersion.fromString('4.1.5');
    final beta = DartVersion.fromString('3.0.0-417.4.beta');
    final betaFuture = DartVersion.fromString('3.2.0-417.4.beta');
    final dev = DartVersion.fromString('3.1.5-417.0.dev');
    final devFuture = DartVersion.fromString('3.2.0-417.0.dev');

    expect(stable > stableMajor, isTrue);
    expect(stable > stableMinor, isTrue);
    expect(stable > stablePatch, isTrue);
    expect(stableFuture > stable, isTrue);
    expect(stable > beta, isTrue);
    expect(betaFuture > stable, isTrue);
    expect(stable > dev, isTrue);
    expect(devFuture > stable, isTrue);
  });

  test('Test compare (beta)', () async {
    final stable = DartVersion.fromString('3.1.0');
    final stableFuture = DartVersion.fromString('3.2.1');
    final beta = DartVersion.fromString('3.1.1-417.4.beta');
    final betaMajor = DartVersion.fromString('2.1.1-417.4.beta');
    final betaMinor = DartVersion.fromString('3.0.1-417.4.beta');
    final betaPatch = DartVersion.fromString('3.1.0-417.4.beta');
    final betaPre = DartVersion.fromString('3.1.1-4.4.beta');
    final betaPrePatch = DartVersion.fromString('3.1.1-417.0.beta');
    final betaFuture = DartVersion.fromString('3.1.1-420.5.beta');
    final dev = DartVersion.fromString('3.0.0-417.0.dev');
    final devFuture = DartVersion.fromString('3.2.0-417.0.dev');

    expect(beta > stable, isTrue);
    expect(stableFuture > beta, isTrue);
    expect(beta > betaMajor, isTrue);
    expect(beta > betaMinor, isTrue);
    expect(beta > betaPatch, isTrue);
    expect(beta > betaPre, isTrue);
    expect(beta > betaPrePatch, isTrue);
    expect(betaFuture > betaPrePatch, isTrue);
    expect(beta > dev, isTrue);
    expect(devFuture > beta, isTrue);
  });

  test('Test compare (dev)', () async {
    final stable = DartVersion.fromString('3.0.5');
    final stableFuture = DartVersion.fromString('3.2.6');
    final beta = DartVersion.fromString('3.1.1-417.4.beta');
    final betaFuture = DartVersion.fromString('3.4.1-417.4.beta');
    final dev = DartVersion.fromString('3.2.5-417.1.dev');
    final devMajor = DartVersion.fromString('2.2.5-417.1.dev');
    final devMinor = DartVersion.fromString('3.1.5-417.1.dev');
    final devPatch = DartVersion.fromString('3.2.4-417.1.dev');
    final devPre = DartVersion.fromString('3.2.5-41.0.dev');
    final devPrePatch = DartVersion.fromString('3.2.5-417.0.dev');
    final devFuture = DartVersion.fromString('3.2.5-417.2.dev');

    expect(dev > stable, isTrue);
    expect(stableFuture > dev, isTrue);
    expect(dev > beta, isTrue);
    expect(betaFuture > dev, isTrue);
    expect(dev > devMajor, isTrue);
    expect(dev > devMinor, isTrue);
    expect(dev > devPatch, isTrue);
    expect(dev > devPre, isTrue);
    expect(dev > devPrePatch, isTrue);
    expect(devFuture > dev, isTrue);
  });
}
