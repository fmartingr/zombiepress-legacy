storage = new require('./lib/storage.coffee').DropboxStorageManager

storage.connect
    key: process.env.DROPBOX_KEY
    secret: process.env.DROPBOX_SECRET
    access_key: process.env.DROPBOX_ACCESS_KEY
    access_secret: process.env.DROPBOX_ACCESS_SECRET

#storage.get 'configuration.toml'
storage.get 'arch_base.sh'
