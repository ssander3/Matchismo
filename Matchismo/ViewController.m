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
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchMode;
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
        _game.matchMode = self.matchMode.selectedSegmentIndex+1;
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
    self.game.matchMode = self.matchMode.selectedSegmentIndex+1;
    [self updateUI];
}

- (IBAction)changeMatchMode:(UISegmentedControl *)sender
{
    self.game.matchMode = sender.selectedSegmentIndex+1;
}

- (IBAction)scrubHistory:(UISlider *)sender
{
    NSUInteger historyCount = self.flipHistory.count;
    if (historyCount)
    {
        int indexValue = [self.historySlider value];
        if (indexValue < historyCount) {
            self.history.text = [self.flipHistory objectAtIndex:indexValue];
        }
    }
}

#pragma mark - UI Update

- (void)updateUI
{
    // Update Match Mode
    self.matchMode.enabled = !self.game.isInGame;
    
    // Update Cards
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setTitleColor:[self colorForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    
    // Update Score
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
    
    // Update History text
    NSString *historyText = @"";
    
    if ([self.game.lastCardsChosen count]) {
        NSMutableArray *cardContents = [NSMutableArray array];
        for (Card *card in self.game.lastCardsChosen) {
            [cardContents addObject:card.contents];
        }
        historyText = [cardContents componentsJoinedByString:@" "];
    }
    
    // Build the history string based on the cards and score
    if (self.game.lastScore > 0) {
        historyText = [NSString stringWithFormat:@"Matched %@ for %ld points!", historyText, (long)self.game.lastScore];
    }
    else if (self.game.lastScore < 0) {
        historyText = [NSString stringWithFormat:@"%@ don't match! %ld point penalty", historyText, (long)self.game.lastScore];
    }
    self.history.text = historyText;
    
    if (![historyText isEqualToString:@""] && ![[self.flipHistory lastObject] isEqualToString:historyText]) {
        [self.flipHistory addObject:historyText];
        // Update History Slider
        [self.historySlider setMaximumValue:self.flipHistory.count];
        [self.historySlider setValue:self.flipHistory.count];
    }
}

- (NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

- (UIColor *)colorForCard:(Card *)card // If you need custom colors override this function
{
    // Set the color to black
    return [UIColor colorWithWhite:0.0f alpha:1];
}
@end
