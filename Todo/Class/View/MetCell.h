//
//  MetCell.h
//  Todo
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@protocol MetCellDelegate;

@interface MetCell : UITableViewCell<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField  * title;
@property (strong, nonatomic) IBOutlet UILabel      * date;
@property (strong, nonatomic) IBOutlet UIButton     * check;

@property (nonatomic) BOOL ok;

@property (strong, nonatomic) TaskData * data;

@property (strong, nonatomic) id<MetCellDelegate> delegate;

- (IBAction)onCheck:(UIButton *)sender;

@end

@protocol MetCellDelegate

-(void)cellCheck:(MetCell *)cell;

-(void)cellEditing:(MetCell *)cell;
-(void)cellChange:(MetCell *)cell;

@end