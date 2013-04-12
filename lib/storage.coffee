fs = require 'fs'


class StorageManager
    options: {}

    deleteFolder: (path) ->
        files = []
        if not path
            path = this.dataFolder

        if fs.existsSync path
            files = fs.readdirSync path
            files.forEach (file, index) =>
                currentPath = path + "/" + file
                if fs.statSync(currentPath).isDirectory()
                    this.deleteFolder currentPath
                else
                    fs.unlinkSync currentPath

        if path != this.dataFolder
            fs.rmdirSync path


class DropboxStorageManager extends StorageManager
    constructor: ->
        this.dropbox = require 'dropbox'
        this.connected = false
        this.initialized = false
        this.dataFolder = 'data'
        this.cursorFile = this.dataFolder + '/.cursor'
        this.cursorTag = false

    getConnectionInfo: ->
        info =
            key: process.env.DROPBOX_KEY
            secret: process.env.DROPBOX_SECRET
            token: process.env.DROPBOX_ACCESS_KEY
            tokenSecret: process.env.DROPBOX_ACCESS_SECRET
        return info

    connect: ->
        options = this.getConnectionInfo()
        this.options.key = options.key
        this.options.secret = options.secret
        this.options.token = options.token
        this.options.tokenSecret = options.tokenSecret
        this.options.sandbox = true
        this.client = new this.dropbox.Client this.options
        this.client.authenticate (error, client) =>
            console.log(error) if error
            if not error
                this.connected = true
        this.initialize()

    initialize: ->
        if fs.existsSync this.cursorFile
            cursor = fs.readFileSync this.cursorFile
            if cursor
                this.cursorTag = cursor
        this.sync()
        this._syncInterval = setInterval =>
            this.sync()
        , 5000

    updateCursor: (cursor) ->
        this.cursorTag = cursor
        fs.writeFileSync this.cursorFile, cursor, 'utf-8', (error) ->
            console.log error if error

    sync: ->
        syncOptions = null
        if this.cursorTag
            syncOptions = {}
            syncOptions.cursorTag = this.cursorTag

        this.client.delta syncOptions, (status, reply) =>
            if false
                console.log 'Status:'
                console.log status
                console.log 'Reply:'
                console.log reply


            if reply.blankSlate
                console.log '[<>] Black state. Removing all data files'
                this.deleteFolder()

            for change in reply.changes
                console.log 'Updating: ' + change.path
                path = this.dataFolder + change.path

                # Removed files/folders
                if change.wasRemoved
                    if fs.existsSync path  # Change went too fast?
                        if fs.lstatSync(path).isDirectory()
                            fs.rmdirSync path
                        else
                            fs.unlinkSync this.dataFolder + change.path
                else
                    # Created ones
                    if change.stat.isFolder
                        if not fs.existsSync path  # Change went too fast?
                            fs.mkdirSync path
                    else if change.stat.isFile
                        this.retrieve change.path
                        
            this.updateCursor(reply.cursorTag)

            #if reply.shouldPullAgain
            #    this.sync()


    retrieve: (file) ->
        this.client.readFile file, (error, data) =>
            if error
                console.log error
            fs.writeFileSync this.dataFolder + file, data, 'utf-8', (error) ->
                console.log error


exports.StorageManager = new StorageManager()
exports.DropboxStorageManager = new DropboxStorageManager()
