//
//  sqlDB.m
//  DayReco
//
//  Created by Victor Wei on 10/4/16.
//  Copyright © 2016 VictorW. All rights reserved.
//

#import "sqlDB.h"
#import "sqlite3.h"

@implementation sqlDB

sqlite3 *userDB;
sqlite3 *recoDB;
sqlite3 *locationsDB;
sqlite3 *restaurantsDB;
sqlite3 *ratingsDB;

NSString *userDBPathString;
NSString *recoDBPathString;
NSString *locationDBPathString;
NSString *restaurantDBPathString;
NSString *ratingDBPathString;


//Create the Users database
- (void) createUserDB {
    //get the default documentdirectory path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    //get the path string and add the object name we are going to create at the path
    userDBPathString = [docPath stringByAppendingPathComponent:@"user.db"];
    char *errorMsg;
    
    //create an instance of the filemanager
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:userDBPathString]) {
        const  char *dbPath= [userDBPathString UTF8String];
        
        //Create the database
        if (sqlite3_open(dbPath, &userDB) == SQLITE_OK){
            
            //create the favorites table that has artist, album, price, numberofsongs, genre, releasedate, and ituneslink.
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS USERS(USERID INTEGER PRIMARY KEY AUTOINCREMENT, FNAME TEXT, LNAME TEXT, EMAIL TEXT, BIO TEXT, PASSWORD TEXT, PICTURE TEXT);";
            
            //perform the sql statement.  if there was a problem executing the statement, log the error
            if (sqlite3_exec(userDB, sql_stmt, NULL, NULL, &errorMsg)!= SQLITE_OK){
                NSLog(@"Failed to create table");
            }
            sqlite3_close(userDB);
        } else {
            NSLog(@"failed to create database");
        }
    } else {
        NSLog(@"database file already exisits");
    }
    
}

//Create db to hold all the city recommendations
- (void) createRecoDB {
    //get the default documentdirectory path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    //get the path string and add the object name we are going to create at the path
    recoDBPathString = [docPath stringByAppendingPathComponent:@"reco.db"];
    char *errorMsg;
    
    //create an instance of the filemanager
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:recoDBPathString]) {
        const  char *dbPath= [recoDBPathString UTF8String];
        
        //Create the database
        if (sqlite3_open(dbPath, &recoDB) == SQLITE_OK){
            
            //create the reco table that has information of a day recommendation.  has the userID associated with it, the category, description, and the day recommendation.
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS RECOS(RECOID INTEGER PRIMARY KEY AUTOINCREMENT, USERID INTEGER, CATEGORY TEXT, DESCRIPTION TEXT, DAYRECO TEXT, CITY TEXT);";
            
            //perform the sql statement.  if there was a problem executing the statement, log the error
            if (sqlite3_exec(recoDB, sql_stmt, NULL, NULL, &errorMsg)!= SQLITE_OK){
                NSLog(@"Failed to create table");
            }
            sqlite3_close(recoDB);
        } else {
            NSLog(@"failed to create database");
        }
    } else {
        NSLog(@"database file already exisits");
    }
    
}

//Create the locations database that is referenced by the recommendations database
- (void) createLocationsDB {
    //get the default documentdirectory path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    //get the path string and add the object name we are going to create at the path
    locationDBPathString = [docPath stringByAppendingPathComponent:@"locations.db"];
    char *errorMsg;
    
    //create an instance of the filemanager
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:locationDBPathString]) {
        const  char *dbPath= [locationDBPathString UTF8String];
        
        //Create the database
        if (sqlite3_open(dbPath, &locationsDB) == SQLITE_OK){
            
            //create the favorites table that has artist, album, price, numberofsongs, genre, releasedate, and ituneslink.
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS LOCATIONS(LOCATIONID INTEGER PRIMARY KEY AUTOINCREMENT, RECOID INTEGER, LOCATION TEXT, PLACEID TEXT, CITY TEXT);";
            
            //perform the sql statement.  if there was a problem executing the statement, log the error
            if (sqlite3_exec(locationsDB, sql_stmt, NULL, NULL, &errorMsg)!= SQLITE_OK){
                NSLog(@"Failed to create table");
            }
            sqlite3_close(locationsDB);
        } else {
            NSLog(@"failed to create database");
        }
    } else {
        NSLog(@"database file already exisits");
    }
}


