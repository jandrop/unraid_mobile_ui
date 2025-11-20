import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unmobile/global/mutations.dart';
import 'package:unmobile/notifiers/auth_state.dart';
import 'package:unmobile/global/queries.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';

class DockersPage extends StatefulWidget {
  const DockersPage({Key? key}) : super(key: key);

  @override
  _MyDockersPageState createState() => _MyDockersPageState();
}

class _MyDockersPageState extends State<DockersPage> {
  AuthState? _state;
  Future<QueryResult>? _allDockers;

  @override
  void initState() {
    super.initState();
    _state = Provider.of<AuthState>(context, listen: false);
    if(_state!.client != null) {
      _state!.client!.resetStore();
      getAllDockers();
    }
  }

  void getAllDockers() async {
    _allDockers = _state!.client!.query(QueryOptions(
      document: gql(Queries.getDockers),
      queryRequestTimeout: const Duration(seconds: 60),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Docker Containers',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            if (_state!.client != null) {
              _state!.client!.resetStore();
              getAllDockers();
              setState(() {});
            }
          },
          child: showDockersContent(),
        ));
  }

  Widget showDockersContent() {
    return FutureBuilder<QueryResult>(
        future: _allDockers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                ],
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.data != null) {
            final result = snapshot.data!;
            final containers = result.data!['docker']['containers'];
            
            if (containers.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.docker, size: 64, color: Theme.of(context).colorScheme.outline),
                    const SizedBox(height: 16),
                    Text(
                      'No containers found',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: containers.length,
                itemBuilder: (context, index) {
                  Map docker = containers[index];
                  bool running = docker['state'] == 'RUNNING';
                  String name = docker['names'][0];

                  if (name.startsWith('/')) {
                    name = name.substring(1);
                  }

                  return _buildDockerCard(docker, name, running);
                });
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.docker, size: 64, color: Theme.of(context).colorScheme.outline),
                  const SizedBox(height: 16),
                  Text('No data available'),
                ],
              ),
            );
          }
        });
  }

  Widget _buildDockerCard(Map docker, String name, bool running) {
    final colorScheme = Theme.of(context).colorScheme;
    final isHealthy = docker['status'] != null && 
                      docker['status'].toString().contains('healthy');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showDockerActions(docker, name, running),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Docker Icon
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: running 
                        ? colorScheme.primaryContainer 
                        : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: docker['labels']['net.unraid.docker.icon'] != null &&
                              docker['labels']['net.unraid.docker.icon']
                                  .toString()
                                  .startsWith('http')
                          ? Image.network(
                              docker['labels']['net.unraid.docker.icon'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.docker,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                            )
                          : Center(
                              child: FaIcon(
                                FontAwesomeIcons.docker,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Container Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildStatusChip(running, isHealthy),
                            if (isHealthy) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: colorScheme.tertiaryContainer,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.heartPulse,
                                      size: 12,
                                      color: colorScheme.onTertiaryContainer,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Healthy',
                                      style: TextStyle(
                                        color: colorScheme.onTertiaryContainer,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Action Button
                  IconButton.filledTonal(
                    icon: FaIcon(
                      running ? FontAwesomeIcons.stop : FontAwesomeIcons.play,
                      size: 18,
                    ),
                    onPressed: () => _toggleDocker(docker, running),
                    tooltip: running ? 'Stop container' : 'Start container',
                  ),
                ],
              ),
              if (docker['image'] != null) ...[
                const SizedBox(height: 12),
                Divider(color: colorScheme.outlineVariant),
                const SizedBox(height: 12),
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.layerGroup,
                      size: 14,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        docker['image'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(bool running, bool isHealthy) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: running 
          ? colorScheme.primaryContainer 
          : colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: running ? colorScheme.primary : colorScheme.error,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            running ? 'Running' : 'Stopped',
            style: TextStyle(
              color: running 
                ? colorScheme.onPrimaryContainer 
                : colorScheme.onErrorContainer,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showDockerActions(Map docker, String name, bool running) {
    showAdaptiveActionSheet(
      context: context,
      title: Text(name),
      actions: <BottomSheetAction>[
        BottomSheetAction(
          title: Row(
            children: [
              FaIcon(
                running ? FontAwesomeIcons.stop : FontAwesomeIcons.play,
                size: 18,
              ),
              const SizedBox(width: 12),
              Text(running ? 'Stop Container' : 'Start Container'),
            ],
          ),
          onPressed: (_) async {
            Navigator.of(context).pop();
            await _toggleDocker(docker, running);
          },
        )
      ],
      cancelAction: CancelAction(title: const Text('Cancel')),
    );
  }

  Future<void> _toggleDocker(Map docker, bool running) async {
    final colorScheme = Theme.of(context).colorScheme;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(running ? 'Stopping container...' : 'Starting container...'),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (docker['id'].contains(':')) {
      docker['id'] = docker['id'].split(':')[1];
    }

    QueryResult result;
    try {
      if (running) {
        result = await _state!.client!.mutate(MutationOptions(
            document: gql(Mutations.stopDocker),
            queryRequestTimeout: Duration(seconds: 30),
            variables: {
              "dockerId": "${docker['id']}",
            }));
        docker['state'] = result.data!['docker']['stop']['state'];
      } else {
        result = await _state!.client!.mutate(MutationOptions(
            document: gql(Mutations.startDocker),
            queryRequestTimeout: Duration(seconds: 30),
            variables: {
              "dockerId": "${docker['id']}",
            }));
        docker['state'] = result.data!['docker']['start']['state'];
      }
      
      Navigator.of(context).pop();
      
      setState(() {});
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: colorScheme.primaryContainer,
          content: Row(
            children: [
              Icon(Icons.check_circle, color: colorScheme.onPrimaryContainer),
              const SizedBox(width: 12),
              Text(
                running ? 'Container stopped' : 'Container started',
                style: TextStyle(color: colorScheme.onPrimaryContainer),
              ),
            ],
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: colorScheme.errorContainer,
          content: Row(
            children: [
              Icon(Icons.error, color: colorScheme.onErrorContainer),
              const SizedBox(width: 12),
              Text(
                'Failed to ${running ? 'stop' : 'start'} container',
                style: TextStyle(color: colorScheme.onErrorContainer),
              ),
            ],
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
