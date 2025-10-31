# Task Management Frontend

A modern React/Next.js frontend for the Task Management Application, built with TypeScript and Tailwind CSS.

## 🚀 Features

- **Modern UI/UX** - Clean, responsive design with Tailwind CSS
- **TypeScript** - Full type safety and better developer experience
- **Authentication** - JWT-based login/signup with protected routes
- **Task Management** - Complete CRUD operations with real-time updates
- **Advanced Filtering** - Filter by status, sort by multiple criteria
- **Pagination** - Efficient handling of large task lists
- **Responsive Design** - Works seamlessly on desktop and mobile
- **Real-time Feedback** - Toast notifications for user actions
- **Loading States** - Smooth loading experiences
- **Error Handling** - Comprehensive error states and recovery

## 📁 Project Structure

```
frontend/
├── src/
│   ├── components/           # Reusable UI components
│   │   ├── Layout.tsx       # Main layout wrapper
│   │   ├── ProtectedRoute.tsx # Route protection
│   │   ├── TaskCard.tsx     # Individual task display
│   │   ├── TaskModal.tsx    # Create/edit task modal
│   │   ├── TaskFilters.tsx  # Filtering controls
│   │   ├── TaskStats.tsx    # Task statistics display
│   │   └── Pagination.tsx   # Pagination component
│   ├── context/
│   │   └── AuthContext.tsx  # Authentication state management
│   ├── hooks/
│   │   └── useTasks.ts      # Custom hook for task operations
│   ├── pages/               # Next.js pages
│   │   ├── _app.tsx         # App configuration
│   │   ├── _document.tsx    # HTML document structure
│   │   ├── index.tsx        # Home page (redirects to tasks)
│   │   ├── login.tsx        # Login page
│   │   ├── signup.tsx       # Registration page
│   │   └── tasks.tsx        # Main tasks page
│   ├── styles/
│   │   └── globals.css      # Global styles and Tailwind
│   ├── types/
│   │   └── index.ts         # TypeScript type definitions
│   └── utils/
│       ├── api.ts           # Axios configuration and interceptors
│       └── date.ts          # Date formatting utilities
├── public/                  # Static assets
├── .env.example            # Environment variables template
├── next.config.js          # Next.js configuration
├── tailwind.config.js      # Tailwind CSS configuration
├── tsconfig.json           # TypeScript configuration
└── package.json            # Dependencies and scripts
```

## 🛠 Installation & Setup

### Prerequisites
- Node.js (v16 or higher)
- npm or yarn
- Backend API running (see backend README)

### Steps

1. **Navigate to frontend directory**
   ```bash
   cd frontend
   ```

2. **Install dependencies**
   ```bash
   npm install
   # or
   yarn install
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env.local
   ```
   
   Edit `.env.local`:
   ```env
   NEXT_PUBLIC_API_URL=http://localhost:5000/api
   ```

4. **Start the development server**
   ```bash
   npm run dev
   # or
   yarn dev
   ```

5. **Open your browser**
   - Visit `http://localhost:3000`
   - You'll be redirected to the login page if not authenticated

## 🎨 UI Components

### Layout Components
- **Layout**: Main application wrapper with header and navigation
- **ProtectedRoute**: Ensures only authenticated users can access certain pages

### Task Components
- **TaskCard**: Displays individual tasks with status, deadline, and actions
- **TaskModal**: Modal for creating and editing tasks
- **TaskFilters**: Controls for filtering and sorting tasks
- **TaskStats**: Dashboard showing task statistics
- **Pagination**: Navigation for paginated task lists

### Form Components
- **Login/Signup Forms**: Authentication forms with validation
- **Task Forms**: Create/edit task forms with validation

## 🔐 Authentication Flow

1. **User Registration/Login**
   - Form validation with react-hook-form
   - JWT token storage in secure cookies
   - Automatic redirect to tasks page

2. **Protected Routes**
   - Automatic redirect to login if not authenticated
   - Token validation on each request
   - Logout functionality with cleanup

3. **API Integration**
   - Axios interceptors for automatic token attachment
   - Error handling for expired tokens
   - Automatic logout on authentication errors

## 📱 Pages