//Create the restaurant database that is referenced by the recommendations database
- (void) createRestaurantsDB {
    //get the default documentdirectory path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    //get the path string and add the object name we are going to create at the path
    restaurantDBPathString = [docPath stringByAppendingPathComponent:@"restaurants.db"];
    char *errorMsg;
    
    //create an instance of the filemanager
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:restaurantDBPathString]) {
        const  char *dbPath= [restaurantDBPathString UTF8String];
        
        //Create the database
        if (sqlite3_open(dbPath, &restaurantsDB) == SQLITE_OK){
            
            //create the favorites table that has artist, album, price, numberofsongs, genre, releasedate, and ituneslink.
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS RESTAURANTS(RESTAURANTID INTEGER PRIMARY KEY AUTOINCREMENT, RECOID INTEGER, RESTAURANT TEXT, PLACEID TEXT, CITY TEXT);";
            
            //perform the sql statement.  if there was a problem executing the statement, log the error
            if (sqlite3_exec(restaurantsDB, sql_stmt, NULL, NULL, &errorMsg)!= SQLITE_OK){
                NSLog(@"Failed to create table");
            }
            sqlite3_close(restaurantsDB);
        } else {
            NSLog(@"failed to create database");
        }
    } else {
        NSLog(@"database file already exisits");
    }
    
}


//Create the ratings database that is referenced by the recommendations database
- (void) createRatingsDB {
    //get the default documentdirectory path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    //get the path string and add the object name we are going to create at the path
    ratingDBPathString = [docPath stringByAppendingPathComponent:@"ratings.db"];
    char *errorMsg;
    
    //create an instance of the filemanager
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:ratingDBPathString]) {
        const  char *dbPath= [ratingDBPathString UTF8String];
        
        //Create the database
        if (sqlite3_open(dbPath, &ratingsDB) == SQLITE_OK){
            
            //create the reco table that has information of a day recommendation.  has the userID associated with it, the category, description, and the day recommendation.
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS RATINGS(RATINGID INTEGER PRIMARY KEY AUTOINCREMENT, RECOID INTEGER, RATING INTEGER, USERID INTEGER);";
            
            //perform the sql statement.  if there was a problem executing the statement, log the error
            if (sqlite3_exec(ratingsDB, sql_stmt, NULL, NULL, &errorMsg)!= SQLITE_OK){
                NSLog(@"Failed to create table");
            }
            sqlite3_close(ratingsDB);
        } else {
            NSLog(@"failed to create database");
        }
    } else {
        NSLog(@"ratings database file already exisits");
    }
    
}






/*****
 Functions to add entries to the database
 *****/



//add a user to the database.
- (BOOL) addUser: (NSString*)fName lName: (NSString*)lName email:(NSString*)email shortBio:(NSString*)shortBio password:(NSString*)password picture:(NSString*)picture {
    
    char* errorMsg;
    //check to see if we can open the database
    if (sqlite3_open([userDBPathString UTF8String], &userDB)==SQLITE_OK) {
        
        //create the insert statement with the above values
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO USERS(FNAME, LNAME, EMAIL, BIO, PASSWORD, PICTURE) VALUES ('%s', '%s', '%s', '%s', '%s', '%s');", [fName UTF8String],[lName UTF8String], [email UTF8String], [shortBio UTF8String], [password UTF8String], [picture UTF8String]];
        
        
        const char *insert_stmt = [insertStmt UTF8String]; //gives a c representation of NSString
        //try to execute the insert statement
        if (sqlite3_exec(userDB, insert_stmt, NULL, NULL, &errorMsg)==SQLITE_OK) {
            //log that the album was added succesfully and close the database
            NSLog(@"User '%@' '%@' added", fName, lName);
            sqlite3_finalize(NULL);
            sqlite3_close(userDB);
            return true;
        } else {
            //execution of the insert statement failed.  Log the error
            NSLog(@"Error adding user to the database");
            //            NSString *temp = [NSString stringWithCString:errorMsg encoding: NSUTF8StringEncoding];
            //            NSLog(temp);
        }
    }
    
    sqlite3_close(userDB);
    return false;
}


