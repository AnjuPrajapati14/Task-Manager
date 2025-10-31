const express = require('express');
const { signup, login, getProfile } = require('../controllers/authController');
const { validate } = require('../middleware/validation');
const { authenticateToken } = require('../middleware/auth');
const { userSignupSchema, userLoginSchema } = require('../utils/validation');

const router = express.Router();

router.post('/signup', validate(userSignupSchema), signup);
router.post('/login', validate(userLoginSchema), login);
router.get('/profile', authenticateToken, getProfile);

module.exports = router;