# Requiring modules
asrt = require 'assert'
vows = require 'vows'
nock = require '../support/nock'
ghub = require '../../src/octonode'

# Authentication tests
vows
  .describe('auth')
  .addBatch
    'Authentication':
      topic: ->
        ghub.auth

      'should have correct modes': (auth) ->
        asrt.equal auth.modes.cli, 0
        asrt.equal auth.modes.web, 1

      'should throw error on misformed config': (auth) ->
        asrt.throws ->
          auth.config
            usesname: 'pkumar'
            password: 'secret'
          , Error

      'should throw error on no mode set': (auth) ->
        asrt.throws ->
          auth.login ['repo'], (err) ->
            throw err
          , Error

  .addBatch
    'Authentication':
      topic: ->
        ghub.auth

      'through cli':
        topic: (auth) ->
          auth.config
            username: 'pkumar'
            password: 'password'

        'should set the correct mode': (auth) ->
          asrt.equal auth.mode, 0

  .addBatch
    'Authentication':
      topic: ->
        ghub.auth

      'through web':
        topic: (auth) ->
          auth.config
            client_id: 'clientid'
            client_secret: 'secret'

        'should set the correct mode': (auth) ->
          asrt.equal auth.mode, 1

        'calling login([])':
          topic: (auth) ->
            auth.login ['repo', 'user']

          'should give correct url': (url) ->
            asrt.equal url, 'https://github.com/login/oauth/authorize?client_id=clientid&scope=repo,user'

  .export module
