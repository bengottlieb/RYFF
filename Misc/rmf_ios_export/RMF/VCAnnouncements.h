//
//  VCAnnouncements.h
//  Saskatoon AFFL
//
//  Created by Scott Gjesdal on 12/19/2013.
//  Copyright (c) 2013 SportForm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCAnnouncements : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *announcementTable;
@end
