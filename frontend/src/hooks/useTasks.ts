import { useState, useEffect, useCallback } from 'react';
import { Task, TaskResponse, CreateTaskData, UpdateTaskData, StatsResponse, TaskStats } from '@/types';
import api from '@/utils/api';
import { toast } from 'react-hot-toast';

interface UseTasksOptions {
  status?: string;
  page?: number;
  limit?: number;
  sortBy?: string;
  sortOrder?: 'asc' | 'desc';
}

interface UseTasksReturn {
  tasks: Task[];
  isLoading: boolean;
  error: string | null;
  pagination: {
    currentPage: number;
    totalPages: number;
    totalTasks: number;
    hasNextPage: boolean;
    hasPrevPage: boolean;
  } | null;
  stats: TaskStats | null;
  createTask: (data: CreateTaskData) => Promise<boolean>;
  updateTask: (id: string, data: UpdateTaskData) => Promise<boolean>;
  deleteTask: (id: string) => Promise<boolean>;
  refreshTasks: () => void;
  loadStats: () => void;
}

export const useTasks = (options: UseTasksOptions = {}): UseTasksReturn => {
  const [tasks, setTasks] = useState<Task[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [pagination, setPagination] = useState<UseTasksReturn['pagination']>(null);
  const [stats, setStats] = useState<TaskStats | null>(null);

  const loadTasks = useCallback(async () => {
    try {
      setIsLoading(true);
      setError(null);

      const params = new URLSearchParams();
      if (options.status) params.append('status', options.status);
      if (options.page) params.append('page', options.page.toString());
      if (options.limit) params.append('limit', options.limit.toString());
      if (options.sortBy) params.append('sortBy', options.sortBy);
      if (options.sortOrder) params.append('sortOrder', options.sortOrder);

      const response = await api.get<TaskResponse>(`/tasks?${params.toString()}`);
      
      if (response.data.success) {
        setTasks(response.data.data.tasks || []);
        setPagination(response.data.data.pagination || null);
      }
    } catch (error: any) {
      const message = error.response?.data?.message || 'Failed to load tasks';
      setError(message);
      toast.error(message);
    } finally {
      setIsLoading(false);
    }
  }, [options.status, options.page, options.limit, options.sortBy, options.sortOrder]);

  const loadStats = useCallback(async () => {
    try {
      const response = await api.get<StatsResponse>('/tasks/stats');
      if (response.data.success) {
        setStats(response.data.data.stats);
      }
    } catch (error: any) {
      console.error('Failed to load stats:', error);
    }
  }, []);

  const createTask = async (data: CreateTaskData): Promise<boolean> => {
    try {
      const response = await api.post<TaskResponse>('/tasks', data);
      
      if (response.data.success) {
        toast.success('Task created successfully!');
        loadTasks();
        loadStats();
        return true;
      }
      return false;
    } catch (error: any) {
      const message = error.response?.data?.message || 'Failed to create task';
      toast.error(message);
      return false;
    }
  };

  const updateTask = async (id: string, data: UpdateTaskData): Promise<boolean> => {
    try {
      const response = await api.put<TaskResponse>(`/tasks/${id}`, data);
      
      if (response.data.success) {
        toast.success('Task updated successfully!');
        loadTasks();
        loadStats();
        return true;
      }
      return false;
    } catch (error: any) {
      const message = error.response?.data?.message || 'Failed to update task';
      toast.error(message);
      return false;
    }
  };

  const deleteTask = async (id: string): Promise<boolean> => {
    try {
      const response = await api.delete(`/tasks/${id}`);
      
      if (response.data.success) {
        toast.success('Task deleted successfully!');
        loadTasks();
        loadStats();
        return true;
      }
      return false;
    } catch (error: any) {
      const message = error.response?.data?.message || 'Failed to delete task';
      toast.error(message);
      return false;
    }
  };

  const refreshTasks = useCallback(() => {
    loadTasks();
    loadStats();
  }, [loadTasks, loadStats]);

  useEffect(() => {
    loadTasks();
    loadStats();
  }, [loadTasks, loadStats]);

  return {
    tasks,
    isLoading,
    error,
    pagination,
    stats,
    createTask,
    updateTask,
    deleteTask,
    refreshTasks,
    loadStats,
  };
};