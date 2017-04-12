//
//  ViewController.m
//  UICollectionViewTest
//
//  Created by alpha on 2017/4/11.
//  Copyright © 2017年 alpha. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *uicollectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.uicollectionView.delegate = self;
    self.uicollectionView.dataSource = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  @brief 取模之后再分配多余的像素，去除平分cell的缝隙.
 *
 *  @param displayWidth  显示的宽度范围（一般是屏幕宽度）
 *  @param col 显示的列数
 *  @param space 列间隔宽度（可以在这里设置，也可以在collection的回调函数中设置）
 *  @param indexPath cell的indexPath
 *
 *  @return 本cell的size
 *
 *  iPhone 6的屏幕是 750.
 *  col = 4，space = 0；
 *  750 % 4 = 2；
 *  (750 - 2) = 187;
 *  每一行的结果
 *  [188,188,187,187];
 *
 */
- (CGSize)fixSizeBydisplayWidth:(float)displayWidth col:(int)col space:(int)space sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float pxWidth = displayWidth * [UIScreen mainScreen].scale;
    pxWidth = pxWidth - space * (col - 1);
    int mo = (int)pxWidth % col;
    if (mo != 0) {
        // 屏幕宽度不可以平均分配
        float fixPxWidth = pxWidth - mo;
        float itemWidth = fixPxWidth / col;
        // 高度取最高的，所以要加1
        float itemHeight = itemWidth + 1.0;
        if (indexPath.row % col < mo) {
            // 模再分配给左边的cell，直到分配完为止
            itemWidth = itemWidth + 1.0;
        }
        NSNumber *numW = @(itemWidth / [UIScreen mainScreen].scale);
        NSNumber *numH = @(itemHeight / [UIScreen mainScreen].scale);
        return CGSizeMake(numW.floatValue, numH.floatValue);
    }else {
        // 屏幕可以平均分配
        float itemWidth = pxWidth / col;
        return CGSizeMake(itemWidth / [UIScreen mainScreen].scale, itemWidth / [UIScreen mainScreen].scale);
    }
}


#pragma mark collection delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1000;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"testCell" forIndexPath:indexPath];
    NSArray *arr = @[[UIColor redColor],[UIColor blueColor],[UIColor greenColor],[UIColor orangeColor],[UIColor purpleColor]];
    [cell setBackgroundColor:arr[random() % 5]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self fixSizeBydisplayWidth:[UIScreen mainScreen].bounds.size.width col:11 space:0 sizeForItemAtIndexPath:indexPath];
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

@end
