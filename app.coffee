toml = require 'tomljs'

storage = new require('./lib/storage.coffee').DropboxStorageManager

storage.connect()

storage.registerAlert '/configuration.toml', (file) ->
    console.log 'CONFIGURATION CHANGED :D:D:D:D:D'
    console.log file
    console.log toml storage.get(file)