//Add a recomendation to the RECO database.  Referenced by UserId.
- (BOOL) addReco: (NSNumber*)userId category:(NSString*)category description:(NSString*)description reco:(NSString*)reco city:(NSString*)city {
    
    char* errorMsg;
    //check to see if we can open the database
    if (sqlite3_open([recoDBPathString UTF8String], &recoDB)==SQLITE_OK) {
        
        //NSString *userIdString = [userId stringValue];
        //error checking for special character '
        NSString *descriptionString = [description stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        NSString *recoString = [reco stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        
        //create the insert statement with the above values
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO RECOS(USERID, CATEGORY, DESCRIPTION, DAYRECO, CITY) VALUES ('%d', '%s', '%s', '%s', '%s');", [userId intValue],[category UTF8String], [descriptionString UTF8String], [recoString UTF8String], [city UTF8String]];
        
        
        const char *insert_stmt = [insertStmt UTF8String]; //gives a c representation of NSString
        //try to execute the insert statement
        if (sqlite3_exec(recoDB, insert_stmt, NULL, NULL, &errorMsg)==SQLITE_OK) {
            //log that the album was added succesfully and close the database
            NSLog(@"Reco added");
            sqlite3_finalize(NULL);
            sqlite3_close(recoDB);
            return true;
        } else {
            //execution of the insert statement failed.  Log the error
            NSLog(@"Error adding reco to the database");
            //            NSString *temp = [NSString stringWithCString:errorMsg encoding: NSUTF8StringEncoding];
            //            NSLog(temp);
        }
    }
    
    sqlite3_close(recoDB);
    return false;
}


//Add a location to the location database.  Referenced by RecoId
- (BOOL) addLocation: (NSNumber*)recoID location:(NSString*)location placeId:(NSString*)placeId city:(NSString*)city {
    
    char* errorMsg;
    //check to see if we can open the database
    if (sqlite3_open([locationDBPathString UTF8String], &locationsDB)==SQLITE_OK) {
        
        //NSString *recoIdString = [recoID stringValue];
        //error checking for special character '
        NSString *locationString = [location stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        
        //create the insert statement with the above values
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO LOCATIONS(RECOID, LOCATION, PLACEID, CITY) VALUES ('%d', '%s', '%s', '%s');", [recoID intValue],[locationString UTF8String], [placeId UTF8String], [city UTF8String]];
        
        
        const char *insert_stmt = [insertStmt UTF8String]; //gives a c representation of NSString
        //try to execute the insert statement
        if (sqlite3_exec(locationsDB, insert_stmt, NULL, NULL, &errorMsg)==SQLITE_OK) {
            //log that the album was added succesfully and close the database
            NSLog(@"Location added");
            sqlite3_finalize(NULL);
            sqlite3_close(locationsDB);
            return true;
        } else {
            //execution of the insert statement failed.  Log the error
            NSLog(@"Error adding Location to the database");
            //            NSString *temp = [NSString stringWithCString:errorMsg encoding: NSUTF8StringEncoding];
            //            NSLog(temp);
        }
    }
    
    sqlite3_close(locationsDB);
    return false;
}



//Add a restaurant object to the database.  Referenced by recoId
- (BOOL) addRestaurant: (NSNumber*)recoID restaurant:(NSString*)restaurant placeId:(NSString*)placeId city:(NSString*)city {
    
    char* errorMsg;
    //check to see if we can open the database
    if (sqlite3_open([restaurantDBPathString UTF8String], &restaurantsDB)==SQLITE_OK) {
        
        //NSString *recoIdString = [recoID stringValue];
        //error checking for special character '
        NSString *restaurantString = [restaurant stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        
        //create the insert statement with the above values
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO RESTAURANTS(RECOID, RESTAURANT, PLACEID, CITY) VALUES ('%d', '%s', '%s', '%s');", [recoID intValue],[restaurantString UTF8String], [placeId UTF8String], [city UTF8String]];
        
        
        const char *insert_stmt = [insertStmt UTF8String]; //gives a c representation of NSString
        //try to execute the insert statement
        if (sqlite3_exec(restaurantsDB, insert_stmt, NULL, NULL, &errorMsg)==SQLITE_OK) {
            //log that the album was added succesfully and close the database
            NSLog(@"Restaurant added");
            sqlite3_finalize(NULL);
            sqlite3_close(restaurantsDB);
            return true;
        } else {
            //execution of the insert statement failed.  Log the error
            NSLog(@"Error adding Restaurant to the database");
            //            NSString *temp = [NSString stringWithCString:errorMsg encoding: NSUTF8StringEncoding];
            //            NSLog(temp);
        }
    }
    
    sqlite3_close(restaurantsDB);
    return false;
}


//Add a Rating object referenced by recoId
- (BOOL) addRating: (NSNumber*)recoID rating:(NSNumber*)rating userID:(NSNumber*)userID {
    char* errorMsg;
    //check to see if we can open the database
    if (sqlite3_open([ratingDBPathString UTF8String], &ratingsDB)==SQLITE_OK) {
        
        //create the insert statement with the above values
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO RATINGS(RECOID, RATING, USERID) VALUES ('%d', '%d', '%d');", [recoID intValue],[rating intValue], [userID intValue]];
        
        const char *insert_stmt = [insertStmt UTF8String]; //gives a c representation of NSString
        //try to execute the insert statement
        if (sqlite3_exec(ratingsDB, insert_stmt, NULL, NULL, &errorMsg)==SQLITE_OK) {
            //log that the album was added succesfully and close the database
            NSLog(@"Rating added");
            sqlite3_finalize(NULL);
            sqlite3_close(ratingsDB);
            return true;
        } else {
        }   NSLog(@"Error adding rating");
    }
    
    sqlite3_close(ratingsDB);
    return false;
}





/*****
 Functions to verify entries in the database
 *****/



//Used to validate whether an account is already registered in the SignUpVC

- (BOOL) doesUserExist: (NSString*)email{
    
    sqlite3_stmt *statement;
    //NSMutableArray *result = [[NSMutableArray alloc] init];
    //NSNumber *result = [[NSNumber alloc] init];
    
    if (sqlite3_open([userDBPathString UTF8String], &userDB) == SQLITE_OK){
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM USERS WHERE EMAIL = '%s'", [email UTF8String]];
        
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_prepare(userDB, query_sql, -1, &statement, NULL) == SQLITE_OK) {
            //for each row, get the column variables and store it into a variable
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                //NSNumber *userID = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(userDB);
                return true;
                
            }
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(userDB);
    return false;
    
}


//Used to validate whether the user credentials are correct
- (BOOL) isUserValid: (NSString*)email password:(NSString*)password {
    
    sqlite3_stmt *statement;
    //NSMutableArray *result = [[NSMutableArray alloc] init];
    //NSNumber *result = [[NSNumber alloc] init];
    
    if (sqlite3_open([userDBPathString UTF8String], &userDB) == SQLITE_OK){
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM USERS WHERE EMAIL = '%s' AND PASSWORD = '%s'", [email UTF8String], [password UTF8String]];
        
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_prepare(userDB, query_sql, -1, &statement, NULL) == SQLITE_OK) {
            //for each row, get the column variables and store it into a variable
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                sqlite3_finalize(statement);
                sqlite3_close(userDB);
                return true;
            }
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(userDB);
    return false;
    
}




//Used to determine if user has already added a rating to the current reco

- (BOOL) isRecoRated: (NSNumber*)recoId userId:(NSNumber*)userId {
    
    sqlite3_stmt *statement;
    
    if (sqlite3_open([ratingDBPathString UTF8String], &ratingsDB) == SQLITE_OK){
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM RATINGS WHERE RECOID = '%d' AND USERID = '%d'", [recoId intValue], [userId intValue]];
        
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_prepare(ratingsDB, query_sql, -1, &statement, NULL) == SQLITE_OK) {
            //for each row, get the column variables and store it into a variable
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                sqlite3_finalize(statement);
                sqlite3_close(ratingsDB);
                return true;
            }
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(ratingsDB);
    return false;
    
}




//Probably not needed
- (NSNumber*) getUserId: (NSString*)userName password:(NSString*)password {
    
    sqlite3_stmt *statement;
    //NSMutableArray *result = [[NSMutableArray alloc] init];
    NSNumber *result = [[NSNumber alloc] init];
    
    if (sqlite3_open([userDBPathString UTF8String], &userDB) == SQLITE_OK){
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM USERS WHERE EMAIL = '%s' AND PASSWORD = '%s", [userName UTF8String], [password UTF8String]];
        
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_prepare(userDB, query_sql, -1, &statement, NULL) == SQLITE_OK) {
            //for each row, get the column variables and store it into a variable
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSNumber *userID = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(userDB);
                return userID;
            }
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(userDB);
    return result;
}


//Get the user information based on the UserId.  Query the user database
- (NSArray*) getUserDataFromId: (NSNumber*)userId {
    
    sqlite3_stmt *statement;
    NSArray *result = [[NSArray alloc] init];
    //check access to the user database
    if (sqlite3_open([userDBPathString UTF8String], &userDB) == SQLITE_OK){
        //create the query as a NSString object
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM USERS WHERE USERID = '%d'", [userId intValue]];
        
        const char *query_sql = [querySql UTF8String];
        if (sqlite3_prepare(userDB, query_sql, -1, &statement, NULL) == SQLITE_OK) {
            //for each row, get the column variables and store it into a variable
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                //get the column information of the user.
                NSNumber *userID = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
                NSString *fName = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(statement, 1)];
                NSString *lName = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(statement, 2)];
                NSString *bio = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(statement, 4)];
                NSString *picture = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(statement, 6)];
                
                //create a nsarray object to hold all the values and then add it to the nsmutablearray object so we can send it back to the user
                result = @[userID, fName, lName, bio, picture];
                
            }
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(userDB);
    return result;
    
}



//Get userdata based on the email of the user.  Used for logging in.
- (NSArray*) getUserData: (NSString*)email {
    
    sqlite3_stmt *statement;
    NSArray *result = [[NSArray alloc] init];
    if (sqlite3_open([userDBPathString UTF8String], &userDB) == SQLITE_OK){
        
        //create the query string as a NSString object
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM USERS WHERE EMAIL = '%s'", [email UTF8String]];
        const char *query_sql = [querySql UTF8String];
        // send query statement to userdatabase
        if (sqlite3_prepare(userDB, query_sql, -1, &statement, NULL) == SQLITE_OK) {
            //for each row, get the column variables and store it into a variable
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                //Get user information and set it as the variables
                NSNumber *userID = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
                NSString *fName = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(statement, 1)];
                NSString *lName = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(statement, 2)];
                NSString *bio = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(statement, 4)];
                NSString *picture = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(statement, 6)];
                
                //create a nsarray object to hold all the values and then add it to the nsmutablearray object so we can send it back to the user
                result = @[userID, fName, lName, bio, picture];
                
            }
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(userDB);
    return result;
    
}


