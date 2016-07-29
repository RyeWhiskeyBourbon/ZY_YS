//
//  RWLoginTableViewCell.m
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/6.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWLoginTableViewCell.h"

@interface RWTextFiledCell ()

<
    UITextFieldDelegate
>

@property (nonatomic,strong)UIView *backView;

@property (nonatomic,strong)UIImageView *header;

@end

@implementation RWTextFiledCell

@synthesize textFiled;
@synthesize backView;
@synthesize header;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
       
        [self initViews];
        
    }
    
    return self;
}

- (void)initViews
{
    backView = [[UIView alloc]init];
    
    backView.backgroundColor = [UIColor lightGrayColor];
    
    [self addSubview:backView];
    
    header = [[UIImageView alloc]init];
    
    [backView addSubview:header];
    
    textFiled = [[UITextField alloc]init];
    
    textFiled.backgroundColor=[UIColor clearColor];
    
    textFiled.textColor = [UIColor whiteColor];
    
    textFiled.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    
    textFiled.delegate = self;
    
    backView.backgroundColor=[UIColor colorWithWhite:0.f alpha:0.2];
    
    [backView addSubview:textFiled];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.delegate textFiledCell:self DidBeginEditing:_placeholder];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];
    
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(backView.mas_left).offset(20);
        make.centerY.equalTo(self.mas_centerY).offset(0);
        make.width.equalTo([NSNumber numberWithFloat:frame.size.height - 20]);
        make.height.equalTo([NSNumber numberWithFloat:frame.size.height - 20]);
    }];
    
    [textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(header.mas_right).offset(10);
        make.right.equalTo(backView.mas_right).offset(0);
        make.top.equalTo(backView.mas_top).offset(15);
        make.bottom.equalTo(backView.mas_bottom).offset(-15);
    }];
}

- (void)setHeaderImage:(UIImage *)headerImage
{
    _headerImage = headerImage;
    
    header.image = _headerImage;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    textFiled.placeholder = _placeholder;
}

@end


@implementation RWButtonCell

@synthesize button;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        button = [[UIButton alloc]init];
        
        button.backgroundColor = MAIN_COLOR;
        
        button.layer.cornerRadius = 10;
        
        button.clipsToBounds = YES;
        
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self addSubview:button];
        
        [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];

    }
    
    return self;
}

- (void)btnClick
{
    [self.delegate button:button ClickWithTitle:_title];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    [button setTitle:_title forState:UIControlStateNormal];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(40);
        make.right.equalTo(self.mas_right).offset(-40);
        make.top.equalTo(self.mas_top).offset(5);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
    
    
}

@end

@interface RWTextViewCell ()

<
    UITextViewDelegate
>

@property (nonatomic,strong)UILabel *placeholder;

@property (nonatomic,strong)UILabel *residueChar;

@property (nonatomic,strong)NSMutableString *input;

@end

@implementation RWTextViewCell

@synthesize placeholder;
@synthesize inputTextView;
@synthesize residueChar;
@synthesize input;

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.length == 0)
    {
        [input appendString:text];
    }
    else
    {
        [input deleteCharactersInRange:
                            NSMakeRange(input.length - range.length, range.length)];
    }
    
    residueChar.text = [NSString stringWithFormat:
                                            @"还可输入%d字",(int)(140 - input.length)];
    
    if (input.length == 0)
    {
        [self addSubview:placeholder];
        
        [placeholder mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(22.5);
            make.top.equalTo(self.mas_top).offset(22);
            make.width.equalTo(@(placeholder.frame.size.width));
            make.height.equalTo(@(placeholder.frame.size.height));
        }];
    }
    else if (placeholder.superview)
    {
        [placeholder removeFromSuperview];
    }
    
    return YES;
}