### `/login`
- User authentication
- Form validation
- Demo credentials display
- Link to signup page

### `/signup`
- User registration
- Form validation with password requirements
- Automatic login after successful registration

### `/tasks` (Protected)
- Main task dashboard
- Task statistics overview
- Filtering and sorting controls
- Paginated task grid
- Create/edit/delete task functionality

## 🎯 Key Features

### Task Management
- **Create Tasks**: Modal form with title, description, status, and deadline
- **Edit Tasks**: In-place editing with pre-filled forms
- **Delete Tasks**: Confirmation dialog before deletion
- **Status Updates**: Quick status changes via dropdown
- **Bulk Operations**: Filter and sort multiple tasks

### Filtering & Sorting
- **Status Filter**: Filter by pending, in-progress, or completed
- **Sort Options**: Sort by date, title, deadline, or status
- **Pagination**: Handle large task lists efficiently

### User Experience
- **Responsive Design**: Works on all screen sizes
- **Loading States**: Skeleton loaders and spinners
- **Error Handling**: User-friendly error messages
- **Success Feedback**: Toast notifications for actions
- **Empty States**: Helpful messages when no tasks exist

## 🔧 Development

### Available Scripts
```bash
# Development server
npm run dev

# Production build
npm run build

# Start production server
npm start

# Linting
npm run lint

# Type checking
npm run type-check
```

### Code Quality
- **TypeScript**: Full type safety
- **ESLint**: Code linting with Next.js rules
- **Prettier**: Code formatting (via ESLint)
- **Husky**: Git hooks for quality checks (optional)

## 🎨 Styling

### Tailwind CSS
- **Utility-first**: Rapid UI development
- **Responsive**: Mobile-first responsive design
- **Dark Mode Ready**: Easy to implement dark mode
- **Custom Theme**: Extended color palette and animations

### Design System
- **Colors**: Primary blue theme with gray neutrals
- **Typography**: Inter font family
- **Spacing**: Consistent spacing scale
- **Animations**: Smooth transitions and hover effects

## 🌐 API Integration

### Endpoints Used
- `POST /api/auth/login` - User authentication
- `POST /api/auth/signup` - User registration
- `GET /api/auth/profile` - Get user profile
- `GET /api/tasks` - Get tasks with filtering/pagination
- `POST /api/tasks` - Create new task
- `PUT /api/tasks/:id` - Update task
- `DELETE /api/tasks/:id` - Delete task
- `GET /api/tasks/stats` - Get task statistics

### Error Handling
- Network errors with retry options
- Validation errors with field-specific messages
- Authentication errors with automatic logout
- Server errors with user-friendly messages

## 🚀 Deployment

### Build for Production
```bash
npm run build
```

### Environment Variables for Production
```env
NEXT_PUBLIC_API_URL=https://your-api-domain.com/api
```

### Deploy to Vercel (Recommended)
```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel

# Set environment variables in Vercel dashboard
```

### Deploy to Netlify
```bash
# Build the app
npm run build

# Deploy the /out folder to Netlify
```

### Deploy to Static Hosting
```bash
# Add to next.config.js for static export
output: 'export'

# Build static files
npm run build
```

## 🧪 Testing

### Manual Testing Checklist
- [ ] User can register and login
- [ ] Tasks can be created, edited, and deleted
- [ ] Filtering and sorting work correctly
- [ ] Pagination functions properly
- [ ] Responsive design works on mobile
- [ ] Error states display correctly
- [ ] Loading states show appropriately

### Automated Testing (Future)
- Unit tests with Jest and React Testing Library
- Integration tests for API calls
- E2E tests with Playwright or Cypress

## 🔧 Customization

### Theming
Edit `tailwind.config.js` to customize:
- Colors
- Fonts
- Spacing
- Animations

### API Configuration
Edit `src/utils/api.ts` to modify:
- Base URL
- Request/response interceptors
- Error handling

### Components
All components are modular and can be easily customized or replaced.

## 📝 License

MIT License - feel free to use this project for learning and development.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📞 Support

For issues and questions:
1. Check the browser console for errors
2. Verify backend API is running
3. Check network requests in developer tools
4. Review environment variables