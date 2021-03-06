//
//  CNFSettingsWindowController.m
//  CoinNotify
//

#import "CNFSettingsWindowController.h"
#import "CNFConstants.h"

@implementation CNFSettingsWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        [window setDelegate:self];
        NSLog(@"Requested value is: %f",[[NSUserDefaults standardUserDefaults] floatForKey:kSettingsUpdateFrequency]);
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [_updateFrequencySlider setFloatValue:[[NSUserDefaults standardUserDefaults] floatForKey:kSettingsUpdateFrequency]];
    [self updateFrequencySliderUpdated:_updateFrequencySlider];
    [_decimalsButton selectItemWithTag:[[NSUserDefaults standardUserDefaults] integerForKey:kSettingsDecimalSteps]];
    [_versionField setStringValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];

}

- (IBAction)updateFrequencySliderUpdated:(NSSlider*)sender
{
    float sliderValue = [sender floatValue];
    _updateFrequencyField.stringValue = [self stringForFrequency:sliderValue];    
    [[NSUserDefaults standardUserDefaults] setFloat:sliderValue forKey:kSettingsUpdateFrequency];
}

- (NSString*)stringForFrequency:(float) frequency
{
    if (frequency <= 60) {
        return [NSString stringWithFormat:@"Every %d seconds", (int)frequency];
    } else if (frequency == 60) {
        return @"Every minute";
    } else if (frequency == 120) {
        return @"Every two minutes";
    } else {
        return [NSString stringWithFormat:@"Every %d:%02d minutes", (int)(frequency / 60), (int)(frequency - 60)];
    }
}

- (void)windowWillClose:(NSNotification *)notification
{
    int decimals = [[[_decimalsButton selectedItem] title] intValue];
    NSLog(@"Saved decimal steps %d", decimals);
    [[NSUserDefaults standardUserDefaults] setInteger:decimals forKey:kSettingsDecimalSteps];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
