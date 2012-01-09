fs = require 'fs'
qs = require('querystring')
async = require('async')
_ = require('underscore')

class Helper
    
  fixturePath: (fileName) =>
    "#{__dirname}/../fixtures/#{fileName}"

  tmpPath: (fileName) =>
    "#{__dirname}/../tmp/#{fileName}"

  cleanTmpFiles: (fileNames) =>
    for file in fileNames
      try
        fs.unlinkSync @tmpPath(file)
      catch ignore

  loadJsonFixture: (fixtureName) =>
    data = fs.readFileSync @fixturePath(fixtureName), "utf-8"
    JSON.parse data

  start: (obj = {}, done) =>
    _.defaults obj, { }
    # Hook up nock here
    done()
    
    
  stop: (done) =>
    done()
    
module.exports = new Helper()
