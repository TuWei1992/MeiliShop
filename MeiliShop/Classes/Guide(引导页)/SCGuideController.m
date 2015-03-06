//
//  SCGuideController.m
//  collectionView引导页
//
//  Created by Jason on 14/11/22.
//  Copyright (c) 2014年 Jason’s Application House. All rights reserved.
//

#import "SCGuideController.h"
#import "AppDelegate.h"
#import "MZLoginViewController.h"
#import "SCSaveTool.h"

@interface SCGuideController ()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, strong) NSArray *imageNames;

@end

@implementation SCGuideController

static NSString * const reuseIdentifier = @"GuideCell";

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (instancetype)initWithImageNames:(NSArray *)imageNames {
    if (self = [super init]) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = [UIScreen mainScreen].bounds.size;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self = [self initWithCollectionViewLayout:layout];
        self.view.frame = [UIScreen mainScreen].bounds;
        self.collectionView.pagingEnabled = YES;
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, [UIScreen mainScreen].bounds.size.width);
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.bounces = NO;
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.imageNames = imageNames;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    AppDelegate *appDele = [[UIApplication sharedApplication] delegate];
    MZLoginViewController *loginVc = (MZLoginViewController *)appDele.window.rootViewController;
    if ([loginVc isKindOfClass:[MZLoginViewController class]]) {
        [loginVc.usernameField resignFirstResponder];
        [loginVc.passwordField resignFirstResponder];
    }
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageNames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
    imageView.image = [UIImage imageNamed:self.imageNames[indexPath.row]];
    [cell addSubview:imageView];
    
    return cell;
}


#pragma mark <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == [UIScreen mainScreen].bounds.size.width * _imageNames.count) {
        AppDelegate *appDele = [[UIApplication sharedApplication] delegate];
        appDele.windowGuide = nil;
        MZLoginViewController *loginVc = (MZLoginViewController *)appDele.window.rootViewController;
        if ([loginVc isKindOfClass:[MZLoginViewController class]]) {
            [loginVc chooseLoginType];
        }
    }
}

@end
