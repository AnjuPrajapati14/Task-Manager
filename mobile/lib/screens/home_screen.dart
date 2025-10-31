import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/custom_button.dart';
import '../widgets/task_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/empty_state.dart';
import 'task_form_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
    _scrollController.addListener(_onScroll);
    
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    final taskProvider = context.read<TaskProvider>();
    String? statusFilter;
    
    switch (_tabController.index) {
      case 1:
        statusFilter = 'pending';
        break;
      case 2:
        statusFilter = 'in-progress';
        break;
      case 3:
        statusFilter = 'completed';
        break;
      default:
        statusFilter = null;
    }
    
    taskProvider.setStatusFilter(statusFilter);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent * 0.8) {
      // Load more when 80% scrolled
      context.read<TaskProvider>().loadNextPage();
    }
  }

  Future<void> _loadData() async {
    final taskProvider = context.read<TaskProvider>();
    await taskProvider.refresh();
  }

  Future<void> _handleRefresh() async {
    await _loadData();
  }

  Future<void> _handleLogout() async {
    final confirmed = await UIHelper.showConfirmDialog(
      context,
      'Logout',
      'Are you sure you want to logout?',
    );
    
    if (confirmed) {
      final authProvider = context.read<AuthProvider>();
      final taskProvider = context.read<TaskProvider>();
      
      await authProvider.logout();
      taskProvider.clear();
      
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        UIHelper.showToast('Logged out successfully');
      }
    }
  }

  void _navigateToTaskForm([Task? task]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(task: task),
      ),
    );
  }

  Future<void> _handleDeleteTask(Task task) async {
    final confirmed = await UIHelper.showConfirmDialog(
      context,
      AppStrings.deleteTask,
      AppStrings.confirmDeleteTask,
    );
    
    if (confirmed) {
      final taskProvider = context.read<TaskProvider>();
      final error = await taskProvider.deleteTask(task.id);
      
      if (mounted) {
        if (error == null) {
          UIHelper.showToast('Task deleted successfully');
        } else {
          UIHelper.showSnackBar(context, error, isError: true);
        }
      }
    }
  }

  Future<void> _handleStatusChange(Task task, TaskStatus status) async {
    if (task.status == status) return;
    
    final taskProvider = context.read<TaskProvider>();
    final error = await taskProvider.updateTaskStatus(task.id, status);
    
    if (mounted && error != null) {
      UIHelper.showSnackBar(context, error, isError: true);
    }
  }

  Widget _buildStatsCards() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final stats = taskProvider.stats;
        
        if (stats == null) {
          return const SizedBox.shrink();
        }
        
        return Container(
          height: 112,
          margin: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Pending',
                  stats.pending,
                  const Color(AppColors.pending),
                  Icons.schedule,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'In Progress',
                  stats.inProgress,
                  const Color(AppColors.inProgress),
                  Icons.hourglass_empty,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Completed',
                  stats.completed,
                  const Color(AppColors.completed),
                  Icons.check_circle,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String label, int count, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        if (taskProvider.isLoading && taskProvider.tasks.isEmpty) {
          return const Expanded(child: TaskListShimmer());
        }
        
        if (taskProvider.error != null && taskProvider.tasks.isEmpty) {
          return Expanded(
            child: ErrorState(
              title: AppStrings.error,
              message: taskProvider.error!,
              onRetry: _loadData,
            ),
          );
        }
        
        if (taskProvider.tasks.isEmpty) {
          return Expanded(
            child: EmptyState(
              icon: Icons.task_alt,
              title: AppStrings.noTasks,
              message: AppStrings.noTasksMessage,
              actionText: AppStrings.addTask,
              onAction: () => _navigateToTaskForm(),
            ),
          );
        }
        
        return Expanded(
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: taskProvider.tasks.length + 
                  (taskProvider.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= taskProvider.tasks.length) {
                  // Loading indicator at bottom
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: LoadingWidget(),
                  );
                }
                
                final task = taskProvider.tasks[index];
                return TaskCard(
                  task: task,
                  onTap: () => _navigateToTaskForm(task),
                  onEdit: () => _navigateToTaskForm(task),
                  onDelete: () => _handleDeleteTask(task),
                  onStatusChanged: (status) => _handleStatusChange(task, status),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.myTasks,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(AppColors.primary),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _handleRefresh,
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: AppStrings.refresh,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'logout') {
                _handleLogout();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: const [
                    Icon(Icons.logout, color: Color(AppColors.error)),
                    SizedBox(width: 8),
                    Text(AppStrings.logout),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'In Progress'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Stats cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildStatsCards(),
          ),
          
          // Task list
          _buildTaskList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToTaskForm(),
        backgroundColor: const Color(AppColors.primary),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}