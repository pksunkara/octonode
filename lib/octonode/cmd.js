// Generated by CoffeeScript 1.12.7
(function() {
  var Cmd;

  Cmd = (function() {
    function Cmd() {}

    Cmd.prototype.conditional = function(etag) {
      this.client.conditional(etag);
      return this;
    };

    return Cmd;

  })();

  module.exports = Cmd;

}).call(this);