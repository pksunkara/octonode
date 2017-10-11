#
# base.coffee: Base Github class
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

# Requiring modules

# Initiate class
class Base

  # Add http conditional "etag"
  conditional: (etag) ->
    @client.conditional(etag)
    return @

# Export module
module.exports = Base
