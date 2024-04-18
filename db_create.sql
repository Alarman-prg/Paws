BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "users" (
	"uuid"	INTEGER NOT NULL,
	"created"	TEXT NOT NULL,
	"name"	TEXT NOT NULL,
	"email"	TEXT NOT NULL UNIQUE,
	"password"	TEXT NOT NULL,
	"user_is_admin"	INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY("uuid" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "carts" (
	"uuid"	INTEGER NOT NULL,
	"status"	TEXT NOT NULL,
	"created"	TEXT NOT NULL,
	"owner_id"	INTEGER NOT NULL,
	FOREIGN KEY("owner_id") REFERENCES "users"("uuid"),
	PRIMARY KEY("uuid" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "cartProducts" (
	"uuid"	INTEGER NOT NULL,
	"cart_id"	INTEGER NOT NULL,
	"product_id"	INTEGER NOT NULL,
	"qty"	INTEGER NOT NULL,
	FOREIGN KEY("product_id") REFERENCES "products"("uuid"),
	FOREIGN KEY("cart_id") REFERENCES "cart"("uuid"),
	PRIMARY KEY("uuid" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "categories" (
	"uuid"	INTEGER NOT NULL,
	"name"	TEXT NOT NULL,
	PRIMARY KEY("name")
);
CREATE TABLE IF NOT EXISTS "products" (
	"uuid"	INTEGER NOT NULL,
	"name"	TEXT NOT NULL UNIQUE,
	"desc"	TEXT NOT NULL,
	"img_url"	TEXT NOT NULL,
	"category_id"	TEXT NOT NULL,
	"is_featured"	INTEGER DEFAULT 0,
	"price"	INTEGER NOT NULL,
	FOREIGN KEY("category_id") REFERENCES "categories"("name"),
	PRIMARY KEY("uuid" AUTOINCREMENT)
);
COMMIT;
