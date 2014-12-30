//
//  PlayingCardViewController.m
//  Matchismo
//
//  Created by Melanie Sanders on 12/13/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "PlayingCardViewController.h"
#import "PlayingCardDeck.h"

@interface PlayingCardViewController ()

@end

@implementation PlayingCardViewController

-(Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (UIColor *)colorForCard:(Card *)card
{
    // if it is a heart or diamond set the color to red
    if ([[card contents] containsString:@"♦"] || [[card contents] containsString:@"♥"]) {
        return [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1];
    }
    else {
        // otherwise set the color to black
        return [UIColor colorWithWhite:0.0f alpha:1];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
