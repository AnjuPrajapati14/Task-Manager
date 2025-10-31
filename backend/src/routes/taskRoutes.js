const express = require('express');
const {
  getTasks,
  getTask,
  createTask,
  updateTask,
  deleteTask,
  getTaskStats
} = require('../controllers/taskController');
const { validate } = require('../middleware/validation');
const { authenticateToken } = require('../middleware/auth');
const { taskSchema, taskUpdateSchema } = require('../utils/validation');

const router = express.Router();

router.use(authenticateToken);

router.get('/', getTasks);
router.get('/stats', getTaskStats);
router.get('/:id', getTask);
router.post('/', validate(taskSchema), createTask);
router.put('/:id', validate(taskUpdateSchema), updateTask);
router.delete('/:id', deleteTask);

module.exports = router;