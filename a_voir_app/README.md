# a_voir_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Folder structure

### /assets (images, fonts, ...)

Folder to store images, files and other static files.

### lib/config

Location to store routes, database configuration file and themes

### lib/constants

This folder is used for all constant we need for the project.
Example: colors.dart, firebase_urls.dart,

### lib/ui

Sharable components that can be used in all application. We want to have the same ui component on all pages.
Example: a reusable button, a textarea

### lib/utils

Utilities used in the application.
Example: Firebase calls library, helpers, services

### lib/components

This folder is used to add all features/components of the application.
Example: login.dart, events_list.dart
