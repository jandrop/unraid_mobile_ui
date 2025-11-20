# Quick Start: VGV Architecture Implementation

## Step-by-Step Guide to Get Started

### Prerequisites

Update `pubspec.yaml`:

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

Run: `flutter pub get`

---

## Phase 1: Setup Foundation (Day 1)

### Step 1: Create Directory Structure

```bash
mkdir -p lib/core/{network,error,storage,di,utils}
mkdir -p lib/features/authentication/{data/{datasources,models,repositories},domain/{entities,repositories,usecases},presentation/{bloc,pages,widgets}}
mkdir -p test/core
mkdir -p test/features/authentication/{data,domain,presentation}
```

### Step 2: Create Core Error Handling

**File: `lib/core/error/failures.dart`**
```dart
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error occurred']) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network connection failed']) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error occurred']) : super(message);
}

class AuthFailure extends Failure {
  const AuthFailure([String message = 'Authentication failed']) : super(message);
}
```

**File: `lib/core/error/exceptions.dart`**
```dart
class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server error occurred']);
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Network connection failed']);
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Cache error occurred']);
}

class AuthException implements Exception {
  final String message;
  AuthException([this.message = 'Authentication failed']);
}
```

### Step 3: Create Network Client

**File: `lib/core/network/graphql_client.dart`**
```dart
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/io_client.dart';
import 'dart:io';

class AppGraphQLClient {
  GraphQLClient? _client;
  
  GraphQLClient? get client => _client;
  
  void initialize({
    required String host,
    required String protocol,
    required String token,
  }) {
    final httpClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    final ioClient = IOClient(httpClient);
    
    final httpLink = HttpLink(
      '$protocol://$host/graphql',
      httpClient: ioClient,
    );
    
    final authLink = AuthLink(
      getToken: () async => 'Bearer $token',
    );
    
    final link = authLink.concat(httpLink);
    
    _client = GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: link,
    );
  }
  
  void dispose() {
    _client = null;
  }
}
```

### Step 4: Setup Dependency Injection

**File: `lib/core/di/injection.dart`**
```dart
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/graphql_client.dart';
import '../storage/secure_storage.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  
  // Core
  getIt.registerLazySingleton(() => AppGraphQLClient());
  getIt.registerLazySingleton(() => SecureStorage(getIt()));
  
  // Features will be registered here
}
```

**File: `lib/core/storage/secure_storage.dart`**
```dart
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorage {
  final SharedPreferences _prefs;
  
  SecureStorage(this._prefs);
  
  Future<void> saveToken(String token) async {
    await _prefs.setString('auth_token', token);
  }
  
  Future<String?> getToken() async {
    return _prefs.getString('auth_token');
  }
  
  Future<void> deleteToken() async {
    await _prefs.remove('auth_token');
  }
  
  Future<void> saveServerConfig({
    required String host,
    required String protocol,
  }) async {
    await _prefs.setString('server_host', host);
    await _prefs.setString('server_protocol', protocol);
  }
  
  Future<Map<String, String>?> getServerConfig() async {
    final host = _prefs.getString('server_host');
    final protocol = _prefs.getString('server_protocol');
    
    if (host != null && protocol != null) {
      return {'host': host, 'protocol': protocol};
    }
    return null;
  }
}
```

### Step 5: Update main.dart

**File: `lib/main.dart`**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Setup dependency injection
  await setupDependencies();
  
  runApp(const MyApp());
}
```

**File: `lib/app/app.dart`**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/di/injection.dart';
import 'theme/app_theme.dart';
import 'routes/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'unConnect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      initialRoute: AppRoutes.splash,
    );
  }
}
```

---

## Phase 2: Implement Authentication Feature (Day 2-3)

### Step 1: Create Domain Layer

**File: `lib/features/authentication/domain/entities/user.dart`**
```dart
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  
  const User({
    required this.id,
    required this.name,
    required this.email,
  });
  
  @override
  List<Object?> get props => [id, name, email];
}
```

**File: `lib/features/authentication/domain/repositories/auth_repository.dart`**
```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String host,
    required String protocol,
    required String username,
    required String password,
  });
  
  Future<Either<Failure, Unit>> logout();
  
  Future<Either<Failure, User>> getCurrentUser();
  
  Future<Either<Failure, bool>> isAuthenticated();
}
```

