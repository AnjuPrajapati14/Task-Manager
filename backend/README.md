# Task Management Backend API

A robust Node.js + Express + MongoDB backend for the Task Management Application.

## 🚀 Features

- **JWT Authentication** - Secure user registration and login
- **Task CRUD Operations** - Complete task management functionality
- **Input Validation** - Joi-based request validation
- **Error Handling** - Comprehensive error handling middleware
- **Security** - Helmet, CORS, rate limiting
- **Database** - MongoDB with Mongoose ODM
- **Pagination & Filtering** - Advanced query capabilities

## 📁 Project Structure

```
backend/
├── src/
│   ├── config/
│   │   └── database.js          # MongoDB connection
│   ├── controllers/
│   │   ├── authController.js    # Authentication logic
│   │   └── taskController.js    # Task management logic
│   ├── middleware/
│   │   ├── auth.js              # JWT authentication middleware
│   │   ├── validation.js        # Request validation middleware
│   │   └── errorHandler.js      # Global error handler
│   ├── models/
│   │   ├── User.js              # User schema
│   │   └── Task.js              # Task schema
│   ├── routes/
│   │   ├── authRoutes.js        # Authentication routes
│   │   └── taskRoutes.js        # Task routes
│   ├── utils/
│   │   ├── jwt.js               # JWT utilities
│   │   └── validation.js        # Joi validation schemas
│   └── app.js                   # Express app setup
├── .env.example                 # Environment variables template
├── .gitignore
├── package.json
└── README.md
```

## 🛠 Installation & Setup

### Prerequisites
- Node.js (v16 or higher)
- MongoDB (local or cloud instance)
- npm or yarn

### Steps

1. **Clone and navigate to backend directory**
   ```bash
   cd backend
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env` file with your configurations:
   ```env
   PORT=5000
   MONGODB_URI=mongodb://localhost:27017/task-management
   JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
   JWT_EXPIRES_IN=7d
   NODE_ENV=development
   ```

4. **Start MongoDB**
   - **Local MongoDB**: Make sure MongoDB is running on your system
   - **MongoDB Atlas**: Use the connection string from your Atlas cluster

5. **Run the application**
   ```bash
   # Development mode (with nodemon)
   npm run dev
   
   # Production mode
   npm start
   ```

6. **Verify installation**
   - Visit `http://localhost:5000` in your browser
   - You should see the API welcome message

## 📚 API Documentation

### Base URL
```
http://localhost:5000/api
```

### Authentication Endpoints

#### Register User
```http
POST /api/auth/signup
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123"
}
```

#### Login User
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "password123"
}
```

#### Get User Profile
```http
GET /api/auth/profile
Authorization: Bearer <token>
```

### Task Endpoints

#### Get All Tasks
```http
GET /api/tasks?status=pending&page=1&limit=10&sortBy=createdAt&sortOrder=desc
Authorization: Bearer <token>
```

#### Get Single Task
```http
GET /api/tasks/:id
Authorization: Bearer <token>
```

#### Create Task
```http
POST /api/tasks
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "Complete project",
  "description": "Finish the task management app",
  "status": "pending",
  "deadline": "2024-12-31T23:59:59.000Z"
}
```

#### Update Task
```http
PUT /api/tasks/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "Updated title",
  "status": "in-progress"
}
```

#### Delete Task
```http
DELETE /api/tasks/:id
Authorization: Bearer <token>
```

#### Get Task Statistics
```http
GET /api/tasks/stats
Authorization: Bearer <token>
```

## 🔐 Authentication

This API uses JWT (JSON Web Tokens) for authentication. Include the token in the Authorization header:

```
Authorization: Bearer <your-jwt-token>
```

## 📝 Data Models

### User Model
```javascript
{
  name: String (required, 2-50 chars),
  email: String (required, unique, valid email),
  password: String (required, min 6 chars, hashed),
  createdAt: Date,
  updatedAt: Date
}
```

### Task Model
```javascript
{
  title: String (required, max 100 chars),
  description: String (optional, max 500 chars),
  status: String (enum: ['pending', 'in-progress', 'completed']),
  deadline: Date (optional, future date),
  user: ObjectId (ref: User),
  createdAt: Date,
  updatedAt: Date
}
```

## 🛡 Security Features

- **Helmet**: Sets various HTTP headers
- **CORS**: Configurable cross-origin resource sharing
- **Rate Limiting**: 100 requests per 15 minutes per IP
- **Input Validation**: Joi-based request validation
- **Password Hashing**: bcryptjs with salt rounds
- **JWT**: Secure token-based authentication

## 🧪 Testing

Run tests (when implemented):
```bash
npm test
```

## 🚀 Deployment

### Environment Variables for Production
```env
NODE_ENV=production
PORT=5000
MONGODB_URI=your-production-mongodb-uri
JWT_SECRET=your-super-secure-production-secret
JWT_EXPIRES_IN=7d
```

### Deploy to Heroku (example)
```bash
# Create Heroku app
heroku create your-app-name

# Set environment variables
heroku config:set NODE_ENV=production
heroku config:set MONGODB_URI=your-mongodb-uri
heroku config:set JWT_SECRET=your-jwt-secret

# Deploy
git push heroku main
```

## 🔧 Development Tips

- Use `npm run dev` for development with auto-restart
- Check MongoDB connection in logs
- Use a tool like Postman or Thunder Client for API testing
- Enable MongoDB logging for debugging queries

## 📄 License

MIT License - feel free to use this project for learning and development.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📞 Support

For issues and questions, please create an issue in the repository.