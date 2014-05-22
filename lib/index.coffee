minimatch = require 'minimatch'

module.exports = (base, routes) ->
  if typeof base isnt 'string'
    routes  = base
    base    = process.cwd()

  return (req, res, next) ->
    # if no extension present, assume it's an html request
    ext = req.url.split('.')[1] || 'html'
    for k, v of routes when minimatch(req.url, k) and ext == 'html'
      req.url = v
      return next()
    next()
