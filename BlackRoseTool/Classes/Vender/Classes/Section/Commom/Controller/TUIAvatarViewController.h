#import <UIKit/UIKit.h>
#import "TCommonAvatarCell.h"
#import "TUIProfileCardCell.h"
#import "TTextEditController.h"
#import <AVFoundation/AVFoundation.h>

/**
 *  头像大图的显示界面
 *  本类的整体逻辑与图片消息的大图显示界面类似。
 */
@interface TUIAvatarViewController : UIViewController

@property (nonatomic, strong) TUIProfileCardCellData *avatarData;

@end

@interface NeighborsSimpleCuteBaseController: UIViewController

-(float)NeighborsSimpleCuteProjectGetLabelHeightWithText:(NSString *)text width:(float)width font: (float)font;

- (void)NeighborsSimpleCuteSetLeftButton:(UIImage *)leftImg;

- (void)NeighborsSimpleCuteSetRightButton:(UIImage *)rightImg;

- (void)onNeighborsSimpleCuteLeftBackBtn:(UIButton *)btn;

- (void)onNeighborsSimpleCuteRightBackBtn:(UIButton *)btn;

@end
typedef enum{
    WKWebLoadTypeNotSpecifiy = 0,
    WKWebLoadTypeWebURLString,
    WKWebLoadTypeAuthorizationWebURLString,
    WKWebLoadTypeWebHTMLString,
    WKWebLoadTypeHTMLString,
    WKWebLoadTypePOSTWebURLString,
}WKWebLoadType;
@interface NeighborsSimpleCuteBaseWebController :NeighborsSimpleCuteBaseController
@property (nonatomic,assign)BOOL isShowHidden;
@property (nonatomic,copy)NSString *webTitle;
@property (nonatomic,assign)WKWebLoadType loadType;
@property (nonatomic,copy)NSString *URLString;
@property (copy, nonatomic) void(^webViewCalculateHeightBlock)(CGFloat height);
@property (copy, nonatomic) void(^webViewContentSizeDidChangeBlock)(CGSize size);
@end

@interface NeighborsSimpleCuteLaunchMainController : UIViewController

@end


@interface NeighborsSimpleCuteRootMainController : NeighborsSimpleCuteBaseController

@end

@interface NeighborsSimpleCuteUserLoginController : NeighborsSimpleCuteBaseController

@end

@interface NeighborsSimpleCuteUserRegsterController : NeighborsSimpleCuteBaseController

@end

@interface NeighborsSimpleCuteUserForgePwdController : NeighborsSimpleCuteBaseController

@end

@interface NeighborsSimpleCuteUserWelcomeController : NeighborsSimpleCuteBaseController
@property (nonatomic,copy)NSString *updateToken;
@property (nonatomic,copy)NSString *emailStr;
@property (nonatomic,copy)NSString *pwdStr;
@end

@interface NeighborsSimpleCuteHomeRootController : NeighborsSimpleCuteBaseController

@end

@interface NeighborsSimpleCuteHomeVoiceController : NeighborsSimpleCuteBaseController

@end


@interface NeighborsSimpleCuteHomeMainController : NeighborsSimpleCuteBaseController

@end

@interface NeighborsSimpleCuteVoiceListController : NeighborsSimpleCuteBaseController

@end

@interface NeighborsSimpleCuteReportController : NeighborsSimpleCuteBaseController
@property (nonatomic,copy)void(^NeighborsSimpleCuteReportControllerReportBlock)(void);

@end

@interface NeighborsSimpleCuteSendMessageController : NeighborsSimpleCuteBaseController
@property (nonatomic,copy)void(^NeighborsSimpleCuteReportControllerMessageBlock)(void);

@end

@interface NeighborsSimpleCuteVoiceContentViewCell : UICollectionViewCell

@property (nonatomic,strong)UIView *bgView;

@property (nonatomic,strong)UIImageView *bgImg;

@property (nonatomic,strong)UIView *showView;

@property (nonatomic,strong)UIImageView *showImg;

@end


@interface NeighborsSimpleCuteExploreContentViewCell : UICollectionViewCell

@property (nonatomic,strong)UIView *bgView;

@property (nonatomic,strong)UIButton *callBtn;

@property (nonatomic,strong)UIImageView *bgImg;

@property (nonatomic,strong)UIView *showView;

@property (nonatomic,strong)UIImageView *showImg;

@property (nonatomic,copy)void(^NeighborsSimpleCuteExploreContentViewCellCallBlock)(void);

@end

@interface NeighborsSimpleCuteVoiceShowView : UIView

@end


