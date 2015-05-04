connect   = require 'connect'
alchemist = require 'alchemist-middleware'

describe 'basic', ->

  it 'should be registered as middleware', ->
    (-> connect().use(pathologist())).should.not.throw()

describe 'routing', ->
  describe 'route match', ->
    before ->
      @app = connect()
        .use(
          pathologist(path.join(base_path, 'basic'),
            '/admin/**':  '/admin.html',
            '**':         '/index.html'
          )
        ).use(alchemist(path.join(base_path, 'basic')))

    it 'should match on the namespaced admin route', (done) ->
      chai.request(@app).get('/admin/dashboard').end (err, res) ->
        res.should.have.status(200)
        res.text.should.equal('<p>hello world from admin!</p>\n')
        done()

    it 'should match all other routes due to ** globstar', (done) ->
      chai.request(@app).get('/fizz/buzz').end (err, res) ->
        res.should.have.status(200)
        res.text.should.equal('<p>hello world from index!</p>\n')
        done()

    it 'should match on the full globstar route', (done) ->
      chai.request(@app).get('/dashboard').end (err, res) ->
        res.should.have.status(200)
        res.text.should.equal('<p>hello world from index!</p>\n')
        done()

  describe 'no match', ->
    it 'should pass it to the next middleware unmodified', (done) ->
      app = connect()
        .use(
          pathologist(path.join(base_path, 'basic'),
            '/admin/**':  '/admin.html'
          )
        ).use(alchemist(path.join(base_path, 'basic')))

      chai.request(app).get('/index.html').end (err, res) ->
        res.should.have.status(200)
        res.text.should.equal('<p>hello world from index!</p>\n')
        done()
