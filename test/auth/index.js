var asrt = require('assert')
  , vows = require('vows')
  , sprt = require('../support')
  , ghub = require('../../lib/octonode');

vows.describe('auth').addBatch({
  'Authentication': {
    topic: function() {
      return ghub.auth;
    },
    'should have correct modes': function(auth) {
      asrt.equal(auth.modes.cli, 0);
      asrt.equal(auth.modes.web, 1);
    },
    'should throw error on misformed config': function(auth) {
      asrt.throws(function() {
        return auth.config({
          usesname: 'pkumar',
          password: 'secret'
        }, Error);
      });
    },
    'should throw error on no mode set': function(auth) {
      asrt.throws(function() {
        return auth.login(['repo'], function(err) {
          throw err;
        }, Error);
      });
    }
  }
}).addBatch({
  'Authentication': {
    topic: function() {
      return ghub.auth;
    },
    'through cli': {
      topic: function(auth) {
        return auth.config({
          username: 'pkumar',
          password: 'password'
        });
      },
      'should set the correct mode': function(auth) {
        asrt.equal(auth.mode, 0);
      }
    }
  }
}).addBatch({
  'Authentication': {
    topic: function() {
      return ghub.auth;
    },
    'through web': {
      topic: function(auth) {
        return auth.config({
          id: 'clientid',
          secret: 'secret'
        });
      },
      'should set the correct mode': function(auth) {
        asrt.equal(auth.mode, 1);
      },
      'calling login([])': {
        topic: function(auth) {
          return auth.login(['repo', 'user']);
        },
        'should give correct url': function(url) {
          url = url.split('&');
          asrt.equal(url[0], 'https://github.com/login/oauth/authorize?client_id=clientid');
          asrt.equal(url[2], 'scope=repo,user');
        }
      }
    }
  }
}).export(module);
