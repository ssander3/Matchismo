//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Melanie Sanders on 10/11/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; // of Card
@property (nonatomic, readwrite) BOOL inGame;
@property (nonatomic, strong) NSMutableArray *history;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *)history
{
    if (!_history) _history = [[NSMutableArray alloc] init];
    
    return _history;
}

-(NSArray *)matchHistory
{
    return self.history;
}

- (instancetype)initWithCardCount:(NSUInteger)count
                       usingDeck:(Deck *)deck
{
    self = [super init]; // super's designated intializer

    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
        // reset inGame (not playing a game)
        self.inGame = false;
    }
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index<[self.cards count]) ? self.cards[index] : nil;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    NSMutableArray *chosenCards = [[NSMutableArray alloc] init];
    BOOL historyAdded = false;
    
    // Game has started
    self.inGame = true;
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
            [self.history addObject:@""];
        } else {
            // match against other choosen cards
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched)
                {
                    [chosenCards addObject:otherCard];
                    if (chosenCards.count == self.matchMode) {
                        int matchScore = [card match:chosenCards];
                        if (matchScore) {
                            self.score += matchScore * MATCH_BONUS;
                            NSMutableString *matchText = [[NSMutableString alloc] initWithFormat:@"Matched %@", card.contents];
                            for (Card *matchedCard in chosenCards) {
                                matchedCard.matched = YES;
                                [matchText appendFormat:@" ,%@", matchedCard.contents];
                            }
                            card.matched = YES;
                            [matchText appendFormat:@" for %d points!", matchScore * MATCH_BONUS];
                            [self.history addObject:matchText];
                            historyAdded = true;
                            
                        } else {
                            self.score -= MISMATCH_PENALTY;
                            NSMutableString *mismatchText = [[NSMutableString alloc] initWithFormat:@"%@", card.contents];
                            for (Card *unmatchedCard in chosenCards) {
                                unmatchedCard.chosen = NO;
                                [mismatchText appendFormat:@" ,%@", unmatchedCard.contents];
                            }
                            [mismatchText appendFormat:@" don't match! %d point penalty!", MISMATCH_PENALTY];
                            [self.history addObject:mismatchText];
                            historyAdded = true;
                        }
                        break;
                    }
                }
            }
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
            
            if (!historyAdded)
            {
                [self.history addObject:[[NSString alloc] initWithFormat:@"%@ selected", card.contents]];
            }
        }
    }
}

@end
