//
//  ToDoViewController.m
//  ToDoList
//
//  Created by Ali Moustafa on 17/01/2023.
//

#import "ToDoViewController.h"
#import "Task.h"
#import "AddViewController.h"
#import "DetalesViewController.h"

@interface ToDoViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *search;

@end

@implementation ToDoViewController

{
    NSUserDefaults *def;
    NSMutableArray<Task*> *ArrofTask;
    Task*task;
    NSMutableArray* selectedTask;//search
    BOOL isSelected; //search
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate=self;
   _tableView.dataSource=self;
    task=[Task new];
    isSelected=NO;  //search
    _search.delegate=self;  //search
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    def=[NSUserDefaults standardUserDefaults];
    ArrofTask=[[self loadTasks:@"task"]mutableCopy];
    [_tableView reloadData];
}

//search
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length==0)
    {
        isSelected=NO;
    }
    else
    {
        isSelected=YES;
        selectedTask=[[NSMutableArray alloc]init];
        for (int i=0; i<ArrofTask.count; i++)
        {
            if ([ArrofTask[i].taskName hasPrefix:searchText] || [ArrofTask[i].taskName hasPrefix:[searchText lowercaseString]])
            {
                    [selectedTask addObject:ArrofTask[i]];
            }
        }
    }
    [_tableView reloadData];
}
//search


- (IBAction)add:(id)sender
{
    AddViewController *view=[self.storyboard instantiateViewControllerWithIdentifier:@"AddViewController"];
     [self.navigationController pushViewController:view animated:YES];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @"TASKS";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //search
    
    if (isSelected)
    {
        if ([selectedTask count]!=0)
        {
            _tableView.hidden = false;
        }
        else
        {
            _tableView.hidden = true;
        }
        return selectedTask.count;
    }

    else
    {
        if ([ArrofTask count]!=0)
        {
            _tableView.hidden = false;

        }
        else
        {
            _tableView.hidden = true;

        }
    //search
        return ArrofTask.count;
    //search
    }
    //search
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    //search
    
    if(isSelected)
    {
        cell.textLabel.text=[[selectedTask objectAtIndex:indexPath.row] taskName];
        if([[selectedTask objectAtIndex:indexPath.row] taskPriority]==0)
        {
            cell.imageView.image=[UIImage imageNamed:@"low"];
        }
        else if ([[selectedTask objectAtIndex:indexPath.row] taskPriority]==1)
        {
            cell.imageView.image=[UIImage imageNamed:@"mid"];
        }
        else
        {
            cell.imageView.image=[UIImage imageNamed:@"high"];
        }
    }

    
    //search
        
     
            else

            
    {
        cell.textLabel.text=[[ArrofTask objectAtIndex:indexPath.row] taskName ];
    
        if([[ArrofTask objectAtIndex:indexPath.row] taskPriority]==0)
        {
            cell.imageView.image=[UIImage imageNamed:@"low"];
        }
        else if ([[ArrofTask objectAtIndex:indexPath.row] taskPriority]==1)
        {
            cell.imageView.image=[UIImage imageNamed:@"mid"];
        }
        else //this because but read if doesn't chose
        {
            cell.imageView.image=[UIImage imageNamed:@"high"];
        }
    }
    
   
    return  cell;

}


// heightForRow
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
        [self saveTasks:@"task" withArray:ArrofTask];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetalesViewController *view=[self.storyboard instantiateViewControllerWithIdentifier:@"DetalesViewController"];
    
    view.task=[ArrofTask objectAtIndex:indexPath.row];
//    [view setIndex:indexPath.row];
    view.x=0;
    [self.navigationController pushViewController:view animated:YES];
    
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
