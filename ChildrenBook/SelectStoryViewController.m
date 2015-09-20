//
//  SelectStoryViewController.m
//  ChildrenBook
//
//  Created by Ivan Cardenas on 9/19/15.
//  Copyright © 2015 Ivan Cardenas. All rights reserved.
//

#import "SelectStoryViewController.h"
#import "PathHelper.h"
#import "BookPreviewViewController.h"

@interface SelectStoryViewController ()
@property (nonatomic, strong) NSMutableArray* dataSource;
@property (nonatomic, strong) IBOutlet UITableView* tableView;
@end

@implementation SelectStoryViewController
@synthesize dataSource, tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataSource = [[NSMutableArray alloc] init];
    [self reloadData];
    // Do any additional setup after loading the view from its nib.
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
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

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString* folder = [self.dataSource objectAtIndex:indexPath.row];
    BookPreviewViewController* bookPreviewViewController = [[BookPreviewViewController alloc] initWithNibName:@"BookPreviewViewController" bundle:nil];
    
    bookPreviewViewController.storyBookPath = [[PathHelper getStoryboardLocation] stringByAppendingPathComponent:folder];
    
    [self.navigationController pushViewController:bookPreviewViewController animated:YES];
    
}

- (IBAction)previousPage:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
