## Libraries
express = require 'express'
http = require 'http'
socketio = require 'socket.io'
twit = require 'twit'


## Servers
app = express()
server = http.createServer app
io = socketio.listen server


## Configuration
CONFIG =
    port: process.env.VCAP_APP_PORT || 1337
    user: process.env.TWITTER_SCREEN_NAME
    nodefly: process.env.NODEFLY_TOKEN || null
    app_name: process.env.APP_NAME || 'fmartingrcom'
    twitter:
        consumer_key: process.env.TWITTER_CONSUMER_KEY
        consumer_secret: process.env.TWITTER_CONSUMER_SECRET
        access_token: process.env.TWITTER_TOKEN_KEY
        access_token_secret: process.env.TWITTER_TOKEN_SECRET

app.configure ->
    app.use '/', express.static __dirname + '/public'


# HTTP
server.listen CONFIG.port

## Nodefly
# Giving errors on AppFog due to gcinfo module
#if CONFIG.nodefly isnt null
#    appfog = JSON.parse process.env.VMC_APP_INSTANCE
#    require('nodefly').profile CONFIG.nodefly, 
#        [APPLICATION_NAME, appfog.name, appfog.instance_index]


## SocketIO
if process.env.VCAP_APP_PORT? # APPFog only configuration
    io.configure ->
        io.set "transports", ["xhr-polling"]
        io.set "polling duration", 10 

#io.sockets.on 'connection', (socket) ->


## Twitter handler
twitter = new twit CONFIG.twitter

stream = twitter.stream 'user', { with: 'user' }

stream.on 'tweet', (_tweet) ->
    if _tweet.user.screen_name is CONFIG.user
        io.sockets.emit 'tweet', { text: "#{_tweet.text}" }
