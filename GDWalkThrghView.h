//
//  GDWalkThrghView.h
//  GHWalkThrough
//
//  Created by Tapasya on 21/01/14.
//  Copyright (c) 2014 Tapasya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDWalkThrgPageCell.h"

typedef NS_ENUM(NSInteger, GDWalkThrghViewDirection) {
    GDWalkThrghViewDirectionVertical,
    GDWalkThrghViewDirectionHorizontal
};

@protocol GDWalkThrghViewDelegate;
@protocol GDWalkThrghViewDataSource;

@interface GDWalkThrghView : UIView

@property (nonatomic, assign) id<GDWalkThrghViewDelegate> delegate;

@property (nonatomic, assign) id<GDWalkThrghViewDataSource> dataSource;

@property (nonatomic, assign) GDWalkThrghViewDirection walkThrghDirection;

@property (nonatomic, strong) UIView* vFltingHeader;

@property (nonatomic, assign) BOOL isfixBackgrnd;

@property (nonatomic, strong) UIImage* brcgImg;

@property (nonatomic, copy) NSString *clsTit;
@property (nonatomic, strong) UICollectionView* cletionView;

- (void) showInfortionView:(UIView*) view animateDuration:(CGFloat) duration;
-(void)settoryupdate;

@end

@protocol GDWalkThrghViewDelegate <NSObject>

@optional
- (void)walkingoutThroughDidDismissView:(GDWalkThrghView *)walkthroughView;

@end

@protocol GDWalkThrghViewDataSource <NSObject>

@required

-(NSInteger) numberOfPages;

@optional
//-(UIView*) customViewForPage:(NSInteger) index;
- (UIImage*) backgdImageforPage:(NSInteger) index;
-(void) configrationPage:(GDWalkThrgPageCell*) cell atIndex:(NSInteger) index;

@end
