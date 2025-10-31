'use client';

import React from 'react';
import { Task } from '@/types';
import { formatDate, formatRelativeTime, isOverdue } from '@/utils/date';
import { Calendar, Clock, Edit, Trash2 } from 'lucide-react';
import clsx from 'clsx';

interface TaskCardProps {
  task: Task;
  onEdit: (task: Task) => void;
  onDelete: (id: string) => void;
  onStatusChange: (id: string, status: Task['status']) => void;
}

const statusColors = {
  pending: 'bg-yellow-100 text-yellow-800 border-yellow-200',
  'in-progress': 'bg-blue-100 text-blue-800 border-blue-200',
  completed: 'bg-green-100 text-green-800 border-green-200',
};

const statusLabels = {
  pending: 'Pending',
  'in-progress': 'In Progress',
  completed: 'Completed',
};

const TaskCard: React.FC<TaskCardProps> = ({ task, onEdit, onDelete, onStatusChange }) => {
  const isTaskOverdue = task.deadline && isOverdue(task.deadline) && task.status !== 'completed';

  return (
    <div className={clsx(
      'bg-white rounded-lg shadow-sm border border-gray-200 p-6 hover:shadow-md transition-shadow',
      isTaskOverdue && 'border-l-4 border-l-red-500'
    )}>
      {/* Header */}
      <div className="flex items-start justify-between mb-3">
        <h3 className="text-lg font-semibold text-gray-900 line-clamp-2">
          {task.title}
        </h3>
        <div className="flex items-center space-x-2 ml-2">
          <button
            onClick={() => onEdit(task)}
            className="p-1 text-gray-400 hover:text-primary-600 transition-colors"
            title="Edit task"
          >
            <Edit className="h-4 w-4" />
          </button>
          <button
            onClick={() => onDelete(task._id)}
            className="p-1 text-gray-400 hover:text-red-600 transition-colors"
            title="Delete task"
          >
            <Trash2 className="h-4 w-4" />
          </button>
        </div>
      </div>

      {/* Description */}
      {task.description && (
        <p className="text-gray-600 text-sm mb-4 line-clamp-3">
          {task.description}
        </p>
      )}

      {/* Status */}
      <div className="flex items-center justify-between mb-4">
        <select
          value={task.status}
          onChange={(e) => onStatusChange(task._id, e.target.value as Task['status'])}
          className={clsx(
            'text-xs font-medium px-2 py-1 rounded-full border cursor-pointer focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500',
            statusColors[task.status]
          )}
        >
          <option value="pending">Pending</option>
          <option value="in-progress">In Progress</option>
          <option value="completed">Completed</option>
        </select>

        {isTaskOverdue && (
          <span className="text-xs font-medium text-red-600 bg-red-50 px-2 py-1 rounded-full">
            Overdue
          </span>
        )}
      </div>

      {/* Footer */}
      <div className="flex items-center justify-between text-xs text-gray-500">
        <div className="flex items-center space-x-4">
          {task.deadline && (
            <div className="flex items-center space-x-1">
              <Calendar className="h-3 w-3" />
              <span className={clsx(
                isTaskOverdue && 'text-red-600 font-medium'
              )}>
                {formatDate(task.deadline)}
              </span>
            </div>
          )}
          
          <div className="flex items-center space-x-1">
            <Clock className="h-3 w-3" />
            <span>{formatRelativeTime(task.createdAt)}</span>
          </div>
        </div>
      </div>
    </div>
  );
};

export default TaskCard;