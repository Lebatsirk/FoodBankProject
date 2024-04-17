--Building and populating DB from scratch

-- Create FoodBank table
CREATE TABLE IF NOT EXISTS FoodBank (
    fbID int(11) NOT NULL AUTO_INCREMENT,
    fbName varchar(80) NOT NULL,
    fbEmail varchar(40),
    fbPhone varchar(12),
    fbWebsite varchar(120),
	PRIMARY KEY (fbID)
);

-- Create ProductCategory table
CREATE TABLE IF NOT EXISTS ProductCategory (
    catID int(11) NOT NULL AUTO_INCREMENT,
    catName varchar(80) NOT NULL,
	PRIMARY KEY (catID)
);

-- Create PriorityList table
CREATE TABLE IF NOT EXISTS PriorityList (
    fbID int(11) NOT NULL, 
    catID int(11) NOT NULL,
	priorityValue tinyint NOT NULL CHECK (priorityValue < 3 AND priorityValue >= 0),
    lastUpdated date DEFAULT CURRENT_DATE,
    PRIMARY KEY (fbID, catID),
    FOREIGN KEY (fbID) REFERENCES FoodBank(fbID),
    FOREIGN KEY (catID) REFERENCES ProductCategory(catID)
);

-- Create FoodbankCategory table
CREATE TABLE IF NOT EXISTS FoodbankCategory (
    fbID int NOT NULL, 
    catID int NOT NULL,
	minThreshold int NOT NULL DEFAULT 10 CHECK (minThreshold < maxThreshold AND minThreshold >=1),
    maxThreshold int NOT NULL DEFAULT 20 CHECK (maxThreshold > minThreshold AND maxThreshold >=1),
    quantity int NOT NULL CHECK (quantity >= 0),
    PRIMARY KEY (fbID, catID),
	CONSTRAINT FK_fbID FOREIGN KEY (fbID) REFERENCES FoodBank(fbID),
	CONSTRAINT FK_catID FOREIGN KEY (catID) REFERENCES ProductCategory(catID)
);

-- Create FoodParcel table 
CREATE TABLE IF NOT EXISTS FoodParcel (
    parcelID int NOT NULL CHECK (parcelID > 0), 
    parcelType varchar(10) NOT NULL,
    PRIMARY KEY (parcelID)
);

-- Create ParcelCategory table
CREATE TABLE IF NOT EXISTS ParcelCategory (
    catID int NOT NULL,
	parcelID int NOT NULL, 
    amount int NOT NULL CHECK (amount >= 0),
    PRIMARY KEY (catID, parcelID),
    FOREIGN KEY (catID) REFERENCES ProductCategory(catID),
    FOREIGN KEY (parcelID) REFERENCES FoodParcel(parcelID)
);

-- Create LoginInfo table
CREATE TABLE IF NOT EXISTS LoginInfo (
	userID int AUTO_INCREMENT NOT NULL,
	userName varchar(150) NOT NULL,
	userPwd varchar(100) NOT NULL,
	userAccessType smallint NOT NULL DEFAULT 0,
	fbID int NOT NULL,
    PRIMARY KEY (userID),
    FOREIGN KEY (fbID) REFERENCES FoodBank(fbID)
);

-- SQL for tr_UpdatePriority BEFORE UPDATE on FoodbankCategory table
CREATE TRIGGER tr_UpdatePriority AFTER UPDATE ON FoodbankCategory FOR EACH ROW 
	BEGIN 
		DECLARE newPriority INT; 
		
		SET newPriority = (SELECT CASE 
			WHEN (new.quantity > maxThreshold) THEN 0 
			WHEN (new.quantity < minThreshold) THEN 2 
			ELSE 1 
		END 
		FROM FoodbankCategory 
		WHERE fbID = old.fbID AND catID = old.catID); 
		
		IF EXISTS ( 
			SELECT priorityValue FROM PriorityList 
			WHERE fbID = old.fbID AND catID = old.catID) THEN 
		
			UPDATE PriorityList SET 
				priorityValue = newPriority, 
				lastUpdated = CURRENT_DATE 
			WHERE (fbID = old.fbID) AND (catID = old.catID); 
		ELSE 
			INSERT INTO PriorityList (fbID, catID, priorityValue) 
			VALUES (old.fbID, old.catID, newPriority); 
		END IF; 
	END
	
