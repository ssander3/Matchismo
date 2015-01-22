//
//  SetCard.h
//  Matchismo
//
//  Created by Scott Sanders on 12/28/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (nonatomic) NSUInteger number;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *shade;
@property (strong, nonatomic) NSString *color;

+ (NSArray *)validSymbols;
+ (NSArray *)validShades;
+ (NSArray *)validColors;
+ (NSUInteger)maxNumber;

@end
