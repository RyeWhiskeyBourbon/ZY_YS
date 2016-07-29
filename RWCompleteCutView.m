//
//  RWCompleteCutView.m
//  RWCompleteCutAnimation
//
//  Created by zhongyu on 16/6/21.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWCompleteCutView.h"
#import<Accelerate/Accelerate.h>
#import "UIImageView+WebCache.h"
#import "RWRequsetManager.h"

CGAffineTransform  GetCGAffineTransformRotateAroundPoint(CGFloat centerX, CGFloat centerY,CGFloat x ,CGFloat y ,CGFloat angle)
{
    x = x - centerX;
    y = y - centerY;
    
    CGAffineTransform  trans = CGAffineTransformMakeTranslation(x, y);
    trans = CGAffineTransformRotate(trans,angle);
    trans = CGAffineTransformTranslate(trans,-x, -y);
    
    return trans;
}

@interface RWCardContentView ()

@property (nonatomic,strong)UIImageView *imageView;

@property (nonatomic,strong)UIButton *responseBtn;

@property (nonatomic,strong)UILabel *footerLabel;

@end

@implementation RWCardContentView

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self initViews];
        [self setDefaultValueWithView];
        [self autoLayoutViews];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (_imageView)
    {
        [self autoLayoutViews];
    }
}

- (void)initViews
{
    _imageView = [[UIImageView alloc] init]; [self addSubview:_imageView];
    
    _responseBtn = [[UIButton alloc] init]; [self addSubview:_responseBtn];
    
    _footerLabel = [[UILabel alloc] init]; [self addSubview:_footerLabel];
}

- (void)autoLayoutViews
{
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    
    [_imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];

    [_responseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(@(w * (24.0f / 67.0f)));
        make.height.equalTo(@(h *(7.0f / 122.0f)));
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(-h * (10.0f / 122.0f));
        
    }];
    
    [_footerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.height.equalTo(@(h *(3.0f / 122.0f)));
        make.bottom.equalTo(self.mas_bottom).offset(-h * (4.0f / 122.0f));
    }];
}

- (void)setDefaultValueWithView
{
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = 5;
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowRadius = 20;
    self.layer.shadowOffset = CGSizeMake(0, -5);
    
    CGFloat fontSize = 16;
    
    if ([UIScreen mainScreen].bounds.size.width <= 320)
    {
        fontSize = 13;
    }
    
    _imageView.userInteractionEnabled = YES;
    
    _responseBtn.layer.cornerRadius = 5;
    _responseBtn.clipsToBounds = YES;
    _responseBtn.backgroundColor = [UIColor blackColor];
    
    [_responseBtn setTitle:@"立即播放" forState:UIControlStateNormal];
    [_responseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _responseBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    
    [_responseBtn addTarget:self
                     action:@selector(buttonDidClick)
           forControlEvents:UIControlEventTouchUpInside];
    
    _footerLabel.text = @"ZHONGYU · 中域";
    _footerLabel.textColor = [UIColor darkGrayColor];
    _footerLabel.font = [UIFont fontWithName:@"STXingkai-SC-Bold"size:fontSize - 4];
    _footerLabel.shadowOffset = CGSizeMake(0.5, 0.5);
    _footerLabel.shadowColor = [UIColor goldColor];
    
    _footerLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)buttonDidClick
{
    if (_delegate)
    {
        [_delegate buttonDidClickWithIndexPath:nil];
    }
}

- (void)setContentImage:(NSString *)contentImage
{
    _contentImage = contentImage;
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_contentImage]];
}

- (void)setButtonText:(NSString *)buttonText
{
    _buttonText = buttonText;
    
    [_responseBtn setTitle:_buttonText forState:UIControlStateNormal];
}

- (void)setFooterText:(NSString *)footerText
{
    _footerText = footerText;
    
    _footerLabel.text = _footerText;
}

@end

@interface RWCompleteCutViewCell ()

<
    UIGestureRecognizerDelegate,
    RWCompleteCutViewDelegate
>

@property (nonatomic,strong)UILabel *numberLabel;

@property (nonatomic,strong)UIImageView *background;

@property (nonatomic,assign)CGFloat angles;

@property (nonatomic,assign)CGFloat centerX;

@property (nonatomic,assign)CGFloat centerY;

@property (nonatomic,assign)CGFloat x;

@property (nonatomic,assign)CGFloat y;

@end

@implementation RWCompleteCutViewCell

