//
//  Task.h
//  ToDoList
//
//  Created by Ali Moustafa on 17/01/2023.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Task : NSObject

@property  NSString *taskName;
@property NSString *taskDescription;
@property  NSDate *dateOfCreation;
@property  int taskPriority;
@property  int taskState;



@end

NS_ASSUME_NONNULL_END





