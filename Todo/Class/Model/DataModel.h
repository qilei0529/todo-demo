//
//  DataModel.h
//  Todo
//

#import <Foundation/Foundation.h>



@interface TaskData : NSObject

@property (strong , nonatomic) NSString * title;

@property (nonatomic) BOOL ok;

@property (strong , nonatomic) NSDate * date;

@end



@interface DataModel : NSObject

@property (strong , nonatomic) NSMutableArray * list;

+(instancetype) create;

+(NSString *)getTimeWithFormat :(NSDate *)time with:(NSString *)format;

-(NSMutableArray *)getList;

-(void)saveData;

-(TaskData *)newTask;

@end
