'use client';

import React from 'react';
import { TaskStats as TaskStatsType } from '@/types';
import { CheckCircle, Clock, AlertCircle } from 'lucide-react';

interface TaskStatsProps {
  stats: TaskStatsType | null;
  isLoading: boolean;
}

const TaskStats: React.FC<TaskStatsProps> = ({ stats, isLoading }) => {
  if (isLoading) {
    return (
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
        {[1, 2, 3].map((i) => (
          <div key={i} className="bg-white rounded-lg shadow-sm border border-gray-200 p-6 animate-pulse">
            <div className="flex items-center">
              <div className="h-8 w-8 bg-gray-200 rounded-full"></div>
              <div className="ml-4">
                <div className="h-4 w-16 bg-gray-200 rounded mb-1"></div>
                <div className="h-6 w-8 bg-gray-200 rounded"></div>
              </div>
            </div>
          </div>
        ))}
      </div>
    );
  }

  if (!stats) {
    return null;
  }

  const statItems = [
    {
      label: 'Pending',
      value: stats.pending,
      icon: AlertCircle,
      color: 'text-yellow-600',
      bg: 'bg-yellow-50',
    },
    {
      label: 'In Progress',
      value: stats['in-progress'],
      icon: Clock,
      color: 'text-blue-600',
      bg: 'bg-blue-50',
    },
    {
      label: 'Completed',
      value: stats.completed,
      icon: CheckCircle,
      color: 'text-green-600',
      bg: 'bg-green-50',
    },
  ];

  const total = stats.pending + stats['in-progress'] + stats.completed;

  return (
    <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
      {statItems.map((item) => {
        const Icon = item.icon;
        const percentage = total > 0 ? Math.round((item.value / total) * 100) : 0;

        return (
          <div key={item.label} className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
            <div className="flex items-center">
              <div className={`flex-shrink-0 p-2 rounded-lg ${item.bg}`}>
                <Icon className={`h-6 w-6 ${item.color}`} />
              </div>
              <div className="ml-4">
                <p className="text-sm font-medium text-gray-600">{item.label}</p>
                <div className="flex items-baseline">
                  <p className="text-2xl font-semibold text-gray-900">{item.value}</p>
                  {total > 0 && (
                    <p className="ml-2 text-sm text-gray-500">({percentage}%)</p>
                  )}
                </div>
              </div>
            </div>
          </div>
        );
      })}
    </div>
  );
};

export default TaskStats;