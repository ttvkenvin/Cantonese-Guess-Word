//
//  TastingController.h
//  cantoneseGame
//
//  Created by dw on 16/1/2.
//  Copyright © 2016年 slippers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFSidorBarController.h"

@interface TastingController : UIViewController<CFSidorBarControllerDelegate>{
    CFSidorBarController *sideBot;
}
@property (nonatomic,assign) int indoxes;

@end
