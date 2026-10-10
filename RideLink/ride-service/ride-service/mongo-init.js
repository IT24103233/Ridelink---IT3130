db = db.getSiblingDB("ridelink_ride");
db.createCollection("rides");

db = db.getSiblingDB("ridelink_account");
db.createCollection("accounts");

db = db.getSiblingDB("ridelink_driver");
db.createCollection("drivers");

db = db.getSiblingDB("ridelink_fare");
db.createCollection("fare_estimates");
db.createCollection("payments");
