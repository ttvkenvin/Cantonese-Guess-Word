//
//  CFSidorBarController.h
//  CDSideBar
//
//  Created by Christophe Dellac on 9/11/14.
//  Copyright (c) 2014 Christophe Dellac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CFSidorBarControllerDelegate <NSObject>

- (void)menuButtonClicked:(int)index;

@end

@interface CFSidorBarController : NSObject
{
    UIView              *_backgroundMenuView;
    UIButton            *_menuButton;
    NSMutableArray      *_buttonList;
     NSArray *activity;
}


@property (nonatomic, retain) UIColor *menuColor;
@property (nonatomic) BOOL isOpen;

@property (nonatomic, retain) id<CFSidorBarControllerDelegate> delegate;

- (CFSidorBarController*)initWithImages:(NSArray*)buttonList;
- (void)insertMenuButtonOnView:(UIView*)view atPosition:(CGPoint)position;
-(void)changetheimage;
-(void)remove;

@end
