import { format, formatDistanceToNow, isValid, parseISO } from 'date-fns';

export const formatDate = (date: string | Date): string => {
  const parsedDate = typeof date === 'string' ? parseISO(date) : date;
  
  if (!isValid(parsedDate)) {
    return 'Invalid date';
  }
  
  return format(parsedDate, 'MMM dd, yyyy');
};

export const formatDateTime = (date: string | Date): string => {
  const parsedDate = typeof date === 'string' ? parseISO(date) : date;
  
  if (!isValid(parsedDate)) {
    return 'Invalid date';
  }
  
  return format(parsedDate, 'MMM dd, yyyy HH:mm');
};

export const formatDateTimeInput = (date: string | Date): string => {
  const parsedDate = typeof date === 'string' ? parseISO(date) : date;
  
  if (!isValid(parsedDate)) {
    return '';
  }
  
  return format(parsedDate, "yyyy-MM-dd'T'HH:mm");
};

export const formatRelativeTime = (date: string | Date): string => {
  const parsedDate = typeof date === 'string' ? parseISO(date) : date;
  
  if (!isValid(parsedDate)) {
    return 'Invalid date';
  }
  
  return formatDistanceToNow(parsedDate, { addSuffix: true });
};

export const isOverdue = (deadline: string): boolean => {
  const deadlineDate = parseISO(deadline);
  return isValid(deadlineDate) && deadlineDate < new Date();
};