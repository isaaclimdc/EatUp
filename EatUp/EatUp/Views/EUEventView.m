//
//  EUEventView.m
//  EatUp
//
//  Created by Isaac Lim on 3/8/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "EUEventView.h"

@implementation EUEventView

@synthesize event, parentVC;
@synthesize titleLabel, dateTimeLabel, locationLabel, goingSegCtrl, participantsScrollView, descriptionTextView;

+ (EUEventView *)newEventViewWithFrame:(CGRect)aFrame
                                 event:(EUEvent *)anEvent
                                parent:(EventViewController *)parentVC
{
    EUEventView *eventView = [[EUEventView alloc] initWithFrame:aFrame];
    eventView.parentVC = parentVC;
    [eventView customizeForEvent:anEvent];
    return eventView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = self.frame.size.width - 2*kEUEventHorzBuffer;
        
        /* Date label */
        dateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kEUEventHorzBuffer,
                                                                  kEUEventHorzBuffer,
                                                                  width,
                                                                  20)];
        dateTimeLabel.font = kEUFontTextItalic;
        dateTimeLabel.textColor = [UIColor grayColor];
        dateTimeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:dateTimeLabel];

        /* Title label */
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kEUEventHorzBuffer,
                                                               CGFloatGetAfterY(dateTimeLabel.frame),
                                                               width,
                                                               30)];
        titleLabel.font = kEUFontTitle;
        titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLabel];

        /* Location label */
        locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(kEUEventHorzBuffer,
                                                                  CGFloatGetAfterY(titleLabel.frame),
                                                                  width,
                                                                  20)];
        locationLabel.font = kEUFontTextItalic;
        locationLabel.backgroundColor = [UIColor clearColor];
        locationLabel.userInteractionEnabled = YES;
        [self addSubview:locationLabel];

        /* Going/Notgoing Segmented Control */
        goingSegCtrl = [[UISegmentedControl alloc] initWithItems:@[@"Going", @"Maybe", @"Not"]];
        goingSegCtrl.frame = CGRectMake(kEUEventHorzBuffer, CGFloatGetAfterY(locationLabel.frame), width, 44);
        goingSegCtrl.selectedSegmentIndex = 1;
        [goingSegCtrl addTarget:self action:@selector(segCtrlChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:goingSegCtrl];

        /* Participants Scroller */
        participantsScrollView = [[ILSideScrollView alloc] initWithFrame:CGRectMake(0,
                                                                                    CGFloatGetAfterY(goingSegCtrl.frame),
                                                                                    self.frame.size.width,
                                                                                    150)];
        [participantsScrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"debut.png"]]
                                    indicatorStyle:UIScrollViewIndicatorStyleBlack
                                   itemBorderColor:kEUMainColor];
        [self addSubview:participantsScrollView];

        /* Description Text View */
        descriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(kEUEventHorzBuffer,
                                                                           CGFloatGetAfterY(participantsScrollView.frame),
                                                                           width,
                                                                           200)];
        descriptionTextView.font = kEUFontText;
        descriptionTextView.editable = NO;
        descriptionTextView.scrollEnabled = NO;
        descriptionTextView.backgroundColor = [UIColor clearColor];
        [self addSubview:descriptionTextView];

        /* Self customization */
        self.backgroundColor = kEUBkgColor;
        
    }
    return self;
}

- (void)customizeForEvent:(EUEvent *)anEvent
{
    self.event = anEvent;
    self.dateTimeLabel.text = [self.event absoluteDateString];
    self.titleLabel.text = self.event.title;
    self.descriptionTextView.text = self.event.description;
    [self autoResize:descriptionTextView];
    self.goingSegCtrl.selectedSegmentIndex = 1;  // By default "Maybe"

    self.locationLabel.attributedText = [self.event locationsString];
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:parentVC action:@selector(locationTapped)];
    [self.locationLabel addGestureRecognizer:tapGesture];

    /* Populate side scroll view */
    NSMutableArray *items = [NSMutableArray array];
    for (EUUser *participant in self.event.participants) {
        ILSideScrollViewItem *item = [ILSideScrollViewItem item];
        item.defaultBackgroundImage = participant.profPic;
        [item setTarget:self action:@selector(pictureTapped:) withObject:participant];
        [items addObject:item];
    }
    [self.participantsScrollView populateSideScrollViewWithItems:items];

    /* Finalize content size */
    self.contentSize = CGSizeMake(self.frame.size.width, CGFloatGetAfterY(descriptionTextView.frame));
}

- (void)pictureTapped:(EUUser *)user
{
    NSString *title, *msg;
    double myUID = [[NSUserDefaults standardUserDefaults] doubleForKey:@"EUMyUID"];
    if (user.uid == myUID) {
        title = @"That's you!";
        msg = @"You're going to this event.";
    }
    else {
        title = [NSString stringWithFormat:@"That's %@!", [user fullName]];
        msg = [NSString stringWithFormat:@"%@ is also going to this event.", user.firstName];
    }
    
    [ILAlertView showWithTitle:title
                       message:msg
              closeButtonTitle:@"OK"
             secondButtonTitle:nil];
}

- (IBAction)segCtrlChanged:(id)sender
{
    UISegmentedControl *segCtrl = (UISegmentedControl *)sender;
    NSUInteger idx = segCtrl.selectedSegmentIndex;

    CGFloat x;
    if (idx == 0)
        x = 60;
    else if (idx == 1)
        x = 160;
    else
        x = 260;

    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(x, segCtrl.center.y);
    spinner.hidesWhenStopped = YES;
    [self addSubview:spinner];
    [spinner startAnimating];

    [self performBlock:^{
        [spinner stopAnimating];
        [spinner removeFromSuperview];
    } afterDelay:0.75];
}

/* Vertically autoresize a UITextView or a UILabel to fit its content */
- (void)autoResize:(UIView *)view
{
    NSString *text;
    UIFont *font;
    if ([view isMemberOfClass:[UITextView class]]) {
        UITextView *textView = (UITextView *)view;
        text = textView.text;
        font = textView.font;
    }
    else if ([view isMemberOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)view;;
        text = label.text;
        font = label.font;
    }

    CGRect rect = view.frame;
    CGSize newSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(view.frame.size.width, MAXFLOAT)];
    rect.size.height = newSize.height + 4*kEUEventVertBuffer + 100;
    view.frame = rect;
}

static CGFloat CGFloatGetAfterY(CGRect rect) {
    return rect.origin.y + rect.size.height + kEUEventVertBuffer;
}

@end
