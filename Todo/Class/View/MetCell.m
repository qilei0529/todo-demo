//
//  MetCell.m
//  Todo
//

#import "MetCell.h"

@implementation MetCell {
    BOOL _key;
    
    BOOL _editing;
}



-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        self.contentView.backgroundColor = RGBA(40, 40, 40, 1);
        _date.textColor = [UIColor whiteColor];
    }else{
        self.contentView.backgroundColor = RGBA(30, 30, 30, 1);
        _date.textColor = RGBA(50, 50, 50, 1);
    }
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
    [super setSelected:selected animated:animated];
    
    BOOL key = selected;
    
    key = _key ? NO : key;
    
    _key = key;
    
    if (key) {
        self.contentView.backgroundColor = RGBA(40, 40, 40, 1);
        _date.textColor = [UIColor whiteColor];
        [self.title setEnabled:YES];
    }else{
        self.contentView.backgroundColor = RGBA(30, 30, 30, 1);
        _date.textColor = RGBA(50, 50, 50, 1);

        [self.title setEnabled:NO];
    }
    
}


#pragma mark event

- (IBAction)onCheck:(UIButton *)sender {
    NSLog(@"select");
    
    BOOL key = !self.check.selected;
    
    self.ok = key;
    
    _data.ok = key;
    
    [self.delegate cellCheck:self];
    
}


#pragma mark set

-(void)setData:(TaskData *)data
{
    _data = data;
    
    NSString * time = [DataModel getTimeWithFormat:_data.date with:@"M-d H:mm"];
    
    self.title.text = _data.title;
    self.date.text = time;
    self.ok = _data.ok;
}



-(void)setOk:(BOOL)ok
{
    self.check.selected = ok;
    _ok = ok;
    
    
}

#pragma mark layout

-(void)layoutSubviews
{
    [super layoutSubviews];
    NSLog(@"layout sub view");
}

-(void)drawRect:(CGRect)rect
{
    
    self.backgroundColor = [UIColor clearColor];
    
    [super drawRect:rect];
    
    _editing = NO;
    _title.delegate = self;
    
    [self addline];
}

-(void)addline
{
    NSLog(@" draw rect");
    
    UIView * line = [[UIView alloc] init];
    
    CGRect rect = self.frame;
    
    rect.origin.x = 0;
    rect.origin.y = rect.size.height - 0.5;
//    rect.origin.y = 0;
    rect.size.height = 0.5;
    
    line.frame = rect;
    line.backgroundColor = RGBA(0, 0, 0, 1);
    
    [self addSubview:line];
    
}

#pragma mark - text Field delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"edit begin");
    [self.delegate cellEditing:self];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    NSString * title = _title.text;
    _data.title = title;
    
    [self.delegate cellChange:self];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"end type 11111");
    [_title resignFirstResponder];
    return YES;
}

@end
