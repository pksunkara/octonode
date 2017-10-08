#
# notification.coffee: Github notification class
#
# Copyright © 2015 Steve Smith. All rights reserved
#

# Requiring modules
Base = require './base'

# Initiate class
class Notification extends Base

  constructor: (@id, @client) ->

  # Mark a notification as read
  # '/notifications/threads/:id' PATCH
  markAsRead: (cb) ->
    @client.post "/notifications/threads/#{@id}", {}, (err, s, b, h)  ->
      return cb(err) if err
      if s isnt 205 then cb(new Error('Notification mark as read error')) else cb null, b, h

  # Unsubscribe from a thread
  # '/notifications/threads/:id/subscription' DELETE
  unsubscribe: (cb) ->
    @client.del "/notifications/threads/#{@id}/subscription", {}, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 204 then cb(new Error('User mute error')) else cb null, b, h

  # Subscribe to a thread
  # '/notifications/threads/:id/subscription' PUT
  subscribe: (cb) ->
    options =
      subscribed: true
      ignored: false
    @client.put "/notifications/threads/#{@id}/subscription", options, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('User unmute error')) else cb null, b, h

  # Stop receiving any notifications from a thread
  # '/notifications/threads/:id/subscription' PUT
  mute: (cb) ->
    options =
      subscribed: false
      ignored: true
    @client.put "/notifications/threads/#{@id}/subscription", options, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('User ignore error')) else cb null, b, h

# Export module
module.exports = Notification
