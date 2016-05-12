//
//  searchTableController.m
//  TableViewDemo
//
//  Created by MichaelMao on 16/5/12.
//  Copyright © 2016年 gegejia. All rights reserved.
//

#import "SearchTableController.h"


@interface SearchTableController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchDisplayController;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation SearchTableController

- (NSMutableArray *)dataSource{

    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithArray:@[@1, @2, @3, @4]];
    }
    return _dataSource;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI{
    self.title = @"searchVC";
//    [self.tableView setTableHeaderView:[self tableHeaderView]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"cellID";
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:cellID];
    }
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [NSString stringWithFormat:@"searchDisplayController"];

    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%@", self.dataSource[indexPath.row]];
    }
    cell.backgroundColor = [UIColor lightGrayColor];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }else{
        return [self.dataSource count];
    }
    
}




@end
