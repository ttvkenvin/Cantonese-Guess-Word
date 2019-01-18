//
//  GHWalkThroughCell.h
//  GHWalkThrough
//
//  Created by Tapasya on 21/01/14.
//  Copyright (c) 2014 Tapasya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TastingController.h"



@protocol TranceViewControllerDelegate;

@interface GDWalkThrgPageCell : UICollectionViewCell


@property (nonatomic, strong) UIImage *imgTitle;
@property (nonatomic, assign) CGFloat imgPositedY;
@property (nonatomic, strong) NSString *tilStr;
@property (nonatomic, strong) UIFont *tileFt;
@property (nonatomic, strong) UIColor *titlClur;
@property (nonatomic, assign) CGFloat titlPositnY;
@property (nonatomic, strong) NSString *descrity;
@property (nonatomic, strong) UIFont *desoryFont;
@property (nonatomic, strong) UIColor *desClur;
@property (nonatomic, assign) CGFloat desPositnY;


@property (nonatomic,assign)NSInteger butnTag;
-(void)buildorenBttn;


@end
