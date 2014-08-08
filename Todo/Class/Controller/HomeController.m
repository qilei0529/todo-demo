//
//  HomeController.m
//  Todo
//

#import "HomeController.h"

#import "MetCell.h"
#import "DataModel.h"

@interface HomeController ()<UITableViewDataSource, UITableViewDelegate,MetCellDelegate>

@end

@implementation HomeController
{
    DataModel       * _dataModel;
    NSMutableArray  * _list;
    
    IBOutlet UITableView    *_table;
    IBOutlet UIView         *_table_head;
    
    BOOL _editing;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initHead];
    
    [self initHomePrss];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
}

-(void)initHead
{
    _table_head.backgroundColor = [UIColor clearColor];
    _table.backgroundColor   = RGBA(20, 20, 20, 1);
}

-(void)initData
{
    _dataModel = [DataModel create];
    _list = [_dataModel getList];
}

#pragma mark table action

-(void)createTask
{
    if (_editing ) return;
    
    BOOL flag = NO;
    TaskData * task;
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    
    if (_list.count > 0) {
        task = [_list objectAtIndex:0];
        
        if ([task.title length] > 0) flag = YES;
        
    }else{
        flag = YES;
    }
    
    if (flag){
        task = [_dataModel newTask];
        
        [_list insertObject:task atIndex:0];
        [_table insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationBottom];

    }
    
    // key board
    [_table selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
    MetCell * cell = (MetCell *)[_table cellForRowAtIndexPath:path];
    [self performSelector:@selector(createEdit:) withObject:cell afterDelay:0.1];
}


-(void)createEdit:(MetCell *)cell
{
    [cell.title becomeFirstResponder];
    NSLog(@" create edit");
}

#pragma mark table delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _list.count;
}

- (MetCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell prepareForReuse]; // use prepare if nes
    
    TaskData * data = [_list objectAtIndex:indexPath.row];
    cell.data = data;
    
    //for delegate
    cell.delegate = self;
    
    
    NSLog(@"----- %d " , cell.ok);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"----- select %d" , (int)indexPath.row);
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;
    if ([tableView isEqual:_table]) {
        result = UITableViewCellEditingStyleDelete;
    }
    return result;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self cellDelete:indexPath];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

#pragma mark - scroll delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat y = scrollView.contentOffset.y;
//    NSLog(@"scroll %.0f" , y);
    if (y < - 80) {
        
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"end drag scroll");
    CGFloat y = scrollView.contentOffset.y;
    
    if (y < -80) {
        NSLog(@"trigger  create" );
        [self createTask];
    }
    
}


#pragma mark - cell delegate

-(void)cellCheck:(MetCell *)cell
{
    NSLog(@" cell check at %d" , 1 );
    
}

-(void)cellChange:(MetCell *)cell
{
    NSLog(@" cell change at %d" , 1);
    
    _editing = NO;
}

-(void)cellEditing:(MetCell *)cell
{
    _editing = YES;
    
//    CGRect rect = cell.frame;
//    CGFloat y = rect.origin.y - _table.contentOffset.y;
//    NSLog(@" cell edting at %.1f %.1f %.1f" , y, rect.origin.y,  _table.contentOffset.y);
    
}

-(void)cellDelete:(NSIndexPath *)indexPath
{
    [_list removeObjectAtIndex:indexPath.row];
    [_table deleteRowsAtIndexPaths:@[ indexPath ]withRowAnimation:UITableViewRowAnimationFade];
    
}

#pragma mark - home press

-(void)initHomePrss
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
    
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    [_dataModel saveData];
    NSLog(@" background");
}

-(void)didReceiveMemoryWarning
{
    [_dataModel saveData];
    NSLog(@" memory");
}

@end
