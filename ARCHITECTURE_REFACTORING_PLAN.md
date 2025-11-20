# Architecture Refactoring Plan - VGV Engineering Standards

## Current Architecture Analysis

### Current Structure
```
lib/
├── main.dart                    # Entry point with providers
├── screens/                     # UI layer (mixed concerns)
│   ├── dashboard.dart          # 1400+ lines, multiple responsibilities
│   ├── login.dart
│   ├── dockers.dart
│   ├── array.dart
│   └── ...
├── notifiers/                   # State management
│   ├── auth_state.dart         # Auth + GraphQL client + storage
│   └── theme_mode.dart
└── global/                      # Shared code
    ├── queries.dart            # GraphQL queries as strings
    ├── mutations.dart
    ├── subscriptions.dart
    ├── routes.dart
    └── drawer.dart
```

### Current Issues

#### 1. **Lack of Layer Separation**
- ❌ UI directly calls GraphQL client
- ❌ Business logic mixed in widget code
- ❌ No clear data layer
- ❌ State management tightly coupled to UI

#### 2. **No Repository Pattern**
- ❌ GraphQL queries embedded in UI
- ❌ No abstraction for data sources
- ❌ Hard to test and mock
- ❌ Difficult to swap data sources

#### 3. **Monolithic Widgets**
- ❌ Dashboard: 1400+ lines
- ❌ Multiple responsibilities per widget
- ❌ Hard to maintain and test
- ❌ Difficult to reuse components

#### 4. **State Management Issues**
- ❌ Direct Provider usage everywhere
- ❌ No clear state pattern (BLoC/Cubit)
- ❌ Mixing local and global state
- ❌ No state events/actions pattern

#### 5. **No Domain Layer**
- ❌ No models/entities
- ❌ No use cases/interactors
- ❌ Business logic in UI
- ❌ No validation logic separation

#### 6. **Testing Challenges**
- ❌ Widgets tightly coupled to services
- ❌ No dependency injection
- ❌ Hard to mock dependencies
- ❌ Limited test coverage possible

---

## VGV Architecture Best Practices

### Recommended Structure (Feature-First + Layered)

```
lib/
├── app/                         # App initialization
│   ├── app.dart                # MaterialApp widget
│   ├── routes/                 # App routing
│   │   ├── routes.dart
│   │   └── routes.g.dart
│   └── theme/                  # Theme configuration
│       ├── app_theme.dart
│       └── theme.dart
├── core/                        # Shared across features
│   ├── network/                # Network client
│   │   ├── graphql_client.dart
│   │   └── network_info.dart
│   ├── error/                  # Error handling
│   │   ├── failures.dart
│   │   └── exceptions.dart
│   ├── storage/                # Local storage
│   │   └── secure_storage.dart
│   └── utils/                  # Utilities
│       ├── validators.dart
│       └── extensions.dart
├── features/                    # Feature modules
│   ├── authentication/
│   │   ├── data/               # Data layer
│   │   │   ├── datasources/
│   │   │   │   ├── auth_remote_datasource.dart
│   │   │   │   └── auth_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/             # Domain layer
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── login.dart
│   │   │       ├── logout.dart
│   │   │       └── get_user.dart
│   │   └── presentation/       # Presentation layer
│   │       ├── bloc/
│   │       │   ├── auth_bloc.dart
│   │       │   ├── auth_event.dart
│   │       │   └── auth_state.dart
│   │       ├── pages/
│   │       │   └── login_page.dart
│   │       └── widgets/
│   │           ├── login_form.dart
│   │           └── protocol_selector.dart
│   ├── dashboard/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── dashboard_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── server_info_model.dart
│   │   │   │   ├── array_info_model.dart
│   │   │   │   └── system_metrics_model.dart
│   │   │   └── repositories/
│   │   │       └── dashboard_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── server_info.dart
│   │   │   │   ├── array_info.dart
│   │   │   │   └── system_metrics.dart
│   │   │   ├── repositories/
│   │   │   │   └── dashboard_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_server_info.dart
│   │   │       ├── get_array_info.dart
│   │   │       └── subscribe_to_metrics.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── dashboard_bloc.dart
│   │       │   ├── dashboard_event.dart
│   │       │   └── dashboard_state.dart
│   │       ├── pages/
│   │       │   └── dashboard_page.dart
│   │       └── widgets/
│   │           ├── server_card.dart
│   │           ├── array_card.dart
│   │           ├── system_card.dart
│   │           └── metric_chart.dart
│   ├── docker/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── ... (other features)
└── main.dart                    # Entry point
```

---

## Key Principles

### 1. **Clean Architecture Layers**

#### Presentation Layer (UI)
- **Responsibility**: Display data and handle user input
- **Components**: Pages, Widgets, BLoC/Cubit
- **Dependencies**: Domain layer only
- **No**: Direct data access, business logic

#### Domain Layer (Business Logic)
- **Responsibility**: Core business rules and entities
- **Components**: Entities, Use Cases, Repository Interfaces
- **Dependencies**: None (pure Dart)
- **No**: Framework dependencies, platform code

