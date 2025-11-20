# VGV Architecture Refactor - TODO List

## ✅ COMPLETED
- [x] Architecture analysis
- [x] Documentation created
- [x] Updated .gitignore for AI docs
- [x] Step 1.1: Add Required Dependencies
- [x] Step 1.2: Create Core Directory Structure
- [x] Step 1.3: Core Error Handling (27 tests ✓)
- [x] Step 1.4: Network Client (15 tests ✓)
- [x] Step 1.5: Storage Abstraction (21 tests ✓)
- [x] Step 1.6: Dependency Injection (13 tests ✓)

---

## 📋 PHASE 1: FOUNDATION (Current Phase - 75% Complete)

### ✅ Step 1.1: Add Required Dependencies
- [x] Update pubspec.yaml with new packages
- [x] Run flutter pub get
- [x] Verify no conflicts

### ✅ Step 1.2: Create Core Directory Structure
- [x] Create lib/core/{network,error,storage,di,utils}
- [x] Create lib/app/{theme,routes}
- [x] Create test/core structure

### ✅ Step 1.3: Core Error Handling
- [x] Create core/error/failures.dart
- [x] Create core/error/exceptions.dart
- [x] Add tests for error classes

### ✅ Step 1.4: Network Client
- [x] Create core/network/graphql_client.dart
- [x] Extract GraphQL logic from AuthState
- [x] Test network client

### ✅ Step 1.5: Storage Abstraction
- [x] Create core/storage/secure_storage.dart
- [x] Abstract SharedPreferences usage
- [x] Test storage layer

### ✅ Step 1.6: Dependency Injection
- [x] Create core/di/injection.dart
- [x] Setup GetIt service locator
- [x] Register core dependencies

### 🔧 Step 1.7: App Structure ⬅️ **YOU ARE HERE**
- [ ] Create app/app.dart
- [ ] Create app/theme/app_theme.dart
- [ ] Move theme logic from main.dart
- [ ] Create app/routes/routes.dart

### 🔧 Step 1.8: Update Main Entry Point
- [ ] Update main.dart to use new structure
- [ ] Initialize dependency injection
- [ ] Test app startup

---

## 📋 PHASE 2: AUTHENTICATION FEATURE

### 🔧 Step 2.1: Auth Domain Layer
- [ ] Create feature branch: feature/auth-domain
- [ ] Create domain/entities/user.dart
- [ ] Create domain/repositories/auth_repository.dart (interface)
- [ ] Create domain/usecases/login.dart
- [ ] Create domain/usecases/logout.dart
- [ ] Create domain/usecases/get_current_user.dart
- [ ] Create domain/usecases/is_authenticated.dart
- [ ] Write unit tests for use cases

### 🔧 Step 2.2: Auth Data Layer
- [ ] Create feature branch: feature/auth-data
- [ ] Create data/models/user_model.dart
- [ ] Create data/datasources/auth_remote_datasource.dart
- [ ] Create data/datasources/auth_local_datasource.dart
- [ ] Create data/repositories/auth_repository_impl.dart
- [ ] Run build_runner for JSON serialization
- [ ] Write tests for data layer

### 🔧 Step 2.3: Auth Presentation Layer
- [ ] Create feature branch: feature/auth-presentation
- [ ] Create presentation/bloc/auth_event.dart
- [ ] Create presentation/bloc/auth_state.dart
- [ ] Create presentation/bloc/auth_bloc.dart
- [ ] Create presentation/pages/login_page.dart
- [ ] Create presentation/widgets/login_form.dart
- [ ] Write BLoC tests
- [ ] Write widget tests

### 🔧 Step 2.4: Auth Dependency Registration
- [ ] Register auth dependencies in DI
- [ ] Test auth flow end-to-end
- [ ] Remove old AuthState notifier
- [ ] Update routes to use new login page

### 🔧 Step 2.5: Auth Integration Testing
- [ ] Integration tests for auth flow
- [ ] Manual testing
- [ ] Bug fixes
- [ ] Merge to develop (locally)

---

## 📋 PHASE 3: DASHBOARD FEATURE

