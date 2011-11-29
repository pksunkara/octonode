#
# auth.coffee: Authentication module for github
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

auth = module.exports

# Requiring modules
octonode = require '../octonode'

auth.load (options) ->
  return this
