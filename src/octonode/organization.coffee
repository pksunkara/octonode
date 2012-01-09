#
# organization.coffee: Github organization class
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

# Requiring modules

# Initiate class
class Organization

  constructor: (@name, @client) ->

  # Get an organization
  # '/orgs/flatiron' GET
  info: (cb) ->
    @client.get "/orgs/#{@name}", (err,s, b)  ->
      return cb(err) if err
      return cb(new Error( 'Organization info error')) if s isnt 200
      cb null,b

# Export module
module.exports = Organization
