fixtures = require './fixtures'

module.exports = (server,cb) ->
  data = 
    accountId: fixtures.accountId
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
    clients: [
      clientId: fixtures.clientId
    ]

    redirectUrls: []
    stat: 
      tokensGranted : 0
      tokensRevoked : 0

  methods = server.pack.plugins['hapi-identity-store'].methods
  methods.oauthApps.create fixtures.accountId,data,null, (err,app) ->
    return cb err if err
    dataUser = 
      username: fixtures.user1.username
      password: fixtures.user1.password
      email: fixtures.user1.email
    methods.users.create fixtures.accountId,dataUser,null, (err,user) ->
      console.log "USER: #{JSON.stringify(user)}"
      cb err