#### Data Layer (Data Management)
- **Responsibility**: Data retrieval and persistence
- **Components**: Repository Implementations, Data Sources, Models
- **Dependencies**: Domain layer
- **No**: UI dependencies

### 2. **Dependency Rule**
```
Presentation → Domain ← Data
     ↓           ↑         ↑
   Depends    Abstract  Implements
```

### 3. **BLoC Pattern for State Management**
- Events: User actions
- States: UI states
- BLoC: Business logic
- Separation of concerns

### 4. **Repository Pattern**
- Abstract repository in domain
- Implementation in data layer
- Easy to test and mock
- Swap implementations easily

### 5. **Use Cases (Interactors)**
- Single responsibility
- Reusable business logic
- Easy to test
- Clear intent

---

## Refactoring Roadmap

### Phase 1: Foundation (Week 1-2)

#### 1.1 Setup Core Infrastructure
- [ ] Create `core/` directory structure
- [ ] Extract GraphQL client to `core/network/`
- [ ] Create error handling framework
- [ ] Setup dependency injection (get_it)
- [ ] Create storage abstraction

**Files to Create:**
```dart
// core/network/graphql_client.dart
class AppGraphQLClient {
  final HttpLink httpLink;
  final AuthLink authLink;
  GraphQLClient get client => ...;
}

// core/error/failures.dart
abstract class Failure {
  final String message;
}

class ServerFailure extends Failure {}
class NetworkFailure extends Failure {}
class AuthFailure extends Failure {}

// core/di/injection.dart
final getIt = GetIt.instance;

void setupDependencies() {
  // Register dependencies
}
```

#### 1.2 Setup Testing Infrastructure
- [ ] Add bloc_test, mocktail packages
- [ ] Create test helpers
- [ ] Setup test directory structure

### Phase 2: Authentication Feature (Week 2-3)

#### 2.1 Create Domain Layer
```dart
// features/authentication/domain/entities/user.dart
class User {
  final String name;
  final String email;
  // Pure business entity
}

// features/authentication/domain/repositories/auth_repository.dart
abstract class AuthRepository {
  Future<Either<Failure, User>> login(String host, String username, String password);
  Future<Either<Failure, Unit>> logout();
  Future<Either<Failure, User>> getCurrentUser();
}

// features/authentication/domain/usecases/login.dart
class Login {
  final AuthRepository repository;
  
  Future<Either<Failure, User>> call(LoginParams params) {
    return repository.login(params.host, params.username, params.password);
  }
}
```

#### 2.2 Create Data Layer
```dart
// features/authentication/data/datasources/auth_remote_datasource.dart
abstract class AuthRemoteDataSource {
  Future<UserModel> login(String host, String username, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AppGraphQLClient client;
  
  @override
  Future<UserModel> login(...) async {
    // GraphQL mutation
  }
}

// features/authentication/data/repositories/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  
  @override
  Future<Either<Failure, User>> login(...) async {
    try {
      final userModel = await remoteDataSource.login(...);
      await localDataSource.cacheUser(userModel);
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
```

#### 2.3 Create Presentation Layer
```dart
// features/authentication/presentation/bloc/auth_bloc.dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login loginUseCase;
  final Logout logoutUseCase;
  
  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }
  
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await loginUseCase(LoginParams(...));
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }
}

// features/authentication/presentation/pages/login_page.dart
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(context, '/dashboard');
          }
        },
        child: LoginView(),
      ),
    );
  }
}
```

#### 2.4 Write Tests
```dart
// test/features/authentication/domain/usecases/login_test.dart
void main() {
  late Login usecase;
  late MockAuthRepository mockRepository;
  
  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = Login(mockRepository);
  });
  
  test('should return User when login is successful', () async {
    // arrange
    when(() => mockRepository.login(any(), any(), any()))
        .thenAnswer((_) async => Right(tUser));
    
    // act
    final result = await usecase(tLoginParams);
    
    // assert
    expect(result, Right(tUser));
    verify(() => mockRepository.login(any(), any(), any()));
  });
}

// test/features/authentication/presentation/bloc/auth_bloc_test.dart
void main() {
  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, AuthAuthenticated] when login is successful',
    build: () {
      when(() => mockLoginUseCase(any()))
          .thenAnswer((_) async => Right(tUser));
      return AuthBloc(loginUseCase: mockLoginUseCase);
    },
    act: (bloc) => bloc.add(LoginRequested(...)),
    expect: () => [
      AuthLoading(),
      AuthAuthenticated(tUser),
    ],
  );
}
```

### Phase 3: Dashboard Feature (Week 3-4)

#### 3.1 Break Down Dashboard
- [ ] Create server info feature
- [ ] Create array info feature
- [ ] Create system metrics feature
- [ ] Create parity check feature
- [ ] Create UPS monitoring feature

#### 3.2 Implement Each Sub-Feature
Following same pattern:
1. Domain entities and use cases
2. Data models and repositories
3. BLoC for state management
4. UI widgets (small, focused)
5. Unit and widget tests

