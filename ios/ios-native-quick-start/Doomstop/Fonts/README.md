# Fonts Directory

This folder contains the custom font files for the Doomstop app.

## Required Font Files:

### Oswald Family (for headlines)
- `Oswald-Regular.ttf`
- `Oswald-SemiBold.ttf`
- `Oswald-Bold.ttf`

### DM Sans Family (for body text)
- `DMSans-Regular.ttf`
- `DMSans-Medium.ttf`

## Installation:

1. Place the actual `.ttf` font files in this directory
2. Ensure the font names match exactly as listed above
3. The fonts are already registered in `Info.plist` under the `UIAppFonts` key
4. Use the fonts in SwiftUI via the `Theme.Fonts` constants:
   - `Theme.Fonts.headline` for Oswald
   - `Theme.Fonts.body` for DM Sans

## Font Usage Example:

```swift
Text("Headline Text")
    .font(.custom(Theme.Fonts.headline, size: 24))
    .fontWeight(.bold)

Text("Body Text")
    .font(.custom(Theme.Fonts.body, size: 16))
```
