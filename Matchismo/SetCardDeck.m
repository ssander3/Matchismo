//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Scott Sanders on 1/1/15.
//  Copyright (c) 2015 CS193p. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (instancetype) init
{
    self = [super init];
    for (NSString *color in [SetCard validColors]) {
        for (NSString *shade in [SetCard validShades]) {
            for (NSString *symbol in [SetCard validSymbols]) {
                for (NSUInteger number = 1; number <= [SetCard maxNumber]; number++) {
                    SetCard *card = [[SetCard alloc] init];
                    card.color = color;
                    card.shade = shade;
                    card.symbol = symbol;
                    card.number = number;
                    [self addCard:card atTop:YES];
                }
            }
        }
    }
    
    return self;
}
@end
