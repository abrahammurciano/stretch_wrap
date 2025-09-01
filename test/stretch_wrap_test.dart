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

class FlexHeightChild extends StatelessWidget {
  final double desiredWidth;
  final double widthThreshold;
  final double height1;
  final double height2;

  const FlexHeightChild({
    required this.desiredWidth,
    required this.widthThreshold,
    required this.height1,
    required this.height2,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: desiredWidth,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(height: (constraints.maxWidth < widthThreshold) ? height1 : height2, width: desiredWidth);
        },
      ),
    );
  }
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

    testWidgets('updates run height when stretched children change height', (tester) async {
      await tester.pumpWidget(
        WrapContainer(
          maxWidth: 500,
          child: StretchWrap(
            children: [
              Stretch(child: FlexHeightChild(desiredWidth: 400, widthThreshold: 450, height1: 100, height2: 30)),
              WrapChild(width: 400, height: 50),
            ],
          ),
        ),
      );

      final flexChild = find.byType(FlexHeightChild);
      final wrapChild = find.byType(WrapChild);

      expect(tester.getSize(flexChild).height, 30);
      expect(tester.getSize(flexChild).width, 500);
      expect(tester.getTopLeft(wrapChild).dy, 30);
    });

    group('RunAlignment', () {
      testWidgets('aligns run to center with RunAlignment.center', (tester) async {
        await tester.pumpWidget(
          const WrapContainer(
            maxWidth: 500,
            child: StretchWrap(
              spacing: 10,
              alignment: RunAlignment.center,
              children: [
                WrapChild(width: 100, height: 50),
                WrapChild(width: 150, height: 50),
              ],
            ),
          ),
        );

        final items = find.descendant(of: find.byType(StretchWrap), matching: find.byType(WrapChild));
        // Total used: 100 + 10 + 150 = 260
        // Remaining: 500 - 260 = 240
        // Offset: 240 / 2 = 120
        expect(tester.getTopLeft(items.first), const Offset(120, 0));
        expect(tester.getTopLeft(items.last), const Offset(230, 0));
      });

      testWidgets('aligns run to end with RunAlignment.end', (tester) async {
        await tester.pumpWidget(
          const WrapContainer(
            maxWidth: 500,
            child: StretchWrap(
              spacing: 10,
              alignment: RunAlignment.end,
              children: [
                WrapChild(width: 100, height: 50),
                WrapChild(width: 150, height: 50),
              ],
            ),
          ),
        );

        final items = find.descendant(of: find.byType(StretchWrap), matching: find.byType(WrapChild));
        // Total used: 100 + 10 + 150 = 260
        // Remaining: 500 - 260 = 240
        // Offset: 240
        expect(tester.getTopLeft(items.first), const Offset(240, 0));
        expect(tester.getTopLeft(items.last), const Offset(350, 0));
      });

      testWidgets('distributes space between children with RunAlignment.spaceBetween', (tester) async {
        await tester.pumpWidget(
          const WrapContainer(
            maxWidth: 500,
            child: StretchWrap(
              spacing: 10,
              alignment: RunAlignment.spaceBetween,
              children: [
                WrapChild(width: 100, height: 50),
                WrapChild(width: 150, height: 50),
                WrapChild(width: 80, height: 50),
              ],
            ),
          ),
        );

        final items = find.descendant(of: find.byType(StretchWrap), matching: find.byType(WrapChild));
        // Total used: 100 + 10 + 150 + 10 + 80 = 350
        // Remaining: 500 - 350 = 150
        // Space between 3 items: 150 / 2 = 75
        // Final spacing between items: 10 (original) + 75 = 85
        expect(tester.getTopLeft(items.at(0)), const Offset(0, 0)); // First at start
        expect(tester.getTopLeft(items.at(1)), const Offset(185, 0)); // 100 + 85 = 185
        expect(tester.getTopLeft(items.at(2)), const Offset(420, 0)); // 185 + 150 + 85 = 420
      });

      testWidgets('spaceBetween with single child behaves like start alignment', (tester) async {
        await tester.pumpWidget(
          const WrapContainer(
            maxWidth: 500,
            child: StretchWrap(
              spacing: 10,
              alignment: RunAlignment.spaceBetween,
              children: [
                WrapChild(width: 100, height: 50),
              ],
            ),
          ),
        );

        final item = find.descendant(of: find.byType(StretchWrap), matching: find.byType(WrapChild));
        // Single child should be at the start
        expect(tester.getTopLeft(item), const Offset(0, 0));
      });

      testWidgets('distributes space around children with RunAlignment.spaceAround', (tester) async {
        await tester.pumpWidget(
          const WrapContainer(
            maxWidth: 500,
            child: StretchWrap(
              spacing: 10,
              alignment: RunAlignment.spaceAround,
              children: [
                WrapChild(width: 100, height: 50),
                WrapChild(width: 150, height: 50),
                WrapChild(width: 80, height: 50),
              ],
            ),
          ),
        );

        final items = find.descendant(of: find.byType(StretchWrap), matching: find.byType(WrapChild));
        // Total used: 100 + 10 + 150 + 10 + 80 = 350
        // Remaining: 500 - 350 = 150
        // Space around each of 3 items: 150 / 3 = 50 per item (25 on each side)
        // Final spacing between items: 10 (original) + 50 = 60
        // Start offset: 25 (half of space around first item)
        expect(tester.getTopLeft(items.at(0)), const Offset(25, 0)); // Start with half-space
        expect(tester.getTopLeft(items.at(1)), const Offset(185, 0)); // 25 + 100 + 60 = 185
        expect(tester.getTopLeft(items.at(2)), const Offset(395, 0)); // 185 + 150 + 60 = 395
      });

      testWidgets('spaceAround with single child centers it', (tester) async {
        await tester.pumpWidget(
          const WrapContainer(
            maxWidth: 500,
            child: StretchWrap(
              spacing: 10,
              alignment: RunAlignment.spaceAround,
              children: [
                WrapChild(width: 100, height: 50),
              ],
            ),
          ),
        );

        final item = find.descendant(of: find.byType(StretchWrap), matching: find.byType(WrapChild));
        // Single child gets all remaining space divided equally on both sides
        // Remaining: 500 - 100 = 400
        // Half space on each side: 400 / 2 = 200
        expect(tester.getTopLeft(item), const Offset(200, 0));
      });

      testWidgets('ignores alignment when run has stretch children', (tester) async {
        await tester.pumpWidget(
          const WrapContainer(
            maxWidth: 500,
            child: StretchWrap(
              spacing: 10,
              alignment: RunAlignment.center,
              children: [
                WrapChild(width: 100, height: 50),
                Stretch(child: WrapChild(height: 50)),
              ],
            ),
          ),
        );

        final nonStretch = find.descendant(of: find.byType(StretchWrap), matching: find.byType(WrapChild)).first;
        final stretch = find.byType(Stretch);

        // Should start at 0 because stretch children take priority
        expect(tester.getTopLeft(nonStretch), const Offset(0, 0));
        expect(tester.getTopLeft(stretch), const Offset(110, 0));

        // Stretch should fill remaining space: 500 - 100 - 10 = 390
        expect(tester.getSize(stretch).width, 390);
      });

      testWidgets('applies alignment to multiple runs independently', (tester) async {
        await tester.pumpWidget(
          WrapContainer(
            maxWidth: 300,
            child: StretchWrap(
              spacing: 10,
              runSpacing: 15,
              alignment: RunAlignment.center,
              children: [
                WrapChild(width: 200, height: 50), // First run
                WrapChild(width: 100, height: 50), // Second run
                WrapChild(width: 80, height: 50), // Second run
              ],
            ),
          ),
        );

        final items = find.descendant(of: find.byType(StretchWrap), matching: find.byType(WrapChild));

        // First run: 200px used, 100px remaining, offset = 50
        expect(tester.getTopLeft(items.at(0)), const Offset(50, 0));

        // Second run: 100 + 10 + 80 = 190px used, 110px remaining, offset = 55
        expect(tester.getTopLeft(items.at(1)), const Offset(55, 65));
        expect(tester.getTopLeft(items.at(2)), const Offset(165, 65));
      });
    });

    group('AutoStretch', () {
      testWidgets('auto-stretches all children with AutoStretch.all', (tester) async {
        await tester.pumpWidget(
          const WrapContainer(
            maxWidth: 500,
            child: StretchWrap(
              spacing: 10,
              autoStretch: AutoStretch.all,
              children: [
                WrapChild(width: 100, height: 50),
                WrapChild(width: 150, height: 50),
              ],
            ),
          ),
        );

        final items = find.descendant(of: find.byType(StretchWrap), matching: find.byType(WrapChild));
        // Remaining space: 500 - 100 - 150 - 10 = 240
        // Split equally: each gets 120 extra
        expect(tester.getSize(items.first).width, 220);
        expect(tester.getSize(items.last).width, 270);
        expect(tester.getTopLeft(items.first), const Offset(0, 0));
        expect(tester.getTopLeft(items.last), const Offset(230, 0));
      });

      testWidgets('auto-stretches all runs except last with AutoStretch.exceptLastRun', (tester) async {
        await tester.pumpWidget(
          WrapContainer(
            maxWidth: 300,
            child: StretchWrap(
              spacing: 10,
              runSpacing: 15,
              autoStretch: AutoStretch.exceptLastRun,
              children: [
                WrapChild(width: 200, height: 50), // First run - should stretch
                WrapChild(width: 100, height: 50), // Second run - should not stretch
                WrapChild(width: 80, height: 50), // Second run - should not stretch
              ],
            ),
          ),
        );

        final items = find.descendant(of: find.byType(StretchWrap), matching: find.byType(WrapChild));

        // First run should stretch: 300 - 200 = 100 extra
        expect(tester.getSize(items.at(0)).width, 300);
        expect(tester.getTopLeft(items.at(0)), const Offset(0, 0));

        // Second run should not stretch (it's the last run)
        expect(tester.getSize(items.at(1)).width, 100);
        expect(tester.getSize(items.at(2)).width, 80);
        expect(tester.getTopLeft(items.at(1)), const Offset(0, 65));
        expect(tester.getTopLeft(items.at(2)), const Offset(110, 65));
      });

      testWidgets('respects explicit Stretch flex when auto-stretching', (tester) async {
        await tester.pumpWidget(
          const WrapContainer(
            maxWidth: 500,
            child: StretchWrap(
              spacing: 10,
              autoStretch: AutoStretch.all,
              children: [
                WrapChild(width: 100, height: 50), // Auto-stretch, flex = 1
                Stretch(flex: 2, child: WrapChild(width: 50, height: 50)), // Explicit flex = 2
              ],
            ),
          ),
        );

        final nonStretch = find.descendant(of: find.byType(StretchWrap), matching: find.byType(WrapChild)).first;
        final stretch = find.byType(Stretch);

        // Remaining space: 500 - 100 - 50 - 10 = 340
        // Total flex: 1 + 2 = 3
        // Non-stretch gets: 340 * 1/3 ≈ 113.33
        // Stretch gets: 340 * 2/3 ≈ 226.67
        expect(tester.getSize(nonStretch).width, closeTo(213.33, 1)); // 100 + 113.33
        expect(tester.getSize(stretch).width, closeTo(276.67, 1)); // 50 + 226.67
      });

      testWidgets('auto-stretch with zero flex explicit Stretch', (tester) async {
        await tester.pumpWidget(
          const WrapContainer(
            maxWidth: 500,
            child: StretchWrap(
              spacing: 10,
              autoStretch: AutoStretch.all,
              children: [
                WrapChild(width: 100, height: 50), // Auto-stretch, flex = 1
                Stretch(flex: 0, child: WrapChild(width: 50, height: 50)), // Explicit flex = 0
              ],
            ),
          ),
        );

        final nonStretch = find.descendant(of: find.byType(StretchWrap), matching: find.byType(WrapChild)).first;
        final stretch = find.byType(Stretch);

        // Remaining space: 500 - 100 - 50 - 10 = 340
        // Total flex: 1 + 0 = 1
        // Non-stretch gets all: 340
        // Stretch gets none: 0
        expect(tester.getSize(nonStretch).width, 440); // 100 + 340
        expect(tester.getSize(stretch).width, 50); // No change
      });
    });

    group('Combined alignment and autoStretch', () {
      testWidgets('applies alignment to last run when AutoStretch.exceptLastRun', (tester) async {
        await tester.pumpWidget(
          WrapContainer(
            maxWidth: 300,
            child: StretchWrap(
              spacing: 10,
              runSpacing: 15,
              alignment: RunAlignment.center,
              autoStretch: AutoStretch.exceptLastRun,
              children: [
                WrapChild(width: 200, height: 50), // First run - should stretch
                WrapChild(width: 100, height: 50), // Last run - should center
                WrapChild(width: 80, height: 50), // Last run - should center
              ],
            ),
          ),
        );

        final items = find.descendant(of: find.byType(StretchWrap), matching: find.byType(WrapChild));

        // First run stretches to full width
        expect(tester.getSize(items.at(0)).width, 300);
        expect(tester.getTopLeft(items.at(0)), const Offset(0, 0));

        // Last run centers: used = 100 + 10 + 80 = 190, remaining = 110, offset = 55
        expect(tester.getSize(items.at(1)).width, 100);
        expect(tester.getSize(items.at(2)).width, 80);
        expect(tester.getTopLeft(items.at(1)), const Offset(55, 65));
        expect(tester.getTopLeft(items.at(2)), const Offset(165, 65));
      });

      testWidgets('ignores alignment when AutoStretch.all', (tester) async {
        await tester.pumpWidget(
          const WrapContainer(
            maxWidth: 500,
            child: StretchWrap(
              spacing: 10,
              alignment: RunAlignment.end, // Should be ignored
              autoStretch: AutoStretch.all,
              children: [
                WrapChild(width: 100, height: 50),
                WrapChild(width: 150, height: 50),
              ],
            ),
          ),
        );

        final items = find.descendant(of: find.byType(StretchWrap), matching: find.byType(WrapChild));
        // Should start at 0 because auto-stretching takes priority
        // Remaining space: 500 - 100 - 150 - 10 = 240, split equally = 120 each
        expect(tester.getTopLeft(items.first), const Offset(0, 0));
        expect(tester.getTopLeft(items.last), const Offset(230, 0)); // 100 + 120 + 10 spacing
      });
    });
  });
}
