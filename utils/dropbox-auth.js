var Dropbox = require("dropbox");

if (!process.env.DROPBOX_KEY || !process.env.DROPBOX_SECRET) {
    console.log('Set up environment variables first!');
    process.exit(-1);
}

var dropbox_app = {
    key: process.env.DROPBOX_KEY,
    secret: process.env.DROPBOX_SECRET
};

var client = new Dropbox.Client({
    key: dropbox_app.key,
    secret: dropbox_app.secret,
    sandbox: true
});

client.authDriver(new Dropbox.Drivers.NodeServer(8191));
client.authenticate(function(error, client) {
    if (error) {
        console.log(error);
    }
    console.log("Your auth credentials:");
    console.log("Token: " + client.oauth.token);
    console.log("Secret: " + client.oauth.secret);
    process.exit(0);
});