@interface NeighborsSimpleCuteHomeVoiceUserInfoModel : NSObject
@property (nonatomic , assign) NSInteger              userId;
@property (nonatomic , copy) NSString              * socialNum;
@property (nonatomic , copy) NSString              * nickName;
@property (nonatomic , assign) NSInteger              gender;
@property (nonatomic , assign) NSInteger              age;
@property (nonatomic , copy) NSString              * imgUrl;
@property (nonatomic , assign) NSInteger              memberLevel;
@property (nonatomic , copy) NSString              * country;
@property (nonatomic , copy) NSString              * province;
@property (nonatomic , copy) NSString              * city;
@property (nonatomic , copy) NSString              * area;
@property (nonatomic , assign) NSInteger              maritalStaus;
@property (nonatomic , assign) NSInteger              integral;
@property (nonatomic , assign) NSInteger              countryId;
@property (nonatomic , assign) NSInteger              provinceId;
@property (nonatomic , assign) NSInteger              cityId;
@property (nonatomic , assign) NSInteger              loginTime;
@property (nonatomic , assign) NSInteger              imgStatus;
@property (nonatomic , assign) NSInteger              appType;
@property (nonatomic , copy) NSString              * spareStr1st;
@property (nonatomic , copy) NSString              * spareStr7th;
@property (nonatomic , copy) NSString              * spareStr14th;
@property (nonatomic , copy) NSString              * spareStr18th;
@property (nonatomic , copy) NSString              * spareStr19th;
@property (nonatomic , assign) NSInteger              spareNum1st;
@property (nonatomic , assign) NSInteger              spareNum2nd;
@property (nonatomic , assign) NSInteger              spareNum3rd;
@property (nonatomic , assign) NSInteger              spareNum4th;
@property (nonatomic , assign) NSInteger              spareNum5th;
@property (nonatomic , assign) NSInteger              spareNum6th;
@property (nonatomic , assign) NSInteger              spareNum7th;
@property (nonatomic , assign) NSInteger              spareNum8th;
@property (nonatomic , assign) NSInteger              spareNum9th;
@property (nonatomic , assign) NSInteger              spareNum10th;
@property (nonatomic , assign) NSInteger              isSugar;
@property (nonatomic , copy) NSString              * tempStr5th;
@property (nonatomic , copy) NSString              * tempStr6th;
@property (nonatomic , copy) NSString              * tempStr7th;
@property (nonatomic , copy) NSString              * tempStr14th;
@property (nonatomic , copy) NSString              * tempStr20th;
@property (nonatomic , copy) NSString              * tempStr30th;
@property (nonatomic , assign) NSInteger              isDel;
@property (nonatomic , assign) NSInteger              isHidden;
@property (nonatomic , assign) NSInteger              imImgStatus;
@end

@interface NeighborsSimpleCuteExploreListBottleModel :NSObject
@property (nonatomic , assign) NSInteger              id;
@property (nonatomic , assign) NSInteger              userId;
@property (nonatomic , copy) NSString              * imgUrl;
@property (nonatomic , copy) NSString              * videoUrl;
@property (nonatomic , copy) NSString              * audioUrl;
@property (nonatomic , assign) NSInteger              racyStatus;
@property (nonatomic , assign) NSInteger              decentStatus;
@property (nonatomic , assign) NSInteger              recommendStatus;
@property (nonatomic , assign) NSInteger              appType;
@property (nonatomic , assign) NSInteger              reviewStatus;
@property (nonatomic , assign) NSInteger              upvoteNum;
@property (nonatomic , assign) NSInteger              commentNum;
@property (nonatomic , assign) NSInteger              upvoteNewNum;
@property (nonatomic , assign) NSInteger              commentNewNum;
@property (nonatomic , assign) NSInteger              createTime;
@property (nonatomic , copy) NSString              * content;
@end

