minimatch = require 'minimatch'
send      = require 'send'

module.exports = (base, routes) ->
  if typeof base isnt 'string'
    routes  = base
    base    = process.cwd()

  return (req, res, next) ->
    for k, v of routes when minimatch(req.url, k)
      req.url = v
      return next()
    next()
