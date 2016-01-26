//
//  PluginDemo.m
//  PluginDemo
//
//  Created by xianzhiliao on 16/1/25.
//  Copyright © 2016年 Putao. All rights reserved.
//

#import "PluginDemo.h"
#import <AppKit/AppKit.h>
#import <stdlib.h>

@interface PluginDemo()

@property (nonatomic, strong)NSString *selectedText;

@end

@implementation PluginDemo

+ (void)pluginDidLoad:(NSBundle *)bundle
{
    [self shared];
}
+ (instancetype)shared
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[self alloc]init];
    });
    return instance;
}
- (instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidFinishLaunchingNotification:) name:NSApplicationDidFinishLaunchingNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showSelectedText:) name:NSTextViewDidChangeSelectionNotification object:nil];
    }
    return self;
}
- (void)applicationDidFinishLaunchingNotification:(NSNotification *)notification
{
    NSMenuItem *fileMenu = [[NSApp menu]itemWithTitle:@"File"];
    NSMenuItem *subMenu = [[NSMenuItem alloc]init];
    subMenu.title = @"很黄很暴力";
    subMenu.target = self;
    subMenu.action = @selector(becomeYellow:);
    
    NSMenuItem *goToGoogle = [[NSMenuItem alloc]initWithTitle:@"go to google" action:@selector(gotoGoogle:) keyEquivalent:@"+"];
    goToGoogle.target = self;
    goToGoogle.keyEquivalentModifierMask = NSCommandKeyMask|NSShiftKeyMask;
    [[fileMenu submenu]addItem:goToGoogle];
}
- (void)becomeYellow:(id)sender
{
    [[[NSApp windows]firstObject]setBackgroundColor:[NSColor yellowColor]];
}
- (void)gotoGoogle:(id)sender
{
    const char *s = [NSString stringWithFormat:@"open /Applications/Safari.app/ https://www.baidu.com/s?wd=%@",self.selectedText].UTF8String;
    system(s);
}
- (void)showSelectedText:(NSNotification *)notification
{
    if ([notification.object isKindOfClass:[NSTextView class]]) {
        NSTextView *tv = notification.object;
        NSString *allText = tv.textStorage.string;
        NSString *selectedText = [allText substringWithRange:tv.selectedRange];
        self.selectedText = selectedText;
    }
}
@end
