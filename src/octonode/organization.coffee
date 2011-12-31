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
    @client.get "/orgs/#{@name}", (s, b) ->
      if s isnt 200 then throw new Error 'Organization info error' else cb b

# Export module
module.exports = Organization
