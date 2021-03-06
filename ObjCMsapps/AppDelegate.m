//
//  AppDelegate.m
//  ObjCMsapps
//
//  Created by hackeru on 18 Tishri 5779.
//  Copyright © 5779 student.roey.honig. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()



@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"ObjCMsapps"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

- (void) saveMovieWithTitle: (NSString *) title
         withPosterImageUrl: (NSString *) image
                 withRating: (double) rating
            withReleaseYear: (int) releaseYear
                  withGenre: (NSArray *) genre {
    
    NSManagedObjectContext *context = self.persistentContainer.viewContext;

    // TODO: cheack for duplicate
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MovieCoreData"];
    NSError *fetchError = nil;
    [request setPredicate:[NSPredicate predicateWithFormat:@"title == %@", title]];
    NSArray *results = [context executeFetchRequest:request error:&fetchError];

    if ([results count] != 0) {
        // There are duplicates
        return;
    } else {
        // insert into coreData
        NSManagedObject *tmpMovie = [NSEntityDescription insertNewObjectForEntityForName:@"MovieCoreData" inManagedObjectContext:context];
        
        
        [tmpMovie setValue:title forKey:@"title"];
        [tmpMovie setValue:image forKey:@"image"];
        [tmpMovie setValue:[NSNumber numberWithDouble:rating] forKey:@"rating"];
        [tmpMovie setValue:[NSNumber numberWithInt:releaseYear] forKey:@"releaseYear"];
        [tmpMovie setValue:genre forKey:@"genre"];
        
        // try to save to persistant store
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"oops, something went wrong, cant save to coreData %@ %@", error, [error localizedDescription]);
        }
    }
    
   
    
}

- (NSMutableArray *) readCoreData {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MovieCoreData"];
    //sorting by release year
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"releaseYear" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    NSMutableArray *results = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return results;
}

- (void) deleteAllCoreData {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MovieCoreData"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
    NSError *deleteError = nil;
    [self.persistentContainer.persistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];

}

- (void) deleteMovieFromCoreDataWithTheTitle: (NSString *) title {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MovieCoreData"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title == %@", title]];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
    NSError *deleteError = nil;
    [self.persistentContainer.persistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];

}

@end
