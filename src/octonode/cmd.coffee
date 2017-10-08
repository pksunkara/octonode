#
# cmd.coffee: Generic Github command class
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

# Requiring modules

# Initiate class
class Cmd

  # Add http conditional "etag"
  conditional: (etag) -> @
    @client.conditional(etag)

# Export module
module.exports = Cmd
