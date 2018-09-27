//
//  AppDelegate.h
//  ObjCMsapps
//
//  Created by hackeru on 18 Tishri 5779.
//  Copyright © 5779 student.roey.honig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

