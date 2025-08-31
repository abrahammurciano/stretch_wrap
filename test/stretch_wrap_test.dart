import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stretch_wrap/stretch_wrap.dart';

class WrapContainer extends StatelessWidget {
  final double maxWidth;
  final Widget child;

  const WrapContainer({super.key, required this.maxWidth, required this.child});

  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      minWidth: 0,
      maxWidth: maxWidth,
      alignment: Alignment.topLeft,
      child: child,
    );
  }
}

class WrapChild extends StatelessWidget {
  final double? width;
  final double? height;

  const WrapChild({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) => SizedBox(width: width, height: height);
}

void main() {
  group('StretchWrap', () {
    testWidgets('renders children with correct spacing', (tester) async {
      await tester.pumpWidget(
        const WrapContainer(
          maxWidth: 1000,
          child: StretchWrap(
            spacing: 10,
            children: [
              WrapChild(width: 100, height: 50),
              WrapChild(width: 100, height: 50),
              WrapChild(width: 100, height: 50),
            ],
          ),
        ),
      );

      final items = find.descendant(of: find.byType(StretchWrap), matching: find.byType(WrapChild));
      expect(tester.getTopLeft(items.first), const Offset(0, 0));
      expect(tester.getTopLeft(items.at(1)), const Offset(110, 0));
      expect(tester.getTopLeft(items.at(2)), const Offset(220, 0));
    });

    testWidgets('wraps to next line when exceeding width', (tester) async {
      await tester.pumpWidget(
        WrapContainer(
          maxWidth: 250,
          child: StretchWrap(
            spacing: 10,
            runSpacing: 15,
            children: [
              WrapChild(width: 100, height: 50),
              WrapChild(width: 100, height: 50),
              WrapChild(width: 100, height: 50),
            ],
          ),
        ),
      );

      final items = find.descendant(of: find.byType(StretchWrap), matching: find.byType(WrapChild));
      expect(tester.getTopLeft(items.first), const Offset(0, 0));
      expect(tester.getTopLeft(items.at(1)), const Offset(110, 0));
      expect(tester.getTopLeft(items.at(2)), const Offset(0, 65));
    });

    testWidgets('stretches single flexible child', (tester) async {
      await tester.pumpWidget(
        const WrapContainer(
          maxWidth: 500,
          child: StretchWrap(
            spacing: 10,
            children: [
              WrapChild(width: 100, height: 50),
              Stretch(child: WrapChild(width: 0, height: 50)),
              WrapChild(width: 100, height: 50),
            ],
          ),
        ),
      );

      final actualSize = tester.getSize(
        find.descendant(of: find.byType(Stretch), matching: find.byType(WrapChild)),
      );
      final expectedWidth = 500 - (2 * 100) - (2 * 10);
      expect(actualSize.width, expectedWidth);
    });

    testWidgets('distributes space proportionally with multiple stretched children', (tester) async {
      await tester.pumpWidget(
        const WrapContainer(
          maxWidth: 500,
          child: StretchWrap(
            spacing: 10,
            children: [
              WrapChild(width: 100, height: 50),
              Stretch(flex: 1, child: WrapChild(height: 50)),
              Stretch(flex: 2, child: WrapChild(height: 50)),
            ],
          ),
        ),
      );

      final stretched = find.byType(Stretch);
      final firstWidth = tester.getSize(stretched.first).width;
      final secondWidth = tester.getSize(stretched.last).width;

      final available = 500 - 100 - (2 * 10);
      final firstExpected = available / 3;
      final secondExpected = 2 * firstExpected;
      expect(firstWidth, closeTo(firstExpected, 1));
      expect(secondWidth, closeTo(secondExpected, 1));
    });

    testWidgets('handles negative spacing values', (tester) async {
      await tester.pumpWidget(
        const WrapContainer(
          maxWidth: 500,
          child: StretchWrap(
            spacing: -10,
            children: [
              WrapChild(width: 100, height: 50),
              WrapChild(width: 100, height: 50),
            ],
          ),
        ),
      );

      var items = find.byType(WrapChild);
      expect(tester.getTopLeft(items.first), const Offset(0, 0));
      expect(tester.getTopLeft(items.last), const Offset(90, 0));
    });

    testWidgets('supports fractional flex values', (tester) async {
      await tester.pumpWidget(
        const WrapContainer(
          maxWidth: 500,
          child: StretchWrap(
            spacing: 10,
            children: [
              WrapChild(width: 100, height: 50),
              Stretch(flex: 0.5, child: WrapChild(height: 50)),
              Stretch(flex: 1.5, child: WrapChild(height: 50)),
            ],
          ),
        ),
      );

      final stretched = find.byType(Stretch);
      final firstWidth = tester.getSize(stretched.first).width;
      final secondWidth = tester.getSize(stretched.last).width;

      final available = 500 - 100 - (2 * 10);
      final totalFlex = 0.5 + 1.5;
      final firstExpected = available * (0.5 / totalFlex);
      final secondExpected = available * (1.5 / totalFlex);
      expect(firstWidth, closeTo(firstExpected, 1));
      expect(secondWidth, closeTo(secondExpected, 1));
    });

    testWidgets('distributes space correctly with mixed integer and fractional flex values', (tester) async {
      await tester.pumpWidget(
        const WrapContainer(
          maxWidth: 600,
          child: StretchWrap(
            spacing: 5,
            children: [
              WrapChild(width: 100, height: 50),
              Stretch(flex: 1, child: WrapChild(height: 50)),
              Stretch(flex: 2.5, child: WrapChild(height: 50)),
              Stretch(flex: 0.25, child: WrapChild(height: 50)),
            ],
          ),
        ),
      );

      final stretched = find.byType(Stretch);
      final firstWidth = tester.getSize(stretched.at(0)).width;
      final secondWidth = tester.getSize(stretched.at(1)).width;
      final thirdWidth = tester.getSize(stretched.at(2)).width;

      final available = 600 - 100 - (3 * 5);
      final totalFlex = 1.0 + 2.5 + 0.25;
      final firstExpected = available * (1.0 / totalFlex);
      final secondExpected = available * (2.5 / totalFlex);
      final thirdExpected = available * (0.25 / totalFlex);
      
      expect(firstWidth, closeTo(firstExpected, 1));
      expect(secondWidth, closeTo(secondExpected, 1));
      expect(thirdWidth, closeTo(thirdExpected, 1));
    });

    testWidgets('handles very small fractional flex values', (tester) async {
      await tester.pumpWidget(
        const WrapContainer(
          maxWidth: 400,
          child: StretchWrap(
            spacing: 0,
            children: [
              WrapChild(width: 100, height: 50),
              Stretch(flex: 0.1, child: WrapChild(height: 50)),
              Stretch(flex: 0.9, child: WrapChild(height: 50)),
            ],
          ),
        ),
      );

      final stretched = find.byType(Stretch);
      final firstWidth = tester.getSize(stretched.first).width;
      final secondWidth = tester.getSize(stretched.last).width;

      final available = 400 - 100;
      final totalFlex = 0.1 + 0.9;
      final firstExpected = available * (0.1 / totalFlex);
      final secondExpected = available * (0.9 / totalFlex);
      
      expect(firstWidth, closeTo(firstExpected, 1));
      expect(secondWidth, closeTo(secondExpected, 1));
      expect(secondWidth / firstWidth, closeTo(9.0, 0.1));
    });

    testWidgets('maintains precision with complex fractional flex ratios', (tester) async {
      await tester.pumpWidget(
        const WrapContainer(
          maxWidth: 1000,
          child: StretchWrap(
            spacing: 20,
            children: [
              WrapChild(width: 200, height: 50),
              Stretch(flex: 1.33, child: WrapChild(height: 50)),
              Stretch(flex: 2.67, child: WrapChild(height: 50)),
              Stretch(flex: 1.0, child: WrapChild(height: 50)),
            ],
          ),
        ),
      );

      final stretched = find.byType(Stretch);
      final firstWidth = tester.getSize(stretched.at(0)).width;
      final secondWidth = tester.getSize(stretched.at(1)).width;
      final thirdWidth = tester.getSize(stretched.at(2)).width;

      final available = 1000 - 200 - (3 * 20);
      final totalFlex = 1.33 + 2.67 + 1.0;
      final firstExpected = available * (1.33 / totalFlex);
      final secondExpected = available * (2.67 / totalFlex);
      final thirdExpected = available * (1.0 / totalFlex);
      
      expect(firstWidth, closeTo(firstExpected, 1));
      expect(secondWidth, closeTo(secondExpected, 1));
      expect(thirdWidth, closeTo(thirdExpected, 1));
      
      expect(secondWidth / firstWidth, closeTo(2.67 / 1.33, 0.05));
    });

    testWidgets('works with zero flex value alongside fractional flex', (tester) async {
      await tester.pumpWidget(
        const WrapContainer(
          maxWidth: 500,
          child: StretchWrap(
            spacing: 10,
            children: [
              WrapChild(width: 100, height: 50),
              Stretch(flex: 0.0, child: WrapChild(width: 50, height: 50)),
              Stretch(flex: 1.5, child: WrapChild(height: 50)),
              Stretch(flex: 0.5, child: WrapChild(height: 50)),
            ],
          ),
        ),
      );

      final stretched = find.byType(Stretch);
      final zeroFlexWidth = tester.getSize(stretched.at(0)).width;
      final firstWidth = tester.getSize(stretched.at(1)).width;
      final secondWidth = tester.getSize(stretched.at(2)).width;

      expect(zeroFlexWidth, 50.0);
      
      final available = 500 - 100 - 50 - (3 * 10);
      final totalFlex = 1.5 + 0.5;
      final firstExpected = available * (1.5 / totalFlex);
      final secondExpected = available * (0.5 / totalFlex);
      
      expect(firstWidth, closeTo(firstExpected, 1));
      expect(secondWidth, closeTo(secondExpected, 1));
      expect(firstWidth / secondWidth, closeTo(3.0, 0.1));
    });

    testWidgets('accepts both integer and double flex values in constructor', (tester) async {
      await tester.pumpWidget(
        const WrapContainer(
          maxWidth: 500,
          child: StretchWrap(
            spacing: 0,
            children: [
              Stretch(flex: 1, child: WrapChild(height: 50)),
              Stretch(flex: 2.5, child: WrapChild(height: 50)),
              Stretch(flex: 3, child: WrapChild(height: 50)),
            ],
          ),
        ),
      );

      final stretched = find.byType(Stretch);
      expect(stretched.evaluate().length, 3);
      
      final firstWidth = tester.getSize(stretched.at(0)).width;
      final secondWidth = tester.getSize(stretched.at(1)).width;
      final thirdWidth = tester.getSize(stretched.at(2)).width;

      final available = 500.0;
      final totalFlex = 1.0 + 2.5 + 3.0;
      final firstExpected = available * (1.0 / totalFlex);
      final secondExpected = available * (2.5 / totalFlex);
      final thirdExpected = available * (3.0 / totalFlex);
      
      expect(firstWidth, closeTo(firstExpected, 1));
      expect(secondWidth, closeTo(secondExpected, 1));
      expect(thirdWidth, closeTo(thirdExpected, 1));
    });
  });
}