-- SQL for tr_UpdatePriorityOnInsert
CREATE TRIGGER tr_UpdatePriorityOnInsert AFTER INSERT ON FoodbankCategory FOR EACH ROW 
BEGIN 
	DECLARE newPriority INT; 
	
	SET newPriority = (SELECT CASE 
		WHEN (new.quantity > maxThreshold) THEN 0 
		WHEN (new.quantity < minThreshold) THEN 2 
		ELSE 1 
	END 
	FROM FoodbankCategory 
	WHERE fbID = new.fbID AND catID = new.catID); 
	
	INSERT INTO PriorityList (fbID, catID, priorityValue) 
	VALUES (new.fbID, new.catID, newPriority); 
END

-- Add FoodBanks
INSERT INTO FoodBank (fbName, fbEmail, fbPhone, fbWebsite)
VALUES ("Food Bank 1", "foodbank1@email.tst", "01234 567890", "http://www.foodbank1.test");
	
INSERT INTO FoodBank (fbName, fbEmail, fbPhone, fbWebsite)
VALUES ("Food Bank 2", "foodbank2@test.tst", "98765 432100", "http://www.foodbank2.test");

INSERT INTO FoodBank (fbName, fbEmail, fbPhone, fbWebsite)
VALUES ("Food Bank 3", "foodbank3@another.tst", "01234 776655", "http://www.foodbank3.test");

-- Add LoginInfo
-- Volunteer for food bank 1
INSERT INTO LoginInfo (userName, userPwd, userAccessType, fbID) 
VALUES ("tm470_vol_1", md5("tm470vol"), 1, 1);

-- Volunteer for food bank 2
INSERT INTO LoginInfo (userName, userPwd, userAccessType, fbID) 
VALUES ("tm470_vol_2", md5("tm470vol"), 1, 2);

-- Manager of food bank 1
INSERT INTO LoginInfo (userName, userPwd, userAccessType, fbID) 
VALUES ("tm470_manager_1", md5("tm470manager"), 2, 1);

-- Manager of food bank 2
INSERT INTO LoginInfo (userName, userPwd, userAccessType, fbID) 
VALUES ("tm470_manager_2", md5("tm470manager"), 2, 2);

-- Public user for testing
INSERT INTO LoginInfo (userName, userPwd, userAccessType, fbID) 
VALUES ("tm470_public", md5("public"), 0, 2);

-- PRODUCT CATEGORIES
INSERT INTO ProductCategory (catName)
VALUES ("Cereal");

INSERT INTO ProductCategory (catName)
VALUES ("Juice");

INSERT INTO ProductCategory (catName)
VALUES ("Milk");

INSERT INTO ProductCategory (catName)
VALUES ("Jam/Honey");

INSERT INTO ProductCategory (catName)
VALUES ("Tea/Coffee");

INSERT INTO ProductCategory (catName)
VALUES ("Soup");

INSERT INTO ProductCategory (catName)
VALUES ("Tinned meal");

INSERT INTO ProductCategory (catName)
VALUES ("Baked beans");

INSERT INTO ProductCategory (catName)
VALUES ("Pasta 500g");

INSERT INTO ProductCategory (catName)
VALUES ("Pasta sauce");

INSERT INTO ProductCategory (catName)
VALUES ("Rice 500g");

INSERT INTO ProductCategory (catName)
VALUES ("Potatoes");

INSERT INTO ProductCategory (catName)
VALUES ("Meatballs/hotdogs");

INSERT INTO ProductCategory (catName)
VALUES ("Tinned chilli/tinned curry");	

INSERT INTO ProductCategory (catName)
VALUES ("Pie/steak/stew");	

INSERT INTO ProductCategory (catName)
VALUES ("Tinned vegetables");	

INSERT INTO ProductCategory (catName)
VALUES ("Tinned fruit");	

INSERT INTO ProductCategory (catName)
VALUES ("Hot dessert");	

INSERT INTO ProductCategory (catName)
VALUES ("Biscuits");	

INSERT INTO ProductCategory (catName)
VALUES ("Tuna");	

INSERT INTO ProductCategory (catName)
VALUES ("Chocolate");


-- FOOD PARCELS	
INSERT INTO FoodParcel (parcelID, parcelType)
VALUES (1, "Small");

INSERT INTO FoodParcel (parcelID, parcelType)
VALUES (2, "Medium");

