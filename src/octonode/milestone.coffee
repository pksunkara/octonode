#
# milestone.coffee: Github milestone class
#
# Copyright © 2014 Matthew Taylor. All rights reserved
#

# Requiring modules
Base = require './base'

# Initiate class
class Milestone extends Base

  constructor: (@repo, @number, @client) ->

  # Get a single milestone
  # '/repos/pksunkara/hub/milestones/37' GET
  info: (cb) ->
    @client.get "/repos/#{@repo}/milestones/#{@number}", (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Milestone info error")) else cb null, b, h

  # Edit an milestone for a repository
  # '/repos/pksunkara/hub/milestones/37' PATCH
  update: (obj, cb) ->
    @client.post "/repos/#{@repo}/milestones/#{@number}", obj, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Milestone update error")) else cb null, b, h

  # Delete a milestone for a repository
  # '/repos/pksunkara/hub/milestones/37' DELETE
  delete: (cb) ->
    @client.del "/repos/#{@repo}/milestones/#{@number}", {}, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 204 then cb(new Error("Milestone delete error")) else cb null, b, h


# Export module
module.exports = Milestone
