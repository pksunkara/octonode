#
# project.coffee: Github milestone class
#

# Requiring modules
Base = require './base'

# Initiate class
class Project extends Base

  constructor: (@repo, @number, @client) ->

  # Get a single project
  # '/repos/pksunkara/hub/projects/37' GET
  info: (cb) ->
    @client.get "/repos/#{@repo}/projects/#{@number}", (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Project info error")) else cb null, b, h

  # Edit an project for a repository
  # '/repos/pksunkara/hub/projects/37' PATCH
  update: (obj, cb) ->
    @client.post "/repos/#{@repo}/projects/#{@number}", obj, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Project update error")) else cb null, b, h

  # Delete a project for a repository
  # '/repos/pksunkara/hub/projects/37' DELETE
  delete: (cb) ->
    @client.del "/repos/#{@repo}/projects/#{@number}", {}, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 204 then cb(new Error("Project delete error")) else cb null, b, h


# Export module
module.exports = Project