INSERT INTO FoodParcel (parcelID, parcelType)
VALUES (3, "Large");


-- PARCEL CATEGORIES
-- Small parcels
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (1, 1, 1);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (2, 1, 0);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (3, 1, 1);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (4, 1, 1);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (5, 1, 1);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (6, 1, 2);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (7, 1, 1);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (8, 1, 3);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (9, 1, 1);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (10, 1, 1);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (11, 1, 1);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (12, 1, 1);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (13, 1, 1);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (14, 1, 1);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (15, 1, 1);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (16, 1, 4);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (17, 1, 2);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (18, 1, 1);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (19, 1, 1);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (20, 1, 2);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (21, 1, 1);

-- Medium parcels
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (1, 2, 1);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (2, 2, 1);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (3, 2, 2);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (4, 2, 1);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (5, 2, 1);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (6, 2, 4);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (7, 2, 2);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (8, 2, 6);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (9, 2, 2);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (10, 2, 1);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (11, 2, 2);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (12, 2, 2);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (13, 2, 2);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (14, 2, 2);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (15, 2, 2);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (16, 2, 8);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (17, 2, 4);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (18, 2, 2);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (19, 2, 2);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (20, 2, 4);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (21, 2, 1);

-- Large parcels
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (1, 3, 2);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (2, 3, 1);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (3, 3, 3);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (4, 3, 2);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (5, 3, 2);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (6, 3, 6);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (7, 3, 3);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (8, 3, 8);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (9, 3, 2);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (10, 3, 2);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (11, 3, 2);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (12, 3, 3);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (13, 3, 4);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (14, 3, 2);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (15, 3, 2);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (16, 3, 12);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (17, 3, 6);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (18, 3, 3);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (19, 3, 2);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (20, 3, 4);
INSERT INTO ParcelCategory (catID, parcelID, amount)
VALUES (21, 3, 1);


-- FOOD BANK CATEGORY RECORDS
-- ...for food bank 2
INSERT INTO FoodbankCategory (fbID, catID, minThreshold, maxThreshold, quantity) 
VALUES (2, 16, 5, 10, 0);

INSERT INTO FoodbankCategory (fbID, catID, minThreshold, maxThreshold, quantity) 
VALUES (2, 9, 5, 10, 0);

INSERT INTO FoodbankCategory (fbID, catID, minThreshold, maxThreshold, quantity) 
VALUES (2, 8, 5, 11, 0);

INSERT INTO FoodbankCategory (fbID, catID, minThreshold, maxThreshold, quantity) 
VALUES (2, 14, 12, 19, 0);

INSERT INTO FoodbankCategory (fbID, catID, minThreshold, maxThreshold, quantity) 
VALUES (2, 6, 12, 30, 0);

INSERT INTO FoodbankCategory (fbID, catID, minThreshold, maxThreshold, quantity) 
VALUES (2, 1, 20, 30, 0);

INSERT INTO FoodbankCategory (fbID, catID, minThreshold, maxThreshold, quantity) 
VALUES (2, 2, 4, 20, 0);

INSERT INTO FoodbankCategory (fbID, catID, minThreshold, maxThreshold, quantity) 
VALUES (2, 3, 6, 10, 0);

INSERT INTO FoodbankCategory (fbID, catID, minThreshold, maxThreshold, quantity) 
VALUES (2, 4, 19, 40, 0);

INSERT INTO FoodbankCategory (fbID, catID, minThreshold, maxThreshold, quantity)
VALUES (2, 7, 9, 14, 6);

--missing values
INSERT INTO FoodbankCategory (fbID, catID, minThreshold, maxThreshold, quantity) 
VALUES (2, 10, 5, 10, 6);

INSERT INTO FoodbankCategory (fbID, catID, minThreshold, maxThreshold, quantity) 
VALUES (2, 11, 5, 10, 19);

INSERT INTO FoodbankCategory (fbID, catID, minThreshold, maxThreshold, quantity) 
VALUES (2, 12, 5, 10, 0);

INSERT INTO FoodbankCategory (fbID, catID, minThreshold, maxThreshold, quantity) 
VALUES (2, 13, 5, 10, 4);

INSERT INTO FoodbankCategory (fbID, catID, minThreshold, maxThreshold, quantity) 
VALUES (2, 20, 5, 10, 12);

--