@synthesize angles,centerX,centerY,x,y;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        if (!_numberLabel)
        {
            [self initViews];
        }
        
        [self autoLayoutViews];
        [self setDefaultValueWithView];
    }
    
    return self;
}

- (void)autoLayoutViews
{
    [_background mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];
    
    CGFloat main_w = self.frame.size.width * (56.0f / 68.0f);
    CGFloat main_h = self.frame.size.height * (82.0f / 113.0f);
    CGFloat main_m = self.frame.size.height * (9.0f / 113.0f);
    
    [_contentViews[RWContentViewOfBottom] mas_remakeConstraints:
     ^(MASConstraintMaker *make){
         
         make.width.equalTo(@(main_w - 20));
         make.height.equalTo(@(main_h - 20));
         make.centerX.equalTo(self.mas_centerX).offset(0);
         make.top.equalTo(self.mas_top).offset(main_m);
     }];
    
    [_contentViews[RWContentViewOfTranslucent] mas_remakeConstraints:
     ^(MASConstraintMaker *make){
         
         make.width.equalTo(@(main_w - 10));
         make.height.equalTo(@(main_h - 10));
         make.centerX.equalTo(self.mas_centerX).offset(0);
         make.top.equalTo(self.mas_top).offset(main_m + 10);
     }];
    
    [_contentViews[RWContentViewOfMain] mas_remakeConstraints:
     ^(MASConstraintMaker *make){
         
         make.width.equalTo(@(main_w));
         make.height.equalTo(@(main_h));
         make.centerX.equalTo(self.mas_centerX).offset(0);
         make.top.equalTo(self.mas_top).offset(main_m + 20);
     }];
    
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo([_contentViews[RWContentViewOfMain] mas_bottom]).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];

}

- (void)initViews
{
    _background = [[UIImageView alloc] init];
    
    [self.contentView addSubview:_background];
    
    _numberLabel = [[UILabel alloc] init];
    
    [self.contentView addSubview:_numberLabel];
    
    NSMutableArray *views = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 3; i ++)
    {
        RWCardContentView *view = [[RWCardContentView alloc] init];
        
        [self.contentView addSubview:view];
        
        view.delegate = self;
        
        [views addObject:view];
    }
    
    _contentViews = views;
}

- (void)buttonDidClickWithIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate)
    {
        [_delegate buttonDidClickWithIndexPath:indexPath];
    }
}

- (void)setDefaultValueWithView
{
    RWCardContentView *bottomView = _contentViews[RWContentViewOfBottom];
    
    bottomView.alpha = 0.5f;
    
    RWCardContentView *translucentView = _contentViews[RWContentViewOfTranslucent];
    
    translucentView.alpha = 0.7f;
    
    RWCardContentView *mainView = _contentViews[RWContentViewOfMain];
    
    mainView.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(revolveViewsWithPanGesture:)];
    
    [mainView addGestureRecognizer:pan];
    
    _numberLabel.textColor = [UIColor lightGrayColor];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.font = [UIFont systemFontOfSize:28];
}

- (void)setNumber:(NSString *)number
{
    _number = number;
    
    _numberLabel.text = _number;
}

- (void)didInThisView
{
    RWCardContentView *translucentView = _contentViews[RWContentViewOfTranslucent];
    
    RWCardContentView *mainView = _contentViews[RWContentViewOfMain];
    
    [UIView animateWithDuration:0.05f animations:^{
        
        CGAffineTransform transform = GetCGAffineTransformRotateAroundPoint(centerX, centerY, x, y, 0.02f);
        
        mainView.transform = transform;
        
    } completion:^(BOOL finished) {
        
        angles = 0;
        
        CGAffineTransform transform = GetCGAffineTransformRotateAroundPoint(centerX, centerY, x, y, angles);
        
        translucentView.transform = transform;
        
        [UIView animateWithDuration:0.2f animations:^{
            
            mainView.transform = transform;
        }];
    }];

}

