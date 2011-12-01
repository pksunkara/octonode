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

  # Get emails of the user
  # '/user/emails'
  getEmails: (cb) ->
    @client.get '/user/emails', (s, b) ->
      if s isnt 200 then throw new Error 'getEmails error' else cb b

  # Set emails of the user
  # '/user/emails' POST
  setEmails: (emails, cb) ->
    @client.post '/user/emails', emails, (s, b) ->
      if s isnt 201 then throw new Error 'setEmails error' else cb b

  # Delete emails of the user
  # '/user/emails' DELETE
  delEmails: (emails, cb) ->
    @client.del '/user/emails', emails, (s, b) ->
      if s isnt 204 then throw new Error 'delEmails error' else cb b
