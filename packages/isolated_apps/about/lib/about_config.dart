import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'about.dart';

final AppMeta aboutMeta = AppMeta(
  id: 'about',
  icon: const Text('🪶', style: TextStyle(fontSize: 20)),
  shortDescription: 'About',
  longDescription:
      "A window onto Robert Coffman's personal site — background, "
      "experience, and how to get in touch.",
  page: const AboutView(),
);