//Get the RecoId of an reco object
- (NSNumber*) getRecoId: (NSNumber*)userId description:(NSString*)description reco:(NSString*)reco city:(NSString*)city{
    sqlite3_stmt *statement;
    NSNumber *recoId = [[NSNumber alloc] init];
    NSString *recoText = [reco stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    //check access to the reco database
    if (sqlite3_open([recoDBPathString UTF8String], &recoDB) == SQLITE_OK){
        //set the query string for the database as an NSString object
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM RECOS WHERE USERID = '%d' AND DESCRIPTION = '%s' AND DAYRECO = '%s' AND CITY = '%s'", [userId intValue], [description UTF8String], [recoText UTF8String], [city UTF8String]];
        const char *query_sql = [querySql UTF8String];
        //execute the query string with the database
        if (sqlite3_prepare(recoDB, query_sql, -1, &statement, NULL) == SQLITE_OK) {
            //for each row, get the column variables and store it into a variable
            while (sqlite3_step(statement) == SQLITE_ROW) {
                recoId = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
            }
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(recoDB);
    return recoId;
    
}





//Get all recos for a given city string
- (NSMutableArray*) getAllRecosForCity: (NSString*)city {
    
    sqlite3_stmt *statement;
    NSMutableArray *result = [[NSMutableArray alloc] init];
    //check access to reco database
    if (sqlite3_open([recoDBPathString UTF8String], &recoDB) == SQLITE_OK){
        NSString *cityString = [city stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        //set the query string
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM RECOS WHERE CITY = '%s'", [cityString UTF8String]];
        const char *query_sql = [querySql UTF8String];
        //execute the query
        if (sqlite3_prepare(recoDB, query_sql, -1, &statement, NULL) == SQLITE_OK) {
            //for each row, get the column variables and store it into a variable
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSNumber *recoID = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
                NSNumber *userID = [NSNumber numberWithInt:sqlite3_column_int(statement, 1)];
                NSString *category = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(statement, 2)];
                NSString *description = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(statement, 3)];
                NSString *dayreco = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(statement, 4)];
                NSString *cityVal = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(statement, 5)];
                
                //create a nsarray object to hold all the values and then add it to the nsmutablearray object so we can send it back to the user
                NSArray *object = @[recoID, userID, category, description, dayreco, cityVal];
                [result addObject:object];
            }
        } else {
            NSLog(@"Error getting city data");
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(recoDB);
    return result;
}




//Get all recos based on category and city
- (NSMutableArray*) getAllRecosForCityCategory: (NSString*)city category:(NSString*)category{
    
    sqlite3_stmt *statement;
    NSMutableArray *result = [[NSMutableArray alloc] init];
    if (sqlite3_open([recoDBPathString UTF8String], &recoDB) == SQLITE_OK){
        NSString *cityString = [city stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM RECOS WHERE CITY = '%s' AND CATEGORY = '%s'", [cityString UTF8String], [category UTF8String]];
        
        const char *query_sql = [querySql UTF8String];
        if (sqlite3_prepare(recoDB, query_sql, -1, &statement, NULL) == SQLITE_OK) {
            //for each row, get the column variables and store it into a variable
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSNumber *recoID = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
                NSNumber *userID = [NSNumber numberWithInt:sqlite3_column_int(statement, 1)];
                NSString *category = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(statement, 2)];
                NSString *description = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(statement, 3)];
                NSString *dayreco = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(statement, 4)];
                NSString *cityVal = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(statement, 5)];
                
                //create a nsarray object to hold all the values and then add it to the nsmutablearray object so we can send it back to the user
                NSArray *object = @[recoID, userID, category, description, dayreco, cityVal];
                [result addObject:object];
            }
        } else {
            NSLog(@"Error getting city data");
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(recoDB);
    return result;
    
    
    
}