#### 3.3 Create Composite Dashboard
```dart
// features/dashboard/presentation/pages/dashboard_page.dart
class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ServerInfoBloc>()..add(LoadServerInfo())),
        BlocProvider(create: (_) => getIt<ArrayInfoBloc>()..add(LoadArrayInfo())),
        BlocProvider(create: (_) => getIt<SystemMetricsBloc>()..add(SubscribeToMetrics())),
      ],
      child: DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ServerInfoBloc>().add(RefreshServerInfo());
          context.read<ArrayInfoBloc>().add(RefreshArrayInfo());
        },
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            ServerInfoCard(),      // Independent widget with BLoC
            ArrayInfoCard(),       // Independent widget with BLoC
            SystemMetricsCard(),   // Independent widget with BLoC
            ParityCheckCard(),     // Independent widget with BLoC
            UpsMonitorCard(),      // Independent widget with BLoC
          ],
        ),
      ),
    );
  }
}
```

### Phase 4: Other Features (Week 4-6)

Following the same pattern, refactor:
- [ ] Docker containers feature
- [ ] Virtual machines feature
- [ ] Array management feature
- [ ] System information feature
- [ ] Plugins feature
- [ ] Settings feature

### Phase 5: Polish & Optimization (Week 6-7)

#### 5.1 Performance
- [ ] Implement proper caching strategy
- [ ] Add offline support
- [ ] Optimize subscriptions
- [ ] Lazy loading for lists

#### 5.2 Error Handling
- [ ] Consistent error messages
- [ ] Retry mechanisms
- [ ] Offline mode indicators
- [ ] Connection status monitoring

#### 5.3 Testing
- [ ] Achieve 80%+ code coverage
- [ ] Integration tests
- [ ] Widget tests for all features
- [ ] E2E tests for critical flows

#### 5.4 Documentation
- [ ] Architecture documentation
- [ ] Feature documentation
- [ ] API documentation
- [ ] Contributing guidelines

---

## Migration Strategy

### Approach: Incremental Migration (Strangler Fig Pattern)

1. **New features use new architecture**
2. **Existing features migrate one-by-one**
3. **Old and new coexist temporarily**
4. **No big-bang rewrite**

### Migration Order (Priority)
1. ✅ Authentication (critical, isolated)
2. ✅ Dashboard (high visibility, complex)
3. ✅ Docker (frequently used)
4. ⚠️ Arrays (less critical, can wait)
5. ⚠️ System info (low priority)
6. ⚠️ Settings (low priority)

### Compatibility Layer
```dart
// lib/legacy/
// Keep old code working while migrating
// Remove after full migration
```

---

## Benefits of VGV Architecture

### 1. **Testability**
- ✅ Pure business logic (easy to test)
- ✅ Mocked dependencies
- ✅ Isolated components
- ✅ High test coverage possible

### 2. **Maintainability**
- ✅ Clear separation of concerns
- ✅ Single responsibility
- ✅ Easy to find code
- ✅ Consistent patterns

### 3. **Scalability**
- ✅ Add features without affecting others
- ✅ Team can work in parallel
- ✅ Clear boundaries
- ✅ Easy to refactor parts

### 4. **Flexibility**
- ✅ Swap implementations easily
- ✅ Change UI without touching logic
- ✅ Change data source without UI changes
- ✅ Platform-independent business logic

### 5. **Code Quality**
- ✅ SOLID principles
- ✅ Clean code
- ✅ Clear dependencies
- ✅ Professional standard

---

## Required Packages

Add to `pubspec.yaml`:

```yaml
dependencies:
  # State Management
  flutter_bloc: ^8.1.6
  equatable: ^2.0.7
  
  # Functional Programming
  dartz: ^0.10.1
  
  # Dependency Injection
  get_it: ^8.0.3
  injectable: ^2.5.0
  
  # Code Generation
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0

dev_dependencies:
  # Testing
  bloc_test: ^9.1.7
  mocktail: ^1.0.4
  
  # Code Generation
  build_runner: ^2.4.13
  freezed: ^2.5.7
  json_serializable: ^6.8.0
  injectable_generator: ^2.6.2
```

---

## Success Metrics

### Code Quality
- [ ] Test coverage > 80%
- [ ] Zero analyzer warnings
- [ ] Lint score: 100/100
- [ ] Clear code organization

### Performance
- [ ] App startup < 2s
- [ ] Page transitions < 300ms
- [ ] Memory usage < 100MB
- [ ] Smooth 60fps animations

### Developer Experience
- [ ] Easy to add new features
- [ ] Clear patterns to follow
- [ ] Good documentation
- [ ] Fast feedback loop (tests)

---

## Conclusion

This architecture refactoring will transform the unConnect app into a professional, maintainable, and scalable application following VGV Engineering best practices. The incremental approach ensures we can deliver value continuously while improving the codebase.

**Estimated Timeline**: 6-7 weeks
**Risk Level**: Medium (incremental approach reduces risk)
**ROI**: High (improved maintainability, testability, scalability)

**Next Step**: Start with Phase 1 - Foundation setup
