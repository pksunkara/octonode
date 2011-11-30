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
  info: (cb) ->
    @client.get "/orgs/#{@name}", cb
