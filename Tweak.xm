#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// ─── iKarwan 2026 @ikg_hd ───────────────────────────────────────────

// ─── YT Liquid Glass Floating Tab Bar ───────────────────────────────────────────
@interface YTFloatingPivotBarView : UIView
@property(nonatomic) _Bool enableFloatingBar;
@property(nonatomic) long long floatingBarStyle;

@end

@interface YTPivotBarView : UIView
@property(nonatomic) long long floatingBarStyle;
@property(nonatomic) _Bool enableFloatingBar;

@end

// Check for the app version
static BOOL YTKIsNewYouTube(void) {
    if (@available(iOS 26.0, *)) {
        NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        return [appVersion compare:@"21.40" options:NSNumericSearch] != NSOrderedAscending;
    }
    return NO;
}

// Gate 1: M3CLiquidGlass — framework gate for Liquid Glass availability
%hook M3CLiquidGlass
+ (BOOL)isLiquidGlassAvailable { return YTKIsNewYouTube() ? YES : %orig; }
+ (BOOL)computeIsLiquidGlassAvailable { return YTKIsNewYouTube() ? YES : %orig; }
%end

// Gate 2: YTFloatingBarExperiment — controls whether floating bar activates
%hook YTFloatingBarExperiment
+ (BOOL)enableFloatingBottomBar { return YTKIsNewYouTube() ? YES : %orig; }
+ (long long)floatingBarStyle { return YTKIsNewYouTube() ? 1 : %orig; }
+ (BOOL)isIconsOnly { return YTKIsNewYouTube() ? NO : %orig; }
+ (BOOL)isIPhoneDuoImprovementsEnabled { return YTKIsNewYouTube() ? YES : %orig; }
%end

// Gate 3: YTColdConfig flags
%hook YTColdConfig
- (BOOL)mainAppCoreClientIos27EnableLiquidGlass { return YTKIsNewYouTube() ? YES : %orig; }
- (BOOL)enableLiquidGlassEffect { return YTKIsNewYouTube() ? YES : %orig; }
- (long long)liquidGlassEffectStyle { return YTKIsNewYouTube() ? 1 : %orig; }
- (long long)mainAppCoreClientIosFloatingBarStyle { return YTKIsNewYouTube() ? 1 : %orig; }
%end

// Gate 4: Force on the view directly when it appears
%hook YTFloatingPivotBarView
- (void)didMoveToWindow {
    %orig;
    if (!self.window) return;
    if (YTKIsNewYouTube()) {
        self.enableFloatingBar = YES;
        self.floatingBarStyle = 1;
    }
}
%end

%hook YTPivotBarView
- (void)didMoveToWindow {
    %orig;
    if (!self.window) return;
    if (YTKIsNewYouTube()) {
        self.enableFloatingBar = YES;
        self.floatingBarStyle = 1;
    }
}
%end

%ctor {
  %init();
}
