#
# auth.coffee: Authentication module for github
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

# Requiring modules
request = require 'request'
url = require 'url'
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
      if scopes instanceof Array
        scopes = JSON.stringify scopes: scopes
      else
        scopes = JSON.stringify scopes
      options =
        url: url.parse "https://api.github.com/authorizations"
        method: 'POST'
        body: scopes
        headers:
          'Content-Type': 'application/json'
          'User-Agent': 'octonode/0.3 (https://github.com/pksunkara/octonode) terminal/0.0'
      options.url.auth = "#{@options.username}:#{@options.password}"
      request options, (err, res, body) ->
        if err?
          callback err
        else
          try
            body = JSON.parse body
          catch err
            callback new Error('Unable to parse body')
          if res.statusCode is 401 then callback(new Error(body.message)) else callback(null, body.id, body.token)
    else if @mode == @modes.web
      if scopes instanceof Array
        uri = 'https://github.com/login/oauth/authorize'
        uri+= '?client_id=' + @options.id
        uri+= '&scope=' + scopes.join(',')
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
          if res.statusCode is 404
            callback(new Error('Access token not found'))
          else
            body = qs.parse body
            if body.error then callback(new Error(body.error)) else callback(null, body.access_token)
    else
      callback new Error('No working mode defined')