-- ...and for food bank 1
INSERT INTO FoodbankCategory (fbID, catID, minThreshold, maxThreshold, quantity) 
VALUES (1, 21, 3, 10, 0);

INSERT INTO FoodbankCategory (fbID, catID, minThreshold, maxThreshold, quantity) 
VALUES (1, 4, 7, 10, 0);

INSERT INTO FoodbankCategory (fbID, catID, minThreshold, maxThreshold, quantity) 
VALUES (1, 7, 5, 19, 0);

INSERT INTO FoodbankCategory (fbID, catID, minThreshold, maxThreshold, quantity) 
VALUES (1, 14, 12, 20, 0);

INSERT INTO FoodbankCategory (fbID, catID, minThreshold, maxThreshold, quantity) 
VALUES (1, 6, 12, 40, 0);


-- Test data
INSERT INTO PriorityList (fbID, catID, priorityValue, lastUpdated) 
VALUES (2, 21, 32, "2023-08-23");

INSERT INTO PriorityList (fbID, catID, priorityValue, lastUpdated) 
VALUES (1, 2, 1, "2023-08-06");

INSERT INTO PriorityList (fbID, catID, priorityValue, lastUpdated) 
VALUES (1, 4, 2, "2023-07-11");

INSERT INTO PriorityList (fbID, catID, priorityValue, lastUpdated) 
VALUES (1, 15, 2, "2022-07-11");

INSERT INTO PriorityList (fbID, catID, priorityValue, lastUpdated) 
VALUES (2, 15, 2, "2022-04-11");

INSERT INTO PriorityList (fbID, catID, priorityValue, lastUpdated) 
VALUES (1, 21, 2, "2022-06-22");

INSERT INTO PriorityList (fbID, catID, priorityValue, lastUpdated) 
VALUES (2, 17, 0, "2022-03-30");

INSERT INTO PriorityList (fbID, catID, priorityValue, lastUpdated) 
VALUES (1, 6, 0, "2020-02-20");

INSERT INTO PriorityList (fbID, catID, priorityValue, lastUpdated) 
VALUES (2, 19, 0, "2020-02-20");

INSERT INTO PriorityList (fbID, catID, priorityValue, lastUpdated) 
VALUES (2, 3, 1, "2022-11-04");



-- View for product category information for food bank 2
CREATE VIEW vw_FoodBank2ProdCatInfo AS 
SELECT 	PCat.catName AS "Product_Category", 
		FBCat.minThreshold AS "Lower_bound", 
		FBCat.maxThreshold AS "Upper_bound", 
		FBCat.quantity AS Quantity, 
	CASE
		WHEN priorityValue = 2 THEN "High"
		WHEN priorityValue = 0 THEN "Low"
		ELSE "Normal"
	END AS Priority  
FROM ProductCategory PCat
RIGHT JOIN PriorityList PL ON PL.catID = PCat.catID
RIGHT JOIN FoodbankCategory AS FBCat ON FBCat.catID = PCat.catID
WHERE PL.fbID = 2
GROUP BY PCat.catID
ORDER BY PL.priorityValue DESC;


-- Create VIEW for product category info for ALL food banks so that it can be queried to filter
CREATE VIEW vw_FoodBankProdCatInfo AS 
SELECT 	PCat.catName AS "Product_Category", 
		FBCat.minThreshold AS "Lower_bound", 
		FBCat.maxThreshold AS "Upper_bound", 
		FBCat.quantity AS Quantity, 
	CASE
		WHEN priorityValue = 2 THEN "High"
		WHEN priorityValue = 0 THEN "Low"
		ELSE "Normal"
	END AS Priority  
FROM ProductCategory PCat
RIGHT JOIN PriorityList PL ON PL.catID = PCat.catID
RIGHT JOIN FoodbankCategory AS FBCat ON FBCat.catID = PCat.catID
GROUP BY PCat.catID
ORDER BY PL.priorityValue DESC;





-- STORED PROCEDURES
CREATE PROCEDURE IF NOT EXISTS GetAllItems ()
    SELECT tempID, tempName, quantity FROM TEMP
	ORDER BY tempName ASC;

CREATE PROCEDURE IF NOT EXISTS GetAllFoodBanks ()
    SELECT fbID, fbName FROM FoodBank
	ORDER BY fbName ASC;
	
