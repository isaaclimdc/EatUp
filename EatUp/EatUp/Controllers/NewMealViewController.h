//
//  NewMealViewController.h
//  EatUp
//
//  Created by Isaac Lim on 3/2/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewMealViewController : UIViewController {
    UIImageView *selectionImg;
}

@property (strong, nonatomic) IBOutlet UIImageView *selectionImg;

- (IBAction)changeToWhen:(id)sender;
- (IBAction)changeToWhere:(id)sender;
- (IBAction)changeToWho:(id)sender;

@end
