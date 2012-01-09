#
# auth.coffee: Authentication module for github
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

# Requiring modules
request = require 'request'
qs = require 'querystring'

# Authentication module
auth = module.exports =

  # Authentication modes
  modes:
    cli: 0
    web: 1

  config: (options) ->
    if options.username and options.password
      @mode = @modes.cli
    else if options.client_id and options.client_secret
      @mode = @modes.web
    else
      throw new Error('No working mode recognized')
    @options = options
    return this

  login: (scopes, callback) ->
    if @mode == @modes.cli
      request
        url: "https://#{@options.username}:#{@options.password}@api.github.com/authorizations"
        method: 'POST'
        body: JSON.stringify
          "scopes": scopes
        headers:
          'Content-Type': 'application/json'
      , (err, res, body) ->
        body = JSON.parse body
        return callback(err,new Error(body.message) ) if res.statusCode is 401
        callback null,body.token
    else if @mode == @modes.web
      if scopes instanceof Array
        uri = 'https://github.com/login/oauth/authorize'
        uri+= '?client_id=' + @options.client_id
        uri+= '&scope=' + scopes.join(',')
      else
        request
          url: 'https://github.com/login/oauth/access_token'
          method: 'POST'
          body: qs.stringify
            code: scopes
            client_id: @options.client_id
            client_secret: @options.client_secret
          headers:
            'Content-Type': 'application/x-www-form-urlencoded'
        , (err, res, body) ->
          return callback(new Error('Access token not found')) if res.statusCode is 404
          body = qs.parse body
          return callback(new Error(body.error)) if body.error
          callback null,body.access_token
    else
      callback new Error('No working mode defined')
