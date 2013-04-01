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
#define kEURequestKeyEventHost @"host"
#define kEURequestKeyEventParticipants @"participants"
#define kEURequestKeyEventLocations @"locations"

#define kEURequestKeyUserUID @"uid"
#define kEURequestKeyUserFirstName @"first_name"
#define kEURequestKeyUserLastName @"last_name"
#define kEURequestKeyUserProfPic @"prof_pic"
#define kEURequestKeyUserParticipating @"participating"
#define kEURequestKeyUserFriends @"friends"
#define kEUFBUserProfPic(x) [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=normal", (x)]

#define kEURequestKeyLocationLat @"lat"
#define kEURequestKeyLocationLng @"lng"
#define kEURequestKeyLocationFriendlyName @"friendly_name"
#define kEURequestKeyLocationLink @"link"
#define kEURequestKeyLocationNumVotes @"num_votes"

#define kEUYelpBaseURL @"http://api.yelp.com/v2"
#define kEUYelpConsumerKey @"WrhO5jwo5-cU_XksdvwF9w"
#define kEUYelpConsumerSecret @"LIX5ilgW8Rb4T1aDGpkbV76Tcno"
#define kEUYelpToken @"_lgr6HuRLW3g87TKWAO0E7g-R8A3klD5"
#define kEUYelpTokenSecret @"22DvMsd9iCPHgwQT-0AlH3bmkM0"

/* NSUserDefaults Keys */
#define kEUUserDefaultsKeyMyUID @"EUMyUID"
#define kEUUserDefaultsKeyMyName @"EUMyName"

/* Misc */
#define kEUDateFormat @"yyyy-MM-dd HH:mm:ss ZZZ"
