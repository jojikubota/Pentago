//
//  PentagoViewController.h
//  PentagoStudentVersion
//
//  Created by AAK on 2/17/14.
//  Copyright (c) 2014 Ali Kooshesh. All rights reserved.
//
//  Modified by Joji Kubota & Jeffrey Teller on 9/24/14.
//

#import <UIKit/UIKit.h>



@interface PentagoViewController : UIViewController

@property(nonatomic, strong) UILabel *iLabel;
-(void) announceWinner: (NSInteger) winner;

@end
