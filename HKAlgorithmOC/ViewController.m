//
//  ViewController.m
//  HKAlgorithmOC
//
//  Created by heke on 16/3/29.
//  Copyright © 2016年 mhk. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UISlider *s = [[UISlider alloc] initWithFrame:CGRectMake(10, 100, 300, 30)];
    s.maximumValue = 1000;
    s.minimumValue = -1000;
    s.value = 0;
    [self.view addSubview:s];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    button.frame = CGRectMake(10, 74, 80, 40);
    button.backgroundColor = [UIColor greenColor];
    [self.view addSubview:button];
    
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){10,130,100,40}];
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
