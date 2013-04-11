class StorageManager
    options: {}


class DropboxStorageManager extends StorageManager
    constructor: ->
        this.dropbox = require 'dropbox'

    connect: (options) ->
        this.options.key = options.key
        this.options.secret = options.secret
        this.options.token = options.access_key
        this.options.tokenSecret = options.access_secret
        this.options.sandbox = true
        this.client = new this.dropbox.Client this.options
        this.client.authenticate (error, client) ->
            console.log(error) if error
            #ıconsole.log client
            #this.get 'config.toml'

    get: (file) ->
        this.client.readFile file, (error, data) ->
            console.log error
            console.log data


exports.StorageManager = new StorageManager()
exports.DropboxStorageManager = new DropboxStorageManager()
