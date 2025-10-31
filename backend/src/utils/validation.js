const Joi = require('joi');

const userSignupSchema = Joi.object({
  name: Joi.string().min(2).max(50).required().messages({
    'string.min': 'Name must be at least 2 characters',
    'string.max': 'Name cannot exceed 50 characters',
    'any.required': 'Name is required'
  }),
  email: Joi.string().email().required().messages({
    'string.email': 'Please enter a valid email',
    'any.required': 'Email is required'
  }),
  password: Joi.string().min(6).required().messages({
    'string.min': 'Password must be at least 6 characters',
    'any.required': 'Password is required'
  })
});

const userLoginSchema = Joi.object({
  email: Joi.string().email().required().messages({
    'string.email': 'Please enter a valid email',
    'any.required': 'Email is required'
  }),
  password: Joi.string().required().messages({
    'any.required': 'Password is required'
  })
});

const taskSchema = Joi.object({
  title: Joi.string().max(100).required().messages({
    'string.max': 'Title cannot exceed 100 characters',
    'any.required': 'Task title is required'
  }),
  description: Joi.string().max(500).allow('').messages({
    'string.max': 'Description cannot exceed 500 characters'
  }),
  status: Joi.string().valid('pending', 'in-progress', 'completed').messages({
    'any.only': 'Status must be pending, in-progress, or completed'
  }),
  deadline: Joi.date().min('now').allow(null).messages({
    'date.min': 'Deadline must be in the future'
  })
});

const taskUpdateSchema = Joi.object({
  title: Joi.string().max(100).messages({
    'string.max': 'Title cannot exceed 100 characters'
  }),
  description: Joi.string().max(500).allow('').messages({
    'string.max': 'Description cannot exceed 500 characters'
  }),
  status: Joi.string().valid('pending', 'in-progress', 'completed').messages({
    'any.only': 'Status must be pending, in-progress, or completed'
  }),
  deadline: Joi.date().min('now').allow(null).messages({
    'date.min': 'Deadline must be in the future'
  })
});

module.exports = {
  userSignupSchema,
  userLoginSchema,
  taskSchema,
  taskUpdateSchema
};