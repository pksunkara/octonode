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
  # `/user`
  info: (cb) ->
    @client.get '/user', (s, b) ->
      if s is 404 then throw new Error 'User not found' else cb b

  # Update user
  update: (info, cb) ->
    @client.post '/user', info, (s, b) ->
      if s isnt 200 then throw new Error 'User update error' else cb b

  # Get emails of the user
  # '/user/emails'
  emails: (cbOrEmails, cb) ->
    if cb? and typeof cbOrEmails isnt 'function'
      @setEmails cbOrEmails, cb
    else if not cb? and typeof cbOrEmails isnt 'function'
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
  # '/user/followers'
  followers: (cb) ->
    @client.get '/user/followers', (s, b) ->
      if s isnt 200 then throw new Error 'User followers error' else cb b

  # Get the followings of the user
  # '/user/following'
  following: (cbOrUser, cb) ->
    if cb? and typeof cbOrUser isnt 'function'
      @checkFollowing cbOrUser, cb
    else
      @client.get '/user/following', (s, b) ->
        if s isnt 200 then throw new Error 'User following error' else cbOrUser b

  # Check if you are following a user
  # '/user/following/pkumar'
  checkFollowing: (cbOrUser, cb) ->
    @client.get "/user/following/#{cb}", (s, b) ->
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
