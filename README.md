# stretch_wrap

A Flutter widget that wraps children into multiple rows and stretches designated children to fill the remaining space in each row.

## Features

- Wraps widgets into multiple rows, like Flutter's built-in `Wrap`.
- Stretches designated children within each row to fill remaining space.
- Supports multiple stretched children in a row with different stretch ratios.
- Configurable spacing between children and rows.

## Usage

Wrap your widgets with `StretchWrap`. Use `Stretch` to mark which children should expand to fill the remaining space:

```dart
StretchWrap(
  spacing: 8,  // Space between children
  runSpacing: 16,  // Space between rows
  children: [
    Container(width: 100, height: 50, color: Colors.red),
    Stretch(  // This will fill available space, minimum width is 50
      child: Container(width: 50, height: 50, color: Colors.blue),
    ),
    Container(width: 80, height: 50, color: Colors.green),
  ],
)
```

### Multiple stretched children

When multiple children in the same row are wrapped with `Stretch`, they share the remaining space proportionally based on their `flex` factor:

```dart
StretchWrap(
  spacing: 8,
  children: [
    Container(width: 100),
    Stretch(  // Gets 1/3 of remaining space (width 0 prevents it from taking a whole row)
      child: Container(color: Colors.blue, width: 0),
    ),
    Stretch(  // Gets 2/3 of remaining space (width 0 prevents it from taking a whole row)
      flex: 2,
      child: Container(color: Colors.green, width: 0),
    ),
  ],
)
```

### How it works

1. First, children are measured and arranged into rows.
2. For each row, any remaining space is divided among `Stretch` children.
3. If a row has multiple `Stretch` children, space is divided according to their `flex` values.
4. Each `Stretch` child is then resized to its calculated width.

## Examples

See the [example](example) folder for a complete sample app:
- [Basic example](example/lib/examples/basic_example.dart)
- [Multiple stretch example](example/lib/examples/multiple_stretch_example.dart)
- [Multiple rows example](example/lib/examples/multiple_rows_example.dart)
- [Mixed content example](example/lib/examples/mixed_content_example.dart)
- [Tag list example](example/lib/examples/tag_list_example.dart)

![Example app](https://raw.githubusercontent.com/abrahammurciano/stretch_wrap/main/example/screenshot.png)