- (void)revolveViewsWithPanGesture:(UIPanGestureRecognizer *)panGesture
{
    if (!x && !y && !centerX && !centerY)
    {
        centerX = panGesture.view.center.x;
        centerY = panGesture.view.center.y;
        
        x = centerX;
        y = panGesture.view.bounds.size.height * 2;
    }
    
    CGPoint distance = [panGesture translationInView:self];
    
    RWCardContentView *translucentView = _contentViews[RWContentViewOfTranslucent];
    
    translucentView.alpha = 1.0f;
    
    panGesture.view.transform = CGAffineTransformIdentity;
    translucentView.transform = CGAffineTransformIdentity;
    
    if (_contentDatas.count == 1 && distance.x < 0.0f)
    {
        translucentView.alpha = 0.0f;
        return;
    }
    else if (_contentDatas.count == 1 && distance.x > 0.0f)
    {
        CGAffineTransform transform = GetCGAffineTransformRotateAroundPoint(centerX, centerY, x, y, -0.6f);
        
        panGesture.view.transform = transform;
        
        angles = 0;
        
        transform = GetCGAffineTransformRotateAroundPoint(centerX,centerY,x,y,angles);
        
        translucentView.transform = transform;
        
        [UIView animateWithDuration:0.2f animations:^{
            
            panGesture.view.transform = transform;
        }];
        
        self.userInteractionEnabled = NO;
        [_delegate revolveDidChangeViewWithState:RWChangeViewStateToFrontView];
        
        return;
    }
    
    angles += [self revolveAngleWithDistance:distance.x];
    
    CGAffineTransform transform = GetCGAffineTransformRotateAroundPoint(centerX, centerY, x, y, angles);
    
    CGAffineTransform transformLucent = GetCGAffineTransformRotateAroundPoint(centerX, centerY, x, y, angles / 4);
    
    if (angles <= 0)
    {
        panGesture.view.transform = transform;
        
        if (_contentDatas.count == 3)
        {
            translucentView.transform = transformLucent;
        }
    }
    
    [panGesture setTranslation:CGPointMake(0, 0) inView:self];
    
    if (panGesture.state == UIGestureRecognizerStateEnded)
    {
        if (angles < -0.15f)
        {
            __block CGAffineTransform transform = GetCGAffineTransformRotateAroundPoint(centerX, centerY, x, y, -0.5);
            
            [UIView animateWithDuration:0.2f animations:^{
                
                panGesture.view.transform = transform;
                
            } completion:^(BOOL finished) {
                
                self.userInteractionEnabled = NO;
                
                [_delegate revolveDidChangeViewWithState:RWChangeViewStateToNextView];
            }];
        }
        else if (angles > 0.15f)
        {
            if (_indexPath.row == 0)
            {
                return;
            }
            
            CGAffineTransform transform = GetCGAffineTransformRotateAroundPoint(centerX, centerY, x, y, -0.6f);
            
            panGesture.view.transform = transform;
            
            angles = 0;
            
            transform = GetCGAffineTransformRotateAroundPoint(centerX,centerY,x,y,angles);
            
            translucentView.transform = transform;
            
            [UIView animateWithDuration:0.2f animations:^{
                
                panGesture.view.transform = transform;
            }];
            
            self.userInteractionEnabled = NO;
            [_delegate revolveDidChangeViewWithState:RWChangeViewStateToFrontView];
        }
        else
        {
            [UIView animateWithDuration:0.3f animations:^{
                
                angles = 0;
                
                CGAffineTransform transform = GetCGAffineTransformRotateAroundPoint(centerX, centerY, x, y, angles);
                
                panGesture.view.transform = transform;
                translucentView.transform = transform;
                translucentView.alpha = 0.7f;
            }];
        }
    }
}

- (void)setContentDatas:(NSArray *)contentDatas
{
    _contentDatas = contentDatas;
    
    RWCardContentView *translucentView = _contentViews[RWContentViewOfTranslucent];
    RWCardContentView *bottomView = _contentViews[RWContentViewOfBottom];
    
    if (_contentDatas.count == 1)
    {
        translucentView.alpha = 0.0f;
        bottomView.alpha = 0.0f;
    }
    else if (_contentDatas.count == 2)
    {
        bottomView.alpha = 0.0f;
        translucentView.alpha = 0.7f;
    }
    else
    {
        bottomView.alpha = 0.5f;
        translucentView.alpha = 0.7f;
    }

    self.userInteractionEnabled = YES;

    for (int i = 0; i < _contentDatas.count; i++)
    {
        RWCardContentView *cut = _contentViews[_contentViews.count - 1 - i];
        
        cut.contentImage = _contentDatas[i];
    }
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    [manager downloadImageWithURL:_contentDatas[0]
                          options:0
                         progress:nil
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
    {
        if (image)
        {
            _background.image = [self blurryImage:image withBlurLevel:0.999f];
            
            [SVProgressHUD dismiss];
        }
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (!_background.image)
        {
            [SVProgressHUD dismiss];
            
            UIResponder *next = [self nextResponder];
            
            do {
                if ([next isKindOfClass:[UIViewController class]])
                {
                    [RWRequsetManager warningToViewController:(UIViewController *)next Title:@"图片加载失败" Click:nil];
                }
                
                next = [next nextResponder];
            } while (next != nil);
        }
    });
}

