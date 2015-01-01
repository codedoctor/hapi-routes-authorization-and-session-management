fixtures = require './fixtures'

module.exports = (server,cb) ->
  data = 
    _tenantId: fixtures._tenantId
    name : 'codedoctor'
    websiteUrl: 'http://somesite.com'
    imageUrl: null
    callbackUrl: null
    notes: 'Some comment'
    scopes: ['read','write']
    revoked: 0
    description: ''
    acceptTermsOfService: true
    isPublished: true
    organizationName: 'codedoctor'
    organizationUrl: 'http://somesite.com'
    tosAcceptanceDate : null
    clientId: fixtures.clientId # Changed in later underlying code

    redirectUrls: []
    stat: 
      tokensGranted : 0
      tokensRevoked : 0

  methodsOauth = server.plugins['hapi-oauth-store-multi-tenant'].methods
  methodsUser = server.plugins['hapi-user-store-multi-tenant'].methods

  methodsOauth.oauthApps.create fixtures._tenantId,data,null, (err,app) ->
    return cb err if err
    
    dataUser = 
      username: fixtures.user1.username
      password: fixtures.user1.password
      email: fixtures.user1.email
    methodsUser.users.create fixtures._tenantId,dataUser,null, (err,user) ->
      cb err, app,user

