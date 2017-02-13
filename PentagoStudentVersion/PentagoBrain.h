//
//  PentagoBrain.h
//  PentagoStudentVersion
//
//  Created by AAK on 2/17/14.
//  Copyright (c) 2014 Ali Kooshesh. All rights reserved.
//
//  Modified by Joji Kubota & Jeffrey Teller on 9/24/14.
//

#import <Foundation/Foundation.h>

@interface PentagoBrain : NSObject

+(PentagoBrain *) sharedInstance;
-(void) startGame;
-(int) whoseTurn;
-(void) flipPlayerTurn;
-(BOOL) isGameStarted;
-(BOOL) isLegalMove:(NSInteger) row :(NSInteger) column :(NSInteger) subsquareNumber;
-(void) addMove:(NSInteger) row :(NSInteger) column :(NSInteger) subsquareNumber;
-(BOOL) shouldRotate: (NSInteger) subsquareNumber;
-(void) rightRotation: (NSInteger) subsquareNumber;
-(void) leftRotation: (NSInteger) subsquareNumber;
-(BOOL) isNutural;
-(BOOL) findCanPlaceMarbleStatus;
-(void) setCanPlaceMarbleStatus: (BOOL) YESorNO;
-(void) setCanRotate: (BOOL) YESorNO;
-(NSInteger) checkWinner;
-(BOOL) checkDraw;
-(void) gameOver;

@end
