#import "RNExternalDisplayView.h"
#import "UIView+React.h"
#import "RCTShadowView.h"
#import <React/RCTLog.h>

@implementation RNExternalDisplayView {
  UIWindow *_window;
  UIView *_subview;
  NSString *_screen;
  BOOL _fallbackInMainScreen;
}

- (void)insertReactSubview:(UIView *)subview atIndex:(NSInteger)atIndex
{
  if (atIndex > 0) {
    RCTLogError(@"RNExternalDisplayView only allowed one child view.");
    return;
  }
  _subview = subview;
  [self updateScreen];
}

- (void)removeReactSubview:(UIView *)subview
{
  [super removeReactSubview:subview];
}

- (void)didMoveToSuperview
{
  [super didMoveToSuperview];
  if (!self.superview) {
    [self invalidate];
  }
}

- (void)invalidate {
  _window = nil;
}

- (void)updateScreen {
  if (!_subview) {
    return;
  }
  NSArray *screens = [UIScreen screens];
  int index = [_screen intValue];
  if (index > 0 && index < [screens count]) {
    // NSLog(@"[RNExternalDisplay] Selected External Display");
    UIScreen* screen = [screens objectAtIndex:index];
    if (!_window) {
      _window = [[UIWindow alloc] init];
    }
    [_window setScreen:screen];
    [_window setFrame:CGRectMake(0, 0, screen.bounds.size.width, screen.bounds.size.height)];
    _window.rootViewController = [[UIViewController alloc] init];
    _window.rootViewController.view = _subview;
    [_window makeKeyAndVisible];
  } else if (_fallbackInMainScreen) {
    [super insertSubview:_subview atIndex:0];
  }
}

- (void)setScreen:(NSString*)screen {
  if (screen != _screen) {
    _window = nil;
  }
  _screen = screen;
  [self updateScreen];
}

- (void)setFallbackInMainScreen:(BOOL)fallbackInMainScreen {
  _fallbackInMainScreen = fallbackInMainScreen;
  [self updateScreen];
}

@end