//Get all reco objects based on the User Id
- (NSMutableArray*) getAllRecosFromUser: (NSNumber*)userId {
    
    sqlite3_stmt *statement;
    NSMutableArray *result = [[NSMutableArray alloc] init];
    if (sqlite3_open([recoDBPathString UTF8String], &recoDB) == SQLITE_OK){
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM RECOS WHERE USERID = '%d'", [userId intValue]];
        const char *query_sql = [querySql UTF8String];
        if (sqlite3_prepare(recoDB, query_sql, -1, &statement, NULL) == SQLITE_OK) {
            //for each row, get the column variables and store it into a variable
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSNumber *recoId = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
                NSNumber *userID = [NSNumber numberWithInt:sqlite3_column_int(statement, 1)];
                NSString *category = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(statement, 2)];
                NSString *description = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(statement, 3)];
                NSString *dayreco = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(statement, 4)];
                NSString *cityVal = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(statement, 5)];
                
                //create a nsarray object to hold all the values and then add it to the nsmutablearray object so we can send it back to the user
                NSArray *object = @[recoId, userId, category, description, dayreco, cityVal];
                [result addObject:object];
            }
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(recoDB);
    return result;
    
    
}


//Grab all location objects based on RecoId
- (NSMutableArray*) getLocationsForReco: (NSNumber*)recoId {
    
    sqlite3_stmt *statement;
    NSMutableArray *result = [[NSMutableArray alloc] init];
    //check location database access
    if (sqlite3_open([locationDBPathString UTF8String], &locationsDB) == SQLITE_OK){
        //NSString *recoString = [recoId stringValue];
        
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM LOCATIONS WHERE RECOID = '%d'", [recoId intValue]];
        
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_prepare(locationsDB, query_sql, -1, &statement, NULL) == SQLITE_OK) {
            //for each row, get the column variables and store it into a variable
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *location = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(statement, 2)];
                NSString *placeId = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(statement, 3)];
                NSString *city = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(statement, 4)];
                //create a nsarray object to hold all the values and then add it to the nsmutablearray object so we can send it back to the user
                NSArray *object = @[location, placeId, city];
                [result addObject:object];
            }
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(locationsDB);
    return result;
    
}