- (void)setPlaceholderText:(NSString *)placeholderText
{
    _placeholderText = placeholderText;
    
    placeholder.text = _placeholderText;
    
    [placeholder sizeToFit];
    
    [placeholder mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(22.5);
        make.top.equalTo(self.mas_top).offset(22);
        make.width.equalTo(@(placeholder.frame.size.width));
        make.height.equalTo(@(placeholder.frame.size.height));
    }];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        input = [[NSMutableString alloc]init];
        
        placeholder = [[UILabel alloc]init];
        placeholder.textColor = Wonderful_GrayColor5;
        placeholder.font = [UIFont systemFontOfSize:17];
        placeholder.numberOfLines = 0;
        
        [self addSubview:placeholder];
        
        residueChar = [[UILabel alloc]init];
        residueChar.text = @"还可输入140字";
        residueChar.textColor = Wonderful_GrayColor5;
        residueChar.font = [UIFont systemFontOfSize:12];
        
        [self addSubview:residueChar];
        
        inputTextView = [[UITextView alloc] init];
        inputTextView.backgroundColor = [UIColor clearColor];
        inputTextView.font = [UIFont systemFontOfSize:17];
        
        inputTextView.delegate = self;
        
        [self addSubview:inputTextView];
    }
    
    return self;
}


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [residueChar mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(@(100));
        make.height.equalTo(@(30));
        make.bottom.equalTo(self.mas_bottom).offset(-15);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    
    [inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.mas_top).offset(15);
        make.bottom.equalTo(residueChar.mas_top).offset(0);
    }];
}
@end
@implementation RwLoginButtonsCell

@synthesize brankgroudView;

@synthesize buttonLogin;

@synthesize registerButton;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        buttonLogin = [[UIButton alloc]init];
        
        buttonLogin.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];

         buttonLogin.clipsToBounds = YES;
        buttonLogin.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [buttonLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self addSubview:buttonLogin];
        
        [buttonLogin addTarget:self action:@selector(btnClickLogin:) forControlEvents:UIControlEventTouchUpInside];

     
        
        
        self.backgroundColor = [UIColor clearColor];
        
        registerButton = [[UIButton alloc]init];
        
        registerButton.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    

        
        registerButton.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self addSubview:registerButton];
        
        [registerButton addTarget:self action:@selector(btnClickRegister) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    
    return self;
}
-(void)btnClickLogin:(UIButton *) button{
    
    
    [self.delegate buttonWithLogin:button];
    
    
    
}
-(void)btnClickRegister{
    
    [self.delegate buttonWithRegister];
}


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [buttonLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(-self.frame.size.width/2-1);
        make.top.equalTo(self.mas_top).offset(7);
        make.bottom.equalTo(self.mas_bottom).offset(-7);
    }];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(buttonLogin.mas_right).offset(1);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self.mas_top).offset(7);
        make.bottom.equalTo(self.mas_bottom).offset(-7);
    }];
}

@end

@interface RWVerificationCodeCell ()

<
    UITextFieldDelegate
>

@property (nonatomic,strong)UIView *backView;

@property (nonatomic,strong)UILabel *text;

@end

@implementation RWVerificationCodeCell

@synthesize textFiled;
@synthesize backView;
@synthesize text;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self initViews];
        
    }
    
    return self;
}

- (void)initViews
{
    backView = [[UIView alloc]init];
    
    backView.backgroundColor = [UIColor lightGrayColor];
    
    [self addSubview:backView];
    
    text = [[UILabel alloc] init];
    text.text = @"验证码：";
    text.textAlignment = NSTextAlignmentCenter;
    text.textColor = [UIColor whiteColor];
    
    [backView addSubview:text];
    
    textFiled = [[UITextField alloc]init];
    
    textFiled.backgroundColor=[UIColor clearColor];
    textFiled.textColor = [UIColor whiteColor];
    textFiled.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    textFiled.delegate = self;
    textFiled.layer.cornerRadius = 5;
    textFiled.clipsToBounds = YES;
    textFiled.textAlignment = NSTextAlignmentCenter;
    
    textFiled.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.7];
    
    backView.backgroundColor= [UIColor colorWithWhite:0.f alpha:0.2];
    
    [backView addSubview:textFiled];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.delegate textFiledCell:nil DidBeginEditing:nil];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];
    
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(backView.mas_right).offset(-180);
        make.centerY.equalTo(self.mas_centerY).offset(0);
        make.width.equalTo(@(80));
        make.height.equalTo([NSNumber numberWithFloat:frame.size.height - 20]);
    }];
    
    [textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(text.mas_right).offset(0);
        make.right.equalTo(backView.mas_right).offset(-100);
        make.top.equalTo(backView.mas_top).offset(10);
        make.bottom.equalTo(backView.mas_bottom).offset(-10);
    }];
}

@end

