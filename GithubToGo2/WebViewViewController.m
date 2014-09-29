//
//  WebViewViewController.m
//  GithubToGo2
//
//  Created by Jeff Gayle on 8/28/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

#import "WebViewViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = false;
    
    WKWebView *webView = [[WKWebView alloc]initWithFrame:_webView.frame];
    [self.view addSubview:webView];
    NSURL *url = [NSURL URLWithString:self.html_url];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    [webView loadRequest:request];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
