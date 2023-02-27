//
//  DoneViewController.m
//  ToDoList
//
//  Created by Ali Moustafa on 17/01/2023.
//

#import "DoneViewController.h"
#import "Task.h"
#import "DetalesViewController.h"

@interface DoneViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DoneViewController

{
    NSUserDefaults *def;
    NSMutableArray<Task*> *ArrofTask;
    Task*task;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    task=[Task new];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    def = [NSUserDefaults standardUserDefaults];
    ArrofTask = [[self loadTasks:@"done"]mutableCopy];
    [_tableView reloadData];
}

//cell data and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"TASKS";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return ArrofTask.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

        cell.textLabel.text=[[ArrofTask objectAtIndex:indexPath.row] taskName ];
        if([[ArrofTask objectAtIndex:indexPath.row] taskPriority]==0){
            cell.imageView.image=[UIImage imageNamed:@"low"];
        }else if ([[ArrofTask objectAtIndex:indexPath.row] taskPriority]==1){
            cell.imageView.image=[UIImage imageNamed:@"mid"];
        }else{
            cell.imageView.image=[UIImage imageNamed:@"high"];
        }
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //make Alert
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"delete task" message:@"do you want delete?" preferredStyle:UIAlertControllerStyleAlert];
    
    
    //Creat buttons
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action)
                         {
        
        //code
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [ArrofTask removeObjectAtIndex:indexPath.row];
        [_tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        def=[NSUserDefaults standardUserDefaults];
        [self saveTasks:@"done" withArray: ArrofTask];
        [_tableView reloadData];
    }
        
        
        //
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
        NSArray *myArray = [[NSKeyedUnarchiver unarchiveObjectWithData:data]mutableCopy];
        return myArray;
    }

@end