**File: `lib/features/authentication/domain/usecases/login.dart`**
```dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class Login {
  final AuthRepository repository;
  
  Login(this.repository);
  
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(
      host: params.host,
      protocol: params.protocol,
      username: params.username,
      password: params.password,
    );
  }
}

class LoginParams extends Equatable {
  final String host;
  final String protocol;
  final String username;
  final String password;
  
  const LoginParams({
    required this.host,
    required this.protocol,
    required this.username,
    required this.password,
  });
  
  @override
  List<Object?> get props => [host, protocol, username, password];
}
```

**Similarly create:**
- `logout.dart`
- `get_current_user.dart`
- `is_authenticated.dart`

### Step 2: Create Data Layer

**File: `lib/features/authentication/data/models/user_model.dart`**
```dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User {
  const UserModel({
    required String id,
    required String name,
    required String email,
  }) : super(id: id, name: name, email: email);
  
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  
  User toEntity() => User(id: id, name: name, email: email);
}
```

Run: `flutter pub run build_runner build --delete-conflicting-outputs`

**File: `lib/features/authentication/data/datasources/auth_remote_datasource.dart`**
```dart
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/graphql_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String host,
    required String protocol,
    required String username,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AppGraphQLClient client;
  
  AuthRemoteDataSourceImpl(this.client);
  
  @override
  Future<UserModel> login({
    required String host,
    required String protocol,
    required String username,
    required String password,
  }) async {
    // Initialize client with credentials
    client.initialize(
      host: host,
      protocol: protocol,
      token: '', // Will be set after login
    );
    
    const String loginMutation = '''
      mutation Login(\$username: String!, \$password: String!) {
        login(username: \$username, password: \$password) {
          token
          user {
            id
            name
            email
          }
        }
      }
    ''';
    
    try {
      final result = await client.client!.mutate(
        MutationOptions(
          document: gql(loginMutation),
          variables: {
            'username': username,
            'password': password,
          },
        ),
      );
      
      if (result.hasException) {
        throw ServerException(result.exception.toString());
      }
      
      final userData = result.data!['login']['user'];
      return UserModel.fromJson(userData);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
```

**File: `lib/features/authentication/data/datasources/auth_local_datasource.dart`**
```dart
import '../../../../core/error/exceptions.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel> getCachedUser();
  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorage storage;
  
  AuthLocalDataSourceImpl(this.storage);
  
  @override
  Future<void> cacheUser(UserModel user) async {
    // Implementation
  }
  
  @override
  Future<UserModel> getCachedUser() async {
    // Implementation
    throw CacheException();
  }
  
  @override
  Future<void> clearCache() async {
    await storage.deleteToken();
  }
}
```

**File: `lib/features/authentication/data/repositories/auth_repository_impl.dart`**
```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  
  @override
  Future<Either<Failure, User>> login({
    required String host,
    required String protocol,
    required String username,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.login(
        host: host,
        protocol: protocol,
        username: username,
        password: password,
      );
      await localDataSource.cacheUser(userModel);
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await localDataSource.clearCache();
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
  
  // Implement other methods...
}
```

### Step 3: Create Presentation Layer

**File: `lib/features/authentication/presentation/bloc/auth_event.dart`**
```dart
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  
  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String host;
  final String protocol;
  final String username;
  final String password;
  
  const AuthLoginRequested({
    required this.host,
    required this.protocol,
    required this.username,
    required this.password,
  });
  
  @override
  List<Object?> get props => [host, protocol, username, password];
}

class AuthLogoutRequested extends AuthEvent {}
```

**File: `lib/features/authentication/presentation/bloc/auth_state.dart`**
```dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  
  const AuthAuthenticated(this.user);
  
  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  
  const AuthError(this.message);
  
  @override
  List<Object?> get props => [message];
}
```

