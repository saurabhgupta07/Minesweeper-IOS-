//
//  FirstViewController.m
//  Minesweeper
//
//  Created by Saurabh Gupta on 10/7/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "FirstViewController.h"
#import "MyView.h"

@interface FirstViewController ()
@property (strong, nonatomic) IBOutlet MyView *myView;

@end

@implementation FirstViewController
@synthesize myView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:myView action:@selector(tapDoubleHandler:)];
    doubleTap.numberOfTapsRequired =2;
    [myView addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:myView action:@selector(tapSingleHandler:)];
    singleTap.numberOfTapsRequired=1;
    [singleTap requireGestureRecognizerToFail: doubleTap];
    [myView addGestureRecognizer:singleTap];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
