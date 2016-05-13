//
//  TTLiveStreamer.h
//  TTLiveSDK
//
//  Created by zhaokai on 16/3/10.
//  Copyright © 2016年 zhaokai. All rights reserved.
//pod 'VideoCore', :git => 'https://github.com/onlyyoujack/VideoCore.git'
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LiveStreamState) {
    /// 初始化时状态为空闲
    LiveStreamStateIdle = 0,
    //开始预览
    LiveStreamStatePreview,
    //开始推流
    LiveStreamStateReadyForPush,
    /// 连接中
    LiveStreamStateConnecting,
    /// 已连接
    LiveStreamStateConnected,
    /// 断开连接中
    LiveStreamStateDisconnecting,
    /// 推流出错
    LiveStreamStateError,
};

typedef NS_ENUM(NSUInteger, LiveFilterType){
    LiveFilterTypeNormal = 0,
    LiveFilterTypeGray,
    LiveFilterTypeInvertColors,
    LiveFilterTypeSepia,
    LiveFilterTypeFisheye,
    LiveFilterTypeGlow,
    LiveFilterTypeFaceBeauty,
    
    LiveFilter_Counts,//滤镜的总数
};

typedef NS_ENUM(NSUInteger, LiveAudioSource) {
    LiveAudioSourceMic,
    LiveAudioSourceMix,
};

@class TTLiveStreamer;

@protocol TTLiveStreamerDelegate <NSObject>
@optional
- (void)flashModeChanged:(TTLiveStreamer *)streamer;//闪光灯是否可用通知
- (void)liveStreamer:(TTLiveStreamer *)streamer streamStateDidChange:(LiveStreamState)state withError:(NSString *)description;
@end

@interface TTLiveStreamer : NSObject

@property (nonatomic,weak) id <TTLiveStreamerDelegate> streamerDelegate;
@property (nonatomic,assign)BOOL debugMode;//默认NO=不打开

- (instancetype)initWithURL:(NSURL *)url with:(UIView *)view frameRate:(int)fps bitrate:(int)bitrate audioSource:(LiveAudioSource)audioSource;
- (instancetype)initWithURL:(NSURL *)url with:(UIView *)view audioSource:(LiveAudioSource)audioSource;

- (void)start;
- (void)stop;
- (BOOL)isRunning;

/**
 *  开始推流，用于断网，切回前台后恢复推流
 *
 *  @param url 推流地址
 */
- (void)startStream:(NSURL *)url;

//MARK:输出的视频大小
/**
 *  输出的视频Size，可不填，根据屏幕提供一个适配默认值
 */
@property (nonatomic,assign) CGSize videoSize;
//MARK:码率控制
@property (nonatomic, assign) int  videoFPS;
@property (nonatomic, assign) int  videoMinFPS;
/**
 *  开始推流时的视频码率，开始推流后，根据网络情况在【Min,Max】范围内调节
 */
@property (nonatomic,assign)int videoInitBitrate;
/**
 *  视频码率自适应调整的上限，为目标码率 (单位：kbps)
 */
@property (nonatomic,assign)int videoMaxBitrate;
/**
 *  视频码率自适应调整的下限 (单位：kbps)
 */
@property (nonatomic,assign)int videoMinBitrate;

/**
 *  自动调整码率，start（）执行 前调用有效
 *  @see start()
 */
@property (nonatomic,assign)BOOL autoAppleEstimateBitrate;

//MARK: 摄像头操作
- (void)switchCamera;//切换前后摄像头
- (void)switchFlash;//闪光灯 开、关 切换
- (BOOL)hasFlash;//当前摄像头是否支持闪光灯
- (BOOL)isFlashAchive;//当前闪光灯开 or 关
//MARK: 滤镜操作
@property (nonatomic, readonly) LiveFilterType activeFilterType;
- (void)switchFilter:(LiveFilterType)type;

//MARK: 音频操作

/**
 *  播放背景音乐
 *
 *  @param url              音乐文件的本地地址
 *  @param loop            是否循环播放
 *  @param volume          初始化音量
 *  @param error           错误
 *  @param completionBlock 背景音乐播放完成回调方法,播放音乐loop为NO时有效
 *
 *  @return yes,开始播放，no 查看 error信息
 */
- (BOOL)playBgMusicWithURL:(NSURL *)url loop:(BOOL)loop volume:(float)volume error:(NSError **)error completionBlock:(void(^)())completionBlock;

/**
 *  停止背景音乐
 */
- (void)stopBgMusic;

/**
 *  暂停背景音乐
 */
- (void)pauseBgMusic;

/**
 *  恢复背景音乐
 */
- (void)resumeBgMusic;

@property (nonatomic,assign)float musicVolume;

/**
 *  人声处理
 *
 *  @param Volume 初始化音量
 */
- (void)recordingVoiceWithVolume:(float)Volume;

@property (nonatomic,assign)float voiceVolume;

//MARK :水印
/**
 *  添加水印，要在 star() 之前调用
 *
 *  @param image 水印图片
 *  @param rect  水印显示的位置 左上角显示（width/2,height/2,width,height）
 */
- (void) addWatermarkWithImage: (UIImage*) image
                     withRect: (CGRect) rect;
@end

