(function() {
  var Gist;

  Gist = (function() {

    function Gist(client) {
      this.client = client;
    }

    Gist.prototype.list = function(cb) {
      return this.client.get("/gists", function(err, s, b) {
        if (err) return cb(err);
        if (s !== 200) {
          return cb(new Error('Gist list error'));
        } else {
          return cb(null, b);
        }
      });
    };

    Gist.prototype.public = function(cb) {
      return this.client.get("/gists/public", function(err, s, b) {
        if (err) return cb(err);
        if (s !== 200) {
          return cb(new Error('Gist public error'));
        } else {
          return cb(null, b);
        }
      });
    };

    Gist.prototype.starred = function(cb) {
      return this.client.get("/gists/starred", function(err, s, b) {
        if (err) return cb(err);
        if (s !== 200) {
          return cb(new Error('Gist starred error'));
        } else {
          return cb(null, b);
        }
      });
    };

    Gist.prototype.user = function(user, cb) {
      return this.client.get("/users/" + user + "/gists", function(err, s, b) {
        if (err) return cb(err);
        if (s !== 200) {
          return cb(new Error('Gist user error'));
        } else {
          return cb(null, b);
        }
      });
    };

    Gist.prototype.get = function(id, cb) {
      return this.client.get("/gists/" + id, function(err, s, b) {
        if (err) return cb(err);
        if (s !== 200) {
          return cb(new Error('Gist get error'));
        } else {
          return cb(null, b);
        }
      });
    };

    Gist.prototype.create = function(gist, cb) {
      return this.client.post("/gists", gist, function(err, s, b) {
        if (err) return cb(err);
        if (s !== 201) {
          return cb(new Error('Gist create error'));
        } else {
          return cb(null, b);
        }
      });
    };

    Gist.prototype.edit = function(id, gist, cb) {
      return this.client.post("/gists/" + id, gist, function(err, s, b) {
        if (err) return cb(err);
        if (s !== 200) {
          return cb(new Error('Gist edit error'));
        } else {
          return cb(null, b);
        }
      });
    };

    Gist.prototype["delete"] = function(id) {
      var _this = this;
      return this.client.del("/gists/" + id, {}, function(err, s, b) {
        if ((err != null) || s !== 204) return _this["delete"](id);
      });
    };

    Gist.prototype.star = function(id) {
      var _this = this;
      return this.client.put("/gists/" + id + "/star", {}, function(err, s, b) {
        if ((err != null) || s !== 204) return _this.star(id);
      });
    };

    Gist.prototype.unstar = function(id) {
      var _this = this;
      return this.client.del("/gists/" + id + "/unstar", {}, function(err, s, b) {
        if ((err != null) || s !== 204) return _this.unstar(id);
      });
    };

    Gist.prototype.check = function(id) {
      return this.client.get("/gists/" + id + "/star", function(err, s, b) {
        if (err) return cb(err);
        return cb(null, s === 204);
      });
    };

    Gist.prototype.listComments = function(id, cb) {
      return this.client.get("/gists/" + id + "/comments", function(err, s, b) {
        if (err) return cb(err);
        if (s !== 200) {
          return cb(new Error('Gist comments error'));
        } else {
          return cb(null, b);
        }
      });
    };

    Gist.prototype.getComment = function(id, cb) {
      return this.client.get("/gists/comments/" + id, function(err, s, b) {
        if (err) return cb(err);
        if (s !== 200) {
          return cb(new Error('Gist getComment error'));
        } else {
          return cb(null, b);
        }
      });
    };

    Gist.prototype.createComment = function(id, comment, cb) {
      return this.client.post("/gists/" + id + "/comments", comment, function(err, s, b) {
        if (err) return cb(err);
        if (s !== 201) {
          return cb(new Error('Gist createComment error'));
        } else {
          return cb(null, b);
        }
      });
    };

    Gist.prototype.updateComment = function(id, comment, cb) {
      return this.client.post("/gists/comments/" + id, comment, function(err, s, b) {
        if (err) return cb(err);
        if (s !== 200) {
          return cb(new Error('Gist updateComment error'));
        } else {
          return cb(null, b);
        }
      });
    };

    Gist.prototype.deleteComment = function(id) {
      var _this = this;
      return this.client.del("/gists/comments/" + id, {}, function(err, s, b) {
        if ((err != null) || s !== 204) return _this.deleteComment(id);
      });
    };

    Gist.prototype.comments = function(id, cbOrCmnt, cb) {
      if (!(cb != null) && typeof cbOrCmnt === 'function') {
        return this.listComments(id, cbOrCmnt);
      } else {
        return this.createComment(id, cbOrCmnt, cb);
      }
    };

    Gist.prototype.comment = function(cbOrIdOrCmnt, cbOrCmnt, cb) {
      if (!(cb != null) && typeof cbOrIdOrCmnt === 'number' && typeof cbOrCmnt === 'function') {
        return this.getComment(cbOrIdOrCmnt, cbOrCmnt);
      } else if (!(cbOrCmnt != null) && !(cb != null) && typeof cbOrIdOrCmnt === 'number') {
        return this.deleteComment(cbOrIdOrCmnt);
      } else if (typeof cb === 'function' && typeof cbOrIdOrCmnt === 'number' && typeof cbOrCmnt('object')) {
        return this.updateComment(cbOrIdOrCmnt, cbOrCmnt, cb);
      } else {
        return cb(new Error('Gist comment error'));
      }
    };

    return Gist;

  })();

  module.exports = Gist;

}).call(this);
