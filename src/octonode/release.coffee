#
# release.coffee: Github release class
#
# Copyright © 2013 Josh Priestley. All rights reserved
#

# Initiate class
class Release

  constructor: (@repo, @number, @client) ->

  # Get a single release
  # '/repos/pksunkara/hub/releases/37' GET
  info: (cb) ->
    @client.get "/repos/#{@repo}/releases/#{@number}", (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Release info error")) else cb null, b, h

  # Attach a file to a release
  # '/repos/pksunkara/hub/releases/37/assets?name=archive.zip' POST
  assets: (uploadHost, name, file, contentType, cb) ->
    options =
      params:
        name: name
      body: file
      headers:
        'Content-Type': contentType
    @client.post "https://#{uploadHost}/repos/#{@repo}/releases/#{@number}/assets", null, options, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 201 then cb(new Error("Release assets error")) else cb null, b, h

# Export module
module.exports = Release
