BEGIN TRANSACTION;
DROP TABLE IF EXISTS "users";
CREATE TABLE IF NOT EXISTS "users" (
	"uuid"	INTEGER NOT NULL,
	"created"	TEXT NOT NULL,
	"name"	TEXT NOT NULL,
	"email"	TEXT NOT NULL UNIQUE,
	"password"	TEXT NOT NULL,
	"user_is_admin"	INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY("uuid" AUTOINCREMENT)
);
DROP TABLE IF EXISTS "carts";
CREATE TABLE IF NOT EXISTS "carts" (
	"uuid"	INTEGER NOT NULL,
	"status"	TEXT NOT NULL,
	"created"	TEXT NOT NULL,
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
	"is_featured"	INTEGER DEFAULT 0,
	"price"	INTEGER,
	FOREIGN KEY("category_id") REFERENCES "categories"("name"),
	PRIMARY KEY("uuid" AUTOINCREMENT)
);
INSERT INTO "categories" VALUES (1,'dog');
INSERT INTO "categories" VALUES (2,'cat');
INSERT INTO "categories" VALUES (3,'reptile');
INSERT INTO "categories" VALUES (4,'fish');
INSERT INTO "categories" VALUES (5,'bird');
INSERT INTO "categories" VALUES (6,'smallMammal');
INSERT INTO "products" VALUES (1,'Squeaky Dog Toy','Squeaky dog toy that is indestructable!','/images/stock.jpeg','dog',0,4);
INSERT INTO "products" VALUES (2,'Cat Food','Highest quality food for your feline fmaily member','/images/catfood.png','cat',0,2);
INSERT INTO "products" VALUES (3,'Dog Food','Highest quality food for your furry companion!','/imgs/dogfood.png','dog',0,918324);
INSERT INTO "products" VALUES (4,'Dog Collar','For long walks or small adventures, this will help keep the peace.','/img/dogcollar.png','dog',0,9823);
INSERT INTO "products" VALUES (5,'Dog Treats','Made from the purest ingredients, these treats will give your pup clean teeth!','/img/dogtreats.png','dog',0,223432);
INSERT INTO "products" VALUES (6,'product name 2','desc name 2','img url 2','cat',0,98234);
INSERT INTO "products" VALUES (7,'product name 3','desc name 3','img url 3','cat',0,126);
COMMIT;
