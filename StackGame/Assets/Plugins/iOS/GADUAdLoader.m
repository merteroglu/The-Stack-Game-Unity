// Copyright 2014 Google Inc. All Rights Reserved.

#import "GADUAdLoader.h"

@import GoogleMobileAds;

#import "GADUNativeCustomTemplateAd.h"
#import "GADUObjectCache.h"
#import "UnityAppController.h"

@interface GADUAdLoader () <GADAdLoaderDelegate, GADNativeCustomTemplateAdLoaderDelegate>

@end

@implementation GADUAdLoader

+ (UIViewController *)unityGLViewController {
  return ((UnityAppController *)[UIApplication sharedApplication].delegate).rootViewController;
}

- (instancetype)initWithAdLoaderClientReference:(GADUTypeAdLoaderClientRef *)adLoaderClient
                                       adUnitID:(NSString *)adUnitID
                                    templateIDs:(NSArray *)templateIDs
                                        adTypes:(NSArray *)adTypes {
  self = [super init];
  if (self) {
    _adLoaderClient = adLoaderClient;
    _adLoader = [[GADAdLoader alloc] initWithAdUnitID:adUnitID
                                   rootViewController:[GADUAdLoader unityGLViewController]
                                              adTypes:@[ kGADAdLoaderAdTypeNativeCustomTemplate ]
                                              options:nil];
    _adLoader.delegate = self;
    _templateIDs = [NSArray arrayWithArray:templateIDs];
    _adTypes = [NSArray arrayWithArray:adTypes];
  }
  return self;
}

- (void)loadRequest:(GADRequest *)request {
  if (!self.adLoader) {
    NSLog(@"GoogleMobileAdsPlugin: AdLoader is nil. Ignoring ad request.");
    return;
  }
  [self.adLoader loadRequest:request];
}

- (NSArray *)nativeCustomTemplateIDsForAdLoader:(GADAdLoader *)adLoader {
  return self.templateIDs;
}

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error {
  if (self.adFailedCallback) {
    NSString *errorMsg = [NSString
        stringWithFormat:@"Failed to receive ad with error: %@", [error localizedFailureReason]];
    self.adFailedCallback(self.adLoaderClient,
                          [errorMsg cStringUsingEncoding:NSUTF8StringEncoding]);
  }
}

- (void)adLoader:(GADAdLoader *)adLoader
    didReceiveNativeCustomTemplateAd:(GADNativeCustomTemplateAd *)nativeCustomTemplateAd {
  if (self.adReceivedCallback) {
    GADUObjectCache *cache = [GADUObjectCache sharedInstance];
    [cache.references setObject:self forKey:[self gadu_referenceKey]];
    self.adReceivedCallback(
        self.adLoaderClient,
        (__bridge GADUTypeNativeCustomTemplateAdRef)
            [[GADUNativeCustomTemplateAd alloc] initWithAd:nativeCustomTemplateAd],
        [nativeCustomTemplateAd.templateID cStringUsingEncoding:NSUTF8StringEncoding]);
  }
}

@end
