//
//  sqlDB.h
//  DayRec
//
//  Created by Victor Wei on 10/7/16.
//  Copyright © 2016 victorW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"



@interface sqlDB : NSObject

//Predefined functions
//Functions to create databases
- (void) createUserDB;
- (void) createRecoDB;
- (void) createLocationsDB;
- (void) createRestaurantsDB;
- (void) createRatingsDB;

//Functions to update databases
- (BOOL) addUser: (NSString*)fName lName: (NSString*)lName email:(NSString*)email shortBio:(NSString*)shortBio password:(NSString*)password picture:(NSString*)picture;
- (BOOL) addReco: (NSNumber*)userId category:(NSString*)category description:(NSString*)description reco:(NSString*)reco city:(NSString*)city;
- (BOOL) addLocation: (NSNumber*)recoID location:(NSString*)location placeId:(NSString*)placeId city:(NSString*)city;
- (BOOL) addRestaurant: (NSNumber*)recoID restaurant:(NSString*)restaurant placeId:(NSString*)placeId city:(NSString*)city;
- (BOOL) addRating: (NSNumber*)recoID rating:(NSNumber*)rating userID:(NSNumber*)userID;

//Function to determine if user exists
- (BOOL) doesUserExist: (NSString*)email;

- (BOOL) isUserValid: (NSString*)email password:(NSString*)password;
- (BOOL) isRecoRated: (NSNumber*)recoId userId:(NSNumber*)userId;

//Function to grab data

- (NSArray*) getUserDataFromId: (NSNumber*)userId;
- (NSMutableArray*) getUserData: (NSString*)email;
- (NSNumber*) getUserId: (NSString*)userName password:(NSString*)password;  //unncessary?
- (NSNumber*) getRecoId: (NSNumber*)userId description:(NSString*)description reco:(NSString*)reco city:(NSString*)city;


- (NSMutableArray*) getAllRecosForCity: (NSString*)city;


- (NSMutableArray*) getAllRecosForCityCategory: (NSString*)city category:(NSString*)category;

- (NSMutableArray*) getAllRecosFromUser: (NSNumber*)userId;
- (NSMutableArray*) getLocationsForReco: (NSNumber*)recoId;
- (NSMutableArray*) getRestaurantsForReco: (NSNumber*)recoId;

- (NSMutableArray*) getRatingsForReco: (NSNumber*)recoId;


- (NSNumber*) getUserRecRating: (NSNumber*)recoId userId:(NSNumber*)userId;




@end




