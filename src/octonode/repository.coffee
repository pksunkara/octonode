#
# repository.coffee: Github repository class
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

# Requiring modules

# Initiate class
class Repository

  constructor: (@name, @client) ->

  # Get a repository
  # '/repos/pkumar/hub' GET
  info: (cb) ->
    @client.get "/repos/#{@name}", (err, s, b)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Repository info error')) cb null, b

# Export module
module.exports = Repository
