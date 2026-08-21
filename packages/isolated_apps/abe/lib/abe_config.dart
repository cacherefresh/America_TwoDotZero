import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'abe.dart';

final AppMeta abeMeta = AppMeta(
  id: 'abe',
  icon: const Icon(Icons.checklist),
  shortDescription: 'A.B.E.',
  longDescription:
      'American Backlog Enhancement — project tracking and management, '
      'hosted on GitHub.',
  page: const ABEView(),
);
