const mm = require('micromatch')

module.exports = (base, routes) => {
  if (typeof base !== 'string') {
    routes = base
    base = process.cwd()
  }

  return (req, res, next) => {
    for (let k in routes) {
      if (mm.isMatch(req.url, k)) {
        req.url = routes[k]
        return next()
      }
    }
    next()
  }
}
