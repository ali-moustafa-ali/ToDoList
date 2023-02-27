//
//  Task.m
//  ToDoList
//
//  Created by Ali Moustafa on 17/01/2023.
//

#import "Task.h"

@implementation Task

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_taskName forKey:@"taskName"];
    [coder encodeObject:_taskDescription forKey:@"taskDescription"];
    [coder encodeObject:_dateOfCreation forKey:@"dateOfCreation"];
    [coder encodeInt:_taskPriority forKey:@"taskPriorit"];
    [coder encodeInt:_taskState forKey:@"taskState"];
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    _taskName=[coder decodeObjectForKey:@"taskName"];
    _taskDescription=[coder decodeObjectForKey:@"taskDescription"];
    _dateOfCreation=[coder decodeObjectForKey:@"dateOfCreation"];
    _taskPriority=[coder decodeIntegerForKey:@"taskPriorit"];
    _taskState=[coder decodeIntegerForKey:@"taskState"];
    return self;
}

@end


