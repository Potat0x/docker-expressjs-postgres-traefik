const express = require('express');
const os = require('os');
const pgp = require('pg-promise')();

const app = express();
const port = 8080;

const databaseHost = process.env.POSTGRES_HOST;
const databasePassword = process.env.POSTGRES_PASSWORD;

// postgres://username:password@host:port/database
const db = pgp(`postgres://postgres:${databasePassword}@${databaseHost}:5432/postgres`);

app.get('/', (req, res) => res.send(`Hello World!<br>${os.hostname()}<br>${os.uptime()}`));
app.get('/pgtest', (req, res) => {
    return db.any('SELECT * FROM hello_world;')
        .then(data => {
            console.log('DATA:', data);
            res.send(data);
        })
        .catch(error => {
            console.log('ERROR:', error);
            res.send(error);
        });
});

app.listen(port, () => console.log(`Example app listening on port ${port}!`));
