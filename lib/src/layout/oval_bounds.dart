import 'dart:math';
import 'dart:ui';

/// Gives the x and y limits of the bounding box at a given rotation relative to
/// the center of the oval.
///
/// Algorithm sourced from Math StackExchange answer:
///   AUTHOR = {J. M. isn&#39;t a mathematician (https://math.stackexchange.com/users/498/j-m-isnt-a-mathematician)},
///   URL = {https://math.stackexchange.com/q/91304}
///
/// Dart implementation written by Rory Stephenson.
///
abstract class OvalBounds {
  static const halfPi = pi * 0.5;
  static const oneAndAHalfPi = pi * 1.5;
  static const twoPi = pi * 2;

  static Offset boundsAtRotation(
    double width,
    double height,
    double radians,
  ) {
    final halfWidthSquared = _halfWidthSquared(width);
    final halfHeightSquared = _halfHeightSquared(height);
    final cosThetaSquared = _cosThetaSquared(radians);
    final sinThetaSquared = _sinThetaSquared(radians);

    return Offset(
      _boundXImpl(
        halfWidthSquared,
        halfHeightSquared,
        cosThetaSquared,
        sinThetaSquared,
      ),
      _boundYImpl(
        halfWidthSquared,
        halfHeightSquared,
        cosThetaSquared,
        sinThetaSquared,
      ),
    );
  }

  static double boundX(
    double width,
    double height,
    double radians,
  ) {
    return _boundXImpl(
      _halfWidthSquared(width),
      _halfHeightSquared(height),
      _cosThetaSquared(radians),
      _sinThetaSquared(radians),
    );
  }

  static double boundY(
    double width,
    double height,
    double radians,
  ) {
    return _boundYImpl(
      _halfWidthSquared(width),
      _halfHeightSquared(height),
      _cosThetaSquared(radians),
      _sinThetaSquared(radians),
    );
  }

  static num _halfWidthSquared(double width) => pow(width / 2, 2);

  static num _halfHeightSquared(double height) => pow(height / 2, 2);

  static num _cosThetaSquared(double radians) => pow(cos(radians), 2);

  static num _sinThetaSquared(double radians) => pow(sin(radians), 2);

  static double _boundXImpl(
    num halfWidthSquared,
    num halfHeightSquared,
    num cosThetaSquared,
    num sinThetaSquared,
  ) {
    return sqrt(halfWidthSquared * cosThetaSquared +
        halfHeightSquared * sinThetaSquared);
  }

  static double _boundYImpl(
    num halfWidthSquared,
    num halfHeightSquared,
    num cosThetaSquared,
    num sinThetaSquared,
  ) {
    return sqrt(halfWidthSquared * sinThetaSquared +
        halfHeightSquared * cosThetaSquared);
  }
}
