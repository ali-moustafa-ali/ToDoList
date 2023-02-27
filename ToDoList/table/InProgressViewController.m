//
//  InProgressViewController.m
//  ToDoList
//
//  Created by Ali Moustafa on 17/01/2023.
//

#import "InProgressViewController.h"
#import "Task.h"
#import "DetalesViewController.h"
#import "AddViewController.h"

@interface InProgressViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentOfPriority;

@end

@implementation InProgressViewController

{
    NSUserDefaults *def;
    NSMutableArray<Task*> *ArrofTask; //inProgress
    
    
    
    Task*task;
    NSMutableArray* doneArray; // done
    
    
}
static NSMutableArray *lowPriorityArr; //lowPriorityArr
static NSMutableArray *medPriorityArr; //medPriorityArr
static NSMutableArray *highPriorityArr; //highPriorityArr

+ (void)initialize
{
    lowPriorityArr = [NSMutableArray new];
    medPriorityArr  = [NSMutableArray new];
    highPriorityArr  = [NSMutableArray new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    task=[Task new];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    def=[NSUserDefaults standardUserDefaults];
    ArrofTask=[[self loadTasks:@"inProgress"]mutableCopy];
    doneArray=[[self loadTasks:@"done"]mutableCopy];
    
    [lowPriorityArr removeAllObjects];
    [medPriorityArr removeAllObjects];
    [highPriorityArr removeAllObjects];
    
    for(int i=0;i<[ArrofTask count];i++)
    {
        if ([[ArrofTask objectAtIndex:i] taskPriority]==0)
        {
            [lowPriorityArr addObject:[ArrofTask objectAtIndex:i]];
            
        }
        if([[ArrofTask objectAtIndex:i] taskPriority]==1)
        {
            [medPriorityArr addObject:[ArrofTask objectAtIndex:i]];
        }
        
        if([[ArrofTask objectAtIndex:i] taskPriority]==2)
        {
            [highPriorityArr addObject:[ArrofTask objectAtIndex:i]];
        }
    }
    [_tableView reloadData];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *nameOfSection;
    switch (section)
    {
        case 0:
            nameOfSection = @"low";
            break;
            
        case 1:
            nameOfSection = @"med";

            break;
            
            
        case 2:
            nameOfSection = @"high";

            break;
    }
    
    return nameOfSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 0;
    
    switch (section)
    {
        case 0:
            num = [lowPriorityArr count];
            break;
            
        case 1:
            num = [medPriorityArr count];
            break;
            
        case 2:
            num = [highPriorityArr count];
            break;
            
    }
    
    return  num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    switch (indexPath.section)
    {
        case 0:
            cell.textLabel.text=[[lowPriorityArr objectAtIndex:indexPath.row] taskName ];
            if([[lowPriorityArr objectAtIndex:indexPath.row] taskPriority]==0)
            {
                cell.imageView.image=[UIImage imageNamed:@"low"];
            }
            break;
            
        case 1:
            cell.textLabel.text=[[medPriorityArr objectAtIndex:indexPath.row] taskName ];
            if([[medPriorityArr objectAtIndex:indexPath.row] taskPriority]==1)
            {
                cell.imageView.image=[UIImage imageNamed:@"mid"];
            }
            break;
            
        case 2:
            cell.textLabel.text=[[highPriorityArr objectAtIndex:indexPath.row] taskName ];
            if([[highPriorityArr objectAtIndex:indexPath.row] taskPriority]==2)
            {
                cell.imageView.image=[UIImage imageNamed:@"high"];
            }
            break;
    }
    
    return  cell;
    
}

//old
//did Select RowA
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetalesViewController *view=[self.storyboard instantiateViewControllerWithIdentifier:@"DetalesViewController"];
    //    view.task=[ArrofTask objectAtIndex:indexPath.row];
//    [view setIndex:indexPath.row];
    
    switch (indexPath.section)
    {
        case 0:
            view.task=[lowPriorityArr objectAtIndex:indexPath.row];
            break;
            
        case 1:
            view.task=[medPriorityArr objectAtIndex:indexPath.row];
            break;
            
        case 2:
            view.task=[highPriorityArr objectAtIndex:indexPath.row];
            break;
    }
    
    view.x=1;
    [self.navigationController pushViewController:view animated:YES];
}

//height For Row
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

//delete
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    //make Alert
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"delete task" message:@"do you want delete?" preferredStyle:UIAlertControllerStyleAlert];
    
    
    //Creat buttons
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action)
                         {
        
        //        //code
        
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            
            switch (indexPath.section)
            {
                case 0:
                    [lowPriorityArr removeObjectAtIndex:indexPath.row];
                    
                    break;
                    
                case 1:
                    
                    [medPriorityArr removeObjectAtIndex:indexPath.row];
                    
                    
                    break;
                    
                case 2:
                    [highPriorityArr removeObjectAtIndex:indexPath.row];
                    break;
                    
            }
            
            [ArrofTask removeAllObjects];
            [ArrofTask addObjectsFromArray:lowPriorityArr];
            [ArrofTask addObjectsFromArray:medPriorityArr];
            [ArrofTask addObjectsFromArray:highPriorityArr];
            
            [_tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            def=[NSUserDefaults standardUserDefaults];
            [self saveTasks:@"inProgress" withArray:ArrofTask];
            
            
            [_tableView reloadData];
        }
        
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


- (IBAction)segmentedChanged:(id)sender
{
    
    switch(self.segmentOfPriority.selectedSegmentIndex)
    {
            
            
        case 0:
            [lowPriorityArr removeAllObjects];
            [medPriorityArr removeAllObjects];
            [highPriorityArr removeAllObjects];
            for(int i=0;i<[ArrofTask count];i++){
                if ([[ArrofTask objectAtIndex:i] taskPriority]==0)
                {
                    [lowPriorityArr addObject:[ArrofTask objectAtIndex:i]];
                }
            }
            [_tableView reloadData];
            break;
            
            
        case 1:
            [lowPriorityArr removeAllObjects];
            [medPriorityArr removeAllObjects];
            [highPriorityArr removeAllObjects];
            
            for(int i=0;i<[ArrofTask count];i++)
            {
                if ([[ArrofTask objectAtIndex:i] taskPriority]==1)
                {
                    [medPriorityArr addObject:[ArrofTask objectAtIndex:i]];
                }
            }
            [_tableView reloadData];
            break;
            
        case 2:
            [lowPriorityArr removeAllObjects];
            [medPriorityArr removeAllObjects];
            [highPriorityArr removeAllObjects];
            for(int i=0;i<[ArrofTask count];i++){
                if ([[ArrofTask objectAtIndex:i] taskPriority]==2)
                {
                    [highPriorityArr addObject:[ArrofTask objectAtIndex:i]];
                }
            }
            [_tableView reloadData];
            break;
            
            
    }
}
@end
