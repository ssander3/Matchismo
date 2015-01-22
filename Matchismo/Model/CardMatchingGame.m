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
@property (nonatomic, readwrite) NSArray *lastCardsChosen;
@property (nonatomic, readwrite) NSInteger lastScore;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSInteger)matchMode
{
    Card *card = [self.cards firstObject];
    if (_matchMode < card.numberOfMatchingCards) {
        _matchMode = card.numberOfMatchingCards;
    }
    return _matchMode;
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
    
    // Game has started
    self.inGame = true;
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        } else {
            // Find other choosen cards
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched)
                {
                    [chosenCards addObject:otherCard];
                }
            }
            // Update last score and chosen cards
            self.lastScore = 0;
            self.lastCardsChosen = [chosenCards arrayByAddingObject:card];
            // Do we have enough cards to try to match?
            if (chosenCards.count + 1 == self.matchMode) {
                int matchScore = [card match:chosenCards];
                if (matchScore) {
                    // Match found, score and take all cards out of play
                    self.lastScore = matchScore * MATCH_BONUS;
                    for (Card *matchedCard in chosenCards) {
                        matchedCard.matched = YES;
                    }
                    card.matched = YES;
                } else {
                    // No match, score penalty and unchoose cards
                    self.lastScore = -MISMATCH_PENALTY;
                    for (Card *unmatchedCard in chosenCards) {
                        unmatchedCard.chosen = NO;
                    }
                }
            }
            self.score += self.lastScore - COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}

@end
