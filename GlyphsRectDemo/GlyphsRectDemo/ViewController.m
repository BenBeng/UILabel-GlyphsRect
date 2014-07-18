//
//  ViewController.m
//  GlyphsRectDemo
//
//  Created by Ben on 14-7-18.
//  Copyright (c) 2014年 Ben. All rights reserved.
//

#import "ViewController.h"
#import "DemoLabel.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet DemoLabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeButtonClicked:(id)sender {
    self.label.text = self.textField.text;
}
@end
