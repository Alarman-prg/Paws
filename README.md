# Paws!

## To run this project
* Get a local copy onto your machine from github.
* Create a database using db_create.sql (this is an empty database)
    * You will want to name it database2 if you don't want to change the name in app.js, line 41.
    * give the table CATEGORIES and created the following records (uuid is autoincremented); name = dog, name = cat, name = reptile, name = fish, name = bird, name = smallMammal

    * give the table PRODUCTS some records. For the img_url the only image that will work is /images/stock.jpeg. The category id will be only one of the following {cat, dog, reptile, fish, bird, smallMammal}  
* run node start
* connect at localhost:8080 or localhost:8080/ or localhost:8080/home
