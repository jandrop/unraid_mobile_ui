# GitHub Actions Workflows

This directory contains the CI/CD pipelines for the unConnect mobile application.

## Workflows

### 1. Build and Release (`build-and-release.yml`)

**Triggers:**
- Push to `main` branch
- Push tags

**Jobs:**

#### Test Job
Runs on every push and PR:
- ✅ Code formatting check
- ✅ Static code analysis with `flutter analyze`
- ✅ Unit tests with `flutter test`

#### Build Job
Runs only when code is merged to `main`:
- 🏗️ Builds Android APK (split per ABI)
- 📦 Builds Android App Bundle (AAB)
- 🏷️ Extracts version from `pubspec.yaml`
- 📝 Generates release notes from commits
- 🔐 Creates SHA256 checksums
- 📤 Uploads artifacts
- 🚀 Creates GitHub Release

**Generated APKs:**
- `unConnect-{version}-{build}-arm64-v8a.apk` (64-bit ARM)
- `unConnect-{version}-{build}-armeabi-v7a.apk` (32-bit ARM)
- `unConnect-{version}-{build}-x86_64.apk` (x86_64)

**Additional Files:**
- `app-release.aab` (App Bundle for Play Store)
- `checksums.txt` (SHA256 checksums)

### 2. Pull Request Checks (`pr-checks.yml`)

**Triggers:**
- Pull requests to `main` or `develop`

**Jobs:**
- 🔍 Code formatting verification
- 📊 Static code analysis
- 🧪 Tests with coverage
- 📈 Upload coverage to Codecov
- 💬 Comment on PR with results

## Release Process

### Automatic Release Creation

When code is merged to `main`, the workflow:

1. **Runs Tests**: Ensures code quality
2. **Extracts Version**: From `pubspec.yaml` (e.g., `1.1.0+41`)
3. **Builds APKs**: For all architectures
4. **Creates Tag**: `v{version}-{build}` (e.g., `v1.1.0-41`)
5. **Generates Notes**: From commit messages since last release
6. **Publishes Release**: On GitHub with all APKs attached

### Manual Release

To create a new release:

1. Update version in `pubspec.yaml`:
   ```yaml
   version: 1.2.0+42
   ```

2. Commit and push to `main`:
   ```bash
   git add pubspec.yaml
   git commit -m "chore: bump version to 1.2.0+42"
   git push origin main
   ```

3. The workflow will automatically:
   - Run tests
   - Build APKs
   - Create GitHub release

## Requirements

### Secrets
No secrets required for basic functionality. Optional:
- `CODECOV_TOKEN` - For coverage reporting (optional)

### Permissions
The workflow requires:
- `contents: write` - To create releases
- `pull-requests: write` - To comment on PRs

## Local Testing

Test the workflow locally before pushing:

```bash
# Run tests
flutter test

# Check formatting
dart format --output=none --set-exit-if-changed .

# Analyze code
flutter analyze

# Build APK
flutter build apk --release --split-per-abi
```

## APK Architecture Guide

| Architecture | Description | Devices |
|-------------|-------------|---------|
| **arm64-v8a** | 64-bit ARM | Modern Android devices (2015+) |
| **armeabi-v7a** | 32-bit ARM | Older Android devices |
| **x86_64** | 64-bit x86 | Emulators, Chrome OS |

## Troubleshooting

### Build Fails

1. Check Flutter version in workflow matches local
2. Ensure all dependencies are compatible
3. Run tests locally first

### Release Not Created

1. Verify version was bumped in `pubspec.yaml`
2. Check if tag already exists
3. Ensure push was to `main` branch

### Test Failures

1. Run tests locally: `flutter test`
2. Check test output in workflow logs
3. Fix failing tests before merge

## Version Management

Version format: `MAJOR.MINOR.PATCH+BUILD`

Example: `1.1.0+41`
- **1.1.0**: Semantic version (major.minor.patch)
- **41**: Build number (auto-incremented)

### Version Bump Guide

- **Major** (1.0.0 → 2.0.0): Breaking changes
- **Minor** (1.0.0 → 1.1.0): New features
- **Patch** (1.0.0 → 1.0.1): Bug fixes
- **Build** (1.0.0+40 → 1.0.0+41): Every build

## Workflow Status

Check workflow status:
- GitHub Actions tab
- Commit status checks
- Release page

## Contributing

When contributing:
1. Create feature branch from `develop`
2. Make changes
3. Push and create PR
4. Wait for checks to pass
5. Merge to `develop`
6. Merge `develop` to `main` for release
