#
# label.coffee: Github label class
#
# Copyright © 2014 Matthew Taylor. All rights reserved
#

# Requiring modules
Base = require './base'

# Initiate class
class Label extends Base

  constructor: (@repo, @name, @client) ->

  # Get a single label
  # '/repos/pksunkara/hub/labels/todo' GET
  info: (cb) ->
    @client.get encodeURI("/repos/#{@repo}/labels/#{@name}"), (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Label info error")) else cb null, b, h

  # Edit a label for a repository
  # '/repos/pksunkara/hub/labels/todo' PATCH
  update: (obj, cb) ->
    @client.post "/repos/#{@repo}/labels/#{@name}", obj, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Label update error")) else cb null, b, h

  # Delete a label for a repository
  # '/repos/pksunkara/hub/labels/todo' DELETE
  delete: (cb) ->
    @client.del encodeURI("/repos/#{@repo}/labels/#{@name}"), {}, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 204 then cb(new Error("Label delete error")) else cb null, b, h


# Export module
module.exports = Label
