# America_TwoDotZero
America_2.0 - The planets have aligned Peace on Earth

## Application Overview

America 2.0 is a multi-tab Flutter web application that serves as a hub for several interconnected initiatives and tools. The application features a persistent purple header navigation bar with the following sections:

### Available Tabs

1. **Home** (🏠) - Welcome screen with app overview
2. **Web 2.0** (🌐) - Markdown content viewer and documentation hub
3. **Game** (🎮) - Embedded Guilds application from GitHub (https://github.com/cacherefresh/Guilds)
4. **We the People** (👥 ↔️ 📜) - Third-party movement platform with campaign contribution transparency requirements (alternates between people and scroll icons)
5. **P.O.E.** (🕊️ ↔️ 🐦‍⬛) - Peace On Earth initiative with world peace proposal details (alternates between peace dove and black raven)
6. **A.B.E.** (✓) - American Backlog Enhancement project tracking from GitHub (https://github.com/cacherefresh/American-Backlog-Enhancement)

### Key Features

- **Persistent Navigation** - Purple header bar stays visible when switching between tabs
- **Embedded Applications** - Game and A.B.E. tabs embed external Flutter web apps via iframes
- **Animated Icons** - We the People and P.O.E. icons animate every 2 seconds
- **Responsive Design** - Works on desktop, tablet, and mobile devices
- **Static Site Generation** - Builds to a fully functional static site for deployment

## Flutter Developer Notes

To clean, build and run this Flutter app:

### Navigate to flutter_app_wrapper
```bash
cd packages/flutter_app_wrapper
```

### Clean previous builds
```bash
flutter clean
```

### Get dependencies
```bash
flutter pub get
```

### Build for web (production)
```bash
flutter build web --release
```

### Output location: build/web/

The build output contains a fully functional static site that can be deployed to GitHub Pages or any static hosting service.

## Project Structure

```
packages/
├── core/              - Core utilities
├── game/              - Game tab with Guilds iframe
├── web_2/             - Web 2.0 markdown viewer
├── we_the_people/     - Third-party movement content
├── poe/               - Peace On Earth initiative
├── abe/               - American Backlog Enhancement iframe
└── markdown_view/     - Markdown rendering component

flutter_app_wrapper/   - Main Flutter application
├── lib/main.dart      - Application entry point and navigation
├── build/web/         - Build output (static site)
└── pubspec.yaml       - Dependencies
```

## Deployment

For detailed deployment instructions to GitHub Pages with your cacherefresh.io domain, see **[SYSOPS_README.md](SYSOPS_README.md)**.

