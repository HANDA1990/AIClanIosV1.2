//
//  SelectView.m
//  AIClan
//
//  Created by hd on 2019/5/6.
//  Copyright © 2019年 hd. All rights reserved.
//

#import "SelectView.h"

@implementation SelectView

- (instancetype)init{
    
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        [self setUp];
    }
    return self;
}
- (void)setUp{
    [self.array addObject:@"客厅鱼缸"];
    [self.array addObject:@"客厅鱼缸"];
    [self.array addObject:@"客厅鱼缸"];
    [self.array addObject:@"客厅鱼缸"];
    [self.array addObject:@"客厅鱼缸"];
    [self.array addObject:@"客厅鱼缸"];
    self.backgroundColor = XXColor(80, 80, 80, 0.5);
    float bh = Height_TabBar;
    float th = Height_NavBar;
    self.tableivew = [[UITableView alloc] initWithFrame:CGRectMake(self.width - 150, th, 150, self.height - bh - th) style:UITableViewStylePlain];
    self.tableivew.separatorColor = [UIColor clearColor];

    self.tableivew.dataSource = self;
    self.tableivew.delegate = self;
    [self addSubview:self.tableivew];
    
    [self.tableivew setEditing:YES animated:YES];
    [self addBottomView];
}

- (void)addBottomView{
    float bh = Height_TabBar;

    UIView *headV = [[UIView alloc] initWithFrame:CGRectMake(self.width - 150, self.bottom - bh, 150, bh)];
    [self addSubview:headV];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, bh)];
    [btn1 setTitle:@"取消" forState:UIControlStateNormal];
    [btn1 setBackgroundColor:[UIColor whiteColor]];
    [btn1 addTarget:self action:@selector(CloseView) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [headV addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(btn1.right, 0, 75, bh   )];
    [btn2 setTitle:@"换水" forState:UIControlStateNormal];
    [btn2 setBackgroundColor:NavColor];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [headV addSubview:btn2];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 0.5)];
    lineV.backgroundColor = [UIColor grayColor];
    [headV addSubview:lineV];
}

- (void)CloseView
{
    self.hidden = YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
    [selectBtn setImage:[UIImage imageNamed:@"gou1"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"gou2"] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(ClickSelect:) forControlEvents:UIControlEventTouchUpInside];
    [headV addSubview:selectBtn];

    UILabel *selectAll = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, 50)];
    selectAll.text = @"选择换鱼缸";
    [headV addSubview:selectAll];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, selectAll.bottom, 150, 0.5)];
    lineV.backgroundColor = [UIColor grayColor];
    [headV addSubview:lineV];

    return headV;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *Identifier = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    cell.textLabel.text = self.array[indexPath.row];
    
    return cell;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //选中数据
    
    [self.selectorPatnArray addObject:self.array[indexPath.row]];
    
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    //从选中中取消
    if (self.selectorPatnArray.count > 0) {
        
        [self.selectorPatnArray removeObject:self.array[indexPath.row]];
    }
    
}

- (void)ClickSelect:(UIButton *)btn
{
    btn.selected =! btn.selected;
    if (!btn.isSelected) {
        if (self.selectorPatnArray.count > 0) {
            
            for (int i = 0; i< self.selectorPatnArray.count; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                [self.tableivew deselectRowAtIndexPath:indexPath animated:NO];
            }
            
            [self.selectorPatnArray removeAllObjects];
        }
        
    }
    else
    {
        if (self.selectorPatnArray.count > 0) {
            [self.selectorPatnArray removeAllObjects];
        }
        [self.selectorPatnArray addObjectsFromArray:self.array];
        
        for (int i = 0; i< self.selectorPatnArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [self.tableivew selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
        }
    }
    [self.tableivew setEditing:YES animated:YES];
}

#pragma mark - 点击事件

- (void)selectMore:(UIBarButtonItem *)action{
//    if ([button.titleLabel.text isEqualToString:@"选择"]) {
//        //移除之前选中的内容
//        if (self.selectorPatnArray.count > 0) {
//            [self.selectorPatnArray removeAllObjects];
//        }
//        [button setTitle:@"确认" forState:(UIControlStateNormal)];
//        //进入编辑状态
//        [self.tableivew setEditing:YES animated:YES];
//    }else{
//
//        [button setTitle:@"选择" forState:(UIControlStateNormal)];
//        　　　　　//对选中内容进行操作
//        NSLog(@"选中个数是 : %lu   内容为 : %@",(unsigned long)self.selectorPatnArray.count,self.selectorPatnArray);
//        //取消编辑状态
//        [self.tableivew setEditing:NO animated:YES];
//
//    }
}


#pragma mark -懒加载

-(NSMutableArray *)array{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

- (NSMutableArray *)selectorPatnArray{
    if (!_selectorPatnArray) {
        _selectorPatnArray = [NSMutableArray array];
    }
    return _selectorPatnArray;
}

@end
