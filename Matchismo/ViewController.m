//
//  ViewController.m
//  Matchismo
//
//  Created by Melanie Sanders on 10/2/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "ViewController.h"
#import "CardMatchingGame.h"

@interface ViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (weak, nonatomic) IBOutlet UITextField *history;
@property (strong, nonatomic) NSMutableArray *flipHistory;
@end

@implementation ViewController

#pragma mark - properties

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[self createDeck]];
    }
    return _game;
}

- (NSMutableArray *)flipHistory
{
    if (!_flipHistory) {
        _flipHistory = [NSMutableArray array];
    }
    return _flipHistory;
}

- (Deck *)createDeck    // abstract
{
    return nil;
}

#pragma mark - IBActions

- (IBAction)touchCardButton:(UIButton *)sender
{
    NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

- (IBAction)redrawButton:(id)sender {
    // destroy the current game and update the UI
    self.flipHistory = nil;
    self.game = nil;
    [self.historySlider setMaximumValue:self.flipHistory.count];
    [self.historySlider setValue:self.flipHistory.count];
    [self updateUI];
}

- (IBAction)scrubHistory:(UISlider *)sender
{
    NSUInteger historyCount = self.flipHistory.count;
    if (historyCount)
    {
        int indexValue = [self.historySlider value];
        if (indexValue < historyCount) {
            self.history.attributedText = [self.flipHistory objectAtIndex:indexValue];
        }
    }
}

#pragma mark - UI Update

- (void)updateUI
{
    // Update Cards
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    
    // Update Score
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
    
    // Update History text
    NSMutableAttributedString *historyText = [[NSMutableAttributedString alloc] initWithString:@""];
    NSAttributedString *spaceString = [[NSAttributedString alloc] initWithString:@" "];
    
    if ([self.game.lastCardsChosen count]) {
        for (Card *card in self.game.lastCardsChosen) {
            [historyText appendAttributedString:[self attributedContentsOfCard:card]];
            [historyText appendAttributedString:spaceString];
        }
    }
    
    // Build the history string based on the cards and score
    if (self.game.lastScore > 0) {
        [historyText insertAttributedString:[[NSAttributedString alloc] initWithString:@"Matched "] atIndex:0];
        [historyText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"for %ld points!", (long)self.game.lastScore]]];
    }
    else if (self.game.lastScore < 0) {
        [historyText appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"don't match! %ld points!", (long)self.game.lastScore]]];
    }
    self.history.attributedText = historyText;
    
    if (![[historyText string] isEqualToString:@""] && ![[[self.flipHistory lastObject] string]isEqualToString:[historyText string]]) {
        [self.flipHistory addObject:historyText];
        // Update History Slider
        [self.historySlider setMaximumValue:self.flipHistory.count];
        [self.historySlider setValue:self.flipHistory.count];
    }
}

- (NSAttributedString *)titleForCard:(Card *)card
{
    NSAttributedString *title  = [[NSAttributedString alloc] initWithString:card.isChosen ? card.contents : @""];
    return title;
}

- (NSAttributedString *)attributedContentsOfCard:(Card *)card
{
    NSAttributedString *cardContents = [[NSAttributedString alloc] initWithString:card.contents];
    return cardContents;
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}
@end
