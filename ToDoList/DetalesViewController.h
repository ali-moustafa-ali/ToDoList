//
//  DetalesViewController.h
//  ToDoList
//
//  Created by Ali Moustafa on 17/01/2023.
//

#import <UIKit/UIKit.h>
#import "Task.h"
NS_ASSUME_NONNULL_BEGIN

@interface DetalesViewController : UIViewController
@property Task* task;
@property int index;
@property int x;

@end

NS_ASSUME_NONNULL_END
