//
//  PentagoBrain.m
//  PentagoStudentVersion
//
//  Created by AAK on 2/17/14.
//  Copyright (c) 2014 Ali Kooshesh. All rights reserved.
//
//  Modified by Joji Kubota & Jeffrey Teller on 9/24/14.
//

#import "PentagoBrain.h"


typedef enum  : NSInteger {player1 = 1, player2 = 2} Player; // To switch between two players.

@interface PentagoBrain() {
    Player player;
    BOOL gameStarted;
    BOOL canPlaceMarble;
    BOOL canRotate;
    Player winner; // Indicate the winner.
}

@property(nonatomic,strong) NSMutableArray *rows;
@property(nonatomic,strong) NSMutableArray *column0;
@property(nonatomic,strong) NSMutableArray *column1;
@property(nonatomic,strong) NSMutableArray *column2;
@property(nonatomic,strong) NSMutableArray *column3;
@property(nonatomic,strong) NSMutableArray *column4;
@property(nonatomic,strong) NSMutableArray *column5;

@property(nonatomic,strong) NSMutableArray *tempRows;
@property(nonatomic,strong) NSMutableArray *tempColumn0;
@property(nonatomic,strong) NSMutableArray *tempColumn1;
@property(nonatomic,strong) NSMutableArray *tempColumn2;

@end

@implementation PentagoBrain


+(PentagoBrain *) sharedInstance
// Creates a shared instance of pBrain
{
    static PentagoBrain *sharedObject = nil;
    
    if( sharedObject == nil )
    {
        sharedObject = [[PentagoBrain alloc] init];
        sharedObject->gameStarted = NO;
    }
    return sharedObject;
}

-(void) startGame
// Starts the game in pBrain by initializing necessary variables.
{
    player = player1;
    gameStarted = YES;
    canPlaceMarble = YES;
    canRotate = NO;
    self.column0 = [[NSMutableArray alloc] initWithObjects:
                    @"0",@"0",@"0",@"0",@"0",@"0", nil];
    self.column1 = [[NSMutableArray alloc] initWithObjects:
                    @"0",@"0",@"0",@"0",@"0",@"0", nil];
    self.column2 = [[NSMutableArray alloc] initWithObjects:
                    @"0",@"0",@"0",@"0",@"0",@"0", nil];
    self.column3 = [[NSMutableArray alloc] initWithObjects:
                    @"0",@"0",@"0",@"0",@"0",@"0", nil];
    self.column4 = [[NSMutableArray alloc] initWithObjects:
                    @"0",@"0",@"0",@"0",@"0",@"0", nil];
    self.column5 = [[NSMutableArray alloc] initWithObjects:
                    @"0",@"0",@"0",@"0",@"0",@"0", nil];
    self.rows = [[NSMutableArray alloc] initWithObjects:
                 _column0,_column1,_column2, _column3,_column4,_column5, nil];

    self.tempColumn0 = [[NSMutableArray alloc] initWithObjects:
                    @"0",@"0",@"0", nil];
    self.tempColumn1 = [[NSMutableArray alloc] initWithObjects:
                    @"0",@"0",@"0", nil];
    self.tempColumn2 = [[NSMutableArray alloc] initWithObjects:
                    @"0",@"0",@"0", nil];
    self.tempRows = [[NSMutableArray alloc] initWithObjects:
                 _tempColumn0,_tempColumn1,_tempColumn2, nil];
    
}

-(int) whoseTurn
// Returns the player whose turn it currently is
{
    return player;
}

-(void) flipPlayerTurn
// Flips the current player turn to opposing player.
{
    if (player == 1)
        player = 2;
    else
        player = 1;
}

-(BOOL) isGameStarted
// Returns the status of the game.
{
        NSLog(@"gameStarted %d", gameStarted);
    return gameStarted;
}

