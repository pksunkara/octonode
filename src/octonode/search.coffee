#
# search.coffee: Github search class
#
# Copyright © 2013 Pavan Kumar Sunkara. All rights reserved
#

# Requiring modules
Base = require './base'

# Initiate class
class Search extends Base

  constructor: (@client) ->

  # Search issues
  issues: (params, cb) ->
    @client.get "/search/issues", params, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Search issues error')) else cb null, b, h

  # Search repositories
  repos: (params, cb) ->
    @client.get "/search/repositories", params, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Search repos error')) else cb null, b, h

  # Search users
  users: (params, cb) ->
    @client.get "/search/users", params, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Search users error')) else cb null, b, h

  # Search code
  code: (params, cb) ->
    @client.get "/search/code", params, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Search email error')) else cb null, b, h

# Export module
module.exports = Search