//Get all restaurants objects from restaurant database based on the corresponding recoId.
- (NSMutableArray*) getRestaurantsForReco: (NSNumber*)recoId {
    
    sqlite3_stmt *statement;
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    if (sqlite3_open([restaurantDBPathString UTF8String], &restaurantsDB) == SQLITE_OK){
        //NSString *recoString = [recoId stringValue];
        
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM RESTAURANTS WHERE RECOID = '%d'", [recoId intValue]];
        
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_prepare(restaurantsDB, query_sql, -1, &statement, NULL) == SQLITE_OK) {
            //for each row, get the column variables and store it into a variable
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSString *restaurant = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(statement, 2)];
                NSString *placeId = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(statement, 3)];
                NSString *city = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(statement, 4)];
                
                //create a nsarray object to hold all the values and then add it to the nsmutablearray object so we can send it back to the user
                NSArray *object = @[restaurant, placeId, city];
                [result addObject:object];
            }
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(restaurantsDB);
    return result;
}



//Get the ratings for reco.  Returns all the ratings associated with the reco Id.
- (NSMutableArray*) getRatingsForReco: (NSNumber*)recoId {
    sqlite3_stmt *statement;
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    if (sqlite3_open([ratingDBPathString UTF8String], &ratingsDB) == SQLITE_OK){
        
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM RATINGS WHERE RECOID = '%d'", [recoId intValue]];
        
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_prepare(ratingsDB, query_sql, -1, &statement, NULL) == SQLITE_OK) {
            //for each row, get the column variables and store it into a variable
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSNumber *recoId = [NSNumber numberWithInt:sqlite3_column_int(statement, 1)];
                NSNumber *rating = [NSNumber numberWithInt:sqlite3_column_int(statement, 2)];
                NSNumber *userId = [NSNumber numberWithInt:sqlite3_column_int(statement, 3)];
                
                NSArray *object = @[recoId, rating, userId];
                
                [result addObject:object];
            }
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(ratingsDB);
    return result;
}