CREATE PROCEDURE IF NOT EXISTS GetAllProductCategories ()
    SELECT catID, catName FROM ProductCategory
	ORDER BY catName ASC;
	
CREATE PROCEDURE IF NOT EXISTS GetSpecificItem (itemID INT)
    SELECT tempName, quantity FROM TEMP WHERE tempID = itemID;

CREATE PROCEDURE GetSpecificFoodBank (IN foodbankID INT UNSIGNED) 
	SELECT fbID, fbName, fbEmail, fbPhone, fbWebsite 
	FROM FoodBank 
	WHERE fbID = foodbankID
	
CREATE PROCEDURE IF NOT EXISTS sp_GetProdCatDetails (IN prodcatID INT UNSIGNED, IN foodbankID INT UNSIGNED) 
	SELECT catName, minThreshold, maxThreshold, quantity FROM ProductCategory AS PC
	LEFT JOIN FoodbankCategory AS FBC ON FBC.catID = PC.catID
	WHERE PC.catID = prodcatID AND FBC.fbID = foodbankID;


CREATE PROCEDURE IF NOT EXISTS sp_UpdateProdCat (IN foodbankID INT UNSIGNED, IN prodcatID INT UNSIGNED, IN newQuantity INT UNSIGNED) 
	UPDATE FoodbankCategory SET quantity = newQuantity 
    WHERE fbID = foodbankID AND catID = prodcatID;

CREATE PROCEDURE IF NOT EXISTS sp_InsertProdCat (IN foodbankID INT UNSIGNED, IN prodcatID INT UNSIGNED, IN newQuantity INT UNSIGNED) 
	INSERT INTO FoodbankCategory (fbID, catID, quantity)
    VALUES (foodbankID, prodcatID, newQuantity);

-- THIS ONE WORKED	
DELIMITER //

CREATE PROCEDURE IF NOT EXISTS sp_UpdateInsertProdCatQty (IN foodbankID INT, IN prodcatID INT, IN newQuantity INT) 
    IF EXISTS (SELECT fbID FROM FoodbankCategory WHERE fbID = foodbankID AND catID = prodcatID) THEN
    	
    		UPDATE FoodbankCategory 
            SET quantity = newQuantity 
    		WHERE fbID = foodbankID AND catID = prodcatID;
    	
    ELSE
    	
    		INSERT INTO FoodbankCategory (fbID, catID, quantity)
        	VALUES (foodbankID, prodcatID, newQuantity);
        
	END IF //

DELIMITER ;
-- .

-- LOGIN STORED PROCEDURE
CREATE PROCEDURE `sp_Login`(IN `foodbankID` INT, IN `username` VARCHAR(150) CHARSET latin1, IN `pwd` VARCHAR(100) CHARSET latin1, OUT `accesstype` INT) NOT DETERMINISTIC READS SQL DATA SQL SECURITY DEFINER SELECT userID, userAccessType FROM LoginInfo WHERE userName = username AND userPwd = MD5(pwd) AND fbID = foodbankID

CREATE PROCEDURE sp_Login (IN foodbankID INT, IN username VARCHAR(150), IN pwd VARCHAR(100), OUT userID INT, OUT accesstype INT) READS SQL DATA 
SELECT userID, userAccessType FROM LoginInfo WHERE userName = username AND userPwd = MD5(pwd) AND fbID = foodbankID




DELIMITER //

CREATE PROCEDURE IF NOT EXISTS sp_UpdateInsertProdCatThresholds (IN foodbankID INT, IN prodcatID INT, IN newMinThreshold INT, IN newMaxThreshold INT) 
    IF EXISTS (SELECT fbID FROM FoodbankCategory WHERE fbID = foodbankID AND catID = prodcatID) THEN
    	
    		UPDATE FoodbankCategory 
            SET minThreshold = newMinThreshold,
				maxThreshold = newMaxThreshold
    		WHERE fbID = foodbankID AND catID = prodcatID;
    	
    ELSE
    	
    		INSERT INTO FoodbankCategory (fbID, catID, minThreshold, maxThreshold)
        	VALUES (foodbankID, prodcatID, newMinThreshold, newMaxThreshold);
        
	END IF //

DELIMITER ;

	
-- CREATE PROCEDURE IF NOT EXISTS GetSpecificProdCat (catID INT)
    -- SELECT tempName, quantity 
	-- FROM TEMP 
	-- WHERE tempID = itemID;
	
