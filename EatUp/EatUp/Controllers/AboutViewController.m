//
//  AboutViewController.m
//  EatUp
//
//  Created by Isaac Lim on 4/23/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

@synthesize versionLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"debut.png"]];

    self.navigationItem.leftBarButtonItem =
    [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"menu.png"]
                        selectedImage:[UIImage imageNamed:@"menuSelected.png"]
                               target:self
                               action:@selector(showSideMenu)];

    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [NSString stringWithFormat:@"Version %@.%@",
                         [infoDict objectForKey:@"CFBundleShortVersionString"],
                         [infoDict objectForKey:@"CFBundleVersion"]];

    NSMutableAttributedString *attrVersion = [[NSMutableAttributedString alloc] initWithString:version];
    [attrVersion addAttributes:@{ NSFontAttributeName : kEUFontTextBold, NSForegroundColorAttributeName : [UIColor whiteColor] }
                         range:NSMakeRange(0, [@"Version" length])];
    versionLabel.attributedText = attrVersion;
}

- (void)showSideMenu
{
    UIViewController *VC;

    if (self.navigationController.revealController.focusedController ==
        self.navigationController.revealController.leftViewController)
    {
        VC = self.navigationController.revealController.frontViewController;
    }
    else
    {
        VC = self.navigationController.revealController.leftViewController;
    }

    [self.navigationController.revealController showViewController:VC];
}

@end
