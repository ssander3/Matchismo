//
//  SetCardViewController.m
//  Matchismo
//
//  Created by Scott Sanders on 1/1/15.
//  Copyright (c) 2015 CS193p. All rights reserved.
//

#import "SetCardViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"

@interface SetCardViewController ()

@end

@implementation SetCardViewController


-(Deck *)createDeck
{
    self.gameType = @"Set Cards";
    return [[SetCardDeck alloc] init];
}

-(NSAttributedString *)titleForCard:(Card *)card
{
    NSString *symbol = @"?";
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    if ([card isKindOfClass:[SetCard class]]) {
        SetCard *setCard = (SetCard *)card;
        
        if ([setCard.symbol isEqualToString:@"oval"]) symbol = @"●";
        if ([setCard.symbol isEqualToString:@"squiggle"]) symbol = @"▲";
        if ([setCard.symbol isEqualToString:@"diamond"]) symbol = @"■";
        
        symbol = [symbol stringByPaddingToLength:setCard.number withString:symbol startingAtIndex:0];
        
        if ([setCard.color isEqualToString:@"red"]) {
            [attributes setObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
        }
        if ([setCard.color isEqualToString:@"green"]) {
            [attributes setObject:[UIColor greenColor] forKey:NSForegroundColorAttributeName];
        }
        if ([setCard.color isEqualToString:@"blue"]) {
            [attributes setObject:[UIColor blueColor] forKey:NSForegroundColorAttributeName];
        }
        
        if ([setCard.shade isEqualToString:@"solid"]) {
            [attributes setObject:@-5 forKey:NSStrokeWidthAttributeName];
        }
        if ([setCard.shade isEqualToString:@"striped"]) {
            [attributes addEntriesFromDictionary:@{NSStrokeWidthAttributeName : @-5,
                                                   NSStrokeColorAttributeName : attributes[NSForegroundColorAttributeName],
                                                   NSForegroundColorAttributeName : [attributes[NSForegroundColorAttributeName] colorWithAlphaComponent:0.1]}];
        }
        if ([setCard.shade isEqualToString:@"open"]) {
            [attributes setObject:@5 forKey:NSStrokeWidthAttributeName];
        }
    }
    
    return [[NSMutableAttributedString alloc] initWithString:symbol attributes:attributes];
}

- (NSAttributedString *)attributedContentsOfCard:(Card *)card
{
    return [self titleForCard:card];
}

-(UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"setCardSelected" : @"setCard"];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
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
