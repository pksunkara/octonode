#
# auth.coffee: Authentication module for github
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

# Requiring modules
request = require 'request'
url = require 'url'
qs = require 'querystring'
randomstring = require 'randomstring'

# Authentication module
auth = module.exports =

  # Authentication modes
  modes:
    cli: 0
    web: 1

  config: (options) ->
    if options.username and options.password
      @mode = @modes.cli
    else if options.id and options.secret
      @mode = @modes.web
    else
      throw new Error('No working mode recognized')
    @options = options
    return this

  revoke: (id, callback) ->
    if @mode == @modes.cli
      options =
        url: url.parse "https://api.github.com/authorizations/#{id}"
        method: 'DELETE'
        headers:
          'User-Agent': 'octonode/0.3 (https://github.com/pksunkara/octonode) terminal/0.0'
      options.url.auth = "#{@options.username}:#{@options.password}"
      request options, (err, res, body) ->
        if err? or res.statusCode isnt 204 then callback(err or new Error(JSON.parse(body).message)) else callback(null)
    else
      callback new Error('Cannot revoke authorization in web mode')

  login: (scopes, callback) ->
    if @mode == @modes.cli
      unless scopes instanceof Array
        scopes = [ scopes ]
      options =
        url: url.parse "https://api.github.com/authorizations"
        method: 'POST'
        body: JSON.stringify
          scopes: scopes
          client_id: @options.id
          client_secret: @options.secret
          fingerprint: @options.fingerprint
          note: @options.note
          note_url: @options.note_url
        headers:
          'Content-Type': 'application/json'
          'User-Agent': 'octonode/0.3 (https://github.com/pksunkara/octonode) terminal/0.0'
      options.url.auth = "#{@options.username}:#{@options.password}"

      # Check for a one time password (for two factor authentication)
      if @options.otp then options.headers['X-GitHub-OTP'] = @options.otp

      request options, (err, res, body) ->
        if err?
          callback err
        else
          try
            body = JSON.parse body
          catch err
            callback new Error('Unable to parse body')
          if res.statusCode is 201 then callback(null, body.id, body.token) else callback(new Error(body.message))
    else if @mode == @modes.web
      if scopes instanceof Array
        uri = 'https://github.com/login/oauth/authorize'
        uri+= "?client_id=#{@options.id}"
        uri+= "&state=#{randomstring.generate()}"
        uri+= "&scope=#{scopes.join(',')}"
        if @options.redirect_uri then uri+= "&redirect_uri=#{@options.redirect_uri}"
        return uri
      else
        request
          url: 'https://github.com/login/oauth/access_token'
          method: 'POST'
          body: qs.stringify
            code: scopes
            client_id: @options.id
            client_secret: @options.secret
          headers:
            'Content-Type': 'application/x-www-form-urlencoded'
            'User-Agent': 'octonode/0.3 (https://github.com/pksunkara/octonode) terminal/0.0'
        , (err, res, body) ->
          if err?
            callback err
          else if res.statusCode is 404
            callback(new Error('Access token not found'))
          else
            body = qs.parse body
            if body.error then callback(new Error(body.error)) else callback(null, body.access_token)
    else
      callback new Error('No working mode defined')