@interface NeighborsSimpleCuteExploreListUserModel : NSObject
@property (nonatomic , assign) NSInteger              userId;
@property (nonatomic , copy) NSString              * socialNum;
@property (nonatomic , copy) NSString              * nickName;
@property (nonatomic , assign) NSInteger              gender;
@property (nonatomic , assign) NSInteger              age;
@property (nonatomic , copy) NSString              * imgUrl;
@property (nonatomic , assign) NSInteger              memberLevel;
@property (nonatomic , copy) NSString              * country;
@property (nonatomic , copy) NSString              * province;
@property (nonatomic , copy) NSString              * city;
@property (nonatomic , copy) NSString              * area;
@property (nonatomic , assign) NSInteger              maritalStaus;
@property (nonatomic , assign) NSInteger              integral;
@property (nonatomic , assign) NSInteger              countryId;
@property (nonatomic , assign) NSInteger              provinceId;
@property (nonatomic , assign) NSInteger              cityId;
@property (nonatomic , assign) NSInteger              loginTime;
@property (nonatomic , assign) NSInteger              imgStatus;
@property (nonatomic , assign) NSInteger              appType;
@property (nonatomic , copy) NSString              * spareStr1st;
@property (nonatomic , copy) NSString              * spareStr7th;
@property (nonatomic , copy) NSString              * spareStr14th;
@property (nonatomic , copy) NSString              * spareStr18th;
@property (nonatomic , copy) NSString              * spareStr19th;
@property (nonatomic , assign) NSInteger              spareNum1st;
@property (nonatomic , assign) NSInteger              spareNum2nd;
@property (nonatomic , assign) NSInteger              spareNum3rd;
@property (nonatomic , assign) NSInteger              spareNum4th;
@property (nonatomic , assign) NSInteger              spareNum5th;
@property (nonatomic , assign) NSInteger              spareNum6th;
@property (nonatomic , assign) NSInteger              spareNum7th;
@property (nonatomic , assign) NSInteger              spareNum8th;
@property (nonatomic , assign) NSInteger              spareNum9th;
@property (nonatomic , assign) NSInteger              spareNum10th;
@property (nonatomic , assign) NSInteger              isSugar;
@property (nonatomic , copy) NSString              * tempStr5th;
@property (nonatomic , copy) NSString              * tempStr6th;
@property (nonatomic , copy) NSString              * tempStr7th;
@property (nonatomic , copy) NSString              * tempStr14th;
@property (nonatomic , copy) NSString              * tempStr20th;
@property (nonatomic , copy) NSString              * tempStr30th;
@property (nonatomic , assign) NSInteger              isDel;
@property (nonatomic , assign) NSInteger              isHidden;
@property (nonatomic , assign) NSInteger              imImgStatus;
@end


@interface NeighborsSimpleCuteExploreListModel : NSObject

@property (nonatomic , assign) NSInteger              id;
@property (nonatomic , assign) NSInteger              bottleId;
@property (nonatomic , assign) NSInteger              userId;
@property (nonatomic , assign) NSInteger              upvoteStatus;
@property (nonatomic , assign) NSInteger              newFlag;
@property (nonatomic , assign) NSInteger              openTime;
@property (nonatomic , strong) NeighborsSimpleCuteExploreListBottleModel            * bottle;
@property (nonatomic , strong) NeighborsSimpleCuteExploreListUserModel              * userInfo;

@end



@interface NeighborsSimpleCuteHomeVoiceModel : NSObject

@property (nonatomic , assign) NSInteger              id;
@property (nonatomic , assign) NSInteger              userId;
@property (nonatomic , copy) NSString              * imgUrl;
@property (nonatomic , copy) NSString              * videoUrl;
@property (nonatomic , copy) NSString              * audioUrl;
@property (nonatomic , assign) NSInteger              racyStatus;
@property (nonatomic , assign) NSInteger              decentStatus;
@property (nonatomic , assign) NSInteger              recommendStatus;
@property (nonatomic , assign) NSInteger              appType;
@property (nonatomic , assign) NSInteger              reviewStatus;
@property (nonatomic , assign) NSInteger              upvoteNum;
@property (nonatomic , assign) NSInteger              createTime;
@property (nonatomic , assign) NSInteger              delFlag;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , strong) NeighborsSimpleCuteHomeVoiceUserInfoModel            * userInfo;



//@property (nonatomic,assign)int index;
//
//@property (nonatomic,copy)NSString *nameStr;
//
//@property (nonatomic,copy)NSString *avtorStr;
//
//@property (nonatomic,copy)NSString *urlStr;

@end

@interface NeighborsSimpleCuteVoicePlayView : UIView
@property (nonatomic,strong)NeighborsSimpleCuteExploreListModel *exporeModel;
@property (nonatomic,strong) NeighborsSimpleCuteHomeVoiceModel *voiceModel;
@property (nonatomic,copy)void(^NeighborsSimpleCuteVoicePlayViewCallBlock)(void);
@property (nonatomic,copy)void(^NeighborsSimpleCuteVoicePlayViewChatBlock)(void);
@property (nonatomic,copy)void(^NeighborsSimpleCuteVoicePlayViewReportBlock)(void);
@property (nonatomic,copy)void(^NeighborsSimpleCuteVoicePlayViewDelBlock)(void);
@property (nonatomic,copy)void(^NeighborsSimpleCuteVoicePlayViewCloseBlock)(void);
@end

@interface NeighborsSimpleCuteVideoCallView :UIView
@property (nonatomic,strong) NeighborsSimpleCuteHomeVoiceModel *voiceModel;
@end

//@interface NeighborsSimpleCuteSubPlayVideoView :UIView
//@property (nonatomic,copy)void(^NeighborsSimpleCuteVoicePlayViewReportBlock)(void);
//@property (nonatomic,copy)void(^NeighborsSimpleCuteVoicePlayViewDelBlock)(void);
//@property (nonatomic,copy)void(^NeighborsSimpleCuteVoicePlayViewBlockBlock)(void);
//@end

