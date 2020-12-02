#
# project.coffee: Github milestone class
#

# Requiring modules
Base = require './base'

# Initiate class
class Project extends Base

  constructor: (@number, @client) ->

  # Get a single project
  # '/projects/37' GET
  info: (cb) ->
    @client.getAccept "/projects/#{@number}", 'inertia-preview', (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Project info error")) else cb null, b, h

  # Edit an project for a repository
  # '/projects/37' PATCH
  update: (obj, cb) ->
    @client.patchAccept "/projects/#{@number}", 'inertia-preview', obj, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Project update error")) else cb null, b, h

  # Delete a project for a repository
  # '/projects/37' DELETE
  delete: (cb) ->
    @client.delAccept "/projects/#{@number}", 'inertia-preview', {}, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 204 then cb(new Error("Project delete error")) else cb null, b, h


# Export module
module.exports = Project
