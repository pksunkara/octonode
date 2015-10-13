var asrt = require('assert')
  , fs = require('fs')
  , path = require('path')
  , vows = require('vows')
  , sprt = require('../support')
  , ghub = require('../../lib/octonode')
  , config
  , releaseNumber
  , client;
config = JSON.parse(fs.readFileSync(path.join(__dirname, '../config.json')));

client = ghub.client(config.auth);

vows.describe('Release').addBatch({
  'get release': {
    topic: function() {
      var release = client.release(config.repo, 1);
      release.info(this.callback);
    },
    'shouldn\'t find the related release': function(err, result) {
      asrt.equal(err.statusCode, 404);
      asrt.equal(err.body.message, 'Not Found');
    }
  }
}).addBatch({
  'create release': {
    topic: function() {
      var repo = client.repo(config.repo);
      repo.release({ tag_name: 'v1.0.0', draft: true }, this.callback);
    },
    'should create a release with tag v1.0.0': function(err, result) {
      var tag = result.tag_name;
      var draft = result.draft;
      releaseNumber = result.id;
      asrt.equal(result.tag_name, 'v1.0.0');
      asrt.equal(result.draft, true);
    }
  }
}).addBatch({
  'upload assets': {
    topic: function() {
      return client.release(config.repo, releaseNumber);
    },
    'with no options': {
      topic: function(release) {
        var file = fs.readFileSync(path.join(__dirname, '../file.zip'));
        release.uploadAssets(file, this.callback);

      },
      'should upload an asset without passing custom options': function(err, result) {
        asrt.equal(result.name, 'archive.zip');
        asrt.equal(result.content_type, 'application/zip');
      }
    },
    'with custom options': {
      topic: function(release) {
        var file = fs.readFileSync(path.join(__dirname, '../image.png'));
        var options = {
          name: 'octonode.png',
          contentType: 'image/png',
          uploadHost: 'uploads.github.com'
        };
        release.uploadAssets(file, options, this.callback);

      },
      'should upload an asset passing custom options': function(err, result) {
        asrt.equal(result.name, 'octonode.png');
        asrt.equal(result.content_type, 'image/png');
      }
    }
  }
})
.export(module);
