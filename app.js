const express = require('express')
const app = express()
const port = 8080

const pgp = require('pg-promise')(/* options */)
//const db = pgp('postgres://username:password@host:port/database')
const db = pgp('postgres://postgres:docker@pg-docker:5432/postgres');

app.get('/', (req, res) => res.send('Hello World!'))
app.get('/pgtest', (req, res) => {

    return db.any('SELECT * FROM table1;')
        .then(function (data) {
            console.log('DATA:', data);
            res.send(data);
        })
        .catch(function (error) {
            console.log('ERROR:', error);
            res.send(error);
        });
});

app.listen(port, () => console.log(`Example app listening on port ${port}!`))

