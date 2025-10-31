export interface User {
  _id: string;
  name: string;
  email: string;
  createdAt: string;
  updatedAt: string;
}

export interface Task {
  _id: string;
  title: string;
  description?: string;
  status: 'pending' | 'in-progress' | 'completed';
  deadline?: string;
  user: string;
  createdAt: string;
  updatedAt: string;
}

export interface AuthResponse {
  success: boolean;
  message: string;
  data: {
    user: User;
    token: string;
  };
}

export interface TaskResponse {
  success: boolean;
  message?: string;
  data: {
    task?: Task;
    tasks?: Task[];
    pagination?: {
      currentPage: number;
      totalPages: number;
      totalTasks: number;
      hasNextPage: boolean;
      hasPrevPage: boolean;
    };
  };
}

export interface TaskStats {
  pending: number;
  'in-progress': number;
  completed: number;
}

export interface StatsResponse {
  success: boolean;
  data: {
    stats: TaskStats;
  };
}

export interface ApiError {
  success: false;
  message: string;
}

export interface CreateTaskData {
  title: string;
  description?: string;
  status?: 'pending' | 'in-progress' | 'completed';
  deadline?: string;
}

export interface UpdateTaskData {
  title?: string;
  description?: string;
  status?: 'pending' | 'in-progress' | 'completed';
  deadline?: string;
}

export interface LoginData {
  email: string;
  password: string;
}

export interface SignupData {
  name: string;
  email: string;
  password: string;
}