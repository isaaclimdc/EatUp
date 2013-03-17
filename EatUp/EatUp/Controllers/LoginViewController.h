//
//  LoginViewController.h
//  EatUp
//
//  Created by Isaac Lim on 3/2/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController {
    UIImageView *background;
    UIActivityIndicatorView *spinner;
}

@property (strong, nonatomic) IBOutlet UIImageView *background;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

- (void)loginFailed;
+ (void)performLogout;

@end