- (CGFloat)revolveAngleWithDistance:(CGFloat)distance
{
    CGFloat proportion = 45.0f / ([UIScreen mainScreen].bounds.size.width * 60);
    
    return distance * proportion;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    angles = 0.0f;
    
    return YES;
}

- (UIImage *)addBackgroundImage:(UIImage *)image
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:10.0] forKey:@"inputRadius"];
    
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    UIImage *blurredImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return blurredImage;
}

-(UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur
{
    if (blur < 0.f || blur > 1.f)
    {
        blur = 0.5f;
    }
    
    int boxSize = (int)(blur * 100);
    
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                       &outBuffer,
                                       NULL,
                                       0,
                                       0,
                                       boxSize,
                                       boxSize,
                                       NULL,
                                       kvImageEdgeExtend);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    return returnImage;
}

@end

@interface RWCompleteCutView ()

<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    RWCompleteCutViewDelegate
>

@property (nonatomic,strong)NSArray *viewSource;

@property (nonatomic,strong)NSIndexPath *faceIndexPath;

@end

static NSString *const cutCell = @"cutCell";

@implementation RWCompleteCutView

@synthesize constraint = _constraint;

- (void)setCardSource:(NSArray *)cardSource
{
    _cardSource = cardSource;
    
    NSMutableArray *temps = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _cardSource.count; i++)
    {
        if (i == _cardSource.count - 1)
        {
            [temps addObject:@[_cardSource[i]]];
        }
        else if (i == _cardSource.count - 2)
        {
            [temps addObject:@[_cardSource[i],
                               _cardSource[i + 1]]];
        }
        else
        {
            [temps addObject:@[_cardSource[i],
                               _cardSource[i + 1],
                               _cardSource[i + 2]]];
        }
    }
    
    _viewSource = temps;
    
    [self reloadData];
}

- (instancetype)initWithConstraint:(void(^)(MASConstraintMaker *make))constraint
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    
    self = [super initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
    
    if (self)
    {
        _constraint = constraint;
        
        self.backgroundColor = [UIColor whiteColor];
        self.scrollEnabled = NO;
        self.pagingEnabled = YES;
        self.delegate = self;
        self.dataSource = self;
        
        [self registerClass:[RWCompleteCutViewCell class] forCellWithReuseIdentifier:cutCell];
    }
    
    return self;
}

- (void)setConstraint:(void (^)(MASConstraintMaker *))constraint
{
    _constraint = constraint;
    
    if (self.superview)
    {
        [self mas_remakeConstraints:_constraint];
    }
}

- (void)didMoveToSuperview
{
    [self mas_makeConstraints:_constraint];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _viewSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RWCompleteCutViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cutCell forIndexPath:indexPath];
    
    _faceIndexPath = indexPath;
    
    cell.indexPath = indexPath;
    cell.number = [NSString stringWithFormat:@"%d/%d",(int)indexPath.row+1,
                                                      (int)_viewSource.count];
    cell.contentDatas = _viewSource[indexPath.row];
    cell.delegate = self;
    
    [cell didInThisView];
    
    return cell;
}

- (void)revolveDidChangeViewWithState:(RWChangeViewState)state
{
    if (state == RWChangeViewStateToNextView)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_faceIndexPath.row + 1
                                                     inSection:0];
        
        [self scrollToItemAtIndexPath:indexPath
                     atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                             animated:NO];
    }
    else
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_faceIndexPath.row - 1
                                                     inSection:0];
        
        if (_faceIndexPath.row == 0)
        {
            indexPath = [NSIndexPath indexPathForItem:0
                                            inSection:0];
            
            RWCompleteCutViewCell *cell =
                    (RWCompleteCutViewCell *)[self cellForItemAtIndexPath:indexPath];
            
            cell.userInteractionEnabled = YES;
        }
        
        [self scrollToItemAtIndexPath:indexPath
                     atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                             animated:NO];
    }
}

- (void)buttonDidClickWithIndexPath:(NSIndexPath *)indexPath
{
    if (_eventSource)
    {
        [_eventSource buttonDidClickWithIndexPath:_faceIndexPath];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
}

@end
