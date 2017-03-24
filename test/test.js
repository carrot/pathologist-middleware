const test = require('ava')
const connect = require('connect')
const pathologist = require('..')
const path = require('path')
const request = require('supertest')
const alchemist = require('alchemist-middleware')
const fixturesPath = path.join(__dirname, 'fixtures')

const routes = {
  '/admin/**': '/admin.html',
  '**': '/index.html'
}

test('should be registered as middleware', (t) => {
  t.notThrows(() => { connect().use(pathologist()) })
})

test('should match on the namespaced admin route', (t) => {
  return request(getApp(routes))
    .get('/admin/dashboard')
    .expect(200)
    .then((res) => t.is(res.text, '<p>hello world from admin!</p>\n'))
})

test('should match all other routes due to ** globstar', (t) => {
  return request(getApp(routes))
    .get('/fizz/buzz')
    .expect(200)
    .then((res) => t.is(res.text, '<p>hello world from index!</p>\n'))
})

test('should match on the full globstar route', (t) => {
  return request(getApp(routes))
    .get('/dashboard')
    .expect(200)
    .then((res) => t.is(res.text, '<p>hello world from index!</p>\n'))
})

test('should pass it to the next middleware unmodified', (t) => {
  return request(getApp({ '/admin/**': '/admin.html' }))
    .get('/index.html')
    .expect(200)
    .then((res) => t.is(res.text, '<p>hello world from index!</p>\n'))
})

function getApp (routes) {
  return connect()
    .use(pathologist(path.join(fixturesPath, 'basic'), routes))
    .use(alchemist(path.join(fixturesPath, 'basic')))
}