//Get the specific rating for a user with a specific reco.  Return 0 if no rating is found.
- (NSNumber*) getUserRecRating: (NSNumber*)recoId userId:(NSNumber*)userId {
    sqlite3_stmt *statement;
    NSNumber *result = [[NSNumber alloc] init];
    
    if (sqlite3_open([ratingDBPathString UTF8String], &ratingsDB) == SQLITE_OK){
        
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM RATINGS WHERE RECOID = '%d' AND USERID = '%d'", [recoId intValue], [userId intValue]];
        
        const char *query_sql = [querySql UTF8String];
        
        if (sqlite3_prepare(ratingsDB, query_sql, -1, &statement, NULL) == SQLITE_OK) {
            //for each row, get the column variables and store it into a variable
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSNumber *recoId = [NSNumber numberWithInt:sqlite3_column_int(statement, 1)];
                NSNumber *rating = [NSNumber numberWithInt:sqlite3_column_int(statement, 2)];
                NSNumber *userId = [NSNumber numberWithInt:sqlite3_column_int(statement, 3)];
                
                result = rating;
                sqlite3_finalize(statement);
                sqlite3_close(ratingsDB);
                return result;
            }
        }
    }
    result = 0;
    sqlite3_finalize(statement);
    sqlite3_close(ratingsDB);
    return result;
}


@end
