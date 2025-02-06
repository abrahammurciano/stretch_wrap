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
  });
}
