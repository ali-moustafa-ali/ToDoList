//
//  AddViewController.m
//  ToDoList
//
//  Created by Ali Moustafa on 17/01/2023.
//

#import "AddViewController.h"
#import "Task.h"
@interface AddViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextView *des;
@property (weak, nonatomic) IBOutlet UIDatePicker *data;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priority;
@property (weak, nonatomic) IBOutlet UISegmentedControl *state;


@end

@implementation AddViewController

{
    Task *task;
    NSMutableArray *arrOFtask;
    NSUserDefaults *def;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    def =[NSUserDefaults standardUserDefaults];
    task = [Task new];
    arrOFtask=[[self loadTasks:@"task"]mutableCopy];
}

- (IBAction)Add:(id)sender
{
    //make Alert
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add task" message:@"do you want add?" preferredStyle:UIAlertControllerStyleAlert];
    
    
    //Creat buttons
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action)
                         {
        
        //code
    
    task.taskName = _name.text;
    task.taskDescription = _des.text;
    task.taskPriority = _priority.selectedSegmentIndex;
    task.dateOfCreation = _data.date;
    [arrOFtask addObject:task];
    [self saveTasks:@"task" withArray:arrOFtask];
    [self.navigationController popViewControllerAnimated:YES];
        
        
    }];
    
    
   
    
    
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:nil];
    
    //add buttons
    [alert addAction:ok];
    [alert addAction:no];
    
    //show alert
    [self presentViewController:alert animated:YES completion:nil];
    
    
}



-(void)saveTasks:(NSString *)keyName withArray:(NSMutableArray *)myArray
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:myArray];
    [def setObject:data forKey:keyName];
    [def synchronize];
}

-(NSArray *)loadTasks:(NSString*)keyName
{
    NSData *data = [def objectForKey:keyName];
    NSArray *myArray = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    return myArray;
}



@end