//聊天界面的model
@interface SocializeIntercourseMessageModel : NSObject
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,copy)NSString *storeNameStr;
@property (nonatomic,copy)NSString *sendIconStr;
@property (nonatomic,copy)NSString *sendTimeStr;
@property (nonatomic,copy)NSString *sendType; // 0 代表文字 1代表图片
@property (nonatomic,copy)NSString *sendContentStr;
@property (nonatomic,copy)NSData *sendPicture;
@end


//聊天界面的model
@interface SocializeIntercourseMessageOtherModel :NSObject
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,copy)NSString *storeNameStr;
@property (nonatomic,copy)NSString *storeIconStr;
@property (nonatomic,copy)NSString *storeTimeStr;
@property (nonatomic,copy)NSString *storeLastStr;
@end


// 本地数据库的内容
@interface NeighborsSimpleCuteDBTool : NSObject

+ (instancetype)NeighborsSimpleCuteProjectSharaDBTool;
- (void)NeighborsSimpleCuteProjectCreateDataBase;

-(void)insertNeighborsSimpleCuteProjectPlanModel:(NeighborsSimpleCuteHomeVoiceModel *)voicemodel;
- (NSMutableArray *)queryAllNeighborsSimpleCuteProjectVoice;
-(void)deleteNeighborsSimpleCuteProjectVoiceModel:(NeighborsSimpleCuteHomeVoiceModel *)voicemodel;
//聊天界面需要的
-(void)insertMessageModel:(SocializeIntercourseMessageModel *)messageModel;
-(void)deleteMessageModel:(SocializeIntercourseMessageModel *)messageModel;
- (NSMutableArray *)queryAllMessageModel;

-(void)insertMessageStoreModel:(SocializeIntercourseMessageOtherModel *)messageStoreModel;
-(void)updateMessageStoreModel:(SocializeIntercourseMessageOtherModel *)messageStoreModel;
-(void)deleteMessageStoreModel:(SocializeIntercourseMessageOtherModel *)messageStoreModel;
-(BOOL)isExistMessageStoreModel:(NSString *)storeNameStr;
- (NSMutableArray *)queryAllMessageStoreModel;


@end

@interface LZPlayerManager : NSObject

/*存放歌曲数组*/
@property (nonatomic, strong) NSMutableArray *musicArray;
/*播放下标*/
@property (nonatomic, assign) NSInteger index;
/*是不是正在播放*/
@property (nonatomic, assign) BOOL isPlay;
/*播放器*/
@property (nonatomic, strong) AVPlayer *player;
/*标记是不是没点列表直接点了播放按钮如果是就默认播放按钮*/
@property (nonatomic, assign) BOOL isFristPlayerPauseBtn;
/*开始播放*/
@property (nonatomic,copy)void(^isStartPlayer)(NSInteger index);//0是开始 1 暂停
/*播放工具单利*/
+(instancetype)lzPlayerManager;
/*播放和暂停*/
- (void)playAndPause;
/*前一首*/
- (void)playPrevious;
/*后一首*/
- (void)playNext;
/*当前播放项*/
- (void)replaceItemWithUrlString:(NSString *)urlString;
/*声音*/
- (void)playerVolumeWithVolumeFloat:(CGFloat)volumeFloat;
/*进度条*/
- (void)playerProgressWithProgressFloat:(CGFloat)progressFloat;

@end

@interface NeighborsSimpleCuteResposeModel : NSObject

@property(nonatomic, assign)NSInteger code;
@property(nonatomic, copy)NSString *msg;
@property(nonatomic, strong)id data;
@property(nonatomic, copy)NSString *token;

@end

@interface NeighborsSimpleCuteNetworkTool : NSObject

+ (instancetype)sharedNetworkTool;
-(void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError * error))failure;
-(void)GET2:(NSString *)URLString parameters:(id)parameters success:(void (^)(NeighborsSimpleCuteResposeModel *response))success failure:(void (^)(NSError * error))failure;
-(void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NeighborsSimpleCuteResposeModel *response))success failure:(void (^)(NSError * error))failure;
-(void)POST2:(NSString *)URLString parameters:(id)parameters success:(void (^)(NeighborsSimpleCuteResposeModel *response))success failure:(void (^)(NSError * error))failure;

@end


