//
//  DataModel.m
//  Todo
//

#import "DataModel.h"
#import "NVDate.h"


@implementation TaskData

@end

@implementation DataModel {
    NSMutableDictionary * _data;
    
    NSString * _path;
}

+(instancetype) create
{
    DataModel * data = [[DataModel alloc] init];
    
    // do something
    return data;
}

-(id)init
{
    self = [super init];
    
    // cache the file path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    _path = [plistPath stringByAppendingPathComponent:@"task.plist"];
    
    NSLog(@"%@" , _path);

    return self;
}

-(void)initPlist
{
    if (_data == nil) {
        _data = [[NSMutableDictionary alloc] initWithContentsOfFile:_path];
//        NSLog(@"%@", _data);
    }
    
    if (_data == nil) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
        _data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        NSLog(@"plist ready %@", plistPath);
    }

}

-(NSMutableArray *)getList
{
    NSMutableArray * array = [NSMutableArray array];
    
    [self initPlist];
    
    NSArray * arr = [NSArray array];
    
    arr = [_data objectForKey:@"Task"];
    
    for (NSDictionary * data in arr) {
        TaskData * item = [[TaskData alloc] init];
        
        item.title = [data objectForKey:@"title"];
        item.ok = [[data objectForKey:@"ok"] boolValue];
        item.date = [data objectForKey:@"date"];
        [array addObject:item];
    }
    
    _list = array;
    
    return array;
}

+(NSString *)getTimeWithFormat :(NSDate *)time with:(NSString *)format
{
    NSString * result = [[[NVDate alloc] initUsingDate:time] stringValueWithFormat:format];
    return result;
}

-(void)saveData
{
    NSLog(@"save ");
    
    NSMutableArray * array = [NSMutableArray array];
    
    
    for (TaskData * task in _list) {
        NSMutableDictionary * item = [NSMutableDictionary dictionary];
        
        [item setObject:task.title forKey:@"title"];
        [item setObject:[NSNumber numberWithBool:task.ok] forKey:@"ok"];
        [item setObject:task.date forKey:@"date"];
        
        [array addObject:item];
    }
    
    //write
    [_data setObject:array forKey:@"Task"];
    
    BOOL flag = [_data writeToFile:_path atomically:YES];
    
    if (flag) {
        NSLog(@" save file ok");
    }
    
    //read for test
//    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:_path];
//    NSLog(@"%@", data);
    
}

-(TaskData *)newTask
{
    TaskData * task = [[TaskData alloc] init];
    
    task.title = @"";
    task.ok = NO;
    
    NSDate * date = [NSDate date];
    task.date = date;
    NSLog(@"date  is %@" , task.date);
    
    return task;
}

@end
