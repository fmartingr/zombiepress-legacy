class ConfigManager
    config: {}
    storage: null

    load: (file) ->


class TOMLConfigManager
    constructor: ->
        this.lib = require 'tomljs'
        this.file = '/configuration.toml'

    load: ->
        data = this.storage.get this.file
        if data
            this.config = this.lib data
        else
            console.error 'Error: Could not open config file!'

    reload: ->
        this.load()
        console.log 'Configuration reloaded'

exports.ConfigManager = new ConfigManager
exports.TOMLConfigManager = new TOMLConfigManager

