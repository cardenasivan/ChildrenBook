//
//  SelectStoryViewController.m
//  ChildrenBook
//
//  Created by Ivan Cardenas on 9/19/15.
//  Copyright © 2015 Ivan Cardenas. All rights reserved.
//

#import "SelectStoryViewController.h"
#import "PathHelper.h"

@interface SelectStoryViewController ()
@property (nonatomic, strong) NSMutableArray* dataSource;
@property (nonatomic, strong) IBOutlet UITableView* tableView;
@end

@implementation SelectStoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataSource = [[NSMutableArray alloc] init];
    [self reloadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)reloadData
{
    NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[PathHelper getStoryboardLocation]
                                                                        error:NULL];
    
    for (NSString* dir in dirs)
    {
        BOOL isDir = NO;
        if([[NSFileManager defaultManager] fileExistsAtPath:[[PathHelper getStoryboardLocation ] stringByAppendingPathComponent:dir] isDirectory:&isDir] && isDir)
        {
            [self.dataSource addObject:[dir lastPathComponent]];
        }
    }
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    
    return cell;
}

- (IBAction)previousPage:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