-- DELIMITER //

-- CREATE PROCEDURE sp_UpdateProdCat (IN foodbankID INT UNSIGNED, IN prodcatID INT UNSIGNED, IN newQuantity INT UNSIGNED) 
	-- IF EXISTS (SELECT fbID FROM FoodbankCategory WHERE fbID = foodbankID AND catID = prodcatID)
    	-- UPDATE FoodbankCategory SET (quantity = newQuantity) 
    	-- WHERE fbID = foodbankID AND catID = prodcatID;
    -- ELSE
    	-- INSERT INTO FoodbankCategory (fbID, catID, quantity)
        -- VALUES (foodbankID, prodcatID, newQuantity);

-- DELIMITER ;
	
CREATE PROCEDURE sp_GetPriorityList (IN foodbankID INT UNSIGNED) 
    SELECT catName, lastUpdated, (SELECT MAX(lastUpdated) FROM PriorityList
    WHERE fbID = foodbankID AND priorityValue = 2) AS mostRecent
    FROM PriorityList AS PL
    LEFT JOIN ProductCategory AS PC 
    ON PC.catID = PL.catID 
    WHERE fbID = foodbankID AND priorityValue = 2
    ORDER BY PC.catName ASC;

-- When there are no high priority items, get medium ones (exclude LOW)
CREATE PROCEDURE sp_GetMediumPriorityItems (IN foodbankID INT UNSIGNED) 
    SELECT catName, lastUpdated, (SELECT MAX(lastUpdated) FROM PriorityList
    WHERE fbID = foodbankID AND priorityValue = 1) AS mostRecent
    FROM PriorityList AS PL
    LEFT JOIN ProductCategory AS PC 
    ON PC.catID = PL.catID 
    WHERE fbID = foodbankID AND priorityValue = 1
    ORDER BY PC.catName ASC;

-- Get product categories for food parcel of specific size for specific foodbank 
CREATE PROCEDURE IF NOT EXISTS sp_GetProdCatsForParcelSize (IN parcel_id INT, IN foodbank_id INT)
	SELECT PC.catID, catName, quantity, amount, (SELECT (quantity < amount)) AS notEnough FROM ParcelCategory AS PC
	LEFT JOIN FoodbankCategory AS FBC ON FBC.catID = PC.catID
	LEFT JOIN ProductCategory AS PRODCAT ON PRODCAT.catID = PC.catID
	WHERE FBC.fbID = foodbank_id AND PC.parcelID = parcel_id
	ORDER BY catName ASC;

-- TRANSACTION FOR FR12
-- Code tests
START TRANSACTION
SET AUTOCOMMIT = 0;
BEGIN
	
COMMIT;


-- This works to do the update as required but want to put it inside a stored procedure that can be called within a transaction
UPDATE FoodbankCategory AS FBC 
INNER JOIN ParcelCategory AS PC ON PC.catID = FBC.catID
SET quantity = quantity - amount
WHERE FBC.fbID = 2 AND PC.parcelID = 1;


-- Work in progress
BEGIN TRANSACTION;
    -- Forces explit commit/rollback
	SET AUTOCOMMIT = 0;
    
    -- Handle exceptions in case of error
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN TRANSACTION -- Start the transaction
        	ROLLBACK; -- If there is an exception, rollback
            RESIGNAL; -- Reset the exception handler
        END; -- End the exception handler
        
        -- Attempt the update
    	UPDATE FoodbankCategory AS FBC 
		INNER JOIN ParcelCategory AS PC ON PC.catID = FBC.catID
		SET quantity = quantity - amount
		WHERE FBC.fbID = foodbankID AND PC.parcelID = parcelID;
    	
        -- Check that the new quantity won't be less than zero
        IF (
            SELECT ((quantity - amount) < 0) FROM FoodbankCategory AS FBC 
			INNER JOIN ParcelCategory AS PC ON PC.catID = FBC.catID
			WHERE FBC.fbID = foodbankID AND PC.parcelID = parcelID
            ) THEN
        	
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient quantity available for selected food parcel size';
        END IF;
COMMIT;
 

