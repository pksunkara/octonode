#
# client.coffee: A client for github
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

# Requiring modules
request = require 'request'

# Initiate class
class Client

  constructor: (@token) ->

  # Github api URL builder
  query: (uri) ->
    uri = "https://api.github.com#{uri}"
    uri+= "?access_token=#{@token}" if @token
    return uri

  # Github api GET request
  get: (path, callback) ->
    request
      uri: @query path
      method: 'GET'
    , (err, res, body) ->
      if err then throw err
      callback res.statusCode, JSON.parse(body)

  # Github api POST request
  post: (path, content={}, callback) ->
    request
      uri: @query path
      method: 'POST'
      body: JSON.stringify content
      headers:
        'Content-Type': 'application/json'
    , (err, res, body) ->
      if err then throw err
      callback res.statusCode, JSON.parse(body)

  # Github api PUT request
  put: (path, content={}, callback) ->
    request
      uri: @query path
      method: 'PUT'
      body: JSON.stringify content
      headers:
        'Content-Type': 'application/json'
    , (err, res, body) ->
      if err then throw err
      callback res.statusCode, JSON.parse(body)

  # Github api DELETE request
  del: (path, content={}, callback) ->
    request
      uri: @query path
      method: 'DELETE'
      body: JSON.stringify content
      headers:
        'Content-Type': 'application/json'
    , (err, res, body) ->
      if err then throw err
      callback res.statusCode, JSON.parse(body)

# Export modules
module.exports = Client
