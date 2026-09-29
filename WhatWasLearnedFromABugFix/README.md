# WhatWasLearnedFromABugFix

Post-mortems for bugs that made it into this repo.

## Intent

This folder exists so a fixed bug leaves something behind besides a diff.

A commit message says *what* changed. These write-ups say **why the bug was
possible at all**, and whether the fix we shipped was the fix a more
experienced engineer would have shipped. The goal is not a changelog — git
already has one — it is to notice patterns across bugs so the same class of
mistake stops recurring.

## What belongs in a write-up

Each file covers one bug and answers:

1. **Symptom** — what was actually observed, in the words it was reported in.
2. **Root cause** — the real mechanism, not the first plausible story. If a bug
   had more than one independent cause, every one of them gets named.
3. **The fix** — what changed and why that layer was the right place to change.
4. **The more senior way** — the honest review. Was there a cleaner fix? Did we
   patch a symptom? What would someone with more experience have done first?
5. **Mistakes made during the fix** — wrong turns taken while debugging, not
   just the bug itself. This section is often the most useful one.
6. **Follow-ups** — known-adjacent problems found but deliberately not fixed,
   so they are not lost.

## Conventions

- One file per bug, named `YYYY-MM-DD_short-slug.md`.
- Be specific and verifiable: name files, versions, and commands.
- Be blunt in sections 4 and 5. A write-up that makes the fix sound clean and
  inevitable has failed at its only job.

## Index

| Date | Write-up | One-line lesson |
|---|---|---|
| 2026-08-29 | [Markdown images did not render on the web build](2026-08-29_markdown-images-not-rendering.md) | Keep source documents portable; fix the renderer, not the content. |