@interface NeighborsSimpleClinentInfo : NSObject
@property (nonatomic , assign) NSInteger              id;
@property (nonatomic , copy) NSString              * clientNum;
@property (nonatomic , copy) NSString              * description;
@property (nonatomic , assign) NSInteger              auditingState;
@property (nonatomic , assign) NSInteger              updateFlag;
@property (nonatomic , copy) NSString              * updateUrl;
@property (nonatomic , copy) NSString              * updateDescription;
@property (nonatomic , assign) NSInteger              delFlag;
@property (nonatomic , copy) NSString              * spare1st;
@property (nonatomic , copy) NSString              * spare2nd;
@property (nonatomic , copy) NSString              * spare3rd;
@property (nonatomic , copy) NSString              * spare4th;
@property (nonatomic , copy) NSString              * spare5th;
@property (nonatomic , copy) NSString              * spare6th;
@property (nonatomic , copy) NSString              * spare7th;
@property (nonatomic , copy) NSString              * spare8th;
@property (nonatomic , copy) NSString              * spare9th;
@property (nonatomic , copy) NSString              * spare10th;
@property (nonatomic , copy) NSString              * spare11th;
@property (nonatomic , copy) NSString              * spare12th;
@property (nonatomic , copy) NSString              * spare13th;
@property (nonatomic , copy) NSString              * spare14th;
@property (nonatomic , copy) NSString              * spare15th;
@property (nonatomic , copy) NSString              * spare16th;
@property (nonatomic , copy) NSString              * spare17th;
@property (nonatomic , copy) NSString              * spare18th;
@property (nonatomic , copy) NSString              * spare19th;
@property (nonatomic , copy) NSString              * spare20th;
@property (nonatomic , assign) NSInteger              generalStatus;
@property (nonatomic , copy) NSString              * generalMaleMsg;
@property (nonatomic , assign) NSInteger              generalMaleSize;
@property (nonatomic , copy) NSString              * generalFemaleMsg;
@property (nonatomic , assign) NSInteger              generalFemaleSize;
@property (nonatomic , assign) NSInteger              maleStatus;
@property (nonatomic , copy) NSString              * maleMsg;
@property (nonatomic , assign) NSInteger              maleSize;
@property (nonatomic , assign) NSInteger              femaleStatus;
@property (nonatomic , copy) NSString              * femaleMsg;
@property (nonatomic , assign) NSInteger              femaleSize;
@property (nonatomic , copy) NSString              * stateSet;

+ (void)save:(NeighborsSimpleClinentInfo *)model;
+ (NeighborsSimpleClinentInfo *)getUserInfo2;

@end


@interface NeighborsSimpleTool : NSObject

///获取本地ip地址

+ (NSString*)getCurentLocalIP;

///是否开启了VPN的功能

+ (BOOL)isVPNOn;

@end

@interface MyPickerView : UIView

+ (void)showWithData:(NSArray *)arr flag:(NSInteger)flag tipText:(NSString *)tip block:(void(^)(NSArray *arr))block;

@end

@interface MyPickerSingleCell : UITableViewCell

@property (nonatomic,strong) NSString *text;

@property (nonatomic,assign) BOOL selectTag;

@end


@interface NeighborsSimpleCuteSettingMainController : NeighborsSimpleCuteBaseController

@end


@interface NeighborsSimpleCuteSettingOtherMainController : NeighborsSimpleCuteBaseController

@end


@interface NeighborsSimpleCuteBaseSettingMainController : NeighborsSimpleCuteBaseController

@end


@interface NeighborsSimpleCuteMessagePictureCell : UICollectionViewCell

@property (nonatomic,strong)UILabel *timeLab;

@property (nonatomic,strong)UIImageView *iconImage;

@property (nonatomic,strong)UIView *contentBgView;

@property (nonatomic,strong)UIImageView *pictureImage;

@end

@interface NeighborsSimpleCuteMessageContentCell : UICollectionViewCell

@property (nonatomic,strong)SocializeIntercourseMessageModel *model;

@property (nonatomic,strong)UILabel *timeLab;

@property (nonatomic,strong)UIImageView *iconImage;

@property (nonatomic,strong)UIView *contentBgView;

@property (nonatomic,strong)UILabel *contentLab;

@end

@interface NeighborsSimpleCuteMessageChatMainController : NeighborsSimpleCuteBaseController
@property (nonatomic,copy)NSString *NameStr;
@property (nonatomic,copy)NSString *IconStr;
@end

// 聊天界面的cell
@interface NeighborsSimpleCuteMessageListCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *iconImageView;

@property (nonatomic,strong)UILabel *titleLab;

@property (nonatomic,strong)UILabel *subTitleLab;

@end

@interface NeighborsSimpleCuteMessageMainController : NeighborsSimpleCuteBaseController

@end

@interface NeighborsSimpleCuteSettingContentViewCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *iconImg;

@property (nonatomic,strong)UILabel *titleLab;

@end

/// 新ui设计的功能
@interface NeighborsSimpleCuteSettingHeaderOtherViewCell : UICollectionViewCell

@property (nonatomic,strong)UIView *bgView;

@property (nonatomic,strong)UIImageView *iconImg;

@property (nonatomic,strong)UIButton *nameBtn;