### 🔧 Step 3.1: Break Down Dashboard
- [ ] Analyze current dashboard.dart
- [ ] Identify sub-features:
  - Server Info Card
  - Array Info Card
  - System Metrics Card
  - Parity Check Card
  - UPS Monitor Card
  - Docker Quick View
  - VM Quick View

### 🔧 Step 3.2: Server Info Sub-Feature
- [ ] Create feature branch: feature/dashboard-server-info
- [ ] Domain: entities, repository interface, use cases
- [ ] Data: models, datasources, repository impl
- [ ] Presentation: bloc, widgets
- [ ] Tests for all layers
- [ ] Merge to develop (locally)

### 🔧 Step 3.3: Array Info Sub-Feature
- [ ] Create feature branch: feature/dashboard-array-info
- [ ] Domain layer
- [ ] Data layer
- [ ] Presentation layer
- [ ] Tests
- [ ] Merge to develop (locally)

### 🔧 Step 3.4: System Metrics Sub-Feature (with subscriptions)
- [ ] Create feature branch: feature/dashboard-metrics
- [ ] Domain layer
- [ ] Data layer with GraphQL subscriptions
- [ ] Presentation layer with stream handling
- [ ] Tests
- [ ] Merge to develop (locally)

### 🔧 Step 3.5: Parity Check Sub-Feature
- [ ] Create feature branch: feature/dashboard-parity
- [ ] Domain layer
- [ ] Data layer
- [ ] Presentation layer
- [ ] Tests
- [ ] Merge to develop (locally)

### 🔧 Step 3.6: UPS Monitor Sub-Feature
- [ ] Create feature branch: feature/dashboard-ups
- [ ] Domain layer
- [ ] Data layer
- [ ] Presentation layer
- [ ] Tests
- [ ] Merge to develop (locally)

### 🔧 Step 3.7: Composite Dashboard Page
- [ ] Create feature branch: feature/dashboard-main
- [ ] Create main dashboard page
- [ ] Integrate all sub-feature cards
- [ ] Add refresh functionality
- [ ] Navigation drawer integration
- [ ] Tests
- [ ] Remove old dashboard.dart
- [ ] Merge to develop (locally)

---

## 📋 PHASE 4: DOCKER FEATURE

### 🔧 Step 4.1: Docker Domain Layer
- [ ] Create feature branch: feature/docker-domain
- [ ] Entities: Container, ContainerStatus
- [ ] Repository interface
- [ ] Use cases: GetContainers, StartContainer, StopContainer, RestartContainer
- [ ] Tests
- [ ] Merge to develop (locally)

### 🔧 Step 4.2: Docker Data Layer
- [ ] Create feature branch: feature/docker-data
- [ ] Models
- [ ] Remote datasource
- [ ] Repository implementation
- [ ] Tests
- [ ] Merge to develop (locally)

### 🔧 Step 4.3: Docker Presentation Layer
- [ ] Create feature branch: feature/docker-presentation
- [ ] BLoC (events, states, bloc)
- [ ] Containers list page
- [ ] Container details page
- [ ] Container control widgets
- [ ] Tests
- [ ] Remove old dockers.dart
- [ ] Merge to develop (locally)

---

## 📋 PHASE 5: OTHER FEATURES

### 🔧 Step 5.1: Virtual Machines Feature
- [ ] Feature branch: feature/vms
- [ ] Domain layer
- [ ] Data layer
- [ ] Presentation layer
- [ ] Tests
- [ ] Remove old vms.dart
- [ ] Merge to develop (locally)

### 🔧 Step 5.2: Array Management Feature
- [ ] Feature branch: feature/array
- [ ] Domain layer
- [ ] Data layer
- [ ] Presentation layer
- [ ] Tests
- [ ] Remove old array.dart
- [ ] Merge to develop (locally)

### 🔧 Step 5.3: System Information Feature
- [ ] Feature branch: feature/system
- [ ] Domain layer
- [ ] Data layer
- [ ] Presentation layer
- [ ] Tests
- [ ] Remove old system.dart
- [ ] Merge to develop (locally)

### 🔧 Step 5.4: Plugins Feature
- [ ] Feature branch: feature/plugins
- [ ] Domain layer
- [ ] Data layer
- [ ] Presentation layer
- [ ] Tests
- [ ] Remove old plugins.dart
- [ ] Merge to develop (locally)

