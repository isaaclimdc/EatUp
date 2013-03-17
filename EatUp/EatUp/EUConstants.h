//
//  EUConstants.h
//  EatUp
//
//  Created by Isaac Lim on 3/3/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import <Foundation/Foundation.h>

/* Colors */
#define kEUMainColor [UIColor colorWithRed:0.9294 green:0.4078 blue:0.0353 alpha:1.0]

/* Fonts */
#define kEUFontFamilyName @"AvenirNext-"
#define kEUFontText [UIFont fontWithName:kEUFontFamilyName @"Regular" size:18]
#define kEUFontBigText [UIFont fontWithName:kEUFontFamilyName @"Regular" size:20]
#define kEUFontTextBold [UIFont fontWithName:kEUFontFamilyName @"DemiBold" size:18]
#define kEUFontTextItalic [UIFont fontWithName:kEUFontFamilyName @"Italic" size:14]
#define kEUFontTitle [UIFont fontWithName:kEUFontFamilyName @"DemiBold" size:20]
#define kEUFontBarTitle [UIFont fontWithName:kEUFontFamilyName @"DemiBold" size:20]
#define kEUFontSubText [UIFont fontWithName:kEUFontFamilyName @"Regular" size:12]
#define kEUNewEventLabelFont kEUFontTextBold
#define kEUNewEventBoxFont kEUFontBigText

/* Rects */
#define kEUEventHorzBuffer 20.0f
#define kEUEventVertBuffer 10.0f
#define kEUNewEventBuffer 20.0f
#define kEUNewEventRowHeight 40.0f

/* HTTP Requests */
#define kEUBaseURL @"http://isaacl.net/install/apps/EatUp/"

#define kEURequestKeyEventEID @"eid"
#define kEURequestKeyEventTitle @"title"
#define kEURequestKeyEventDateTime @"date_time"
#define kEURequestKeyEventDescription @"description"
#define kEURequestKeyEventParticipants @"participants"
#define kEURequestKeyEventLocations @"locations"

#define kEURequestKeyUserUID @"uid"
#define kEURequestKeyUserFirstName @"first_name"
#define kEURequestKeyUserLastName @"last_name"
#define kEURequestKeyUserProfPic @"prof_pic"
#define kEURequestKeyUserParticipating @"participating"
#define kEURequestKeyUserFriends @"friends"

#define kEURequestKeyLocationLat @"lat"
#define kEURequestKeyLocationLng @"lng"
#define kEURequestKeyLocationFriendlyName @"friendly_name"
#define kEURequestKeyLocationLink @"link"
#define kEURequestKeyLocationNumVotes @"num_votes"

/* NSUserDefaults Keys */
#define kEUUserDefaultsKeyMyUID @"EUMyUID"
#define kEUUserDefaultsKeyMyName @"EUMyName"

/* Misc */
#define kEUDateFormat @"yyyy-MM-dd HH:mm:ss ZZZ"