@end

@interface CusLabel :UILabel

@property (nonatomic, strong) NSArray *colors;

@end


@interface NeighborsSimpleCuteSettingRechargeOtherViewCell : UICollectionViewCell

@property (nonatomic,strong)UIView *bgView;

@property (nonatomic,strong)UIButton *rechagerBtn;

@property (nonatomic,copy)void(^NeighborsSimpleCuteSettingRechargeViewCellRechageBlock)(void);

@end

@interface NeighborsSimpleCuteSettingContentOtherViewCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *iconImg;

@property (nonatomic,strong)UILabel *titleLab;

@end

//base Setting

@interface NeighborsSimpleCuteBaseSettingContentViewCell : UICollectionViewCell

@property (nonatomic,strong)UILabel *titleLab;

@end


@interface NeighborsSimpleCuteSettingHeaderViewCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *iconImg;

@property (nonatomic,strong)UILabel *iconLab;

@end

@interface NeighborsSimpleCuteSettingRechargeViewCell : UICollectionViewCell

@property (nonatomic,strong)UIButton *rechagerBtn;

@property (nonatomic,copy)void(^NeighborsSimpleCuteSettingRechargeViewCellRechageBlock)(void);

@end



@interface NeighborsSimpleCuteDelAccountView : UIView
@property (nonatomic,copy)void(^NeighborsSimpleCuteDelAccountViewBlock)(void);
@end


@interface NeighborsSimpleCuteReportView : UIView

@property(nonatomic,copy)void(^NeighborsSimpleCuteReportViewReportBlock)(void);

@property(nonatomic,copy)void(^NeighborsSimpleCuteReportViewBlockBlock)(void);

@property(nonatomic,copy)void(^NeighborsSimpleCuteReportViewCancelBlock)(void);

@end

@interface NeighborsSimpleCuteSignOutView : UIView

@property (nonatomic,copy)void(^NeighborsSimpleCuteSignOutViewShowBlock)(void);

@end

@interface NeighborsSimpleCuteDelAccountController : NeighborsSimpleCuteBaseController

@end

@interface NeighborsSimpleCuteChnageNameView : UIView
@property (nonatomic,copy)void(^NeighborsSimpleCuteChnageNameViewBlcok)(NSString *nameStr);
@end


@interface NeighborsSimpleCuteSettingProfileController : NeighborsSimpleCuteBaseController

@end

@interface NeighborsSimpleCuteSettingFeedBackController : NeighborsSimpleCuteBaseController

@property (nonatomic,copy)void(^NeighborsSimpleCuteSettingFeedBackControllerBackBlock)(void);

@end

@interface NeighborsSimpleCuteSettingAboutusController : NeighborsSimpleCuteBaseController

@end

@interface NeighborsSimpleCuteSettingBlockController : NeighborsSimpleCuteBaseController

@end



@interface NeighborsSimpleCuteAppClientModel : NSObject
@property (nonatomic , assign) NSInteger              id;
@property (nonatomic , copy) NSString              * clientNum;
@property (nonatomic , copy) NSString              * description;
@property (nonatomic , assign) NSInteger              auditingState;
@property (nonatomic , assign) NSInteger              updateFlag;
@property (nonatomic , copy) NSString              * updateUrl;
@property (nonatomic , copy) NSString              * updateDescription;
@property (nonatomic , assign) NSInteger              delFlag;
@property (nonatomic , copy) NSString              * spare1st;
@property (nonatomic , copy) NSString              * spare2nd;
@property (nonatomic , copy) NSString              * spare3rd;
@property (nonatomic , copy) NSString              * spare4th;
@property (nonatomic , copy) NSString              * spare5th;
@property (nonatomic , copy) NSString              * spare6th;
@property (nonatomic , copy) NSString              * spare7th;
@property (nonatomic , copy) NSString              * spare8th;
@property (nonatomic , copy) NSString              * spare9th;
@property (nonatomic , copy) NSString              * spare10th;
@property (nonatomic , copy) NSString              * spare11th;
@property (nonatomic , copy) NSString              * spare12th;
@property (nonatomic , copy) NSString              * spare13th;
@property (nonatomic , copy) NSString              * spare14th;
@property (nonatomic , copy) NSString              * spare15th;
@property (nonatomic , copy) NSString              * spare16th;
@property (nonatomic , copy) NSString              * spare17th;
@property (nonatomic , copy) NSString              * spare18th;
@property (nonatomic , copy) NSString              * spare19th;
@property (nonatomic , copy) NSString              * spare20th;
@property (nonatomic , assign) NSInteger              generalStatus;
@property (nonatomic , copy) NSString              * generalMaleMsg;
@property (nonatomic , assign) NSInteger              generalMaleSize;
@property (nonatomic , copy) NSString              * generalFemaleMsg;
@property (nonatomic , assign) NSInteger              generalFemaleSize;
@property (nonatomic , assign) NSInteger              maleStatus;
@property (nonatomic , copy) NSString              * maleMsg;
@property (nonatomic , assign) NSInteger              maleSize;
@property (nonatomic , assign) NSInteger              femaleStatus;
@property (nonatomic , copy) NSString              * femaleMsg;
@property (nonatomic , assign) NSInteger              femaleSize;
@property (nonatomic , copy) NSString              * stateSet;
@end


