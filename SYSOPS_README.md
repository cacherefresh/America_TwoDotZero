# America 2.0 - Systems Operations & Deployment Guide

## Overview

This guide provides detailed instructions for building the America 2.0 Flutter application as a static web site and deploying it to GitHub Pages with a custom domain (`cacherefresh.io`) hosted on GoDaddy.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Building the Flutter Web App](#building-the-flutter-web-app)
3. [GitHub Pages Setup](#github-pages-setup)
4. [Custom Domain Configuration (GoDaddy)](#custom-domain-configuration-godaddy)
5. [Automated Deployment](#automated-deployment)
6. [Maintenance & Updates](#maintenance--updates)
7. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Required Software

- **Flutter SDK**: Version 3.0.0 or higher
  ```bash
  flutter --version
  ```

- **Git**: Version control system
  ```bash
  git --version
  ```

- **Node.js & npm**: Optional, for build optimization (version 18+)

### Required Accounts & Services

- **GitHub Account**: With access to the repository
- **Domain Hosting Account**: Domain owner with DNS management access
- **cacherefresh.io Domain**: Already registered and active

### Required Permissions

- Repository: Push/merge access to `main` branch
- GoDaddy: Full DNS and domain management access

---

## Building the Flutter Web App

### Step 1: Prepare the Project

Navigate to the project root:
```bash
cd /path/to/America_TwoDotZero/flutter_app_wrapper
```

### Step 2: Get Dependencies

Fetch all package dependencies:
```bash
flutter pub get
```

If you encounter issues with local path dependencies, ensure all packages have `publish_to: none` in their `pubspec.yaml`:
- `packages/common/core/pubspec.yaml`
- `packages/common/markdown_view/pubspec.yaml`
- `packages/isolated_apps/game/pubspec.yaml`
- `packages/isolated_apps/web_2/pubspec.yaml`
- `packages/isolated_apps/we_the_people/pubspec.yaml`
- `packages/isolated_apps/poe/pubspec.yaml`
- `packages/isolated_apps/abe/pubspec.yaml`
- `packages/isolated_apps/about/pubspec.yaml`

### Step 3: Build for Web

Build the web application as a static site:

```bash
flutter build web --release
```

**Build Options:**

- `--release`: Optimizes for production (recommended)
- `--web-renderer html`: Uses HTML renderer for better compatibility
- `--csp`: Enables Content Security Policy for enhanced security

**Full command with optimization:**
```bash
flutter build web --release --web-renderer html
```

### Step 4: Output Location

The build artifacts will be located at:
```
flutter_app_wrapper/build/web/
```

This directory contains:
- `index.html` - Main application entry point
- `main.dart.js` - Compiled Dart application
- `assets/` - Static assets (images, fonts, markdown files)
- `canvaskit/` - Web rendering engine resources

### Step 5: Verify the Build

Test the build locally:
```bash
# Using Python 3
python3 -m http.server 8000 --directory build/web

# Using Python 2
python -m SimpleHTTPServer 8000
```

Visit `http://localhost:8000` in your browser and verify:
- All four menu icons display (Web 2.0, Game, We the People, P.O.E.)
- Navigation between sections works
- Links are functional
- No console errors

---

## GitHub Pages Setup

### Step 1: Repository Structure

Ensure your GitHub repository is set up correctly:

```
cacherefresh/America_TwoDotZero/
├── flutter_app_wrapper/
│   ├── build/
│   │   └── web/  ← Build output
│   ├── lib/
│   ├── pubspec.yaml
│   └── ...
├── packages/
├── SYSOPS_README.md  ← This file
├── README.md
└── .github/
    └── workflows/  ← For CI/CD (optional)
```

### Step 2: Configure GitHub Pages

#### Option A: Deploy from `gh-pages` Branch (Recommended)

1. **Create the `gh-pages` branch locally** (if it doesn't exist):
   ```bash
   git checkout --orphan gh-pages
   git rm -rf .
   echo "placeholder" > README.md
   git add README.md
   git commit -m "Initial gh-pages commit"
   git push origin gh-pages
   ```

2. **Configure GitHub Pages settings**:
   - Go to: Repository → Settings → Pages
   - Under "Source", select:
     - Branch: `gh-pages`
     - Folder: `/ (root)`
   - Click "Save"

#### Option B: Deploy from `main` Branch

1. **Create a `docs/` folder** in the `main` branch root
2. **Copy build output** to `docs/`
3. **Configure GitHub Pages settings**:
   - Go to: Repository → Settings → Pages
   - Under "Source", select:
     - Branch: `main`
     - Folder: `/docs`
   - Click "Save"

### Step 3: Deploy Web Build

Choose your deployment method:

#### Manual Deployment (Simple)

```bash
# From flutter_app_wrapper directory, after running `flutter build web --release`

# Navigate to repository root
cd ../..

# Create or update docs folder (for main branch deployment)
mkdir -p docs
rm -rf docs/*
cp -r flutter_app_wrapper/build/web/* docs/

# OR use gh-pages branch
git checkout gh-pages
rm -rf * .github .gitignore  # Keep .git
cp -r flutter_app_wrapper/build/web/* ./
git add -A
git commit -m "Deploy: Update web application"
git push origin gh-pages
```

#### Scripted Deployment

Create `scripts/deploy.sh`:

```bash
#!/bin/bash
set -e

echo "Building Flutter web application..."
cd flutter_app_wrapper
flutter build web --release --web-renderer html
cd ..

echo "Deploying to GitHub Pages..."
DEPLOY_BRANCH="gh-pages"
BUILD_DIR="flutter_app_wrapper/build/web"

# Stash current changes
git stash

# Checkout gh-pages branch
git checkout $DEPLOY_BRANCH

# Clear old content
rm -rf *
rm -rf .github .gitignore

# Copy new build
cp -r $BUILD_DIR/* ./

# Commit and push
git add -A
git commit -m "Deploy: $(date '+%Y-%m-%d %H:%M:%S')" || echo "No changes to commit"
git push origin $DEPLOY_BRANCH

# Return to main branch
git checkout main

echo "✓ Deployment complete!"
```

Make it executable:
```bash
chmod +x scripts/deploy.sh
```

Run the deployment:
```bash
./scripts/deploy.sh
```

### Step 4: Verify GitHub Pages Deployment

1. Go to: Repository → Settings → Pages
2. Look for the message: "Your site is published at `https://cacherefresh.github.io`"
3. Visit: `https://cacherefresh.github.io` (or your GitHub Pages URL)
4. Verify the application loads and functions correctly

---

## Custom Domain Configuration (GoDaddy)

### Step 1: Update GitHub Pages for Custom Domain

1. **Add CNAME file** to your deployment:

   In your `gh-pages` or `docs/` folder, create `CNAME`:
   ```
   cacherefresh.io
   ```

   Or add to deployment script:
   ```bash
   echo "cacherefresh.io" > CNAME
   ```

2. **Configure in GitHub Pages settings**:
   - Go to: Repository → Settings → Pages
   - Under "Custom domain", enter: `cacherefresh.io`
   - Check "Enforce HTTPS"
   - Click "Save"

   GitHub will automatically create the `CNAME` file if you enter the domain.

### Step 2: Configure DNS on GoDaddy

#### Via GoDaddy Dashboard

1. **Log in to GoDaddy account**
2. **Navigate to Domains**:
   - Click "My Products" → Domains
   - Select `cacherefresh.io`

3. **Access DNS Settings**:
   - Click the domain name
   - Go to "Manage DNS" or "Nameservers"

4. **Add/Update DNS Records**:

   **For Apex Domain (cacherefresh.io):**

   Delete existing `A` records and add these GitHub Pages IP addresses:
   ```
   Type: A
   Name: @ (or leave blank)
   Value: 185.199.108.153
   TTL: 600 (or 3600)
   ```

   Repeat for these IP addresses:
   - `185.199.109.153`
   - `185.199.110.153`
   - `185.199.111.153`

   **For WWW Subdomain:**

   Add a `CNAME` record:
   ```
   Type: CNAME
   Name: www
   Value: cacherefresh.github.io
   TTL: 600 (or 3600)
   ```

5. **Save Changes**

   Click "Save" or confirm changes. DNS propagation typically takes 15 minutes to 48 hours.

#### Verify DNS Configuration

```bash
# Check A records
dig cacherefresh.io A

# Check CNAME for www
dig www.cacherefresh.io CNAME

# Full DNS lookup
nslookup cacherefresh.io
```

Expected output for A records:
```
cacherefresh.io     IN  A   185.199.108.153
cacherefresh.io     IN  A   185.199.109.153
cacherefresh.io     IN  A   185.199.110.153
cacherefresh.io     IN  A   185.199.111.153
```

### Step 3: Verify Custom Domain Setup

1. Wait for DNS propagation (check with `dig` command above)
2. Visit `https://cacherefresh.io` in your browser
3. You should be automatically redirected from GitHub Pages
4. Verify HTTPS is active (padlock icon in browser)
5. Verify all application features work

---

## Automated Deployment

### GitHub Actions Workflow

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches:
      - main
    paths:
      - 'flutter_app_wrapper/**'
      - 'packages/**'
      - '.github/workflows/deploy.yml'
  workflow_dispatch:

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
          channel: 'stable'

      - name: Get Dependencies
        run: |
          cd flutter_app_wrapper
          flutter pub get

      - name: Build Web App
        run: |
          cd flutter_app_wrapper
          flutter build web --release --web-renderer html

      - name: Create CNAME
        run: echo "cacherefresh.io" > flutter_app_wrapper/build/web/CNAME

      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./flutter_app_wrapper/build/web
          cname: cacherefresh.io
```

**Setup Instructions:**

1. Create the workflow directory:
   ```bash
   mkdir -p .github/workflows
   ```

2. Create `deploy.yml` file with content above

3. Commit and push:
   ```bash
   git add .github/workflows/deploy.yml
   git commit -m "Add GitHub Actions deployment workflow"
   git push origin main
   ```

4. **Verify Workflow**:
   - Go to: Repository → Actions
   - Watch the workflow run
   - Check for green checkmark indicating success

---

## Maintenance & Updates

### Deploying Changes

#### For Manual Deployment:

1. **Make code changes** in your local environment
2. **Test locally**:
   ```bash
   cd flutter_app_wrapper
   flutter run -d chrome  # or other device
   ```

3. **Build for production**:
   ```bash
   flutter build web --release
   ```

4. **Deploy using script**:
   ```bash
   ./scripts/deploy.sh
   ```

5. **Verify** at `https://cacherefresh.io`

#### For Automated Deployment (GitHub Actions):

1. **Make code changes** and commit
2. **Push to main branch**:
   ```bash
   git push origin main
   ```

3. **Automatic deployment** happens via GitHub Actions
4. **Monitor** via: Repository → Actions
5. **Verify** at `https://cacherefresh.io` (may take 1-2 minutes)

### Regular Maintenance Tasks

**Weekly:**
- Check GitHub Pages deployment status
- Verify application loads without errors
- Monitor browser console for errors

**Monthly:**
- Update Flutter SDK:
  ```bash
  flutter upgrade
  ```
- Update package dependencies:
  ```bash
  flutter pub upgrade
  ```
- Test all application features

**Quarterly:**
- Review GitHub Pages analytics
- Check for security updates
- Audit DNS settings on GoDaddy

### Asset Updates

**Adding New Markdown Files:**

1. Place files in: `flutter_app_wrapper/assets/vault/MDs/`
2. Rebuild:
   ```bash
   cd flutter_app_wrapper
   flutter build web --release
   ```
3. Deploy using your chosen method
4. Application automatically detects new files

---

## Troubleshooting

### Build Issues

**Problem: Build fails with dependency errors**
```
Solution: Run flutter pub get and ensure all pubspec.yaml files have publish_to: none
flutter clean
flutter pub get
flutter build web --release
```

**Problem: Local path dependencies cause issues**
```
Solution: Verify all packages are in packages/ directory and pubspec.yaml paths are correct
cat packages/common/core/pubspec.yaml | grep "publish_to"
```

### Deployment Issues

**Problem: GitHub Pages not updating**
```
Solution: 
1. Verify CNAME file exists in deployment directory
2. Check GitHub Pages settings → Pages
3. Force push gh-pages branch: git push -f origin gh-pages
4. Clear browser cache (Ctrl+Shift+Del or Cmd+Shift+Delete)
```

**Problem: 404 errors after deployment**
```
Solution:
1. Verify index.html exists in deployment root
2. Check that build/web/ directory contains all files
3. Ensure no stray directories wrapping content
4. GitHub Pages should show: "Your site is published at..."
```

### DNS Issues

**Problem: Domain not resolving to GitHub Pages**
```
Solution:
1. Verify DNS records using: dig cacherefresh.io A
2. Wait 24-48 hours for full propagation
3. Check GoDaddy DNS settings are saved
4. Clear local DNS cache:
   - macOS: sudo dscacheutil -flushcache
   - Windows: ipconfig /flushdns
   - Linux: sudo systemctl restart systemd-resolved
5. Verify CNAME record in GitHub Pages settings
```

**Problem: HTTPS not working**
```
Solution:
1. Ensure "Enforce HTTPS" is checked in GitHub Pages settings
2. Verify CNAME file content is correct: cacherefresh.io
3. GitHub manages SSL certificates automatically
4. Wait 5-15 minutes after domain setup for certificate issuance
5. Disable browser cache and hard refresh (Cmd+Shift+R or Ctrl+Shift+R)
```

**Problem: www subdomain not working**
```
Solution:
1. Verify www CNAME record points to: cacherefresh.github.io
2. GitHub redirects www automatically with apex domain setup
3. DNS propagation may take 48 hours
4. Alternative: Remove www CNAME if not needed
```

### Application Issues

**Problem: Links not working in deployed version**
```
Solution:
1. Check browser console for errors (F12)
2. Verify url_launcher package is working in web context
3. Test locally: flutter run -d chrome
4. GitHub Pages may block external link launches
```

**Problem: Assets/images not loading**
```
Solution:
1. Verify assets are in flutter_app_wrapper/assets/
2. Check pubspec.yaml includes asset paths:
   flutter:
     assets:
       - assets/vault/MDs/
3. Rebuild: flutter build web --release
4. Clear browser cache
```

### Performance Issues

**Problem: Application loads slowly**
```
Solution:
1. Build with optimizations: flutter build web --release
2. Check GoDaddy DNS performance settings
3. Minimize asset file sizes
4. Use browser DevTools to identify slow resources
5. Consider CDN for large static files
```

---

## Reference URLs

- **GitHub Pages Documentation**: https://pages.github.com/
- **Flutter Web Build Guide**: https://docs.flutter.dev/platform-integration/web/building-a-web-application
- **GoDaddy DNS Guide**: https://www.godaddy.com/help/manage-dns-for-your-domain-680
- **GitHub Actions**: https://docs.github.com/en/actions
- **Custom Domain on GitHub Pages**: https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site

---

## Support & Escalation

### Common Issues Checklist

- [ ] Flutter SDK version 3.0.0 or higher installed
- [ ] All local package dependencies have `publish_to: none`
- [ ] `flutter pub get` ran successfully
- [ ] `flutter build web --release` completed without errors
- [ ] CNAME file exists in deployment directory
- [ ] GitHub Pages settings configured correctly
- [ ] DNS records added to GoDaddy
- [ ] DNS propagation confirmed with `dig` command
- [ ] HTTPS working (padlock icon shows)
- [ ] All application features tested

### Getting Help

If issues persist:

1. **Check GitHub Issues**: Search for similar problems
2. **Flutter Documentation**: https://flutter.dev/docs
3. **GitHub Pages Support**: https://github.com/contact
4. **GoDaddy Support**: https://support.godaddy.com/

---

**Last Updated**: April 2026  
**Version**: 1.0  
**Status**: Production Ready