-- This seems to work
DELIMITER //
CREATE PROCEDURE sp_UpdateAllProdCatQuantities(
    IN foodbankID INT,
    IN parcelID INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
    SET AUTOCOMMIT = 0;

    UPDATE FoodbankCategory AS FBC 
    INNER JOIN ParcelCategory AS PC ON PC.catID = FBC.catID
    SET FBC.quantity = FBC.quantity - PC.amount
    WHERE FBC.fbID = foodbankID AND PC.parcelID = parcelID;

     -- Check that the new quantity won't be less than zero
        IF (
            SELECT ((quantity - amount) < 0) FROM FoodbankCategory AS FBC 
			INNER JOIN ParcelCategory AS PC ON PC.catID = FBC.catID
			WHERE FBC.fbID = foodbankID AND PC.parcelID = parcelID
            ) THEN
        	
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient quantity available for selected food parcel size';
        END IF;
        
    COMMIT;
    SET AUTOCOMMIT = 1;
END;
//
DELIMITER ;



-- going to need to loop through every prodcat and perform update of quantity but have the whole thing enclosed within a transaction so that it can be rolled back if there are any problems


-- TO DO once sql is working for this, include client-side validation on FR11/FR12 page





















-- Full Trigger SQL generated by PHPMyAdmin
CREATE TRIGGER `tr_UpdatePriority` AFTER UPDATE ON `FoodbankCategory` FOR EACH ROW BEGIN DECLARE newPriority INT; SET newPriority = (SELECT CASE WHEN (new.quantity > maxThreshold) THEN 0 WHEN (new.quantity < minThreshold) THEN 2 ELSE 1 END FROM FoodbankCategory WHERE fbID = old.fbID AND catID = old.catID); IF EXISTS ( SELECT priorityValue FROM PriorityList WHERE fbID = old.fbID AND catID = old.catID) THEN UPDATE PriorityList SET priorityValue = newPriority, lastUpdated = CURRENT_DATE WHERE (fbID = old.fbID) AND (catID = old.catID); ELSE INSERT INTO PriorityList (fbID, catID, priorityValue) VALUES (old.fbID, old.catID, newPriority); END IF; END

-- BEGIN
	-- DECLARE newPriority INT;

	-- SET newPriority = (SELECT CASE 
		-- WHEN (new.quantity > maxThreshold) THEN 0
		-- WHEN (new.quantity < minThreshold) THEN 2
		-- ELSE 1
	-- END 
	-- FROM FoodbankCategory
	-- WHERE fbID = old.fbID AND catID = old.catID);
		
	-- INSERT INTO PriorityList (fbID, catID, priorityValue)
    -- VALUES (old.fbID, old.catID, newPriority);
-- END

-- BEGIN
	-- DECLARE newPriority INT;

	-- SET newPriority = (SELECT CASE 
		-- WHEN (new.quantity > maxThreshold) THEN 0
		-- WHEN (new.quantity < minThreshold) THEN 2
		-- ELSE 1
	-- END 
	-- FROM FoodbankCategory
	-- WHERE fbID = new.fbID AND catID = new.catID);
		
	-- INSERT INTO PriorityList (fbID, catID, priorityValue)
    -- VALUES (new.fbID, new.catID, newPriority);
-- END


-- CREATE TRIGGER `tr_UpdatePriorityOnInsert` AFTER INSERT ON `FoodbankCategory` FOR EACH ROW BEGIN DECLARE newPriority INT; SET newPriority = (SELECT CASE WHEN (new.quantity > maxThreshold) THEN 0 WHEN (new.quantity < minThreshold) THEN 2 ELSE 1 END FROM FoodbankCategory WHERE fbID = new.fbID AND catID = new.catID); INSERT INTO PriorityList (fbID, catID, priorityValue) VALUES (new.fbID, new.catID, newPriority); END












--FR11/FR12
-- Initial idea for SP but would it be helpful to also get current quantity here as well?
CREATE PROCEDURE IF NOT EXISTS sp_GetProdCatsForParcelSize (IN parcel_id INT)
	SELECT catID, amount FROM ParcelCategory AS PC
	WHERE parcelID = parcel_id;
	
-- Same with current quantity for specific FB too
SELECT PC.catID, catName, quantity, amount, (SELECT (quantity < amount)) AS notEnough FROM ParcelCategory AS PC
LEFT JOIN FoodbankCategory AS FBC ON FBC.catID = PC.catID
LEFT JOIN ProductCategory AS PRODCAT ON PRODCAT.catID = PC.catID
WHERE FBC.fbID = 2 AND PC.parcelID = 3;
    
