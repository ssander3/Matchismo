//
//  PlayingCardViewController.m
//  Matchismo
//
//  Created by Melanie Sanders on 12/13/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "PlayingCardViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@interface PlayingCardViewController ()

@end

@implementation PlayingCardViewController

-(Deck *)createDeck
{
    self.gameType = @"Playing Cards";
    return [[PlayingCardDeck alloc] init];
}

-(NSAttributedString *)titleForCard:(Card *)card
{
    NSString *title = @"?";
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    if ([card isKindOfClass:[PlayingCard class]]) {
        PlayingCard *playingCard = (PlayingCard *)card;
        
        title = playingCard.isChosen ? playingCard.contents : @"";
        
        if ([title containsString:@"♦"] || [title containsString:@"♥"]) {
            [attributes setObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
        }
        else
        {
            [attributes setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
        }
    }
    
    return [[NSMutableAttributedString alloc] initWithString:title attributes:attributes];
}

-(NSAttributedString *)attributedContentsOfCard:(Card *)card
{
    NSString *title = @"?";
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    if ([card isKindOfClass:[PlayingCard class]]) {
        PlayingCard *playingCard = (PlayingCard *)card;
        
        title =  playingCard.contents;
        
        if ([title containsString:@"♦"] || [title containsString:@"♥"]) {
            [attributes setObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
        }
        else
        {
            [attributes setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
        }
    }
    
    return [[NSMutableAttributedString alloc] initWithString:title attributes:attributes];
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