### 🔧 Step 5.5: Settings Feature
- [ ] Feature branch: feature/settings
- [ ] Domain layer
- [ ] Data layer
- [ ] Presentation layer
- [ ] Tests
- [ ] Remove old settings.dart
- [ ] Merge to develop (locally)

### 🔧 Step 5.6: Notifications Feature
- [ ] Feature branch: feature/notifications
- [ ] Domain layer
- [ ] Data layer
- [ ] Presentation layer
- [ ] Tests
- [ ] Remove old notifications.dart
- [ ] Merge to develop (locally)

### 🔧 Step 5.7: Shares Feature
- [ ] Feature branch: feature/shares
- [ ] Domain layer
- [ ] Data layer
- [ ] Presentation layer
- [ ] Tests
- [ ] Remove old shares.dart
- [ ] Merge to develop (locally)

---

## 📋 PHASE 6: CLEANUP & OPTIMIZATION

### 🔧 Step 6.1: Remove Legacy Code
- [ ] Feature branch: feature/cleanup
- [ ] Remove old screens/ directory
- [ ] Remove old notifiers/ directory
- [ ] Remove old global/ directory
- [ ] Update all imports
- [ ] Verify app works
- [ ] Merge to develop (locally)

### 🔧 Step 6.2: Performance Optimization
- [ ] Feature branch: feature/performance
- [ ] Add caching strategy
- [ ] Optimize subscriptions
- [ ] Lazy loading for lists
- [ ] Memory profiling
- [ ] Merge to develop (locally)

### 🔧 Step 6.3: Error Handling & Offline Support
- [ ] Feature branch: feature/offline
- [ ] Consistent error messages
- [ ] Retry mechanisms
- [ ] Offline indicators
- [ ] Connection status monitoring
- [ ] Merge to develop (locally)

### 🔧 Step 6.4: Testing & Coverage
- [ ] Run all tests
- [ ] Generate coverage report
- [ ] Target 80%+ coverage
- [ ] Fix failing tests
- [ ] Add missing tests

### 🔧 Step 6.5: Documentation
- [ ] Update README.md
- [ ] Add architecture documentation
- [ ] Add contribution guidelines
- [ ] Document APIs
- [ ] Code documentation

### 🔧 Step 6.6: Final Review
- [ ] Code review
- [ ] Performance testing
- [ ] Manual testing all features
- [ ] Bug fixes
- [ ] Ready for production

---

## 📊 Progress Tracking

**Total Steps:** 95
**Completed:** 3 (3.2%)
**Current Phase:** Phase 1 - Foundation
**Current Step:** 1.1 - Add Required Dependencies

**Estimated Timeline:**
- Phase 1 (Foundation): 2 weeks
- Phase 2 (Authentication): 1 week
- Phase 3 (Dashboard): 2 weeks
- Phase 4 (Docker): 1 week
- Phase 5 (Other Features): 3 weeks
- Phase 6 (Cleanup): 1 week
**Total:** ~10 weeks (2.5 months)

---

## 🎯 Current Task Details

### Step 1.1: Add Required Dependencies

**What to do:**
1. Add new packages to pubspec.yaml
2. Run flutter pub get
3. Verify no conflicts
4. Test that app still runs

**New dependencies to add:**
```yaml
dependencies:
  flutter_bloc: ^8.1.6
  equatable: ^2.0.7
  dartz: ^0.10.1
  get_it: ^8.0.3
  injectable: ^2.5.0
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0

dev_dependencies:
  bloc_test: ^9.1.7
  mocktail: ^1.0.4
  build_runner: ^2.4.13
  freezed: ^2.5.7
  json_serializable: ^6.8.0
  injectable_generator: ^2.6.2
```

**Expected outcome:**
- ✅ pubspec.yaml updated
- ✅ No dependency conflicts
- ✅ App still runs
- ✅ Ready for next step

**Branch:** develop (working directly for now)

---

## 📝 Notes

- Never commit AI-generated docs (handled in .gitignore)
- Create feature branches locally (never push to GitHub)
- Merge to develop locally after each feature complete
- Keep files < 200 lines
- Write tests as you go
- Follow VGV patterns strictly
