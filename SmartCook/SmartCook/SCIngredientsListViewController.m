//
//  SCIngredientsListViewController.m
//  SmartCook
//
//  Created by Noah Dayan on 12/24/13.
//  Copyright (c) 2013 Noah Dayan. All rights reserved.
//

#import "SCIngredientsListViewController.h"
#import "SCRecipesDetailViewController.h"

@interface SCIngredientsListViewController ()

@end

@implementation SCIngredientsListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // This table displays items in the Ingredient class
        self.parseClassName = @"Ingredient";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 25;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.ingredientsType = @"All";
    self.ingredientsIDs = [[NSMutableArray alloc] init];
    self.title = @"Ingredients";
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(searchRecipe:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(clearIngredients:)];
    self.navigationItem.leftBarButtonItem = clearButton;
    
    UIBarButtonItem *addRecipeButton = [[UIBarButtonItem alloc] initWithTitle:@"Recipe" style:UIBarButtonItemStylePlain target:self action:@selector(addRecipe:)];
    
    UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *addIngredientButton = [[UIBarButtonItem alloc] initWithTitle:@"Ingredient" style:UIBarButtonItemStylePlain target:self action:@selector(addIngredient:)];
    
    [self setToolbarItems:[NSArray arrayWithObjects:addIngredientButton, spaceButton, addRecipeButton, nil]];
    
    self.detailViewController = (SCRecipesDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:@"Ingredient"];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0)
    {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    if(self.ingredientsType && ![self.ingredientsType isEqualToString: @"All"])
    {
        [query whereKey:@"type" equalTo:self.ingredientsType];
    }
    
    [query orderByAscending:@"name"];
    
    return query;
}

- (void)searchRecipe:(id)sender
{
    [self recipesWithIngredients:self.ingredientsIDs];
}

- (void)receiveRecipe:(NSArray *)objects error:(NSError *)error
{
    if(!error)
    {
        // The find succeeded.
        NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
        
        if([objects count] == 0)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Recipe" message:@"There are no recipes with these ingredients!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
                [alert dismissViewControllerAnimated:YES completion:nil];
                
            }];
            
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            NSMutableArray *recipes = [[NSMutableArray alloc] init];
            for(PFObject *object in objects)
            {
                [recipes addObject:object.objectId];
            }
            
            _detailViewController.recipesIDs = recipes;
            [_detailViewController loadObjects];
        }
    }
    else
    {
        // Log details of the failure
        NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
}

- (void)clearIngredients:(id)sender
{
    for(UITableViewCell *cell in self.tableView.visibleCells)
    {
        if(cell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    self.ingredientsIDs = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
    _detailViewController.recipesIDs = [[NSArray alloc] init];
    [_detailViewController loadObjects];
}

- (IBAction)filterIngredientType:(UISegmentedControl *)sender
{
    if(sender.selectedSegmentIndex == 1)
    {
        self.ingredientsType = @"Fruit";
    }
    else if(sender.selectedSegmentIndex == 2)
    {
        self.ingredientsType = @"Vegetable";
    }
    else if(sender.selectedSegmentIndex == 3)
    {
        self.ingredientsType = @"Cereal";
    }
    else
    {
        self.ingredientsType = @"All";
    }
    
    [self loadObjects];
}

- (void)dealloc
{
    self.ingredientsType = nil;
    self.ingredientsIDs = nil;
    self.detailViewController = nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *CellIdentifier = @"Cell";
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if(!cell)
    {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = object[@"name"];
    cell.detailTextLabel.text = object[@"type"];
    
    if([self.ingredientsIDs containsObject:object.objectId])
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

        [self.ingredientsIDs addObject:[self objectAtIndexPath:indexPath].objectId];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;

        [self.ingredientsIDs removeObject:[self objectAtIndexPath:indexPath].objectId];
    }
    
    [self.tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *count = [[NSString alloc] init];
    
    if([self.ingredientsIDs count] == 1)
    {
        count = [NSString stringWithFormat:@"%lu %@", (unsigned long)[self.ingredientsIDs count], @"Ingredient"];
    }
    else
    {
        count = [NSString stringWithFormat:@"%lu %@", (unsigned long)[self.ingredientsIDs count], @"Ingredients"];
    }
    
    return count;
}

- (NSArray *)ingredientInfos
{
    NSMutableArray *infos = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Ingredient"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu ingredients.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                
                [infos addObject:object.objectId];
                
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    return infos;
}

- (NSArray *)ingredientInfosWithType:(NSString *)type
{
    NSMutableArray *infos = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Ingredient"];
    [query whereKey:@"type" equalTo:type];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                
                [infos addObject:object.objectId];
                
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    return infos;
}

- (NSArray *)recipeInfos
{
    NSMutableArray *infos = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Recipe"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                
                [infos addObject:object.objectId];
                
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    return infos;
}

- (NSArray *)recipeIngredients:(NSString *)recipeID
{
    NSMutableArray *ingredients = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Recipe"];
    [query getObjectInBackgroundWithId:recipeID block:^(PFObject *object, NSError *error) {
        // Do something with the returned PFObject in the object variable.
        for (NSString *ingredient in object[@"ingredients"])
        {
            [ingredients addObject:ingredient];
        }
        
    }];
    
    return ingredients;
}

- (NSArray *)recipesWithIngredients:(NSArray *)ingredients
{
    NSMutableArray *recipes = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Recipe"];
    [query whereKey:@"ingredients" containsAllObjectsInArray:ingredients];
    [query findObjectsInBackgroundWithTarget:self selector:@selector(receiveRecipe:error:)];
    
    return recipes;
}

- (void)addRecipe:(id)sender
{
    if([self.ingredientsIDs count] != 0)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add Recipe" message:@"Enter name and type of recipe:" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            UITextField *name = (UITextField *)[[alert textFields] firstObject];
            UITextField *type = (UITextField *)[[alert textFields] lastObject];
            
            PFObject *recipe = [PFObject objectWithClassName:@"Recipe"];
            recipe[@"ingredients"] = self.ingredientsIDs;
            recipe[@"name"] = name.text;
            recipe[@"type"] = type.text;
            [recipe saveInBackground];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            [alert dismissViewControllerAnimated:YES completion:nil];
            
        }];
        
        [alert addAction:cancel];
        [alert addAction:ok];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Name";
        }];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Type";
        }];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add Recipe" message:@"Select at least one ingredient!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            [alert dismissViewControllerAnimated:YES completion:nil];
            
        }];
        
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)addIngredient:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add Ingredient" message:@"Enter name and type of ingredient:" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UITextField *name = (UITextField *)[[alert textFields] firstObject];
        UITextField *type = (UITextField *)[[alert textFields] lastObject];
        
        PFObject *ingredient = [PFObject objectWithClassName:@"Ingredient"];
        ingredient[@"name"] = name.text;
        ingredient[@"type"] = type.text;
        [ingredient saveInBackground];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        [alert dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    [alert addAction:cancel];
    [alert addAction:ok];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Name";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Type";
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
