'use strict'
const express = require("express")
const app = express()

const staticOptions = {
    dotfiles : "deny",
    etag : "",
    extensions : "",
    fallthrough : "",
    immutable : "",
    index : "index.html",
    lastModified : "",
    maxAge : "",
    redirect : ""
}

app.use(express.static('public', staticOptions))

app.set('views', './views')
app.set('view engine', 'ejs')
const ejs = require("ejs")


const sqlite3 = require('sqlite3')
const sqlite = require('sqlite')

const multer = require('multer')
app.use(multer().none())
app.use(express.urlencoded({extended : true}));
app.use(express.json())

let INVALID_PARAM_ERROR = 400
let INVALID_PARAM_ERROR_MSG = "No results for your parameters."
let SERVER_ERROR = 500
let SERVER_ERROR_MSG = 'Something went wrong on the server.'



async function getDbConnection() {
    const db = await sqlite.open({
        filename : 'database2.db',
        driver: sqlite3.Database
    });

    return db;
}

app.get('/', (req, res) => {
    res.redirect("/home")
})

app.get('/home', (req, res) => {
    res.render("home");
})

app.get("/products",  (req, res) => {
    res.redirect("/products/all")
})

app.get("/products/all", async function (req, res) {
    let qry = 'SELECT * FROM products;';
    let db = await getDbConnection();
    try {
        let menu = await db.all(qry);
        res.render("all_products", {item : menu})
    } catch (error) {
        res.status(SERVER_ERROR).send(SERVER_ERROR_MSG);
    }
})

app.get("/products/:name", async function (req, res) {
    let qry = 'SELECT * FROM products WHERE category_id = ?;';
    let db = await getDbConnection();
    try {
        let menu = await db.all(qry, req.params.name);
        res.render('selected_products', { item : menu });
    } catch (err) {
        console.log("Error:", err);
        console.log(qry);
        res.status(500).send("Internal Server Error");
    }
})

app.get('/detail', function(req, res) {
    const itemString = req.query.item;
    const item = JSON.parse(decodeURIComponent(itemString));
    // Now you can use the 'item' object as needed
    res.render('detail', { item: item });
});

app.get("detail/:name", async function(req, res) {
    let qry = 'SELECT * FROM products WHERE name = ?;';
    let db = await getDbConnection();
    try {
        let menu = await db.all(qry, req.params.name);
        res.render('detail', { item : menu });
    } catch (error) {
        console.log("Error:", err);
        console.log(qry);
        res.status(500).send("Internal Server Error");
    }
})


app.get("/admin", (req, res) => {
    res.render("admin")
})

app.get("/contact", (req, res) => {
    res.render("contact")
})

app.get("/cart", (req, res) => {
    res.render("cart")
})


const PORT_DEF = process.env.PORT || 8080;
console.log("Listening on " + PORT_DEF);
app.listen(PORT_DEF)