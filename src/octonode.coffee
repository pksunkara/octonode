#
# octonode.coffee: Top level include for octonode module
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

octonode = module.exports

# Requiring modules
octonode.request = require 'request'

# [Authentication](octonode/auth.html) for github
octonode.auth = require './octonode/auth'
