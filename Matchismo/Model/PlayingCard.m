//
//  PlayingCard.m
//  Matchismo
//
//  Created by Melanie Sanders on 10/2/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

static const int RANK_SCORE = 4;
static const int SUIT_SCORE = 1;
static const int ALL_MATCH_BONUS = 2;

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    int matchCount = 0;
    
    //Create mutable copy of otherCards
    NSMutableArray *matchCards = [[NSMutableArray alloc] initWithArray:otherCards];
    
    [matchCards addObject:self];
    
    while ([matchCards count]) {
        id card = [matchCards firstObject];
        // Is this really a PlayingCard
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *) card;
            // Remove the card from the array
            [matchCards removeObject:card];
            
            // For each of the remaining card, score it
            for (id nextCard in matchCards) {
                // Is this really a PlayingCard
                if ([nextCard isKindOfClass:[PlayingCard class]]) {
                    PlayingCard *nextPlayingCard = (PlayingCard *) nextCard;
                    
                    // Now score these two cards
                    if (playingCard.rank == nextPlayingCard.rank) {
                        score += RANK_SCORE;
                        matchCount++;
                    } else if ([playingCard.suit isEqualToString:nextPlayingCard.suit]) {
                        score += SUIT_SCORE;
                        matchCount++;
                    }
                }
            }
        }
    }
    
    // If all cards matched
    if (matchCount == [otherCards count])
    {
        score *= ALL_MATCH_BONUS;
    }
    
    return score;
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;   // because we provide setter and getter

+ (NSArray *)validSuits
{
    return @[@"♥",@"♠",@"♦",@"♣"];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit])
    {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank { return [[self rankStrings] count]-1; }

-(void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
