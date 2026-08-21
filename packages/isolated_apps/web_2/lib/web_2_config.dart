import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'web_2.dart';

final AppMeta web2Meta = AppMeta(
  id: 'web_2',
  icon: const Icon(Icons.public),
  shortDescription: 'Web 2.0',
  longDescription:
      'Markdown documentation viewer — browse drafts, proposals, and policy '
      'ideas straight from the project vault.',
  page: const Web2View(),
);