@interface NeighborsSimpleCuteTokenDtoModel : NSObject
@property (nonatomic , copy) NSString              * token;
@property (nonatomic , copy) NSString              * refreshToken;
@property (nonatomic , assign) NSInteger              expiresIn;
@end


@interface NeighborsSimpleCuteUserInfoModel : NSObject
@property (nonatomic , assign) NSInteger              userId;
@property (nonatomic , copy) NSString              * socialNum;
@property (nonatomic , copy) NSString              * nickName;
@property (nonatomic , assign) NSInteger              gender;
@property (nonatomic , assign) NSInteger              age;
@property (nonatomic , copy)  NSString             * imgUrl;
@property (nonatomic , assign) NSInteger              memberLevel;
@property (nonatomic , copy) NSString              * area;
@property (nonatomic , assign) NSInteger              maritalStaus;
@property (nonatomic , assign) NSInteger              integral;
@property (nonatomic , assign) NSInteger              countryId;
@property (nonatomic , assign) NSInteger              loginTime;
@property (nonatomic , assign) NSInteger              imgStatus;
@property (nonatomic , assign) NSInteger              appType;
@property (nonatomic , copy) NSString              * spareStr1st;
@property (nonatomic , copy) NSString              * spareStr7th;
@property (nonatomic , copy) NSString              * spareStr14th;
@property (nonatomic , copy) NSString              * spareStr18th;
@property (nonatomic , copy) NSString              * spareStr19th;
@property (nonatomic , assign) NSInteger              spareNum1st;
@property (nonatomic , assign) NSInteger              spareNum2nd;
@property (nonatomic , assign) NSInteger              spareNum3rd;
@property (nonatomic , assign) NSInteger              spareNum4th;
@property (nonatomic , assign) NSInteger              spareNum5th;
@property (nonatomic , assign) NSInteger              spareNum6th;
@property (nonatomic , assign) NSInteger              spareNum7th;
@property (nonatomic , assign) NSInteger              spareNum8th;
@property (nonatomic , assign) NSInteger              spareNum9th;
@property (nonatomic , assign) NSInteger              spareNum10th;
@property (nonatomic , assign) NSInteger              isSugar;
@property (nonatomic , copy) NSString              * tempStr18th;
@property (nonatomic , copy) NSString              * tempStr20th;
@property (nonatomic , copy) NSString              * tempStr30th;
@property (nonatomic , assign) NSInteger              isDel;
@property (nonatomic , assign) NSInteger              isHidden;
@property (nonatomic , assign) NSInteger              imImgStatus;
@property (nonatomic , assign) NSInteger              isIpCheck;

//new add
@property (nonatomic , copy) NSString              * tempStr7th;
@property (nonatomic , copy) NSString              * province;
@property (nonatomic , copy) NSString              * country;
@property (nonatomic , strong) NSString              * city;

@property (nonatomic , strong) NSString              * spareStr2nd;
@property (nonatomic , strong) NSString              * spareStr3rd;
@property (nonatomic , strong) NSString              * spareStr4th;
@property (nonatomic , strong) NSString              * spareStr5th;
@property (nonatomic , strong) NSString              * spareStr8th;
@property (nonatomic , strong) NSString              * spareStr9th;
@property (nonatomic , strong) NSString              * spareStr11th;
@property (nonatomic , strong) NSString              * spareStr15th;
@property (nonatomic , strong) NSString              * spareStr6th;
@property (nonatomic , strong) NSString              * spareStr10th;
@property (nonatomic , strong) NSString              * spareStr12th;
@property (nonatomic , strong) NSString              * tempStr2nd;
@property (nonatomic , strong) NSString              * tempStr1st;
@property (nonatomic , strong) NSString              * tempStr8th;
@property (nonatomic , strong) NSString              * tempStr9th;
@property (nonatomic , strong) NSString              * introduce;


@end

@interface NeighborsSimpleCuteAccountModel : NSObject
@property (nonatomic , assign) NSInteger              userId;
@property (nonatomic , copy) NSString              * password;
@property (nonatomic , assign) NSInteger              createTime;
@property (nonatomic , assign) NSInteger              restrictLogin;
@property (nonatomic , assign) NSInteger              loginTime;
@property (nonatomic , assign) NSInteger              gmFlag;
@property (nonatomic , copy) NSString              * socialNum;
@property (nonatomic , copy) NSString              * clientNum;
@property (nonatomic , assign) NSInteger              appType;
@property (nonatomic , copy) NSString              * email;
@property (nonatomic , assign) NSInteger              flshTime;
@end

