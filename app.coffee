# Modules
toml = require 'tomljs'

# Libraries
storage = require('./lib/storage.coffee').DropboxStorageManager

config = require('./lib/config.coffee').TOMLConfigManager
config.storage = storage
config.reload()

storage.registerAlert '/configuration.toml', (file) ->
    config.reload()

storage.registerAlert '/routing.toml', (file) =>
    routes = toml storage.get(file)
    console.log routes
    router = new director.http.Router routes

storage.connect()
