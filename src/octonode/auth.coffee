#
# auth.coffee: Authentication module for github
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

# Requiring modules
request = require 'request'

# Authentication module
auth = module.exports =

  # Authentication modes
  modes:
    cli: 0
    web: 1

  load: (options) ->
    if options.username and options.password
      @mode = @modes.cli
    else if options.client_id and options.client_secret
      @mode = @modes.web
    @options = options

  login: (scopes) ->
    if @mode==@modes.cli
      request
        url: "https://#{@options.username}:#{@options.password}@api.github.com/authorizations",
        method: 'POST',
        body: JSON.stringify
          "scopes": scopes
        headers:
          'Content-type': 'application/json'
      , (err, res, body) ->
        console.log JSON.parse(body)