**File: `lib/features/authentication/presentation/bloc/auth_bloc.dart`**
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/is_authenticated.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login loginUseCase;
  final Logout logoutUseCase;
  final IsAuthenticated isAuthenticatedUseCase;
  
  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.isAuthenticatedUseCase,
  }) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }
  
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await isAuthenticatedUseCase();
    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (isAuth) => isAuth
          ? emit(AuthAuthenticated(/* cached user */))
          : emit(AuthUnauthenticated()),
    );
  }
  
  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await loginUseCase(LoginParams(
      host: event.host,
      protocol: event.protocol,
      username: event.username,
      password: event.password,
    ));
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }
  
  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await logoutUseCase();
    emit(AuthUnauthenticated());
  }
}
```

**File: `lib/features/authentication/presentation/pages/login_page.dart`**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>(),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacementNamed('/dashboard');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return const LoginForm();
          },
        ),
      ),
    );
  }
}
```

### Step 4: Register Dependencies

**Update: `lib/core/di/injection.dart`**
```dart
// Add to setupDependencies():

  // Auth Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(getIt()),
  );
  
  // Auth Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );
  
  // Auth Use Cases
  getIt.registerLazySingleton(() => Login(getIt()));
  getIt.registerLazySingleton(() => Logout(getIt()));
  getIt.registerLazySingleton(() => IsAuthenticated(getIt()));
  
  // Auth BLoC
  getIt.registerFactory(
    () => AuthBloc(
      loginUseCase: getIt(),
      logoutUseCase: getIt(),
      isAuthenticatedUseCase: getIt(),
    ),
  );
```

---

## Phase 3: Testing (Day 4)

### Example Test Files

**File: `test/features/authentication/domain/usecases/login_test.dart`**
```dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late Login usecase;
  late MockAuthRepository mockRepository;
  
  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = Login(mockRepository);
  });
  
  const tUser = User(id: '1', name: 'Test', email: 'test@example.com');
  const tParams = LoginParams(
    host: 'localhost',
    protocol: 'http',
    username: 'admin',
    password: 'password',
  );
  
  test('should return User when login is successful', () async {
    // arrange
    when(() => mockRepository.login(
          host: any(named: 'host'),
          protocol: any(named: 'protocol'),
          username: any(named: 'username'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => const Right(tUser));
    
    // act
    final result = await usecase(tParams);
    
    // assert
    expect(result, const Right(tUser));
    verify(() => mockRepository.login(
          host: tParams.host,
          protocol: tParams.protocol,
          username: tParams.username,
          password: tParams.password,
        )).called(1);
  });
}
```

**File: `test/features/authentication/presentation/bloc/auth_bloc_test.dart`**
```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late AuthBloc authBloc;
  late MockLogin mockLogin;
  late MockLogout mockLogout;
  late MockIsAuthenticated mockIsAuthenticated;
  
  setUp(() {
    mockLogin = MockLogin();
    mockLogout = MockLogout();
    mockIsAuthenticated = MockIsAuthenticated();
    authBloc = AuthBloc(
      loginUseCase: mockLogin,
      logoutUseCase: mockLogout,
      isAuthenticatedUseCase: mockIsAuthenticated,
    );
  });
  
  const tUser = User(id: '1', name: 'Test', email: 'test@example.com');
  
  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, AuthAuthenticated] when login is successful',
    build: () {
      when(() => mockLogin(any())).thenAnswer(
        (_) async => const Right(tUser),
      );
      return authBloc;
    },
    act: (bloc) => bloc.add(const AuthLoginRequested(
      host: 'localhost',
      protocol: 'http',
      username: 'admin',
      password: 'password',
    )),
    expect: () => [
      AuthLoading(),
      const AuthAuthenticated(tUser),
    ],
  );
  
  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, AuthError] when login fails',
    build: () {
      when(() => mockLogin(any())).thenAnswer(
        (_) async => const Left(AuthFailure('Invalid credentials')),
      );
      return authBloc;
    },
    act: (bloc) => bloc.add(const AuthLoginRequested(
      host: 'localhost',
      protocol: 'http',
      username: 'admin',
      password: 'wrong',
    )),
    expect: () => [
      AuthLoading(),
      const AuthError('Invalid credentials'),
    ],
  );
}
```

---

## Next Steps

1. ✅ Run `flutter pub get`
2. ✅ Run `flutter pub run build_runner build`
3. ✅ Run tests: `flutter test`
4. ✅ Build app: `flutter run`

Then continue with:
- Dashboard feature
- Docker feature
- Other features

Follow the same pattern for each feature! 🎉
