//
//  ViewController.m
//  GLInputPanel
//
//  Created by Yanci on 2017/8/24.
//  Copyright © 2017年 Yanci. All rights reserved.
//

#import "ViewController.h"
#import "GoodLookFloatView.h"
#import "GLChatInputPanel.h"

@interface ViewController ()
@property (nonatomic,strong)GoodLookFloatView *floatView;
@property (nonatomic,strong)GLChatInputPanel *inputPanel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    /** 添加悬浮视图 */
    [self.view addSubview:self.floatView];
    [self.floatView resetPosition];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GoodLookFloatViewDelegate
- (void)floatView:(id)sender didPickEdit:(GLEditType)editType {
    
    if (editType == GLEditText) {
        [self.inputPanel setPanelType:GLChatInputPanelType_Text];
        [self.inputPanel show];
    }
    else if(editType == GLEditUploadPic) {
        [self.inputPanel setPanelType:GLChatInputPanelType_Image];
        [self.inputPanel show];
    }
    else if(editType == GLEditUploadVideo) {
        [self.inputPanel setPanelType:GLChatInputPanelType_Video];
        [self.inputPanel show];
    }
}


#pragma mark - getter and setter
- (GoodLookFloatView *)floatView {
    if (!_floatView) {
        _floatView = [[GoodLookFloatView alloc]init];
        _floatView.frame = CGRectMake(0, 64.0, 44, 44);
        _floatView.backgroundColor = [UIColor clearColor];
        _floatView.delegate = self;
    }
    return _floatView;
}

- (GLChatInputPanel *)inputPanel {
    if (!_inputPanel) {
        _inputPanel = [[GLChatInputPanel alloc]init];
    }
    return _inputPanel;
}


@end
