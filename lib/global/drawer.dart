import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unmobile/global/routes.dart';
import 'package:unmobile/notifiers/auth_state.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String _selectedServer = '';
  AuthState? _state;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _state = Provider.of<AuthState>(context, listen: false);
    if (_state!.client != null) {
      _state!.client!.resetStore();
      _selectedServer = _state!.getSelectedServerIp() ?? '';
    }
    // Determine current route and set selected index
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSelectedIndex();
    });
  }

  void _updateSelectedIndex() {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    setState(() {
      switch (currentRoute) {
        case Routes.dashboard:
          _selectedIndex = 0;
          break;
        case Routes.array:
          _selectedIndex = 1;
          break;
        case Routes.shares:
          _selectedIndex = 2;
          break;
        case Routes.dockers:
          _selectedIndex = 3;
          break;
        case Routes.vms:
          _selectedIndex = 4;
          break;
        case Routes.system:
          _selectedIndex = 5;
          break;
        case Routes.plugins:
          _selectedIndex = 6;
          break;
        case Routes.settings:
          _selectedIndex = 7;
          break;
        default:
          _selectedIndex = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthState state = Provider.of<AuthState>(context, listen: false);
    final colorScheme = Theme.of(context).colorScheme;

    return NavigationDrawer(
      selectedIndex: _selectedIndex,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.primaryContainer,
                colorScheme.secondaryContainer,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surface.withAlpha(230),
                  shape: BoxShape.circle,
                ),
                child: FaIcon(
                  FontAwesomeIcons.userAstronaut,
                  size: 32,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                state.userData?["name"] ?? 'Unknown User',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.surface.withAlpha(179),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  (state.userData?["roles"] is List && 
                      (state.userData?["roles"]?.isNotEmpty ?? false))
                      ? state.userData!["roles"][0]
                      : "No Role",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Consumer<AuthState>(builder: (context, authState, child) {
                if (authState.client == null) {
                  return SizedBox.shrink();
                }
                final servers = authState.getMultiservers();
                if (servers.isEmpty) {
                  return SizedBox.shrink();
                }

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withAlpha(230),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    isDense: true,
                    value: _selectedServer,
                    dropdownColor: colorScheme.surface,
                    icon: Icon(Icons.arrow_drop_down, color: colorScheme.onSurface),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                    underline: Container(height: 0),
                    items: [
                      for (var server in servers)
                        DropdownMenuItem<String>(
                          value: server['ip'],
                          child: Text(
                            server['ip'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        )
                    ],
                    onChanged: (String? newValue) async {
                      if (newValue != null && newValue != _selectedServer) {
                        try {
                          await state.switchMultiserver(newValue);
                          _selectedServer = newValue;
                          Navigator.of(context).pushReplacementNamed(Routes.dashboard);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: colorScheme.primaryContainer,
                              content: Text(
                                'Server switched to $newValue',
                                style: TextStyle(color: colorScheme.onPrimaryContainer),
                              ),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        } on AuthException catch (e) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: colorScheme.errorContainer,
                              content: Text(
                                e.msg,
                                style: TextStyle(color: colorScheme.onErrorContainer),
                              ),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: colorScheme.errorContainer,
                              content: Text(
                                'Failed to switch server',
                                style: TextStyle(color: colorScheme.onErrorContainer),
                              ),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      }
                    },
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 12),
        NavigationDrawerDestination(
          icon: FaIcon(FontAwesomeIcons.gauge, size: 20),
          label: Text('Dashboard'),
        ),
        NavigationDrawerDestination(
          icon: FaIcon(FontAwesomeIcons.hardDrive, size: 20),
          label: Text('Array'),
        ),
        NavigationDrawerDestination(
          icon: FaIcon(FontAwesomeIcons.folder, size: 20),
          label: Text('Shares'),
        ),
        NavigationDrawerDestination(
          icon: FaIcon(FontAwesomeIcons.docker, size: 20),
          label: Text('Docker Containers'),
        ),
        NavigationDrawerDestination(
          icon: FaIcon(FontAwesomeIcons.desktop, size: 20),
          label: Text('Virtual Machines'),
        ),
        NavigationDrawerDestination(
          icon: FaIcon(FontAwesomeIcons.server, size: 20),
          label: Text('System Info'),
        ),
        NavigationDrawerDestination(
          icon: FaIcon(FontAwesomeIcons.puzzlePiece, size: 20),
          label: Text('Plugins'),
        ),
        const Divider(height: 32),
        NavigationDrawerDestination(
          icon: FaIcon(FontAwesomeIcons.gear, size: 20),
          label: Text('Settings'),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.tonalIcon(
            icon: FaIcon(FontAwesomeIcons.arrowRightFromBracket, size: 18),
            label: Text('Logout'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    icon: Icon(Icons.logout, size: 32),
                    title: const Text('Logout'),
                    content: const Text('Do you really want to logout?'),
                    actions: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FilledButton(
                        child: const Text('Logout'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          state.logout();
                        },
                      )
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
      onDestinationSelected: (int index) {
        setState(() {
          _selectedIndex = index;
        });
        
        switch (index) {
          case 0:
            Navigator.of(context).pushReplacementNamed(Routes.dashboard);
            break;
          case 1:
            Navigator.of(context).pushNamed(Routes.array);
            break;
          case 2:
            Navigator.of(context).pushNamed(Routes.shares);
            break;
          case 3:
            Navigator.of(context).pushNamed(Routes.dockers);
            break;
          case 4:
            Navigator.of(context).pushNamed(Routes.vms);
            break;
          case 5:
            Navigator.of(context).pushNamed(Routes.system);
            break;
          case 6:
            Navigator.of(context).pushNamed(Routes.plugins);
            break;
          case 7:
            Navigator.of(context).pushNamed(Routes.settings);
            break;
        }
      },
    );
  }
}
