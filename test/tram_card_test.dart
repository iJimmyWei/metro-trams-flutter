import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_trams/components/tram_card.dart';

Widget makeTesteableWidget({Widget child}) {
  return MaterialApp(
    home: child,
  );
}

String fromRichTextToPlainText(final Widget widget) {
  if (widget is RichText) {
    if (widget.text is TextSpan) {
      final buffer = StringBuffer();
      (widget.text as TextSpan).computeToPlainText(buffer);
      return buffer.toString();
    }
  }
  return null;
}

void main() {
  testWidgets('Tram card widget - in transit tram - mins',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(makeTesteableWidget(
        child: TramCard(
            line: "choochooline",
            waitTime: "3",
            dest: "North Pole",
            carriages: "Double",
            status: "Moving")));

    expect(
        find.byWidgetPredicate(
            (widget) => fromRichTextToPlainText(widget) == 'Departing'),
        findsNothing);

    expect(
        find.byWidgetPredicate(
            (widget) => fromRichTextToPlainText(widget) == 'Arriving'),
        findsNothing);

    expect(
        find.byWidgetPredicate(
            (widget) => fromRichTextToPlainText(widget) == '3 mins'),
        findsOneWidget);
  });

  testWidgets('Tram card widget - in transit tram - min',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(makeTesteableWidget(
        child: TramCard(
            line: "choochooline",
            waitTime: "1",
            dest: "North Pole",
            carriages: "Double",
            status: "Moving")));

    expect(
        find.byWidgetPredicate(
            (widget) => fromRichTextToPlainText(widget) == '1 min'),
        findsOneWidget);
  });

  testWidgets('Tram card widget - arriving tram', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(makeTesteableWidget(
        child: TramCard(
            line: "choochooline",
            waitTime: "3",
            dest: "North Pole",
            carriages: "Double",
            status: "Arriving")));

    // Verify destination
    expect(find.text("North Pole"), findsOneWidget);

    // Verify carriage
    expect(find.text('Double Carriage'), findsOneWidget);

    // Verify arriving shows
    expect(
        find.byWidgetPredicate(
            (widget) => fromRichTextToPlainText(widget) == 'Arriving'),
        findsOneWidget);
  });

  testWidgets('Tram card widget - departing tram', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(makeTesteableWidget(
        child: TramCard(
            line: "choochooline",
            waitTime: "3",
            dest: "North Pole",
            carriages: "Double",
            status: "Departing")));

    // Verify departing shows
    expect(
        find.byWidgetPredicate(
            (widget) => fromRichTextToPlainText(widget) == 'Departing'),
        findsOneWidget);
  });
}
