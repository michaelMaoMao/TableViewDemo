//
//  ViewController.m
//  TableViewDemo
//
//  Created by MichaelMao on 16/5/11.
//  Copyright © 2016年 MichaelMao. All rights reserved.
//

#import "ViewController.h"


@interface ViewController () <UISearchDisplayDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *fliterData;

@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchDisplayController;

@end

@implementation ViewController

- (NSMutableArray *)filterData{

    if (!_fliterData) {
        _fliterData = [NSMutableArray array];
    }
    return _fliterData;
}

-(NSMutableArray *)dataSource{

    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithArray:
                       @[
                        @[@"alice", @"bob", @"crist", @"Apple", @"Elia6", @"Michael41", @"maomao"],
                        @[@"a1", @"b2", @"c3", @"d4", @"e5", @"f6", @"g7", @"h8"]]
                       ];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
   
}

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(nullable NSString *)searchString {
    [self fliterContentForSearchText:searchString];
    return YES;
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    [self fliterContentForSearchText:controller.searchBar.text];
    return YES;
}


#pragma mark - Filtering

- (void)fliterContentForSearchText:(NSString *)searchText {
    [self.fliterData removeAllObjects];
    [self fliterModel:self.dataSource forSearchText:searchText];
    self.searchDisplayController.searchResultsTitle = @"searchResultsTitle";
}

- (void)fliterModel:(NSArray *)array forSearchText:(NSString *)searchText {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
    NSMutableArray *AllData = [NSMutableArray arrayWithArray:self.dataSource[0]];
    [AllData addObjectsFromArray:self.dataSource[self.dataSource.count -1]];
    NSArray * fliterArr = [AllData filteredArrayUsingPredicate:predicate];
    [self.filterData addObjectsFromArray: fliterArr];
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return @"SearchDisplayResults";
    }else{
        return [NSString stringWithFormat:@"section header %zi", section + 1];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }else{
        return [self.dataSource count];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.fliterData count];
    }else{
        return [self.dataSource[section] count];
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:cellID];
    }
    NSString *detail =  [NSString stringWithFormat:@"content is %@", self.dataSource[indexPath.section][indexPath.row]];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        detail = [NSString stringWithFormat:@"content is %@", self.fliterData[indexPath.row]];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Row NO.%zi", indexPath.row + 1];
;
    cell.detailTextLabel.text = detail;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return (indexPath.row == 10)? NO : YES;
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{

    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger styleTag = indexPath.row%2 == 0 ?  UITableViewCellEditingStyleInsert : UITableViewCellEditingStyleDelete;
    return styleTag;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    NSMutableArray *sourceSet = [NSMutableArray arrayWithArray:self.dataSource[sourceIndexPath.section]];
    NSMutableArray *destinationSet = [NSMutableArray arrayWithArray:self.dataSource[destinationIndexPath.section]];
    if ([sourceSet isEqualToArray:destinationSet]) {
        [sourceSet exchangeObjectAtIndex:destinationIndexPath.row withObjectAtIndex:sourceIndexPath.row];
    }else{
    
        [destinationSet insertObject:sourceSet[sourceIndexPath.row] atIndex:destinationIndexPath.row];
        [sourceSet removeObjectAtIndex:sourceIndexPath.row];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"UITableViewCellEditingStyleDelete");
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    }else if (editingStyle == UITableViewCellEditingStyleInsert){
        NSLog(@"UITableViewCellEditingStyleInsert");
        [self.dataSource insertObject:@1 atIndex:indexPath.row];
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
