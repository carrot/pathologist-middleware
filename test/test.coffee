connect   = require 'connect'
alchemist = require 'alchemist-middleware'

describe 'basic', ->

  it 'should be registered as middleware', ->
    (-> connect().use(pathologist())).should.not.throw()

describe 'routing', ->
  before ->
    @app = connect()
      .use(
        pathologist(path.join(base_path, 'basic'),
          '/admin/**':  '/admin.html',
          '**':         '/index.html'
        )
      ).use(
        alchemist(path.join(base_path, 'basic'))
      )

  it 'should match on the namespaced admin route', (done) ->
    chai.request(@app).get('/admin/dashboard').res (res) ->
      res.should.have.status(200)
      res.text.should.equal('<p>hello world from admin!</p>\n')
      done()

  it 'should match all other routes due to ** globstar', (done) ->
    chai.request(@app).get('/fizz/buzz').res (res) ->
      res.should.have.status(200)
      res.text.should.equal('<p>hello world from index!</p>\n')
      done()

  it 'should match on the full globstar route', (done) ->
    chai.request(@app).get('/dashboard').res (res) ->
      res.should.have.status(200)
      res.text.should.equal('<p>hello world from index!</p>\n')
      done()
