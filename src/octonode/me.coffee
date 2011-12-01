#
# me.coffee: Github authenticated user class
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

# Requiring modules

# Initiate class
class Me

  constructor: (@client) ->

  # Get a user
  # '/user' GET
  info: (cb) ->
    @client.get '/user', (s, b) ->
      if s is 404 then throw new Error 'User not found' else cb b

  # Update user
  # '/user' PATCH
  update: (info, cb) ->
    @client.put '/user', info, (s, b) ->
      if s isnt 200 then throw new Error 'User update error' else cb b

  # Get emails of the user
  # '/user/emails' GET
  emails: (cbOrEmails, cb) ->
    if cb? and typeof cbOrEmails isnt 'function'
      @setEmails cbOrEmails, cb
    else if !cb? and typeof cbOrEmails isnt 'function'
      @delEmails cbOrEmails
    else
      @client.get '/user/emails', (s, b) ->
        if s isnt 200 then throw new Error 'User emails error' else cbOrEmails b

  # Set emails of the user
  # '/user/emails' POST
  setEmails: (emails, cb) ->
    @client.post '/user/emails', emails, (s, b) ->
      if s isnt 201 then throw new Error 'User setEmails error' else cb b

  # Delete emails of the user
  # '/user/emails' DELETE
  delEmails: (emails) ->
    @client.del '/user/emails', emails, (s, b) ->
      if s isnt 204 then throw new Error 'User delEmails error'

  # Get the followers of the user
  # '/user/followers' GET
  # TODO: page, user
  followers: (cb) ->
    @client.get '/user/followers', (s, b) ->
      if s isnt 200 then throw new Error 'User followers error' else cb b

  # Get the followings of the user
  # '/user/following' GET
  # TODO: page, user
  following: (cbOrUser, cb) ->
    if cb? and typeof cbOrUser isnt 'function'
      @checkFollowing cbOrUser, cb
    else
      @client.get '/user/following', (s, b) ->
        if s isnt 200 then throw new Error 'User following error' else cbOrUser b

  # Check if you are following a user
  # '/user/following/pkumar' GET
  checkFollowing: (cbOrUser, cb) ->
    @client.get "/user/following/#{cbOrUser}", (s, b) ->
      if s is 204 then cb(true) else cb(false)

  # Follow a user
  # '/user/following/pkumar' PUT
  follow: (user) ->
    @client.put "/user/following/#{user}", {}, (s, b) ->
      if s isnt 204 then throw new Error 'User follow error'

  # Unfollow a user
  # '/user/following/pkumar' DELETE
  unfollow: (user) ->
    @client.del "/user/following/#{user}", {}, (s, b) ->
      if s isnt 204 then throw new Error 'User unfollow error'

  # Get public keys of a user
  # '/user/keys' GET
  keys: (cbOrIdOrKey, cbOrKey, cb) ->
    if !cb? and typeof cbOrIdOrKey is 'number' and typeof cbOrKey is 'function'
      @getKey cbOrIdOrKey, cbOrKey
    else if !cbOrKey? and !cb? and typeof cbOrIdOrKey is 'number'
      @delKey cbOrIdOrKey
    else if !cb? and typeof cbOrKey is 'function' and typeof cbOrIdOrKey is 'object'
      @createKey cbOrIdOrKey, cbOrKey
    else if typeof cb is 'function' and typeof cbOrIdOrKey is 'number' and typeof cbOrKey 'object'
      @updateKey cbOrIdOrKey, cbOrKey, cb
    else
      @client.get '/user/keys', (s, b) ->
        if s isnt 200 then throw new Error 'User keys error' else cbOrIdOrKey b

  # Get a single public key
  # '/user/keys/1' GET
  getKey: (id, cb) ->
    @client.get "/user/keys/#{id}", (s, b) ->
      if s isnt 200 then throw new Error 'User getKey error' else cb b

  # Create a public key
  # '/user/keys' POST
  createKey: (key, cb) ->
    @client.post '/user/keys', key, (s, b) ->
      if s isnt 201 then throw new Error 'User createKey error' else cb b

  # Update a public key
  # '/user/keys/1' PATCH
  updateKey: (id, key, cb) ->
    @client.put "/user/keys/#{id}", key, (s, b) ->
      if s isnt 200 then throw new Error 'User updateKey error' else cb b

  # Delete a public key
  # '/user/keys/1' DELETE
  delKey: (id) ->
    @client.del "/user/keys/#{id}", (s, b) ->
      if s isnt 204 then throw new Error 'User delKey error'