-(BOOL) isLegalMove:(NSInteger)x :(NSInteger)y :(NSInteger)subsquareNumber
// Checks potential move to see if it has been taken already.
{
    // Adjust row and column depending on subSquare.
    if (subsquareNumber == 1)
        x += 3;
    else if (subsquareNumber == 2)
        y += 3;
    else if (subsquareNumber == 3)
    {
        x += 3;
        y += 3;
    }
    // Test the adjusted row and column
    if ( [_rows[x][y]  isEqual: @"0"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void) addMove:(NSInteger)x :(NSInteger)y :(NSInteger)subsquareNumber
// Adds the move to the correct spot in pBrain.
{
    // Adjust row and column depending on subSquare.
    if (subsquareNumber == 1)
        x += 3;
    else if (subsquareNumber == 2)
        y += 3;
    else if (subsquareNumber == 3)
    {
        x += 3;
        y += 3;
    }

    NSString *strPlayer;
    if (player == player1)
        strPlayer = @"1";
    else
        strPlayer = @"2";

    self.rows[x][y] = strPlayer;
}

-(BOOL) findCanPlaceMarbleStatus
// check if the player is allowed to place a marble.
{
    return canPlaceMarble;
}

-(BOOL) isNutural
// Returns YES if any of the 4 sub-boards are neutral.
// A sub-board is neutral if all spaces or all but the middle space are empty.
{
    int count0 = 0;
    // for subboard 0.
    for (int i = 0; i < 3; i++)
        for (int j = 0; j < 3; j++) {
            if (![_rows[j][i] isEqual: @"0"])
                count0++;
        }
    if (![_rows[1][1] isEqual: @"0"])
        count0--; // Ignore if it was the center postion.
    if (count0 == 0) return YES;
    
    int count1 = 0;
    // for subboard 1.
    for (int i = 0; i < 3; i++)
        for (int j = 3; j < 6; j++) {
            if (![_rows[j][i] isEqual: @"0"])
                count1++;
        }
    if (![_rows[4][1] isEqual: @"0"])
        count1--; // Ignore if it was the center postion.
    if (count1 == 0) return YES;

    int count2 = 0;
    // for subboard 2.
    for (int i = 3; i < 6; i++)
        for (int j = 0; j < 3; j++) {
            if (![_rows[j][i] isEqual: @"0"])
                count2++;
        }
    if (![_rows[1][4] isEqual: @"0"])
        count2--; // Ignore if it was the center postion.
    if (count2 == 0) return YES;

    int count3 = 0;
    // for subboard 3.
    for (int i = 3; i < 6; i++)
        for (int j = 3; j < 6; j++) {
            if (![_rows[j][i] isEqual: @"0"])
                count3++;
        }
    if (![_rows[4][4] isEqual: @"0"])
        count3--; // Ignore if it was the center postion.
    if (count3 == 0) return YES;
    
    return NO;
}


-(void) setCanPlaceMarbleStatus: (BOOL) YESorNO;
// Alters whether or not a marble is able to be placed
{
    canPlaceMarble = YESorNO;
}

-(void) setCanRotate: (BOOL) YESorNO;
// Alters whether a player can rotate a sub-board or not.
{
    canRotate = YESorNO;
}


-(BOOL) shouldRotate: (NSInteger) subsquareNumber
// Returns if a specific sub-board is able to be rotated.
// A sub-board is able to be rotated if it is not neutral.
{
    if (gameStarted == NO || canRotate == NO)
        return NO;

    int offsetX = 0;
    int offsetY = 0;
    
    // Adjust x & y depending on the subsquare.
    if (subsquareNumber == 1) {
        offsetX += 3;
    }
    else if (subsquareNumber == 2) {
        offsetY += 3;
    }
    else if (subsquareNumber == 3) {
        offsetX += 3;
        offsetY += 3;
    }
    
    // Count the number of marbles on the subboard.
    int marbCount = 0;
    int i, j, n, m;
    for (i = 0 + offsetY, n = i; i < n + 3; i++)
        for (j = 0 + offsetX, m = j; j < m + 3; j++) {
            NSLog(@"before[%d][%d]=%@", j, i, _rows[j][i]);
            if ( ![_rows[j][i] isEqual: @"0"] ) {
                marbCount++;
            }
        }
    
    // Return NO if sub-board is empty or contains only one marble in the middle space.
    if (marbCount == 0) // No marbles on the subboard.
        return NO;
    else if (marbCount == 1 && ![_rows[offsetX+1][offsetY+1] isEqual: @"0"]) // Marble in the center only.
        return NO;

    return YES;
}

-(void) rightRotation: (NSInteger) subsquareNumber
// Rotates the selected sub-board 90 degrees to the right.
{
    int offsetX = 0;
    int offsetY = 0;
    
    // Adjust depending on the subsquare.
    if (subsquareNumber == 1) {
        offsetX += 3;
    }
    else if (subsquareNumber == 2) {
        offsetY += 3;
    }
    else if (subsquareNumber == 3) {
        offsetX += 3;
        offsetY += 3;
    }
    
    // Save rotated values in the tempArray.
    int i, j, n, m, a, b;
    for (i = 0 + offsetY, n = i, a = 0; i < n + 3; i++, a++)
        for (j = 0 + offsetX, m = j, b = 0; j < m + 3; j++, b++) {
            self.tempRows[2-a][b] = _rows[j][i];
        }
    
    // Copy back the rotated value into the mainArray.
    for (i = 0 + offsetY, n = i, a = 0; i < n + 3; i++, a++)
        for (j = 0 + offsetX, m = j, b = 0; j < m + 3; j++, b++) {
            self.rows[j][i] = _tempRows[b][a];

        }
}

-(void) leftRotation: (NSInteger) subsquareNumber
// Rotates the selected sub-board 90 degrees to the left.
{
    int offsetX = 0;
    int offsetY = 0;
    
    // Adjust depending on the subsquare.
    if (subsquareNumber == 1) {
        offsetX += 3;
    }
    else if (subsquareNumber == 2) {
        offsetY += 3;
    }
    else if (subsquareNumber == 3) {
        offsetX += 3;
        offsetY += 3;
    }
    
    // Save rotated values in the tempArray.
    int i, j, n, m, a, b;
    for (i = 0 + offsetY, n = i, a = 0; i < n + 3; i++, a++)
        for (j = 0 + offsetX, m = j, b = 0; j < m + 3; j++, b++) {
            self.tempRows[a][2-b] = self.rows[j][i];
        }
    
    // Copy back the rotated value into the mainArray.
    for (i = 0 + offsetY, n = i, a = 0; i < n + 3; i++, a++)
        for (j = 0 + offsetX, m = j, b = 0; j < m + 3; j++, b++) {
            self.rows[j][i] = self.tempRows[b][a];
        }
}

-(NSInteger) checkWinner
{
    // check row
    int count1 = 0;
    int count2 = 0;
    for (int i = 0; i < 6; i++)
        for (int j = 0; j < 6; j++) {

            if ([self.rows[j][i] isEqual: @"1"])
                count1++;
            else
                count1 = 0;
            if ([self.rows[j][i] isEqual: @"2"])
                count2++;
            else
                count2 = 0;
            if (count1 == 5) {
                [self gameOver];
                return player1;
            }
            if (count2 == 5) {
                [self gameOver];
                return player2;
                }
            if (j == 5) {
                count1 = 0;
                count2 = 0;
            }
        }

    // check column
    count1 = 0;
    count2 = 0;
    for (int i = 0; i < 6; i++)
        for (int j = 0; j < 6; j++) {
            if ([self.rows[i][j] isEqual: @"1"])
                count1++;
            else
                count1 = 0;
            if ([self.rows[i][j] isEqual: @"2"])
                count2++;
            else
                count2 = 0;
            if (count1 == 5) {
                [self gameOver];
                return player1;
            }
            if (count2 == 5) {
                [self gameOver];
                return player2;
            }
            if (j == 5) {
                count1 = 0;
                count2 = 0;
            }
        }

    // left side left diagonal.
    count1 = 0;
    count2 = 0;
    for (int i = 0; i < 5; i++) {
        if ([self.rows[i][i+1] isEqual: @"1"])
            count1++;
        else
            count1 = 0;
        if ([self.rows[i][i+1] isEqual: @"2"])
            count2++;
        else
            count2 = 0;
        if (count1 == 5) {
            [self gameOver];
            return player1;
        }
        if (count2 == 5) {
            [self gameOver];
            return player2;
        }
    }

    // left diagonal.
    count1 = 0;
    count2 = 0;
    for (int i = 0; i < 6; i++) {
        if ([self.rows[i][i] isEqual: @"1"])
            count1++;
        else
            count1 = 0;
        if ([self.rows[i][i] isEqual: @"2"])
            count2++;
        else
            count2 = 0;
        if (count1 == 5) {
            [self gameOver];
            return player1;
        }
        if (count2 == 5) {
            [self gameOver];
            return player2;
        }
    }

    // right side left diagonal.
    count1 = 0;
    count2 = 0;
    for (int i = 0; i < 5; i++) {
        if ([self.rows[i+1][i] isEqual: @"1"])
            count1++;
        else
            count1 = 0;
        if ([self.rows[i+1][i] isEqual: @"2"])
            count2++;
        else
            count2 = 0;
        if (count1 == 5) {
            [self gameOver];
            return player1;
        }
        if (count2 == 5) {
            [self gameOver];
            return player2;
        }
    }

    // right side right diagonal.
    count1 = 0;
    count2 = 0;
    for (int i = 1; i < 6; i++) {
        if ([self.rows[i][6-i] isEqual: @"1"])
            count1++;
        else
            count1 = 0;
        if ([self.rows[i][6-i] isEqual: @"2"])
            count2++;
        else
            count2 = 0;
        if (count1 == 5) {
            [self gameOver];
            return player1;
        }
        if (count2 == 5) {
            [self gameOver];
            return player2;
        }
    }
    
    // right diagonal.
    count1 = 0;
    count2 = 0;
    for (int i = 0; i < 6; i++) {
        if ([self.rows[i][5-i] isEqual: @"1"])
            count1++;
        else
            count1 = 0;
        if ([self.rows[i][5-i] isEqual: @"2"])
            count2++;
        else
            count2 = 0;
        if (count1 == 5) {
            [self gameOver];
            return player1;
        }
        if (count2 == 5) {
            [self gameOver];
            return player2;
        }
    }
    
    // left side right diagonal.
    count1 = 0;
    count2 = 0;
    for (int i = 0; i < 5; i++) {
        if ([self.rows[i][4-i] isEqual: @"1"])
            count1++;
        else
            count1 = 0;
        if ([self.rows[i][4-i] isEqual: @"2"])
            count2++;
        else
            count2 = 0;
        if (count1 == 5) {
            [self gameOver];
            return player1;
        }
        if (count2 == 5) {
            [self gameOver];
            return player2;
        }
    }
    
    return 0;
}

-(BOOL) checkDraw
{
    int count = 0;
    for (int i = 0; i < 6; i++)
        for (int j = 0; j < 6; j++) {
            if (![self.rows[j][i] isEqual: @"0"])
                  count++;
        }
    NSLog(@"count is %d", count);
    if (count == 36) {
        [self gameOver];
        return YES;
    }
    return NO;
}

-(void) gameOver
{
    gameStarted = NO;
    canPlaceMarble = NO;
    canRotate = NO;
}


@end
