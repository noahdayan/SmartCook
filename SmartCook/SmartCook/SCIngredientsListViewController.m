//
//  SCIngredientsListViewController.m
//  SmartCook
//
//  Created by Noah Dayan on 12/24/13.
//  Copyright (c) 2013 Noah Dayan. All rights reserved.
//

#import "SCIngredientsListViewController.h"
#import "SCIngredientInfo.h"
#import "SCIngredientDatabase.h"
#import "SCIngredientsDetailViewController.h"
#import "SCRecipeInfo.h"
#import "SCRecipeDatabase.h"

@interface SCIngredientsListViewController ()

@end

@implementation SCIngredientsListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.ingredientsInfos = [SCIngredientDatabase database].ingredientInfos;
    self.ingredientsIDs = [[NSMutableArray alloc] init];
    self.title = @"Ingredients";
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(searchRecipe:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(clearIngredients:)];
    self.navigationItem.leftBarButtonItem = clearButton;
    
    self.detailViewController = (SCIngredientsDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchRecipe:(id)sender
{
    NSArray *recipesWithIngredients = [[SCRecipeDatabase database] recipesWithIngredients:self.ingredientsIDs];
    
    if([recipesWithIngredients count] == 0)
    {
        _detailViewController.detailDescriptionLabel.text = @"No Recipes!";
    }
    else
    {
        NSString *recipes = [[NSString alloc] init];
        for(SCRecipeInfo *info in recipesWithIngredients)
        {
            //NSLog(@"%@, %@", info.name, info.type);
            if([recipes isEqualToString:@""])
            {
                recipes = info.name;
            }
            else
            {
                recipes = [NSString stringWithFormat:@"%@, %@", recipes, info.name];
            }
        }
    
        _detailViewController.detailDescriptionLabel.text = recipes;
    }
}

- (void)clearIngredients:(id)sender
{
    for(UITableViewCell *cell in self.tableView.visibleCells)
    {
        if(cell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            //[self.ingredientsIDs removeObject:[NSNumber numberWithInteger:[self.tableView indexPathForCell:cell].row+1]];
            [self.ingredientsIDs removeObject:cell.textLabel.text];
        }
    }
    
    _detailViewController.ingredientCount.text = @"0 Ingredients";
}

- (IBAction)filterIngredientType:(UISegmentedControl *)sender
{
    if(sender.selectedSegmentIndex == 1)
    {
        self.ingredientsInfos = [[SCIngredientDatabase database] ingredientInfosWithType:@"fruit"];
    }
    else if(sender.selectedSegmentIndex == 2)
    {
        self.ingredientsInfos = [[SCIngredientDatabase database] ingredientInfosWithType:@"vegetable"];
    }
    else if(sender.selectedSegmentIndex == 3)
    {
        self.ingredientsInfos = [[SCIngredientDatabase database] ingredientInfosWithType:@"cereal"];
    }
    else
    {
        self.ingredientsInfos = [[SCIngredientDatabase database] ingredientInfos];
    }
    
    [self.tableView reloadData];
}

- (void)dealloc
{
    self.ingredientsInfos = nil;
    self.ingredientsIDs = nil;
    self.detailViewController = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_ingredientsInfos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    SCIngredientInfo *info = [_ingredientsInfos objectAtIndex:indexPath.row];
    cell.textLabel.text = info.name;
    cell.detailTextLabel.text = info.type;
    //if([self.ingredientsIDs containsObject:[NSNumber numberWithInteger:indexPath.row+1]])
    if([self.ingredientsIDs containsObject:cell.textLabel.text])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(cell.accessoryType == UITableViewCellAccessoryNone)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        //[self.ingredientsIDs addObject:[NSNumber numberWithInteger:indexPath.row+1]];
        [self.ingredientsIDs addObject:cell.textLabel.text];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        //[self.ingredientsIDs removeObject:[NSNumber numberWithInteger:indexPath.row+1]];
        [self.ingredientsIDs removeObject:cell.textLabel.text];
    }
    
    [self updateIngredientCount];
    
    SCIngredientInfo *info = [_ingredientsInfos objectAtIndex:indexPath.row];
    _detailViewController.detailDescriptionLabel.text = info.name;
}

- (void)updateIngredientCount
{
    if([self.ingredientsIDs count] == 1)
    {
        _detailViewController.ingredientCount.text = [NSString stringWithFormat:@"%i %@", [self.ingredientsIDs count],@"Ingredient"];
    }
    else
    {
        _detailViewController.ingredientCount.text = [NSString stringWithFormat:@"%i %@", [self.ingredientsIDs count],@"Ingredients"];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

*/

@end