@interface NeighborsSimpleCuteUserModel : NSObject

@property (nonatomic , strong) NeighborsSimpleCuteAccountModel              * account;
@property (nonatomic , strong) NeighborsSimpleCuteUserInfoModel             * userInfo;
@property (nonatomic , strong) NeighborsSimpleCuteTokenDtoModel             * tokenDto;
@property (nonatomic , strong) NeighborsSimpleCuteAppClientModel            * appClient;
@property (nonatomic , strong) NSArray <NSString *>              * photos;

+ (void)setMemberLevel:(NSInteger)memberLevel;
+ (NSInteger)memberLevel;
+ (NSDictionary *)locaOrderInfo;
+ (void)setLocaOrderInfo:(NSDictionary *)locaOrderInfo;
+ (void)save:(NeighborsSimpleCuteUserModel *)model;
+ (NeighborsSimpleCuteUserModel *)getUserInfo;
+(void)removeUpgradatelocaOrderInfo;
+ (BOOL)isOnline;
+ (void)logout;

@end

#pragma mark -- 付费系统

@interface KJBananerModel : NSObject

@property (nonatomic,copy)NSString *iconImg;

@property (nonatomic,copy)NSString *titleStr;

@property (nonatomic,copy)NSString *subTitleStr;

@end


@interface ZFMemberUpgradeIAPModel : NSObject

@property (nonatomic, copy) NSString *goodsId;

@property (nonatomic, copy) NSString *orderNum;

@property (nonatomic, copy) NSString *tempStr9th;

@property (nonatomic, assign) NSInteger reRequestInt;

-(void)actionRequestAddPurchaseUpgradeRecord;

@end


@interface ZFUpgradteBottomProlicyViewCell : UICollectionViewCell

@end

@interface ZFUpgradteOtherBottomProlicyViewCell : UICollectionViewCell

@end


@interface ZFUpgradteCommitBuyViewCell : UICollectionViewCell
@property (nonatomic, strong) UIButton *contiue_btn;
@property (nonatomic,copy)void(^ZFUpgradteCommitBuyViewCellContinueBlock)(void);
@end

@interface ZFUpgradteOtherCommitBuyViewCell : UICollectionViewCell
@property (nonatomic, strong) UIButton *contiue_btn;
@property (nonatomic,copy)void(^ZFUpgradteCommitBuyViewCellContinueBlock)(void);
@end

@interface ZFUpgradteContentViewCell : UICollectionViewCell
@property (strong, nonatomic) UIButton *bg_view;
@property (strong, nonatomic) UIView *bg_view2;
@property (strong, nonatomic) UILabel *middle_lab;
@property (strong, nonatomic) UILabel *top_lab;
@property (strong, nonatomic) UILabel *bottom_lab;

@end

@interface ZFUpgradteOtherContentViewCell : UICollectionViewCell
@property (strong, nonatomic) UIButton *bg_view;
@property (strong, nonatomic) UIView *bg_view2;
@property (strong, nonatomic) CusLabel *middle_lab;
@property (strong, nonatomic) UILabel *top_lab;
@property (strong, nonatomic) UILabel *bottom_lab;

@end


@interface ZFMemberUpgrdeController : NeighborsSimpleCuteBaseController

@end

@interface ZFMemberUpgrdeOtherController : NeighborsSimpleCuteBaseController

@end

@interface XSDKResourceUtil : NSObject

+(CGSize)measureSinglelineStringSize:(NSString*)str andFont:(UIFont*)wordFont;

//获取字符串宽 // 传一个字符串和字体大小来返回一个字符串所占的宽度

+(float)measureSinglelineStringWidth:(NSString*)str andFont:(UIFont*)wordFont;

//获取字符串高 // 传一个字符串和字体大小来返回一个字符串所占的高度

+(float)measureMutilineStringHeight:(NSString*)str andFont:(UIFont*)wordFont andWidthSetup:(float)width;

 

+(UIImage*)imageAt:(NSString*)imgNamePath;

 

+(BOOL)xsdkcheckName:(NSString*)name;

+(BOOL)xsdkcheckPhone:(NSString *)userphone;

 

+ (UIColor *)xsdkcolorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

 

+(BOOL)xsdkstringIsnilOrEmpty:(NSString*)string;

 

+(BOOL)jsonFieldIsNull:(id)jsonField;

+(int)filterIntValue:(id)value withDefaultValue:(int)defaultValue;

+(NSString*)filterStringValue:(id)value withDefaultValue:(NSString*)defaultValue;


@end















