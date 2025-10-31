'use client';

import React, { createContext, useContext, useEffect, useState } from 'react';
import Cookies from 'js-cookie';
import { User, LoginData, SignupData, AuthResponse } from '@/types';
import api from '@/utils/api';
import { toast } from 'react-hot-toast';

interface AuthContextType {
  user: User | null;
  isLoading: boolean;
  isAuthenticated: boolean;
  login: (data: LoginData) => Promise<boolean>;
  signup: (data: SignupData) => Promise<boolean>;
  logout: () => void;
  checkAuth: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};

interface AuthProviderProps {
  children: React.ReactNode;
}

export const AuthProvider: React.FC<AuthProviderProps> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  const isAuthenticated = !!user;

  const login = async (data: LoginData): Promise<boolean> => {
    try {
      const response = await api.post<AuthResponse>('/auth/login', data);
      
      if (response.data.success) {
        const { user, token } = response.data.data;
        setUser(user);
        Cookies.set('token', token, { expires: 7 });
        Cookies.set('user', JSON.stringify(user), { expires: 7 });
        toast.success('Login successful!');
        return true;
      }
      return false;
    } catch (error: any) {
      const message = error.response?.data?.message || 'Login failed';
      toast.error(message);
      return false;
    }
  };

  const signup = async (data: SignupData): Promise<boolean> => {
    try {
      const response = await api.post<AuthResponse>('/auth/signup', data);
      
      if (response.data.success) {
        const { user, token } = response.data.data;
        setUser(user);
        Cookies.set('token', token, { expires: 7 });
        Cookies.set('user', JSON.stringify(user), { expires: 7 });
        toast.success('Account created successfully!');
        return true;
      }
      return false;
    } catch (error: any) {
      const message = error.response?.data?.message || 'Signup failed';
      toast.error(message);
      return false;
    }
  };

  const logout = () => {
    setUser(null);
    Cookies.remove('token');
    Cookies.remove('user');
    toast.success('Logged out successfully');
  };

  const checkAuth = async () => {
    try {
      const token = Cookies.get('token');
      const userCookie = Cookies.get('user');
      
      if (token && userCookie) {
        const userData = JSON.parse(userCookie);
        
        // Verify token is still valid
        const response = await api.get('/auth/profile');
        if (response.data.success) {
          setUser(response.data.data.user);
        } else {
          throw new Error('Invalid token');
        }
      }
    } catch (error) {
      // Clear invalid credentials
      Cookies.remove('token');
      Cookies.remove('user');
      setUser(null);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    checkAuth();
  }, []);

  const value = {
    user,
    isLoading,
    isAuthenticated,
    login,
    signup,
    logout,
    checkAuth,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};