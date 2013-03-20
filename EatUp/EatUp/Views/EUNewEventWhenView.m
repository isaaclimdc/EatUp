//
//  EUNewEventWhenView.m
//  EatUp
//
//  Created by Isaac Lim on 3/16/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "EUNewEventWhenView.h"

@interface EUNewEventWhenView ()
{
    UIDatePicker *datePicker;
    UILabel *dateLabel;
    UITextView *titleBox;
    UITextView *descriptionBox;

    NSDate *eventDateTime;
}
@end

@implementation EUNewEventWhenView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = frame.size.width - kEUNewEventBuffer*2;
        
        /* Date/Time */
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kEUNewEventBuffer,
                                                              kEUNewEventBuffer,
                                                              width,
                                                              kEUNewEventRowHeight)];
        eventDateTime = [NSDate date];
        dateLabel.text = [self dateString];
        dateLabel.font = kEUNewEventBoxFont;
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:dateLabel];

        UIButton *dateTimeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        dateTimeButton.frame = CGRectMake(kEUNewEventBuffer,
                                          CGFloatGetAfterY(dateLabel.frame),
                                          width,
                                          kEUNewEventRowHeight);
        [dateTimeButton setTitle:@"Set event start time" forState:UIControlStateNormal];
        [dateTimeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        dateTimeButton.titleLabel.font = kEUNewEventLabelFont;
        [dateTimeButton addTarget:self action:@selector(showDateActionSheet:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:dateTimeButton];

        /* Title */
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kEUNewEventBuffer,
                                                                        CGFloatGetAfterY(dateTimeButton.frame)+kEUNewEventBuffer,
                                                                        width,
                                                                        kEUNewEventRowHeight)];
        titleLabel.text = @"Event title";
        titleLabel.font = kEUNewEventLabelFont;
        titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLabel];

        titleBox = [[UITextView alloc] initWithFrame:CGRectMake(kEUNewEventBuffer,
                                                                CGFloatGetAfterY(titleLabel.frame),
                                                                width,
                                                                50.0f)];
        titleBox.backgroundColor = [UIColor whiteColor];
        titleBox.font = kEUNewEventBoxFont;
        titleBox.autocapitalizationType = UITextAutocapitalizationTypeWords;
        [self addSubview:titleBox];

        /* Description */
        UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kEUNewEventBuffer,
                                                                              CGFloatGetAfterY(titleBox.frame)+kEUNewEventBuffer,
                                                                              width,
                                                                              kEUNewEventRowHeight)];
        descriptionLabel.text = @"Event description";
        descriptionLabel.font = kEUNewEventLabelFont;
        descriptionLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:descriptionLabel];

        descriptionBox = [[UITextView alloc] initWithFrame:CGRectMake(kEUNewEventBuffer,
                                                                      CGFloatGetAfterY(descriptionLabel.frame),
                                                                      width,
                                                                      300.0f)];
        descriptionBox.backgroundColor = [UIColor whiteColor];
        descriptionBox.font = kEUNewEventBoxFont;
        [self addSubview:descriptionBox];

        /* Finally, set content size */
        self.contentSize = CGSizeMake(frame.size.width, CGFloatGetAfterY(descriptionBox.frame)+kEUNewEventBuffer);
    }
    return self;
}

- (IBAction)showDateActionSheet:(id)sender
{
    UIActionSheet *aSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:@"Select"
                                               otherButtonTitles:nil];

    [aSheet showInView:[[[UIApplication sharedApplication] delegate] window]];
    aSheet.bounds = CGRectMake(10, 0, self.frame.size.width, 550);

    /* Add the picker */
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    datePicker.date = eventDateTime;
    [aSheet addSubview:datePicker];

    /* Arrange the buttons */
    NSArray *subviews = [aSheet subviews];
	[[subviews objectAtIndex:0] setFrame:CGRectMake(20, 233, 280, 46)];
	[[subviews objectAtIndex:1] setFrame:CGRectMake(20, 288, 280, 46)];
    [[subviews objectAtIndex:2] setFrame:CGRectMake(0, 0, 320, 500)];
}

/* Package up data on this view and prepare for sending */
- (NSDictionary *)serialize
{
    NSDictionary *dict = @{
                           kEURequestKeyEventDateTime : eventDateTime,
                           kEURequestKeyEventTitle : titleBox.text,
                           kEURequestKeyEventDescription : descriptionBox.text
                           };

    return dict;
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        eventDateTime = datePicker.date;
        dateLabel.text = [self dateString];
    }
}

#pragma mark - Helper Methods

- (NSString *)dateString
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = kEUDateFormat;
    df.dateStyle = NSDateFormatterFullStyle;
    return [df stringFromDate:eventDateTime];
}

static CGFloat CGFloatGetAfterY(CGRect rect) {
    return rect.origin.y + rect.size.height;
}

@end