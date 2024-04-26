BEGIN TRANSACTION;
DROP TABLE IF EXISTS "users";
CREATE TABLE IF NOT EXISTS "users" (
	"uuid"	INTEGER NOT NULL,
	"username"	TEXT NOT NULL,
	"email"	TEXT NOT NULL UNIQUE,
	"password"	TEXT NOT NULL,
	PRIMARY KEY("uuid" AUTOINCREMENT)
);
DROP TABLE IF EXISTS "carts";
CREATE TABLE IF NOT EXISTS "carts" (
	"uuid"	INTEGER NOT NULL,
	"status"	TEXT NOT NULL,
	"owner_id"	INTEGER NOT NULL,
	FOREIGN KEY("owner_id") REFERENCES "users"("uuid"),
	PRIMARY KEY("uuid" AUTOINCREMENT)
);
DROP TABLE IF EXISTS "cartProducts";
CREATE TABLE IF NOT EXISTS "cartProducts" (
	"uuid"	INTEGER NOT NULL,
	"cart_id"	INTEGER NOT NULL,
	"product_id"	INTEGER NOT NULL,
	"qty"	INTEGER NOT NULL,
	FOREIGN KEY("product_id") REFERENCES "products"("uuid"),
	FOREIGN KEY("cart_id") REFERENCES "cart"("uuid"),
	PRIMARY KEY("uuid" AUTOINCREMENT)
);
DROP TABLE IF EXISTS "categories";
CREATE TABLE IF NOT EXISTS "categories" (
	"uuid"	INTEGER NOT NULL,
	"name"	TEXT NOT NULL,
	PRIMARY KEY("name")
);
DROP TABLE IF EXISTS "products";
CREATE TABLE IF NOT EXISTS "products" (
	"uuid"	INTEGER NOT NULL,
	"name"	TEXT NOT NULL UNIQUE,
	"desc"	TEXT NOT NULL,
	"img_url"	TEXT NOT NULL,
	"category_id"	TEXT NOT NULL,
	"price"	INTEGER,
	FOREIGN KEY("category_id") REFERENCES "categories"("name"),
	PRIMARY KEY("uuid" AUTOINCREMENT)
);
INSERT INTO "users" VALUES (1, 'jacob', 'jacob@url.com', 'password');
INSERT INTO "categories" VALUES (1,'dog');
INSERT INTO "categories" VALUES (2,'cat');
INSERT INTO "categories" VALUES (3,'reptile');
INSERT INTO "categories" VALUES (4,'fish');
INSERT INTO "categories" VALUES (5,'bird');
INSERT INTO "categories" VALUES (6,'smallMammal');
INSERT INTO "products" VALUES (1,'Squeaky Dog Toy','Squeaky dog toy that is indestructable!','/images/stock.jpeg','dog',1);
INSERT INTO "products" VALUES (2,'Cat Food','Highest quality food for your feline fmaily member','/images/stock.jpeg','cat',2);
INSERT INTO "products" VALUES (3,'Dog Food','Highest quality food for your furry companion!','/imgs/stock.jpeg','dog',3);
INSERT INTO "products" VALUES (4,'Dog Collar','For long walks or small adventures, this will help keep the peace.','/img/stock.jpeg','dog',4);
INSERT INTO "products" VALUES (5,'Dog Treats','Made from the purest ingredients, these treats will give your pup clean teeth!','/img/stock.jpeg','dog',5);
INSERT INTO "products" VALUES (6,'Reptile Filler Product','DESCRIPTION','IMG URL','reptile',6);
INSERT INTO "products" VALUES (7,'Fish Filler Product','DESCRIPTION','IMG URL','fish',7);
INSERT INTO "products" VALUES (8,'Bird Filler Product','DESCRIPTION','IMG URL','bird',8);
INSERT INTO "products" VALUES (9,'smallMammal Filler Product','DESCRIPTION','IMG URL','smallMammal',9);

COMMIT;
