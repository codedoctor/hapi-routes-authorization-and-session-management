Joi = require "joi"

minLoginLength = 2
maxLoginLength = 100
minPasswordLength = 8
maxPasswordLength = 40

validateId = Joi.string().length(24)

module.exports =
  validateId: validateId

  password: Joi.string().min(minPasswordLength).max(maxPasswordLength).example('some password')
  login: Joi.string().min(minLoginLength).max(maxLoginLength).example('johnsmith')

