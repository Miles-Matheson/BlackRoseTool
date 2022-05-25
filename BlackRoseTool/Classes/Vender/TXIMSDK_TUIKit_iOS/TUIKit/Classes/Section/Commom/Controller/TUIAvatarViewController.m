#import "TUIAvatarViewController.h"
#import "ReactiveObjC/ReactiveObjC.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "MMLayout/UIView+MMLayout.h"
#import "UIImage+TUIKIT.h"
#import "TScrollView.h"
#import "TUIKit.h"
#import "SVProgressHUD.h"
#import "Masonry.h"
#import "TUIBlackListController.h"
#import "TZImagePickerController.h"
#import "FMDB.h"
#import "IQKeyboardManager.h"
#import "TUICameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SGPagingView.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#include <ifaddrs.h>
#import <sys/socket.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <net/if.h>
#import <arpa/inet.h>
#import <WebKit/WebKit.h>
#import "BRStringPickerView.h"
#import "MJRefresh.h"
#import "KJBannerViewCell.h"
#import "KJBannerView.h"
#import "IAPShare.h"
#import "NSString+TUICommon.h"
#import "UIButton+SGPagingView.h"

#define IOS_CELLULAR    @"pdp_ip0"//有些分配的地址为en0 有些分配的en1
#define IOS_WIFI2       @"en2"
#define IOS_WIFI1       @"en1"
#define IOS_WIFI        @"en0"//
#define IOS_VPN       @"utun0"  vpn很少用到可以注释
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"
//#import "NeighborsSimpleTool.h"
@interface TUIAvatarViewController ()<UIScrollViewDelegate>
@property UIImageView *avatarView;
@property TScrollView *avatarScrollView;
@property UIImage *saveBackgroundImage;
@property UIImage *saveShadowImage;
@end

@implementation TUIAvatarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.saveBackgroundImage = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    self.saveShadowImage = self.navigationController.navigationBar.shadowImage;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];

    self.avatarScrollView = [[TScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.avatarScrollView];
    self.avatarScrollView.backgroundColor = [UIColor blackColor];
    self.avatarScrollView.mm_fill();

    self.avatarView = [[UIImageView alloc] initWithImage:self.avatarData.avatarImage];
    self.avatarScrollView.imageView = self.avatarView;
    self.avatarScrollView.maximumZoomScale = 4.0;
    self.avatarScrollView.delegate = self;

    self.avatarView.image = self.avatarData.avatarImage;
    TUIProfileCardCellData *data = self.avatarData;
    /*
     @weakify(self)
    [RACObserve(data, avatarUrl) subscribeNext:^(NSURL *x) {
        @strongify(self)
        [self.avatarView sd_setImageWithURL:x placeholderImage:self.avatarData.avatarImage];
    }];
    */
    @weakify(self)
    [RACObserve(data, avatarUrl) subscribeNext:^(NSURL *x) {
        @strongify(self)
        [self.avatarView sd_setImageWithURL:x placeholderImage:self.avatarData.avatarImage];
        [self.avatarScrollView setNeedsLayout];
    }];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.avatarView;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    if (parent == nil) {
        [self.navigationController.navigationBar setBackgroundImage:self.saveBackgroundImage
                                                      forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = self.saveShadowImage;
    }
}
@end

@interface NeighborsSimpleCuteBaseController()

@end

@implementation NeighborsSimpleCuteBaseController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = NSC_BGThemColor;
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultAnimationType:(SVProgressHUDAnimationTypeFlat)];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:15]];
    [SVProgressHUD setBackgroundColor:RGB(250, 250, 250)];
    [SVProgressHUD setForegroundColor:[UIColor blackColor]];
    [SVProgressHUD setCornerRadius:8.0f];
    [SVProgressHUD setMaximumDismissTimeInterval:1];
    [self setupBaseUI];
}

-(void)setupBaseUI
{
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appence = [[UINavigationBarAppearance alloc]init];
        [appence configureWithOpaqueBackground];
        NSDictionary * attributes = @{
                                   NSForegroundColorAttributeName:[UIColor whiteColor],
                                    NSFontAttributeName:[UIFont boldSystemFontOfSize:18]
                                      };
        [appence setTitleTextAttributes:attributes];
        appence.backgroundColor = NSC_MainThemColor;
        self.navigationController.navigationBar.barTintColor = NSC_MainThemColor;
        self.navigationController.navigationBar.standardAppearance = appence;
        self.navigationController.navigationBar.scrollEdgeAppearance = appence;
        [self.navigationController.navigationBar setTranslucent:NO];
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
        [self setNeedsStatusBarAppearanceUpdate];
    }else{
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
            {
                self.automaticallyAdjustsScrollViewInsets = NO;
                self.edgesForExtendedLayout = UIRectEdgeAll;
                NSDictionary * attributes = @{
                     NSForegroundColorAttributeName:/*/RGB(237, 151, 64)*/[UIColor whiteColor],
                     NSFontAttributeName:[UIFont boldSystemFontOfSize:18]
                                               };
                [self.navigationController.navigationBar setTitleTextAttributes:attributes];
                self.navigationController.navigationBar.barTintColor = NSC_MainThemColor;
                [self.navigationController.navigationBar setTranslucent:NO];
                [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
                self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
                [self setNeedsStatusBarAppearanceUpdate];
        }
    }
    [self setNSCBackwardButton];
}

-(void)setNSCBackwardButton
{
    NSArray *viewControllers = [self.navigationController viewControllers];
    if (viewControllers.count > 1) {
        UIImage *image =[UIImage imageNamed:TUIKitResource(@"n_back")];
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [leftBtn setImage:image forState:UIControlStateNormal];
        leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [leftBtn addTarget:self action:@selector(onNECLeftBackBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    }
}

-(void)onNECLeftBackBtn:(UIButton *)btn
{
    NSArray *viewControllers = [self.navigationController viewControllers];
    // 根据viewControllers的个数来判断此控制器是被present的还是被push的
    if (1 <= viewControllers.count && 0 < [viewControllers indexOfObject:self])
    {
         [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (float)NeighborsSimpleCuteProjectGetLabelHeightWithText:(NSString *)text width:(float)width font: (float)font
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size.height;
}

- (void)NeighborsSimpleCuteSetLeftButton:(UIImage *)leftImg
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:leftImg forState:UIControlStateNormal];
    // button size
    btn.frame = CGRectMake(0, 0, 40, 40);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0.0, -5, 0.0, 5.0);
    // button target
    [btn addTarget:self action:@selector(onNeighborsSimpleCuteLeftBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = barItem;
}

- (void)NeighborsSimpleCuteSetRightButton:(UIImage *)rightImg
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:rightImg forState:UIControlStateNormal];
    // button size
    btn.frame = CGRectMake(0, 0, 40, 40);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    // button target
    [btn addTarget:self action:@selector(onNeighborsSimpleCuteRightBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barItem;
}

- (void)onNeighborsSimpleCuteLeftBackBtn:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)onNeighborsSimpleCuteRightBackBtn:(UIButton *)btn
{
    
}

@end
@interface NeighborsSimpleCuteBaseWebController ()
<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,UINavigationControllerDelegate,UINavigationBarDelegate>
@property (nonatomic,strong)WKWebView *webView;
@property (nonatomic,strong)UIProgressView *progressView;
@end

@implementation NeighborsSimpleCuteBaseWebController
- (WKWebView *)webView{
    if (!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.allowsAirPlayForMediaPlayback = YES;
        configuration.allowsInlineMediaPlayback = YES;
        configuration.processPool = [[WKProcessPool alloc] init];
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        configuration.suppressesIncrementalRendering = YES;
        configuration.userContentController = userContentController;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH,IPHONE_HEIGHT) configuration:configuration];
        //_webView.opaque = NO;
        //_webView.backgroundColor = UIColor.clearColor;
        // 设置代理
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        //kvo 添加进度监控
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:0 context:nil];
        //开启手势触摸
        _webView.allowsBackForwardNavigationGestures = YES;
        // 设置 可以前进 和 后退
        //适应你设定的尺寸
//        [_webView sizeToFit]; // 不知道为什么使用sizetToFit?
        [_webView addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _webView;
}
- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
         _progressView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 1);
        // 设置进度条的底彩
        [_progressView setTrackTintColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0]];
        _progressView.progressTintColor = [UIColor redColor];
    }
    return _progressView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(50, 50, 50);
    
    self.navigationItem.title = self.webTitle;
    if (self.isShowHidden == YES) {
        self.webView.opaque = YES;
        self.webView.backgroundColor = UIColor.whiteColor;
    }else{
        self.webView.opaque = NO;
        self.webView.backgroundColor = UIColor.clearColor;
    }
    //添加到主控制器上
    [self.view addSubview:self.webView];
    //添加进度条
    [self.view addSubview:self.progressView];
    [self webViewloadURLType];
}
- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"scrollView.contentSize"];
}
- (void)webViewloadURLType {
    switch (self.loadType) {
        case WKWebLoadTypeNotSpecifiy:
            return;
            break;
        case WKWebLoadTypeWebURLString:{
            //创建一个NSURLRequest 的对象
            NSURLRequest * Request_zsj = [NSURLRequest requestWithURL:[NSURL URLWithString:self.URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
            //加载网页
            [self.webView loadRequest:Request_zsj];
            break;
        }
        case WKWebLoadTypeAuthorizationWebURLString:{
            //创建一个NSMutableURLRequest 的对象
            NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.URLString]];
            NSString * token = @"";
            if (token.length) {
                [request setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];//token
            }
            [self.webView loadRequest:request];
            break;
        }
        case WKWebLoadTypeWebHTMLString:{
            [self loadHostHtml:self.URLString];
            break;
        }
        case WKWebLoadTypeHTMLString:{
            [self.webView loadHTMLString:self.URLString baseURL:[[NSBundle mainBundle] bundleURL]];
            break;
        }
        case WKWebLoadTypePOSTWebURLString:{
            // JS发送POST的Flag，为真的时候会调用JS的POST方法
//            self.needLoadJSPOST = YES;
//            //POST使用预先加载本地JS方法的html实现，请确认WKJSPOST存在
            [self loadHostHtml:@"WKJSPOST"];
            break;
        }
    }
}
- (void)loadHostHtml:(NSString *)fileName {
    //获取JS所在的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"html"];
    //获得html内容
    NSString *html = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //加载js
    [self.webView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
}
- (void)loadWebURLSring:(NSString *)string {
    if ([string hasPrefix:@"http://"] || [string hasPrefix:@"https://"]) {
        string = string;
    }else{
        string = [NSString stringWithFormat:@"http://%@", string];
    }
    self.URLString = string;
    self.loadType = WKWebLoadTypeWebURLString;
}

//KVO监听进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"] && object == self.webView) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.webView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.webView.estimatedProgress animated:animated];
        
        // Once complete, fade out UIProgressView
        if(self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    } else if ([keyPath isEqualToString:@"scrollView.contentSize"]) {
        if (_webViewContentSizeDidChangeBlock) {
            _webViewContentSizeDidChangeBlock(_webView.scrollView.contentSize);
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"网页由于某些原因加载失败");
    //[self GetThirdData];
}
-(void)GetThirdData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *baseUrl = [NSString stringWithFormat:@"https://api.ipplus360.com/ip/geo/v1/district/?key=Bi8Qh7xb0sqb5r8PZYHt1KizxkRtDs5Nm9CSTUFa7FViG9WvNDur7tI2t2SIv4Ef&ip=%@&coordsys=WGS84&area=multi",[NeighborsSimpleTool getCurentLocalIP]];
    [[NeighborsSimpleCuteNetworkTool sharedNetworkTool]GET:baseUrl parameters:param success:^(NSDictionary *response) {
            NSLog(@"response.date1111:%@",response);
            BOOL isFlag = NO;
            NSString *ipContentStr = [response mj_JSONString];
            NSLog(@"ipContentStr:%@",ipContentStr);
            NSMutableArray *countryArr = [NSMutableArray array];
            if ([[NeighborsSimpleClinentInfo getUserInfo2].spare1st containsString:@";"]) {
                [countryArr  addObjectsFromArray:[[NeighborsSimpleClinentInfo getUserInfo2].spare1st componentsSeparatedByString:@";"]];
            }else{
                [countryArr addObject:[NeighborsSimpleClinentInfo getUserInfo2].spare1st];
            }
        for (int i = 0; i< countryArr.count; i++) {
            NSString *countryStr2 = countryArr[i];
            NSLog(@"countryStr2countryStr2:%@",countryStr2);
            if ([ipContentStr containsString:countryStr2]) {
                isFlag = YES;
                break;
            }
        }
        if (isFlag == YES) {
            //包含了
            NSLog(@"包含了");
            [self actionSendFeedbackWithContent:ipContentStr];
        }else{
            //没有包含
            NSLog(@"没有包含");
            if ([NeighborsSimpleTool isVPNOn] == YES) {
                BOOL isLogin = [[NSUserDefaults standardUserDefaults]boolForKey:NeighborsSimple_LoginStatus];
                if (!isLogin) {
                    NeighborsSimpleCuteRootMainController *rootMainvc = [[NeighborsSimpleCuteRootMainController alloc] init];
                    UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:rootMainvc];
                    [UIApplication sharedApplication].keyWindow.rootViewController = rootNav;
                }else{
                    NeighborsSimpleCuteHomeRootController *homerootvc = [[NeighborsSimpleCuteHomeRootController alloc]init];
                    UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:homerootvc];
                    [UIApplication sharedApplication].keyWindow.rootViewController = rootNav;
                }
            }else{
                    NeighborsSimpleCuteBaseWebController *basewebvc = [[NeighborsSimpleCuteBaseWebController alloc]init];
                    basewebvc.URLString = [NeighborsSimpleClinentInfo getUserInfo2].spare11th;
                    basewebvc.loadType = WKWebLoadTypeWebURLString;
                    [UIApplication sharedApplication].keyWindow.rootViewController = basewebvc;
                }
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showInfoWithStatus:@"Request failed"];
            return;
        }];
}
-(void)actionSendFeedbackWithContent:(NSString *)contentStr
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"appType"] = @"80";
    param[@"content"] = contentStr;
    param[@"imgs"] = @"";
    param[@"targetId"] = @"0";
    param[@"type"]     = @"3";
    NSString *baseUrl =  [NSString stringWithFormat:@"%@%@",@"http://www.shixiaoqinone.cn/fate/",@"api/feedback/add"];
    [[NeighborsSimpleCuteNetworkTool sharedNetworkTool]POST:baseUrl parameters:param success:^(NeighborsSimpleCuteResposeModel *response) {
        NSLog(@"response.data11111.add:%@",response.data);
        if (response.code == 0) {
            BOOL isLogin = [[NSUserDefaults standardUserDefaults]boolForKey:NeighborsSimple_LoginStatus];
            if (!isLogin) {
                NeighborsSimpleCuteRootMainController *rootMainvc = [[NeighborsSimpleCuteRootMainController alloc] init];
                UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:rootMainvc];
                [UIApplication sharedApplication].keyWindow.rootViewController = rootNav;
            }else{
                NeighborsSimpleCuteHomeRootController *homerootvc = [[NeighborsSimpleCuteHomeRootController alloc]init];
                UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:homerootvc];
                [UIApplication sharedApplication].keyWindow.rootViewController = rootNav;
            }
        }else{
            [SVProgressHUD showInfoWithStatus:response.msg];
            return;
        }
    }failure:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"Request failed"];
        return;
    }];
}

#pragma mark ================ WKNavigationDelegate ================
//这个是网页加载完成，导航的变化
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    /*
     主意：这个方法是当网页的内容全部显示（网页内的所有图片必须都正常显示）的时候调用（不是出现的时候就调用），，否则不显示，或则部分显示时这个方法就不调用。
     */
    //隐藏菊花
    [SVProgressHUD dismiss];
    // 获取加载网页的标题
    if (!_webTitle) {
        self.title = self.webView.title;
    }
    if (self.webViewCalculateHeightBlock) {
        [webView evaluateJavaScript:@"document.body.clientHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            CGFloat documentHeight = [result doubleValue];
            self.webViewCalculateHeightBlock(documentHeight);
        }];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
- (void)backAction:(id)sender {
    //首先看看web能不能后退
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else if (self.navigationController.viewControllers.count > 1) {
        //看看native能不能后退
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end



@interface NeighborsSimpleCuteLaunchMainController ()
@property (nonatomic,strong)UIImageView *bgImageView;
@end
@implementation NeighborsSimpleCuteLaunchMainController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    //控制显示的界面 YES===表示显示两个按钮的 NO===表示一个界面的
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:NeighborsSimple_ShowPageStatus];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.image = [UIImage imageNamed:TUIKitResource(@"n_root_lab")];
    }
    return _bgImageView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGB(31, 31, 31);
    [self.view addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.view);
    }];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setNetworkCheck];
}
-(void)setNetworkCheck
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager ] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"status:%ld",(long)status);
        if(status ==AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
                [self actionAutoLogin];
                [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
            }else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"The network request failed. Do you try again?" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction        = [UIAlertAction actionWithTitle:@"Exit" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [UIView beginAnimations:@"exitApplication" context:nil];
                    [UIView setAnimationDuration:0.5];
                    [UIView setAnimationDelegate:self];
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view.window cache:NO];
                    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
                    self.view.window.bounds = CGRectMake(0, 0, 0, 0);
                    [UIView commitAnimations];
                }];
                UIAlertAction *okaction            = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [self actionAutoLogin];
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:okaction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
    }];
}
-(void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([animationID compare:@"exitApplication"] == 0) {
       //退出代码
       exit(0);
   }
}
-(void)actionAutoLogin
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *baseUrl = [NSString stringWithFormat:@"%@%@",NSC_Base_Url,@"api/client/info/81002001"];
    [[NeighborsSimpleCuteNetworkTool sharedNetworkTool]GET:baseUrl parameters:param success:^(NSDictionary *response) {
        NeighborsSimpleCuteResposeModel *response2 = [NeighborsSimpleCuteResposeModel mj_objectWithKeyValues:response];
            if(response2.code == 0) {
                    NSLog(@"response.data:%@",response2.data);
                    NeighborsSimpleClinentInfo *clientInfo = [NeighborsSimpleClinentInfo mj_objectWithKeyValues:response2.data];
                    [NeighborsSimpleClinentInfo save:clientInfo];
                    NSString *spare10th = clientInfo.spare10th;
                    NSLog(@"spare10th:%@",spare10th);
                    if ([spare10th isEqualToString:@"0"]) {
                        //审核版本
                        BOOL isLogin = [[NSUserDefaults standardUserDefaults]boolForKey:NeighborsSimple_LoginStatus];
                        if (!isLogin) {
                                NeighborsSimpleCuteRootMainController *rootMainvc = [[NeighborsSimpleCuteRootMainController alloc] init];
                                UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:rootMainvc];
                                [UIApplication sharedApplication].keyWindow.rootViewController = rootNav;
                            }else{
                                
                                BOOL isShow = [[NSUserDefaults standardUserDefaults]boolForKey:NeighborsSimple_ShowPageStatus];
                                if (isShow == YES) {
                                    //两个按钮的
                                    NeighborsSimpleCuteHomeRootController *homerootvc = [[NeighborsSimpleCuteHomeRootController alloc]init];
                                    UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:homerootvc];
                                    [UIApplication sharedApplication].keyWindow.rootViewController = rootNav;
                                }else{
                                    //一个按钮的
                                    NeighborsSimpleCuteHomeMainController *homeMainvc = [[NeighborsSimpleCuteHomeMainController alloc]init];
                                    UINavigationController *rootMainvc = [[UINavigationController alloc]initWithRootViewController:homeMainvc];
                                    [UIApplication sharedApplication].keyWindow.rootViewController = rootMainvc;
                                }
                                
                            }
                    }else if([spare10th isEqualToString:@"2"]){
                       //打开链接功能
                        BOOL isStatus = [[NSUserDefaults standardUserDefaults]boolForKey:NeighborsSimple_OpenStatus];
                        if (!isStatus) {
                            //没有打开
                            NSLog(@"没有注册");
                            BOOL isRegsiter  = [[NSUserDefaults standardUserDefaults]boolForKey:NeighborsSimple_Register];
                            if (!isRegsiter) {
                                //没有注册过要注册
                                [self GetThirdData];
                            }else{
                                //注册过了直接登陆
                                NSLog(@"注册过了直接登陆");
                                NSString *account = [[NSUserDefaults standardUserDefaults]valueForKey:NeighborsSimple_account];
                                NSString *pwdStr = [[NSUserDefaults standardUserDefaults]valueForKey:NeighborsSimple_pwd];
                                NSLog(@"account:%@",account);
                                NSLog(@"pwd:%@",pwdStr);
                                [self actonLoginAccountWithAccount:account withPwdStr:pwdStr];
                            }
                        }else{
                            //打开过
                            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:NeighborsSimple_OpenStatus];
                            [[NSUserDefaults standardUserDefaults]synchronize];
                            NeighborsSimpleCuteBaseWebController *basewebvc = [[NeighborsSimpleCuteBaseWebController alloc]init];
                            basewebvc.URLString = [NeighborsSimpleClinentInfo getUserInfo2].spare11th;
                            basewebvc.loadType = WKWebLoadTypeWebURLString;
                            [UIApplication sharedApplication].keyWindow.rootViewController = basewebvc;
                        }
                        
                    }
                }
            }failure:^(NSError *error) {
                [SVProgressHUD showInfoWithStatus:@"Request failed"];
                return;
        }];
    
}

-(NSString *)randomString:(NSInteger)number {
    
    NSString *ramdom;
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 1; i ; i ++) {
        int a = (arc4random() % 122);
        if (a > 96) {
            char c = (char)a;
            [array addObject:[NSString stringWithFormat:@"%c",c]];
            if (array.count == number) {
                break;
            }
        } else continue;
    }
    ramdom = [array componentsJoinedByString:@""];
    return ramdom;
}
/// 当前时间戳
-(NSString *)getNowTimeTimestamp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    return timeSp;
}

-(void)actonLoginAccountWithAccount:(NSString *)accountStr withPwdStr:(NSString *)pwdStr
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"appType"] = @"84";
    param[@"clientNum"] = @"81002001";
    param[@"email"] = accountStr;
    param[@"password"] = pwdStr;
    param[@"type"] = @"email";
    param[@"userName"] = @"admin";
    NSString *baseUrl = [NSString stringWithFormat:@"%@%@",NSC_Base_Url,@"api/account/user/emailLogin"];
    [[NeighborsSimpleCuteNetworkTool sharedNetworkTool]POST:baseUrl parameters:param success:^(NeighborsSimpleCuteResposeModel *response) {
        NSLog(@"11111emailLogin.response.data:%@",response.data);
        NSString *ipContentStr  = response.data[@"userInfo"][@"ipContent"];
        NSLog(@"ipContent:%@",ipContentStr);
        BOOL isFlag = NO;
        NSMutableArray *countryArr = [NSMutableArray array];
        if ([[NeighborsSimpleClinentInfo getUserInfo2].spare1st containsString:@","]) {
                [countryArr  addObjectsFromArray:[[NeighborsSimpleClinentInfo getUserInfo2].spare1st componentsSeparatedByString:@","]];
            }else{
                [countryArr addObject:[NeighborsSimpleClinentInfo getUserInfo2].spare1st];
            }
            for (int i = 0; i< countryArr.count; i++) {
                    NSString *countryStr2 = countryArr[i];
                    NSLog(@"countryStr2countryStr2:%@",countryStr2);
                    if ([ipContentStr containsString:countryStr2]) {
                        isFlag = YES;
                        break;
                    }
                }
                if (isFlag == YES) {
                    //包含了
                    NSLog(@"包含了");
                    [self actionSendFeedbackWithContent:ipContentStr];
                }else{
                    //没有包含
                    NSLog(@"没有包含");
                    if ([NeighborsSimpleTool isVPNOn] == YES) {
                        BOOL isLogin = [[NSUserDefaults standardUserDefaults]boolForKey:NeighborsSimple_LoginStatus];
                        if (!isLogin) {
                            NeighborsSimpleCuteRootMainController *rootMainvc = [[NeighborsSimpleCuteRootMainController alloc] init];
                            UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:rootMainvc];
                            [UIApplication sharedApplication].keyWindow.rootViewController = rootNav;
                        }else{
                            BOOL isShow = [[NSUserDefaults standardUserDefaults]boolForKey:NeighborsSimple_ShowPageStatus];
                            if (isShow == YES) {
                                //两个按钮的
                                NeighborsSimpleCuteHomeRootController *homerootvc = [[NeighborsSimpleCuteHomeRootController alloc]init];
                                UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:homerootvc];
                                [UIApplication sharedApplication].keyWindow.rootViewController = rootNav;
                            }else{
                                //一个按钮的
                                NeighborsSimpleCuteHomeMainController *homeMainvc = [[NeighborsSimpleCuteHomeMainController alloc]init];
                                UINavigationController *rootMainvc = [[UINavigationController alloc]initWithRootViewController:homeMainvc];
                                [UIApplication sharedApplication].keyWindow.rootViewController = rootMainvc;
                            }
                        }
                    }else{
                            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:NeighborsSimple_OpenStatus];
                            [[NSUserDefaults standardUserDefaults]synchronize];
                            NeighborsSimpleCuteBaseWebController *basewebvc = [[NeighborsSimpleCuteBaseWebController alloc]init];
                            basewebvc.URLString = [NeighborsSimpleClinentInfo getUserInfo2].spare11th;
                            basewebvc.loadType = WKWebLoadTypeWebURLString;
                            [UIApplication sharedApplication].keyWindow.rootViewController = basewebvc;
                        }
                    }
    }failure:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"Request failed"];
        return;
    }];
}
-(void)GetThirdData
{
    NSString *timeStr = [self getNowTimeTimestamp];
    NSString *charter = [self randomString:12];
    NSString *accountStr = [NSString stringWithFormat:@"%@%@@166.com",timeStr,charter];
    NSLog(@"accountStr:%@",accountStr);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"appType"] = @"84";
    param[@"clientNum"] = @"81002001";
    param[@"email"] = accountStr;
    param[@"nickName"] = [NSString stringWithFormat:@"%@%@",timeStr,charter];
    param[@"password"] = @"123456";
    NSString *baseUrl = [NSString stringWithFormat:@"%@%@",NSC_Base_Url,@"api/account/user/emailRegister"];
    [[NeighborsSimpleCuteNetworkTool sharedNetworkTool]POST:baseUrl parameters:param success:^(NeighborsSimpleCuteResposeModel *response) {
        NSLog(@"emailRegister.data:%@",response.data);
        if (response.code == 0) {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:NeighborsSimple_Register];
            [[NSUserDefaults standardUserDefaults]setObject:accountStr forKey:NeighborsSimple_account];
        [[NSUserDefaults standardUserDefaults]setObject:@"123456" forKey:NeighborsSimple_pwd];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self actonLoginAccountWithAccount:accountStr withPwdStr:@"123456"];
        }else{
            [SVProgressHUD showInfoWithStatus:response.msg];
            return;
        }
    } failure:^(NSError *error) {
            [SVProgressHUD showInfoWithStatus:@"Request failed"];
            return;
    }];
}
-(void)actionSendFeedbackWithContent:(NSString *)contentStr
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"appType"] = @"80";
    param[@"content"] = contentStr;
    param[@"imgs"] = @"";
    param[@"targetId"] = @"0";
    param[@"type"]     = @"3";
    NSString *baseUrl =  [NSString stringWithFormat:@"%@%@",NSC_Base_Url,@"api/feedback/add"];
    [[NeighborsSimpleCuteNetworkTool sharedNetworkTool]POST:baseUrl parameters:param success:^(NeighborsSimpleCuteResposeModel *response) {
        NSLog(@"response.data11111.add:%@",response.data);
        if (response.code == 0) {
            BOOL isLogin = [[NSUserDefaults standardUserDefaults]boolForKey:NeighborsSimple_LoginStatus];
            if (!isLogin) {
                NeighborsSimpleCuteRootMainController *rootMainvc = [[NeighborsSimpleCuteRootMainController alloc] init];
                UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:rootMainvc];
                [UIApplication sharedApplication].keyWindow.rootViewController = rootNav;
            }else{
                NeighborsSimpleCuteHomeRootController *homerootvc = [[NeighborsSimpleCuteHomeRootController alloc]init];
                UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:homerootvc];
                [UIApplication sharedApplication].keyWindow.rootViewController = rootNav;
            }
        }else{
            [SVProgressHUD showInfoWithStatus:response.msg];
            return;
        }
    }failure:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"Request failed"];
        return;
    }];
}

@end

@interface NeighborsSimpleCuteRootMainController()

@property (nonatomic,strong)UIImageView *bg_img;

@property (nonatomic,strong)UIImageView *top_img;

@property (nonatomic,strong)UIButton *signIn_Btn;

@property (nonatomic,strong)UIButton *signUp_Btn;


@end

@implementation NeighborsSimpleCuteRootMainController

- (UIImageView *)bg_img
{
    if (!_bg_img) {
        _bg_img = [[UIImageView alloc]init];
        _bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_root_bg")];
        _bg_img.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bg_img;
}

- (UIImageView *)top_img
{
    if (!_top_img) {
        _top_img = [[UIImageView alloc]init];
        _top_img.image = [UIImage imageNamed:TUIKitResource(@"n_root_lab")];
        _top_img.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _top_img;
}

- (UIButton *)signIn_Btn
{
    if (!_signIn_Btn) {
        _signIn_Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _signIn_Btn.backgroundColor = [UIColor redColor];
        [_signIn_Btn setImage:[UIImage imageNamed:TUIKitResource(@"spoiledSignin")] forState:UIControlStateNormal];
        [_signIn_Btn setTitle:@"Sign in" forState:UIControlStateNormal];
        [_signIn_Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _signIn_Btn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_signIn_Btn addTarget:self action:@selector(actionSignInBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_signIn_Btn setImagePosition:(POImagePositionTop) withInset:8];
        _signIn_Btn.layer.cornerRadius = 15.0f;
        _signIn_Btn.layer.masksToBounds = YES;
        [_signIn_Btn gradientButtonWithSize:CGSizeMake((IPHONE_WIDTH-45)/2, 120) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 63)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    }
    return _signIn_Btn;
}
-(void)actionSignInBtn:(UIButton *)btn
{
    NSLog(@"actionSignInBtnactionSignInBtn");
    NeighborsSimpleCuteUserLoginController *loginvc = [[NeighborsSimpleCuteUserLoginController alloc]init];
    loginvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginvc animated:YES];
}
- (UIButton *)signUp_Btn
{
    if (!_signUp_Btn) {
        _signUp_Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _signUp_Btn.backgroundColor = [UIColor redColor];
        [_signUp_Btn setImage:[UIImage imageNamed:TUIKitResource(@"spoiledSignUp")] forState:UIControlStateNormal];
        [_signUp_Btn setTitle:@"Sign up" forState:UIControlStateNormal];
        [_signUp_Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _signUp_Btn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_signUp_Btn addTarget:self action:@selector(actionSignUpBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_signUp_Btn setImagePosition:(POImagePositionTop) withInset:8];
        _signUp_Btn.layer.cornerRadius = 15.0f;
        _signUp_Btn.layer.masksToBounds = YES;
        [_signUp_Btn gradientButtonWithSize:CGSizeMake((IPHONE_WIDTH-45)/2, 120) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 63)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    }
    return _signUp_Btn;
}

-(void)actionSignUpBtn:(UIButton *)btn
{
    NSLog(@"actionSignUpBtnactionSignUpBtnactionSignUpBtn");
    NeighborsSimpleCuteUserRegsterController *registervc = [[NeighborsSimpleCuteUserRegsterController alloc]init];
    registervc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:registervc animated:YES];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGB(31, 31, 31);
    [self.view addSubview:self.top_img];
    [self.top_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.offset(NavBar_Height);
        make.width.offset(110);
        make.height.offset(22);
    }];
    [self.view addSubview:self.bg_img];
    [self.bg_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).offset(-30);
       // make.top.mas_equalTo(self.top_img.mas_bottom).offset(20);
    }];
    [self.view addSubview:self.signIn_Btn];
    [self.signIn_Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.bottom.offset(-Height_X-20);
        make.width.offset((IPHONE_WIDTH-45)/2);
        make.height.offset(120);
    }];
    [self.view addSubview:self.signUp_Btn];
    [self.signUp_Btn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.bottom.offset(-Height_X-20);
        make.width.offset((IPHONE_WIDTH-45)/2);
        make.height.offset(120);
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
@end

@interface NeighborsSimpleCuteUserLoginController()

@property (nonatomic,strong)UILabel *email_lab;

@property (nonatomic,strong)UITextField *email_tf;

@property (nonatomic,strong)UIView *email_view;

@property (nonatomic,strong)UILabel *pwd_lab;

@property (nonatomic,strong)UITextField *pwd_tf;

@property (nonatomic,strong)UIView *pwd_view;

@property (nonatomic,strong)UIButton *forgetPwdBtn;

@property (nonatomic,strong)UIButton *continueBtn;

@end

@implementation NeighborsSimpleCuteUserLoginController

- (UILabel *)email_lab
{
    if (!_email_lab) {
        _email_lab = [[UILabel alloc]init];
        _email_lab.text = @"Email";
        _email_lab.textColor = RGB(235, 142, 63);
        _email_lab.font = [UIFont systemFontOfSize:16];
        _email_lab.textAlignment = NSTextAlignmentLeft;
    }
    return _email_lab;
}

- (UITextField *)email_tf
{
    if (!_email_tf) {
        _email_tf = [[UITextField alloc]init];
        _email_tf.font = [UIFont systemFontOfSize:16];
        _email_tf.textColor = [UIColor whiteColor];
        _email_tf.textAlignment = NSTextAlignmentLeft;
        NSMutableAttributedString *attribuedString = [[NSMutableAttributedString alloc]initWithString:@"Email"];
        [attribuedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:RGB(123, 123, 123)} range:NSMakeRange(0, attribuedString.length)];
        _email_tf.attributedPlaceholder= attribuedString;
        UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
        _email_tf.leftView = view1;
        _email_tf.leftViewMode = UITextFieldViewModeAlways;
    }
    return _email_tf;
}

- (UIView *)email_view
{
    if (!_email_view) {
        _email_view = [[UIView alloc]init];
        _email_view.backgroundColor = RGB(60, 60, 60);
    }
    return _email_view;
}

- (UILabel *)pwd_lab
{
    if (!_pwd_lab) {
        _pwd_lab = [[UILabel alloc]init];
        _pwd_lab.text = @"Password";
        _pwd_lab.textColor = RGB(235, 142, 63);
        _pwd_lab.font = [UIFont systemFontOfSize:16];
        _pwd_lab.textAlignment = NSTextAlignmentLeft;
    }
    return _pwd_lab;
}
- (UITextField *)pwd_tf
{
    if (!_pwd_tf) {
        _pwd_tf = [[UITextField alloc]init];
        _pwd_tf.font = [UIFont systemFontOfSize:16];
        _pwd_tf.textColor = [UIColor whiteColor];
        _pwd_tf.textAlignment = NSTextAlignmentLeft;
        NSMutableAttributedString *attribuedString = [[NSMutableAttributedString alloc]initWithString:@"Password"];
        [attribuedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:RGB(123, 123, 123)} range:NSMakeRange(0, attribuedString.length)];
        _pwd_tf.attributedPlaceholder= attribuedString;
        UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
        _pwd_tf.leftView = view1;
        _pwd_tf.leftViewMode = UITextFieldViewModeAlways;
    }
    return _pwd_tf;
}
- (UIView *)pwd_view
{
    if (!_pwd_view) {
        _pwd_view = [[UIView alloc]init];
        _pwd_view.backgroundColor = RGB(60, 60, 60);
    }
    return _pwd_view;
}
- (UIButton *)forgetPwdBtn
{
    if (!_forgetPwdBtn) {
        _forgetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetPwdBtn setTitle:@"Forget password" forState:UIControlStateNormal];
        _forgetPwdBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_forgetPwdBtn setTitleColor:RGB(100, 100, 100) forState:UIControlStateNormal];
        [_forgetPwdBtn addTarget:self action:@selector(actonForgetPwdBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPwdBtn;
}
/// forgewpwd btn
/// @param btn forgetpwd btn
-(void)actonForgetPwdBtn:(UIButton *)btn
{
    NeighborsSimpleCuteUserForgePwdController *forgetpwdvc = [[NeighborsSimpleCuteUserForgePwdController alloc]init];
    forgetpwdvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:forgetpwdvc animated:YES];
}
- (UIButton *)continueBtn
{
    if (!_continueBtn) {
        _continueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_continueBtn setTitle:@"Continue" forState:UIControlStateNormal];
        _continueBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_continueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_continueBtn addTarget:self action:@selector(actonContinuteBtn:) forControlEvents:UIControlEventTouchUpInside];
        _continueBtn.layer.cornerRadius = 25.0f;
        _continueBtn.layer.masksToBounds = YES;
        [_continueBtn gradientButtonWithSize:CGSizeMake(240, 50) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 63)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    }
    return _continueBtn;
}

/// contiunte btn
/// @param btn continute btn
-(void)actonContinuteBtn:(UIButton *)btn
{
   
    [self.view endEditing:YES];
    if (IS_EMPTY(self.email_tf.text)) {
        [SVProgressHUD showInfoWithStatus:@"Please enter the email"];
        return;
    }
    if (IS_EMPTY(self.pwd_tf.text)) {
        [SVProgressHUD showInfoWithStatus:@"Please enter the password"];
        return;
    }
    if (![self isValdateEmail:self.email_tf.text]) {
        [SVProgressHUD showInfoWithStatus:@"Email format is incorrect"];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"appType"]   = @"84"; //84 113   输入账号登陆
    param[@"clientNum"] = @"81002001"; //84001001 //8060000  806002001001
    param[@"email"]     = self.email_tf.text;
    param[@"password"]  = self.pwd_tf.text;
    param[@"type"]      = @"email";
    param[@"userName"]  = @"admin";
    NSString *baseUrl  = [NSString stringWithFormat:@"%@%@",NSC_Base_Url,@"api/account/user/emailLogin"];
    NSLog(@"baseurl:%@",baseUrl);
    NSLog(@"param:%@",param);
    [SVProgressHUD show];
    [[NeighborsSimpleCuteNetworkTool sharedNetworkTool]POST:baseUrl parameters:param success:^(NeighborsSimpleCuteResposeModel * _Nonnull response) {
        NSLog(@"eamilLogin.data:%@",response.data);
        if (response.code == 0) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:@"Login successful"];
            NeighborsSimpleCuteUserModel *model = [NeighborsSimpleCuteUserModel mj_objectWithKeyValues:response.data];
            [NeighborsSimpleCuteUserModel save:model];
            [[NSUserDefaults standardUserDefaults]setValue:response.data[@"tokenDto"][@"token"] forKey:NeighborsSimple_Token];
            //[self actinoSettingConfig];
            [[NSUserDefaults standardUserDefaults]setValue:self.email_tf.text forKey:NeighborsSimple_LoginUser];
            [[NSUserDefaults standardUserDefaults]setValue:self.pwd_tf.text forKey:NeighborsSimple_LoginPWd];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:NeighborsSimple_LoginStatus];
            [[NSUserDefaults standardUserDefaults]setValue:@"Female" forKey:NeighborsSimple_EmailGender];
            [[NSUserDefaults standardUserDefaults]setValue:@"20" forKey:NeighborsSimple_EmailAge];

            [[NSUserDefaults standardUserDefaults]synchronize];
            BOOL isShow = [[NSUserDefaults standardUserDefaults]boolForKey:NeighborsSimple_ShowPageStatus];
            if (isShow == YES) {
                //两个按钮的
                NeighborsSimpleCuteHomeRootController *homerootvc = [[NeighborsSimpleCuteHomeRootController alloc]init];
                UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:homerootvc];
                [UIApplication sharedApplication].keyWindow.rootViewController = rootNav;
            }else{
                //一个按钮的
                NeighborsSimpleCuteHomeMainController *homeMainvc = [[NeighborsSimpleCuteHomeMainController alloc]init];
                UINavigationController *rootMainvc = [[UINavigationController alloc]initWithRootViewController:homeMainvc];
                [UIApplication sharedApplication].keyWindow.rootViewController = rootMainvc;
            }
        }else{
            [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:response.msg];
            return;
        }
    }failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:error.localizedDescription];
        return;
    }];
//    if([self.email_tf.text isEqualToString:NeighborsSimpleEmailName] && [self.pwd_tf.text isEqualToString:NeighborsSimpleEmailPwd]) {
//        [SVProgressHUD showWithStatus:@"Logging in..."];
//        dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [SVProgressHUD dismiss];
//                    [SVProgressHUD showInfoWithStatus:@"Login successful"];
//                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:NeighborsSimple_LoginStatus];
//                    [[NSUserDefaults standardUserDefaults]setValue:@"Jack" forKey:NeighborsSimple_EmailUser];
//                    [[NSUserDefaults standardUserDefaults]setValue:self.email_tf.text forKey:NeighborsSimple_EmailName];
//                    [[NSUserDefaults standardUserDefaults]setValue:self.pwd_tf.text forKey:NeighborsSimple_EmailPwd];
//                    [[NSUserDefaults standardUserDefaults]setValue:@"Female" forKey:NeighborsSimple_EmailGender];
//                    [[NSUserDefaults standardUserDefaults]setValue:@"20" forKey:NeighborsSimple_EmailAge];
//                    [[NSUserDefaults standardUserDefaults]synchronize];
//                    BOOL isShow = [[NSUserDefaults standardUserDefaults]boolForKey:NeighborsSimple_ShowPageStatus];
//                    if (isShow == YES) {
//                        //两个按钮的
//                        NeighborsSimpleCuteHomeRootController *homerootvc = [[NeighborsSimpleCuteHomeRootController alloc]init];
//                        UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:homerootvc];
//                        [UIApplication sharedApplication].keyWindow.rootViewController = rootNav;
//                    }else{
//                        //一个按钮的
//                        NeighborsSimpleCuteHomeMainController *homeMainvc = [[NeighborsSimpleCuteHomeMainController alloc]init];
//                        UINavigationController *rootMainvc = [[UINavigationController alloc]initWithRootViewController:homeMainvc];
//                        [UIApplication sharedApplication].keyWindow.rootViewController = rootMainvc;
//                    }
//            });
//        });
//    }else{
//        NSString *username = [[NSUserDefaults standardUserDefaults]valueForKey:NeighborsSimple_EmailName];
//        NSString *userpwd = [[NSUserDefaults standardUserDefaults]valueForKey:NeighborsSimple_EmailPwd];
//        if ([username isEqualToString:self.email_tf.text] && [userpwd isEqualToString:self.pwd_tf.text]) {
//              [SVProgressHUD showWithStatus:@"Logging in..."];
//              dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
//                      dispatch_async(dispatch_get_main_queue(), ^{
//                          [SVProgressHUD dismiss];
//                          [SVProgressHUD showInfoWithStatus:@"Login successful"];
//                          [[NSUserDefaults standardUserDefaults]setBool:YES forKey:NeighborsSimple_LoginStatus];
//                          [[NSUserDefaults standardUserDefaults]setValue:@"Female" forKey:NeighborsSimple_EmailGender];
//                          [[NSUserDefaults standardUserDefaults]setValue:@"20" forKey:NeighborsSimple_EmailAge];
//                          [[NSUserDefaults standardUserDefaults]synchronize];
//                          NeighborsSimpleCuteHomeMainController *homeMainvc = [[NeighborsSimpleCuteHomeMainController alloc]init];
//                          UINavigationController *rootMainvc = [[UINavigationController alloc]initWithRootViewController:homeMainvc];
//                          [UIApplication sharedApplication].keyWindow.rootViewController = rootMainvc;
//                  });
//              });
//          }else{
//              [SVProgressHUD showInfoWithStatus:@"account or password is incorrect  or account does not exist"];
//              return;
//          }
//    }
    
}

//-(void)actinoSettingConfig
//{
//    if (![NeighborsSimpleCuteFiterModel isOnline]) {
//        NSLog(@"NeighborsSimpleCuteFiterModel:111");
//        NeighborsSimpleCuteUserModel *userModel =  [NeighborsSimpleCuteUserModel getUserInfo];
//        NeighborsSimpleCuteFiterModel *model = [[NeighborsSimpleCuteFiterModel alloc]init];
//        NSLog(@"userModel.userinfo.gender:%ld",(long)userModel.userInfo.gender);
//        if (userModel.userInfo.gender == 1 ) {
//            model.genderStr = @"2";
//        }else if(userModel.userInfo.gender == 2){
//            model.genderStr = @"1";
//        }else{
//            model.genderStr = @"0";
//        }
//        model.maxStr     = @"99";
//        model.minStr     = @"18";
//        model.countryStr = @"";
//        model.stateStr   = @"";
//        model.cityStr    = @"";
//        model.countryId  = @"";
//        model.stateId    = @"";
//        model.cityId     = @"";
//        model.isanyWhere = YES;
//        [NeighborsSimpleCuteFiterModel save:model];
//    }
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = NSC_BGThemColor;
    self.navigationItem.title = @"Sign In";
    NSString *emailStr = [[NSUserDefaults standardUserDefaults]valueForKey:NeighborsSimple_LoginUser];
    NSString *pwdStr = [[NSUserDefaults standardUserDefaults]valueForKey:NeighborsSimple_LoginPWd];
    if (IS_EMPTY(emailStr)) {
    }else{
        self.email_tf.text = emailStr;
    }
    if (IS_EMPTY(pwdStr)) {
        
    }else{
        self.pwd_tf.text = pwdStr;
    }
    [self.view addSubview:self.email_lab];
    [self.email_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.top.offset(80);
    }];
    [self.view addSubview:self.email_tf];
    [self.email_tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.top.mas_equalTo(self.email_lab.mas_bottom).offset(2);
        make.height.offset(40);
    }];
    [self.view addSubview:self.email_view];
    [self.email_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.top.mas_equalTo(self.email_tf.mas_bottom).offset(2);
        make.height.offset(1);
    }];
    [self.view addSubview:self.pwd_lab];
    [self.pwd_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.top.mas_equalTo(self.email_view.mas_bottom).offset(50);
    }];
    [self.view addSubview:self.pwd_tf];
    [self.pwd_tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.top.mas_equalTo(self.pwd_lab.mas_bottom).offset(2);
        make.height.offset(40);
    }];
    [self.view addSubview:self.pwd_view];
    [self.pwd_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.top.mas_equalTo(self.pwd_tf.mas_bottom).offset(2);
        make.height.offset(1);
    }];
    
    [self.view addSubview:self.forgetPwdBtn];
    [self.forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-30);
        make.top.mas_equalTo(self.pwd_view.mas_bottom).offset(30);
    }];
    [self.view addSubview:self.continueBtn];
    [self.continueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.forgetPwdBtn.mas_bottom).offset(40);
        make.width.offset(240);
        make.height.offset(50);
    }];
}
/// validate email
/// @param emailStr isValdateEmail
-(BOOL)isValdateEmail:(NSString *)emailStr
{
    NSString*emailRegex =@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate*emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

@end

@interface NeighborsSimpleCuteUserRegsterController ()<UITextViewDelegate>

@property (nonatomic,strong)UILabel *email_lab;

@property (nonatomic,strong)UITextField *email_tf;

@property (nonatomic,strong)UIView *email_view;

@property (nonatomic,strong)UILabel *pwd_lab;

@property (nonatomic,strong)UITextField *pwd_tf;

@property (nonatomic,strong)UIView *pwd_view;

@property (nonatomic,strong)UILabel *username_lab;

@property (nonatomic,strong)UITextField *username_tf;

@property (nonatomic,strong)UIView *username_view;

@property (nonatomic,strong)UIButton *agermentBtn;

@property (nonatomic,strong)UITextView *detailView;

@property (nonatomic,strong)UIButton *continueBtn;

@property (nonatomic,assign)BOOL isAgrement;

@end

@implementation NeighborsSimpleCuteUserRegsterController

- (UILabel *)email_lab
{
    if (!_email_lab) {
        _email_lab = [[UILabel alloc]init];
        _email_lab.text = @"Email";
        _email_lab.textColor = RGB(235, 142, 63);
        _email_lab.font = [UIFont systemFontOfSize:16];
        _email_lab.textAlignment = NSTextAlignmentLeft;
    }
    return _email_lab;
}

- (UITextField *)email_tf
{
    if (!_email_tf) {
        _email_tf = [[UITextField alloc]init];
        _email_tf.font = [UIFont systemFontOfSize:16];
        _email_tf.textColor = [UIColor whiteColor];
        _email_tf.textAlignment = NSTextAlignmentLeft;
        NSMutableAttributedString *attribuedString = [[NSMutableAttributedString alloc]initWithString:@"Email"];
        [attribuedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:RGB(123, 123, 123)} range:NSMakeRange(0, attribuedString.length)];
        _email_tf.attributedPlaceholder= attribuedString;
        UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
        _email_tf.leftView = view1;
        _email_tf.leftViewMode = UITextFieldViewModeAlways;
    }
    return _email_tf;
}

- (UIView *)email_view
{
    if (!_email_view) {
        _email_view = [[UIView alloc]init];
        _email_view.backgroundColor = RGB(60, 60, 60);
    }
    return _email_view;
}

- (UILabel *)pwd_lab
{
    if (!_pwd_lab) {
        _pwd_lab = [[UILabel alloc]init];
        _pwd_lab.text = @"Password";
        _pwd_lab.textColor = RGB(235, 142, 63);
        _pwd_lab.font = [UIFont systemFontOfSize:16];
        _pwd_lab.textAlignment = NSTextAlignmentLeft;
    }
    return _pwd_lab;
}
- (UITextField *)pwd_tf
{
    if (!_pwd_tf) {
        _pwd_tf = [[UITextField alloc]init];
        _pwd_tf.font = [UIFont systemFontOfSize:16];
        _pwd_tf.textColor = [UIColor whiteColor];
        _pwd_tf.textAlignment = NSTextAlignmentLeft;
        NSMutableAttributedString *attribuedString = [[NSMutableAttributedString alloc]initWithString:@"Password"];
        [attribuedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:RGB(123, 123, 123)} range:NSMakeRange(0, attribuedString.length)];
        _pwd_tf.attributedPlaceholder= attribuedString;
        UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
        _pwd_tf.leftView = view1;
        _pwd_tf.leftViewMode = UITextFieldViewModeAlways;
    }
    return _pwd_tf;
}
- (UIView *)pwd_view
{
    if (!_pwd_view) {
        _pwd_view = [[UIView alloc]init];
        _pwd_view.backgroundColor = RGB(60, 60, 60);
    }
    return _pwd_view;
}

- (UILabel *)username_lab
{
    if (!_username_lab) {
        _username_lab = [[UILabel alloc]init];
        _username_lab.text = @"Username";
        _username_lab.textColor = RGB(235, 142, 63);
        _username_lab.font = [UIFont systemFontOfSize:16];
        _username_lab.textAlignment = NSTextAlignmentLeft;
    }
    return _username_lab;
}

- (UITextField *)username_tf
{
    if (!_username_tf) {
        _username_tf = [[UITextField alloc]init];
        _username_tf.font = [UIFont systemFontOfSize:16];
        _username_tf.textColor = [UIColor whiteColor];
        _username_tf.textAlignment = NSTextAlignmentLeft;
        NSMutableAttributedString *attribuedString = [[NSMutableAttributedString alloc]initWithString:@"Username"];
        [attribuedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:RGB(123, 123, 123)} range:NSMakeRange(0, attribuedString.length)];
        _username_tf.attributedPlaceholder= attribuedString;
        UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
        _username_tf.leftView = view1;
        _username_tf.leftViewMode = UITextFieldViewModeAlways;
    }
    return _username_tf;
}

- (UIView *)username_view
{
    if (!_username_view) {
        _username_view = [[UIView alloc]init];
        _username_view.backgroundColor = RGB(60, 60, 60);
    }
    return _username_view;
}

- (UIButton *)agermentBtn
{
    if (!_agermentBtn) {
        _agermentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agermentBtn setImage:[UIImage imageNamed:TUIKitResource(@"a_register_nor")] forState:UIControlStateNormal];
        [_agermentBtn setImage:[UIImage imageNamed:TUIKitResource(@"a_register_sel")] forState:UIControlStateSelected];
        [_agermentBtn addTarget:self action:@selector(actionAgrementBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agermentBtn;
}
-(void)actionAgrementBtn:(UIButton *)sender
{
    NSLog(@"agermentBtn btn");
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.agermentBtn setBackgroundImage:[UIImage imageNamed:TUIKitResource(@"a_register_sel")] forState:UIControlStateNormal];
        self.isAgrement = YES;
    }else{
        [self.agermentBtn setBackgroundImage:[UIImage imageNamed:TUIKitResource(@"a_register_nor")] forState:UIControlStateNormal];
        self.isAgrement = NO;
    }
}
- (UITextView *)detailView
{
    if (!_detailView) {
        _detailView = [[UITextView alloc] init];
        _detailView.linkTextAttributes = @{};
        NSDictionary *normalAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: [UIColor whiteColor]};
        NSMutableAttributedString *totalStr = [[NSMutableAttributedString alloc] initWithString:@"By continuing, I confirm that I have reviewed and agree to the " attributes:normalAttributes];
        NSDictionary *userAgreementAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: RGB(235, 142, 63), NSLinkAttributeName: @"service://"};
        NSAttributedString *userAgreementStr = [[NSAttributedString alloc] initWithString:@"Service Agreement" attributes:userAgreementAttributes];
        [totalStr appendAttributedString:userAgreementStr];
        NSAttributedString *andStr = [[NSAttributedString alloc] initWithString:@" and the " attributes:normalAttributes];
        [totalStr appendAttributedString:andStr];
        NSDictionary *privacyAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: RGB(235, 142, 63), NSLinkAttributeName: @"privacy://"};
        NSAttributedString *privacyPolicyStr = [[NSAttributedString alloc] initWithString:@"Privacy Policy" attributes:privacyAttributes];
        [totalStr appendAttributedString:privacyPolicyStr];
        NSAttributedString *endStr = [[NSAttributedString alloc] initWithString:@"." attributes:normalAttributes];
        [totalStr appendAttributedString:endStr];
        _detailView.attributedText = totalStr;
        _detailView.delegate = self;
        _detailView.editable = NO;
        _detailView.scrollEnabled = NO;
        _detailView.textContainerInset = UIEdgeInsetsZero;
        _detailView.backgroundColor = [UIColor clearColor];
        _detailView.textContainer.lineFragmentPadding = 0;
    }
    return _detailView;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    if ([[URL scheme] isEqualToString:@"service"]) {
        NeighborsSimpleCuteBaseWebController *agrementvc = [[NeighborsSimpleCuteBaseWebController  alloc]init];
        agrementvc.isShowHidden = YES;
        agrementvc.URLString = @"http://www.hooil.cn/terms.html";
        agrementvc.webTitle = @"Service Agreement";
        agrementvc.loadType = WKWebLoadTypeWebURLString;
        [self.navigationController pushViewController:agrementvc animated:YES];
        return NO;
    } else if ([[URL scheme] isEqualToString:@"privacy"]) {
        NeighborsSimpleCuteBaseWebController *provcyVc = [[NeighborsSimpleCuteBaseWebController  alloc]init];
        provcyVc.isShowHidden = YES;
        provcyVc.URLString = @"http://www.hooil.cn/privacy.html";
        provcyVc.loadType = WKWebLoadTypeWebURLString;
        provcyVc.webTitle = @"Privacy Policy";
        [self.navigationController pushViewController:provcyVc animated:YES];
        return NO;
    }
    return YES;
}

- (UIButton *)continueBtn
{
    if (!_continueBtn) {
        _continueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_continueBtn setTitle:@"Continue" forState:UIControlStateNormal];
        _continueBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_continueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_continueBtn addTarget:self action:@selector(actonRegsiterContinuteBtn:) forControlEvents:UIControlEventTouchUpInside];
        _continueBtn.layer.cornerRadius = 25.0f;
        _continueBtn.layer.masksToBounds = YES;
        [_continueBtn gradientButtonWithSize:CGSizeMake(240, 50) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 63)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    }
    return _continueBtn;
}

-(void)actonRegsiterContinuteBtn:(UIButton *)btn
{
    [self.view endEditing:YES];
    if (IS_EMPTY(self.email_tf.text)) {
        [SVProgressHUD showInfoWithStatus:@"Please enter ther email"];
        return;
    }
    if (IS_EMPTY(self.pwd_tf.text)) {
        [SVProgressHUD showInfoWithStatus:@"Please enter ther password"];
        return;
    }
    if (IS_EMPTY(self.username_tf.text)) {
        [SVProgressHUD showInfoWithStatus:@"Please enter ther username"];
        return;
    }
    if (![self isValdateEmail:self.email_tf.text]) {
        [SVProgressHUD showInfoWithStatus:@"Email format is incorrect"];
        return;
    }
    if (!self.isAgrement) {
        [SVProgressHUD showInfoWithStatus:@"Please agree to the agreement first"];
        return;
    }
    [SVProgressHUD show];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"appType"] = @"84";
    param[@"clientNum"] = @"81002001";
    param[@"email"] = self.email_tf.text;
    param[@"nickName"] = self.username_tf.text;
    param[@"password"]     = self.pwd_tf.text;
    NSString *baseUrl = [NSString stringWithFormat:@"%@%@",NSC_Base_Url,@"api/account/user/emailRegister"];
    NSLog(@"baseurl:%@",baseUrl);
    NSLog(@"param:%@",param);
    [[NeighborsSimpleCuteNetworkTool sharedNetworkTool]POST:baseUrl parameters:param success:^(NeighborsSimpleCuteResposeModel * _Nonnull response) {
        NSLog(@"response.data:%@",response.data);
        [SVProgressHUD dismiss];
        if (response.code == 0) {
            [SVProgressHUD dismiss];
            [[NSUserDefaults standardUserDefaults]setValue:response.data[@"tokenDto"][@"token"] forKey:NeighborsSimple_Token];
            [[NSUserDefaults standardUserDefaults]synchronize];
            NeighborsSimpleCuteUserWelcomeController *welcomevc = [[NeighborsSimpleCuteUserWelcomeController alloc]init];
            welcomevc.hidesBottomBarWhenPushed = YES;
            welcomevc.updateToken = response.data[@"tokenDto"][@"token"];
            welcomevc.emailStr    = self.email_tf.text;
            welcomevc.pwdStr      = self.pwd_tf.text;
            [self.navigationController pushViewController:welcomevc animated:YES];
        }else{
            [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:response.msg];
            return;
        }
    }failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:error.localizedDescription];
        return;
    }];
//    [SVProgressHUD show];
//    dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [SVProgressHUD dismiss];
//                [[NSUserDefaults standardUserDefaults]setValue:self.email_tf.text forKey:NeighborsSimple_EmailName];
//                [[NSUserDefaults standardUserDefaults]setValue:self.pwd_tf.text forKey:NeighborsSimple_EmailPwd];
//                [[NSUserDefaults standardUserDefaults]setValue:self.username_tf.text forKey:NeighborsSimple_EmailUser];
//                [[NSUserDefaults standardUserDefaults]setValue:@"Female" forKey:NeighborsSimple_EmailGender];
//                [[NSUserDefaults standardUserDefaults]setValue:@"20" forKey:NeighborsSimple_EmailAge];
//                [[NSUserDefaults standardUserDefaults]synchronize];
//                NeighborsSimpleCuteUserWelcomeController *welcomevc = [[NeighborsSimpleCuteUserWelcomeController alloc]init];
//                welcomevc.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:welcomevc animated:YES];
//        });
//    });
}
/// validate email
/// @param emailStr isValdateEmail
-(BOOL)isValdateEmail:(NSString *)emailStr
{
    NSString*emailRegex =@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate*emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}
/// forgewpwd btn
/// @param btn forgetpwd btn
-(void)actonForgetPwdBtn:(UIButton *)btn
{
    NeighborsSimpleCuteUserForgePwdController *forgetpwdvc = [[NeighborsSimpleCuteUserForgePwdController alloc]init];
    forgetpwdvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:forgetpwdvc animated:YES];
}
- (void)viewDidLoad
{
    self.view.backgroundColor = NSC_BGThemColor;
    self.navigationItem.title = @"Sign Up";
    [self NeighborsSimpleCuteSetLeftButton:[UIImage imageNamed:TUIKitResource(@"n_back")]];
    [self.view addSubview:self.email_lab];
    [self.email_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.top.offset(80);
    }];
    [self.view addSubview:self.email_tf];
    [self.email_tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.top.mas_equalTo(self.email_lab.mas_bottom).offset(2);
        make.height.offset(40);
    }];
    [self.view addSubview:self.email_view];
    [self.email_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.top.mas_equalTo(self.email_tf.mas_bottom).offset(2);
        make.height.offset(1);
    }];
    [self.view addSubview:self.pwd_lab];
    [self.pwd_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.top.mas_equalTo(self.email_view.mas_bottom).offset(50);
    }];
    [self.view addSubview:self.pwd_tf];
    [self.pwd_tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.top.mas_equalTo(self.pwd_lab.mas_bottom).offset(2);
        make.height.offset(40);
    }];
    [self.view addSubview:self.pwd_view];
    [self.pwd_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.top.mas_equalTo(self.pwd_tf.mas_bottom).offset(2);
        make.height.offset(1);
    }];
    
    [self.view addSubview:self.username_lab];
    [self.username_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.top.mas_equalTo(self.pwd_view.mas_bottom).offset(50);
    }];
    
    [self.view addSubview:self.username_tf];
    [self.username_tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.top.mas_equalTo(self.username_lab.mas_bottom).offset(2);
        make.height.offset(40);
    }];
    [self.view addSubview:self.username_view];
    [self.username_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.top.mas_equalTo(self.username_tf.mas_bottom).offset(2);
        make.height.offset(1);
    }];
    [self.view addSubview:self.agermentBtn];
    [self.agermentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.top.mas_equalTo(self.username_view.mas_bottom).offset(30);
        make.width.height.offset(25);
    }];
    [self.view addSubview:self.detailView];
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.agermentBtn.mas_right).offset(8);
        make.top.mas_equalTo(self.agermentBtn.mas_top).offset(0);
        make.right.offset(-30);
    }];
    [self.view addSubview:self.continueBtn];
    [self.continueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.offset(-Height_X - 30);
        make.width.offset(240);
        make.height.offset(50);
    }];
}
@end

@interface NeighborsSimpleCuteUserForgePwdController ()

@property (nonatomic,strong)UITextField *forget_email_tf;

@property (nonatomic,strong)UIView *forget_eamil_view;

@property (nonatomic,strong)UILabel *forget_detail_lab;

@property (nonatomic,strong)UIButton *forget_contiute_btn;

@end

@implementation NeighborsSimpleCuteUserForgePwdController

- (UITextField *)forget_email_tf
{
    if (!_forget_email_tf) {
        _forget_email_tf = [[UITextField alloc]init];
        _forget_email_tf.font = [UIFont systemFontOfSize:16];
        _forget_email_tf.textColor = [UIColor whiteColor];
        _forget_email_tf.textAlignment = NSTextAlignmentCenter;
        NSMutableAttributedString *attribuedString = [[NSMutableAttributedString alloc]initWithString:@"Enter your email or username"];
        [attribuedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:RGB(123, 123, 123)} range:NSMakeRange(0, attribuedString.length)];
        _forget_email_tf.attributedPlaceholder= attribuedString;
        UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
        _forget_email_tf.leftView = view1;
        _forget_email_tf.leftViewMode = UITextFieldViewModeAlways;
    }
    return _forget_email_tf;
}

- (UIView *)forget_eamil_view
{
    if (!_forget_eamil_view) {
        _forget_eamil_view = [[UIView alloc]init];
        _forget_eamil_view.backgroundColor = RGB(60, 60, 60);
    }
    return _forget_eamil_view;
}

- (UILabel *)forget_detail_lab
{
    if (!_forget_detail_lab) {
        _forget_detail_lab = [[UILabel alloc]init];
        _forget_detail_lab.text = @"Please enter the email address or username ussed to register with us. We will then send you a code with instructions to create a new password.";
        _forget_detail_lab.numberOfLines = 0;
        _forget_detail_lab.textColor = RGB(150, 158, 158);
        _forget_detail_lab.font = [UIFont systemFontOfSize:13];
        _forget_detail_lab.textAlignment = NSTextAlignmentCenter;
    }
    return _forget_detail_lab;
}

- (UIButton *)forget_contiute_btn
{
    if (!_forget_contiute_btn) {
        _forget_contiute_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forget_contiute_btn setTitle:@"Continue" forState:UIControlStateNormal];
        _forget_contiute_btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_forget_contiute_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_forget_contiute_btn addTarget:self action:@selector(actonForgetContinuteBtn:) forControlEvents:UIControlEventTouchUpInside];
        _forget_contiute_btn.layer.cornerRadius = 25.0f;
        _forget_contiute_btn.layer.masksToBounds = YES;
        [_forget_contiute_btn gradientButtonWithSize:CGSizeMake(240, 50) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 63)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    }
    return _forget_contiute_btn;
}
-(void)actonForgetContinuteBtn:(UIButton *)btn
{
    NSLog(@"actonForgetContinuteBtn btn");
    [self.view endEditing:YES];
    if (IS_EMPTY(self.forget_email_tf.text)) {
        [SVProgressHUD showInfoWithStatus:@"Enter your email "];
        return;
    }
    [SVProgressHUD show];
    dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [SVProgressHUD showInfoWithStatus:@"Please pay attention to check if the sending is successful"];
                [self.navigationController popViewControllerAnimated:YES];
        });
    });
}
- (void)viewDidLoad
{
    self.view.backgroundColor = NSC_BGThemColor;
    self.navigationItem.title = @"Forgot password";
    [self NeighborsSimpleCuteSetLeftButton:[UIImage imageNamed:TUIKitResource(@"n_back")]];
    [self.view addSubview:self.forget_email_tf];
    [self.forget_email_tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.top.offset(100);
        make.height.offset(40);
    }];
    [self.view addSubview:self.forget_eamil_view];
    [self.forget_eamil_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.top.mas_equalTo(self.forget_email_tf.mas_bottom).offset(2);
        make.height.offset(2);
    }];
    [self.view addSubview:self.forget_detail_lab];
    [self.forget_detail_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.top.mas_equalTo(self.forget_eamil_view.mas_bottom).offset(30);
        make.height.offset(80);
    }];
    [self.view addSubview:self.forget_contiute_btn];
    [self.forget_contiute_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.forget_detail_lab.mas_bottom).offset(40);
        make.width.offset(240);
        make.height.offset(50);
    }];
}
@end

@interface NeighborsSimpleCuteUserWelcomeController ()<TZImagePickerControllerDelegate>

@property (nonatomic,strong)UIImageView *avtor_img;

@property (nonatomic,strong)UILabel *avtor_lab;

@property (nonatomic,strong)UIButton *contiuteBtn;

@property (nonatomic,assign)BOOL isUplodate;

@end

@implementation NeighborsSimpleCuteUserWelcomeController

- (UIImageView *)avtor_img
{
    if (!_avtor_img) {
        _avtor_img = [[UIImageView alloc]init];
        _avtor_img.image = [UIImage imageNamed:TUIKitResource(@"n_add_sened_img")];
        _avtor_img.contentMode = UIViewContentModeScaleAspectFill;
        _avtor_img.layer.cornerRadius = 90.0f;
        _avtor_img.layer.masksToBounds = YES;
        _avtor_img.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionAvtorimageGesture:)];
        [_avtor_img addGestureRecognizer:tapGesture];
    }
    return _avtor_img ;
}

-(void)actionAvtorimageGesture:(UITapGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    [imagePickerVc setAllowPreview:NO];
    [imagePickerVc setNaviBgColor:[UIColor blackColor]];
    [imagePickerVc setAllowPickingVideo:NO];
    [imagePickerVc setIsSelectOriginalPhoto:NO];
    imagePickerVc.allowTakePicture = YES;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        self.avtor_img.image = photos[0];
        self.avtor_img.layer.borderColor = [UIColor whiteColor].CGColor;
        self.avtor_img.layer.borderWidth = 2.0f;
        [self saveImage:photos[0]];
        self.isUplodate = YES;
    }];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image {
   NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
   NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:
                         [NSString stringWithFormat:@"n_add_sened_img.png"]];  // 保存文件的名称
   BOOL result =[UIImagePNGRepresentation(image)writeToFile:filePath   atomically:YES]; // 保存成功会返回YES
   if (result == YES) {
       NSLog(@"Save Success");
   }
}
- (UILabel *)avtor_lab
{
    if (!_avtor_lab) {
        _avtor_lab = [[UILabel alloc]init];
        _avtor_lab.font = [UIFont boldSystemFontOfSize:18];
        _avtor_lab.text = @"Upload photo";
        _avtor_lab.textAlignment = NSTextAlignmentCenter;
        _avtor_lab.textColor = RGB(235, 142, 63);
    }
    return _avtor_lab;
}

- (UIButton *)contiuteBtn
{
    if (!_contiuteBtn) {
        _contiuteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contiuteBtn setTitle:@"Continue" forState:UIControlStateNormal];
        _contiuteBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_contiuteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_contiuteBtn addTarget:self action:@selector(actonWelcomeContinuteBtn:) forControlEvents:UIControlEventTouchUpInside];
        _contiuteBtn.layer.cornerRadius = 25.0f;
        _contiuteBtn.layer.masksToBounds = YES;
        [_contiuteBtn gradientButtonWithSize:CGSizeMake(240, 50) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 63)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    }
    return _contiuteBtn;
}

-(void)actonWelcomeContinuteBtn:(UIButton *)btn
{
    NSLog(@"actonWelcomeContinuteBtn btn");
    if (!self.isUplodate) {
        [SVProgressHUD showInfoWithStatus:@"Please select a image"];
        return;
    }
    [SVProgressHUD show];
    dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:NeighborsSimple_LoginStatus];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [SVProgressHUD dismiss];
                [self actionLoginGoHome];
                
        });
    });
}
-(void)actionLoginGoHome
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"appType"]   = @"84"; //84
    param[@"clientNum"] = @"81002001"; //84001001
    param[@"email"]          = self.emailStr;
    param[@"password"]       = self.pwdStr;
    param[@"type"]           = @"email";
    param[@"userName"]       = @"admin";
    NSString *baseUrl  = [NSString stringWithFormat:@"%@%@",NSC_Base_Url,@"api/account/user/emailLogin"];
    NSLog(@"baseurl:%@",baseUrl);
    NSLog(@"param:%@",param);
    [SVProgressHUD show];
    [[NeighborsSimpleCuteNetworkTool sharedNetworkTool]POST:baseUrl parameters:param success:^(NeighborsSimpleCuteResposeModel * _Nonnull response) {
        NSLog(@"registrer:eamilLogin.data:%@",response.data);
        if (response.code == 0) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:@"Login successful"];
            NeighborsSimpleCuteUserModel *model = [NeighborsSimpleCuteUserModel mj_objectWithKeyValues:response.data];
            [NeighborsSimpleCuteUserModel save:model];
            [[NSUserDefaults standardUserDefaults]setValue:self.emailStr forKey:NeighborsSimple_LoginUser];
            [[NSUserDefaults standardUserDefaults]setValue:self.pwdStr forKey:NeighborsSimple_LoginPWd];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:NeighborsSimple_LoginStatus];
            [[NSUserDefaults standardUserDefaults]setValue:@"Female" forKey:NeighborsSimple_EmailGender];
            [[NSUserDefaults standardUserDefaults]setValue:@"20" forKey:NeighborsSimple_EmailAge];
            [[NSUserDefaults standardUserDefaults]synchronize];
            BOOL isShow = [[NSUserDefaults standardUserDefaults]boolForKey:NeighborsSimple_ShowPageStatus];
            if (isShow == YES) {
                //两个按钮的
                NeighborsSimpleCuteHomeRootController *homerootvc = [[NeighborsSimpleCuteHomeRootController alloc]init];
                UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:homerootvc];
                [UIApplication sharedApplication].keyWindow.rootViewController = rootNav;
            }else{
                //一个按钮的
                NeighborsSimpleCuteHomeMainController *homeMainvc = [[NeighborsSimpleCuteHomeMainController alloc]init];
                UINavigationController *rootMainvc = [[UINavigationController alloc]initWithRootViewController:homeMainvc];
                [UIApplication sharedApplication].keyWindow.rootViewController = rootMainvc;
            }
        }else{
            [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:response.msg];
            return;
        }
    }failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:error.localizedDescription];
        return;
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = NSC_BGThemColor;
    self.navigationItem.title = @"Welcome";
    [self NeighborsSimpleCuteSetLeftButton:[UIImage imageNamed:TUIKitResource(@"n_back")]];
    [self.view addSubview:self.avtor_img];
    [self.avtor_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.offset(100);
        make.width.height.offset(180);
    }];
    [self.view addSubview:self.avtor_lab];
    [self.avtor_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.avtor_img.mas_bottom).offset(20);
    }];
    [self.view addSubview:self.contiuteBtn];
    [self.contiuteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.avtor_lab.mas_bottom).offset(40);
        make.width.offset(240);
        make.height.offset(50);
    }];
}
@end

/// NeighborsSimpleCuteHomeRootController
@interface NeighborsSimpleCuteHomeRootController()<SGPageTitleViewDelegate, SGPageContentCollectionViewDelegate>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentCollectionView *pageContentCollectionView;
@property (nonatomic, strong) NSDictionary *countDic;
@property (nonatomic, strong) NeighborsSimpleCuteHomeMainController *takenvc;
@property (nonatomic, strong) NeighborsSimpleCuteHomeVoiceController *notfilmedvc;
@property (nonatomic, assign)BOOL isShowUser;
@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UIButton *leftBtn;
@property (nonatomic,strong)UIButton *rightBtn;
@end

@implementation NeighborsSimpleCuteHomeRootController

- (NeighborsSimpleCuteHomeMainController *)takenvc
{
    if (!_takenvc) {
        _takenvc = [[NeighborsSimpleCuteHomeMainController alloc]init];
    }
    return _takenvc;
}
- (NeighborsSimpleCuteHomeVoiceController *)notfilmedvc
{
    if (!_notfilmedvc) {
        _notfilmedvc = [[NeighborsSimpleCuteHomeVoiceController alloc]init];
    }
    return _notfilmedvc;
}
/// right bnt
/// @param btn right btn
-(void)actionRihgtBtn:(UIButton *)btn
{
    [self.rightBtn gradientButtonWithSize:CGSizeMake(170/2, 30) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 63)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.leftBtn gradientButtonWithSize:CGSizeMake(170/2, 30) colorArray:@[(id)RGB(50, 50,50),(id)RGB(50, 50, 50)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    [self.leftBtn setTitleColor:RGB(200, 200, 200) forState:UIControlStateNormal];
    [self addChildViewController:self.notfilmedvc];
    self.notfilmedvc.view.frame = self.view.bounds;
    [self.view addSubview:self.notfilmedvc.view];
    [self.notfilmedvc didMoveToParentViewController:self];
}
/// left btn
/// @param btn left btn
-(void)actionLeftBtn:(UIButton *)btn
{
    [self.leftBtn gradientButtonWithSize:CGSizeMake(170/2, 30) colorArray:@[(id)RGB(235, 142, 63),(id)RGB(250, 204, 72)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    [self.leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.rightBtn gradientButtonWithSize:CGSizeMake(170/2, 30) colorArray:@[(id)RGB(50, 50, 50),(id)RGB(50, 50, 50)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    [self.rightBtn setTitleColor:RGB(200, 200,200) forState:UIControlStateNormal];
    [self addChildViewController:self.takenvc];
    self.takenvc.view.frame = self.view.bounds;
    [self.view addSubview:self.takenvc.view];
    [self.takenvc didMoveToParentViewController:self];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = NSC_BGThemColor;
    [self NeighborsSimpleCuteSetLeftButton:[UIImage imageNamed:TUIKitResource(@"n_main_setting")]];
    [self NeighborsSimpleCuteSetRightButton:[UIImage imageNamed:TUIKitResource(@"n_main_message")]];
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 170, 31)];
    self.topView.backgroundColor =  RGB(200, 200, 200);
    self.topView.layer.cornerRadius = 5.0f;
    self.topView.layer.masksToBounds = YES;
    self.topView.layer.borderColor = RGB(200, 200, 200).CGColor;
    self.topView.layer.borderWidth = 1.0f;
    self.leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(1, 0.5, 170/2, 30)];
    [self.leftBtn setTitle:@"SUPRISE" forState:UIControlStateNormal];
    [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.leftBtn addTarget:self action:@selector(actionLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(170/2+1, 0.5, 170/2, 30)];
    [self.rightBtn setTitle:@"POPULAR" forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.rightBtn addTarget:self action:@selector(actionRihgtBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = self.topView;
    [self.topView addSubview:self.leftBtn];
    [self.topView addSubview:self.rightBtn];
    [self.leftBtn gradientButtonWithSize:CGSizeMake(170/2, 30) colorArray:@[(id)RGB(235, 142, 63),(id)RGB(250, 204, 72)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightBtn gradientButtonWithSize:CGSizeMake(170/2, 30) colorArray:@[(id)RGB(0, 0, 0),(id)RGB(0, 0, 0)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.notfilmedvc.view];
    [self actionRihgtBtn:nil];
}
- (void)onNeighborsSimpleCuteLeftBackBtn:(UIButton *)btn
{   // zf todo 要修改的东西
    NeighborsSimpleCuteSettingOtherMainController *settingvc = [[NeighborsSimpleCuteSettingOtherMainController alloc]init];
    settingvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingvc animated:YES];
}

- (void)onNeighborsSimpleCuteRightBackBtn:(UIButton *)btn
{
    NeighborsSimpleCuteMessageMainController *messagevc = [[NeighborsSimpleCuteMessageMainController alloc]init];
    messagevc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messagevc animated:YES];
}
@end
@interface NeighborsSimpleCuteHomeVoiceController () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView  *voiceCollectionView;
@property (nonatomic,strong)NSMutableArray    *vocieListArr;
@end

@implementation NeighborsSimpleCuteHomeVoiceController
- (NSMutableArray *)vocieListArr
{
    if (!_vocieListArr) {
        _vocieListArr =[NSMutableArray array];
    }
    return _vocieListArr;
}
- (UICollectionView *)voiceCollectionView
{
    if (!_voiceCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        flow.minimumLineSpacing = 10;//行间距
        flow.minimumInteritemSpacing = 10;//列间距
        _voiceCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flow];
        _voiceCollectionView.backgroundColor = [UIColor clearColor];
        _voiceCollectionView.showsVerticalScrollIndicator = NO;
        _voiceCollectionView.showsHorizontalScrollIndicator = NO;
        _voiceCollectionView.delegate = self;
        _voiceCollectionView.dataSource = self;
        [_voiceCollectionView registerClass:[NeighborsSimpleCuteVoiceContentViewCell class] forCellWithReuseIdentifier:@"NeighborsSimpleCuteVoiceContentViewCell"];
    }
    return _voiceCollectionView;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setupVoiceData];
    [self.view addSubview:self.voiceCollectionView];
    [self.voiceCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
}

-(void)setupVoiceData{
    NSMutableDictionary *param  = [NSMutableDictionary dictionary];
    NeighborsSimpleCuteUserModel *model = [NeighborsSimpleCuteUserModel getUserInfo];
    param[@"appType"] = @"85"; //popular系统的用户列表
    param[@"clientNum"] = @"84001002";
    if (model.userInfo.gender == 0) {
        param[@"gender"] = @"0";
    }else if(model.userInfo.gender == 1){
        param[@"gender"] = @"2";
    }else if(model.userInfo.gender == 2){
        param[@"gender"] = @"1";
    }
    NSString *baseurl = [NSString stringWithFormat:@"%@%@",NSC_Base_Url,@"api/bottle/bottleList"];
    NSLog(@"param:%@",param);
    NSLog(@"baseUrl:%@",baseurl);
    [SVProgressHUD show];
    [[NeighborsSimpleCuteNetworkTool sharedNetworkTool]POST:baseurl parameters:param success:^(NeighborsSimpleCuteResposeModel * _Nonnull response) {
        NSLog(@"response.data:%@",response.data);
        [SVProgressHUD dismiss];
        if (response.code == 0) {
            [self.vocieListArr removeAllObjects];
            self.vocieListArr  = [NeighborsSimpleCuteHomeVoiceModel mj_objectArrayWithKeyValuesArray:response.data];
            NSLog(@"self.homeAllListArr.count:%lu",(unsigned long)self.vocieListArr.count);
            [self.voiceCollectionView reloadData];
        }else{
            [SVProgressHUD showInfoWithStatus:response.msg];
            return;
        }
    }failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:error.localizedDescription];
        return;
    }];
}

#pragma mark --- voiceCollectionView 代理方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.vocieListArr.count;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((IPHONE_WIDTH - 31)/2, 230);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NeighborsSimpleCuteVoiceContentViewCell *contentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NeighborsSimpleCuteVoiceContentViewCell" forIndexPath:indexPath];
    NSString *imageBaseUrl = [NSString stringWithFormat:@"%@/",[NeighborsSimpleCuteUserModel getUserInfo].appClient.spare17th];
    NeighborsSimpleCuteHomeVoiceModel *model = self.vocieListArr[indexPath.row];
    [contentCell.bgImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,model.userInfo.imgUrl]] placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
    return contentCell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NeighborsSimpleCuteHomeVoiceModel *model = self.vocieListArr[indexPath.row];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"bottleId"] = @(model.id);
    NSString *baseUrl = [NSString stringWithFormat:@"%@api/bottle/open/%@",NSC_Base_Url,@(model.id)];
    NSLog(@"param:%@",param);
    NSLog(@"baseurl:%@",baseUrl);
    NeighborsSimpleCuteVoicePlayView *playView= [[NeighborsSimpleCuteVoicePlayView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT)];
    playView.voiceModel = model;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    NSCParameterAssert(window);
    [window addSubview:playView];
    [playView setNeighborsSimpleCuteVoicePlayViewCallBlock:^{
        NeighborsSimpleCuteVideoCallView *callView = [[NeighborsSimpleCuteVideoCallView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT)];
        callView.voiceModel = model;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        NSCParameterAssert(window);
        [window addSubview:callView];
    }];
    [playView setNeighborsSimpleCuteVoicePlayViewReportBlock:^{
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Microphone enabled code‘
                    NeighborsSimpleCuteSettingFeedBackController *reportShowVc = [[NeighborsSimpleCuteSettingFeedBackController alloc]init];
                    reportShowVc.hidesBottomBarWhenPushed = YES;
                    [reportShowVc setNeighborsSimpleCuteSettingFeedBackControllerBackBlock:^{
                        playView.hidden = NO;
                    }];
                    [self.navigationController pushViewController:reportShowVc animated:YES];
                });

            } else {
            }
        }];
     
    }];
    [playView setNeighborsSimpleCuteVoicePlayViewChatBlock:^{
        // 聊天界面功能
        NeighborsSimpleCuteMessageChatMainController *messageChatvc = [[NeighborsSimpleCuteMessageChatMainController alloc]init];
        messageChatvc.hidesBottomBarWhenPushed = YES;
        NSString *imageBaseUrl = [NSString stringWithFormat:@"%@/",[NeighborsSimpleCuteUserModel getUserInfo].appClient.spare17th];
        messageChatvc.IconStr = [NSString stringWithFormat:@"%@%@",imageBaseUrl,model.userInfo.imgUrl];
        messageChatvc.NameStr = model.userInfo.nickName;
        [self.navigationController pushViewController:messageChatvc animated:YES];
    }];
    //删除功能
    [playView setNeighborsSimpleCuteVoicePlayViewDelBlock:^{
        [self.vocieListArr removeObject:model];
        [self.voiceCollectionView reloadData];
    }];
    //关闭页面功能
    [playView setNeighborsSimpleCuteVoicePlayViewCloseBlock:^{
        //[self.vocieListArr removeObject:model];
        //[self.voiceCollectionView reloadData];
    }];
//    [SVProgressHUD show];
//    [[NeighborsSimpleCuteNetworkTool sharedNetworkTool]POST:baseUrl parameters:param success:^(NeighborsSimpleCuteResposeModel *response) {
//            [SVProgressHUD dismiss];
//        if (response.code ==  0) {
//
//        }
//    }failure:^(NSError *error) {
//
//    }];
}
@end

@interface NeighborsSimpleCuteHomeMainController ()
@property (nonatomic,strong)UIImageView *titleBgView;
@property (nonatomic,strong)UIView *contentBgView;
@property (nonatomic,strong)UIImageView *contentBgImagView;
@property (nonatomic,strong)UIView *bottomBgView;
@property (nonatomic,strong)UIButton *refreshBtn;
@property (nonatomic,strong)UIButton *sortBtn;
@property (nonatomic,strong)UIButton *sendBtn;

@property (nonatomic,strong)UIView *first_view;
@property (nonatomic,strong)UIImageView *first_bg_img;
@property (nonatomic,strong)UIImageView *first_img;
@property (nonatomic,strong)UIButton *first_btn;

@property (nonatomic,strong)UIView *second_view;
@property (nonatomic,strong)UIImageView *second_bg_img;
@property (nonatomic,strong)UIImageView *second_img;
@property (nonatomic,strong)UIButton *second_btn;

@property (nonatomic,strong)UIView *third_view;
@property (nonatomic,strong)UIImageView *third_bg_img;
@property (nonatomic,strong)UIImageView *third_img;
@property (nonatomic,strong)UIButton *third_btn;

@property (nonatomic,strong)UIView *four_view;
@property (nonatomic,strong)UIImageView *four_bg_img;
@property (nonatomic,strong)UIImageView *four_img;
@property (nonatomic,strong)UIButton *four_btn;

@property (nonatomic,strong)UIView *five_view;
@property (nonatomic,strong)UIImageView *five_bg_img;
@property (nonatomic,strong)UIImageView *five_img;
@property (nonatomic,strong)UIButton *five_btn;

@property (nonatomic,strong)UIView *six_view;
@property (nonatomic,strong)UIImageView *six_bg_img;
@property (nonatomic,strong)UIImageView *six_img;
@property (nonatomic,strong)UIButton *six_btn;

@property (nonatomic,strong)UIView *seven_view;
@property (nonatomic,strong)UIImageView *seven_bg_img;
@property (nonatomic,strong)UIImageView *seven_img;
@property (nonatomic,strong)UIButton *seven_btn;

@property (nonatomic,strong)NSMutableArray *firstListArr;
@property (nonatomic,strong)NSMutableArray *secondListArr;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong)NSTimer *timer2;
@property (nonatomic,assign)NSInteger cutDown;
@property (nonatomic,assign)BOOL isRefresh;
@property (nonatomic,strong)NSMutableArray *homeAllListArr;
@property (nonatomic,strong)NSMutableArray *randomListArr;

@end

@implementation NeighborsSimpleCuteHomeMainController

- (NSMutableArray *)homeAllListArr
{
    if (!_homeAllListArr) {
        _homeAllListArr = [NSMutableArray array];
    }
    return _homeAllListArr;
}

- (NSMutableArray *)randomListArr
{
    if (!_randomListArr) {
        _randomListArr = [NSMutableArray array];
    }
    return _randomListArr;
}

- (NSMutableArray *)firstListArr
{
    if (!_firstListArr) {
        _firstListArr = [NSMutableArray array];
    }
    return  _firstListArr;
}
- (NSMutableArray *)secondListArr
{
    if (!_secondListArr) {
        _secondListArr = [NSMutableArray array];
    }
    return _secondListArr;
}
- (NSTimer *)timer2
{
    if (!_timer2) {
        _timer2 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateProgress2) userInfo:nil repeats:true];
    }
    return _timer2;
}
-(void)updateProgress2
{
    NSString *imageBaseUrl = [NSString stringWithFormat:@"%@/",[NeighborsSimpleCuteUserModel getUserInfo].appClient.spare17th];
    NSLog(@"self.cutDownself.cutDownself.cutDown:%ld",(long)self.cutDown);
    self.cutDown --;
    if (self.cutDown == 0) {
        [SVProgressHUD dismiss];
        [self.timer2 setFireDate:[NSDate distantFuture]];
        return;
    }
        if (self.homeAllListArr.count >= 7) {
            if (self.cutDown == 1) {
                self.six_view.hidden = NO;
                NeighborsSimpleCuteHomeVoiceModel *svoicemodel5 = self.homeAllListArr[5];
                [self.six_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel5.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
                if (svoicemodel5.audioUrl.length > 0) {
                    self.six_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
                }else{
                    self.six_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
                  }
            }else if(self.cutDown == 2){
                self.second_view.hidden = NO;
                NeighborsSimpleCuteHomeVoiceModel *svoicemodel2 = self.homeAllListArr[1];
                [self.second_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel2.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
                if (svoicemodel2.audioUrl.length > 0) {
                    self.second_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
                }else{
                    self.second_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
                }
            }else if(self.cutDown == 3){
                self.five_view.hidden = NO;
                NeighborsSimpleCuteHomeVoiceModel *svoicemodel4 = self.homeAllListArr[4];
                [self.five_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel4.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
                if (svoicemodel4.audioUrl.length > 0) {
                    self.five_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
                }else{
                    self.five_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
                }
            }else if(self.cutDown == 4){
                self.four_view.hidden = NO;
                NeighborsSimpleCuteHomeVoiceModel *svoicemodel3 = self.homeAllListArr[3];
                [self.four_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel3.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
                if (svoicemodel3.audioUrl.length > 0) {
                    self.four_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
                }else{
                    self.four_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
                }
            }else if(self.cutDown == 5){
                self.third_view.hidden = NO;
                NeighborsSimpleCuteHomeVoiceModel *svoicemodel2 = self.homeAllListArr[2];
                [self.third_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel2.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
                if (svoicemodel2.audioUrl.length > 0) {
                    self.third_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
                }else{
                    self.third_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
                }
            }else if(self.cutDown == 6){
                self.first_view.hidden = NO;
                NeighborsSimpleCuteHomeVoiceModel *svoicemodel1 = self.homeAllListArr[0];
                [self.first_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel1.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
                if (svoicemodel1.audioUrl.length > 0) {
                    self.first_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
                }else{
                    self.first_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
                }
            }else if(self.cutDown == 7){
                self.seven_view.hidden = NO;
                NeighborsSimpleCuteHomeVoiceModel *svoicemodel6 = self.homeAllListArr[6];
                [self.seven_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel6.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
                if (svoicemodel6.audioUrl.length > 0) {
                    self.seven_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
                }else{
                    self.seven_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
                }
            }
        }else{
             if(self.homeAllListArr.count == 1){
                 if (self.cutDown == 1) {
                     self.first_view.hidden = NO;
                     NeighborsSimpleCuteHomeVoiceModel *svoicemodel1 = self.homeAllListArr[0];
                     [self.first_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel1.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
                     if (svoicemodel1.audioUrl.length > 0) {
                         self.first_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
                     }else{
                         self.first_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
                     }
                 }
                
            }else if(self.homeAllListArr.count == 2){
                if (self.cutDown == 1) {
                    self.first_view.hidden = NO;
                    NeighborsSimpleCuteHomeVoiceModel *svoicemodel1 = self.homeAllListArr[0];
                    [self.first_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel1.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
                    if (svoicemodel1.audioUrl.length > 0) {
                        self.first_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
                    }else{
                        self.first_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
                    }
                }else if(self.cutDown ==2){
                    self.second_view.hidden = NO;
                    NeighborsSimpleCuteHomeVoiceModel *svoicemodel2 = self.homeAllListArr[1];
                    [self.second_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel2.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
                    if (svoicemodel2.audioUrl.length > 0) {
                        self.second_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
                    }else{
                        self.second_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
                    }
                }
            }else if(self.homeAllListArr.count == 3){
                if (self.cutDown == 1) {
                    self.first_view.hidden = NO;
                    NeighborsSimpleCuteHomeVoiceModel *svoicemodel1 = self.homeAllListArr[0];
                    [self.first_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel1.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
                    if (svoicemodel1.audioUrl.length > 0) {
                        self.first_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
                    }else{
                        self.first_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
                    }
                }else if(self.cutDown ==2){
                    self.second_view.hidden = NO;
                    NeighborsSimpleCuteHomeVoiceModel *svoicemodel2 = self.homeAllListArr[1];
                    [self.second_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel2.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
                    if (svoicemodel2.audioUrl.length > 0) {
                        self.second_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
                    }else{
                        self.second_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
                    }
                }else if(self.cutDown == 3){
                    self.third_view.hidden = NO;
                    NeighborsSimpleCuteHomeVoiceModel *svoicemodel3 = self.homeAllListArr[2];
                    [self.third_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel3.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
                    if (svoicemodel3.audioUrl.length > 0) {
                        self.third_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
                    }else{
                        self.third_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
                    }
                }
            }else if(self.homeAllListArr.count == 4){
                if (self.cutDown == 1) {
                    self.first_view.hidden = NO;
                    NeighborsSimpleCuteHomeVoiceModel *svoicemodel1 = self.homeAllListArr[0];
                    [self.first_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel1.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
                    if (svoicemodel1.audioUrl.length > 0) {
                        self.first_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
                    }else{
                        self.first_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
                    }
                }else if(self.cutDown ==2){
                    self.second_view.hidden = NO;
                    NeighborsSimpleCuteHomeVoiceModel *svoicemodel2 = self.homeAllListArr[1];
                    [self.second_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel2.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
                    if (svoicemodel2.audioUrl.length > 0) {
                        self.second_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
                    }else{
                        self.second_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
                    }
                }else if(self.cutDown == 3){
                    self.third_view.hidden = NO;
                    NeighborsSimpleCuteHomeVoiceModel *svoicemodel3 = self.homeAllListArr[2];
                    [self.third_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel3.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
                    if (svoicemodel3.audioUrl.length > 0) {
                        self.third_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
                    }else{
                        self.third_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
                    }
                }else if(self.cutDown == 4){
                    self.four_view.hidden = NO;
                    NeighborsSimpleCuteHomeVoiceModel *svoicemodel4 = self.homeAllListArr[3];
                    [self.four_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel4.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
                    if (svoicemodel4.audioUrl.length > 0) {
                        self.four_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
                    }else{
                        self.four_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
                    }
                }
            }else if(self.homeAllListArr.count == 5){
                if (self.cutDown == 1) {
                    self.first_view.hidden = NO;
                    NeighborsSimpleCuteHomeVoiceModel *svoicemodel1 = self.homeAllListArr[0];
                    [self.first_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel1.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
                    if (svoicemodel1.audioUrl.length > 0) {
                        self.first_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
                    }else{
                        self.first_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
                    }
                }else if(self.cutDown ==2){
                    self.second_view.hidden = NO;
                    NeighborsSimpleCuteHomeVoiceModel *svoicemodel2 = self.homeAllListArr[1];
                    [self.second_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel2.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
                    if (svoicemodel2.audioUrl.length > 0) {
                        self.second_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
                    }else{
                        self.second_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
                    }
                }else if(self.cutDown == 3){
                    self.third_view.hidden = NO;
                    NeighborsSimpleCuteHomeVoiceModel *svoicemodel3 = self.homeAllListArr[2];
                    [self.third_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel3.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
                    if (svoicemodel3.audioUrl.length > 0) {
                        self.third_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
                    }else{
                        self.third_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
                    }
                }else if(self.cutDown == 4){
                    self.four_view.hidden = NO;
                    NeighborsSimpleCuteHomeVoiceModel *svoicemodel4 = self.homeAllListArr[3];
                    [self.four_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel4.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
                    if (svoicemodel4.audioUrl.length > 0) {
                        self.four_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
                    }else{
                        self.four_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
                    }
                }else if(self.cutDown == 5){
                    self.five_view.hidden = NO;
                    NeighborsSimpleCuteHomeVoiceModel *svoicemodel5 = self.homeAllListArr[4];
                    [self.five_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel5.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
                    if (svoicemodel5.audioUrl.length > 0) {
                        self.five_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
                    }else{
                        self.five_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
                    }
                }
            }else if(self.homeAllListArr.count == 6){
                if (self.cutDown == 1) {
                    self.first_view.hidden = NO;
                    NeighborsSimpleCuteHomeVoiceModel *svoicemodel1 = self.homeAllListArr[0];
                    [self.first_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel1.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
                    if (svoicemodel1.audioUrl.length > 0) {
                        self.first_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
                    }else{
                        self.first_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
                    }
                }else if(self.cutDown ==2){
                    self.second_view.hidden = NO;
                    NeighborsSimpleCuteHomeVoiceModel *svoicemodel2 = self.homeAllListArr[1];
                    [self.second_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel2.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
                    if (svoicemodel2.audioUrl.length > 0) {
                        self.second_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
                    }else{
                        self.second_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
                    }
                }else if(self.cutDown == 3){
                    self.third_view.hidden = NO;
                    NeighborsSimpleCuteHomeVoiceModel *svoicemodel3 = self.homeAllListArr[2];
                    [self.third_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel3.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
                    if (svoicemodel3.audioUrl.length > 0) {
                        self.third_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
                    }else{
                        self.third_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
                    }
                }else if(self.cutDown == 4){
                    self.four_view.hidden = NO;
                    NeighborsSimpleCuteHomeVoiceModel *svoicemodel4 = self.homeAllListArr[3];
                    [self.four_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel4.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
                    if (svoicemodel4.audioUrl.length > 0) {
                        self.four_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
                    }else{
                        self.four_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
                    }
                }else if(self.cutDown == 5){
                    self.five_view.hidden = NO;
                    NeighborsSimpleCuteHomeVoiceModel *svoicemodel5 = self.homeAllListArr[4];
                    [self.five_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel5.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
                    if (svoicemodel5.audioUrl.length > 0) {
                        self.five_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
                    }else{
                        self.five_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
                    }
                }else if(self.cutDown == 6){
                    self.six_view.hidden = NO;
                    NeighborsSimpleCuteHomeVoiceModel *svoicemodel6 = self.homeAllListArr[5];
                    [self.six_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel6.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
                    if (svoicemodel6.audioUrl.length > 0) {
                        self.six_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
                    }else{
                        self.six_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
                    }
                }
        }
    }
    
}
-(NSTimer *)timer{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateProgress) userInfo:nil repeats:true];
    }
    return _timer;
}
-(void)updateProgress
{

}

- (UIView *)seven_view
{
    if (!_seven_view) {
        _seven_view = [[UIView alloc]init];
        _seven_view.hidden = YES;
    }
    return _seven_view;
}

- (UIImageView *)seven_bg_img
{
    if (!_seven_bg_img) {
        _seven_bg_img = [[UIImageView alloc]init];
        _seven_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
        _seven_bg_img.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _seven_bg_img;
}

- (UIImageView *)seven_img
{
    if (!_seven_img) {
        _seven_img = [[UIImageView alloc]init];
        _seven_img.image = [UIImage imageNamed:TUIKitResource(@"test")];
        _seven_img.contentMode = UIViewContentModeScaleAspectFill;
        _seven_img.layer.cornerRadius = 15.0f;
        _seven_img.layer.masksToBounds = YES;
    }
    return _seven_img;
}
- (UIButton *)seven_btn
{
    if (!_seven_btn) {
        _seven_btn = [[UIButton alloc]init];
        [_seven_btn addTarget:self action:@selector(actionactionPlayVoiceBtnBtn:) forControlEvents:UIControlEventTouchUpInside];
        _seven_btn.tag = 6;
    }
    return _seven_btn;
}

- (UIView *)six_view
{
    if (!_six_view) {
        _six_view = [[UIView alloc]init];
        _six_view.hidden = YES;
    }
    return _six_view;
}

- (UIImageView *)six_bg_img
{
    if (!_six_bg_img) {
        _six_bg_img = [[UIImageView alloc]init];
        _six_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
        _six_bg_img.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _six_bg_img;
}

- (UIImageView *)six_img
{
    if (!_six_img) {
        _six_img = [[UIImageView alloc]init];
        _six_img.image = [UIImage imageNamed:TUIKitResource(@"test")];
        _six_img.contentMode = UIViewContentModeScaleAspectFill;
        _six_img.layer.cornerRadius = 15.0f;
        _six_img.layer.masksToBounds = YES;
    }
    return _six_img;
}

- (UIButton *)six_btn
{
    if (!_six_btn) {
        _six_btn = [[UIButton alloc]init];
        [_six_btn addTarget:self action:@selector(actionactionPlayVoiceBtnBtn:) forControlEvents:UIControlEventTouchUpInside];
        _six_btn.tag = 5;
    }
    return _six_btn;
}

- (UIView *)five_view
{
    if (!_five_view) {
        _five_view = [[UIView alloc]init];
        _five_view.hidden = YES;
    }
    return _five_view;
}
- (UIImageView *)five_bg_img
{
    if (!_five_bg_img) {
        _five_bg_img = [[UIImageView alloc]init];
        _five_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
        _five_bg_img.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _five_bg_img;
}

- (UIImageView *)five_img
{
    if (!_five_img) {
        _five_img = [[UIImageView alloc]init];
        _five_img.image = [UIImage imageNamed:TUIKitResource(@"test")];
        _five_img.contentMode = UIViewContentModeScaleAspectFill;
        _five_img.layer.cornerRadius = 15.0f;
        _five_img.layer.masksToBounds = YES;
    }
    return _five_img;
}

- (UIButton *)five_btn
{
    if (!_five_btn) {
        _five_btn = [[UIButton alloc]init];
        [_five_btn addTarget:self action:@selector(actionactionPlayVoiceBtnBtn:) forControlEvents:UIControlEventTouchUpInside];
        _five_btn.tag = 4;
    }
    return _five_btn;
}

- (UIView *)four_view
{
    if (!_four_view) {
        _four_view = [[UIView alloc]init];
        _four_view.hidden = YES;
    }
    return _four_view;
}
- (UIImageView *)four_bg_img
{
    if (!_four_bg_img) {
        _four_bg_img = [[UIImageView alloc]init];
        _four_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
        _four_bg_img.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _four_bg_img;
}

- (UIImageView *)four_img
{
    if (!_four_img) {
        _four_img = [[UIImageView alloc]init];
        _four_img.image = [UIImage imageNamed:TUIKitResource(@"test")];
        _four_img.contentMode = UIViewContentModeScaleAspectFill;
        _four_img.layer.cornerRadius = 15.0f;
        _four_img.layer.masksToBounds = YES;
    }
    return _four_img;
}
- (UIButton *)four_btn
{
    if (!_four_btn) {
        _four_btn = [[UIButton alloc]init];
        [_four_btn addTarget:self action:@selector(actionactionPlayVoiceBtnBtn:) forControlEvents:UIControlEventTouchUpInside];
        _four_btn.tag = 3;
    }
    return _four_btn;
}


- (UIView *)third_view
{
    if (!_third_view) {
        _third_view = [[UIView alloc]init];
        _third_view.hidden = YES;
    }
    return _third_view;
}
- (UIImageView *)third_bg_img
{
    if (!_third_bg_img) {
        _third_bg_img = [[UIImageView alloc]init];
        _third_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
        _third_bg_img.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _third_bg_img;
}

- (UIImageView *)third_img
{
    if (!_third_img) {
        _third_img = [[UIImageView alloc]init];
        _third_img.image = [UIImage imageNamed:TUIKitResource(@"test")];
        _third_img.contentMode = UIViewContentModeScaleAspectFill;
        _third_img.layer.cornerRadius = 15.0f;
        _third_img.layer.masksToBounds = YES;
    }
    return _third_img;
}

- (UIButton *)third_btn
{
    if (!_third_btn) {
        _third_btn = [[UIButton alloc]init];
        [_third_btn addTarget:self action:@selector(actionactionPlayVoiceBtnBtn:) forControlEvents:UIControlEventTouchUpInside];
        _third_btn.tag = 2;
    }
    return _third_btn;
}

- (UIView *)second_view
{
    if (!_second_view) {
        _second_view = [[UIView alloc]init];
        _second_view.hidden = YES;
    }
    return _second_view;
}

- (UIImageView *)second_bg_img
{
    if (!_second_bg_img) {
        _second_bg_img = [[UIImageView alloc]init];
        _second_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
        _second_bg_img.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _second_bg_img;
}

- (UIImageView *)second_img
{
    if (!_second_img) {
        _second_img = [[UIImageView alloc]init];
        _second_img.image = [UIImage imageNamed:TUIKitResource(@"test")];
        _second_img.contentMode = UIViewContentModeScaleAspectFill;
        _second_img.layer.cornerRadius = 15.0f;
        _second_img.layer.masksToBounds = YES;
    }
    return _second_img;
}

- (UIButton *)second_btn
{
    if (!_second_btn) {
        _second_btn = [[UIButton alloc]init];
        [_second_btn addTarget:self action:@selector(actionactionPlayVoiceBtnBtn:) forControlEvents:UIControlEventTouchUpInside];
        _second_btn.tag = 1;
    }
    return _second_btn;
}
-(void)actionactionPlayVoiceBtn:(UIButton *)btn
{
    NSLog(@"actionactionPlayVoiceBtnactionactionPlayVoiceBtn");
}
- (UIView *)first_view
{
    if (!_first_view) {
        _first_view = [[UIView alloc]init];
        _first_view.hidden = YES;
    }
    return _first_view;
}

- (UIImageView *)first_bg_img
{
    if (!_first_bg_img) {
        _first_bg_img = [[UIImageView alloc]init];
        _first_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
        _first_bg_img.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _first_bg_img;
}

- (UIImageView *)first_img
{
    if (!_first_img) {
        _first_img = [[UIImageView alloc]init];
        _first_img.image = [UIImage imageNamed:TUIKitResource(@"test")];
        _first_img.contentMode = UIViewContentModeScaleAspectFill;
        _first_img.layer.cornerRadius = 15.0f;
        _first_img.layer.masksToBounds = YES;
    }
    return _first_img;
}

- (UIButton *)first_btn
{
    if (!_first_btn) {
        _first_btn = [[UIButton alloc]init];
        [_first_btn addTarget:self action:@selector(actionactionPlayVoiceBtnBtn:) forControlEvents:UIControlEventTouchUpInside];
        _first_btn.tag = 0;
    }
    return _first_btn;
}
- (UIImageView *)contentBgImagView
{
    if (!_contentBgImagView) {
        _contentBgImagView = [[UIImageView alloc]init];
        _contentBgImagView.image = [UIImage imageNamed:TUIKitResource(@"n_piaoliup_bg")];
    }
    return _contentBgImagView;
}

- (UIView *)contentBgView
{
    if (!_contentBgView) {
        _contentBgView = [[UIView alloc]init];
        _contentBgView.backgroundColor = [UIColor clearColor];
    }
    return _contentBgView;
}
- (UIView *)bottomBgView
{
    if (!_bottomBgView) {
        _bottomBgView = [[UIView alloc]init];
        _bottomBgView.backgroundColor = RGB(50, 50, 50);
        _bottomBgView.layer.cornerRadius = 25.0f;
        _bottomBgView.layer.masksToBounds = YES;
    }
    return _bottomBgView;
}

- (UIButton *)refreshBtn
{
    if (!_refreshBtn) {
        _refreshBtn = [[UIButton alloc]init];
        [_refreshBtn setImage:[UIImage imageNamed:TUIKitResource(@"n_main_search")] forState:UIControlStateNormal];
        [_refreshBtn addTarget:self action:@selector(actionHomeRefresh:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshBtn;
}
-(void)actionHomeRefresh:(UIButton *)sender
{
    NSMutableDictionary *param  = [NSMutableDictionary dictionary];
    NeighborsSimpleCuteUserModel *model = [NeighborsSimpleCuteUserModel getUserInfo];
    param[@"appType"] = @"85"; //是suprise系统的，这个系统如果修改apptype需要修改两个地方。
    param[@"clientNum"] = @"84001002";
    if (model.userInfo.gender == 0) {
        param[@"gender"] = @"0";
    }else if(model.userInfo.gender == 1){
        param[@"gender"] = @"2";
    }else if(model.userInfo.gender == 2){
        param[@"gender"] = @"1";
    }
    NSString *baseurl = [NSString stringWithFormat:@"%@%@",NSC_Base_Url,@"api/bottle/bottleList"];
    NSLog(@"param:%@",param);
    NSLog(@"baseUrl:%@",baseurl);
    [SVProgressHUD show];
    [[NeighborsSimpleCuteNetworkTool sharedNetworkTool]POST:baseurl parameters:param success:^(NeighborsSimpleCuteResposeModel * _Nonnull response) {
        NSLog(@"response.data:%@",response.data);
        [SVProgressHUD dismiss];
        if (response.code == 0) {
            NSMutableArray *array = [NSMutableArray array];
            [self.homeAllListArr removeAllObjects];
            [self.randomListArr removeAllObjects];
            array = [NeighborsSimpleCuteHomeVoiceModel mj_objectArrayWithKeyValuesArray:response.data];
            NSLog(@"self.homeAllListArr.count:%lu",(unsigned long)array.count);
            self.first_view.hidden = YES;
            self.second_view.hidden = YES;
            self.third_view.hidden = YES;
            self.four_view.hidden = YES;
            self.five_view.hidden = YES;
            self.six_view.hidden = YES;
            self.seven_view.hidden = YES;
            if (array.count >=7) {
                for (int i = 0; i<7; i++) {
                    int index = arc4random() % (array.count);
                    NSString *indexStr = nil;
                    indexStr = [NSString stringWithFormat:@"%d",index];
                    while ([self.randomListArr containsObject:indexStr]) {
                        int index = arc4random() % (array.count);
                        indexStr = [NSString stringWithFormat:@"%d",index];
                    }
                    [self.randomListArr addObject:indexStr];
                    NSLog(@"homeAllListArr:snum:%@",indexStr);
                    int tagtalTag = [indexStr intValue];
                    [self.homeAllListArr addObject:array[tagtalTag]];
                }
                [SVProgressHUD show];
                self.cutDown = 9;
            }else{
                [self.homeAllListArr addObjectsFromArray:array];
                [SVProgressHUD show];
                if (array.count == 0) {
                    [SVProgressHUD dismiss];
                    return;
                }else if(array.count == 1){
                    self.cutDown = 3;
                }else if(array.count == 2){
                    self.cutDown = 4;
                }else if(array.count == 3){
                    self.cutDown = 5;
                }else if(array.count == 4){
                    self.cutDown = 6;
                }else if(array.count == 5){
                    self.cutDown = 7;
                }else if(array.count == 6){
                    self.cutDown = 8;
                }
            }
            self.timer2.fireDate=[NSDate distantPast];
        }else{
            [SVProgressHUD showInfoWithStatus:response.msg];
            return;
        }
    }failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:error.localizedDescription];
        return;
    }];
}
- (UIButton *)sortBtn
{
    if (!_sortBtn) {
        _sortBtn = [[UIButton alloc]init];
        [_sortBtn setImage:[UIImage imageNamed:TUIKitResource(@"n_main_list")] forState:UIControlStateNormal];
        [_sortBtn addTarget:self action:@selector(actionHomeSort) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sortBtn;
}

-(void)actionHomeSort
{
    NSLog(@"actionHomeSort");
    NeighborsSimpleCuteVoiceListController *voiceListvc = [[NeighborsSimpleCuteVoiceListController alloc]init];
    voiceListvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:voiceListvc animated:YES];
}

- (UIButton *)sendBtn
{
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc]init];
        [_sendBtn setImage:[UIImage imageNamed:TUIKitResource(@"n_main_voice")] forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(actionSendBtn) forControlEvents:UIControlEventTouchUpInside];
        _sendBtn.layer.cornerRadius = 30.0f;
        _sendBtn.layer.masksToBounds = YES;
        [_sendBtn gradientButtonWithSize:CGSizeMake(60, 60) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 63)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    }
    return _sendBtn;
}

-(void)actionSendBtn
{
    NSLog(@"actionSendBtnactionSendBtnactionSendBtn");
    NeighborsSimpleCuteVoiceShowView *voiceShowView = [[NeighborsSimpleCuteVoiceShowView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT)];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    NSCParameterAssert(window);
    [window addSubview:voiceShowView];
}
- (UIImageView *)titleBgView
{
    if (!_titleBgView) {
        _titleBgView = [[UIImageView alloc]init];
        _titleBgView.image = [UIImage imageNamed:TUIKitResource(@"hooilbiaoti")];
        _titleBgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _titleBgView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = NSC_MainThemColor;
    self.navigationItem.titleView = self.titleBgView;
    self.isRefresh = YES;
    [self NeighborsSimpleCuteSetLeftButton:[UIImage imageNamed:TUIKitResource(@"n_main_setting")]];
    [self NeighborsSimpleCuteSetRightButton:[UIImage imageNamed:TUIKitResource(@"n_main_message")]];
    [self setupUI];
    [self actionHomeData];
}

-(void)actionHomeData
{
    NSMutableDictionary *param  = [NSMutableDictionary dictionary];
    NeighborsSimpleCuteUserModel *model = [NeighborsSimpleCuteUserModel getUserInfo];
    param[@"appType"] = @"85";//是suprise系统的，这个系统如果修改apptype需要修改两个地方。
    param[@"clientNum"] = @"81002001";
    if (model.userInfo.gender == 0) {
        param[@"gender"] = @"0";
    }else if(model.userInfo.gender == 1){
        param[@"gender"] = @"2";
    }else if(model.userInfo.gender == 2){
        param[@"gender"] = @"1";
    }
    NSString *baseurl = [NSString stringWithFormat:@"%@%@",NSC_Base_Url,@"api/bottle/bottleList"];
    NSLog(@"param:%@",param);
    NSLog(@"baseUrl:%@",baseurl);
    [SVProgressHUD show];
    [[NeighborsSimpleCuteNetworkTool sharedNetworkTool]POST:baseurl parameters:param success:^(NeighborsSimpleCuteResposeModel * _Nonnull response) {
        NSLog(@"response.data:%@",response.data);
        [SVProgressHUD dismiss];
        if (response.code == 0) {
            self.first_view.hidden = YES;
            self.second_view.hidden = YES;
            self.third_view.hidden = YES;
            self.four_view.hidden = YES;
            self.five_view.hidden = YES;
            self.six_view.hidden = YES;
            self.seven_view.hidden = YES;
            [self.homeAllListArr removeAllObjects];
            self.homeAllListArr  = [NeighborsSimpleCuteHomeVoiceModel mj_objectArrayWithKeyValuesArray:response.data];
            NSLog(@"self.homeAllListArr.count:%lu",(unsigned long)self.homeAllListArr.count);
            [self actionSetHomeData];
        }else{
            [SVProgressHUD showInfoWithStatus:response.msg];
            return;
        }
    }failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:error.localizedDescription];
        return;
    }];
}
-(void)actionSetHomeData
{   NSString *imageBaseUrl = [NSString stringWithFormat:@"%@/",[NeighborsSimpleCuteUserModel getUserInfo].appClient.spare17th];
    if (self.homeAllListArr.count >= 7) {
    self.first_view.hidden = NO;
    NeighborsSimpleCuteHomeVoiceModel *svoicemodel0 = self.homeAllListArr[0];
    [self.first_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel0.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
    if (svoicemodel0.audioUrl.length > 0) {
        self.first_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
    }else{
        self.first_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
    }
    self.second_view.hidden = NO;
    NeighborsSimpleCuteHomeVoiceModel *svoicemodel1 = self.homeAllListArr[1];
    [self.second_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel1.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
    if (svoicemodel1.audioUrl.length > 0) {
        self.second_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
    }else{
        self.second_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
    }
    self.third_view.hidden = NO;
    NeighborsSimpleCuteHomeVoiceModel *svoicemodel2 = self.homeAllListArr[2];
    [self.third_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel2.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
    if (svoicemodel2.audioUrl.length > 0) {
        self.third_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
    }else{
        self.third_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
    }
    self.four_view.hidden = NO;
    NeighborsSimpleCuteHomeVoiceModel *svoicemodel3 = self.homeAllListArr[3];
    [self.four_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel3.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
    if (svoicemodel3.audioUrl.length > 0) {
        self.four_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
    }else{
        self.four_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
    }
    self.five_view.hidden = NO;
    NeighborsSimpleCuteHomeVoiceModel *svoicemodel4 = self.homeAllListArr[4];
    [self.five_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel4.userInfo.imgUrl]]];
    if (svoicemodel4.audioUrl.length > 0) {
        self.five_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
    }else{
        self.five_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
    }
    self.six_view.hidden = NO;
    NeighborsSimpleCuteHomeVoiceModel *svoicemodel5 = self.homeAllListArr[5];
    [self.six_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel5.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
    if (svoicemodel5.audioUrl.length > 0) {
        self.six_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
    }else{
        self.six_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
    }
    self.seven_view.hidden = NO;
    NeighborsSimpleCuteHomeVoiceModel *svoicemodel6 = self.homeAllListArr[6];
    [self.seven_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel6.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
    if (svoicemodel6.audioUrl.length > 0) {
        self.seven_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
    }else{
        self.seven_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
    }
}else{
     if(self.homeAllListArr.count == 1){
         self.first_view.hidden = NO;
         NeighborsSimpleCuteHomeVoiceModel *svoicemodel1 = self.homeAllListArr[0];
         [self.first_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel1.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
         if (svoicemodel1.audioUrl.length > 0) {
             self.first_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
         }else{
             self.first_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
         }
    }else if(self.homeAllListArr.count == 2){
        self.first_view.hidden = NO;
        NeighborsSimpleCuteHomeVoiceModel *svoicemodel0 = self.homeAllListArr[0];
        [self.first_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel0.userInfo.imgUrl]]];
        if (svoicemodel0.audioUrl.length > 0) {
            self.first_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
        }else{
            self.first_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
        }
        self.second_view.hidden = NO;
        NeighborsSimpleCuteHomeVoiceModel *svoicemodel1 = self.homeAllListArr[1];
        [self.second_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel1.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
        if (svoicemodel1.audioUrl.length > 0) {
            self.second_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
        }else{
            self.second_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
        }
    }else if(self.homeAllListArr.count == 3){
        self.first_view.hidden = NO;
        NeighborsSimpleCuteHomeVoiceModel *svoicemodel0 = self.homeAllListArr[0];
        [self.first_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel0.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
        if (svoicemodel0.audioUrl.length > 0) {
            self.first_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
        }else{
            self.first_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
        }
        self.second_view.hidden = NO;
        NeighborsSimpleCuteHomeVoiceModel *svoicemodel1 = self.homeAllListArr[1];
        [self.second_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel1.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
        if (svoicemodel1.audioUrl.length > 0) {
            self.second_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
        }else{
            self.second_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
        }
        self.third_view.hidden = NO;
        NeighborsSimpleCuteHomeVoiceModel *svoicemodel2 = self.homeAllListArr[2];
        [self.third_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel2.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
        if (svoicemodel2.audioUrl.length > 0) {
            self.third_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
        }else{
            self.third_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
        }
    }else if(self.homeAllListArr.count == 4){
        self.first_view.hidden = NO;
        NeighborsSimpleCuteHomeVoiceModel *svoicemodel0 = self.homeAllListArr[0];
        [self.first_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel0.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
        if (svoicemodel0.audioUrl.length > 0) {
            self.first_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
        }else{
            self.first_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
        }
        self.second_view.hidden = NO;
        NeighborsSimpleCuteHomeVoiceModel *svoicemodel1 = self.homeAllListArr[1];
        [self.second_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel1.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
        if (svoicemodel1.audioUrl.length > 0) {
            self.second_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
        }else{
            self.second_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
        }
        self.third_view.hidden = NO;
        NeighborsSimpleCuteHomeVoiceModel *svoicemodel2 = self.homeAllListArr[2];
        [self.third_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel2.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
        if (svoicemodel2.audioUrl.length > 0) {
            self.third_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
        }else{
            self.third_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
        }
        self.four_view.hidden = NO;
        NeighborsSimpleCuteHomeVoiceModel *svoicemodel3 = self.homeAllListArr[3];
        [self.four_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel3.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
        if (svoicemodel3.audioUrl.length > 0) {
            self.four_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
        }else{
            self.four_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
        }
    }else if(self.homeAllListArr.count == 5){
        self.first_view.hidden = NO;
        NeighborsSimpleCuteHomeVoiceModel *svoicemodel0 = self.homeAllListArr[0];
        [self.first_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel0.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
        if (svoicemodel0.audioUrl.length > 0) {
            self.first_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
        }else{
            self.first_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
        }
        self.second_view.hidden = NO;
        NeighborsSimpleCuteHomeVoiceModel *svoicemodel1 = self.homeAllListArr[1];
        [self.second_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel1.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
        if (svoicemodel1.audioUrl.length > 0) {
            self.second_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
        }else{
            self.second_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
        }
        self.third_view.hidden = NO;
        NeighborsSimpleCuteHomeVoiceModel *svoicemodel2 = self.homeAllListArr[2];
        [self.third_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel2.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
        if (svoicemodel2.audioUrl.length > 0) {
            self.third_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
        }else{
            self.third_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
        }
        self.four_view.hidden = NO;
        NeighborsSimpleCuteHomeVoiceModel *svoicemodel3 = self.homeAllListArr[3];
        [self.four_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel3.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
        if (svoicemodel3.audioUrl.length > 0) {
            self.four_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
        }else{
            self.four_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
        }

        self.five_view.hidden = NO;
        NeighborsSimpleCuteHomeVoiceModel *svoicemodel4 = self.homeAllListArr[4];
        [self.five_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel4.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
        if (svoicemodel4.audioUrl.length > 0) {
            self.five_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
        }else{
            self.five_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
        }

    }else if(self.homeAllListArr.count == 6){
        self.first_view.hidden = NO;
        NeighborsSimpleCuteHomeVoiceModel *svoicemodel0 = self.homeAllListArr[0];
        [self.first_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel0.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
        if (svoicemodel0.audioUrl.length > 0) {
            self.first_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
        }else{
            self.first_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
        }
        self.second_view.hidden = NO;
        NeighborsSimpleCuteHomeVoiceModel *svoicemodel1 = self.homeAllListArr[1];
        [self.second_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel1.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
        if (svoicemodel1.audioUrl.length > 0) {
            self.second_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
        }else{
            self.second_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
        }
        self.third_view.hidden = NO;
        NeighborsSimpleCuteHomeVoiceModel *svoicemodel2 = self.homeAllListArr[2];
        [self.third_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel2.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
        if (svoicemodel2.audioUrl.length > 0) {
            self.third_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
        }else{
            self.third_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
        }
        self.four_view.hidden = NO;
        NeighborsSimpleCuteHomeVoiceModel *svoicemodel3 = self.homeAllListArr[3];
        [self.four_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel3.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
        if (svoicemodel3.audioUrl.length > 0) {
            self.four_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
        }else{
            self.four_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
        }

        self.five_view.hidden = NO;
        NeighborsSimpleCuteHomeVoiceModel *svoicemodel4 = self.homeAllListArr[4];
        [self.five_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel4.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
        if (svoicemodel4.audioUrl.length > 0) {
            self.five_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
        }else{
            self.five_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
        }
        self.six_view.hidden = NO;
        NeighborsSimpleCuteHomeVoiceModel *svoicemodel5 = self.homeAllListArr[5];
        [self.six_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseUrl,svoicemodel5.userInfo.imgUrl]]placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg")]];
        if (svoicemodel5.audioUrl.length > 0) {
            self.six_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg")];
        }else{
            self.six_bg_img.image = [UIImage imageNamed:TUIKitResource(@"n_cityuserback_bg2")];
          }
        }
    }
}

-(void)setupUI
{
    [self.view addSubview:self.contentBgView];
    [self.contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).offset(-50);
        make.left.right.offset(0);
        make.height.offset(460);
    }];
    [self.contentBgView addSubview:self.contentBgImagView];
    [self.contentBgImagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.offset(50);
    }];
    [self.contentBgView addSubview:self.second_view];
    [self.second_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view).offset(-3);
        make.top.offset(5);
        make.width.offset(135);
        make.height.offset(50);
    }];
    [self.second_view addSubview:self.second_bg_img];
    [self.second_bg_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.offset(0);
    }];
    [self.second_view addSubview:self.second_img];
    [self.second_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.mas_equalTo(self.second_view).offset(-5);
        make.width.height.offset(30);
    }];
    [self.second_view addSubview:self.second_btn];
    [self.second_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.offset(0);
    }];
 
    [self.contentBgView addSubview:self.first_view];
    [self.first_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentBgView).offset(-115);
        make.top.mas_equalTo(self.second_view.mas_bottom).offset(-8);
        make.width.offset(135);
        make.height.offset(50);
    }];
    [self.first_view addSubview:self.first_bg_img];
    [self.first_bg_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    [self.first_view addSubview:self.first_img];
    [self.first_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.mas_equalTo(self.first_view).offset(-5);
        make.width.height.offset(30);
    }];
    [self.first_view addSubview:self.first_btn];
    [self.first_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    
    [self.contentBgView addSubview:self.third_view];
    [self.third_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentBgView).offset(95);
        make.top.mas_equalTo(self.second_view.mas_bottom).offset(15);
        make.width.offset(135);
        make.height.offset(50);
    }];
    
    [self.third_view addSubview:self.third_bg_img];
    [self.third_bg_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    [self.third_view addSubview:self.third_img];
    [self.third_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.mas_equalTo(self.third_view).offset(-5);
        make.width.height.offset(30);
    }];
    [self.third_view addSubview:self.third_btn];
    [self.third_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    
    [self.contentBgView addSubview:self.four_view];
    [self.four_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentBgView).offset(40);
        make.top.mas_equalTo(self.third_view.mas_bottom).offset(60);
        make.width.offset(135);
        make.height.offset(50);
    }];
    
    [self.four_view addSubview:self.four_bg_img];
    [self.four_bg_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    [self.four_view addSubview:self.four_img];
    [self.four_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.mas_equalTo(self.four_view).offset(-5);
        make.width.height.offset(30);
    }];
    [self.four_view addSubview:self.four_btn];
    [self.four_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    
    
    [self.contentBgView addSubview:self.five_view];
    [self.five_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentBgView).offset(-115);
        make.top.mas_equalTo(self.four_view.mas_bottom).offset(70);
        make.width.offset(135);
        make.height.offset(50);
    }];
    
    [self.five_view addSubview:self.five_bg_img];
    [self.five_bg_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    [self.five_view addSubview:self.five_img];
    [self.five_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.mas_equalTo(self.five_view).offset(-5);
        make.width.height.offset(30);
    }];
    [self.five_view addSubview:self.five_btn];
    [self.five_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    

    [self.contentBgView addSubview:self.six_view];
    [self.six_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentBgView).offset(95);
        make.top.mas_equalTo(self.four_view.mas_bottom).offset(60);
        make.width.offset(135);
        make.height.offset(50);
    }];
    
    [self.six_view addSubview:self.six_bg_img];
    [self.six_bg_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    [self.six_view addSubview:self.six_img];
    [self.six_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.mas_equalTo(self.six_view).offset(-5);
        make.width.height.offset(30);
    }];
    [self.six_view addSubview:self.six_btn];
    [self.six_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    
    
    [self.contentBgView addSubview:self.seven_view];
    [self.seven_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentBgView);
        make.bottom.mas_equalTo(self.contentBgView.mas_bottom).offset(-30);
        make.width.offset(135);
        make.height.offset(50);
    }];
    
    
    [self.seven_view addSubview:self.seven_bg_img];
    [self.seven_bg_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    [self.seven_view addSubview:self.seven_img];
    [self.seven_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.mas_equalTo(self.seven_view).offset(-5);
        make.width.height.offset(30);
    }];
    [self.seven_view addSubview:self.seven_btn];
    [self.seven_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    
    [self.view addSubview:self.bottomBgView];
    [self.bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.offset(-Height_X - 30);
        make.width.offset(240);
        make.height.offset(50);
    }];
        
    
    
    [self.bottomBgView addSubview:self.refreshBtn];
    [self.refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bottomBgView);
        make.left.offset(20);
    }];
    [self.bottomBgView addSubview:self.sortBtn];
    [self.sortBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bottomBgView);
        make.right.offset(-20);
    }];
    [self.view addSubview:self.sendBtn];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.bottomBgView);
        make.width.height.offset(60);
    }];
}

-(void)actionactionPlayVoiceBtnBtn:(UIButton *)sender
{
    int tag = (int)sender.tag;
    NSLog(@"tag:%d",tag);
    NeighborsSimpleCuteHomeVoiceModel *voicemodel = nil;
    voicemodel = self.homeAllListArr[tag];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"bottleId"] = @(voicemodel.id);
    NSString *baseUrl = [NSString stringWithFormat:@"%@api/bottle/open/%@",NSC_Base_Url,@(voicemodel.id)];
    NSLog(@"param:%@",param);
    NSLog(@"baseurl:%@",baseUrl);
    [SVProgressHUD show];
    [[NeighborsSimpleCuteNetworkTool sharedNetworkTool]POST:baseUrl parameters:param success:^(NeighborsSimpleCuteResposeModel *response) {
        [SVProgressHUD dismiss];
        if (response.code == 0) {
            [self actionHomeHiddenWithTag:tag];
            NeighborsSimpleCuteVoicePlayView *playView = [[NeighborsSimpleCuteVoicePlayView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT)];
            playView.voiceModel = voicemodel;
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            NSCParameterAssert(window);
            [window addSubview:playView];
            [playView setNeighborsSimpleCuteVoicePlayViewDelBlock:^{
                if (tag == 0) {
                    self.first_view.hidden = YES;
                }else if(tag == 1){
                    self.second_view.hidden = YES;
                }else if(tag == 2){
                    self.third_view.hidden = YES;
                }else if(tag == 3){
                    self.four_view.hidden = YES;
                }else if(tag == 4){
                    self.five_view.hidden = YES;
                }else if(tag == 5){
                    self.six_view.hidden = YES;
                    }
            }];
            [playView setNeighborsSimpleCuteVoicePlayViewReportBlock:^{
                NeighborsSimpleCuteSettingFeedBackController *reportShowVc = [[NeighborsSimpleCuteSettingFeedBackController alloc]init];
                reportShowVc.hidesBottomBarWhenPushed = YES;
                [reportShowVc setNeighborsSimpleCuteSettingFeedBackControllerBackBlock:^{
                    playView.hidden = NO;
                }];
                [self.navigationController pushViewController:reportShowVc animated:YES];
            }];
            [playView setNeighborsSimpleCuteVoicePlayViewCallBlock:^{
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                            if (granted) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    NeighborsSimpleCuteVideoCallView *callView = [[NeighborsSimpleCuteVideoCallView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT)];
                                    callView.voiceModel = voicemodel;
                                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                                    NSCParameterAssert(window);
                                    [window addSubview:callView];
                                });
                
                            } else {
                                // [self showPhoto];
                                // Microphone disabled code
                            }
                        }];
            }];
            
            [playView setNeighborsSimpleCuteVoicePlayViewChatBlock:^{
                //聊天界面功能
                NeighborsSimpleCuteMessageChatMainController *messageChatvc =  [[NeighborsSimpleCuteMessageChatMainController alloc]init];
                messageChatvc.hidesBottomBarWhenPushed = YES;
                NSString *imageBaseUrl = [NSString stringWithFormat:@"%@/",[NeighborsSimpleCuteUserModel getUserInfo].appClient.spare17th];
                messageChatvc.IconStr = [NSString stringWithFormat:@"%@%@",imageBaseUrl,voicemodel.userInfo.imgUrl];
                messageChatvc.NameStr = voicemodel.userInfo.nickName;
                [self.navigationController pushViewController:messageChatvc animated:YES];
//                NeighborsSimpleCuteSendMessageController *reportShowVc = [[NeighborsSimpleCuteSendMessageController alloc]init];
//                reportShowVc.hidesBottomBarWhenPushed = YES;
//                [reportShowVc setNeighborsSimpleCuteReportControllerMessageBlock:^{
//                    playView.hidden = NO;
//                }];
//                [self.navigationController pushViewController:reportShowVc animated:YES];
            }];
        }
    }failure:^(NSError *error) {
            
    }];
}

-(void)actionHomeHiddenWithTag:(int )tag
{
    if (tag == 0) {
        self.first_view.hidden = YES;
    }else if(tag == 1){
        self.second_view.hidden = YES;
    }else if(tag == 2){
        self.third_view.hidden = YES;
    }else if(tag == 3){
        self.four_view.hidden = YES;
    }else if(tag == 4){
        self.five_view.hidden = YES;
    }else if(tag == 5){
        self.six_view.hidden = YES;
    }else if(tag == 6){
        self.seven_view.hidden = YES;
    }
}

- (void)onNeighborsSimpleCuteLeftBackBtn:(UIButton *)btn
{
    NeighborsSimpleCuteSettingMainController *settingvc = [[NeighborsSimpleCuteSettingMainController alloc]init];
    settingvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingvc animated:YES];
}
- (void)onNeighborsSimpleCuteRightBackBtn:(UIButton *)btn
{
    NeighborsSimpleCuteMessageMainController *messagevc = [[NeighborsSimpleCuteMessageMainController alloc]init];
    messagevc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messagevc animated:YES];
}
@end

@interface NeighborsSimpleCuteVoiceContentViewCell()

@end

@implementation NeighborsSimpleCuteVoiceContentViewCell


- (UIImageView *)bgImg
{
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc]init];
        _bgImg.image = [UIImage imageNamed:TUIKitResource(@"test")];
        _bgImg.contentMode = UIViewContentModeScaleAspectFill;
        _bgImg.layer.cornerRadius = 10.0f;
        _bgImg.layer.masksToBounds = YES;
    }
    return _bgImg;
}
- (UIView *)showView
{
    if (!_showView) {
        _showView = [[UIView alloc]init];
        _showView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        _showView.layer.cornerRadius = 10.0f;
        _showView.layer.masksToBounds = YES;
    }
    return _showView;
}

- (UIImageView *)showImg
{
    if (!_showImg) {
        _showImg = [[UIImageView alloc]init];
        _showImg.image = [UIImage imageNamed:TUIKitResource(@"wokovoicelisticontwose")];
    }
    return _showImg;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    [self addSubview:self.bgImg];
    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.bottom.offset(0);
    }];
    
    [self addSubview:self.showView];
    [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.bottom.offset(0);
    }];
    [self addSubview:self.showImg];
    [self.showImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.bgImg);
    }];
}
@end

@interface NeighborsSimpleCuteExploreContentViewCell ()

/*
 @property (nonatomic,strong)UIView *bgView;

 @property (nonatomic,strong)UIButton *callBtn;

 @property (nonatomic,strong)UIImageView *bgImg;

 @property (nonatomic,strong)UIImageView *apperaView;

 @property (nonatomic,strong)UIImageView *showImg;

 */
@end

@implementation NeighborsSimpleCuteExploreContentViewCell


- (UIImageView *)bgImg
{
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc]init];
        _bgImg.image = [UIImage imageNamed:TUIKitResource(@"test")];
        _bgImg.contentMode = UIViewContentModeScaleAspectFill;
        _bgImg.layer.cornerRadius = 10.0f;
        _bgImg.layer.masksToBounds = YES;
        _bgImg.layer.borderColor = RGB(255, 181, 0).CGColor;
        _bgImg.layer.borderWidth = 1.0;
    }
    return _bgImg;
}
- (UIView *)showView
{
    if (!_showView) {
        _showView = [[UIView alloc]init];
        _showView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        _showView.layer.cornerRadius = 10.0f;
        _showView.layer.masksToBounds = YES;
    }
    return _showView;
}

- (UIImageView *)showImg
{
    if (!_showImg) {
        _showImg = [[UIImageView alloc]init];
        _showImg.image = [UIImage imageNamed:TUIKitResource(@"n_explore_alter")];
    }
    return _showImg;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}
- (UIButton *)callBtn
{
    if (!_callBtn) {
        _callBtn = [[UIButton alloc]init];
        _callBtn.backgroundColor = RGB(255, 181, 0);
        [_callBtn setImage:[UIImage imageNamed:TUIKitResource(@"n_explore_call")] forState:UIControlStateNormal];
        [_callBtn addTarget:self action:@selector(actionCallBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_callBtn setTitle:@" Call" forState:UIControlStateNormal];
        _callBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _callBtn.layer.cornerRadius = 20.0f;
        _callBtn.layer.masksToBounds = YES;
    }
    return _callBtn;
}

-(void)actionCallBtn:(UIButton *)btn
{
    NSLog(@"actionCallBtnactionCallBtnactionCallBtnactionCallBtn");
    if (self.NeighborsSimpleCuteExploreContentViewCellCallBlock) {
        self.NeighborsSimpleCuteExploreContentViewCellCallBlock();
    }
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    [self addSubview:self.bgImg];
    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.bottom.offset(-30);
    }];
    
    [self addSubview:self.showView];
    [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.bottom.offset(-30);
    }];
    [self addSubview:self.showImg];
    [self.showImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.bgImg);
    }];
    [self addSubview:self.callBtn];
    [self.callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.offset(-10);
        make.width.offset(95);
        make.height.offset(40);
    }];
}
@end

@interface NeighborsSimpleCuteReportController ()

@end

@implementation NeighborsSimpleCuteReportController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"FeedBack";
}

@end

@interface NeighborsSimpleCuteSendMessageController ()
@property (strong,nonatomic)IQTextView *send_detail_view;
@property (nonatomic,strong)UIButton *sendBtn;
@end

@implementation NeighborsSimpleCuteSendMessageController
- (UIButton *)sendBtn
{
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        [_sendBtn setTitle:@"Send" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sendBtn addTarget:self action:@selector(actionSendBtn:) forControlEvents:UIControlEventTouchUpInside];
        _sendBtn.layer.cornerRadius = 15.0f;
        _sendBtn.layer.masksToBounds = YES;
        [_sendBtn gradientButtonWithSize:CGSizeMake(60, 30) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 6)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _sendBtn;
}

-(void)actionSendBtn:(UIButton *)btn
{
    NSLog(@"actionSendBtn btn");
    [self.view endEditing:YES];
    if (IS_EMPTY(self.send_detail_view.text)) {
        [SVProgressHUD showInfoWithStatus:@"Enter what you want to say"];
        return;
    }
    [SVProgressHUD show];
    dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [SVProgressHUD showInfoWithStatus:@"Send successful"];
                [self.navigationController popViewControllerAnimated:YES];
        });
    });
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Message";
    [self NeighborsSimpleCuteSetLeftButton:[UIImage imageNamed:TUIKitResource(@"n_back")]];
    self.send_detail_view = [[IQTextView alloc]init];
    self.send_detail_view.backgroundColor = RGB(60, 60, 60);
    self.send_detail_view.placeholder = @"Say hi.....";
    self.send_detail_view.placeholderTextColor = RGB(153, 153, 153);
    self.send_detail_view.textColor = [UIColor whiteColor];
    self.send_detail_view.font = [UIFont systemFontOfSize:15];
    self.send_detail_view.textAlignment = NSTextAlignmentLeft;
    self.send_detail_view.layer.cornerRadius  = 10.0f;
    self.send_detail_view.layer.masksToBounds = YES;
    [self.view addSubview:self.send_detail_view];
    [self.send_detail_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.top.offset(20);
        make.height.offset(260);
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.sendBtn];
}
- (void)onNeighborsSimpleCuteLeftBackBtn:(UIButton *)btn
{
    if (self.NeighborsSimpleCuteReportControllerMessageBlock) {
        self.NeighborsSimpleCuteReportControllerMessageBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end

@interface NeighborsSimpleCuteVoiceListController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView *exploreCollectionView;
@property (nonatomic,strong)NSMutableArray *exploreListArr;
@property (nonatomic,assign)BOOL isDefault;
@property (nonatomic,assign)NSInteger page; //页码
@property (nonatomic,assign)BOOL isMore;

@end

@implementation NeighborsSimpleCuteVoiceListController

- (NSMutableArray *)exploreListArr
{
    if (!_exploreListArr) {
        _exploreListArr = [NSMutableArray array];
    }
    return _exploreListArr;
}
- (UICollectionView *)exploreCollectionView
{
    if (!_exploreCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        flow.minimumLineSpacing = 10;//行间距
        flow.minimumInteritemSpacing = 10;//列间距
        _exploreCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flow];
        _exploreCollectionView.backgroundColor = [UIColor clearColor];
        _exploreCollectionView.showsVerticalScrollIndicator = NO;
        _exploreCollectionView.showsHorizontalScrollIndicator = NO;
        _exploreCollectionView.delegate = self;
        _exploreCollectionView.dataSource = self;
        [_exploreCollectionView registerClass:[NeighborsSimpleCuteExploreContentViewCell class] forCellWithReuseIdentifier:@"NeighborsSimpleCuteExploreContentViewCell"];
    }
    return _exploreCollectionView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Meet Voice";
    [self.view addSubview:self.exploreCollectionView];
    [self.exploreCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    [self actionNewExploreList];
    self.exploreCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(actionNewExploreList)];
    self.exploreCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(actionMoreExploreList)];
}
/// 更多数据
-(void)actionMoreExploreList
{
    if (self.isMore == YES) {
        [self.exploreCollectionView.mj_footer endRefreshing];
        return;
    }
    self.page++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"appType"] = @"1";
    param[@"pageNum"] = @(self.page);
    param[@"pageSize"] = @"20";
    NSString *baseurl = [NSString stringWithFormat:@"%@%@",NSC_Base_Url,@"api/bottle/openedList"];
    NSLog(@"param:%@",param);
    NSLog(@"baseurl:%@",baseurl);
    [[NeighborsSimpleCuteNetworkTool sharedNetworkTool]POST:baseurl parameters:param success:^(NeighborsSimpleCuteResposeModel * _Nonnull response) {
        NSLog(@"response.data:%@",response.data);
        [self.exploreCollectionView.mj_header endRefreshing];
        [self.exploreCollectionView.mj_footer  endRefreshing];
        if (response.code == 0) {
            NSMutableArray *array  = [NeighborsSimpleCuteExploreListModel mj_objectArrayWithKeyValuesArray:response.data];
            if (array.count == 0) {
                [self.exploreCollectionView.mj_footer endRefreshing];
                [self.exploreCollectionView reloadData];
                return;
            }else{
                [self.exploreListArr addObjectsFromArray:array];
                [self.exploreCollectionView.mj_footer endRefreshing];
                [self.exploreCollectionView reloadData];
            }
        }else{
            [self.exploreCollectionView.mj_footer endRefreshing];
            [SVProgressHUD showInfoWithStatus:response.msg];
            return;
        }
    }failure:^(NSError * _Nonnull error) {
        [self.exploreCollectionView.mj_footer endRefreshing];
        [SVProgressHUD showInfoWithStatus:error.localizedDescription];
        return;
    }];
}
/// 最新数据
-(void)actionNewExploreList
{
    self.isMore = NO;
    [self.exploreCollectionView.mj_footer resetNoMoreData];
    self.page = 1;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"appType"] = @"1";
    param[@"pageNum"] = @(self.page);
    param[@"pageSize"] = @"20";
    NSString *baseurl = [NSString stringWithFormat:@"%@%@",NSC_Base_Url,@"api/bottle/openedList"];
    NSLog(@"param:%@",param);
    NSLog(@"baseurl:%@",baseurl);
    [SVProgressHUD show];
    [[NeighborsSimpleCuteNetworkTool sharedNetworkTool]POST:baseurl parameters:param success:^(NeighborsSimpleCuteResposeModel * _Nonnull response) {
        NSLog(@"response.data:%@",response.data);
        [SVProgressHUD dismiss];
        if (response.code == 0) {
            [self.exploreListArr removeAllObjects];
            self.exploreListArr = [NeighborsSimpleCuteExploreListModel mj_objectArrayWithKeyValuesArray:response.data];
            [self.exploreCollectionView.mj_header endRefreshing];
            [self.exploreCollectionView.mj_header endRefreshing];
            [self.exploreCollectionView reloadData];
        }else{
            [self.exploreCollectionView.mj_header endRefreshing];
            [SVProgressHUD showInfoWithStatus:response.msg];
            return;
        }
    }failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [self.exploreCollectionView.mj_header endRefreshing];
        [SVProgressHUD showInfoWithStatus:error.localizedDescription];
        return;
    }];
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.exploreListArr.count;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((IPHONE_WIDTH - 40)/2, 240);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NeighborsSimpleCuteExploreContentViewCell *contentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NeighborsSimpleCuteExploreContentViewCell" forIndexPath:indexPath];
    NeighborsSimpleCuteExploreListModel *model = self.exploreListArr[indexPath.row];
    [contentCell.bgImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[NeighborsSimpleCuteUserModel getUserInfo].appClient.spare17th,model.userInfo.imgUrl]]];
    [contentCell setNeighborsSimpleCuteExploreContentViewCellCallBlock:^{
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //需要执行的方法
                    NeighborsSimpleCuteVideoCallView *callView = [[NeighborsSimpleCuteVideoCallView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT)];
                    callView.voiceModel = model;
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    NSCParameterAssert(window);
                    [window addSubview:callView];
                });
            } else {
                // [self showPhoto];
                // Microphone disabled code
            }
        }];
    }];
    return contentCell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NeighborsSimpleCuteExploreListModel *model = self.exploreListArr[indexPath.row];
    NeighborsSimpleCuteVoicePlayView *playView= [[NeighborsSimpleCuteVoicePlayView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT)];
    playView.exporeModel = model;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    NSCParameterAssert(window);
    [window addSubview:playView];
    [playView setNeighborsSimpleCuteVoicePlayViewCallBlock:^{
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Microphone enabled code‘
                    NeighborsSimpleCuteVideoCallView *callView = [[NeighborsSimpleCuteVideoCallView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT)];
                    callView.voiceModel = model;
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    NSCParameterAssert(window);
                    [window addSubview:callView];
                });

            } else {
            }
        }];
       
    }];
    [playView setNeighborsSimpleCuteVoicePlayViewReportBlock:^{
        NeighborsSimpleCuteSettingFeedBackController *reportShowVc = [[NeighborsSimpleCuteSettingFeedBackController alloc]init];
        reportShowVc.hidesBottomBarWhenPushed = YES;
        [reportShowVc setNeighborsSimpleCuteSettingFeedBackControllerBackBlock:^{
            playView.hidden = NO;
        }];
        [self.navigationController pushViewController:reportShowVc animated:YES];
    }];
    [playView setNeighborsSimpleCuteVoicePlayViewChatBlock:^{
        NeighborsSimpleCuteSendMessageController *sendMessagevc = [[NeighborsSimpleCuteSendMessageController alloc]init];
        sendMessagevc.hidesBottomBarWhenPushed = YES;
        [sendMessagevc setNeighborsSimpleCuteReportControllerMessageBlock:^{
            playView.hidden = NO;
        }];
        [self.navigationController pushViewController:sendMessagevc animated:YES];
    }];
    [playView setNeighborsSimpleCuteVoicePlayViewDelBlock:^{
        [self.exploreListArr removeObject:model];
        [self.exploreCollectionView reloadData];
    }];
    [playView setNeighborsSimpleCuteVoicePlayViewCloseBlock:^{
        //[self.exploreListArr removeObject:model];
        //[self.exploreCollectionView reloadData];
    }];
}
@end
#define kRecordAudioFile @"myRecord.caf"
@interface NeighborsSimpleCuteVoiceShowView ()<AVAudioRecorderDelegate>
@property (nonatomic,strong)UIView *bg_view;
@property (nonatomic,strong)UIButton *topBtn;
@property (nonatomic,strong)UILabel *contentLab;
@property (nonatomic,strong)UIButton *okBtn;
@property (nonatomic,strong)UIButton *cancelBtn;
@property (nonatomic,strong)UIButton *voiceBtn;
@property (nonatomic,strong)UILabel *timeLab;
@property (nonatomic,strong)UIButton *closeBtn;
@property (nonatomic,strong) AVAudioRecorder *audioRecorder;//音频录音机
@property (nonatomic,strong) NSTimer *timer;//录音声波监控（注意这里暂时不对播放进行监控）
@property (nonatomic,assign)NSInteger cutDown;
@property (nonatomic,assign)BOOL isRecorder;
@end

@implementation NeighborsSimpleCuteVoiceShowView
-(NSTimer *)timer{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateProgress) userInfo:nil repeats:true];
    }
    return _timer;
}
-(void)updateProgress
{
    self.cutDown++;
    self.timeLab.hidden = NO;
    self.timeLab.text = [NSString stringWithFormat:@"%ldS",(long)self.cutDown];
}
-(AVAudioRecorder *)audioRecorder{
    if (!_audioRecorder) {
        //创建录音文件保存路径
        NSURL *url=[self getSavePath];
        //创建录音格式设置
        NSDictionary *setting=[self getAudioSetting];
        //创建录音机
        NSError *error=nil;
        _audioRecorder=[[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate=self;
        _audioRecorder.meteringEnabled=YES;//如果要监控声波则必须设置为YES
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioRecorder;
}
/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */
-(NSDictionary *)getAudioSetting{
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    //设置录音格式
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道,这里采用单声道
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //....其他设置等
    return dicM;
}
/**
 *  取得录音文件保存路径
 *
 *  @return 录音文件路径
 */
-(NSURL *)getSavePath{
    NSString *urlStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr=[urlStr stringByAppendingPathComponent:kRecordAudioFile];
    NSLog(@"file path:%@",urlStr);
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    return url;
}

- (UIButton *)okBtn
{
    if (!_okBtn) {
        
        _okBtn = [[UIButton alloc]init];
        [_okBtn setTitle:@"OK" forState:UIControlStateNormal];
        [_okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _okBtn.layer.cornerRadius = 8.0f;
        _okBtn.layer.masksToBounds = YES;
        [_okBtn addTarget:self action:@selector(actionOkBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_okBtn gradientButtonWithSize:CGSizeMake(60, 60) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 63)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    }
    return _okBtn;
}
-(void)actionOkBtn:(UIButton *)btn
{
    NSLog(@"actionOkBtnactionOkBtnactionOkBtn btn");
    if (self.cutDown <= 0) {
        [SVProgressHUD showInfoWithStatus:@"Please record audio first"];
        return;
    }
    if (!self.isRecorder) {
        [SVProgressHUD showInfoWithStatus:@"Save the recording before you can send it"];
    }
    [SVProgressHUD show];
    dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [SVProgressHUD showInfoWithStatus:@"Send Successfully"];
                [UIView animateWithDuration:0.3 animations:^{
                    self.alpha = 0;
                } completion:^(BOOL finished) {
                    self.hidden = YES;
                    [self removeFromSuperview];
                }];
        });
    });
}
- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]init];
        [_cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancelBtn.layer.cornerRadius = 8.0f;
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn addTarget:self action:@selector(actionCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn gradientButtonWithSize:CGSizeMake(60, 60) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 63)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    }
    return _cancelBtn;
}

-(void)actionCancelBtn:(UIButton *)btn
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc]init];
        [_closeBtn setImage:[UIImage imageNamed:TUIKitResource(@"n_vocie_del")] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(actionCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.hidden = YES;
    }
    return _closeBtn;
}

-(void)actionCloseBtn:(UIButton *)btn
{
    self.timeLab.hidden = YES;
    self.closeBtn.hidden = YES;
    self.timer.fireDate=[NSDate distantFuture];
    [self.voiceBtn setImage:[UIImage imageNamed:TUIKitResource(@"n_send_voice")] forState:UIControlStateNormal];
    [self.audioRecorder pause];
}

- (UILabel *)timeLab
{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc]init];
        _timeLab.text = @"1s";
        _timeLab.textColor = [UIColor whiteColor];
        _timeLab.textAlignment = NSTextAlignmentCenter;
        _timeLab.font = [UIFont systemFontOfSize:16];
        _timeLab.hidden = YES;
    }
    return _timeLab;
}

- (UIButton *)voiceBtn
{
    if (!_voiceBtn) {
        _voiceBtn = [[UIButton alloc]init];
        [_voiceBtn setImage:[UIImage imageNamed:TUIKitResource(@"n_send_voice")] forState:UIControlStateNormal];
        _voiceBtn.layer.cornerRadius = 127/2;
        _voiceBtn.layer.masksToBounds = YES;
        [_voiceBtn addTarget:self action:@selector(actionSendVoice:) forControlEvents:UIControlEventTouchUpInside];
        [_voiceBtn gradientButtonWithSize:CGSizeMake(60, 60) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 63)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    }
    return _voiceBtn;
}

-(void)actionSendVoice:(UIButton *)sender
{
    NSLog(@"actionSendVoiceactionSendVoice btn");
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.voiceBtn setImage:[UIImage imageNamed:TUIKitResource(@"n_voice_stop")] forState:UIControlStateNormal];
        [self.audioRecorder record];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
        self.timer.fireDate=[NSDate distantPast];
        self.closeBtn.hidden = YES;
    }else{
        [self.voiceBtn setImage:[UIImage imageNamed:TUIKitResource(@"n_voice_play")] forState:UIControlStateNormal];
        [self.audioRecorder pause];
        self.timer.fireDate=[NSDate distantFuture];
        self.closeBtn.hidden = NO;
        self.isRecorder = YES;
    }
}
- (UIView *)bg_view
{
    if (!_bg_view) {
        _bg_view = [[UIView alloc]init];
        _bg_view.backgroundColor = [UIColor whiteColor];
        _bg_view.layer.cornerRadius = 5.0f;
        _bg_view.layer.masksToBounds = YES;
    }
    return _bg_view;
}

- (UIButton *)topBtn
{
    if (!_topBtn) {
        _topBtn = [[UIButton alloc]init];
        [_topBtn setTitle:@"Send Voice" forState:UIControlStateNormal];
        [_topBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_topBtn gradientButtonWithSize:CGSizeMake(60, 60) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 63)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    }
    return _topBtn;
}
- (UILabel *)contentLab
{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc]init];
        _contentLab.text = @"Say something interesting or sing a song. If someone is interested in your voice, you can video chat.";
        _contentLab.numberOfLines = 0;
        _contentLab.textColor = RGB(146, 119, 88);
        _contentLab.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLab;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    [self addSubview:self.bg_view];
    [self.bg_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self).offset(-20);
        make.height.offset(450);
        
    }];
    [self.bg_view addSubview:self.topBtn];
    [self.topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.offset(60);
    }];
    [self.bg_view addSubview:self.voiceBtn];
    [self.voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bg_view);
        make.centerY.mas_equalTo(self.bg_view).offset(-20);
        make.width.height.offset(127);
    }];
    [self.bg_view addSubview:self.timeLab];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bg_view);
        make.bottom.mas_equalTo(self.voiceBtn.mas_bottom).offset(-10);
    }];
    [self.bg_view addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.voiceBtn.mas_top).offset(0);
        make.left.mas_equalTo(self.voiceBtn.mas_right).offset(-20);
        make.width.height.offset(30);
    }];
    [self.bg_view addSubview:self.contentLab];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.top.mas_equalTo(self.voiceBtn.mas_bottom).offset(25);
    }];
    CGFloat bottomW = (IPHONE_WIDTH -60)/2;
    [self addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.mas_equalTo(self.bg_view.mas_bottom).offset(20);
        make.width.offset(bottomW);
        make.height.offset(50);
    }];
    [self addSubview:self.okBtn];
    [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.cancelBtn);
        make.right.offset(-20);
        make.width.offset(bottomW);
        make.height.offset(50);
    }];
    
}

@end

@interface NeighborsSimpleCuteVoicePlayView ()

@property (nonatomic,strong)UIView *bgView;

@property (nonatomic,strong)UIButton *closeBtn;

@property (nonatomic,strong)UIButton *reportBtn;

@property (nonatomic,strong)UIButton *callBtn;

@property (nonatomic,strong)UIButton *messageBtn;

@property (nonatomic,strong)UIView *centerView;

@property (nonatomic,strong)UILabel *contentLab;

@property (nonatomic,strong)UIImageView *iconImg;

@property (nonatomic,strong)UIImageView *playImg;

@property (nonatomic,strong)UIButton *playBtn;

@property (nonatomic,strong)UIView *effectView;

@property (nonatomic,copy)NSString *urlStr;

@property (nonatomic,strong)NSTimer     *timer;

@property (nonatomic,strong)UIView *alterView;

@property (nonatomic,strong)UIView  *subBgView;

@property (nonatomic,strong)UIButton *firstBtn;

@property (nonatomic,strong)UIButton *secondBtn;

@property (nonatomic,strong)UIButton *thirdBtn;

@property (nonatomic,strong)UIButton *fourBtn;


@end

@implementation NeighborsSimpleCuteVoicePlayView

- (void)setExporeModel:(NeighborsSimpleCuteExploreListModel *)exporeModel
{
    _exporeModel = exporeModel;
    NSString *imageUrl = [NSString stringWithFormat:@"%@/%@",[NeighborsSimpleCuteUserModel getUserInfo].appClient.spare17th,exporeModel.userInfo.imgUrl];
    NSLog(@"imageurl:%@",imageUrl);
    self.urlStr = [NSString stringWithFormat:@"%@/%@",[NeighborsSimpleCuteUserModel getUserInfo].appClient.spare17th,exporeModel.bottle.audioUrl];
    NSLog(@"self.urlStr:%@",self.urlStr);
    if ([self.urlStr containsString:@";"]) {
        NSArray *array =  [self.urlStr componentsSeparatedByString:@";"];
        self.urlStr = array[0];
    }
    self.contentLab.text = [NSString stringWithFormat:@"Click listen %@’s voice",exporeModel.userInfo.nickName];
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}

- (void)setVoiceModel:(NeighborsSimpleCuteHomeVoiceModel *)voiceModel
{
    _voiceModel = voiceModel;
    NSString *imageUrl = [NSString stringWithFormat:@"%@/%@",[NeighborsSimpleCuteUserModel getUserInfo].appClient.spare17th,voiceModel.userInfo.imgUrl];
    NSLog(@"imageurl:%@",imageUrl);
    self.urlStr = [NSString stringWithFormat:@"%@/%@",[NeighborsSimpleCuteUserModel getUserInfo].appClient.spare17th,voiceModel.audioUrl];
    NSLog(@"self.urlStr:%@",self.urlStr);
    if ([self.urlStr containsString:@";"]) {
        NSArray *array =  [self.urlStr componentsSeparatedByString:@";"];
        self.urlStr = array[0];
    }
    self.contentLab.text = [NSString stringWithFormat:@"Click listen %@’s voice",voiceModel.userInfo.nickName];
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}
- (NSTimer *)timer
{
    if (!_timer) {
        _timer =[NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(timerAct) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}
-(void)timerAct
{
    if ([LZPlayerManager lzPlayerManager].player.currentTime.timescale == 0 || [LZPlayerManager lzPlayerManager].player.currentItem.duration.timescale == 0 ) {
        return;
    }
    // 获得当前时间
    long long int currentTime = [LZPlayerManager lzPlayerManager].player.currentTime.value / [LZPlayerManager lzPlayerManager].player.currentTime.timescale;
    
    // 获得音乐总时长
    long long int totalTime = [LZPlayerManager lzPlayerManager].player.currentItem.duration.value / [LZPlayerManager lzPlayerManager].player.currentItem.duration.timescale;
    NSString *str = [NSString stringWithFormat:@"%lld",totalTime];
    if (currentTime == totalTime) {
        [[LZPlayerManager lzPlayerManager]playAndPause];
        self.playImg.hidden = YES;
        [self.playImg stopAnimating];
        [self.playBtn setImage:[UIImage imageNamed:TUIKitResource(@"n_voice_play")] forState:UIControlStateNormal];
        return;
    }
    if ([LZPlayerManager lzPlayerManager].isPlay) {//正在播放歌曲时头像转动
        [UIView beginAnimations:@"rzoration" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.iconImg.transform = CGAffineTransformRotate(self.iconImg.transform, 0.1);
        [UIView commitAnimations];
    }
}

- (UIView *)alterView
{
    if (!_alterView) {
        _alterView = [[UIView alloc]init];
        _alterView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        _alterView.hidden = YES;
    }
    return _alterView;
}

- (UIButton *)firstBtn
{
    if (!_firstBtn) {
        _firstBtn = [[UIButton alloc]init];
        [_firstBtn setImage:[UIImage imageNamed:TUIKitResource(@"spoiledSupriseReport")] forState:UIControlStateNormal];
        [_firstBtn setTitle:@" Report" forState:UIControlStateNormal];
        _firstBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_firstBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_firstBtn addTarget:self action:@selector(actionFirstBtn:) forControlEvents:UIControlEventTouchUpInside];
        _firstBtn.tag = 0;
    }
    return _firstBtn;
}

-(void)actionFirstBtn:(UIButton *)btn
{
    NSLog(@"actionFirstBtnactionFirstBtn");
    if (self.NeighborsSimpleCuteVoicePlayViewReportBlock) {
        self.NeighborsSimpleCuteVoicePlayViewReportBlock();
    }
    self.hidden = YES;
    if ([LZPlayerManager lzPlayerManager].isPlay) {
        [[LZPlayerManager lzPlayerManager]playAndPause];
        self.playImg.hidden = YES;
        [self.playImg stopAnimating];
        [self.playBtn setImage:[UIImage imageNamed:TUIKitResource(@"n_voice_play")] forState:UIControlStateNormal];
    }
}
- (UIButton *)secondBtn
{
    if (!_secondBtn) {
        _secondBtn = [[UIButton alloc]init];
        [_secondBtn setImage:[UIImage imageNamed:TUIKitResource(@"spoiledSupriseBlock")] forState:UIControlStateNormal];
        [_secondBtn setTitle:@" Block" forState:UIControlStateNormal];
        _thirdBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_secondBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_secondBtn addTarget:self action:@selector(actionSecondBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _secondBtn;
}

-(void)actionSecondBtn:(UIButton *)btn
{
    NSLog(@"actionSecondBtn");
//    [SVProgressHUD show];
//    dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [SVProgressHUD dismiss];
//                [SVProgressHUD showInfoWithStatus:@"Block successfully"];
//                self.alterView.hidden = YES;
//                self.subBgView.hidden = YES;
//        });
//    });
    [SVProgressHUD show];
    dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [SVProgressHUD showInfoWithStatus:@"Blocked successfully"];
                self.alterView.hidden = YES;
                self.subBgView.hidden = YES;
                if (self.NeighborsSimpleCuteVoicePlayViewDelBlock) {
                    self.NeighborsSimpleCuteVoicePlayViewDelBlock();
                }
                if ([LZPlayerManager lzPlayerManager].isPlay) {
                    [[LZPlayerManager lzPlayerManager]playAndPause];
                    self.playImg.hidden = YES;
                    [self.playImg stopAnimating];
                    [self.playBtn setImage:[UIImage imageNamed:TUIKitResource(@"n_voice_play")] forState:UIControlStateNormal];
                }
                [self removeFromSuperview];
        });
    });
}
- (UIButton *)thirdBtn
{
    if (!_thirdBtn) {
        _thirdBtn = [[UIButton alloc]init];
        [_thirdBtn setImage:[UIImage imageNamed:TUIKitResource(@"spoiledSupriseDelete")] forState:UIControlStateNormal];
        [_thirdBtn setTitle:@" Delete" forState:UIControlStateNormal];
        _thirdBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_thirdBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_thirdBtn addTarget:self action:@selector(actionThirdBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _thirdBtn;
}

-(void)actionThirdBtn:(UIButton *)btn
{
    NSLog(@"actionThirdBtn");
    [SVProgressHUD show];
    dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [SVProgressHUD showInfoWithStatus:@"Delete successfully"];
                self.alterView.hidden = YES;
                self.subBgView.hidden = YES;
                if (self.NeighborsSimpleCuteVoicePlayViewDelBlock) {
                    self.NeighborsSimpleCuteVoicePlayViewDelBlock();
                }
                if ([LZPlayerManager lzPlayerManager].isPlay) {
                    [[LZPlayerManager lzPlayerManager]playAndPause];
                    self.playImg.hidden = YES;
                    [self.playImg stopAnimating];
                    [self.playBtn setImage:[UIImage imageNamed:TUIKitResource(@"n_voice_play")] forState:UIControlStateNormal];
                }
                [self removeFromSuperview];
        });
    });
}
- (UIButton *)fourBtn
{
    if (!_fourBtn) {
        _fourBtn = [[UIButton alloc]init];
        [_fourBtn setImage:[UIImage imageNamed:TUIKitResource(@"spoiledSupriseCancel")] forState:UIControlStateNormal];
        [_fourBtn setTitle:@" Cancel" forState:UIControlStateNormal];
        _fourBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_fourBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_fourBtn addTarget:self action:@selector(actionFourBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fourBtn;
}

-(void)actionFourBtn:(UIButton *)btn
{
    self.alterView.hidden = YES;
    self.subBgView.hidden = YES;
    if ([LZPlayerManager lzPlayerManager].isPlay) {
        [[LZPlayerManager lzPlayerManager]playAndPause];
        [self.playImg stopAnimating];
        [self.playBtn setImage:[UIImage imageNamed:TUIKitResource(@"n_voice_play")] forState:UIControlStateNormal];
    }
}
- (UIView *)subBgView
{
    if (!_subBgView) {
        _subBgView = [[UIView alloc]init];
        _subBgView.backgroundColor = [UIColor whiteColor];
        _subBgView.layer.cornerRadius = 5.0f;
        _subBgView.layer.masksToBounds = YES;
        _subBgView.hidden = YES;
    }
    return _subBgView;
}

- (UIView *)effectView
{
    if (!_effectView) {
        _effectView = [[UIView alloc]init];
        _effectView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    }
    return _effectView;
}

- (UIImageView *)playImg
{
    if (!_playImg) {
        _playImg = [[UIImageView alloc]init];
        //_playImg.image = [UIImage imageNamed:TUIKitResource(@"test")];
        _playImg.contentMode = UIViewContentModeScaleAspectFill;
        _playImg.hidden  = YES;
    }
    return _playImg;
}

- (UIButton *)playBtn
{
    if (!_playBtn) {
        _playBtn = [[UIButton alloc]init];
        [_playBtn setImage:[UIImage imageNamed:TUIKitResource(@"n_voice_play")] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(actionPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}
-(void)actionPlayBtn:(UIButton *)sender
{
    NSLog(@"actionPlayBtnactionPlayBtn");
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.playImg.hidden = NO;
        [[LZPlayerManager lzPlayerManager]replaceItemWithUrlString:self.urlStr];
        [self.playBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        NSMutableArray *images = [NSMutableArray array];
        for (int i = 1; i <= 60; i++) {
            NSString *imageName = [NSString stringWithFormat:TUIKitResource(@"zhendonghua6yuemoapp (%d)"),i];
            NSLog(@"imageName:%@",imageName);
            [images addObject:[UIImage imageNamed:imageName]];
        }
        [self.playImg setAnimationImages:images];
        [self.playImg setAnimationRepeatCount:100000000];
        [self.playImg startAnimating];
        self.timer.fireDate=[NSDate distantPast];
    }else{
        self.playImg.hidden = YES;
        [[LZPlayerManager lzPlayerManager]playAndPause];
        [self.playImg stopAnimating];
        [self.playBtn setImage:[UIImage imageNamed:TUIKitResource(@"n_voice_play")] forState:UIControlStateNormal];
        self.timer.fireDate=[NSDate distantFuture];
    }
}

- (UIImageView *)iconImg
{
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc]init];
        _iconImg.contentMode = UIViewContentModeScaleAspectFill;
        _iconImg.layer.cornerRadius = 96.0f;
        _iconImg.layer.borderColor = [UIColor grayColor].CGColor;
        _iconImg.layer.borderWidth = .0f;
        _iconImg.layer.masksToBounds = YES;
    }
    return _iconImg;
}

-(void)stopTimer{
    self.timer.fireDate=[NSDate distantFuture];
    [self.timer invalidate];
    if (self.timer) {
        self.timer = nil;
    }
}

- (UILabel *)contentLab
{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc]init];
        _contentLab.text = @"Click listen Tom’s voice";
        _contentLab.numberOfLines = 0;
        _contentLab.textColor = RGB(146, 119, 88);
        _contentLab.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLab;
}
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 5.0f;
        _bgView.layer.masksToBounds  = YES;
    }
    return _bgView;
}
- (UIView *)centerView
{
    if (!_centerView) {
        _centerView = [[UIView alloc]init];
        _centerView.backgroundColor = [UIColor clearColor];
        _centerView.layer.cornerRadius = 100;
        _centerView.layer.masksToBounds = YES;
    }
    return _centerView  ;
}

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc]init];
        [_closeBtn setImage:[UIImage imageNamed:TUIKitResource(@"n_voice_play_close")] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(actionCloseBtn:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _closeBtn;
}
-(void)actionCloseBtn:(UIButton *)btn
{
    if ([LZPlayerManager lzPlayerManager].isPlay) {
        [[LZPlayerManager lzPlayerManager]playAndPause];
        self.playImg.hidden = YES;
        [self.playImg stopAnimating];
        [self.playBtn setImage:[UIImage imageNamed:TUIKitResource(@"n_voice_play")] forState:UIControlStateNormal];
    }
    if (self.NeighborsSimpleCuteVoicePlayViewCloseBlock) {
        self.NeighborsSimpleCuteVoicePlayViewCloseBlock();
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}
- (UIButton *)reportBtn
{
    if (!_reportBtn) {
        _reportBtn = [[UIButton alloc]init];
        [_reportBtn setImage:[UIImage imageNamed:TUIKitResource(@"n_voice_play_jubao")] forState:UIControlStateNormal];
        [_reportBtn addTarget:self action:@selector(actionReortBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reportBtn;
}

-(void)actionReortBtn:(UIButton *)btn
{
    NSLog(@"actionReortBtnactionReortBtnactionReortBtn");
    self.alterView.hidden = NO;
    self.subBgView.hidden = NO;
    [self addSubview:self.alterView];
    [self.alterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    [self addSubview:self.subBgView];
    
    CGFloat height = (IPHONE_HEIGHT- 450)/2 + 50;
    [self addSubview:self.subBgView];
    [self.subBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(height);
            make.right.offset(-60);
            make.width.offset(120);
            make.height.offset(220);
    }];
    CGFloat height2 = 220 / 4;
    [self.subBgView addSubview:self.firstBtn];
    [self.firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.offset(0);
            make.height.offset(height2);
    }];
    [self.subBgView addSubview:self.secondBtn];
    [self.secondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.mas_equalTo(self.firstBtn.mas_bottom).offset(0);
            make.height.offset(height2);
    }];
    [self.subBgView addSubview:self.thirdBtn];
    [self.thirdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.mas_equalTo(self.secondBtn.mas_bottom).offset(0);
            make.height.offset(height2);
    }];
    [self.subBgView addSubview:self.fourBtn];
    [self.fourBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.offset(0);
            make.height.offset(height2);
    }];
    

}

- (UIButton *)callBtn
{
    if (!_callBtn) {
        _callBtn = [[UIButton alloc]init];
        [_callBtn setImage:[UIImage imageNamed:TUIKitResource(@"n_voice_play_video")] forState:UIControlStateNormal];
        [_callBtn addTarget:self action:@selector(actionCallBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _callBtn;
}

-(void)actionCallBtn:(UIButton *)btn
{
    NSLog(@"actionCallBtnactionCallBtnactionCallBtn");
    if (self.NeighborsSimpleCuteVoicePlayViewCallBlock) {
        self.NeighborsSimpleCuteVoicePlayViewCallBlock();
    }
    if ([LZPlayerManager lzPlayerManager].isPlay) {
        [[LZPlayerManager lzPlayerManager]playAndPause];
        self.playImg.hidden = YES;
        [self.playImg stopAnimating];
        [self.playBtn setImage:[UIImage imageNamed:TUIKitResource(@"n_voice_play")] forState:UIControlStateNormal];
    }
}

- (UIButton *)messageBtn
{
    if (!_messageBtn) {
        _messageBtn = [[UIButton alloc]init];
        [_messageBtn setImage:[UIImage imageNamed:TUIKitResource(@"n_voice_play_chat")] forState:UIControlStateNormal];
        [_messageBtn addTarget:self action:@selector(actionMessageBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageBtn;
}

-(void)actionMessageBtn:(UIButton *)btn
{
    NSLog(@"actionMessageBtnactionMessageBtnactionMessageBtn");
    if (self.NeighborsSimpleCuteVoicePlayViewChatBlock) {
        self.NeighborsSimpleCuteVoicePlayViewChatBlock();
    }
    self.hidden = YES;
    if ([LZPlayerManager lzPlayerManager].isPlay) {
        self.playImg.hidden = YES;
        [[LZPlayerManager lzPlayerManager]playAndPause];
        [self.playImg stopAnimating];
        [self.playBtn setImage:[UIImage imageNamed:TUIKitResource(@"n_voice_play")] forState:UIControlStateNormal];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        [self setpUI];
    }
    return self;
}

-(void)setpUI
{
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.centerX.centerY.mas_equalTo(self);
        make.height.offset(450);
    }];
    [self.bgView addSubview:self.centerView];
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView);
        make.centerY.mas_equalTo(self.bgView).offset(-30);
        make.width.height.offset(200);
    }];
    [self.centerView addSubview:self.iconImg];
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(4);
        make.right.offset(-4);
        make.top.offset(4);
        make.bottom.offset(-4);
    }];
    [self.centerView addSubview:self.effectView];
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    [self.centerView addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.centerView);
        make.left.right.top.bottom.offset(0);
    }];
    [self.centerView addSubview:self.playImg];
    [self.playImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.centerView);
        make.left.right.offset(0);
        make.height.offset(40);
    }];
    [self.bgView addSubview:self.contentLab];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView);
        make.top.mas_equalTo(self.centerView.mas_bottom).offset(25);
        make.left.offset(10);
        make.right.offset(-10);
    }];
    [self.bgView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(10);
        make.width.height.offset(40);
    }];
    [self.bgView addSubview:self.reportBtn];
    [self.reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.top.offset(10);
        make.width.height.offset(40);
    }];
    [self.bgView addSubview:self.callBtn];
    [self.callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-20);
        make.centerX.mas_equalTo(self.bgView).offset(-60);
        make.width.height.offset(50);
    }];
    [self.bgView addSubview:self.messageBtn];
    [self.messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-20);
        make.centerX.mas_equalTo(self.bgView).offset(60);
        make.width.height.offset(50);
    }];
}

@end


@interface NeighborsSimpleCuteVideoCallView()
@property (nonatomic,strong)UIView *bg_view;
@property (nonatomic,strong)UIButton *topBtn;
@property (nonatomic,strong)UILabel *contentLab;
@property (nonatomic,strong)UIButton *okBtn;

@end

@implementation NeighborsSimpleCuteVideoCallView

- (void)setVoiceModel:(NeighborsSimpleCuteHomeVoiceModel *)voiceModel
{
    _voiceModel = voiceModel;
    //self.contentLab.text = [NSString stringWithFormat:@"Sorry, %@ is not online and can't start a video chat.",voiceModel.nameStr];
}

- (UIView *)bg_view
{
    if (!_bg_view) {
        _bg_view = [[UIView alloc]init];
        _bg_view.backgroundColor = [UIColor whiteColor];
        _bg_view.layer.cornerRadius = 5.0f;
        _bg_view.layer.masksToBounds = YES;
    }
    return _bg_view;
}
- (UIButton *)topBtn
{
    if (!_topBtn) {
        _topBtn = [[UIButton alloc]init];
        [_topBtn setTitle:@"Tips" forState:UIControlStateNormal];
        [_topBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_topBtn gradientButtonWithSize:CGSizeMake(60, 60) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 63)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    }
    return _topBtn;
}

- (UILabel *)contentLab
{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc]init];
        _contentLab.text = @"Sorry, this member does not have permission to open video chat for you.";
        _contentLab.numberOfLines = 0;
        _contentLab.textColor = RGB(146, 119, 88);
        _contentLab.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLab;
}
- (UIButton *)okBtn
{
    if (!_okBtn) {
        _okBtn = [[UIButton alloc]init];
        [_okBtn setTitle:@"OK" forState:UIControlStateNormal];
        [_okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _okBtn.layer.cornerRadius = 8.0f;
        _okBtn.layer.masksToBounds = YES;
        [_okBtn addTarget:self action:@selector(actionOkBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_okBtn gradientButtonWithSize:CGSizeMake(60, 60) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 63)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    }
    return _okBtn;
}

-(void)actionOkBtn:(UIButton *)btn
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        [self setupUI];
    }
    return self;
}
-(void)setupUI
{
    [self addSubview:self.bg_view];
    [self.bg_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self);
        make.left.offset(30);
        make.right.offset(-30);
        make.height.offset(360);
    }];

    [self.bg_view addSubview:self.topBtn];
    [self.topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.offset(50);
    }];
    [self.bg_view addSubview:self.contentLab];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.bg_view);
        make.left.offset(20);
        make.right.offset(-20);
    }];
    [self.bg_view addSubview:self.okBtn];
    [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bg_view);
        make.bottom.offset(-30);
        make.width.offset(240);
        make.height.offset(50);
    }];
}
@end

//@interface NeighborsSimpleCuteSubPlayVideoView ()
//
//@property (nonatomic,strong)UIView  *bgView;
//
//@property (nonatomic,strong)UIButton *firstBtn;
//
//@property (nonatomic,strong)UIButton *secondBtn;
//
//@property (nonatomic,strong)UIButton *thirdBtn;
//
//@property (nonatomic,strong)UIButton *fourBtn;
//
//@end
//
//@implementation NeighborsSimpleCuteSubPlayVideoView
//
//- (UIButton *)firstBtn
//{
//    if (!_firstBtn) {
//        _firstBtn = [[UIButton alloc]init];
//        [_firstBtn setImage:[UIImage imageNamed:TUIKitResource(@"spoiledSupriseReport")] forState:UIControlStateNormal];
//        [_firstBtn setTitle:@" Report" forState:UIControlStateNormal];
//        _firstBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//        [_firstBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [_firstBtn addTarget:self action:@selector(actionFirstBtn:) forControlEvents:UIControlEventTouchUpInside];
//        _firstBtn.tag = 0;
//    }
//    return _firstBtn;
//}
//
//-(void)actionFirstBtn:(UIButton *)btn
//{
//    NSLog(@"actionFirstBtnactionFirstBtn");
//    if (self.NeighborsSimpleCuteVoicePlayViewReportBlock) {
//        self.NeighborsSimpleCuteVoicePlayViewReportBlock();
//    }
//}
//- (UIButton *)secondBtn
//{
//    if (!_secondBtn) {
//        _secondBtn = [[UIButton alloc]init];
//        [_secondBtn setImage:[UIImage imageNamed:TUIKitResource(@"spoiledSupriseBlock")] forState:UIControlStateNormal];
//        [_secondBtn setTitle:@" Block" forState:UIControlStateNormal];
//        _thirdBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//        [_secondBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [_secondBtn addTarget:self action:@selector(actionSecondBtn:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _secondBtn;
//}
//
//-(void)actionSecondBtn:(UIButton *)btn
//{
//    NSLog(@"actionSecondBtn");
//    [SVProgressHUD show];
//    dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [SVProgressHUD dismiss];
//                [SVProgressHUD showInfoWithStatus:@"Block successfully"];
//                [self removeFromSuperview];
//        });
//    });
//}
//- (UIButton *)thirdBtn
//{
//    if (!_thirdBtn) {
//        _thirdBtn = [[UIButton alloc]init];
//        [_thirdBtn setImage:[UIImage imageNamed:TUIKitResource(@"spoiledSupriseDelete")] forState:UIControlStateNormal];
//        [_thirdBtn setTitle:@" Delete" forState:UIControlStateNormal];
//        _thirdBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//        [_thirdBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [_thirdBtn addTarget:self action:@selector(actionThirdBtn:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _thirdBtn;
//}
//
//-(void)actionThirdBtn:(UIButton *)btn
//{
//    NSLog(@"actionThirdBtn");
//    if (self.NeighborsSimpleCuteVoicePlayViewDelBlock) {
//        self.NeighborsSimpleCuteVoicePlayViewDelBlock();
//    }
//}
//- (UIButton *)fourBtn
//{
//    if (!_fourBtn) {
//        _fourBtn = [[UIButton alloc]init];
//        [_fourBtn setImage:[UIImage imageNamed:TUIKitResource(@"spoiledSupriseCancel")] forState:UIControlStateNormal];
//        [_fourBtn setTitle:@" Cancel" forState:UIControlStateNormal];
//        _fourBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//        [_fourBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [_fourBtn addTarget:self action:@selector(actionFourBtn:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _fourBtn;
//}
//
//-(void)actionFourBtn:(UIButton *)btn
//{
////    NSLog(@"actionFourBtnactionFourBtn");
////    [UIView animateWithDuration:0.3 animations:^{
////        self.alpha = 0;
////    } completion:^(BOOL finished) {
////        self.hidden = YES;
////        [self removeFromSuperview];
////    }];
//}
//- (UIView *)bgView
//{
//    if (!_bgView) {
//        _bgView = [[UIView alloc]init];
//        _bgView.backgroundColor = [UIColor whiteColor];
//        _bgView.layer.cornerRadius = 5.0f;
//        _bgView.layer.masksToBounds = YES;
//    }
//
//    return _bgView;
//}
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
//        [self setupUI];
//    }
//    return self;
//}
//-(void)setupUI
//{
//    CGFloat height = (IPHONE_HEIGHT- 450)/2 + 50;
//    [self addSubview:self.bgView];
//    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(height);
//        make.right.offset(-60);
//        make.width.offset(120);
//        make.height.offset(220);
//    }];
//    CGFloat height2 = 220 / 4;
//    [self.bgView addSubview:self.firstBtn];
//    [self.firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.offset(0);
//        make.height.offset(height2);
//    }];
//    [self.bgView addSubview:self.secondBtn];
//    [self.secondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.offset(0);
//        make.top.mas_equalTo(self.firstBtn.mas_bottom).offset(0);
//        make.height.offset(height2);
//    }];
//    [self.bgView addSubview:self.thirdBtn];
//    [self.thirdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.offset(0);
//        make.top.mas_equalTo(self.secondBtn.mas_bottom).offset(0);
//        make.height.offset(height2);
//    }];
//    [self.bgView addSubview:self.fourBtn];
//    [self.fourBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.bottom.right.offset(0);
//        make.height.offset(height2);
//    }];
//}
//
//@end
@interface NeighborsSimpleCuteHomeVoiceUserInfoModel ()

@end

@implementation NeighborsSimpleCuteHomeVoiceUserInfoModel


@end

@implementation NeighborsSimpleCuteExploreListBottleModel

@end

@implementation NeighborsSimpleCuteExploreListUserModel

@end

@implementation NeighborsSimpleCuteExploreListModel

@end


@interface NeighborsSimpleCuteHomeVoiceModel ()

@end


@implementation NeighborsSimpleCuteHomeVoiceModel
@end

//聊天界面的model
@interface SocializeIntercourseMessageModel()

@end

@implementation SocializeIntercourseMessageModel

@end

//聊天界面的model
@interface SocializeIntercourseMessageOtherModel()

@end

@implementation SocializeIntercourseMessageOtherModel

@end

static NeighborsSimpleCuteDBTool *instance = nil;

@interface NeighborsSimpleCuteDBTool ()

@property (strong,nonatomic)FMDatabase *NSCDB;

@end




@implementation NeighborsSimpleCuteDBTool

+ (instancetype)NeighborsSimpleCuteProjectSharaDBTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NeighborsSimpleCuteDBTool alloc]init];
    });
    return  instance;
}
- (void)NeighborsSimpleCuteProjectCreateDataBase
{
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filename = [doc stringByAppendingPathComponent:@"NeighborsSimpleCuteProject.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:filename];
    if ([db open]) {
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS n_voice (id integer PRIMARY KEY AUTOINCREMENT,n_name_str text NOT NULL, n_avtor_str text NOT NULL,n_url_str text NOT NULL);"];
        if (result) {
            NSLog(@"create n_voice success");
        }else{
            NSLog(@"create n_voice failure");
        }
        BOOL result2 = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS s_message (id integer PRIMARY KEY AUTOINCREMENT,storeNameStr text NOT NULL, sendIconStr text NOT NULL,sendTimeStr text NOT NULL,sendContentStr text NOT NULL,sendType text NOT NULL,sendPicture bool);"];
        if (result2) {
            NSLog(@"创建s_message成功");
        }else{
            NSLog(@"创建s_message失败");
        }
        BOOL result3 = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS s_messageStore (id integer PRIMARY KEY AUTOINCREMENT,storeNameStr text NOT NULL,storeTimeStr text NOT NULL,storeIconStr text NOT NULL,storeLastStr text NOT NULL);"];
        if (result3) {
            NSLog(@"创建s_messageStore成功");
        }else{
            NSLog(@"创建s_messageStore失败");
        }
    }
    self.NSCDB = db;
}

-(void)insertNeighborsSimpleCuteProjectPlanModel:(NeighborsSimpleCuteHomeVoiceModel *)voicemodel
{
    if ([self isEixistWithVoiceModel:voicemodel] == NO) {
       // [self.NSCDB executeUpdate:@"INSERT INTO n_voice (n_name_str,n_avtor_str,n_url_str) VALUES (?,?,?);",voicemodel.nameStr,voicemodel.avtorStr,voicemodel.urlStr];
    }
}
- (NSMutableArray *)queryAllNeighborsSimpleCuteProjectVoice
{
    NSMutableArray *arry = [NSMutableArray array];
    FMResultSet *resultset = [self.NSCDB executeQuery:@"SELECT * FROM n_voice"];
          while ([resultset next]) {
              NeighborsSimpleCuteHomeVoiceModel *model = [[NeighborsSimpleCuteHomeVoiceModel alloc]init];
//              model.index = [resultset intForColumn:@"id"];
//              model.nameStr = [resultset stringForColumn:@"n_name_str"];
//              model.avtorStr = [resultset stringForColumn:@"n_avtor_str"];
//              model.urlStr      = [resultset stringForColumn:@"n_url_str"];
              [arry addObject:model];
        }
    [resultset close];
    return arry;
}
-(BOOL)isEixistWithVoiceModel:(NeighborsSimpleCuteHomeVoiceModel *)model
{
    BOOL isHave = NO;
    NSMutableArray *arry = [NSMutableArray array];
    arry = [self queryAllNeighborsSimpleCuteProjectVoice];
    for (NeighborsSimpleCuteHomeVoiceModel *voicemodel in arry) {
//        if ([voicemodel.nameStr isEqualToString:model.nameStr]) {
//            isHave = YES;
//            break;
//        }
    }
    return isHave;
}


-(void)deleteNeighborsSimpleCuteProjectVoiceModel:(NeighborsSimpleCuteHomeVoiceModel *)voicemodel
{
    
  //  [self.NSCDB executeUpdate:@"DELETE FROM n_voice WHERE id = ?;",@(voicemodel.index)];
}

// 聊天界面需要的功能
-(void)insertMessageModel:(SocializeIntercourseMessageModel *)messageModel
{
    [self.NSCDB executeUpdate:@"INSERT INTO s_message (storeNameStr,sendIconStr,sendTimeStr,sendContentStr,sendType,sendPicture) VALUES (?,?,?,?,?,?);",messageModel.storeNameStr,messageModel.sendIconStr,messageModel.sendTimeStr,messageModel.sendContentStr,messageModel.sendType,messageModel.sendPicture];
}
-(void)deleteMessageModel:(SocializeIntercourseMessageModel *)messageModel
{
    [self.NSCDB executeUpdate:@"DELETE FROM s_message WHERE id = ?;",@(messageModel.index)];
}
- (NSMutableArray *)queryAllMessageModel
{
    NSMutableArray *arry = [NSMutableArray array];
    FMResultSet *resultset = [self.NSCDB executeQuery:@"SELECT * FROM s_message"];
          while ([resultset next]) {
              SocializeIntercourseMessageModel *model = [[SocializeIntercourseMessageModel alloc]init];
              model.index  = [resultset intForColumn:@"id"];
              model.storeNameStr = [resultset stringForColumn:@"storeNameStr"];
              model.sendIconStr  = [resultset stringForColumn:@"sendIconStr"];
              model.sendTimeStr  = [resultset stringForColumn:@"sendTimeStr"];
              model.sendContentStr  = [resultset stringForColumn:@"sendContentStr"];
              model.sendType  = [resultset stringForColumn:@"sendType"];
              model.sendPicture = [resultset dataForColumn:@"sendPicture"];
              [arry addObject:model];
          }
    [resultset close];
    return arry;
}
//插入数据的功能
-(void)insertMessageStoreModel:(SocializeIntercourseMessageOtherModel *)messageStoreModel
{
    [self.NSCDB executeUpdate:@"INSERT INTO s_messageStore (storeNameStr,storeTimeStr,storeIconStr,storeLastStr) VALUES (?,?,?,?);",messageStoreModel.storeNameStr,messageStoreModel.storeTimeStr,messageStoreModel.storeIconStr,messageStoreModel.storeLastStr];
}
-(void)updateMessageStoreModel:(SocializeIntercourseMessageOtherModel *)messageStoreModel
{
    [self.NSCDB executeUpdate:@"UPDATE s_messageStore  set storeNameStr = ?,storeTimeStr = ?,storeIconStr = ?, storeLastStr = ?  where id = ?",messageStoreModel.storeNameStr,messageStoreModel.storeTimeStr,messageStoreModel.storeIconStr,messageStoreModel.storeLastStr,@(messageStoreModel.index)];
}
-(void)deleteMessageStoreModel:(SocializeIntercourseMessageOtherModel *)messageStoreModel
{
    [self.NSCDB executeUpdate:@"DELETE FROM s_messageStore WHERE id = ?;",@(messageStoreModel.index)];
}

-(BOOL)isExistMessageStoreModel:(NSString *)storeNameStr
{
    BOOL isExist = NO;
    NSMutableArray *array = [self queryAllMessageStoreModel];
    for (SocializeIntercourseMessageOtherModel *model in array) {
        if ([model.storeNameStr isEqualToString:storeNameStr]) {
            isExist = YES;
            break;
        }
    }
    return isExist;
}

- (NSMutableArray *)queryAllMessageStoreModel
{
    NSMutableArray *arry = [NSMutableArray array];
    FMResultSet *resultset = [self.NSCDB executeQuery:@"SELECT * FROM s_messageStore"];
          while ([resultset next]) {
              SocializeIntercourseMessageOtherModel *model = [[SocializeIntercourseMessageOtherModel alloc]init];
              model.index  = [resultset intForColumn:@"id"];
              model.storeNameStr = [resultset stringForColumn:@"storeNameStr"];
              model.storeTimeStr  = [resultset stringForColumn:@"storeTimeStr"];
              model.storeIconStr  = [resultset stringForColumn:@"storeIconStr"];
              model.storeLastStr  = [resultset stringForColumn:@"storeLastStr"];
              [arry addObject:model];
          }
    [resultset close];
    return arry;
}

@end


@interface LZPlayerManager ()

@end

static LZPlayerManager *_lzPlayerManager = nil;


@implementation LZPlayerManager

+(instancetype)lzPlayerManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _lzPlayerManager = [[LZPlayerManager alloc]init];
        
    });
    return _lzPlayerManager;
}
/*初始化播放器*/
- (instancetype)init
{
    if (self = [super init]) {
        _player = [[AVPlayer alloc] init];
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session  setCategory:AVAudioSessionCategoryPlayback error:nil];
        [session setActive:YES error:nil];
    }
    return self;
}

// 播放
- (void)playerPlay
{
    [_player play];
    _isPlay = YES;
    
}
//暂停
- (void)playerPause
{
    [_player pause];
    _isPlay = NO;
  
}
//播放和暂停
- (void)playAndPause
{
    if (self.isPlay) {
        [self playerPause];
        if (self.isStartPlayer) {
            self.isStartPlayer(1);
        }
    }else{
        [self playerPlay];
        if (self.isStartPlayer) {
            self.isStartPlayer(0);
        }
    }
}
//前一首
- (void)playPrevious
{
    if (self.index == 0) {
        self.index = self.musicArray.count - 1;
    }else{
        self.index--;
    }
}
//下一首
- (void)playNext
{
    if (self.index == self.musicArray.count - 1) {
        self.index = 0;
    }else{
        self.index++;
    }
}
//音量
- (void)playerVolumeWithVolumeFloat:(CGFloat)volumeFloat
{
    self.player.volume = volumeFloat;
}
//进度
- (void)playerProgressWithProgressFloat:(CGFloat)progressFloat
{
    [self.player seekToTime:CMTimeMakeWithSeconds(progressFloat, 1) completionHandler:^(BOOL finished) {
        [self playerPlay];
    }];
}
//当前播放
- (void)replaceItemWithUrlString:(NSString *)urlString
{
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:urlString]];
    [self.player replaceCurrentItemWithPlayerItem:item];
    [self playerPlay];
}


@end

@interface NeighborsSimpleClinentInfo ()

@end
static NSString *UserModelKey = @"UserModelkey";
@implementation NeighborsSimpleClinentInfo

+ (void)save:(NeighborsSimpleClinentInfo *)model
{
    NSDictionary *user = model.mj_keyValues;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:user forKey:UserModelKey];
    [defaults synchronize];
}
+ (NeighborsSimpleClinentInfo *)getUserInfo2
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:UserModelKey];
    NeighborsSimpleClinentInfo *user =[NeighborsSimpleClinentInfo mj_objectWithKeyValues:dict];
    return user;
}

@end

@interface NeighborsSimpleTool ()

@end

@implementation NeighborsSimpleTool

+ (NSString*)getCurentLocalIP{
    NSString *address = @"error";

      struct ifaddrs *interfaces = NULL;

      struct ifaddrs *temp_addr = NULL;

      int success = 0;

      // retrieve the current interfaces - returns 0 on success

      success = getifaddrs(&interfaces);

      if (success == 0) {

          // Loop through linked list of interfaces

          temp_addr = interfaces;

          while(temp_addr != NULL) {

              if(temp_addr->ifa_addr->sa_family == AF_INET) {

                  // Check if interface is en0 which is the wifi connection on the iPhone

                  if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {

                      // Get NSString from C String

                      address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];

                  }

              }

              temp_addr = temp_addr->ifa_next;

          }

      }

      // Free memory

      freeifaddrs(interfaces);

      return address;

}

//    int sockfd = socket(AF_INET,SOCK_DGRAM, 0);
//    // if (sockfd <</span> 0) return nil; //这句报错，由于转载的，不太懂，注释掉无影响，懂的大神欢迎指导
//    NSMutableArray *ips = [NSMutableArray array];
//
//    int BUFFERSIZE =4096;
//
//    struct ifconf ifc;
//
//    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
//
//    struct ifreq *ifr, ifrcopy;
//
//    ifc.ifc_len = BUFFERSIZE;
//
//    ifc.ifc_buf = buffer;
//
//    if (ioctl(sockfd,SIOCGIFCONF, &ifc) >= 0){
//
//        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){
//
//            ifr = (struct ifreq *)ptr;
//
//            int len =sizeof(struct sockaddr);
//
//            if (ifr->ifr_addr.sa_len > len) {
//                len = ifr->ifr_addr.sa_len;
//            }
//
//            ptr += sizeof(ifr->ifr_name) + len;
//
//            if (ifr->ifr_addr.sa_family !=AF_INET) continue;
//
//            if ((cptr = (char *)strchr(ifr->ifr_name,':')) != NULL) *cptr =0;
//
//            if (strncmp(lastname, ifr->ifr_name,IFNAMSIZ) == 0)continue;
//
//            memcpy(lastname, ifr->ifr_name,IFNAMSIZ);
//
//            ifrcopy = *ifr;
//
//            ioctl(sockfd,SIOCGIFFLAGS, &ifrcopy);
//
//            if ((ifrcopy.ifr_flags &IFF_UP) == 0)continue;
//
//            NSString *ip = [NSString stringWithFormat:@"%s",inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
//            [ips addObject:ip];
//        }
//    }
//    close(sockfd);
//
//    NSString *deviceIP =@"";
//
//    for (int i=0; i < ips.count; i++){
//        if (ips.count >0){
//            deviceIP = [NSString stringWithFormat:@"%@",ips.lastObject];
//        }
//    }
//
//    return deviceIP;
//}

+ (BOOL)isVPNOn
{
   BOOL flag = NO;
   NSString *version = [UIDevice currentDevice].systemVersion;
   // need two ways to judge this.
   if (version.doubleValue >= 9.0)
   {
       NSDictionary *dict = CFBridgingRelease(CFNetworkCopySystemProxySettings());
       NSArray *keys = [dict[@"__SCOPED__"] allKeys];
       for (NSString *key in keys) {
           if ([key rangeOfString:@"tap"].location != NSNotFound ||
               [key rangeOfString:@"tun"].location != NSNotFound ||
               [key rangeOfString:@"ipsec"].location != NSNotFound ||
               [key rangeOfString:@"ppp"].location != NSNotFound){
               flag = YES;
               break;
           }
       }
   }
   else
   {
       struct ifaddrs *interfaces = NULL;
       struct ifaddrs *temp_addr = NULL;
       int success = 0;
       
       // retrieve the current interfaces - returns 0 on success
       success = getifaddrs(&interfaces);
       if (success == 0)
       {
           // Loop through linked list of interfaces
           temp_addr = interfaces;
           while (temp_addr != NULL)
           {
               NSString *string = [NSString stringWithFormat:@"%s" , temp_addr->ifa_name];
               if ([string rangeOfString:@"tap"].location != NSNotFound ||
                   [string rangeOfString:@"tun"].location != NSNotFound ||
                   [string rangeOfString:@"ipsec"].location != NSNotFound ||
                   [string rangeOfString:@"ppp"].location != NSNotFound)
               {
                   flag = YES;
                   break;
               }
               temp_addr = temp_addr->ifa_next;
           }
       }
       
       // Free memory
       freeifaddrs(interfaces);
   }


   return flag;
}


@end


@interface NeighborsSimpleCuteNetworkTool ()

@end

@implementation NeighborsSimpleCuteNetworkTool
static id _instance;
static AFHTTPSessionManager *_session;
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}
+ (instancetype)sharedNetworkTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        /*
        NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
        conf.timeoutIntervalForRequest = 60;
        _session = [[AFHTTPSessionManager alloc]initWithBaseURL:nil sessionConfiguration:conf];
         */
        _session = [AFHTTPSessionManager manager];
        [_session.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        _session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
        _session.requestSerializer = [AFJSONRequestSerializer serializer];
        AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
        response.removesKeysWithNullValues = YES;//去除空值
        _session.responseSerializer = response;//申明返回的结果是json
        _instance = [[self alloc] init];
    });
    return _instance;
}

-(void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    [_session GET:URLString parameters:parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
       
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"responseObject.data:%@",responseObject);
           // NeighborsSimpleCuteResposeModel *response = [NeighborsSimpleCuteResposeModel mj_objectWithKeyValues:responseObject];
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
}

-(void)GET2:(NSString *)URLString parameters:(id)parameters success:(void (^)(NeighborsSimpleCuteResposeModel *response))success failure:(void (^)(NSError * error))failure
{
    [_session GET:URLString parameters:parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject.data:%@",responseObject);
       NeighborsSimpleCuteResposeModel *response = [NeighborsSimpleCuteResposeModel mj_objectWithKeyValues:responseObject];
        if (success) {
            success(response);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
-(void)POST2:(NSString *)URLString parameters:(id)parameters success:(void (^)(NeighborsSimpleCuteResposeModel *response))success failure:(void (^)(NSError * error))failure
{
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:NeighborsSimple_Token];
    if (token.length > 0) {
        [_session.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    }
    [_session POST:URLString parameters:parameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"POST.responseObject:%@",responseObject);
        NeighborsSimpleCuteResposeModel *response = [NeighborsSimpleCuteResposeModel mj_objectWithKeyValues:responseObject];
        NSLog(@"response:%@",response);
        if (success) {
            success(response);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
-(void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NeighborsSimpleCuteResposeModel *response))success failure:(void (^)(NSError * error))failure
{
    NeighborsSimpleCuteUserModel *usermodel = [NeighborsSimpleCuteUserModel getUserInfo];
    if (usermodel.tokenDto.token.length > 0) {
        NSLog(@"有token:%@",usermodel.tokenDto.token);
        [_session.requestSerializer setValue:usermodel.tokenDto.token forHTTPHeaderField:@"token"];
    }
    [_session POST:URLString parameters:parameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"POST.responseObject:%@",responseObject);
        NeighborsSimpleCuteResposeModel *response = [NeighborsSimpleCuteResposeModel mj_objectWithKeyValues:responseObject];
        NSLog(@"response:%@",response);
        if (success) {
            success(response);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end

@interface NeighborsSimpleCuteResposeModel ()


@end

@implementation NeighborsSimpleCuteResposeModel

@end

// 新的个人中心版本
@interface NeighborsSimpleCuteSettingOtherMainController()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView *settingOtherCollectionView;
@property (nonatomic,strong)NSMutableArray *settingOtherImageListArr;
@property (nonatomic,strong)NSMutableArray *settingOtherTitleListArr;
@property(nonatomic,copy)NSString *memberLevel;
@end
@implementation NeighborsSimpleCuteSettingOtherMainController

- (UICollectionView *)settingOtherCollectionView
{
    if (!_settingOtherCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        flow.minimumLineSpacing = 10;//行间距
        flow.minimumInteritemSpacing = 10;//列间距
        _settingOtherCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flow];
        _settingOtherCollectionView.backgroundColor = [UIColor clearColor];
        _settingOtherCollectionView.showsVerticalScrollIndicator = NO;
        _settingOtherCollectionView.showsHorizontalScrollIndicator = NO;
        _settingOtherCollectionView.delegate = self;
        _settingOtherCollectionView.dataSource = self;
        [_settingOtherCollectionView registerClass:[NeighborsSimpleCuteSettingHeaderOtherViewCell class] forCellWithReuseIdentifier:@"NeighborsSimpleCuteSettingHeaderOtherViewCell"];
        [_settingOtherCollectionView registerClass:[NeighborsSimpleCuteSettingContentOtherViewCell class] forCellWithReuseIdentifier:@"NeighborsSimpleCuteSettingContentOtherViewCell"];
        [_settingOtherCollectionView registerClass:[NeighborsSimpleCuteSettingRechargeOtherViewCell class] forCellWithReuseIdentifier:@"NeighborsSimpleCuteSettingRechargeOtherViewCell"];
    }
    return _settingOtherCollectionView;
}

- (NSMutableArray *)settingOtherImageListArr
{
    if (!_settingOtherImageListArr) {
        _settingOtherImageListArr = [NSMutableArray arrayWithObjects:TUIKitResource(@"grzxer_edit"),TUIKitResource(@"grzxer_contact"),TUIKitResource(@"grzxer_delete"),TUIKitResource(@"grzxer_setting"), nil];
    }
    return _settingOtherImageListArr;
}
- (NSMutableArray *)settingOtherTitleListArr
{
    if (!_settingOtherTitleListArr) {
        _settingOtherTitleListArr = [NSMutableArray arrayWithObjects:@"Edit profile",@"Contact us",@"Delete account",@"Base setting", nil];
    }
    return _settingOtherTitleListArr;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"userId"] = @([NeighborsSimpleCuteUserModel getUserInfo].userInfo.userId);
    NSString *baseUrl = [NSString stringWithFormat:@"%@api/relation/visitor/%ld",NSC_Base_Url,(long)[NeighborsSimpleCuteUserModel getUserInfo].userInfo.userId];
    NSLog(@"baseUlr:%@",baseUrl);
    [[NeighborsSimpleCuteNetworkTool sharedNetworkTool]POST:baseUrl parameters:param success:^(NeighborsSimpleCuteResposeModel *response) {
        NSLog(@"viewWillAppearviewWillAppear.data：%@",response.data);
        self.memberLevel  = response.data[@"userInfo"][@"memberLevel"];
        NSLog(@"self.memberLevelself.memberLevel:%@",self.memberLevel);
        [self.settingOtherCollectionView reloadData];
    } failure:^(NSError *error) {
        
    }];
    [self.settingOtherCollectionView reloadData];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"";
    self.view.backgroundColor = NSC_MainThemColor;
    [self NeighborsSimpleCuteSetLeftButton:[UIImage imageNamed:@""]];
    [self NeighborsSimpleCuteSetRightButton:[UIImage imageNamed:TUIKitResource(@"n_setting_back")]];
    [self.view  addSubview:self.settingOtherCollectionView];
    [self.settingOtherCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
}
- (void)onNeighborsSimpleCuteRightBackBtn:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- NeighborsSimpleCuteSettingMainController <UICollectionViewDelegate,UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 1;
    }
    else{
        return self.settingOtherTitleListArr.count;
    }
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return UIEdgeInsetsZero;
    }else{
        return UIEdgeInsetsMake(20, 20, 20, 20);
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(IPHONE_WIDTH, 220);
    }else if(indexPath.section == 1){
        return CGSizeMake(IPHONE_WIDTH-60, 100);
    }
    else{
        return CGSizeMake((IPHONE_WIDTH - 50)/2, 130);
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NeighborsSimpleCuteSettingHeaderOtherViewCell *headerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NeighborsSimpleCuteSettingHeaderOtherViewCell" forIndexPath:indexPath];
        NSString *imageBaseUrl = [NSString stringWithFormat:@"%@/",[NeighborsSimpleCuteUserModel getUserInfo].appClient.spare17th];
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",imageBaseUrl,[NeighborsSimpleCuteUserModel getUserInfo].userInfo.tempStr7th];
        NSLog(@"imageUrlimageUrl:%@",imageUrl);
        [headerCell.iconImg sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:TUIKitResource(@"n_default_bg.png")]];
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//        NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:
//                                      [NSString stringWithFormat:(@"n_add_sened_img.png")]];
//        // 保存文件的名称
//        UIImage *img = [UIImage imageWithContentsOfFile:filePath];
//        NSLog(@"img:%@",img);
//        if (img) {
//                headerCell.iconImg.image = img;
//            }else{
//                headerCell.iconImg.image = [UIImage imageNamed:TUIKitResource(@"n_default_bg.png")];
//        }
        NSString *userName = [NeighborsSimpleCuteUserModel getUserInfo].userInfo.nickName;
        [headerCell.nameBtn setTitle:userName forState:UIControlStateNormal];
        if ([self.memberLevel intValue] == 1) {
            [headerCell.nameBtn setImage:[UIImage imageNamed:TUIKitResource(@"name_huang")] forState:UIControlStateNormal];
        }else{
            [headerCell.nameBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
        return headerCell;
    }else if(indexPath.section == 1){
        NeighborsSimpleCuteSettingRechargeOtherViewCell *rechagerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NeighborsSimpleCuteSettingRechargeOtherViewCell" forIndexPath:indexPath];
        [rechagerCell setNeighborsSimpleCuteSettingRechargeViewCellRechageBlock:^{
            NSLog(@"upgrade other controller");
            NSString *spare9th =  [NeighborsSimpleCuteUserModel getUserInfo].appClient.spare9th;
            NSLog(@"spare9th:%@",spare9th);
            if ([spare9th isEqualToString:@"0"]) {
                //显示新的
                ZFMemberUpgrdeOtherController *zfothermembervc = [[ZFMemberUpgrdeOtherController alloc]init];
                zfothermembervc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:zfothermembervc animated:YES];
            }else if([spare9th isEqualToString:@"1"]){
                //显示老的
                ZFMemberUpgrdeController *upgrdevc = [[ZFMemberUpgrdeController alloc]init];
                upgrdevc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:upgrdevc animated:YES];
            }else{
                //显示老的
                ZFMemberUpgrdeController *upgrdevc = [[ZFMemberUpgrdeController alloc]init];
                upgrdevc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:upgrdevc animated:YES];
            }
        
        }];
        return rechagerCell;
    }else{
        NeighborsSimpleCuteSettingContentOtherViewCell *contentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NeighborsSimpleCuteSettingContentOtherViewCell" forIndexPath:indexPath];
        contentCell.iconImg.image = [UIImage imageNamed:self.settingOtherImageListArr[indexPath.row]];
        contentCell.titleLab.text = self.settingOtherTitleListArr[indexPath.row];
        return contentCell;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        int row = (int)indexPath.row;
        switch (row) {
            case 0:
            {
                //Profile
                NeighborsSimpleCuteSettingProfileController *profilevc = [[NeighborsSimpleCuteSettingProfileController alloc]init];
                profilevc.hidesBottomBarWhenPushed = YES;
                //[self.navigationController setNavigationBarHidden:NO animated:YES];
                [self.navigationController pushViewController:profilevc animated:YES];
            }
                break;
            case 1:
            {
                //Contact us
                NeighborsSimpleCuteSettingFeedBackController *feedbackvc = [[NeighborsSimpleCuteSettingFeedBackController alloc]init];
                feedbackvc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:feedbackvc animated:YES];
            }
                break;
            case 2:
            {
                //Delete account
                NeighborsSimpleCuteDelAccountView *delView = [[NeighborsSimpleCuteDelAccountView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT)];
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                [delView setNeighborsSimpleCuteDelAccountViewBlock:^{
                     NeighborsSimpleCuteDelAccountController *delaccountvc = [[NeighborsSimpleCuteDelAccountController alloc]init];
                     delaccountvc.hidesBottomBarWhenPushed = YES;
                     [self.navigationController pushViewController:delaccountvc animated:YES];
                }];
                NSCParameterAssert(window);
                [window addSubview:delView];

            }
                break;
            case 3:
            {
                //Base Setting
                NeighborsSimpleCuteBaseSettingMainController *baseSettingVc = [[NeighborsSimpleCuteBaseSettingMainController alloc]init];
                baseSettingVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:baseSettingVc animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

@end

// base setting

@interface NeighborsSimpleCuteBaseSettingMainController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView *baseSettingCollectionView;

@property (nonatomic,strong)NSMutableArray *baseSettingTitleArr;

@end
@implementation NeighborsSimpleCuteBaseSettingMainController

- (NSMutableArray *)baseSettingTitleArr
{
    if (!_baseSettingTitleArr) {
        _baseSettingTitleArr = [NSMutableArray arrayWithObjects:@"Sevice agreement",@"Privacy policy",@"Feedback",@"Block member",@"Delete account",@"Forgot password",@"Sign out", nil];
    }
    return _baseSettingTitleArr;
}

- (UICollectionView *)baseSettingCollectionView
{
    if (!_baseSettingCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        flow.minimumLineSpacing = 10;//行间距
        flow.minimumInteritemSpacing = 10;//列间距
        _baseSettingCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flow];
        _baseSettingCollectionView.backgroundColor = [UIColor clearColor];
        _baseSettingCollectionView.showsVerticalScrollIndicator = NO;
        _baseSettingCollectionView.showsHorizontalScrollIndicator = NO;
        _baseSettingCollectionView.delegate = self;
        _baseSettingCollectionView.dataSource = self;
        [_baseSettingCollectionView registerClass:[NeighborsSimpleCuteBaseSettingContentViewCell class] forCellWithReuseIdentifier:@"NeighborsSimpleCuteBaseSettingContentViewCell"];
    }
    return _baseSettingCollectionView;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Setting";
    [self.view  addSubview:self.baseSettingCollectionView];
    [self.baseSettingCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.right.bottom.offset(0);
    }];
}
#pragma mark -- NeighborsSimpleCuteBaseSettingMainController 代理方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.baseSettingTitleArr.count;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(IPHONE_WIDTH-20, 70);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NeighborsSimpleCuteBaseSettingContentViewCell *baseSettingContentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NeighborsSimpleCuteBaseSettingContentViewCell" forIndexPath:indexPath];
    baseSettingContentCell.titleLab.text = self.baseSettingTitleArr[indexPath.row];
    return baseSettingContentCell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        // Service Agrement
        NeighborsSimpleCuteBaseWebController *agrementvc = [[NeighborsSimpleCuteBaseWebController  alloc]init];
        agrementvc.isShowHidden = YES;
        agrementvc.URLString = @"http://www.hooil.cn/terms.html";
        agrementvc.loadType = WKWebLoadTypeWebURLString;
        agrementvc.webTitle = @"Service Agreement";
        [self.navigationController pushViewController:agrementvc animated:YES];
    }else if(indexPath.row == 1){
        //Privacy policy
        NeighborsSimpleCuteBaseWebController *provcyVc = [[NeighborsSimpleCuteBaseWebController  alloc]init];
        provcyVc.isShowHidden = YES;
        provcyVc.URLString = @"http://www.hooil.cn/privacy.html";
        provcyVc.loadType = WKWebLoadTypeWebURLString;
        provcyVc.webTitle = @"Privacy Policy";
        [self.navigationController pushViewController:provcyVc animated:YES];
    }else if(indexPath.row == 2){
        //FeedBack
        NeighborsSimpleCuteSettingFeedBackController *feedbackvc = [[NeighborsSimpleCuteSettingFeedBackController alloc]init];
        feedbackvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:feedbackvc animated:YES];
    }else if(indexPath.row == 3){
        //Block member
        NeighborsSimpleCuteSettingBlockController *blocklistvc = [[NeighborsSimpleCuteSettingBlockController alloc]init];
        blocklistvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:blocklistvc animated:YES];
    }else if(indexPath.row == 4){
        //Delete Account
        NeighborsSimpleCuteDelAccountView *delView = [[NeighborsSimpleCuteDelAccountView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT)];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [delView setNeighborsSimpleCuteDelAccountViewBlock:^{
             NeighborsSimpleCuteDelAccountController *delaccountvc = [[NeighborsSimpleCuteDelAccountController alloc]init];
             delaccountvc.hidesBottomBarWhenPushed = YES;
             [self.navigationController pushViewController:delaccountvc animated:YES];
        }];
        NSCParameterAssert(window);
        [window addSubview:delView];
    }else if(indexPath.row == 5){
        //Forget password
        NeighborsSimpleCuteUserForgePwdController *forgetpasswordvc = [[NeighborsSimpleCuteUserForgePwdController alloc]init];
        forgetpasswordvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:forgetpasswordvc animated:YES];
    }else{
        //sign out
        NeighborsSimpleCuteSignOutView *outView = [[NeighborsSimpleCuteSignOutView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT)];
        [outView setNeighborsSimpleCuteSignOutViewShowBlock:^{
            [SVProgressHUD show];
            dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                        [SVProgressHUD showInfoWithStatus:@"Sign out successful"];
                        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:NeighborsSimple_LoginStatus];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        NeighborsSimpleCuteRootMainController *rootMainvc = [[NeighborsSimpleCuteRootMainController alloc]init];
                        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:rootMainvc];
                                [UIApplication sharedApplication].keyWindow.rootViewController = nav;
                    });
           });
        }];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        NSCParameterAssert(window);
        [window addSubview:outView];
    }
}
@end

@interface NeighborsSimpleCuteSettingMainController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView *settingCollectionView;

@property (nonatomic,strong)NSMutableArray *settingImageListArr;

@property (nonatomic,strong)NSMutableArray *settingTitleListArr;

@end

@implementation NeighborsSimpleCuteSettingMainController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.settingCollectionView reloadData];
}
- (NSMutableArray *)settingImageListArr
{
    if (!_settingImageListArr) {
        _settingImageListArr = [NSMutableArray arrayWithObjects:TUIKitResource(@"n_setting_profile"),TUIKitResource(@"n_setting_contact"),TUIKitResource(@"n_setting_aboutus"),TUIKitResource(@"n_setting_booklist"),TUIKitResource(@"n_setting_del"),TUIKitResource(@"n_setting_signout"), nil];
    }
    return _settingImageListArr;
}
- (NSMutableArray *)settingTitleListArr
{
    if (!_settingTitleListArr) {
        _settingTitleListArr = [NSMutableArray arrayWithObjects:@"Profile",@"Contact us",@"About us",@"Blocklist",@"Delete account",@"Sign out", nil];
    }
    return _settingTitleListArr;
}

- (UICollectionView *)settingCollectionView
{
    if (!_settingCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        flow.minimumLineSpacing = 10;//行间距
        flow.minimumInteritemSpacing = 10;//列间距
        _settingCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flow];
        _settingCollectionView.backgroundColor = [UIColor clearColor];
        _settingCollectionView.showsVerticalScrollIndicator = NO;
        _settingCollectionView.showsHorizontalScrollIndicator = NO;
        _settingCollectionView.delegate = self;
        _settingCollectionView.dataSource = self;
        [_settingCollectionView registerClass:[NeighborsSimpleCuteSettingHeaderViewCell class] forCellWithReuseIdentifier:@"NeighborsSimpleCuteSettingHeaderViewCell"];
        [_settingCollectionView registerClass:[NeighborsSimpleCuteSettingContentViewCell class] forCellWithReuseIdentifier:@"NeighborsSimpleCuteSettingContentViewCell"];
        [_settingCollectionView registerClass:[NeighborsSimpleCuteSettingRechargeViewCell class] forCellWithReuseIdentifier:@"NeighborsSimpleCuteSettingRechargeViewCell"];
    }
    return _settingCollectionView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"";
    self.view.backgroundColor = NSC_MainThemColor;
    [self NeighborsSimpleCuteSetLeftButton:[UIImage imageNamed:@""]];
    [self NeighborsSimpleCuteSetRightButton:[UIImage imageNamed:TUIKitResource(@"n_setting_back")]];
    [self.view  addSubview:self.settingCollectionView];
    [self.settingCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
}
- (void)onNeighborsSimpleCuteRightBackBtn:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- NeighborsSimpleCuteSettingMainController <UICollectionViewDelegate,UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 1;
    }
    else{
        return self.settingTitleListArr.count;
    }
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return UIEdgeInsetsZero;
    }else{
        return UIEdgeInsetsMake(20, 20, 20, 20);
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(IPHONE_WIDTH, 180);
    }else if(indexPath.section == 1){
        return CGSizeMake(IPHONE_WIDTH-60, 60);
    }
    else{
        return CGSizeMake((IPHONE_WIDTH - 50)/2, 130);
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NeighborsSimpleCuteSettingContentViewCell *headerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NeighborsSimpleCuteSettingContentViewCell" forIndexPath:indexPath];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:
                                      [NSString stringWithFormat:(@"n_add_sened_img.png")]];
        // 保存文件的名称
        UIImage *img = [UIImage imageWithContentsOfFile:filePath];
        NSLog(@"img:%@",img);
        if (img) {
                headerCell.iconImg.image = img;
            }else{
                headerCell.iconImg.image = [UIImage imageNamed:TUIKitResource(@"n_default_bg.png")];
            }
        NSString *userName = [NeighborsSimpleCuteUserModel getUserInfo].userInfo.nickName;
        //[[NSUserDefaults standardUserDefaults]valueForKey:NeighborsSimple_EmailUser];
        headerCell.titleLab.text = userName;
        return headerCell;
    }else if(indexPath.section == 1){
        NeighborsSimpleCuteSettingRechargeViewCell *rechagerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NeighborsSimpleCuteSettingRechargeViewCell" forIndexPath:indexPath];
        [rechagerCell setNeighborsSimpleCuteSettingRechargeViewCellRechageBlock:^{
            NSLog(@"upgrade");
            ZFMemberUpgrdeController *zfmembervc = [[ZFMemberUpgrdeController alloc]init];
            zfmembervc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:zfmembervc animated:YES];
        }];
        return rechagerCell;
    }else{
        NeighborsSimpleCuteSettingHeaderViewCell *contentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NeighborsSimpleCuteSettingHeaderViewCell" forIndexPath:indexPath];
        contentCell.iconImg.image = [UIImage imageNamed:self.settingImageListArr[indexPath.row]];
        contentCell.iconLab.text = self.settingTitleListArr[indexPath.row];
        return contentCell;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        int row = (int)indexPath.row;
        switch (row) {
            case 0:
            {
                //Profile
                NeighborsSimpleCuteSettingProfileController *profilevc = [[NeighborsSimpleCuteSettingProfileController alloc]init];
                profilevc.hidesBottomBarWhenPushed = YES;
                //[self.navigationController setNavigationBarHidden:NO animated:YES];
                [self.navigationController pushViewController:profilevc animated:YES];
            }
                break;
            case 1:
            {
                //Contact us
                NeighborsSimpleCuteSettingFeedBackController *feedbackvc = [[NeighborsSimpleCuteSettingFeedBackController alloc]init];
                feedbackvc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:feedbackvc animated:YES];
            }
                break;
            case 2:
            {
                //About us
                NeighborsSimpleCuteSettingAboutusController *aboutusvc = [[NeighborsSimpleCuteSettingAboutusController alloc]init];
                aboutusvc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:aboutusvc animated:YES];

            }
                break;
            case 3:
            {
                //Bloclist
                NeighborsSimpleCuteSettingBlockController *blocklistvc = [[NeighborsSimpleCuteSettingBlockController alloc]init];
                blocklistvc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:blocklistvc animated:YES];
            }
                break;
            case 4:
            {
                //Delete account
            
                NeighborsSimpleCuteDelAccountView *delView = [[NeighborsSimpleCuteDelAccountView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT)];
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                [delView setNeighborsSimpleCuteDelAccountViewBlock:^{
                     NeighborsSimpleCuteDelAccountController *delaccountvc = [[NeighborsSimpleCuteDelAccountController alloc]init];
                     delaccountvc.hidesBottomBarWhenPushed = YES;
                     [self.navigationController pushViewController:delaccountvc animated:YES];
                }];
                NSCParameterAssert(window);
                [window addSubview:delView];
        
            }
                break;
            case 5:
            {
                //Sign out
                NeighborsSimpleCuteSignOutView *outView = [[NeighborsSimpleCuteSignOutView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT)];
                [outView setNeighborsSimpleCuteSignOutViewShowBlock:^{
                    [SVProgressHUD show];
                    dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [SVProgressHUD dismiss];
                                [SVProgressHUD showInfoWithStatus:@"Sign out successful"];
                                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:NeighborsSimple_LoginStatus];
                                [[NSUserDefaults standardUserDefaults]synchronize];
                                NeighborsSimpleCuteRootMainController *rootMainvc = [[NeighborsSimpleCuteRootMainController alloc]init];
                                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:rootMainvc];
                                        [UIApplication sharedApplication].keyWindow.rootViewController = nav;
                            });
                   });
                }];
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                NSCParameterAssert(window);
                [window addSubview:outView];
                
//                NeighborsSimpleCuteSignOutView *signoutView = [NeighborsSimpleCuteSignOutView alertViewShow];
//                [signoutView setNeighborsSimpleCuteSignOutViewShowBlock:^{
//                    [SVProgressHUD show];
//                    dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
//                            dispatch_async(dispatch_get_main_queue(), ^{
//                                [SVProgressHUD dismiss];
//                                [SVProgressHUD showInfoWithStatus:@"Sign out successful"];
//                                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:NeighborsSimple_LoginStatus];
//                                [[NSUserDefaults standardUserDefaults]synchronize];
//                                NeighborsSimpleCuteRootMainController *rootMainvc = [[NeighborsSimpleCuteRootMainController alloc]init];
//                                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:rootMainvc];
//                                [UIApplication sharedApplication].keyWindow.rootViewController = nav;
//                        });
//                    });
//                }];
//                [signoutView show];
            }
                break;
            default:
                break;
        }
    }
}

@end

// 聊天内容的内容详情带图片的

@interface NeighborsSimpleCuteMessagePictureCell()

@end

@implementation NeighborsSimpleCuteMessagePictureCell

- (UILabel *)timeLab
{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc]init];
        _timeLab.text = @"2022-02-28 11:26";
        _timeLab.textColor = [UIColor whiteColor];
        _timeLab.font = [UIFont systemFontOfSize:15];
        _timeLab.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLab;
}

- (UIView *)contentBgView
{
    if (!_contentBgView) {
        _contentBgView = [[UIView alloc]init];
        _contentBgView.backgroundColor = RGB(232, 195, 129);
        _contentBgView.layer.cornerRadius = 10.0f;
        _contentBgView.layer.masksToBounds = YES;
    }
    return _contentBgView;
}

- (UIImageView *)pictureImage
{
    if (!_pictureImage) {
        _pictureImage = [[UIImageView alloc]init];
        _pictureImage.contentMode = UIViewContentModeScaleAspectFill;
        _pictureImage.layer.cornerRadius = 10.0f;
        _pictureImage.layer.masksToBounds = YES;
    }
    return _pictureImage;
}

- (UIImageView *)iconImage
{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc]init];
        _iconImage.contentMode = UIViewContentModeScaleAspectFill;
        _iconImage.layer.cornerRadius = 45/2.0f;
        _iconImage.layer.masksToBounds = YES;
    }
    return _iconImage;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupPictureUI];
    }
    return self;
}

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        self.backgroundColor = [UIColor clearColor];
//        [self setupPictureUI];
//    }
//    return self;
//}

-(void)setupPictureUI
{
    [self addSubview:self.timeLab];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.offset(5);
    }];
    [self addSubview:self.iconImage];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.offset(15);
        make.width.height.offset(45);
    }];
    [self addSubview:self.contentBgView];
    [self.contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLab.mas_bottom).offset(8);
        make.right.mas_equalTo(self.iconImage.mas_left).offset(-15);
        make.width.offset(100);
        make.height.offset(130);
    }];
    [self.contentBgView addSubview:self.pictureImage];
    [self.pictureImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
}
@end


//聊天内容带文字内容的
@interface NeighborsSimpleCuteMessageContentCell()

@end

@implementation NeighborsSimpleCuteMessageContentCell


- (UILabel *)timeLab
{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc]init];
        _timeLab.text = @"2022-02-28 11:26";
        _timeLab.textColor = [UIColor whiteColor];
        _timeLab.font = [UIFont systemFontOfSize:15];
        _timeLab.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLab;
}

- (UIView *)contentBgView
{
    if (!_contentBgView) {
        _contentBgView = [[UIView alloc]init];
        _contentBgView.backgroundColor = RGB(232, 195, 129);
        _contentBgView.layer.cornerRadius = 10.0f;
        _contentBgView.layer.masksToBounds = YES;
    }
    return _contentBgView;
}

- (UIImageView *)iconImage
{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc]init];
        _iconImage.contentMode = UIViewContentModeScaleAspectFill;
        _iconImage.layer.cornerRadius = 45/2.0f;
        _iconImage.layer.masksToBounds = YES;
    }
    return _iconImage;
}
- (UILabel *)contentLab
{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc]init];
        _contentLab.text = @"_contentLab_contentLab_contentLab_contentLab_contentLab_contentLab";
        _contentLab.textColor = [UIColor blackColor];
        _contentLab.numberOfLines = 0 ;
        _contentLab.font = [UIFont systemFontOfSize:15];
        _contentLab.textAlignment = NSTextAlignmentLeft;
    }
    return _contentLab;
}
- (void)setModel:(SocializeIntercourseMessageModel *)model
{
    _model = model;
    self.timeLab.text = model.sendTimeStr;
    self.contentLab.text = model.sendContentStr;
    float textWidth =  [XSDKResourceUtil measureSinglelineStringWidth:model.sendContentStr andFont:[UIFont systemFontOfSize:15]];
    if (textWidth >= 240) {
        textWidth = 240;
    }else{
        textWidth += 10;
    }
    [self.contentBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLab.mas_bottom).offset(8);
        make.right.mas_equalTo(self.iconImage.mas_left).offset(-15);
        make.width.offset(textWidth);
        make.bottom.offset(-10);
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupTextUI];
    }
    return self;
}
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        self.backgroundColor = [UIColor clearColor];
//        [self setupTextUI];
//    }
//    return self;
//}

-(void)setupTextUI
{
    [self addSubview:self.timeLab];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.height.offset(20);
        make.top.offset(5);
    }];
    [self addSubview:self.iconImage];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.offset(15);
        make.width.height.offset(45);
    }];
    [self addSubview:self.contentBgView];
    [self.contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLab.mas_bottom).offset(8);
        make.right.mas_equalTo(self.iconImage.mas_left).offset(-15);
        make.width.offset(240);
        make.bottom.offset(-10);
    }];
    [self.contentBgView addSubview:self.contentLab];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5);
        make.top.offset(5);
        make.right.offset(-5);
        make.bottom.offset(-5);
    }];
}
@end

// 发送聊天界面的功能
@interface NeighborsSimpleCuteMessageChatMainController()<UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate>

@property (nonatomic,strong)UIView *bottomView;

@property (nonatomic,strong)UICollectionView *detailCollectionView;

@property (nonatomic,strong)NSMutableArray *detailListArr;

@property (nonatomic,strong)NSMutableArray *detailAllListArr;

@property (nonatomic,strong)UIButton *addPictureBtn;

@property (nonatomic,strong)UITextField *sendInputView;

@property (nonatomic,strong)UIButton *sendBtn;

@property (nonatomic,strong)UIImageView *pictureImage;

@end

@implementation NeighborsSimpleCuteMessageChatMainController

- (UIImageView *)pictureImage
{
    if (!_pictureImage) {
        _pictureImage = [[UIImageView alloc]init];
        _pictureImage.contentMode = UIViewContentModeScaleAspectFill;
        _pictureImage.hidden = YES;
    }
    return _pictureImage;
}

- (UICollectionView *)detailCollectionView
{
    if (!_detailCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        flow.minimumLineSpacing = 10;
        flow.minimumInteritemSpacing = 10;
        _detailCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flow];
        _detailCollectionView.backgroundColor = [UIColor clearColor];
        _detailCollectionView.delegate = self;
        _detailCollectionView.dataSource = self;
        [_detailCollectionView registerClass:[NeighborsSimpleCuteMessageContentCell class] forCellWithReuseIdentifier:@"NeighborsSimpleCuteMessageContentCell"];
        [_detailCollectionView registerClass:[NeighborsSimpleCuteMessagePictureCell class] forCellWithReuseIdentifier:@"NeighborsSimpleCuteMessagePictureCell"];
    }
    return _detailCollectionView;
}

- (NSMutableArray *)detailAllListArr
{
    if (!_detailAllListArr) {
        _detailAllListArr = [NSMutableArray array];
    }
    return _detailAllListArr;
}
- (NSMutableArray *)detailListArr
{
    if (!_detailListArr) {
        _detailListArr = [NSMutableArray array];
    }
    return _detailListArr;
}
- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor clearColor];
    }
    return _bottomView;
}

- (UIButton *)addPictureBtn
{
    if (!_addPictureBtn) {
        _addPictureBtn = [[UIButton alloc]init];
        [_addPictureBtn setImage:[UIImage imageNamed:TUIKitResource(@"spoiledaddphoto")] forState:UIControlStateNormal];
        [_addPictureBtn addTarget:self action:@selector(actionAddPictureBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addPictureBtn;
}

-(void)actionAddPictureBtn:(UIButton *)btn
{
    NSLog(@"actionAddPictureBtn btn");
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    [imagePickerVc setAllowPreview:NO];
    [imagePickerVc setNaviBgColor:[UIColor blackColor]];
    [imagePickerVc setAllowPickingVideo:NO];
    [imagePickerVc setIsSelectOriginalPhoto:NO];
    imagePickerVc.allowTakePicture = YES;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        self.pictureImage.image = photos[0];
        SocializeIntercourseMessageModel *model = [[SocializeIntercourseMessageModel alloc]init];
        model.storeNameStr = self.NameStr;
        model.sendTimeStr  = [self SocializeIntercourseGetCurrentTime:@"yyyy-MM-dd HH:mm:ss"];
        model.sendContentStr = @"[Picture]";
        model.sendIconStr    = self.IconStr;
        model.sendType       = @"1";
        model.sendPicture    = UIImageJPEGRepresentation(self.pictureImage.image, 1);
        [SVProgressHUD show];
        dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [[NeighborsSimpleCuteDBTool NeighborsSimpleCuteProjectSharaDBTool]insertMessageModel:model];
                    BOOL isExist = [[NeighborsSimpleCuteDBTool NeighborsSimpleCuteProjectSharaDBTool]isExistMessageStoreModel:self.NameStr];
                    if (isExist == NO) {
                        SocializeIntercourseMessageOtherModel *model = [[SocializeIntercourseMessageOtherModel alloc]init];
                        model.storeNameStr = self.NameStr;
                        model.storeTimeStr = [self SocializeIntercourseGetCurrentTime:@"yyyy-MM-dd HH:mm:ss"];
                        model.storeLastStr  = self.sendInputView.text;
                        model.storeIconStr = self.IconStr;
                        [[NeighborsSimpleCuteDBTool NeighborsSimpleCuteProjectSharaDBTool]insertMessageStoreModel:model];
                    }else{
                        NSMutableArray *array  = [[NeighborsSimpleCuteDBTool NeighborsSimpleCuteProjectSharaDBTool]queryAllMessageStoreModel];
                        SocializeIntercourseMessageOtherModel *storeModel = array[0];
                        storeModel.storeTimeStr = [self SocializeIntercourseGetCurrentTime:@"yyyy-MM-dd HH:mm:ss"];
                        storeModel.storeLastStr =  @"[Picture]";
                        [[NeighborsSimpleCuteDBTool NeighborsSimpleCuteProjectSharaDBTool]updateMessageStoreModel:storeModel];
                    }
                    self.sendInputView.text = @"";
                    [self.sendInputView resignFirstResponder];
                    [self.detailAllListArr removeAllObjects];
                    [self.detailListArr removeAllObjects];
                    self.detailAllListArr = [[NeighborsSimpleCuteDBTool NeighborsSimpleCuteProjectSharaDBTool]queryAllMessageModel];
                    for (SocializeIntercourseMessageModel *model in self.detailAllListArr) {
                        if ([model.storeNameStr isEqualToString:self.NameStr]) {
                            [self.detailListArr addObject:model];
                        }
                    }
                    [self.detailCollectionView reloadData];
                    if ([self.detailListArr count]) {   //messageData是数据源
                        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.detailListArr.count-1 inSection:0];
                        [self.detailCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:(UICollectionViewScrollPositionBottom) animated:YES];
                        }
            });
        });
    }];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (UIButton *)sendBtn
{
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc]init];
        [_sendBtn setImage:[UIImage imageNamed:TUIKitResource(@"spoiledaendmessagenewnew")] forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(actionSendBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}
-(NSString *)SocializeIntercourseGetCurrentTime:(NSString *)formatter
{
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:formatter];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter2 stringFromDate:datenow];
    NSLog(@"currentTimeString =  %@",currentTimeString);
    return currentTimeString;
}
-(void)actionSendBtn:(UIButton *)btn
{
    NSLog(@"actionSendBtn btn");
    if (IS_EMPTY(self.sendInputView.text)) {
        [SVProgressHUD showInfoWithStatus:@"Please enter the content to send"];
        return;
    }
    SocializeIntercourseMessageModel *model = [[SocializeIntercourseMessageModel alloc]init];
    model.storeNameStr = self.NameStr;
    model.sendTimeStr  = [self SocializeIntercourseGetCurrentTime:@"yyyy-MM-dd HH:mm:ss"];
    model.sendContentStr = self.sendInputView.text;
    model.sendIconStr    = self.IconStr;
    model.sendType       = @"0";
    model.sendPicture    = @"";//UIImageJPEGRepresentation(self.pictureImage.image, 1);
    [SVProgressHUD show];
    dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [[NeighborsSimpleCuteDBTool NeighborsSimpleCuteProjectSharaDBTool]insertMessageModel:model];
                BOOL isExist = [[NeighborsSimpleCuteDBTool NeighborsSimpleCuteProjectSharaDBTool]isExistMessageStoreModel:self.NameStr];
                if (isExist == NO) {
                    SocializeIntercourseMessageOtherModel *model = [[SocializeIntercourseMessageOtherModel alloc]init];
                    model.storeNameStr = self.NameStr;
                    model.storeTimeStr = [self SocializeIntercourseGetCurrentTime:@"yyyy-MM-dd HH:mm:ss"];
                    model.storeLastStr  = self.sendInputView.text;
                    model.storeIconStr = self.IconStr;
                    [[NeighborsSimpleCuteDBTool NeighborsSimpleCuteProjectSharaDBTool]insertMessageStoreModel:model];
                }else{
                    NSMutableArray *array  = [[NeighborsSimpleCuteDBTool NeighborsSimpleCuteProjectSharaDBTool]queryAllMessageStoreModel];
                    SocializeIntercourseMessageOtherModel *storeModel = array[0];
                    storeModel.storeTimeStr = [self SocializeIntercourseGetCurrentTime:@"yyyy-MM-dd HH:mm:ss"];
                    storeModel.storeLastStr =  self.sendInputView.text;
                    [[NeighborsSimpleCuteDBTool NeighborsSimpleCuteProjectSharaDBTool]updateMessageStoreModel:storeModel];
                }
                self.sendInputView.text = @"";
                [self.sendInputView resignFirstResponder];
                [self.detailAllListArr removeAllObjects];
                [self.detailListArr removeAllObjects];
                self.detailAllListArr = [[NeighborsSimpleCuteDBTool NeighborsSimpleCuteProjectSharaDBTool]queryAllMessageModel];
                for (SocializeIntercourseMessageModel *model in self.detailAllListArr) {
                    if ([model.storeNameStr isEqualToString:self.NameStr]) {
                        [self.detailListArr addObject:model];
                    }
                }
                [self.detailCollectionView reloadData];
                if ([self.detailListArr count]) {   //messageData是数据源
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.detailListArr.count-1 inSection:0];
                    [self.detailCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:(UICollectionViewScrollPositionBottom) animated:YES];
                    }
        });
    });
}
- (UITextField *)sendInputView
{
    if (!_sendInputView) {
        _sendInputView = [[UITextField alloc]init];
        _sendInputView.backgroundColor = RGB(50, 50, 50);
        _sendInputView.layer.cornerRadius = 20.0f;
        _sendInputView.layer.masksToBounds = YES;
        _sendInputView.textColor = [UIColor whiteColor];
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 10)];
        _sendInputView.leftViewMode = UITextFieldViewModeAlways;
        _sendInputView.leftView = leftView;
        NSMutableAttributedString *attribuedString = [[NSMutableAttributedString alloc]initWithString:@"Message here..."];
        [attribuedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:RGB(172, 172, 172)} range:NSMakeRange(0, attribuedString.length)];
        _sendInputView.attributedPlaceholder= attribuedString;
    }
    return _sendInputView;
}
-(void)dealloc
{
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [self.detailAllListArr removeAllObjects];
    [self.detailListArr removeAllObjects];
    self.detailAllListArr = [[NeighborsSimpleCuteDBTool NeighborsSimpleCuteProjectSharaDBTool]queryAllMessageModel];
    for (SocializeIntercourseMessageModel *model in self.detailAllListArr) {
        if ([model.storeNameStr isEqualToString:self.NameStr]) {
            [self.detailListArr addObject:model];
        }
    }
    [self.detailCollectionView reloadData];
    if ([self.detailListArr count]) {   //messageData是数据源
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.detailListArr.count-1 inSection:0];
        [self.detailCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:(UICollectionViewScrollPositionBottom) animated:YES];
    }
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.NameStr;
    [self NeighborsSimpleCuteSetRightButton:[UIImage imageNamed:TUIKitResource(@"chatsetting")]];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(60);
    }];
    [self.bottomView addSubview:self.addPictureBtn];
    [self.addPictureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bottomView);
        make.left.offset(15);
        make.width.height.offset(40);
    }];
    [self.bottomView  addSubview:self.sendBtn];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bottomView);
        make.right.offset(-15);
        make.width.height.offset(40);
    }];
    [self.bottomView addSubview:self.sendInputView];
    [self.sendInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bottomView);
        make.left.mas_equalTo(self.addPictureBtn.mas_right).offset(15);
        make.right.mas_equalTo(self.sendBtn.mas_left).offset(-15);
        make.height.offset(40);
    }];
    [self.view addSubview:self.detailCollectionView];
    [self.detailCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.bottom.mas_equalTo(self.bottomView.mas_top).offset(0);
    }];
    [self.view addSubview:self.pictureImage];
    [self.pictureImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.view);
        make.width.offset(200);
        make.height.offset(200);
    }];
}
#pragma mark --   detailCollectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.detailListArr.count;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SocializeIntercourseMessageModel *model = self.detailListArr[indexPath.row];
  float textWidth =  [XSDKResourceUtil measureSinglelineStringWidth:model.sendContentStr andFont:[UIFont systemFontOfSize:15]];
    if (textWidth >= 240) {
        textWidth = 240;
    }else{
        textWidth += 10;
    }
   float hight = [XSDKResourceUtil measureMutilineStringHeight:model.sendContentStr andFont:[UIFont systemFontOfSize:15] andWidthSetup:textWidth];
    if ([model.sendType isEqualToString:@"0"]) {
        //带文字
        return CGSizeMake(IPHONE_WIDTH, hight + 55);
    }else{
        //带图片
        return  CGSizeMake(IPHONE_WIDTH, 160);
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        SocializeIntercourseMessageModel *model = self.detailListArr[indexPath.row];
        if ([model.sendType isEqualToString:@"0"]) {
            //文字功能
            NeighborsSimpleCuteMessageContentCell *messageCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NeighborsSimpleCuteMessageContentCell" forIndexPath:indexPath];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:
                                          [NSString stringWithFormat:(@"n_add_sened_img.png")]];
            // 保存文件的名称
            UIImage *img = [UIImage imageWithContentsOfFile:filePath];
            NSLog(@"img:%@",img);
            if (img) {
                    messageCell.iconImage.image = img;
                }else{
                    messageCell.iconImage.image = [UIImage imageNamed:TUIKitResource(@"n_default_bg.png")];
            }
            messageCell.model = model;
            return messageCell;
        }else{
            //图片功能
            NeighborsSimpleCuteMessagePictureCell *messagePictureCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NeighborsSimpleCuteMessagePictureCell" forIndexPath:indexPath];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:
                                          [NSString stringWithFormat:(@"n_add_sened_img.png")]];
            // 保存文件的名称
            UIImage *img = [UIImage imageWithContentsOfFile:filePath];
            NSLog(@"img:%@",img);
            if (img) {
                    messagePictureCell.iconImage.image = img;
                }else{
                    messagePictureCell.iconImage.image = [UIImage imageNamed:TUIKitResource(@"n_default_bg.png")];
            }
            messagePictureCell.timeLab.text = [NSString stringWithFormat:@"%@",model.sendTimeStr];
            messagePictureCell.pictureImage.image = [UIImage imageWithData:model.sendPicture];
            return messagePictureCell;
        }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.detailListArr.count;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    SocializeIntercourseMessageModel *model = self.detailListArr[indexPath.row];
//   float textWidth =  [XSDKResourceUtil measureSinglelineStringWidth:model.sendContentStr andFont:[UIFont systemFontOfSize:15]];
//    NSLog(@"textWith:%f",textWidth);
//    if ([model.sendType isEqualToString:@"0"]) {
//        CGFloat height = [self SocializeIntercourseGetLSwLabelHeightWithText:model.sendContentStr width:240 font:15];
//        return height + 70;
//    }else{
//        return 160;
//    }
//}
//
//-(float)SocializeIntercourseGetLSwLabelHeightWithText:(NSString *)text width:(float)width font: (float)font
//{
//    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
//    return rect.size.height;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    SocializeIntercourseMessageModel *model = self.detailListArr[indexPath.row];
//    if ([model.sendType isEqualToString:@"0"]) {
//        //文字功能
//        NeighborsSimpleCuteMessageContentCell *messageCell = [tableView dequeueReusableCellWithIdentifier:@"NeighborsSimpleCuteMessageContentCell" forIndexPath:indexPath];
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//        NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:
//                                      [NSString stringWithFormat:(@"n_add_sened_img.png")]];
//        // 保存文件的名称
//        UIImage *img = [UIImage imageWithContentsOfFile:filePath];
//        NSLog(@"img:%@",img);
//        if (img) {
//                messageCell.iconImage.image = img;
//            }else{
//                messageCell.iconImage.image = [UIImage imageNamed:TUIKitResource(@"n_default_bg.png")];
//        }
//        messageCell.timeLab.text = model.sendTimeStr;
//        messageCell.contentLab.text = model.sendContentStr;
//        messageCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return messageCell;
//    }else{
//        //图片功能
//        NeighborsSimpleCuteMessagePictureCell *messagePictureCell = [tableView dequeueReusableCellWithIdentifier:@"NeighborsSimpleCuteMessagePictureCell" forIndexPath:indexPath];
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//        NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:
//                                      [NSString stringWithFormat:(@"n_add_sened_img.png")]];
//        // 保存文件的名称
//        UIImage *img = [UIImage imageWithContentsOfFile:filePath];
//        NSLog(@"img:%@",img);
//        if (img) {
//                messagePictureCell.iconImage.image = img;
//            }else{
//                messagePictureCell.iconImage.image = [UIImage imageNamed:TUIKitResource(@"n_default_bg.png")];
//        }
//        messagePictureCell.timeLab.text = [NSString stringWithFormat:@"%@",model.sendTimeStr];
//        messagePictureCell.pictureImage.image = [UIImage imageWithData:model.sendPicture];
//        messagePictureCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return messagePictureCell;
//    }
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}
//举报功能
- (void)onNeighborsSimpleCuteRightBackBtn:(UIButton *)btn
{
    NSLog(@"举报功能");
    NeighborsSimpleCuteReportView *repotview = [[NeighborsSimpleCuteReportView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT)];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    NSCParameterAssert(window);
    [repotview setNeighborsSimpleCuteReportViewBlockBlock:^{
        [SVProgressHUD showInfoWithStatus:@"This member has been successfully moved to your blacklist"];
    }];
    [repotview setNeighborsSimpleCuteReportViewReportBlock:^{
        NeighborsSimpleCuteSettingFeedBackController *feedbackvc = [[NeighborsSimpleCuteSettingFeedBackController alloc]init];
        feedbackvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:feedbackvc animated:YES];
    }];
    [window addSubview:repotview];
}
@end

// 聊天界面cell
@interface NeighborsSimpleCuteMessageListCell ()

@end

@implementation NeighborsSimpleCuteMessageListCell

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.backgroundColor = [UIColor clearColor];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.layer.cornerRadius = 40.0f;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _iconImageView.layer.borderWidth = 1.5;
    }
    return _iconImageView;
}
- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor = RGB(247, 191, 70);
        _titleLab.text = @"TestTest";
        _titleLab.font = [UIFont systemFontOfSize:18];
        _titleLab.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLab;
}

- (UILabel *)subTitleLab
{
    if (!_subTitleLab) {
        _subTitleLab = [[UILabel alloc]init];
        _subTitleLab.textColor = RGB(166, 166, 166);
        _subTitleLab.text = @"hello djghsajdgasjjkdsahskjfdss...";
        _subTitleLab.font = [UIFont fontWithName:@"MyriadPro-Regular" size:15];
        _subTitleLab.textAlignment = NSTextAlignmentLeft;
    }
    return _subTitleLab;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = NSC_BGThemColor2;
        self.contentView.layer.cornerRadius = 10.0f;
        self.contentView.layer.masksToBounds = YES;
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    [self addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.offset(15);
        make.width.height.offset(80);
    }];
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView).offset(-15);
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(10);
        make.right.offset(-10);
    }];
    [self addSubview:self.subTitleLab];
    [self.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(10);
        make.right.offset(-10);
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(10);
    }];
}

@end

// 聊天界面的功能

@interface NeighborsSimpleCuteMessageMainController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UIImageView *typeImg;

@property (nonatomic,strong)UILabel *typeAlterLab;

@property (nonatomic,strong)UICollectionView *messageCollectionView;

@property (nonatomic,strong)NSMutableArray *messageListArr;

@end

@implementation NeighborsSimpleCuteMessageMainController

- (NSMutableArray *)messageListArr
{
    if (!_messageListArr) {
        _messageListArr = [NSMutableArray array];
    }
    return _messageListArr;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view addSubview:self.messageCollectionView];
    [self.messageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    [self.view addSubview:self.typeImg];
    [self.typeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).offset(-40);
    }];
    [self.view addSubview:self.typeAlterLab];
    [self.typeAlterLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(40);
        make.right.offset(-40);
        make.top.mas_equalTo(self.typeImg.mas_bottom).offset(30);
    }];
    [self.messageListArr removeAllObjects];
    self.messageListArr = [[NeighborsSimpleCuteDBTool NeighborsSimpleCuteProjectSharaDBTool]queryAllMessageStoreModel];
    if (self.messageListArr.count == 0) {
        self.typeImg.hidden  = NO;
        self.typeAlterLab.hidden = NO;
        self.messageCollectionView.hidden = YES;
    }else{
        self.typeImg.hidden = YES;
        self.typeAlterLab.hidden = YES;
        self.messageCollectionView.hidden = NO;
    }
    [self.messageCollectionView reloadData];
}
- (UICollectionView *)messageCollectionView
{
    if (!_messageCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        flow.minimumLineSpacing = 10;
        flow.minimumInteritemSpacing = 10;
        _messageCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flow];
        _messageCollectionView.backgroundColor = [UIColor clearColor];
        _messageCollectionView.delegate = self;
        _messageCollectionView.dataSource = self;
        [_messageCollectionView registerClass:[NeighborsSimpleCuteMessageListCell class] forCellWithReuseIdentifier:@"NeighborsSimpleCuteMessageListCell"];
    }
    return _messageCollectionView;
}
- (UIImageView *)typeImg
{
    if (!_typeImg) {
        _typeImg = [[UIImageView alloc]init];
        _typeImg.image = [UIImage imageNamed:TUIKitResource(@"n_nomessageshow_alter")];
        _typeImg.contentMode =  UIViewContentModeScaleAspectFit;
    }
    return _typeImg;
}
- (UILabel *)typeAlterLab
{
    if (!_typeAlterLab) {
        _typeAlterLab = [[UILabel alloc]init];
        _typeAlterLab.text = @"You haven't received any message yet. Upload your voice for more attention.";
        _typeAlterLab.textColor = RGB(237, 151, 64);
        _typeAlterLab.textAlignment = NSTextAlignmentCenter;
        _typeAlterLab.numberOfLines = 0;
    }
    return _typeAlterLab;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Message";
}
#pragma mark -- NeighborsSimpleCuteMessageMainController -- UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.messageListArr.count;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 0, 0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH-20, 100);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NeighborsSimpleCuteMessageListCell *mesageListCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NeighborsSimpleCuteMessageListCell" forIndexPath:indexPath];
    SocializeIntercourseMessageOtherModel *model = self.messageListArr[indexPath.row];
    [mesageListCell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.storeIconStr]];
    mesageListCell.titleLab.text = [NSString stringWithFormat:@"%@",model.storeNameStr];
    mesageListCell.subTitleLab.text = [NSString stringWithFormat:@"%@",model.storeLastStr];
    return mesageListCell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    SocializeIntercourseMessageOtherModel *model = self.messageListArr[indexPath.row];
    NeighborsSimpleCuteMessageChatMainController *messageChatVc = [[NeighborsSimpleCuteMessageChatMainController alloc]init];
    messageChatVc.hidesBottomBarWhenPushed = YES;
    messageChatVc.NameStr = model.storeNameStr;
    messageChatVc.IconStr  = model.storeIconStr;
    [self.navigationController pushViewController:messageChatVc animated:YES];
}
@end

@interface NeighborsSimpleCuteSettingContentViewCell ()

@end

@implementation NeighborsSimpleCuteSettingContentViewCell

- (UIImageView *)iconImg
{
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc]init];
        _iconImg.image = [UIImage imageNamed:TUIKitResource(@"test")];
        _iconImg.contentMode = UIViewContentModeScaleAspectFill;
        _iconImg.layer.cornerRadius= 60;
        _iconImg.layer.masksToBounds = YES;
        _iconImg.layer.borderColor = NSC_MainThemColor.CGColor;
        _iconImg.layer.borderWidth = 2.0f;
    }
    return _iconImg;
}
- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.text = @"Test";
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.font = [UIFont systemFontOfSize:16];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI
{
    [self addSubview:self.iconImg];
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.offset(10);
        make.width.height.offset(120);
    }];
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.iconImg.mas_bottom).offset(15);
    }];
}
@end

@interface NeighborsSimpleCuteSettingRechargeViewCell()

@end


@implementation NeighborsSimpleCuteSettingRechargeViewCell

- (UIButton *)rechagerBtn
{
    if (!_rechagerBtn) {
        _rechagerBtn = [[UIButton alloc]init];
        [_rechagerBtn setImage:[UIImage imageNamed:TUIKitResource(@"zf_profile_update")] forState:UIControlStateNormal];
        [_rechagerBtn setTitle:@"    Upgrade" forState:UIControlStateNormal];
        [_rechagerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rechagerBtn addTarget:self action:@selector(actionRechageBtn:) forControlEvents:UIControlEventTouchUpInside];
        _rechagerBtn.layer.cornerRadius = 10.0f;
        _rechagerBtn.layer.masksToBounds = YES;
        [_rechagerBtn gradientButtonWithSize:CGSizeMake((IPHONE_WIDTH - 60),60) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 63)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    }
    return _rechagerBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    [self addSubview:self.rechagerBtn];
    [self.rechagerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self);
        make.width.offset(IPHONE_WIDTH-60);
        make.height.height.offset(60);
    }];
}

-(void)actionRechageBtn:(UIButton *)btn
{
    NSLog(@"购买会员");
    if (self.NeighborsSimpleCuteSettingRechargeViewCellRechageBlock) {
        self.NeighborsSimpleCuteSettingRechargeViewCellRechageBlock();
    }
}

@end

/// 新ui设计的功能
@interface NeighborsSimpleCuteSettingHeaderOtherViewCell ()


@end

@implementation NeighborsSimpleCuteSettingHeaderOtherViewCell

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = NSC_BGThemColor2;
        _bgView.layer.cornerRadius = 65.0f;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}
- (UIImageView *)iconImg
{
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc]init];
        _iconImg.image = [UIImage imageNamed:TUIKitResource(@"n_setting_profile")];
        _iconImg.contentMode = UIViewContentModeScaleAspectFill;
        _iconImg.layer.cornerRadius = 60.0f;
        _iconImg.layer.masksToBounds = YES;
    }
    return _iconImg;
}
- (UIButton *)nameBtn
{
    if (!_nameBtn) {
        _nameBtn = [[UIButton alloc]init];
        [_nameBtn setTitle:@"测试功能" forState:UIControlStateNormal];
        [_nameBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nameBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [_nameBtn setImage:[UIImage imageNamed:TUIKitResource(@"name_huang")] forState:UIControlStateNormal];
        [_nameBtn setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    }
    return _nameBtn;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.contentView.backgroundColor = NSC_BGThemColor2;
        [self setupUI];
    }
    return self;
}
-(void)setupUI
{
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self).offset(-20);
        make.width.height.offset(130);
    }];
    [self addSubview:self.iconImg];
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self).offset(-20);
        make.width.height.offset(120);
    }];
    [self addSubview:self.nameBtn];
    [self.nameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.iconImg.mas_bottom).offset(20);
    }];
}

@end

@interface NeighborsSimpleCuteSettingRechargeOtherViewCell()

@end

@implementation NeighborsSimpleCuteSettingRechargeOtherViewCell

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = NSC_BGThemColor2;
        _bgView.layer.cornerRadius = 10.0f;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}
- (UIButton *)rechagerBtn
{
    if (!_rechagerBtn) {
        _rechagerBtn = [[UIButton alloc]init];
        [_rechagerBtn setImage:[UIImage imageNamed:TUIKitResource(@"grzxer_upgrade")] forState:UIControlStateNormal];
        [_rechagerBtn setTitle:@"   Upgrade to Permium Member" forState:UIControlStateNormal];
        [_rechagerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_rechagerBtn addTarget:self action:@selector(actionRechageBtn:) forControlEvents:UIControlEventTouchUpInside];
        _rechagerBtn.layer.cornerRadius = 10.0f;
        _rechagerBtn.layer.masksToBounds = YES;
        [_rechagerBtn gradientButtonWithSize:CGSizeMake((IPHONE_WIDTH - 60),60) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 63)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromTopToBottom];
    }
    return _rechagerBtn;
}


-(void)actionRechageBtn:(UIButton *)btn
{
    //upgrade to Permium Member
    if (self.NeighborsSimpleCuteSettingRechargeViewCellRechageBlock) {
        self.NeighborsSimpleCuteSettingRechargeViewCellRechageBlock();
    }
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self);
        make.width.offset(IPHONE_WIDTH-30);
        make.height.height.offset(90);
    }];
    [self addSubview:self.rechagerBtn];
    [self.rechagerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self);
        make.width.offset(IPHONE_WIDTH-40);
        make.height.height.offset(80);
    }];
}
@end

// base setting

@interface NeighborsSimpleCuteBaseSettingContentViewCell()

@end

@implementation NeighborsSimpleCuteBaseSettingContentViewCell

- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.text = @"Test";
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.font = [UIFont systemFontOfSize:17];
        _titleLab.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLab;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = RGB(41, 41, 41);
        self.layer.cornerRadius = 8.0f;
        self.layer.masksToBounds = YES;
        [self setupUI];
    }
    return self;
}
-(void)setupUI
{
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.offset(15);
        make.right.offset(-15);
    }];
}

@end

@interface NeighborsSimpleCuteSettingContentOtherViewCell ()


@end

@implementation NeighborsSimpleCuteSettingContentOtherViewCell

- (UIImageView *)iconImg
{
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc]init];
        _iconImg.image = [UIImage imageNamed:TUIKitResource(@"test")];
        _iconImg.contentMode = UIViewContentModeScaleAspectFit;
        //_iconImg.layer.cornerRadius= 30;
        //_iconImg.layer.masksToBounds = YES;
        //_iconImg.layer.borderColor = NSC_MainThemColor.CGColor;
        //_iconImg.layer.borderWidth = 2.0f;
    }
    return _iconImg;
}
- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.text = @"Test";
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.font = [UIFont systemFontOfSize:16];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = NSC_BGThemColor2;
        self.layer.cornerRadius = 15.0f;
        self.layer.masksToBounds = YES;
        [self setupUI];
    }
    return self;
}
-(void)setupUI
{
    [self addSubview:self.iconImg];
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.offset(25);
        //make.width.height.offset(60);
    }];
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.iconImg.mas_bottom).offset(10);
    }];
}

@end

@interface NeighborsSimpleCuteSettingHeaderViewCell ()


@end

@implementation NeighborsSimpleCuteSettingHeaderViewCell

- (UIImageView *)iconImg
{
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc]init];
        _iconImg.image = [UIImage imageNamed:TUIKitResource(@"n_setting_profile")];
        _iconImg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconImg;
}

- (UILabel *)iconLab
{
    if (!_iconLab) {
        _iconLab = [[UILabel alloc]init];
        _iconLab.text = @"About us";
        _iconLab.textColor = RGB(237, 151, 64);
        _iconLab.font = [UIFont systemFontOfSize:16];
        _iconLab.textAlignment = NSTextAlignmentCenter;
    }
    return _iconLab;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = NSC_BGThemColor2;
        self.contentView.layer.cornerRadius = 15.0f;
        self.contentView.layer.masksToBounds = YES;
        [self setupUI];
    }
    return self;
}
-(void)setupUI
{
    [self addSubview:self.iconImg];
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self).offset(-20);
    }];
    [self addSubview:self.iconLab];
    [self.iconLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.iconImg.mas_bottom).offset(20);
    }];
}
@end

@interface NeighborsSimpleCuteDelAccountView ()

@property (nonatomic,strong)UIView *bgView;

@property (nonatomic,strong)UILabel *alterLab;

@property (nonatomic,strong)UILabel *alterContentLab;

@property (nonatomic,strong)UIButton *cancelBtn;

@property (nonatomic,strong)UIButton *signOutBtn;

@end

@implementation NeighborsSimpleCuteDelAccountView

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = RGB(50, 48, 49);
        _bgView.layer.cornerRadius = 8.0f;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}
- (UILabel *)alterContentLab
{
    if (!_alterContentLab) {
        _alterContentLab = [[UILabel alloc]init];
        _alterContentLab.text = @"If you delete your account, you will permanently lose your profile, voice, messages, photo.";
        _alterContentLab.numberOfLines = 0 ;
        _alterContentLab.textColor = [UIColor whiteColor];
        _alterContentLab.textAlignment = NSTextAlignmentCenter;
    }
    return _alterContentLab;
}
- (UILabel *)alterLab
{
    if (!_alterLab) {
        _alterLab = [[UILabel  alloc]init];
        _alterLab.text = @"Delete my account ？";
        _alterLab.textColor = RGB(237, 151, 64);
        _alterLab.font = [UIFont boldSystemFontOfSize:17];
        _alterLab.textAlignment = NSTextAlignmentCenter;
    }
    return _alterLab;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]init];
        _cancelBtn.layer.cornerRadius = 25.0f;
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelBtn addTarget:self action:@selector(actionDelCancelbtn:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn gradientButtonWithSize:CGSizeMake((IPHONE_WIDTH - 100)/2,50) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 63)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    }
    return _cancelBtn;
}

- (UIButton *)signOutBtn
{
    if (!_signOutBtn) {
        _signOutBtn = [[UIButton alloc]init];
        _signOutBtn.layer.cornerRadius = 25.0f;
        _signOutBtn.layer.masksToBounds = YES;
        [_signOutBtn setTitle:@"Confirm" forState:UIControlStateNormal];
        [_signOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _signOutBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_signOutBtn addTarget:self action:@selector(actionDelConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_signOutBtn gradientButtonWithSize:CGSizeMake((IPHONE_WIDTH - 100)/2,50) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 63)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    }
    return _signOutBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    self.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.offset(330);
    }];
    [self.bgView addSubview:self.alterContentLab];
    [self.alterContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView);
        make.centerY.mas_equalTo(self.bgView).offset(-20);
        make.left.offset(20);
        make.right.offset(-20);
    }];
    [self.bgView addSubview:self.alterLab];
    [self.alterLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView);
        make.bottom.mas_equalTo(self.alterContentLab.mas_top).offset(-30);
    }];
    [self.bgView addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.bottom.offset(-40);
        make.width.offset((IPHONE_WIDTH - 100)/2);
        make.height.offset(50);
    }];
    [self.bgView addSubview:self.signOutBtn];
    [self.signOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.bottom.offset(-40);
        make.width.offset((IPHONE_WIDTH - 100)/2);
        make.height.offset(50);
    }];
}

-(void)actionDelCancelbtn:(UIButton *)btn
{
    NSLog(@"actionDelCancelbtnactionDelCancelbtnactionDelCancelbtn");
    [self removeFromSuperview];
}

-(void)actionDelConfirmBtn:(UIButton *)btn
{
    NSLog(@"actionDelConfirmBtnactionDelConfirmBtnactionDelConfirmBtnactionDelConfirmBtn");
    if (self.NeighborsSimpleCuteDelAccountViewBlock) {
        self.NeighborsSimpleCuteDelAccountViewBlock();
    }
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self];
    if (![self.bgView pointInside:[self.bgView convertPoint:location fromView:self.bgView.window] withEvent:nil]){
        [self removeFromSuperview];
    }
}

@end

@interface NeighborsSimpleCuteChnageNameView ()

@property (nonatomic,strong)UIView *bgView;

@property (nonatomic,strong)UILabel *alterLab;

@property (nonatomic,strong)UIButton *cancelBtn;

@property (nonatomic,strong)UITextField *nameTF;

@property (nonatomic,strong)UIButton *signOutBtn;

@end

@implementation NeighborsSimpleCuteChnageNameView

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = NSC_BGThemColor;
        _bgView.layer.cornerRadius = 8.0f;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UITextField *)nameTF
{
    if (!_nameTF) {
        _nameTF = [[UITextField alloc]init];
        _nameTF.placeholder = @"Please enter your username";
        _nameTF.textColor = [UIColor  whiteColor];
        _nameTF.backgroundColor = RGB(100, 100, 100);
        _nameTF.layer.cornerRadius = 5.0f;
        _nameTF.layer.masksToBounds = YES;
        _nameTF.textAlignment = NSTextAlignmentLeft;
    }
    return _nameTF;
}
- (UILabel *)alterLab
{
    if (!_alterLab) {
        _alterLab = [[UILabel  alloc]init];
        _alterLab.text = @"Change username";
        _alterLab.textColor = RGB(237, 151, 64);
        _alterLab.font = [UIFont boldSystemFontOfSize:17];
        _alterLab.textAlignment = NSTextAlignmentCenter;
    }
    return _alterLab;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]init];
        _cancelBtn.layer.cornerRadius = 25.0f;
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelBtn addTarget:self action:@selector(actionCancelbtn:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn gradientButtonWithSize:CGSizeMake((IPHONE_WIDTH - 100)/2,50) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 63)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    }
    return _cancelBtn;
}

- (UIButton *)signOutBtn
{
    if (!_signOutBtn) {
        _signOutBtn = [[UIButton alloc]init];
        _signOutBtn.layer.cornerRadius = 25.0f;
        _signOutBtn.layer.masksToBounds = YES;
        [_signOutBtn setTitle:@"Submit" forState:UIControlStateNormal];
        [_signOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _signOutBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_signOutBtn addTarget:self action:@selector(actionSignOutBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_signOutBtn gradientButtonWithSize:CGSizeMake((IPHONE_WIDTH - 100)/2,50) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 63)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    }
    return _signOutBtn;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    self.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.offset(220);
    }];
    [self.bgView addSubview:self.alterLab];
    [self.alterLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView);
        make.top.offset(30);
    }];
    
    [self.bgView addSubview:self.nameTF];
    [self.nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.top.mas_equalTo(self.alterLab.mas_bottom).offset(20);
        make.height.offset(40);
    }];
    
    [self.bgView addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.mas_equalTo(self.nameTF.mas_bottom).offset(20);
        make.width.offset((IPHONE_WIDTH - 100)/2);
        make.height.offset(50);
    }];
    [self.bgView addSubview:self.signOutBtn];
    [self.signOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.top.mas_equalTo(self.nameTF.mas_bottom).offset(20);
        make.width.offset((IPHONE_WIDTH - 100)/2);
        make.height.offset(50);
    }];
    
    NSString *nameStr = [NeighborsSimpleCuteUserModel getUserInfo].userInfo.nickName;
    //[[NSUserDefaults standardUserDefaults]valueForKey:NeighborsSimple_EmailUser];
    self.nameTF.text = nameStr;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self];
    if (![self.bgView pointInside:[self.bgView convertPoint:location fromView:self.bgView.window] withEvent:nil]){
        [self removeFromSuperview];
    }
}

-(void)actionCancelbtn:(UIButton *)btn
{
    NSLog(@"actionCancelbtnactionCancelbtnactionCancelbtnactionCancelbtn");
    [self removeFromSuperview];
}

-(void)actionSignOutBtn:(UIButton *)btn
{
    NSLog(@"actionSignOutBtnactionSignOutBtnactionSignOutBtn");
    if (self.nameTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"Please enter your username"];
        return;
    }
    if (self.NeighborsSimpleCuteChnageNameViewBlcok) {
        self.NeighborsSimpleCuteChnageNameViewBlcok(self.nameTF.text);
    }
    [self removeFromSuperview];
}
@end

// 举报view alter

@interface NeighborsSimpleCuteReportView ()

@property (nonatomic,strong)UIButton *reportBtn;

@property (nonatomic,strong)UIButton *blockBtn;

@property (nonatomic,strong)UIButton *cancelBtn;

@end

@implementation NeighborsSimpleCuteReportView

- (UIButton *)reportBtn
{
    if (!_reportBtn) {
        _reportBtn = [[UIButton alloc]init];
        _reportBtn.backgroundColor = NSC_BGThemColor2;
        [_reportBtn setTitle:@"Report" forState:UIControlStateNormal];
        [_reportBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _reportBtn.titleLabel.font = [UIFont fontWithName:@"ArialMT" size:17];
        _reportBtn.layer.cornerRadius = 10.f;
        _reportBtn.layer.masksToBounds = YES;
        [_reportBtn addTarget:self action:@selector(actionReportBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reportBtn;
}

-(void)actionReportBtn:(UIButton *)btn
{
    if (self.NeighborsSimpleCuteReportViewReportBlock) {
        self.NeighborsSimpleCuteReportViewReportBlock();
    }
    [self removeFromSuperview];
}
- (UIButton *)blockBtn
{
    if (!_blockBtn) {
        _blockBtn = [[UIButton alloc]init];
        _blockBtn.backgroundColor = NSC_BGThemColor2;
        [_blockBtn setTitle:@"Block" forState:UIControlStateNormal];
        [_blockBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _blockBtn.titleLabel.font = [UIFont fontWithName:@"ArialMT" size:17];
        _blockBtn.layer.cornerRadius = 10.f;
        _blockBtn.layer.masksToBounds = YES;
        [_blockBtn addTarget:self action:@selector(actionBlockBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _blockBtn;
}

-(void)actionBlockBtn:(UIButton *)btn
{
    if (self.NeighborsSimpleCuteReportViewBlockBlock) {
        self.NeighborsSimpleCuteReportViewBlockBlock();
    }
    [self removeFromSuperview];
}
- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]init];
        _cancelBtn.backgroundColor = NSC_BGThemColor2;
        [_cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont fontWithName:@"ArialMT" size:17];
        _cancelBtn.layer.cornerRadius = 10.f;
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn addTarget:self action:@selector(actionCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

-(void)actionCancelBtn:(UIButton *)btn
{
    if (self.NeighborsSimpleCuteReportViewCancelBlock) {
        self.NeighborsSimpleCuteReportViewCancelBlock();
    }
    [self removeFromSuperview];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupRepotUI];
    }
    return self;
}

-(void)setupRepotUI
{
    self.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.bottom.offset(-10);
        make.height.offset(55);
    }];
    [self addSubview:self.blockBtn];
    [self.blockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.bottom.mas_equalTo(self.cancelBtn.mas_top).offset(-15);
        make.height.offset(55);
    }];
    [self addSubview:self.reportBtn];
    [self.reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.bottom.mas_equalTo(self.blockBtn.mas_top).offset(-15);
        make.height.offset(55);
    }];
}
@end

@interface NeighborsSimpleCuteSignOutView ()

@property (nonatomic,strong)UIView *bgView;

@property (nonatomic,strong)UILabel *alterLab;

@property (nonatomic,strong)UIButton *cancelBtn;

@property (nonatomic,strong)UIButton *signOutBtn;

@end

@implementation NeighborsSimpleCuteSignOutView

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = RGB(50, 48, 49);
        _bgView.layer.cornerRadius = 8.0f;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UILabel *)alterLab
{
    if (!_alterLab) {
        _alterLab = [[UILabel  alloc]init];
        _alterLab.text = @"Are you sure you want to sign out？";
        _alterLab.textColor = RGB(237, 151, 64);
        _alterLab.font = [UIFont boldSystemFontOfSize:17];
        _alterLab.textAlignment = NSTextAlignmentCenter;
    }
    return _alterLab;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]init];
        _cancelBtn.layer.cornerRadius = 25.0f;
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelBtn addTarget:self action:@selector(actionCancelbtn:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn gradientButtonWithSize:CGSizeMake((IPHONE_WIDTH - 100)/2,50) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 63)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    }
    return _cancelBtn;
}

- (UIButton *)signOutBtn
{
    if (!_signOutBtn) {
        _signOutBtn = [[UIButton alloc]init];
        _signOutBtn.layer.cornerRadius = 25.0f;
        _signOutBtn.layer.masksToBounds = YES;
        [_signOutBtn setTitle:@"Sign out" forState:UIControlStateNormal];
        [_signOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _signOutBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_signOutBtn addTarget:self action:@selector(actionSignOutBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_signOutBtn gradientButtonWithSize:CGSizeMake((IPHONE_WIDTH - 100)/2,50) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 63)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    }
    return _signOutBtn;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    self.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.offset(260);
    }];
    [self.bgView addSubview:self.alterLab];
    [self.alterLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView);
        make.centerY.mas_equalTo(self.bgView).offset(-40);
    }];
    [self.bgView addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.bottom.offset(-40);
        make.width.offset((IPHONE_WIDTH - 100)/2);
        make.height.offset(50);
    }];
    [self.bgView addSubview:self.signOutBtn];
    [self.signOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.bottom.offset(-40);
        make.width.offset((IPHONE_WIDTH - 100)/2);
        make.height.offset(50);
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self];
    if (![self.bgView pointInside:[self.bgView convertPoint:location fromView:self.bgView.window] withEvent:nil]){
        [self removeFromSuperview];
    }
}

-(void)actionCancelbtn:(UIButton *)btn
{
    NSLog(@"actionCancelbtnactionCancelbtnactionCancelbtnactionCancelbtn");
    [self removeFromSuperview];
}

-(void)actionSignOutBtn:(UIButton *)btn
{
    NSLog(@"actionSignOutBtnactionSignOutBtnactionSignOutBtn");
    if (self.NeighborsSimpleCuteSignOutViewShowBlock) {
        self.NeighborsSimpleCuteSignOutViewShowBlock();
    }
    [self removeFromSuperview];
}
@end

@interface NeighborsSimpleCuteDelAccountController ()

@property (nonatomic,strong)UITextField *forget_email_tf;

@property (nonatomic,strong)UIView *forget_eamil_view;

@property (nonatomic,strong)UILabel *forget_detail_lab;

@property (nonatomic,strong)UIButton *forget_contiute_btn;
@end

@implementation NeighborsSimpleCuteDelAccountController


- (UITextField *)forget_email_tf
{
    if (!_forget_email_tf) {
        _forget_email_tf = [[UITextField alloc]init];
        _forget_email_tf.enabled = NO;
        _forget_email_tf.font = [UIFont systemFontOfSize:16];
        _forget_email_tf.textColor = [UIColor whiteColor];
        _forget_email_tf.textAlignment = NSTextAlignmentCenter;
        NSMutableAttributedString *attribuedString = [[NSMutableAttributedString alloc]initWithString:@"Enter your email or username"];
        [attribuedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:RGB(123, 123, 123)} range:NSMakeRange(0, attribuedString.length)];
        _forget_email_tf.attributedPlaceholder= attribuedString;
        UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
        _forget_email_tf.leftView = view1;
        _forget_email_tf.leftViewMode = UITextFieldViewModeAlways;
    }
    return _forget_email_tf;
}

- (UIView *)forget_eamil_view
{
    if (!_forget_eamil_view) {
        _forget_eamil_view = [[UIView alloc]init];
        _forget_eamil_view.backgroundColor = RGB(60, 60, 60);
    }
    return _forget_eamil_view;
}

- (UILabel *)forget_detail_lab
{
    if (!_forget_detail_lab) {
        _forget_detail_lab = [[UILabel alloc]init];
        _forget_detail_lab.text = @"If you delete your account, you will permanently lose your profile, voice, messages, photo.";
        _forget_detail_lab.numberOfLines = 0;
        _forget_detail_lab.textColor = RGB(223, 193, 143);
        _forget_detail_lab.font = [UIFont systemFontOfSize:13];
        _forget_detail_lab.textAlignment = NSTextAlignmentCenter;
    }
    return _forget_detail_lab;
}

- (UIButton *)forget_contiute_btn
{
    if (!_forget_contiute_btn) {
        _forget_contiute_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forget_contiute_btn setTitle:@"Submit" forState:UIControlStateNormal];
        _forget_contiute_btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_forget_contiute_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_forget_contiute_btn addTarget:self action:@selector(actonForgetContinuteBtn:) forControlEvents:UIControlEventTouchUpInside];
        _forget_contiute_btn.layer.cornerRadius = 25.0f;
        _forget_contiute_btn.layer.masksToBounds = YES;
        [_forget_contiute_btn gradientButtonWithSize:CGSizeMake(240, 50) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 63)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    }
    return _forget_contiute_btn;
}
-(void)actonForgetContinuteBtn:(UIButton *)btn
{
    NSLog(@"actonForgetContinuteBtn btn");
    [self.view endEditing:YES];
    [SVProgressHUD show];
    dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [SVProgressHUD showInfoWithStatus:@"Delete account successful"];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:NeighborsSimple_LoginStatus];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:NeighborsSimple_EmailName];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:NeighborsSimple_EmailPwd];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:NeighborsSimple_EmailUser];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:NeighborsSimple_EmailGender];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:NeighborsSimple_EmailAge];
                [[NSUserDefaults standardUserDefaults]synchronize];
                NeighborsSimpleCuteRootMainController *rootMainvc = [[NeighborsSimpleCuteRootMainController alloc]init];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:rootMainvc];
                [UIApplication sharedApplication].keyWindow.rootViewController = nav;
        });
    });
}
- (void)viewDidLoad
{
    self.view.backgroundColor = NSC_BGThemColor;
    self.navigationItem.title = @"Delete my password";
    [self NeighborsSimpleCuteSetLeftButton:[UIImage imageNamed:TUIKitResource(@"n_back")]];
    [self.view addSubview:self.forget_email_tf];
    [self.forget_email_tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.top.offset(100);
        make.height.offset(40);
    }];
    [self.view addSubview:self.forget_eamil_view];
    [self.forget_eamil_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.top.mas_equalTo(self.forget_email_tf.mas_bottom).offset(2);
        make.height.offset(2);
    }];
    [self.view addSubview:self.forget_detail_lab];
    [self.forget_detail_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.top.mas_equalTo(self.forget_eamil_view.mas_bottom).offset(30);
        make.height.offset(80);
    }];
    [self.view addSubview:self.forget_contiute_btn];
    [self.forget_contiute_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.forget_detail_lab.mas_bottom).offset(40);
        make.width.offset(240);
        make.height.offset(50);
    }];
    NSString *emailStr = [[NSUserDefaults standardUserDefaults]valueForKey:NeighborsSimple_EmailName];
    self.forget_email_tf.text = emailStr;
}
@end

@interface NeighborsSimpleCuteProfileHeaderViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView *headeImage;

@end

@implementation NeighborsSimpleCuteProfileHeaderViewCell

- (UIImageView *)headeImage
{
    if (!_headeImage) {
        _headeImage = [[UIImageView alloc]init];
        _headeImage.image = [UIImage imageNamed:TUIKitResource(@"test")];
        _headeImage.layer.cornerRadius = 60.0f;
        _headeImage.layer.masksToBounds = YES;
        _headeImage.layer.borderColor = NSC_BGThemColor2.CGColor;
        _headeImage.layer.borderWidth = 3.0f;
        _headeImage.contentMode  =  UIViewContentModeScaleAspectFill;
    }
    return _headeImage;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    [self.contentView addSubview:self.headeImage];
    [self.headeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.contentView);
        make.width.height.offset(120);
    }];
}

@end

@interface NeighborsSimpleCuteProfileContentViewCell : UITableViewCell

@property (nonatomic,strong)UIView *bg_View;

@property (nonatomic,strong)UIView *userNameView;

@property (nonatomic,strong)UILabel *userNameLab;

@property (nonatomic,strong)UILabel *userNameConLab;

@property (nonatomic,strong)UIView *userLineView;

@property (nonatomic,strong)UIImageView *userNameJt;

@property (nonatomic,strong)UIView *genderView;

@property (nonatomic,strong)UILabel *genderLab;

@property (nonatomic,strong)UILabel *genderConLab;

@property (nonatomic,strong)UIView *genderLineView;

@property (nonatomic,strong)UIImageView *genderJt;

@property (nonatomic,strong)UIView *ageView;

@property (nonatomic,strong)UILabel *ageLab;

@property (nonatomic,strong)UILabel *ageConLab;

@property (nonatomic,strong)UIView *ageLineView;

@property (nonatomic,strong)UIImageView *ageJt;

@property (nonatomic,copy)void(^NeighborsSimpleCuteProfileContentViewCellBlock)(int tag);

@end

@implementation NeighborsSimpleCuteProfileContentViewCell

- (UIView *)bg_View
{
    if (!_bg_View) {
        _bg_View = [[UIView alloc]init];
        _bg_View.backgroundColor = RGB(40, 40, 40);
        _bg_View.layer.cornerRadius = 8.0f;
        _bg_View.layer.masksToBounds = YES;
    }
    return _bg_View;
}
- (UIView *)userNameView
{
    if (!_userNameView) {
        _userNameView = [[UIView alloc]init];
        _userNameView.backgroundColor = [UIColor clearColor];
        _userNameView.userInteractionEnabled = YES;
        _userNameView.tag = 1001;
        UITapGestureRecognizer *tapClickGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actinonClickChange:)];
        [_userNameView addGestureRecognizer:tapClickGesture];
    }
    return _userNameView;
}
-(void)actinonClickChange:(UITapGestureRecognizer *)gesture{
    int tag = (int) gesture.view.tag - 1000;
    if (self.NeighborsSimpleCuteProfileContentViewCellBlock) {
        self.NeighborsSimpleCuteProfileContentViewCellBlock(tag);
    }
}
- (UILabel *)userNameLab
{
    if (!_userNameLab) {
        _userNameLab = [[UILabel alloc]init];
        _userNameLab.text = @"Username";
        _userNameLab.textColor =  RGB(235, 142, 63);
        _userNameLab.font  = [UIFont systemFontOfSize:16];
        _userNameLab.textAlignment = NSTextAlignmentLeft;
    }
    return _userNameLab;
}

- (UILabel *)userNameConLab
{
    if (!_userNameConLab) {
        _userNameConLab = [[UILabel alloc]init];
        _userNameConLab.text = @"Username";
        _userNameConLab.textColor =  [UIColor whiteColor];
        _userNameConLab.font  = [UIFont systemFontOfSize:16];
        _userNameConLab.textAlignment = NSTextAlignmentRight;
    }
    return _userNameConLab;
}
- (UIView *)userLineView
{
    if (!_userLineView) {
        _userLineView = [[UIView alloc]init];
        _userLineView.backgroundColor = RGB(30, 30, 30);
    }
    return _userLineView;
}

- (UIImageView *)userNameJt
{
    if (!_userNameJt) {
        _userNameJt = [[UIImageView alloc]init];
        _userNameJt.image = [UIImage imageNamed:TUIKitResource(@"a_setting_jt")];
    }
    return _userNameJt;
}

- (UIView *)genderView
{
    if (!_genderView) {
        _genderView = [[UIView alloc]init];
        _genderView.backgroundColor = [UIColor clearColor];
        _genderView.userInteractionEnabled = YES;
        _genderView.tag = 1002;
        UITapGestureRecognizer *tapClickGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actinonClickChange:)];
        [_genderView addGestureRecognizer:tapClickGesture];
    }
    return _genderView;
}

- (UILabel *)genderLab
{
    if (!_genderLab) {
        _genderLab = [[UILabel alloc]init];
        _genderLab.text = @"Gender";
        _genderLab.textColor =  RGB(235, 142, 63);
        _genderLab.font  = [UIFont systemFontOfSize:16];
        _genderLab.textAlignment = NSTextAlignmentLeft;
    }
    return _genderLab;
}

- (UILabel *)genderConLab
{
    if (!_genderConLab) {
        _genderConLab = [[UILabel alloc]init];
        _genderConLab.text = @"Gender";
        _genderConLab.textColor =  [UIColor whiteColor];
        _genderConLab.font  = [UIFont systemFontOfSize:16];
        _genderConLab.textAlignment = NSTextAlignmentRight;
    }
    return _genderConLab;
}

- (UIImageView *)genderJt
{
    if (!_genderJt) {
        _genderJt = [[UIImageView alloc]init];
        _genderJt.image = [UIImage imageNamed:TUIKitResource(@"a_setting_jt")];
    }
    return _genderJt;
}

- (UIView *)genderLineView
{
    if (!_genderLineView) {
        _genderLineView = [[UIView alloc]init];
        _genderLineView.backgroundColor = RGB(30, 30, 30);
    }
    return _genderLineView;
}

- (UIView *)ageView
{
    if (!_ageView) {
        _ageView = [[UIView alloc]init];
        _ageView.backgroundColor = [UIColor clearColor];
        _ageView.userInteractionEnabled = YES;
        _ageView.tag = 1003;
        UITapGestureRecognizer *tapClickGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actinonClickChange:)];
        [_ageView addGestureRecognizer:tapClickGesture];
        
    }
    return _ageView;
}

- (UILabel *)ageLab
{
    if (!_ageLab) {
        _ageLab = [[UILabel alloc]init];
        _ageLab.text = @"Age";
        _ageLab.textColor =  RGB(235, 142, 63);
        _ageLab.font  = [UIFont systemFontOfSize:16];
        _ageLab.textAlignment = NSTextAlignmentLeft;
    }
    return _ageLab;
}

- (UILabel *)ageConLab
{
    if (!_ageConLab) {
        _ageConLab = [[UILabel alloc]init];
        _ageConLab.text = @"Age";
        _ageConLab.textColor =  [UIColor whiteColor];
        _ageConLab.font  = [UIFont systemFontOfSize:16];
        _ageConLab.textAlignment = NSTextAlignmentRight;
    }
    return _ageConLab;
}

- (UIImageView *)ageJt
{
    if (!_ageJt) {
        _ageJt = [[UIImageView alloc]init];
        _ageJt.image = [UIImage imageNamed:TUIKitResource(@"a_setting_jt")];
    }
    return _ageJt;
}

- (UIView *)ageLineView
{
    if (!_ageLineView) {
        _ageLineView = [[UIView alloc]init];
        _ageLineView.backgroundColor = RGB(30, 30, 30);
    }
    return _ageLineView;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    [self.contentView addSubview:self.bg_View];
    [self.bg_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.top.offset(10);
        make.bottom.offset(-10);
    }];
    CGFloat height = 240 / 3;
    [self.bg_View addSubview:self.userNameView];
    [self.userNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(height);
        make.width.offset(80);
    }];
    [self.userNameView addSubview:self.userNameLab];
    [self.userNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.userNameView);
        make.left.offset(15);
    }];
    [self.userNameView addSubview:self.userNameJt];
    [self.userNameJt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.userNameView);
        make.right.offset(-15);
        make.width.offset(7);
        make.height.offset(13);
    }];
    [self.userNameView addSubview:self.userNameConLab];
    [self.userNameConLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.userNameView);
        make.left.mas_equalTo(self.userNameLab.mas_right).offset(10);
        make.right.mas_equalTo(self.userNameJt.mas_left).offset(-10);
    }];
    [self.userNameView addSubview:self.userLineView];
    [self.userLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.left.offset(10);
        make.right.offset(-10);
        make.height.offset(1);
    }];
    [self.bg_View addSubview:self.genderView];
    [self.genderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.mas_equalTo(self.userNameView.mas_bottom).offset(0);
        make.height.offset(height);
    }];
    
    [self.genderView addSubview:self.genderLab];
    [self.genderLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.genderView);
        make.left.offset(15);
    }];
    [self.genderView addSubview:self.genderJt];
    [self.genderJt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.genderView);
        make.right.offset(-15);
        make.width.offset(7);
        make.height.offset(13);
    }];
    [self.genderView addSubview:self.genderConLab];
    [self.genderConLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.genderView);
        make.left.mas_equalTo(self.genderLab.mas_right).offset(10);
        make.right.mas_equalTo(self.genderJt.mas_left).offset(-10);
    }];
    [self.genderView addSubview:self.genderLineView];
    [self.genderLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.left.offset(10);
        make.right.offset(-10);
        make.height.offset(1);
    }];
    
    [self.bg_View addSubview:self.ageView];
    [self.ageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.offset(height);
    }];
    
    [self.ageView addSubview:self.ageLab];
    [self.ageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.ageView);
        make.left.offset(15);
    }];
    [self.ageView addSubview:self.ageJt];
    [self.ageJt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.ageView);
        make.right.offset(-15);
        make.width.offset(7);
        make.height.offset(13);
    }];
    [self.ageView addSubview:self.ageConLab];
    [self.ageConLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.ageView);
        make.left.mas_equalTo(self.ageLab.mas_right).offset(10);
        make.right.mas_equalTo(self.ageJt.mas_left).offset(-10);
    }];
//    [self.ageView addSubview:self.ageLineView];
//    [self.ageLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.offset(0);
//        make.left.offset(10);
//        make.right.offset(-10);
//        make.height.offset(1);
//    }];
}
@end

#define kRecordAudioFile @"myRecord2.caf"
@interface NeighborsSimpleCuteProfileVoiceViewCell : UITableViewCell <AVAudioRecorderDelegate>

@property (nonatomic,strong)UIView *bgView;

@property (nonatomic,strong)UIButton *voiceBtn;

@property (nonatomic,strong)UIButton *voiceBtn2;

@property (nonatomic,strong)UILabel *topLab;

@property (nonatomic,strong)UIButton *uploadBtn;

@property (nonatomic,strong)UILabel *timeLab;

@property (nonatomic,strong)UIButton *closeBtn;

@property (nonatomic,strong) AVAudioRecorder *audioRecorder;//音频录音机
@property (nonatomic,strong) NSTimer *timer;//录音声波监控（注意这里暂时不对播放进行监控）
@property (nonatomic,assign)NSInteger cutDown;
@property (nonatomic,assign)BOOL isRecorder;

@end


@implementation NeighborsSimpleCuteProfileVoiceViewCell

-(NSTimer *)timer{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateProgress) userInfo:nil repeats:true];
    }
    return _timer;
}
-(void)updateProgress
{
    self.cutDown++;
    self.timeLab.hidden = NO;
    self.timeLab.text = [NSString stringWithFormat:@"%ldS",(long)self.cutDown];
}
-(AVAudioRecorder *)audioRecorder{
    if (!_audioRecorder) {
        //创建录音文件保存路径
        NSURL *url=[self getSavePath];
        //创建录音格式设置
        NSDictionary *setting=[self getAudioSetting];
        //创建录音机
        NSError *error=nil;
        _audioRecorder=[[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate=self;
        _audioRecorder.meteringEnabled=YES;//如果要监控声波则必须设置为YES
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioRecorder;
}
/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */
-(NSDictionary *)getAudioSetting{
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    //设置录音格式
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道,这里采用单声道
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //....其他设置等
    return dicM;
}
/**
 *  取得录音文件保存路径
 *
 *  @return 录音文件路径
 */
-(NSURL *)getSavePath{
    NSString *urlStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr=[urlStr stringByAppendingPathComponent:kRecordAudioFile];
    NSLog(@"file path:%@",urlStr);
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    return url;
}

- (UILabel *)topLab
{
    if (!_topLab) {
        _topLab = [[UILabel alloc]init];
        _topLab.text = @"Headline by Voice";
        _topLab.textColor = [UIColor whiteColor];
        _topLab.font = [UIFont systemFontOfSize:18];
        _topLab.textAlignment = NSTextAlignmentCenter;
    }
    return _topLab;
}
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = RGB(30, 30, 30);
        _bgView.layer.cornerRadius = 8.0f;
        _bgView.layer.masksToBounds = YES;
        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
}

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc]init];
        [_closeBtn setImage:[UIImage imageNamed:TUIKitResource(@"n_vocie_del")] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(actionCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.hidden = YES;
    }
    return _closeBtn;
}

-(void)actionCloseBtn:(UIButton *)btn
{
    NSLog(@"actionCloseBtnactionCloseBtnactionCloseBtn");
    self.cutDown = 0;
    self.timeLab.hidden = YES;
    self.closeBtn.hidden = YES;
    self.timer.fireDate=[NSDate distantFuture];
    [self.voiceBtn setImage:[UIImage imageNamed:TUIKitResource(@"n_send_voice")] forState:UIControlStateNormal];
    [self.audioRecorder pause];
}

- (UILabel *)timeLab
{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc]init];
        _timeLab.text = @"1s";
        _timeLab.textColor = [UIColor whiteColor];
        _timeLab.textAlignment = NSTextAlignmentCenter;
        _timeLab.font = [UIFont systemFontOfSize:16];
        _timeLab.hidden = YES;
    }
    return _timeLab;
}
- (UIButton *)voiceBtn2
{
    if (!_voiceBtn2) {
        _voiceBtn2 = [[UIButton alloc]init];
        _voiceBtn2.backgroundColor = [UIColor redColor];
        [_voiceBtn addTarget:self action:@selector(actioPuush) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceBtn2;
}

-(void)actioPuush
{
    NSLog(@"actioPuushactioPuushactioPuushactioPuush");
}

- (UIButton *)voiceBtn
{
    if (!_voiceBtn) {
        _voiceBtn = [[UIButton alloc]init];
        [_voiceBtn setImage:[UIImage imageNamed:TUIKitResource(@"n_send_voice")] forState:UIControlStateNormal];
        _voiceBtn.layer.cornerRadius = 127/2;
        _voiceBtn.layer.masksToBounds = YES;
        [_voiceBtn addTarget:self action:@selector(actionSendVoice111:) forControlEvents:UIControlEventTouchUpInside];
        [_voiceBtn gradientButtonWithSize:CGSizeMake(60, 60) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 63)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    }
    return _voiceBtn;
}
-(void)actionSendVoice111:(UIButton *)sender{
    NSLog(@"111111");
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.voiceBtn setImage:[UIImage imageNamed:TUIKitResource(@"n_voice_stop")] forState:UIControlStateNormal];
        [self.audioRecorder record];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
        self.timer.fireDate=[NSDate distantPast];
        self.closeBtn.hidden = YES;
    }else{
        [self.voiceBtn setImage:[UIImage imageNamed:TUIKitResource(@"n_voice_play")] forState:UIControlStateNormal];
        [self.audioRecorder pause];
        self.timer.fireDate=[NSDate distantFuture];
        self.closeBtn.hidden = NO;
        self.isRecorder = YES;
    }
}

- (UIButton *)uploadBtn
{
    if (!_uploadBtn) {
        _uploadBtn = [[UIButton alloc]init];
        [_uploadBtn setTitle:@"Upload" forState:UIControlStateNormal];
        [_uploadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _uploadBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_uploadBtn addTarget:self action:@selector(actionUploadBtn:) forControlEvents:UIControlEventTouchUpInside];
        _uploadBtn.layer.cornerRadius = 25.0f;
        _uploadBtn.layer.masksToBounds = YES;
        [_uploadBtn gradientButtonWithSize:CGSizeMake(240, 50) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 63)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    }
    return _uploadBtn;
}
-(void)actionUploadBtn:(UIButton *)btn
{
    NSLog(@"actionUploadBtnactionUploadBtn");
    if (self.cutDown <= 0) {
         [SVProgressHUD showInfoWithStatus:@"Please record audio first"];
         return;
     }
     if (!self.isRecorder) {
         [SVProgressHUD showInfoWithStatus:@"Save the recording before you can send it"];
     }
     [SVProgressHUD show];
     dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
             dispatch_async(dispatch_get_main_queue(), ^{
                 [SVProgressHUD dismiss];
                 [SVProgressHUD showInfoWithStatus:@"Send successfully"];
                 self.cutDown = 0;
                 self.timeLab.hidden = YES;
                 self.closeBtn.hidden = YES;
                 self.timer.fireDate=[NSDate distantFuture];
                 [self.voiceBtn setImage:[UIImage imageNamed:TUIKitResource(@"n_send_voice")] forState:UIControlStateNormal];
                 [self.audioRecorder pause];
         });
     });
    
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.top.offset(10);
        make.bottom.offset(-10);
    }];
    [self.bgView addSubview:self.voiceBtn];
    [self.voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.bgView);
        make.width.height.offset(127);
    }];
    [self.bgView addSubview:self.topLab];
    [self.topLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView);
        make.bottom.mas_equalTo(self.voiceBtn.mas_top).offset(-30);
    }];
    [self.bgView addSubview:self.uploadBtn];
    [self.uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView);
        make.bottom.offset(-20);
    }];
    [self.bgView addSubview:self.timeLab];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView);
        make.bottom.mas_equalTo(self.voiceBtn.mas_bottom).offset(-10);
    }];
    [self.bgView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.voiceBtn.mas_top).offset(0);
        make.left.mas_equalTo(self.voiceBtn.mas_right).offset(-20);
        make.width.height.offset(30);
    }];
}
@end

@interface NeighborsSimpleCuteSettingProfileController ()
<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *profileTableView;
@property (nonatomic,strong)NeighborsSimpleCuteProfileContentViewCell *contentCell;
@property (nonatomic,strong)NeighborsSimpleCuteProfileHeaderViewCell *headerCell;
@property (nonatomic,strong)UITextField *userNametf;
@property (nonatomic,strong)NSMutableArray *genderListArr;
@property (nonatomic,strong)NSMutableArray *ageListArr;
@end

@implementation NeighborsSimpleCuteSettingProfileController

- (NSMutableArray *)genderListArr
{
    if (!_genderListArr) {
        _genderListArr = [NSMutableArray arrayWithObjects:@"Female",@"Male", nil];
    }
    return _genderListArr;
}

- (NSMutableArray *)ageListArr
{
    if (!_ageListArr) {
        _ageListArr = [NSMutableArray array];
        for (int i = 18;i< 100;i++) {
            NSString *ageStr = [NSString stringWithFormat:@"%d",i];
            NSLog(@"ageStr:%@",ageStr);
            [_ageListArr addObject:ageStr];
        }
    }
    return _ageListArr;
}

- (UITableView *)profileTableView
{   if (!_profileTableView) {
        _profileTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _profileTableView.backgroundColor = [UIColor clearColor];
        _profileTableView.showsVerticalScrollIndicator = NO;
        _profileTableView.showsHorizontalScrollIndicator = NO;
        _profileTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _profileTableView.delegate = self;
        _profileTableView.dataSource = self;
        [_profileTableView registerClass:[NeighborsSimpleCuteProfileHeaderViewCell class] forCellReuseIdentifier:@"NeighborsSimpleCuteProfileHeaderViewCell"];
        [_profileTableView registerClass:[NeighborsSimpleCuteProfileContentViewCell class] forCellReuseIdentifier:@"NeighborsSimpleCuteProfileContentViewCell"];
        [_profileTableView registerClass:[NeighborsSimpleCuteProfileVoiceViewCell class] forCellReuseIdentifier:@"NeighborsSimpleCuteProfileVoiceViewCell"];
    }
    return _profileTableView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = NSC_MainThemColor;
    [self NeighborsSimpleCuteSetLeftButton:[UIImage imageNamed:@""]];
    [self NeighborsSimpleCuteSetRightButton:[UIImage imageNamed:TUIKitResource(@"n_setting_back")]];
    [self.view addSubview:self.profileTableView];
    [self.profileTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
}

- (void)onNeighborsSimpleCuteRightBackBtn:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 200;
    }else if(indexPath.section == 1){
        return 340;
    }else{
        return 260;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        self.headerCell = [tableView dequeueReusableCellWithIdentifier:@"NeighborsSimpleCuteProfileHeaderViewCell" forIndexPath:indexPath];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:
                              [NSString stringWithFormat:@"n_add_sened_img.png"]];
        // 保存文件的名称
        UIImage *img = [UIImage imageWithContentsOfFile:filePath];
        NSLog(@"img:%@",img);
        if (img) {
            self.headerCell.headeImage.image = img;
        }else{
        self.headerCell.headeImage.image = [UIImage imageNamed:TUIKitResource(@"n_default_bg.png")];
        }
        self.headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.headerCell;
    }else if(indexPath.section == 1){
        
        NeighborsSimpleCuteProfileVoiceViewCell *voiceCell = [tableView dequeueReusableCellWithIdentifier:@"NeighborsSimpleCuteProfileVoiceViewCell" forIndexPath:indexPath];
        voiceCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return voiceCell;
    }else{
        self.contentCell = [tableView dequeueReusableCellWithIdentifier:@"NeighborsSimpleCuteProfileContentViewCell" forIndexPath:indexPath];
        NSString *nameStr = [NeighborsSimpleCuteUserModel getUserInfo].userInfo.nickName;
        // [[NSUserDefaults standardUserDefaults]valueForKey:NeighborsSimple_EmailUser];
        NSString *genderStr = [[NSUserDefaults standardUserDefaults]valueForKey:NeighborsSimple_EmailGender];
        NSString *ageStr = [[NSUserDefaults standardUserDefaults]valueForKey:NeighborsSimple_EmailAge];
        self.contentCell.userNameConLab.text = nameStr;
        self.contentCell.genderConLab.text = genderStr;
        self.contentCell.ageConLab.text    = ageStr;
        [self.contentCell setNeighborsSimpleCuteProfileContentViewCellBlock:^(int tag) {
            NSLog(@"tag:%d",tag);
            if (tag == 1) {
                [self actionUpdateName];
            }else if(tag == 2){
                [self actionSelectGender];
            }else if(tag == 3){
                [self actionSelectAge];
            }
        }];
        self.contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.contentCell;
    }
}
/// updatename
-(void)actionUpdateName
{

    NeighborsSimpleCuteChnageNameView *nameView = [[NeighborsSimpleCuteChnageNameView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT)];
    [nameView setNeighborsSimpleCuteChnageNameViewBlcok:^(NSString * _Nonnull nameStr) {
        [SVProgressHUD show];
                 dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [SVProgressHUD dismiss];
                             self.contentCell.userNameConLab.text = nameStr;
                             NeighborsSimpleCuteUserModel *model = [NeighborsSimpleCuteUserModel getUserInfo];
                             model.userInfo.nickName = nameStr;
                             [NeighborsSimpleCuteUserModel save:model];
                             //[[NSUserDefaults standardUserDefaults]setValue:nameStr forKey:NeighborsSimple_EmailUser];
                             //[[NSUserDefaults standardUserDefaults]synchronize];
                     });
            });
    }];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    NSCParameterAssert(window);
    [window addSubview:nameView];
//    NSString *nameStr = [[NSUserDefaults standardUserDefaults]valueForKey:NeighborsSimple_EmailUser];
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Tip" message:@"please enter user name" preferredStyle:UIAlertControllerStyleAlert];
//    //增加取消按钮；
//    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
//     //增加确定按钮；
//     [alertController addAction:[UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//       UITextField *userNameTextField = alertController.textFields.firstObject;
//         if (IS_EMPTY(userNameTextField.text)) {
//             [SVProgressHUD showInfoWithStatus:@"please enter user name"];
//             return;
//         }
//         [SVProgressHUD show];
//         dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
//                 dispatch_async(dispatch_get_main_queue(), ^{
//                     [SVProgressHUD dismiss];
//                     self.contentCell.userNameConLab.text = userNameTextField.text;
//                     [[NSUserDefaults standardUserDefaults]setValue:userNameTextField.text forKey:NeighborsSimple_EmailUser];
//                     [[NSUserDefaults standardUserDefaults]synchronize];
//             });
//         });
//     }]];
//     //定义第一个输入框；
//     [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.placeholder = @"please enter user name";
//        textField.text = nameStr;
//     }];
//     [self presentViewController:alertController animated:true completion:nil];
}

/// select gender
-(void)actionSelectGender
{
    [BRStringPickerView showStringPickerWithTitle:@"Gender" dataSource:self.genderListArr defaultSelValue:@"Female" isAutoSelect:NO resultBlock:^(id selectValue) {
        [SVProgressHUD show];
        dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    NSString *genderStr = (NSString *)selectValue;
                    self.contentCell.genderConLab.text = genderStr;
                    [[NSUserDefaults standardUserDefaults]setValue:genderStr forKey:NeighborsSimple_EmailGender];
                    [[NSUserDefaults standardUserDefaults]synchronize];
            });
        });
      }];
}
/// select age
-(void)actionSelectAge
{
    [BRStringPickerView showStringPickerWithTitle:@"Age" dataSource:self.ageListArr defaultSelValue:@"18" isAutoSelect:NO resultBlock:^(id selectValue) {
        [SVProgressHUD show];
        dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    NSString *ageStr = (NSString *)selectValue;
                    self.contentCell.ageConLab.text = ageStr;
                    [[NSUserDefaults standardUserDefaults]setValue:ageStr forKey:NeighborsSimple_EmailAge];
                    [[NSUserDefaults standardUserDefaults]synchronize];
            });
        });
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [self.view endEditing:YES];
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
        [imagePickerVc setAllowPreview:NO];
        [imagePickerVc setNaviBgColor:[UIColor blackColor]];
        [imagePickerVc setAllowPickingVideo:NO];
        [imagePickerVc setIsSelectOriginalPhoto:NO];
        imagePickerVc.allowTakePicture = YES;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            self.headerCell.headeImage.image = photos[0];
            self.headerCell.headeImage.layer.borderColor = NSC_BGThemColor2.CGColor;
            self.headerCell.headeImage.layer.borderWidth = 3.0f;
            [self saveImage:photos[0]];
        }];
        imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}
- (void)saveImage:(UIImage *)image {
   NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
   NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:
                         [NSString stringWithFormat:@"n_add_sened_img.png"]];  // 保存文件的名称
   BOOL result =[UIImagePNGRepresentation(image)writeToFile:filePath   atomically:YES]; // 保存成功会返回YES
   if (result == YES) {
       NSLog(@"Save Success");
   }
}
@end

@interface NeighborsSimpleCuteSettingFeedBackController ()

@property (nonatomic,strong)UILabel *contentLab;

@property (nonatomic,strong)IQTextView *inputContentView;

@property (nonatomic,strong)UILabel *screntshotsLab;

@property (nonatomic,strong)UIView *screntshotsView;

@property (nonatomic,strong)UIView *firstView;

@property (nonatomic,strong)UIButton *firstBtn;

@property (nonatomic,strong)UIImageView *firstImg;

@property (nonatomic,strong)UIView *secondView;

@property (nonatomic,strong)UIButton *secondBtn;

@property (nonatomic,strong)UIImageView *secondImg;

@property (nonatomic,strong)UIView *thirdView;

@property (nonatomic,strong)UIButton *thirdBtn;

@property (nonatomic,strong)UIImageView *thirdImg;

@property (nonatomic,strong)UIButton *submitBtn;

@property (nonatomic,assign)BOOL isFirst;

@property (nonatomic,assign)BOOL isSecond;

@property (nonatomic,assign)BOOL isThird;

@end

@implementation NeighborsSimpleCuteSettingFeedBackController

- (UILabel *)contentLab
{
    if (!_contentLab) {
        _contentLab  = [[UILabel alloc]init];
        _contentLab.textColor = RGB(237, 151, 64);
        _contentLab.text = @"Content";
        _contentLab.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLab;
}
- (IQTextView *)inputContentView
{
    if (!_inputContentView) {
        _inputContentView = [[IQTextView alloc]init];
        _inputContentView.backgroundColor = RGB(60, 60, 60);
        _inputContentView.placeholder = @"Describe your problem...";
        _inputContentView.placeholderTextColor = RGB(153, 153, 153);
        _inputContentView.textColor = [UIColor whiteColor];
        _inputContentView.font = [UIFont systemFontOfSize:15];
        _inputContentView.textAlignment = NSTextAlignmentLeft;
        _inputContentView.layer.cornerRadius  = 10.0f;
        _inputContentView.layer.masksToBounds = YES;
    }
    return _inputContentView;
}
- (UILabel *)screntshotsLab
{
    if (!_screntshotsLab) {
        _screntshotsLab  = [[UILabel alloc]init];
        _screntshotsLab.textColor = RGB(237, 151, 64);
        _screntshotsLab.text = @"Screenshots";
        _screntshotsLab.textAlignment = NSTextAlignmentCenter;
    }
    return _screntshotsLab;
}
- (UIView *)screntshotsView
{
    if (!_screntshotsView) {
        _screntshotsView = [[UIView alloc]init];
        _screntshotsView.backgroundColor = RGB(60, 60, 60);
        _screntshotsView.layer.cornerRadius = 10.0f;
        _screntshotsView.layer.masksToBounds = YES;
    }
    return _screntshotsView;
}

- (UIView *)firstView
{
    if (!_firstView) {
        _firstView = [[UIView alloc]init];
        _firstView.backgroundColor = [UIColor clearColor];
        _firstView.layer.cornerRadius = 5.0f;
        _firstView.layer.masksToBounds = YES;
    }
    return _firstView;
}

- (UIButton *)firstBtn
{
    if (!_firstBtn) {
        _firstBtn = [[UIButton alloc]init];
        _firstBtn.tag = 1001;
        [_firstBtn setTitle:@"+" forState:UIControlStateNormal];
        [_firstBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _firstBtn.titleLabel.font = [UIFont systemFontOfSize:30];
        [_firstBtn addTarget:self action:@selector(actionFirstUplodaimage:) forControlEvents:UIControlEventTouchUpInside];
        [_firstBtn gradientButtonWithSize:CGSizeMake((IPHONE_WIDTH - 80)/3,120) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 63)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    }
    return _firstBtn;
}
- (UIImageView *)firstImg
{
    if (!_firstImg) {
        _firstImg = [[UIImageView alloc]init];
        _firstImg.contentMode =  UIViewContentModeScaleAspectFill;
        _firstImg.layer.cornerRadius = 5.0f;
        _firstImg.layer.masksToBounds = YES;
    }
    return _firstImg;
}

- (UIView *)secondView
{
    if (!_secondView) {
        _secondView = [[UIView alloc]init];
        _secondView.backgroundColor = [UIColor clearColor];
        _secondView.layer.cornerRadius = 5.0f;
        _secondView.layer.masksToBounds = YES;
    }
    return _secondView;
}

- (UIButton *)secondBtn
{
    if (!_secondBtn) {
        _secondBtn = [[UIButton alloc]init];
        _secondBtn.tag = 1002;
        [_secondBtn setTitle:@"+" forState:UIControlStateNormal];
        [_secondBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _secondBtn.titleLabel.font = [UIFont systemFontOfSize:30];
        [_secondBtn addTarget:self action:@selector(actionFirstUplodaimage:) forControlEvents:UIControlEventTouchUpInside];
        [_secondBtn gradientButtonWithSize:CGSizeMake((IPHONE_WIDTH - 80)/3,120) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 63)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    }
    return _secondBtn;
}

- (UIImageView *)secondImg
{
    if (!_secondImg) {
        _secondImg = [[UIImageView alloc]init];
        _secondImg.contentMode =  UIViewContentModeScaleAspectFill;
        _secondImg.layer.cornerRadius = 5.0f;
        _secondImg.layer.masksToBounds = YES;
    }
    return _secondImg;
}
- (UIView *)thirdView
{
    if (!_thirdView) {
        _thirdView = [[UIView alloc]init];
        _thirdView.backgroundColor = [UIColor clearColor];
        _thirdView.layer.cornerRadius = 5.0f;
        _thirdView.layer.masksToBounds = YES;
    }
    return _thirdView;
}

- (UIButton *)thirdBtn
{
    if (!_thirdBtn) {
        _thirdBtn = [[UIButton alloc]init];
        _thirdBtn.tag = 1003;
        [_thirdBtn setTitle:@"+" forState:UIControlStateNormal];
        [_thirdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _thirdBtn.titleLabel.font = [UIFont systemFontOfSize:30];
        [_thirdBtn addTarget:self action:@selector(actionFirstUplodaimage:) forControlEvents:UIControlEventTouchUpInside];
        [_thirdBtn gradientButtonWithSize:CGSizeMake((IPHONE_WIDTH - 80)/3,120) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 63)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    }
    return _thirdBtn;
}

- (UIImageView *)thirdImg
{
    if (!_thirdImg) {
        _thirdImg = [[UIImageView alloc]init];
        _thirdImg.contentMode =  UIViewContentModeScaleAspectFill;
        _thirdImg.layer.cornerRadius = 5.0f;
        _thirdImg.layer.masksToBounds = YES;
    }
    return _thirdImg;
}

- (UIButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn setTitle:@"Submit" forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(actionSubmitBtn:) forControlEvents:UIControlEventTouchUpInside];
        _submitBtn.layer.cornerRadius = 25.0f;
        _submitBtn.layer.masksToBounds = YES;
        [_submitBtn gradientButtonWithSize:CGSizeMake(240, 50) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 63)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    }
    return _submitBtn;
}

-(void)actionSubmitBtn:(UIButton *)btn
{
    if (IS_EMPTY(self.inputContentView.text)) {
        [SVProgressHUD showInfoWithStatus:@"Describe your problem..."];
        return;
    }
    if (self.isFirst == NO && self.isSecond == NO && self.isThird == NO) {
        [SVProgressHUD showInfoWithStatus:@"Please upload a picture"];
        return;
    }
    [SVProgressHUD show];
    dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [SVProgressHUD showInfoWithStatus:@"Submit successful"];
                [self.navigationController popViewControllerAnimated:YES];
        });
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"FeedBack";
    [self NeighborsSimpleCuteSetLeftButton:[UIImage imageNamed:TUIKitResource(@"n_back")]];
    [self.view addSubview:self.contentLab];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.offset(30);
    }];
    [self.view addSubview:self.inputContentView];
    [self.inputContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.top.mas_equalTo(self.contentLab.mas_bottom).offset(20);
        make.height.offset(200);
    }];
    [self.view addSubview:self.screntshotsLab];
    [self.screntshotsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.inputContentView.mas_bottom).offset(15);
    }];
    [self.view addSubview:self.screntshotsView];
    [self.screntshotsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.top.mas_equalTo(self.screntshotsLab.mas_bottom).offset(20);
        make.height.offset(120);
    }];
    CGFloat scrent_width = (IPHONE_WIDTH - 80)/3;
    [self.screntshotsView addSubview:self.firstView];
    [self.firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.centerY.mas_equalTo(self.screntshotsView);
        make.height.offset(100);
        make.width.offset(scrent_width);
    }];
    
    [self.firstView addSubview:self.firstBtn];
    [self.firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    [self.firstView addSubview:self.firstImg];
    [self.firstImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    
    [self.screntshotsView addSubview:self.secondView];
    [self.secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.firstView.mas_right).offset(10);
        make.centerY.mas_equalTo(self.screntshotsView);
        make.height.offset(100);
        make.width.offset(scrent_width);
    }];
    
    [self.secondView addSubview:self.secondBtn];
    [self.secondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    [self.secondView addSubview:self.secondImg];
    [self.secondImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    
    [self.screntshotsView addSubview:self.thirdView];
    [self.thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.centerY.mas_equalTo(self.screntshotsView);
        make.height.offset(100);
        make.width.offset(scrent_width);
    }];
    
    [self.thirdView addSubview:self.thirdBtn];
    [self.thirdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    [self.thirdView addSubview:self.thirdImg];
    [self.thirdImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    [self.view addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.offset(-20);
        make.width.offset(240);
        make.height.offset(50);
    }];
    
}

-(void)onNeighborsSimpleCuteLeftBackBtn:(UIButton *)btn
{
    if (self.NeighborsSimpleCuteSettingFeedBackControllerBackBlock) {
        self.NeighborsSimpleCuteSettingFeedBackControllerBackBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)actionSubmitBtn
{
    NSLog(@"actionSubmitBtnactionSubmitBtn");
   
}
-(void)actionFirstUplodaimage:(UIButton *)btn
{
    int tag = (int)btn.tag;
    NSLog(@"tag:%d",tag);
    [self.view endEditing:YES];
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    [imagePickerVc setAllowPreview:NO];
    [imagePickerVc setNaviBgColor:[UIColor blackColor]];
    [imagePickerVc setAllowPickingVideo:NO];
    [imagePickerVc setIsSelectOriginalPhoto:NO];
    imagePickerVc.allowTakePicture = YES;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (tag == 1001) {
            self.firstImg.image = photos[0];
            [self.firstBtn setTitle:@"" forState:UIControlStateNormal];
            self.isFirst = YES;
        }else if(tag == 1002){
            self.secondImg.image = photos[0];
            [self.secondBtn setTitle:@"" forState:UIControlStateNormal];
            self.isSecond = YES;
        }else if(tag == 1003){
            self.thirdImg.image = photos[0];
            [self.thirdBtn setTitle:@"" forState:UIControlStateNormal];
            self.isThird = YES;
        }
    }];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
@end

@interface NeighborsSimpleCuteSettingAboutusController ()

@property (nonatomic,strong)UIView *serviceView;

@property (nonatomic,strong)UIView *privacyView;

@property (nonatomic,strong)UILabel *versionLab;

@end

@implementation NeighborsSimpleCuteSettingAboutusController

- (UIView *)serviceView
{
    if (!_serviceView) {
        _serviceView = [[UIView alloc]init];
        _serviceView.backgroundColor = RGB(60, 60, 60);
        _serviceView.layer.cornerRadius = 8.0f;
        _serviceView.layer.masksToBounds = YES;
        _serviceView.userInteractionEnabled = YES;
        UITapGestureRecognizer *serviceTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionPushService)];
        [_serviceView addGestureRecognizer:serviceTap];
        
    }
    return _serviceView;
}

-(void)actionPushService
{
    NSLog(@"actionPushServiceactionPushServiceactionPushService");
    NeighborsSimpleCuteBaseWebController *agrementvc = [[NeighborsSimpleCuteBaseWebController  alloc]init];
    agrementvc.isShowHidden = YES;
    agrementvc.URLString = @"http://www.hooil.cn/terms.html";
    agrementvc.loadType = WKWebLoadTypeWebURLString;
    agrementvc.webTitle = @"Service Agreement";
    [self.navigationController pushViewController:agrementvc animated:YES];
}
- (UIView *)privacyView
{
    if (!_privacyView) {
        _privacyView = [[UIView alloc]init];
        _privacyView.backgroundColor = RGB(60, 60, 60);
        _privacyView.layer.cornerRadius = 8.0f;
        _privacyView.layer.masksToBounds = YES;
        _privacyView.userInteractionEnabled = YES;
        UITapGestureRecognizer *privacyTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionPushPrivacy)];
        [_privacyView addGestureRecognizer:privacyTap];
    }
    return _privacyView;
}

-(void)actionPushPrivacy
{
    NSLog(@"actionPushPrivacyactionPushPrivacyactionPushPrivacyactionPushPrivacy");
    NeighborsSimpleCuteBaseWebController *agrementvc = [[NeighborsSimpleCuteBaseWebController  alloc]init];
    agrementvc.isShowHidden = YES;
    agrementvc.URLString = @"http://www.hooil.cn/privacy.html";
    agrementvc.webTitle = @"Privacy Policy";
    agrementvc.loadType = WKWebLoadTypeWebURLString;
    [self.navigationController pushViewController:agrementvc animated:YES];
}
- (UILabel *)versionLab
{
    if (!_versionLab) {
        _versionLab = [[UILabel alloc]init];
        _versionLab.text = @"Hooil Version 1.0.0";
        _versionLab.textColor = RGB(237, 151, 64);
        _versionLab.textAlignment = NSTextAlignmentCenter;
        _versionLab.font = [UIFont systemFontOfSize:16];
    }
    return _versionLab;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"About us";
    [self.view addSubview:self.serviceView];
    [self.serviceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.top.offset(30);
        make.height.offset(60);
    }];
    UILabel *serviceLab = [[UILabel alloc]init];
    serviceLab.text = @"Service Agreement";
    serviceLab.textColor = [UIColor whiteColor];
    serviceLab.font = [UIFont systemFontOfSize:16];
    serviceLab.textAlignment = NSTextAlignmentLeft;
    [self.serviceView addSubview:serviceLab];
    [serviceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.serviceView);
        make.left.offset(20);
    }];
    UIImageView *jtImg = [[UIImageView alloc]init];
    jtImg.image = [UIImage imageNamed:TUIKitResource(@"a_setting_jt")];
    jtImg.contentMode = UIViewContentModeScaleAspectFit;
    [self.serviceView addSubview:jtImg];
    [jtImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.serviceView);
        make.right.offset(-20);
    }];
    
    [self.view addSubview:self.privacyView];
    [self.privacyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.top.mas_equalTo(self.serviceView.mas_bottom).offset(15);
        make.height.offset(60);
    }];
    UILabel *serviceLab2 = [[UILabel alloc]init];
    serviceLab2.text = @"Privacy Policy";
    serviceLab2.textColor = [UIColor whiteColor];
    serviceLab2.font = [UIFont systemFontOfSize:16];
    serviceLab2.textAlignment = NSTextAlignmentLeft;
    [self.privacyView addSubview:serviceLab2];
    [serviceLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.privacyView);
        make.left.offset(20);
    }];
    UIImageView *jtImg2 = [[UIImageView alloc]init];
    jtImg2.image = [UIImage imageNamed:TUIKitResource(@"a_setting_jt")];
    jtImg2.contentMode = UIViewContentModeScaleAspectFit;
    [self.privacyView addSubview:jtImg2];
    [jtImg2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.privacyView);
        make.right.offset(-20);
    }];
        
    [self.view addSubview:self.versionLab];
    [self.versionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.privacyView.mas_bottom).offset(30);
    }];
}
@end

@interface NeighborsSimpleCuteSettingBlockController ()

@property (nonatomic,strong)UIImageView *blockImg;

@property (nonatomic,strong)UILabel *blockAlterLab;

@end

@implementation NeighborsSimpleCuteSettingBlockController

- (UIImageView *)blockImg
{
    if (!_blockImg) {
        _blockImg = [[UIImageView alloc]init];
        _blockImg.image = [UIImage imageNamed:TUIKitResource(@"n_setting_block")];
        _blockImg.contentMode =  UIViewContentModeScaleAspectFit;
    }
    return _blockImg;
}
- (UILabel *)blockAlterLab
{
    if (!_blockAlterLab) {
        _blockAlterLab = [[UILabel alloc]init];
        _blockAlterLab.text = @"No members on your blacklist";
        _blockAlterLab.textColor = RGB(237, 151, 64);
        _blockAlterLab.textAlignment = NSTextAlignmentCenter;
        _blockAlterLab.numberOfLines = 0;
    }
    return _blockAlterLab;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Block member";
    [self.view addSubview:self.blockImg];
    [self.blockImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).offset(-40);
    }];
    [self.view addSubview:self.blockAlterLab];
    [self.blockAlterLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(40);
        make.right.offset(-40);
        make.top.mas_equalTo(self.blockImg.mas_bottom).offset(30);
    }];
}
@end

@implementation NeighborsSimpleCuteAppClientModel

@end

@implementation NeighborsSimpleCuteTokenDtoModel

@end

@implementation NeighborsSimpleCuteUserInfoModel

@end

@implementation NeighborsSimpleCuteAccountModel

@end

@implementation NeighborsSimpleCuteUserModel


/*
 + (NSDictionary *)mj_replacedKeyFromPropertyName
 {
     return @{@"uuid": @"id"};
 }
 + (void)save:(JYSUserModel *)model{
     NSDictionary *user = model.mj_keyValues;
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     [defaults setObject:user forKey:UserModelKey];
     [defaults synchronize];
 }
 + (JYSUserModel *)getInfo{
     NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:UserModelKey];
     JYSUserModel *user =[JYSUserModel mj_objectWithKeyValues:dict];
     return user;
 }
 + (BOOL)isOnline{
     NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:UserModelKey];
     JYSUserModel *user =[JYSUserModel mj_objectWithKeyValues:dict];
     if (user.token.length>0)
         return YES;
     return NO;
 }
 + (void)logout{
     NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:UserModelKey];
     JYSUserModel *user =[JYSUserModel mj_objectWithKeyValues:dict];
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     [defaults removeObjectForKey:UserModelKey];
     [defaults synchronize];
     user = nil;
 }
 */
+ (void)setMemberLevel:(NSInteger)memberLevel {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:memberLevel forKey:@"memberLevel"];
    [defaults synchronize];
}
+ (NSInteger)memberLevel {
    NSInteger memberLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"memberLevel"];
    return memberLevel;
}
+ (NSDictionary *)locaOrderInfo {
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"locaOrderInfo"];
    return dict;
}
+ (void)setLocaOrderInfo:(NSDictionary *)locaOrderInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:locaOrderInfo forKey:@"locaOrderInfo"];
    [defaults synchronize];
}
+ (void)save:(NeighborsSimpleCuteUserModel *)model
{
    NSDictionary *user = model.mj_keyValues;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:user forKey:@"userModel"];
    [defaults synchronize];
}
+ (NeighborsSimpleCuteUserModel *)getUserInfo
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userModel"];
    NeighborsSimpleCuteUserModel *user =[NeighborsSimpleCuteUserModel mj_objectWithKeyValues:dict];
    return user;
}
+ (BOOL)isOnline
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userModel"];
    NeighborsSimpleCuteUserModel *user =[NeighborsSimpleCuteUserModel mj_objectWithKeyValues:dict];
    if (user.tokenDto.token.length>0)
        return YES;
    return NO;
}
+ (void)logout
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userModel"];
    NeighborsSimpleCuteUserModel *user =[NeighborsSimpleCuteUserModel mj_objectWithKeyValues:dict];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"userModel"];
    [defaults synchronize];
    user = nil;
}

+(void)removeUpgradatelocaOrderInfo
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"locaOrderInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

@implementation KJBananerModel


@end

@implementation ZFMemberUpgradeIAPModel

-(void)actionRequestAddPurchaseUpgradeRecord
{
    ZFMemberUpgradeIAPModel *model = [ZFMemberUpgradeIAPModel mj_objectWithKeyValues:[NeighborsSimpleCuteUserModel locaOrderInfo]];
    NSLog(@"model:%@",model);
    if (model && model.reRequestInt > 0) {
        NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:[model mj_JSONObject]];
        [para setObject:@"1" forKey:@"payStatus"];
        [para setObject:@"IOS" forKey:@"tempStr10th"];
        NSLog(@"param:%@",para);
        NSString *url = [NSString stringWithFormat:@"%@%@",NSC_Base_Url,@"api/user/addOrderRecord"];
        [[NeighborsSimpleCuteNetworkTool sharedNetworkTool]POST:url parameters:para success:^(NeighborsSimpleCuteResposeModel *response) {
            model.reRequestInt -= 1;
            [NeighborsSimpleCuteUserModel setLocaOrderInfo:[model mj_JSONObject]];
        }failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.domain];
            return;
        }];
    }else{
        [NeighborsSimpleCuteUserModel removeUpgradatelocaOrderInfo];
    }
}

@end

@interface ZFBananerCollectionViewCell : KJBannerViewCell

@property (nonatomic,strong)UIImageView *bgImg;

@property (nonatomic,strong)UILabel *titleLab;

@property (nonatomic,strong)UILabel *subTitleLab;

@end

@implementation ZFBananerCollectionViewCell

- (UIImageView *)bgImg
{
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc]init];
        _bgImg.image = [UIImage imageNamed:@"upgrdate_huiyuan1"];
        _bgImg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImg;
}
- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.text = @"Unlimited reply voice";
        _titleLab.font = [UIFont systemFontOfSize:18];
        _titleLab.textColor = RGB(243, 165, 29);
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}
- (UILabel *)subTitleLab
{
    if (!_subTitleLab) {
        _subTitleLab = [[CusLabel alloc]init];
        _subTitleLab.text = @"Reply voice to everyone";
        _subTitleLab.font = [UIFont systemFontOfSize:15];
        _subTitleLab.textColor = RGB(243, 165, 29);
        _subTitleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _subTitleLab;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    [self.contentView addSubview:self.bgImg];
    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.offset(20);
        make.height.width.offset(70);
    }];
    [self.contentView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.bgImg.mas_bottom).offset(10);
    }];
    [self addSubview:self.subTitleLab];
    [self.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(10);
    }];
}
- (void)setModel:(NSObject *)model
{
    KJBananerModel *mmodel = (KJBananerModel*)model;
    self.bgImg.image = [UIImage imageNamed:TUIKitResource(mmodel.iconImg)];
    self.titleLab.text = mmodel.titleStr;
    self.subTitleLab.text = mmodel.subTitleStr;
}

@end


@interface ZFBananerCollectionOtherViewCell : KJBannerViewCell

@property (nonatomic,strong)UIImageView *bgImg;

@property (nonatomic,strong)CusLabel *titleLab;

@property (nonatomic,strong)CusLabel *subTitleLab;

@end

@implementation ZFBananerCollectionOtherViewCell

- (UIImageView *)bgImg
{
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc]init];
        _bgImg.image = [UIImage imageNamed:@"upgrdate_huiyuan1"];
        _bgImg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImg;
}
- (CusLabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[CusLabel alloc]init];
        _titleLab.text = @"Unlimited reply voice";
        _titleLab.font = [UIFont fontWithName:@"Times-Bold" size:18];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}
- (CusLabel *)subTitleLab
{
    if (!_subTitleLab) {
        _subTitleLab = [[CusLabel alloc]init];
        _subTitleLab.text = @"Reply voice to everyone";
        _subTitleLab.font = [UIFont fontWithName:@"Times-Bold" size:15];
        _subTitleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _subTitleLab;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    [self.contentView addSubview:self.bgImg];
    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.offset(20);
        make.height.width.offset(70);
    }];
    [self.contentView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.bgImg.mas_bottom).offset(10);
    }];
    [self addSubview:self.subTitleLab];
    [self.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(10);
    }];
}
- (void)setModel:(NSObject *)model
{
    KJBananerModel *mmodel = (KJBananerModel*)model;
    self.bgImg.image = [UIImage imageNamed:TUIKitResource(mmodel.iconImg)];
    self.titleLab.text = mmodel.titleStr;
    self.subTitleLab.text = mmodel.subTitleStr;
}

@end

@interface ZFUpgradteOtherBottomProlicyViewCell()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *prolicyTextView;

@end

@implementation ZFUpgradteOtherBottomProlicyViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI
{
    self.prolicyTextView = [[UITextView alloc] init];
    self.prolicyTextView.linkTextAttributes = @{};
    NSDictionary *normalAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"ArialMT" size:12], NSForegroundColorAttributeName: HEXCOLOR(0xA1A0A0)};
    NSMutableAttributedString *totalStr = [[NSMutableAttributedString alloc] initWithString:@"  Your payment will be charged to your iTunes account. Your subscription will automatically renew, for the same price and length of time, unless you cancel it in Settings in the iTunes Store at east 24 hours before the end of the current period. If you cancel, your subscription will stop at the end of your subscription billing cycle. By purchasing, you agree to our " attributes:normalAttributes];
    NSDictionary *userAgreementAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: HEXCOLOR(0xFC8038), NSLinkAttributeName: @"privacy://"};
    NSAttributedString *userAgreementStr = [[NSAttributedString alloc] initWithString:@"Privacy Policy" attributes:userAgreementAttributes];
    [totalStr appendAttributedString:userAgreementStr];
    NSAttributedString *andStr = [[NSAttributedString alloc] initWithString:@" the " attributes:normalAttributes];
    [totalStr appendAttributedString:andStr];
    NSDictionary *privacyAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: HEXCOLOR(0xFC8038), NSLinkAttributeName: @"service://"};
    NSAttributedString *privacyPolicyStr = [[NSAttributedString alloc] initWithString:@"Terms of Service" attributes:privacyAttributes];
    [totalStr appendAttributedString:privacyPolicyStr];
    NSAttributedString *endStr = [[NSAttributedString alloc] initWithString:@"." attributes:normalAttributes];
    [totalStr appendAttributedString:endStr];
    self.prolicyTextView.attributedText = totalStr;
    self.prolicyTextView.delegate = self;
    self.prolicyTextView.editable = NO;
    self.prolicyTextView.scrollEnabled = NO;
    self.prolicyTextView.textContainerInset = UIEdgeInsetsZero;
    self.prolicyTextView.backgroundColor = [UIColor clearColor];
    self.prolicyTextView.textContainer.lineFragmentPadding = 0;
    [self.contentView addSubview:self.prolicyTextView];
    [self.prolicyTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.top.equalTo(@10);
        make.bottom.equalTo(@-10);
    }];
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    if ([[URL scheme] isEqualToString:@"service"]) {
        NeighborsSimpleCuteBaseWebController *vc = [[NeighborsSimpleCuteBaseWebController alloc]init];
        vc.isShowHidden = YES;
        vc.webTitle = @"Terms of Service";
        vc.URLString = @"http://www.hooil.cn/terms.html";
        vc.loadType = WKWebLoadTypeWebURLString;
        [self.mm_viewController.navigationController pushViewController:vc animated:YES];
        return NO;
    } else if ([[URL scheme] isEqualToString:@"privacy"]) {
        NeighborsSimpleCuteBaseWebController *vc = [[NeighborsSimpleCuteBaseWebController alloc]init];
        vc.webTitle = @"Privacy Policy";
        vc.URLString = @"http://www.hooil.cn/privacy.html";
        vc.isShowHidden = YES;
        vc.loadType = WKWebLoadTypeWebURLString;
        [self.mm_viewController.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    return YES;
}
@end

@interface ZFUpgradteBottomProlicyViewCell ()<UITextViewDelegate>
@property (nonatomic, strong) UITextView *prolicyTextView;
@end

@implementation ZFUpgradteBottomProlicyViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI
{
    self.prolicyTextView = [[UITextView alloc] init];
    self.prolicyTextView.linkTextAttributes = @{};
    NSDictionary *normalAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: HEXCOLOR(0xA1A0A0)};
    NSMutableAttributedString *totalStr = [[NSMutableAttributedString alloc] initWithString:@"  Your payment will be charged to your iTunes account. Your subscription will automatically renew, for the same price and length of time, unless you cancel it in Settings in the iTunes Store at east 24 hours before the end of the current period. If you cancel, your subscription will stop at the end of your subscription billing cycle. By purchasing, you agree to our " attributes:normalAttributes];
    NSDictionary *userAgreementAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: HEXCOLOR(0xFC7D38), NSLinkAttributeName: @"privacy://"};
    NSAttributedString *userAgreementStr = [[NSAttributedString alloc] initWithString:@"Privacy Policy" attributes:userAgreementAttributes];
    [totalStr appendAttributedString:userAgreementStr];
    NSAttributedString *andStr = [[NSAttributedString alloc] initWithString:@" the " attributes:normalAttributes];
    [totalStr appendAttributedString:andStr];
    NSDictionary *privacyAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: HEXCOLOR(0xFC7D38), NSLinkAttributeName: @"service://"};
    NSAttributedString *privacyPolicyStr = [[NSAttributedString alloc] initWithString:@"Terms of Service" attributes:privacyAttributes];
    [totalStr appendAttributedString:privacyPolicyStr];
    NSAttributedString *endStr = [[NSAttributedString alloc] initWithString:@"." attributes:normalAttributes];
    [totalStr appendAttributedString:endStr];
    self.prolicyTextView.attributedText = totalStr;
    self.prolicyTextView.delegate = self;
    self.prolicyTextView.editable = NO;
    self.prolicyTextView.scrollEnabled = NO;
    self.prolicyTextView.textContainerInset = UIEdgeInsetsZero;
    self.prolicyTextView.backgroundColor = [UIColor clearColor];
    self.prolicyTextView.textContainer.lineFragmentPadding = 0;
    [self.contentView addSubview:self.prolicyTextView];
    [self.prolicyTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.top.equalTo(@10);
        make.bottom.equalTo(@-10);
    }];
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    if ([[URL scheme] isEqualToString:@"service"]) {
        NeighborsSimpleCuteBaseWebController *vc = [[NeighborsSimpleCuteBaseWebController alloc]init];
        vc.isShowHidden = YES;
        vc.webTitle = @"Terms of Service";
        vc.URLString = @"http://www.hooil.cn/terms.html";
        vc.loadType = WKWebLoadTypeWebURLString;
        [self.mm_viewController.navigationController pushViewController:vc animated:YES];
        return NO;
    } else if ([[URL scheme] isEqualToString:@"privacy"]) {
        NeighborsSimpleCuteBaseWebController *vc = [[NeighborsSimpleCuteBaseWebController alloc]init];
        vc.webTitle = @"Privacy Policy";
        vc.URLString = @"http://www.hooil.cn/privacy.html";
        vc.isShowHidden = YES;
        vc.loadType = WKWebLoadTypeWebURLString;
        [self.mm_viewController.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    return YES;
}

@end
//CONTINECE
@interface ZFUpgradteOtherCommitBuyViewCell()

@end

@implementation ZFUpgradteOtherCommitBuyViewCell

- (UIButton *)contiue_btn
{
    if (!_contiue_btn) {
        _contiue_btn = [[UIButton alloc]init];
        [_contiue_btn setTitle:@"CONTINUE" forState:UIControlStateNormal];
        [_contiue_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _contiue_btn.titleLabel.font = [UIFont fontWithName:@"Times-Bold" size:18];
        _contiue_btn.layer.cornerRadius = 25.0f;
        _contiue_btn.layer.masksToBounds = YES;
        [_contiue_btn addTarget:self action:@selector(actionContiueBtn:) forControlEvents:UIControlEventTouchUpInside];
       [_contiue_btn gradientButtonWithSize:CGSizeMake((IPHONE_WIDTH-80), 50) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 63)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    }
    return _contiue_btn;
}

-(void)actionContiueBtn:(UIButton *)btn
{
    NSLog(@"actionContiueBtn Other btn");
    if (self.ZFUpgradteCommitBuyViewCellContinueBlock) {
        self.ZFUpgradteCommitBuyViewCellContinueBlock();
    }
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    [self.contentView addSubview:self.contiue_btn];
    [self.contiue_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.contentView);
        make.height.offset(50);
        make.left.offset(40);
        make.right.offset(-40);
    }];
}

@end



@interface ZFUpgradteCommitBuyViewCell ()

@end


@implementation ZFUpgradteCommitBuyViewCell

- (UIButton *)contiue_btn
{
    if (!_contiue_btn) {
        _contiue_btn = [[UIButton alloc]init];
        [_contiue_btn setTitle:@"Continue" forState:UIControlStateNormal];
        [_contiue_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _contiue_btn.titleLabel.font = [UIFont systemFontOfSize:16];
        _contiue_btn.layer.cornerRadius = 10.0f;
        _contiue_btn.layer.masksToBounds = YES;
        [_contiue_btn addTarget:self action:@selector(actionContiueBtn:) forControlEvents:UIControlEventTouchUpInside];
       [_contiue_btn gradientButtonWithSize:CGSizeMake((IPHONE_WIDTH-40), 50) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 63)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    }
    return _contiue_btn;
}

-(void)actionContiueBtn:(UIButton *)btn
{
    NSLog(@"actionContiueBtn btn");
    if (self.ZFUpgradteCommitBuyViewCellContinueBlock) {
        self.ZFUpgradteCommitBuyViewCellContinueBlock();
    }
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    [self.contentView addSubview:self.contiue_btn];
    [self.contiue_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.contentView);
        make.height.offset(50);
        make.left.offset(20);
        make.right.offset(-20);
    }];
}

@end

//新的内购的界面功能
@interface ZFUpgradteOtherContentViewCell()


@end

@implementation ZFUpgradteOtherContentViewCell

- (UIButton *)bg_view
{
    if (!_bg_view) {
        _bg_view = [[UIButton alloc]init];
        _bg_view.backgroundColor = RGB(55, 55, 55);
    }
    return _bg_view;
}

- (UIView *)bg_view2

{
    if (!_bg_view2) {
        _bg_view2 = [[UIView alloc]init];
        _bg_view2.backgroundColor = RGB(55, 55, 55);
    }
    return _bg_view2;
}

- (CusLabel *)middle_lab
{
    if (!_middle_lab) {
        _middle_lab = [[CusLabel alloc]init];
        _middle_lab.text = @"$58.99";
        _middle_lab.textAlignment = NSTextAlignmentCenter;
        _middle_lab.font  = [UIFont fontWithName:@"Times-Roman" size:18];
    }
    return _middle_lab;
}

- (UILabel *)top_lab
{
    if (!_top_lab) {
        _top_lab = [[UILabel alloc]init];
        _top_lab.text = @"6  /n months";
        _top_lab.textColor = RGB(178, 171, 157);
        _top_lab.textAlignment = NSTextAlignmentCenter;
        _top_lab.numberOfLines = 2;
        _top_lab.font = [UIFont fontWithName:@"Times-Roman" size:15];
    }
    return _top_lab;
}

- (UILabel *)bottom_lab
{
    if (!_bottom_lab) {
        _bottom_lab = [[UILabel alloc]init];
        _bottom_lab.text = @"8.99 / month";
        _bottom_lab.textColor = RGB(178, 171, 157);
        _bottom_lab.textAlignment = NSTextAlignmentCenter;
        _bottom_lab.font = [UIFont fontWithName:@"Times-Roman" size:14];
    }
    return _bottom_lab;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    [self.contentView addSubview:self.bg_view];
    [self.bg_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    
    [self.contentView addSubview:self.bg_view2];
    [self.bg_view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(4);
        make.top.offset(4);
        make.right.offset(-4);
        make.bottom.offset(-4);
    }];
    
    [self.contentView addSubview:self.middle_lab];
    [self.middle_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.top_lab];
    [self.top_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.middle_lab.mas_top).offset(-15);
    }];
    
    [self.contentView addSubview:self.bottom_lab];
    [self.bottom_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.middle_lab.mas_bottom).offset(15);
    }];
}
@end

@interface ZFUpgradteContentViewCell  ()

@end

@implementation ZFUpgradteContentViewCell


- (UIButton *)bg_view
{
    if (!_bg_view) {
        _bg_view = [[UIButton alloc]init];
        _bg_view.backgroundColor = RGB(55, 55, 55);
    }
    return _bg_view;
}

- (UIView *)bg_view2

{
    if (!_bg_view2) {
        _bg_view2 = [[UIView alloc]init];
        _bg_view2.backgroundColor = RGB(55, 55, 55);
    }
    return _bg_view2;
}

- (UILabel *)middle_lab
{
    if (!_middle_lab) {
        _middle_lab = [[UILabel alloc]init];
        _middle_lab.text = @"$58.99";
        _middle_lab.textColor = RGB(252, 133, 55);
        _middle_lab.font  = [UIFont boldSystemFontOfSize:18];
    }
    return _middle_lab;
}

- (UILabel *)top_lab
{
    if (!_top_lab) {
        _top_lab = [[UILabel alloc]init];
        _top_lab.text = @"6 months";
        _top_lab.textColor = RGB(176, 171, 157);
        _top_lab.font = [UIFont systemFontOfSize:15];
    }
    return _top_lab;
}

- (UILabel *)bottom_lab
{
    if (!_bottom_lab) {
        _bottom_lab = [[UILabel alloc]init];
        _bottom_lab.text = @"8.99 / month";
        _bottom_lab.textColor = RGB(176, 171, 157);
        _bottom_lab.font = [UIFont systemFontOfSize:15];
    }
    return _bottom_lab;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    [self.contentView addSubview:self.bg_view];
    [self.bg_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    
    [self.contentView addSubview:self.bg_view2];
    [self.bg_view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(4);
        make.top.offset(4);
        make.right.offset(-4);
        make.bottom.offset(-4);
    }];
    
    [self.contentView addSubview:self.middle_lab];
    [self.middle_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.top_lab];
    [self.top_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.middle_lab.mas_top).offset(-15);
    }];
    
    [self.contentView addSubview:self.bottom_lab];
    [self.bottom_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.middle_lab.mas_bottom).offset(15);
    }];
}
@end

//#define UpgradeSecret2 @"0bfb984514a14ba8a89198f5911fc1fa" //共享数据
#define UpgradeSecret2 @"f2c46f2c7a15487f9858a78a28fc2203" // hooil-APP
// 新会员功能
@interface ZFMemberUpgrdeOtherController()<UICollectionViewDelegate,UICollectionViewDataSource,KJBannerViewDelegate,KJBannerViewDataSource>
@property (nonatomic,strong)UIButton *restoreOtherBtn;
@property (nonatomic,strong)UIView *bottomOtherView;
@property (nonatomic,strong)KJBannerView *bannerOther;
@property (nonatomic,assign)BOOL isSelectOther;
@property (nonatomic,assign)NSInteger upgradeSelectRowOther;
@property (nonatomic,copy)NSString *upgrdateCurrentProductIDOther;
@property (nonatomic,strong)NSMutableArray *bannerListArrOther;
@property (nonatomic,strong)NSMutableArray *productListArrOther;
@property (nonatomic,strong)NSMutableArray *identityListArrOther;
@property (nonatomic,strong)UICollectionView *productCollectionViewOther;
@end
@implementation ZFMemberUpgrdeOtherController
- (UICollectionView *)productCollectionViewOther
{
    if (!_productCollectionViewOther) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        flow.minimumLineSpacing = 10;
        flow.minimumInteritemSpacing = 10;
        _productCollectionViewOther = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flow];
        _productCollectionViewOther.backgroundColor = [UIColor clearColor];
        _productCollectionViewOther.delegate = self;
        _productCollectionViewOther.dataSource = self;
        [_productCollectionViewOther registerClass:[ZFUpgradteOtherContentViewCell class] forCellWithReuseIdentifier:@"ZFUpgradteOtherContentViewCell"];
        [_productCollectionViewOther registerClass:[ZFUpgradteOtherCommitBuyViewCell class] forCellWithReuseIdentifier:@"ZFUpgradteOtherCommitBuyViewCell"];
        [_productCollectionViewOther registerClass:[ZFUpgradteOtherBottomProlicyViewCell class] forCellWithReuseIdentifier:@"ZFUpgradteOtherBottomProlicyViewCell"];
    }
    return _productCollectionViewOther;
}

- (NSMutableArray *)identityListArrOther
{
    if (!_identityListArrOther) {
        //_identityListArrOther = [NSMutableArray arrayWithObjects:@"cooil_1_month",@"cooil_3_months",@"cooil_6_months",@"cooil_12_months",nil];
        _identityListArrOther = [NSMutableArray arrayWithObjects:@"hooil_1_month",@"hooil_3_months",@"hooil_6_months",@"hooil_12_months",nil];
    }
    return _identityListArrOther;
}
- (NSMutableArray *)productListArrOther
{
    if (!_productListArrOther) {
        _productListArrOther = [NSMutableArray array];
    }
    return _productListArrOther;
}
- (NSMutableArray *)bannerListArrOther
{
    if (!_bannerListArrOther) {
        _bannerListArrOther = [NSMutableArray array];
    }
    return _bannerListArrOther;
}
- (UIView *)bottomOtherView
{
    if (!_bottomOtherView) {
        _bottomOtherView = [[UIView alloc]init];
        _bottomOtherView.backgroundColor = [UIColor clearColor];
        //RGBColor(55, 55, 55);
    }
    return _bottomOtherView;
}
- (UIButton *)restoreOtherBtn
{
    if (!_restoreOtherBtn) {
        _restoreOtherBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_restoreOtherBtn setTitle:@"Restore" forState:UIControlStateNormal];
        [_restoreOtherBtn setTitleColor:RGB(252, 246, 224) forState:UIControlStateNormal];
        _restoreOtherBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _restoreOtherBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 4.0, 0.0, -4.0);
        [_restoreOtherBtn addTarget:self action:@selector(setOtherCxshareldstaretlRightBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_restoreOtherBtn sizeToFit];
    }
    return _restoreOtherBtn;
}

-(void)setOtherCxshareldstaretlRightBtn:(UIButton *)btn
{
    NSLog(@"setCxshareldstaretlRightBtn");
    
     NSLog(@"Restore btn");
     [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
     [SVProgressHUD show];
     [[IAPShare sharedHelper].iap restoreProductsWithCompletion:^(SKPaymentQueue *payment, NSError *error) {
         NSLog(@"payment.transactions.count:%lu", (unsigned long)payment.transactions.count);
         if (!error && payment.transactions.count) {
             if (![NeighborsSimpleCuteUserModel locaOrderInfo].allValues.count) {
                 NSData *data = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                 [[IAPShare sharedHelper].iap checkReceipt:data AndSharedSecret:UpgradeSecret2 onCompletion:^(NSString *response, NSError *error) {
                     NSDictionary *dics = [response getCxshareldstaretlToDictionary];
                     NSLog(@"dics:%@",dics);
                     if ([dics[@"status"] intValue] == 21007) {
                         [IAPShare sharedHelper].iap.production = YES;
                         [[IAPShare sharedHelper].iap checkReceipt:data AndSharedSecret:UpgradeSecret2 onCompletion:^(NSString *response, NSError *error) {
                                 if (error) {
                                    [SVProgressHUD dismiss];
                                    [SVProgressHUD showInfoWithStatus:@"Restore purchase failed."];
                                 } else {
                                     [SVProgressHUD dismiss];
                                     [SVProgressHUD showInfoWithStatus:@"Restore purchase successed."];
                                     [self actionAddRecordWithResposeoneData:response];
                                 }
                         }];
                     } else {
                         if (error) {
                            [SVProgressHUD dismiss];
                            [SVProgressHUD showInfoWithStatus:@"Restore purchase failed."];
                         } else {
                             [SVProgressHUD dismiss];
                             [SVProgressHUD showInfoWithStatus:@"Restore purchase successed."];
                             [self actionAddRecordWithResposeoneData:response];
                         }
                     }
                 }];
             } else {
                 [SVProgressHUD dismiss];
                 [SVProgressHUD showInfoWithStatus:@"Restore purchase successed."];
                 //update local data
                 NeighborsSimpleCuteUserModel *userModel = [NeighborsSimpleCuteUserModel getUserInfo];
                 userModel.userInfo.memberLevel = 1;
                 [NeighborsSimpleCuteUserModel save:userModel];
             }
         } else {
             [SVProgressHUD dismiss];
             [SVProgressHUD showInfoWithStatus:@"Please select membership"];
         }
     }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.upgradeSelectRowOther = 100;
    self.navigationItem.title = @"Upgrade";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.restoreOtherBtn];
    [self setupBanerData];
    [self setupUpgradeTopView];
    [[ZFMemberUpgradeIAPModel new] actionRequestAddPurchaseUpgradeRecord];
    [self setupStoreInfoData];
}
-(void)setupBanerData
{
    [self.bannerListArrOther removeAllObjects];
    KJBananerModel *model = [[KJBananerModel alloc]init];
    model.iconImg = @"huiyuan2";
    model.titleStr = @"Unlimited Reply Voice";
    model.subTitleStr = @"Reply Voice To Everyone Every Day";
    [self.bannerListArrOther addObject:model];
    KJBananerModel *model2 = [[KJBananerModel alloc]init];
    model2.iconImg = @"huiyuan2";
    model2.titleStr = @"Unlimited Send Voice";
    model2.subTitleStr = @"Send More Voice In The City Square";
    [self.bannerListArrOther addObject:model2];
}
-(void)setupUpgradeTopView
{
    KJBannerView *banner = [[KJBannerView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,180)];
    banner.delegate = self;
    banner.dataSource = self;

    [banner registerClass:[ZFBananerCollectionOtherViewCell class] forCellWithReuseIdentifier:@"ZFBananerCollectionOtherViewCell"];
    banner.itemSpace = 10;
    banner.delegate = self;
    banner.itemWidth = self.view.frame.size.width;
    banner.rollType = KJBannerViewRollDirectionTypeRightToLeft;
    [self.view addSubview:banner];
    [banner reloadData];
}
#pragma mark - KJBannerViewDelegate
- (void)kj_bannerView:(KJBannerView *)banner didSelectItemAtIndex:(NSInteger)index
{
    
}
- (void)kj_bannerView:(KJBannerView *)banner loopScrolledItemAtIndex:(NSInteger)index
{
    
}
#pragma mark - KJBannerViewDataSource

- (NSInteger)kj_numberOfItemsInBannerView:(KJBannerView *)banner
{
    return self.bannerListArrOther.count;
}
- (__kindof KJBannerViewCell *)kj_bannerView:(KJBannerView *)banner cellForItemAtIndex:(NSInteger)index {
    ZFBananerCollectionOtherViewCell *cell = [banner dequeueReusableCellWithReuseIdentifier:@"ZFBananerCollectionOtherViewCell" forIndex:index];
    KJBananerModel *model  = self.bannerListArrOther[index];
    cell.titleLab.text = model.titleStr;
    cell.subTitleLab.text = model.subTitleStr;
    cell.bgImg.image = [UIImage imageNamed:TUIKitResource(model.iconImg)];
    return cell;
}
- (nullable NSString *)kj_bannerView:(KJBannerView *)banner nextPreRenderedImageItemAtIndex:(NSInteger)index{
    return nil;
}
- (void)kj_bannerView:(KJBannerView *)banner preRenderedImage:(UIImage *)image{
    
}
/// 获取苹果商店的东西
-(void)setupStoreInfoData
{
    [SVProgressHUD show];
    NSSet* dataSet = [[NSSet alloc] initWithArray:self.self.identityListArrOther];
    [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
    [IAPShare sharedHelper].iap.production = YES;
    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest *request, SKProductsResponse *response) {
        if (response.products.count >0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                NSLog(@"setupStoreInfoData:count:%lu",(unsigned long)response.products.count);
                [self.productListArrOther removeAllObjects];
                NSMutableArray *array = [NSMutableArray array];
                [array addObjectsFromArray:response.products];
                [array enumerateObjectsUsingBlock:^(SKProduct  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.productIdentifier isEqualToString:@"hooil_1_month"]) {
                        [self.productListArrOther addObject:obj];
                        *stop = YES;
                    }
                }];
                [response.products enumerateObjectsUsingBlock:^(SKProduct  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.productIdentifier isEqualToString:@"hooil_3_months"]) {
                        [self.productListArrOther addObject:obj];
                        *stop = YES;
                    }
                }];
                [response.products enumerateObjectsUsingBlock:^(SKProduct  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.productIdentifier isEqualToString:@"hooil_6_months"]) {
                        [self.productListArrOther addObject:obj];
                        *stop = YES;
                    }
                }];
                [response.products enumerateObjectsUsingBlock:^(SKProduct  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.productIdentifier isEqualToString:@"hooil_12_months"]) {
                        [self.productListArrOther addObject:obj];
                        *stop = YES;
                    }
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [self showAnimationMethod];
                });
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }
    }];
}
- (void)showAnimationMethod {
    
    [self.view addSubview:self.bottomOtherView];
    [self.bottomOtherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.offset(180);
    }];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH, Screen_Height- 180) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bottomOtherView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.bottomOtherView.layer.mask = maskLayer;
    [self.bottomOtherView addSubview:self.productCollectionViewOther];
    [self.productCollectionViewOther mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    [UIView animateWithDuration:1.0
                          delay:0.0
         usingSpringWithDamping:0.4
          initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        [self.view layoutIfNeeded];
    }
                     completion:^(BOOL finished) {
                    
    }];
}
#pragma mark -- ZFMemberUpgrdeController | UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.productListArrOther.count;
    }else{
        return 1;
    }
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsMake(20, 20, 20, 20);
    }else{
        return UIEdgeInsetsZero;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
     if(indexPath.section == 0){
        return CGSizeMake((SCREEN_WIDTH-50)/2, 150);
    }else if(indexPath.section == 1){
        return CGSizeMake(SCREEN_WIDTH, 50);
    }else{
        return CGSizeMake(SCREEN_WIDTH, 200);
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        ZFUpgradteOtherContentViewCell *contentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZFUpgradteOtherContentViewCell" forIndexPath:indexPath];
        SKProduct *product = self.productListArrOther[indexPath.row];
        contentCell.middle_lab.text = [self formatter:product number:product.price];
        if (indexPath.row == 0) {
            contentCell.top_lab.text = @"1 \n month";
            NSString *doubleString = [NSString stringWithFormat:@"%lf", [product.price doubleValue]];
            NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
            contentCell.bottom_lab.text = [NSString stringWithFormat:@"%@/month",[self formatter:product number:decNumber]];
        }else if(indexPath.row == 1){
            contentCell.top_lab.text = @"3  \n months";
            NSString *doubleString = [NSString stringWithFormat:@"%lf", [product.price doubleValue]/3];
            NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
            contentCell.bottom_lab.text = [NSString stringWithFormat:@"%@/month",[self formatter:product number:decNumber]];
        }else if(indexPath.row == 2 ){
            contentCell.top_lab.text = @"6 \n months";
            NSString *doubleString = [NSString stringWithFormat:@"%lf", [product.price doubleValue]/6];
            NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
            contentCell.bottom_lab.text = [NSString stringWithFormat:@"%@/month",[self formatter:product number:decNumber]];
        }else{
            contentCell.top_lab.text = @"12 \n months";
            NSString *doubleString = [NSString stringWithFormat:@"%lf", [product.price doubleValue]/12];
            NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
            contentCell.bottom_lab.text = [NSString stringWithFormat:@"%@/months",[self formatter:product number:decNumber]];
        }
        if (indexPath.row == self.upgradeSelectRowOther) {
            [contentCell.bg_view gradientButtonWithSize:CGSizeMake((IPHONE_WIDTH-50)/2, 130) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 63)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
            contentCell.bg_view.layer.cornerRadius = 6.0f;
            contentCell.bg_view.layer.masksToBounds = YES;
        }else{
            [contentCell.bg_view gradientButtonWithSize:CGSizeMake((IPHONE_WIDTH-50)/2, 130) colorArray:@[(id)RGB(55,55,55),(id)RGB(55, 55, 55)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
            contentCell.bg_view.layer.cornerRadius = 0.0f;
            contentCell.bg_view.layer.masksToBounds = YES;
        }
        return contentCell;
    }else if(indexPath.section == 1){
        ZFUpgradteOtherCommitBuyViewCell *buyCommitCell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZFUpgradteOtherCommitBuyViewCell" forIndexPath:indexPath];
        [buyCommitCell setZFUpgradteCommitBuyViewCellContinueBlock:^{
            //contiuebtn action
            [self actionUpgrdatePurcharAction];
        }];
        return buyCommitCell;
    }else{
        ZFUpgradteOtherBottomProlicyViewCell *prolicahBottomCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZFUpgradteOtherBottomProlicyViewCell" forIndexPath:indexPath];
        return prolicahBottomCell;
    }
}

//开始购买
-(void)actionUpgrdatePurcharAction
{
    if (self.isSelectOther == NO) {
        [SVProgressHUD showInfoWithStatus:@"Please select membership to purchas"];
        return;
    }
    [SVProgressHUD show];
    SKProduct *product = self.productListArrOther[self.upgradeSelectRowOther];
    [[IAPShare sharedHelper].iap buyProduct:product onCompletion:^(SKPaymentTransaction *transcation) {
        if (transcation.transactionState == SKPaymentTransactionStatePurchasing) {
            NSLog(@"SKPaymentTransactionStatePurchasing");
        }else if(transcation.transactionState == SKPaymentTransactionStatePurchased){
            NSLog(@"SKPaymentTransactionStatePurchased");
            if (transcation.originalTransaction) {
                if (![NeighborsSimpleCuteUserModel locaOrderInfo].allValues.count) {
                    NSData *data = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                    [[IAPShare sharedHelper].iap checkReceipt:data AndSharedSecret:UpgradeSecret2 onCompletion:^(NSString *response, NSError *error) {
                        NSDictionary *dics = [response getCxshareldstaretlToDictionary];
                        if ([dics[@"status"] intValue] == 21007) {
                            [IAPShare sharedHelper].iap.production = YES;
                            [[IAPShare sharedHelper].iap checkReceipt:data onCompletion:^(NSString *response, NSError *error) {
                                if (error) {
                                    [SVProgressHUD dismiss];
                                    [SVProgressHUD showInfoWithStatus:@"Please restore to purchase"];
                                    return;
                                }else{
                                    [SVProgressHUD dismiss];
                                    [SVProgressHUD showInfoWithStatus:@"Purchase successed."];
                                    [self actionAddRecordWithResposeoneData:response];
                                }
                            }];
                        }else{
                            if (error) {
                                [SVProgressHUD dismiss];
                                [SVProgressHUD showInfoWithStatus:@"Please restore to purchase"];
                            }else{
                                [SVProgressHUD dismiss];
                                [SVProgressHUD showInfoWithStatus:@"Purchase successed."];
                                [self actionAddRecordWithResposeoneData:response];
                            }
                        }
                    }];
                }else{
                    ZFMemberUpgradeIAPModel *model = [ZFMemberUpgradeIAPModel mj_objectWithKeyValues:[NeighborsSimpleCuteUserModel locaOrderInfo]];
                    if (![model.goodsId isEqualToString:self.upgrdateCurrentProductIDOther]) {
                        model.goodsId = self.upgrdateCurrentProductIDOther;
                        model.reRequestInt = 5;
                        // 请求记录
                        [self actionRequestAddUpgredateOrderRecord];
                    } else {
                        [SVProgressHUD dismiss];
                        [SVProgressHUD showInfoWithStatus:@"Purchase successed."];
                        //这里记录下成功
                        NeighborsSimpleCuteUserModel *userModel = [NeighborsSimpleCuteUserModel getUserInfo];
                        userModel.userInfo.memberLevel = 1;
                        [NeighborsSimpleCuteUserModel save:userModel];
                    }
                }
            }else{
                NSData *data = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                [[IAPShare sharedHelper].iap checkReceipt:data AndSharedSecret:UpgradeSecret2 onCompletion:^(NSString *response, NSError *error) {
                    NSDictionary *dics = [response getCxshareldstaretlToDictionary];
                    if ([dics[@"status"] intValue] == 21007) {
                        [IAPShare sharedHelper].iap.production = YES;
                        [[IAPShare sharedHelper].iap checkReceipt:data AndSharedSecret:UpgradeSecret2 onCompletion:^(NSString *response, NSError *error) {
                            if (error) {
                                [SVProgressHUD dismiss];
                                [SVProgressHUD showInfoWithStatus:@"Purchase failed."];
                            }else{
                                [SVProgressHUD dismiss];
                                [SVProgressHUD showInfoWithStatus:@"Purchase successed."];
                                [self actionAddRecordWithResposeoneData:response];
                            }
                        }];
                    }else{
                        if (error) {
                            [SVProgressHUD dismiss];
                            [SVProgressHUD showInfoWithStatus:@"Purchase failed."];
                        }else{
                            [SVProgressHUD dismiss];
                            [SVProgressHUD showInfoWithStatus:@"Purchase successed."];
                            [self actionAddRecordWithResposeoneData:response];
                        }
                    }
                }];
            }
        }else if(transcation.transactionState == SKPaymentTransactionStateFailed){
            NSLog(@"SKPaymentTransactionStateFailed");
            [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:@"Purchase Cancel"];
        }else if(transcation.transactionState == SKPaymentTransactionStateRestored){
            NSLog(@"SKPaymentTransactionStateRestored");
            [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:@"Purchase Restored"];
        }else if(transcation.transactionState == SKPaymentTransactionStateDeferred){
            NSLog(@"SKPaymentTransactionStateDeferred");
            [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:@"Purchase Deferred"];
        }else{
            [SVProgressHUD dismiss];
        }
    }];
}
/// 添加记录功能
/// @param response 返回内容
-(void)actionAddRecordWithResposeoneData:(NSString *)response
{   //记录状态
    NeighborsSimpleCuteUserModel *userModel = [NeighborsSimpleCuteUserModel getUserInfo];
    userModel.userInfo.memberLevel = 1;
    [NeighborsSimpleCuteUserModel save:userModel];
    //添加记录功能
    ZFMemberUpgradeIAPModel *upgrdateModel = [[ZFMemberUpgradeIAPModel alloc]init];
    upgrdateModel.reRequestInt = 5;
    NSDictionary *dic = [NSArray arrayWithArray:[response getCxshareldstaretlToDictionary][@"pending_renewal_info"]].lastObject;
    upgrdateModel.orderNum = [NSString stringWithFormat:@"GPA.IOS.(%ld)(%@)",(long)userModel.userInfo.userId,dic[@"original_transaction_id"]];
    upgrdateModel.goodsId = dic[@"product_id"];
    [NeighborsSimpleCuteUserModel setLocaOrderInfo:[upgrdateModel mj_JSONObject]];
    [self actionRequestAddUpgredateOrderRecord];
}
/// 调用接口给服务器返回数据
-(void)actionRequestAddUpgredateOrderRecord
{
    ZFMemberUpgradeIAPModel *model = [ZFMemberUpgradeIAPModel mj_objectWithKeyValues:[NeighborsSimpleCuteUserModel locaOrderInfo]];
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:[model mj_JSONObject]];
    [para setObject:@"1" forKey:@"payStatus"];
    [para setObject:@"IOS" forKey:@"tempStr10th"];
    NSLog(@"param:%@",para);
    NSString *url = [NSString stringWithFormat:@"%@%@",NSC_Base_Url,@"api/user/addOrderRecord"];
    [[NeighborsSimpleCuteNetworkTool sharedNetworkTool]POST:url parameters:para success:^(NeighborsSimpleCuteResposeModel *response) {
        [SVProgressHUD dismiss];
        if (response.code == 0) {
            ZFMemberUpgradeIAPModel *model = [ZFMemberUpgradeIAPModel mj_objectWithKeyValues:[NeighborsSimpleCuteUserModel locaOrderInfo]];
            model.reRequestInt -= 1;
            [NeighborsSimpleCuteUserModel setLocaOrderInfo:[model mj_JSONObject]];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.domain];
            return;
    }];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    self.isSelectOther = YES;
    self.upgradeSelectRowOther = (int)indexPath.row;
    self.upgrdateCurrentProductIDOther = self.identityListArrOther[indexPath.row];
    [self.productCollectionViewOther reloadData];
}
#pragma mark - KJBannerViewDelegate
//点击图片的代理
- (void)kj_BannerView:(KJBannerView *)banner SelectIndex:(NSInteger)index
{
    NSLog(@"index = %ld",(long)index);
}
- (NSString *)formatter:(SKProduct *)obj number:(NSDecimalNumber *)number{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:obj.priceLocale];
    NSString *formattedPrice = [numberFormatter stringFromNumber:number];
    return formattedPrice;
}
@end

//#define UpgradeSecret @"0bfb984514a14ba8a89198f5911fc1fa"// cooil
#define UpgradeSecret @"f2c46f2c7a15487f9858a78a28fc2203"// hooil-app
@interface ZFMemberUpgrdeController ()<UICollectionViewDelegate,UICollectionViewDataSource,KJBannerViewDelegate,KJBannerViewDataSource>
@property (nonatomic,strong)UIButton *restoreBtn;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)KJBannerView *banner;
@property (nonatomic,assign)BOOL isSelect;
@property (nonatomic,assign)NSInteger upgradeSelectRow;
@property (nonatomic,copy)NSString *upgrdateCurrentProductID;
@property (nonatomic,strong)NSMutableArray *bannerListArr;
@property (nonatomic,strong)NSMutableArray *productListArr;
@property (nonatomic,strong)NSMutableArray *identityListArr;
@property (nonatomic,strong)UICollectionView *productCollectionView;
@end

@implementation ZFMemberUpgrdeController
- (UICollectionView *)productCollectionView
{
    if (!_productCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        flow.minimumLineSpacing = 10;
        flow.minimumInteritemSpacing = 10;
        _productCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flow];
        _productCollectionView.backgroundColor = [UIColor clearColor];
        _productCollectionView.delegate = self;
        _productCollectionView.dataSource = self;
        [_productCollectionView registerClass:[ZFUpgradteContentViewCell class] forCellWithReuseIdentifier:@"ZFUpgradteContentViewCell"];
        [_productCollectionView registerClass:[ZFUpgradteCommitBuyViewCell class] forCellWithReuseIdentifier:@"ZFUpgradteCommitBuyViewCell"];
        //[_productCollectionView registerNib:[UINib nibWithNibName:@"ZFUpgradteContentViewCell" bundle:nil] forCellWithReuseIdentifier:@"ZFUpgradteContentViewCell"];
        //[_productCollectionView registerNib:[UINib nibWithNibName:@"ZFUpgradteCommitBuyViewCell" bundle:nil] forCellWithReuseIdentifier:@"ZFUpgradteCommitBuyViewCell"];
        [_productCollectionView registerClass:[ZFUpgradteBottomProlicyViewCell class] forCellWithReuseIdentifier:@"ZFUpgradteBottomProlicyViewCell"];
    }
    return _productCollectionView;
}

- (NSMutableArray *)identityListArr
{
    if (!_identityListArr) {
        //_identityListArr = [NSMutableArray arrayWithObjects:@"cooil_1_month",@"cooil_3_months",@"cooil_6_months",@"cooil_12_months",nil];
        _identityListArr = [NSMutableArray arrayWithObjects:@"hooil_1_month",@"hooil_3_months",@"hooil_6_months",@"hooil_12_months",nil];
    }
    return _identityListArr;
}
- (NSMutableArray *)productListArr
{
    if (!_productListArr) {
        _productListArr = [NSMutableArray array];
    }
    return _productListArr;
}
- (NSMutableArray *)bannerListArr
{
    if (!_bannerListArr) {
        _bannerListArr = [NSMutableArray array];
    }
    return _bannerListArr;
}
- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor clearColor];
        //RGBColor(55, 55, 55);
    }
    return _bottomView;
}
- (UIButton *)restoreBtn
{
    if (!_restoreBtn) {
        _restoreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_restoreBtn setTitle:@"Restore" forState:UIControlStateNormal];
        [_restoreBtn setTitleColor:RGB(252, 246, 224) forState:UIControlStateNormal];
        _restoreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _restoreBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 4.0, 0.0, -4.0);
        [_restoreBtn addTarget:self action:@selector(setCxshareldstaretlRightBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_restoreBtn sizeToFit];
    }
    return _restoreBtn;
}

-(void)setCxshareldstaretlRightBtn:(UIButton *)btn
{
    NSLog(@"setCxshareldstaretlRightBtn");
    
     NSLog(@"Restore btn");
     [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
     [SVProgressHUD show];
     [[IAPShare sharedHelper].iap restoreProductsWithCompletion:^(SKPaymentQueue *payment, NSError *error) {
         NSLog(@"payment.transactions.count:%lu", (unsigned long)payment.transactions.count);
         if (!error && payment.transactions.count) {
             if (![NeighborsSimpleCuteUserModel locaOrderInfo].allValues.count) {
                 NSData *data = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                 [[IAPShare sharedHelper].iap checkReceipt:data AndSharedSecret:UpgradeSecret onCompletion:^(NSString *response, NSError *error) {
                     NSDictionary *dics = [response getCxshareldstaretlToDictionary];
                     NSLog(@"dics:%@",dics);
                     if ([dics[@"status"] intValue] == 21007) {
                         [IAPShare sharedHelper].iap.production = YES;
                         [[IAPShare sharedHelper].iap checkReceipt:data AndSharedSecret:UpgradeSecret onCompletion:^(NSString *response, NSError *error) {
                                 if (error) {
                                    [SVProgressHUD dismiss];
                                    [SVProgressHUD showInfoWithStatus:@"Restore purchase failed."];
                                 } else {
                                     [SVProgressHUD dismiss];
                                     [SVProgressHUD showInfoWithStatus:@"Restore purchase successed."];
                                     [self actionAddRecordWithResposeoneData:response];
                                }
                         }];
                     } else {
                         if (error) {
                            [SVProgressHUD dismiss];
                            [SVProgressHUD showInfoWithStatus:@"Restore purchase failed."];
                         } else {
                             [SVProgressHUD dismiss];
                             [SVProgressHUD showInfoWithStatus:@"Restore purchase successed."];
                             [self actionAddRecordWithResposeoneData:response];
                         }
                     }
                 }];
             } else {
                 [SVProgressHUD dismiss];
                 [SVProgressHUD showInfoWithStatus:@"Restore purchase successed."];
                 //update local data
                 NeighborsSimpleCuteUserModel *userModel = [NeighborsSimpleCuteUserModel getUserInfo];
                 userModel.userInfo.memberLevel = 1;
                 [NeighborsSimpleCuteUserModel save:userModel];
             }
         } else {
             [SVProgressHUD dismiss];
             [SVProgressHUD showInfoWithStatus:@"Please select membership"];
         }
     }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.upgradeSelectRow = 100;
    self.navigationItem.title = @"Upgrade";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.restoreBtn];
    [self setupBanerData];
    [self setupUpgradeTopView];
    [[ZFMemberUpgradeIAPModel new] actionRequestAddPurchaseUpgradeRecord];
    [self setupStoreInfoData];
}

-(void)setupBanerData
{
    [self.bannerListArr removeAllObjects];
    KJBananerModel *model = [[KJBananerModel alloc]init];
    model.iconImg = @"upgrdate_huiyuan2";
    model.titleStr = @"Unlimited Reply Voice";
    model.subTitleStr = @"Reply Voice To Everyone Every Day";
    [self.bannerListArr addObject:model];
    KJBananerModel *model2 = [[KJBananerModel alloc]init];
    model2.iconImg = @"upgrdate_huiyuan1";
    model2.titleStr = @"Unlimited Send Voice";
    model2.subTitleStr = @"Send More Voice In The City Square";
    [self.bannerListArr addObject:model2];
}
-(void)setupUpgradeTopView
{
    KJBannerView *banner = [[KJBannerView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,180)];
    banner.delegate = self;
    banner.dataSource = self;

    [banner registerClass:[ZFBananerCollectionViewCell class] forCellWithReuseIdentifier:@"ZFBananerCollectionViewCell"];
    banner.itemSpace = 10;
    banner.delegate = self;
    banner.itemWidth = self.view.frame.size.width;
    banner.rollType = KJBannerViewRollDirectionTypeRightToLeft;
    [self.view addSubview:banner];
    [banner reloadData];
}
#pragma mark - KJBannerViewDelegate
- (void)kj_bannerView:(KJBannerView *)banner didSelectItemAtIndex:(NSInteger)index
{
}
- (void)kj_bannerView:(KJBannerView *)banner loopScrolledItemAtIndex:(NSInteger)index
{
}
#pragma mark - KJBannerViewDataSource
- (NSInteger)kj_numberOfItemsInBannerView:(KJBannerView *)banner
{
    return self.bannerListArr.count;
}
- (__kindof KJBannerViewCell *)kj_bannerView:(KJBannerView *)banner cellForItemAtIndex:(NSInteger)index
{
    ZFBananerCollectionViewCell *cell = [banner dequeueReusableCellWithReuseIdentifier:@"ZFBananerCollectionViewCell" forIndex:index];
    KJBananerModel *model  = self.bannerListArr[index];
    cell.titleLab.text = model.titleStr;
    cell.subTitleLab.text = model.subTitleStr;
    cell.bgImg.image = [UIImage imageNamed:TUIKitResource(model.iconImg)];
    return cell;
}
- (nullable NSString *)kj_bannerView:(KJBannerView *)banner nextPreRenderedImageItemAtIndex:(NSInteger)index{
    return nil;
}
- (void)kj_bannerView:(KJBannerView *)banner preRenderedImage:(UIImage *)image
{
    
}
/// 获取苹果商店的东西
-(void)setupStoreInfoData
{
    [SVProgressHUD show];
    NSSet* dataSet = [[NSSet alloc] initWithArray:self.self.identityListArr];
    [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
    [IAPShare sharedHelper].iap.production = YES;
    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest *request, SKProductsResponse *response) {
        if (response.products.count >0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                NSLog(@"setupStoreInfoData:count:%lu",(unsigned long)response.products.count);
                [self.productListArr removeAllObjects];
                NSMutableArray *array = [NSMutableArray array];
                [array addObjectsFromArray:response.products];
                [array enumerateObjectsUsingBlock:^(SKProduct  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.productIdentifier isEqualToString:@"hooil_1_month"]) {
                        [self.productListArr addObject:obj];
                        *stop = YES;
                    }
                }];
                [response.products enumerateObjectsUsingBlock:^(SKProduct  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.productIdentifier isEqualToString:@"hooil_3_months"]) {
                        [self.productListArr addObject:obj];
                        *stop = YES;
                    }
                }];
                [response.products enumerateObjectsUsingBlock:^(SKProduct  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.productIdentifier isEqualToString:@"hooil_6_months"]) {
                        [self.productListArr addObject:obj];
                        *stop = YES;
                    }
                }];
                [response.products enumerateObjectsUsingBlock:^(SKProduct  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.productIdentifier isEqualToString:@"hooil_12_months"]) {
                        [self.productListArr addObject:obj];
                        *stop = YES;
                    }
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [self showAnimationMethod];
                });
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }
    }];
}
- (void)showAnimationMethod {
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.offset(180);
    }];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH, Screen_Height- 180) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bottomView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.bottomView.layer.mask = maskLayer;
    [self.bottomView addSubview:self.productCollectionView];
    [self.productCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    [UIView animateWithDuration:1.0
                          delay:0.0
         usingSpringWithDamping:0.4
          initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        [self.view layoutIfNeeded];
    }
                     completion:^(BOOL finished) {
                    
    }];
}
#pragma mark -- ZFMemberUpgrdeController | UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.productListArr.count;
    }else{
        return 1;
    }
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsMake(20, 20, 20, 20);
    }else{
        return UIEdgeInsetsZero;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
     if(indexPath.section == 0){
        return CGSizeMake((SCREEN_WIDTH-50)/2, 130);
    }else if(indexPath.section == 1){
        return CGSizeMake(SCREEN_WIDTH, 50);
    }else{
        return CGSizeMake(SCREEN_WIDTH, 200);
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        ZFUpgradteContentViewCell *contentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZFUpgradteContentViewCell" forIndexPath:indexPath];
        SKProduct *product = self.productListArr[indexPath.row];
        contentCell.middle_lab.text = [self formatter:product number:product.price];
        if (indexPath.row == 0) {
            contentCell.top_lab.text = @"1 month";
            NSString *doubleString = [NSString stringWithFormat:@"%lf", [product.price doubleValue]];
            NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
            contentCell.bottom_lab.text = [NSString stringWithFormat:@"%@/month",[self formatter:product number:decNumber]];
        }else if(indexPath.row == 1){
            contentCell.top_lab.text = @"3 months";
            NSString *doubleString = [NSString stringWithFormat:@"%lf", [product.price doubleValue]/3];
            NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
            contentCell.bottom_lab.text = [NSString stringWithFormat:@"%@/month",[self formatter:product number:decNumber]];
        }else if(indexPath.row == 2 ){
            contentCell.top_lab.text = @"6 months";
            NSString *doubleString = [NSString stringWithFormat:@"%lf", [product.price doubleValue]/6];
            NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
            contentCell.bottom_lab.text = [NSString stringWithFormat:@"%@/month",[self formatter:product number:decNumber]];
        }else{
            contentCell.top_lab.text = @"12 months";
            NSString *doubleString = [NSString stringWithFormat:@"%lf", [product.price doubleValue]/12];
            NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
            contentCell.bottom_lab.text = [NSString stringWithFormat:@"%@/months",[self formatter:product number:decNumber]];
        }
        if (indexPath.row == self.upgradeSelectRow) {
            [contentCell.bg_view gradientButtonWithSize:CGSizeMake((IPHONE_WIDTH-50)/2, 130) colorArray:@[(id)RGB(250, 204, 72),(id)RGB(235, 142, 63)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
            contentCell.bg_view.layer.cornerRadius = 6.0f;
            contentCell.bg_view.layer.masksToBounds = YES;
        }else{
            [contentCell.bg_view gradientButtonWithSize:CGSizeMake((IPHONE_WIDTH-50)/2, 130) colorArray:@[(id)RGB(55,55,55),(id)RGB(55, 55, 55)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftTopToRightBottom];
            contentCell.bg_view.layer.cornerRadius = 0.0f;
            contentCell.bg_view.layer.masksToBounds = YES;
        }
        return contentCell;
    }else if(indexPath.section == 1){
        ZFUpgradteCommitBuyViewCell *buyCommitCell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZFUpgradteCommitBuyViewCell" forIndexPath:indexPath];
        [buyCommitCell setZFUpgradteCommitBuyViewCellContinueBlock:^{
            //contiuebtn action
            [self actionUpgrdatePurcharAction];
        }];
        return buyCommitCell;
    }else{
        ZFUpgradteBottomProlicyViewCell *prolicahBottomCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZFUpgradteBottomProlicyViewCell" forIndexPath:indexPath];
        return prolicahBottomCell;
    }
}

//开始购买
-(void)actionUpgrdatePurcharAction
{
    if (self.isSelect == NO) {
        [SVProgressHUD showInfoWithStatus:@"Please select membership to purchas"];
        return;
    }
    [SVProgressHUD show];
    SKProduct *product = self.productListArr[self.upgradeSelectRow];
    [[IAPShare sharedHelper].iap buyProduct:product onCompletion:^(SKPaymentTransaction *transcation) {
        if (transcation.transactionState == SKPaymentTransactionStatePurchasing) {
            NSLog(@"SKPaymentTransactionStatePurchasing");
        }else if(transcation.transactionState == SKPaymentTransactionStatePurchased){
            NSLog(@"SKPaymentTransactionStatePurchased");
            if (transcation.originalTransaction) {
                if (![NeighborsSimpleCuteUserModel locaOrderInfo].allValues.count) {
                    NSData *data = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                    [[IAPShare sharedHelper].iap checkReceipt:data AndSharedSecret:UpgradeSecret onCompletion:^(NSString *response, NSError *error) {
                        NSDictionary *dics = [response getCxshareldstaretlToDictionary];
                        if ([dics[@"status"] intValue] == 21007) {
                            [IAPShare sharedHelper].iap.production = YES;
                            [[IAPShare sharedHelper].iap checkReceipt:data onCompletion:^(NSString *response, NSError *error) {
                                if (error) {
                                    [SVProgressHUD dismiss];
                                    [SVProgressHUD showInfoWithStatus:@"Please restore to purchase"];
                                    return;
                                }else{
                                    [SVProgressHUD dismiss];
                                    [SVProgressHUD showInfoWithStatus:@"Purchase successed."];
                                    [self actionAddRecordWithResposeoneData:response];
                                }
                            }];
                        }else{
                            if (error) {
                                [SVProgressHUD dismiss];
                                [SVProgressHUD showInfoWithStatus:@"Please restore to purchase"];
                            }else{
                                [SVProgressHUD dismiss];
                                [SVProgressHUD showInfoWithStatus:@"Purchase successed."];
                                [self actionAddRecordWithResposeoneData:response];
                            }
                        }
                    }];
                }else{
                    ZFMemberUpgradeIAPModel *model = [ZFMemberUpgradeIAPModel mj_objectWithKeyValues:[NeighborsSimpleCuteUserModel locaOrderInfo]];
                    if (![model.goodsId isEqualToString:self.upgrdateCurrentProductID]) {
                        model.goodsId = self.upgrdateCurrentProductID;
                        model.reRequestInt = 5;
                        // 请求记录
                        [self actionRequestAddUpgredateOrderRecord];
                    } else {
                        [SVProgressHUD dismiss];
                        [SVProgressHUD showInfoWithStatus:@"Purchase successed."];
                        //这里记录下成功
                        NeighborsSimpleCuteUserModel *userModel = [NeighborsSimpleCuteUserModel getUserInfo];
                        userModel.userInfo.memberLevel = 1;
                        [NeighborsSimpleCuteUserModel save:userModel];
                    }
                }
            }else{
                NSData *data = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                [[IAPShare sharedHelper].iap checkReceipt:data AndSharedSecret:UpgradeSecret onCompletion:^(NSString *response, NSError *error) {
                    NSDictionary *dics = [response getCxshareldstaretlToDictionary];
                    if ([dics[@"status"] intValue] == 21007) {
                        [IAPShare sharedHelper].iap.production = YES;
                        [[IAPShare sharedHelper].iap checkReceipt:data AndSharedSecret:UpgradeSecret onCompletion:^(NSString *response, NSError *error) {
                            if (error) {
                                [SVProgressHUD dismiss];
                                [SVProgressHUD showInfoWithStatus:@"Purchase failed."];
                            }else{
                                [SVProgressHUD dismiss];
                                [SVProgressHUD showInfoWithStatus:@"Purchase successed."];
                                [self actionAddRecordWithResposeoneData:response];
                            }
                        }];
                    }else{
                        if (error) {
                            [SVProgressHUD dismiss];
                            [SVProgressHUD showInfoWithStatus:@"Purchase failed."];
                        }else{
                            [SVProgressHUD dismiss];
                            [SVProgressHUD showInfoWithStatus:@"Purchase successed."];
                            [self actionAddRecordWithResposeoneData:response];
                        }
                    }
                }];
            }
        }else if(transcation.transactionState == SKPaymentTransactionStateFailed){
            NSLog(@"SKPaymentTransactionStateFailed");
            [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:@"Purchase Cancel"];
        }else if(transcation.transactionState == SKPaymentTransactionStateRestored){
            NSLog(@"SKPaymentTransactionStateRestored");
            [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:@"Purchase Restored"];
        }else if(transcation.transactionState == SKPaymentTransactionStateDeferred){
            NSLog(@"SKPaymentTransactionStateDeferred");
            [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:@"Purchase Deferred"];
        }else{
            [SVProgressHUD dismiss];
        }
    }];
}
/// 添加记录功能
/// @param response 返回内容
-(void)actionAddRecordWithResposeoneData:(NSString *)response
{   //记录状态
    NeighborsSimpleCuteUserModel *userModel = [NeighborsSimpleCuteUserModel getUserInfo];
    userModel.userInfo.memberLevel = 1;
    [NeighborsSimpleCuteUserModel save:userModel];
    //添加记录功能
    ZFMemberUpgradeIAPModel *upgrdateModel = [[ZFMemberUpgradeIAPModel alloc]init];
    upgrdateModel.reRequestInt = 5;
    NSDictionary *dic = [NSArray arrayWithArray:[response getCxshareldstaretlToDictionary][@"pending_renewal_info"]].lastObject;
    upgrdateModel.orderNum = [NSString stringWithFormat:@"GPA.IOS.(%ld)(%@)",(long)userModel.userInfo.userId,dic[@"original_transaction_id"]];
    upgrdateModel.goodsId = dic[@"product_id"];
    [NeighborsSimpleCuteUserModel setLocaOrderInfo:[upgrdateModel mj_JSONObject]];
    [self actionRequestAddUpgredateOrderRecord];
}
/// 调用接口给服务器返回数据
-(void)actionRequestAddUpgredateOrderRecord
{
    ZFMemberUpgradeIAPModel *model = [ZFMemberUpgradeIAPModel mj_objectWithKeyValues:[NeighborsSimpleCuteUserModel locaOrderInfo]];
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:[model mj_JSONObject]];
    [para setObject:@"1" forKey:@"payStatus"];
    [para setObject:@"IOS" forKey:@"tempStr10th"];
    NSLog(@"param:%@",para);
    NSString *url = [NSString stringWithFormat:@"%@%@",NSC_Base_Url,@"api/user/addOrderRecord"];
    [[NeighborsSimpleCuteNetworkTool sharedNetworkTool]POST:url parameters:para success:^(NeighborsSimpleCuteResposeModel *response) {
        [SVProgressHUD dismiss];
        if (response.code == 0) {
            ZFMemberUpgradeIAPModel *model = [ZFMemberUpgradeIAPModel mj_objectWithKeyValues:[NeighborsSimpleCuteUserModel locaOrderInfo]];
            model.reRequestInt -= 1;
            [NeighborsSimpleCuteUserModel setLocaOrderInfo:[model mj_JSONObject]];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.domain];
            return;
    }];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    self.isSelect = YES;
    self.upgradeSelectRow = (int)indexPath.row;
    self.upgrdateCurrentProductID = self.identityListArr[indexPath.row];
    [self.productCollectionView reloadData];
}
#pragma mark - KJBannerViewDelegate
//点击图片的代理
- (void)kj_BannerView:(KJBannerView *)banner SelectIndex:(NSInteger)index
{
    NSLog(@"index = %ld",(long)index);
}
- (NSString *)formatter:(SKProduct *)obj number:(NSDecimalNumber *)number{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:obj.priceLocale];
    NSString *formattedPrice = [numberFormatter stringFromNumber:number];
    return formattedPrice;
}

@end


@interface CusLabel ()

@end

@implementation CusLabel

- (void)drawRect:(CGRect)rect
{
    CGSize textSize = [self.text sizeWithAttributes:@{NSFontAttributeName : self.font}];
    CGRect textRect = (CGRect){0, 0, textSize};
    
    // 画文字(不做显示用, 主要作用是设置 layer 的 mask)
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.textColor set];
    
//    CGRect textRect;
    
    if (self.textAlignment == NSTextAlignmentLeft) {
        textRect = CGRectMake(rect.origin.x, rect.origin.y + (rect.size.height - textSize.height)/2.0, textSize.width, textSize.height);
    }
    else if (self.textAlignment == NSTextAlignmentCenter) {
        textRect = CGRectMake(rect.origin.x + (rect.size.width - textSize.width)/2.0, rect.origin.y + (rect.size.height - textSize.height)/2.0, textSize.width, textSize.height);
    }
    else {
        textRect = CGRectMake(rect.origin.x + (rect.size.width - textSize.width), rect.origin.y + (rect.size.height - textSize.height)/2.0, textSize.width, textSize.height);
    }
    
    [self.text drawWithRect:textRect options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:NULL];
    
    // 坐标(只对设置后的画到 context 起作用, 之前画的文字不起作用)
    CGContextTranslateCTM(context, 0.0f, rect.size.height - (rect.size.height - textSize.height) * 0.5);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    
    CGImageRef alphaMask = CGBitmapContextCreateImage(context);
    CGContextClearRect(context, rect); // 清除之前画的文字
    
    // 设置mask
    CGContextClipToMask(context, rect, alphaMask);
    
    // 画渐变色
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    self.colors = @[(id)(id)RGB(250, 204, 72).CGColor,(id)RGB(235, 142, 63).CGColor];
    //self.colors = @[(id)RGB(250, 166, 94).CGColor,(id)RGB(247, 189, 21).CGColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)self.colors, NULL);
    CGPoint startPoint = CGPointMake(textRect.origin.x + textRect.size.width/2.0,
                                     textRect.origin.y + textRect.size.height);
    CGPoint endPoint = CGPointMake(textRect.origin.x + textRect.size.width/2.0,
                                   textRect.origin.y);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    // 释放内存
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    CFRelease(alphaMask);
}
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    // 获取文字mask
//    [self.text drawInRect:self.bounds withAttributes:@{NSFontAttributeName : self.font}];
//    CGImageRef textMask = CGBitmapContextCreateImage(context);
//
//    // 清空画布
//    CGContextClearRect(context, rect);
//
//    // 设置蒙层
//    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);
//    CGContextClipToMask(context, rect, textMask);
//
//    // 绘制渐变
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGFloat locations[] = {0,1};
//    CGFloat colors[] = {
//        247.0/255.0,189.0/255.0,21.0/255.0,1.0,
//        250.0/255.0,166.0/255.0,94.0/255.0,1.0
//        };
//    CGGradientRef gradient=CGGradientCreateWithColorComponents(colorSpace, colors, locations, 2);
//    CGPoint start = CGPointMake(0,0);
//    CGPoint end = CGPointMake(self.bounds.size.height/2,0);
//    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation);
//
//    // 释放
//    CGColorSpaceRelease(colorSpace);
//    CGGradientRelease(gradient);
//    CGImageRelease(textMask);
//}

@end

@interface XSDKResourceUtil ()

@end

@implementation XSDKResourceUtil

+(float)measureMutilineStringHeight:(NSString*)str andFont:(UIFont*)wordFont andWidthSetup:(float)width{

    if (str == nil || width <= 0) return 0;

    CGSize measureSize;

    if([[UIDevice currentDevice].systemVersion floatValue] < 7.0){

        measureSize = [str sizeWithFont:wordFont constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];

    }else{

        measureSize = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:wordFont, NSFontAttributeName, nil] context:nil].size;

    }

    return ceil(measureSize.height);

}

// 传一个字符串和字体大小来返回一个字符串所占的宽度

+(float)measureSinglelineStringWidth:(NSString*)str andFont:(UIFont*)wordFont{

    if (str == nil) return 0;

    CGSize measureSize;

    if([[UIDevice currentDevice].systemVersion floatValue] < 7.0){

        measureSize = [str sizeWithFont:wordFont constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];

    }else{

        measureSize = [str boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:wordFont, NSFontAttributeName, nil] context:nil].size;

    }

    return ceil(measureSize.width);

}

+(CGSize)measureSinglelineStringSize:(NSString*)str andFont:(UIFont*)wordFont

{

    if (str == nil) return CGSizeZero;

    CGSize measureSize;

    if([[UIDevice currentDevice].systemVersion floatValue] < 7.0){

        measureSize = [str sizeWithFont:wordFont constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];

    }else{

        measureSize = [str boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:wordFont, NSFontAttributeName, nil] context:nil].size;

    }

    return measureSize;

}

 

//+(UIImage*)imageAt:(NSString*)imgNamePath{

//    if (imgNamePath == nil || [[imgNamePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0) {

//        return nil;

//    }

//    return [UIImage imageNamed:[ImageResourceBundleName stringByAppendingPathComponent:imgNamePath]];

//}

 

+(BOOL)xsdkcheckName:(NSString*)name{

    if([XSDKResourceUtil xsdkstringIsnilOrEmpty:name]){

        return NO;

    }else{

        if(name.length < 5){

            return NO;

        }

        

        if(name.length > 20){

            return NO;

        }

        

        NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[a-zA-Z][a-zA-Z0-9_]*$"];

        if(![pred evaluateWithObject:name]){

            return [XSDKResourceUtil xsdkcheckPhone:name];

        }

    }

    return YES;

}

 

+(BOOL)xsdkcheckPhone:(NSString *)userphone

{

    NSPredicate * phone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1\\d{10}"];

    if (![phone evaluateWithObject:userphone]) {

        return NO;

    }

    return YES;

}
+(BOOL)xsdkstringIsnilOrEmpty:(NSString*)string{
    if (string == nil || [string isKindOfClass:[NSNull class]]  || [string isEqualToString:@""]) {
        return YES;
    }else{
        return NO;
    }
}
+(UIColor *)xsdkcolorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{   //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)

    {

        return [UIColor clearColor];

    }

    // strip 0X if it appears

    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾

    if ([cString hasPrefix:@"0X"])

    {

        cString = [cString substringFromIndex:2];

    }

    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾

    if ([cString hasPrefix:@"#"])

    {

        cString = [cString substringFromIndex:1];

    }

    if ([cString length] != 6)

    {

        return [UIColor clearColor];

    }

    

    // Separate into r, g, b substrings

    NSRange range;

    range.location = 0;

    range.length = 2;

    //r

    NSString *rString = [cString substringWithRange:range];

    //g

    range.location = 2;

    NSString *gString = [cString substringWithRange:range];

    //b

    range.location = 4;

    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

+(BOOL)jsonFieldIsNull:(id)jsonField{
    return (jsonField == nil || [jsonField isKindOfClass:[NSNull class]]);
}

+(int)filterIntValue:(id)value withDefaultValue:(int)defaultValue{
    if (![XSDKResourceUtil jsonFieldIsNull:value]) {
        return [value intValue];
    }else{
        return defaultValue;
    }
}

+(NSString*)filterStringValue:(id)value withDefaultValue:(NSString*)defaultValue
{
    if ([value isKindOfClass:[NSString class]] && ![XSDKResourceUtil xsdkstringIsnilOrEmpty:value]) {
        return value;
    }else{
        return defaultValue;
    }
}
@end


