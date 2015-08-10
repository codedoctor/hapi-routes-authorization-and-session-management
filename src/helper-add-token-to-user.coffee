_ = require 'underscore'
Boom = require 'boom'
#mongoose = require 'mongoose'

helperObjToRestUser = require './helper-obj-to-rest-user'

module.exports = (oauthAuth, baseUrl,_tenantId,userId, clientId, realm, scope ,user, cb) ->

  if clientId
    oauthAuth.createOrReuseTokenForUserId _tenantId,userId, clientId, realm,scope, null, (err, token) ->
      return cb err if err
      return cb new Boom.badRequest("#{baseUrl}/users") unless token

      user = helperObjToRestUser user, "#{baseUrl}/users"
      _.extend user,
        token:
          accessToken : token.accessToken
          refreshToken : token.refreshToken

      cb null, user
  else
    cb null, helperObjToRestUser user, "#{baseUrl}/users"
