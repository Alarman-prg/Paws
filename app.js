'use strict'
const express = require("express")
const app = express()
const axios = require('axios');

const staticOptions = {
    dotfiles: "deny",
    etag: "",
    extensions: "",
    fallthrough: "",
    immutable: "",
    index: "index.html",
    lastModified: "",
    maxAge: "",
    redirect: ""
}

app.use(express.static('public', staticOptions))

app.set("views", "./views")
app.set("view engine", "ejs")
const ejs = require("ejs")


const sqlite3 = require("sqlite3")
const sqlite = require("sqlite")

const multer = require("multer")
app.use(multer().none())
app.use(express.urlencoded({ extended: true }));
app.use(express.json())

let INVALID_PARAM_ERROR = 400
let INVALID_PARAM_ERROR_MSG = "No results for your parameters."
let SERVER_ERROR = 500
let SERVER_ERROR_MSG = "Something went wrong on the server."



async function getDbConnection() {
    const db = await sqlite.open({
        filename: 'db.db',
        driver: sqlite3.Database
    });

    return db;
}

// default view
app.get("/", (req, res) => {
    res.redirect("/login")
})

app.get("/home", (req, res) => {
    res.render("home");
})

app.get("/login", (req, res) => {
    res.render("login")
})

app.post("/login", async function (req, res) {
    const username = req.body.username;
    const password = req.body.password;

    try {
        let db = await getDbConnection();
        db.get("SELECT * FROM users WHERE username = ? AND password = ?;", [username, password]);
        let active = 1;
        db.run("UPDATE users SET active = ? WHERE username = ?;", [active, username])

    } catch (err) {
        // not implemented
        if (!row) {
            return res.status(401).send(SERVER_ERROR_MSG);
        }
        res.status(404).send(SERVER_ERROR_MSG);
        res.redirect("/login")
    }
    res.redirect("/home");
})

app.get("/logout", (req, res) => {
    res.render("logout")
})

app.post("/logout", async function (req, res) {
    try {
        let db = await getDbConnection();
        db.run("UPDATE users set active = 0 WHERE active = 1;")
    } catch (error) {
        return res.status(401).send(SERVER_ERROR_MSG);
    }
    res.redirect("/login")
})

app.get("/products", (req, res) => {
    res.redirect("/products/all")
})

app.get("/products/all", async function (req, res) {
    let qry = 'SELECT * FROM products;';
    let db = await getDbConnection();
    try {
        let menu = await db.all(qry);
        res.render("all_products", { item: menu })
    } catch (error) {
        res.status(SERVER_ERROR).send(SERVER_ERROR_MSG);
    }
})

app.get("/products/:name", async function (req, res) {
    let qry = 'SELECT * FROM products WHERE category_id = ?;';
    let db = await getDbConnection();
    try {
        let menu = await db.all(qry, req.params.name);
        res.render('selected_products', { item: menu });
    } catch (err) {
        res.status(SERVER_ERROR).send(SERVER_ERROR_MSG);
    }
})

app.get("/detail", function (req, res) {
    const itemString = req.query.item;
    const item = JSON.parse(decodeURIComponent(itemString));
    res.render('detail', { item: item });
});

app.get("detail/:name", async function (req, res) {
    let qry = 'SELECT * FROM products WHERE name = ?;';
    let db = await getDbConnection();
    try {
        let menu = await db.all(qry, req.params.name);
        res.render('detail', { item: menu });
    } catch (error) {
        console.log("Error:", err);
        console.log(qry);
        res.status(500).send(SERVER_ERROR_MSG);
    }
})

app.post("/add",  async function (req, res) {
    try {
        const { productId, quantity } = req.body;
        const db = await getDbConnection();

        await db.run(
            "INSERT INTO cartProducts (cart_id, product_id, qty) VALUES ((SELECT uuid FROM carts WHERE owner_id = (SELECT uuid FROM users WHERE active = 1)), ?, ?)",
            [productId, quantity]
        );

        res.redirect("/cart");
    } catch (error) {
        res.status(500).send(SERVER_ERROR_MSG);
    }
});


app.get("/admin", (req, res) => {
    res.render("admin")
})

app.get("/contact", (req, res) => {
    res.render("contact")
})

app.get("/cart", async function (req, res) {
    try {
        const db = await getDbConnection();


        // 10 hrs to figure this out
        // https://www.sqlite.org/docs.html praise god
        // assume: p is products table, cp is cartProducts table in db
        // From the active user a uuid is matched with the cart owner_id which is matched with the cartProducts cart_id then returns the name, price, and qty of each product in the active users cart. 

        const cartItems = await db.all(
            "SELECT p.name, p.price, cp.qty FROM cartProducts AS cp INNER JOIN products AS p ON cp.product_id = p.uuid WHERE cp.cart_id = (SELECT uuid FROM carts WHERE owner_id = (SELECT uuid FROM users WHERE active = 1))"
        );

        let subtotal = 0;
        cartItems.forEach(item => {
            subtotal += item.price * item.qty;
        });

        // taxes, just doing 10% 
        const taxes = subtotal * 0.1;
        const grandTotal = subtotal + taxes;

        res.render("cart", { cartItems, subtotal, taxes, grandTotal });
    } catch (error) {
        res.status(500).send(SERVER_ERROR_MSG);
    }
});

app.post("/clear-cart", async function (req, res) {
    
})

app.get('/chuck', async (req, res) => {
    try {
      const query = req.query.q || "fight"; // Use query parameter 'q' for the search query
      const options = {
        method: 'GET',
        url: 'https://matchilling-chuck-norris-jokes-v1.p.rapidapi.com/jokes/random',
        params: {
          query: query
        },
        headers: {
          accept: 'application/json',
          'X-RapidAPI-Key': 'f19a715697msh8dfdab4b71c8f97p19d88fjsn41814e5a31c7', // Replace with your RapidAPI key
          'X-RapidAPI-Host': 'matchilling-chuck-norris-jokes-v1.p.rapidapi.com'
        }
      };
      
      const response = await axios.request(options);
      console.log(response)
    res.render("chuck", {data: response.data});
    } catch (error) {
      res.status(SERVER_ERROR).send(SERVER_ERROR_MSG);
    }
  });


  app.get("/social", (req, res) => {
    res.render("social");
  })

const PORT_DEF = process.env.PORT || 8080;
console.log("Listening on " + PORT_DEF);
app.listen(PORT_DEF)