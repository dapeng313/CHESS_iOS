//
//  WhiteboardViewController.m
//  ACEDrawingViewDemo
//
//  Created by Stefano Acerbetti on 1/6/13.
//  Copyright (c) 2013 Stefano Acerbetti. All rights reserved.
//

#import "WhiteboardViewController.h"
#import <ACEDrawingView/ACEDrawingView.h>
#import <AVFoundation/AVUtilities.h>
#import <QuartzCore/QuartzCore.h>
#import "NIMSDK.h"
#import "NIMMessageMaker.h"

#define kActionSheetColor       100
#define kActionSheetTool        101

@interface WhiteboardViewController ()<UIActionSheetDelegate, ACEDrawingViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (copy, nonatomic) NSString *sessionID;
@property (copy, nonatomic) NSString *info;

@end

@implementation WhiteboardViewController

#pragma mark - public methods
- (id)initWithSessionID:(NSString *)sessionID
                   info:(NSString *)info
{
    if (self = [super init]) {
        _sessionID = sessionID;
        _info = info;
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set the delegate
    self.drawingView.delegate = self;
    
    // start with a black pen
    self.lineWidthSlider.value = self.drawingView.lineWidth;
    
    // set draggable text properties
    self.drawingView.draggableTextFontName = @"MarkerFelt-Thin";

    [[self navigationController] setNavigationBarHidden: false animated: true];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"" style: UIBarButtonItemStylePlain target: nil action: nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"发送" style: UIBarButtonItemStylePlain target:self action:@selector(sendImage:)];
    
    self.navigationItem.title = @"白面"; //NSLocalizedString(@"chat", comment: @"");
    [[[self navigationController] navigationBar] setFrame: CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 75)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions

- (void)updateButtonStatus
{
    self.undoButton.enabled = [self.drawingView canUndo];
    self.redoButton.enabled = [self.drawingView canRedo];
}

- (void)sendImage:(id)sender
{
    // show the preview image
    UIImage *baseImage = [self.baseImageView image];
    UIImage *image =  baseImage ? [self.drawingView applyDrawToImage:baseImage] : self.drawingView.image;

    NIMMessage *message = [NIMMessageMaker msgWithImage:image];
    [[[NIMSDK sharedSDK] chatManager] sendMessage:message
                                        toSession:[NIMSession session:_sessionID type:NIMSessionTypeTeam]
                                            error:nil];

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)undo:(id)sender
{
    [self.drawingView undoLatestStep];
    [self updateButtonStatus];
}

- (IBAction)redo:(id)sender
{
    [self.drawingView redoLatestStep];
    [self updateButtonStatus];
}

- (IBAction)clear:(id)sender
{
    if ([self.baseImageView image])
    {
        [self.baseImageView setImage:nil];
        [self.drawingView setFrame:self.baseImageView.frame];
    }
    
    [self.drawingView clear];
    [self updateButtonStatus];
}


#pragma mark - ACEDrawing View Delegate

- (void)drawingView:(ACEDrawingView *)view didEndDrawUsingTool:(id<ACEDrawingTool>)tool;
{
    [self updateButtonStatus];
}


#pragma mark - Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.cancelButtonIndex != buttonIndex) {
        if (actionSheet.tag == kActionSheetColor) {
            
            self.colorButton.title = [actionSheet buttonTitleAtIndex:buttonIndex];
            switch (buttonIndex) {
                case 0:
                    self.drawingView.lineColor = [UIColor blackColor];
                    break;
                    
                case 1:
                    self.drawingView.lineColor = [UIColor blueColor];
                    break;
                    
                case 2:
                    self.drawingView.lineColor = [UIColor darkGrayColor];
                    break;
                    
                case 3:
                    self.drawingView.lineColor = [UIColor grayColor];
                    break;

                case 4:
                    self.drawingView.lineColor = [UIColor orangeColor];
                    break;

                case 5:
                    self.drawingView.lineColor = [UIColor magentaColor];
                    break;
                    
                case 6:
                    self.drawingView.lineColor = [UIColor purpleColor];
                    break;
                    
                case 7:
                    self.drawingView.lineColor = [UIColor redColor];
                    break;
                    
                case 8:
                    self.drawingView.lineColor = [UIColor yellowColor];
                    break;
                    
                case 9:
                    self.drawingView.lineColor = [UIColor greenColor];
                    break;
            }
            
        } else {
            
            self.toolButton.title = [actionSheet buttonTitleAtIndex:buttonIndex];
            switch (buttonIndex) {
                case 0:
                    self.drawingView.drawTool = ACEDrawingToolTypePen;
                    break;
                    
                case 1:
                    self.drawingView.drawTool = ACEDrawingToolTypeLine;
                    break;
                    
                case 2:
                    self.drawingView.drawTool = ACEDrawingToolTypeArrow;
                    break;
                    
                case 3:
                    self.drawingView.drawTool = ACEDrawingToolTypeRectagleStroke;
                    break;
                    
                case 4:
                    self.drawingView.drawTool = ACEDrawingToolTypeRectagleFill;
                    break;
                    
                case 5:
                    self.drawingView.drawTool = ACEDrawingToolTypeEllipseStroke;
                    break;
                    
                case 6:
                    self.drawingView.drawTool = ACEDrawingToolTypeEllipseFill;
                    break;
                    
                case 7:
                    self.drawingView.drawTool = ACEDrawingToolTypeEraser;
                    break;
                    
                case 8:
                    self.drawingView.drawTool = ACEDrawingToolTypeDraggableText;
                    break;
            }
            
            // if eraser, disable color and alpha selection
            self.colorButton.enabled = self.alphaButton.enabled = buttonIndex != 6;
        }
    }
}

#pragma mark - Settings

- (IBAction)colorChange:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择颜色"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"黑色", @"蓝色", @"深灰色", @"灰色", @"橙色", @"粉红色", @"紫色", @"红色", @"黄色", @"绿色", nil];
    
    [actionSheet setTag:kActionSheetColor];
    [actionSheet showInView:self.view];
}

- (IBAction)toolChange:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择工具"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"笔", @"线", @"箭头",
                                  @"矩形 (描边)", @"矩形 (填充)",
                                  @"椭圆 (行程)", @"椭圆 (填充)",
                                  @"橡皮", @"可拖动文本",
                                  nil];
    
    [actionSheet setTag:kActionSheetTool];
    [actionSheet showInView:self.view];
}

- (IBAction)toggleWidthSlider:(id)sender
{
    // toggle the slider
    self.lineWidthSlider.hidden = !self.lineWidthSlider.hidden;
    self.lineAlphaSlider.hidden = YES;
}

- (IBAction)widthChange:(UISlider *)sender
{
    self.drawingView.lineWidth = sender.value;
}

- (IBAction)toggleAlphaSlider:(id)sender
{
    // toggle the slider
    self.lineAlphaSlider.hidden = !self.lineAlphaSlider.hidden;
    self.lineWidthSlider.hidden = YES;
}

- (IBAction)alphaChange:(UISlider *)sender
{
    self.drawingView.lineAlpha = sender.value;
}

- (IBAction)loadImage:(id)sender
{
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)takePhoto:(id)sender {
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    [self.drawingView clear];
    [self updateButtonStatus];
    
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.baseImageView setImage:image];
    [self.drawingView setFrame:AVMakeRectWithAspectRatioInsideRect(image.size, self.baseImageView.frame)];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
