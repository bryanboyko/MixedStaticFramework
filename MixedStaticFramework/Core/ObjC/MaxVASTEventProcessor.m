//
//  MaxVASTEventProcessor.m
//  VAST
//
//  Created by Thomas Poland on 10/3/13.
//  Copyright (c) 2013 Nexage. All rights reserved.
//

#import "MaxVASTEventProcessor.h"
#import "MaxVASTUrlWithId.h"
#import "MaxCommonLogger.h"

@interface MaxVASTEventProcessor()

@property(nonatomic, strong) NSDictionary *trackingEvents;
@property(nonatomic, strong) id<MaxVASTViewControllerDelegate> delegate;

@end


@implementation MaxVASTEventProcessor

// designated initializer
- (id)initWithTrackingEvents:(NSDictionary *)trackingEvents withDelegate:(id<MaxVASTViewControllerDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.trackingEvents = trackingEvents;
        self.delegate = delegate;
    }
    return self;
}

- (void)trackEvent:(MaxVASTEvent)vastEvent
{
    switch (vastEvent) {
     
        case VASTEventTrackStart:
            if ([self.delegate respondsToSelector:@selector(vastTrackingEvent:)]) {
                [self.delegate vastTrackingEvent:@"start"];
            }

            for (NSURL *aURL in (self.trackingEvents)[@"start"]) {
                [self sendTrackingRequest:aURL];
                [MaxCommonLogger debug:@"VAST - Event Processor" withMessage:[NSString stringWithFormat:@"Sent track start to url: %@", [aURL absoluteString]]];
            }
         break;
            
        case VASTEventTrackFirstQuartile:
            if ([self.delegate respondsToSelector:@selector(vastTrackingEvent:)]) {
                [self.delegate vastTrackingEvent:@"firstQuartile"];
            }
            
            for (NSURL *aURL in (self.trackingEvents)[@"firstQuartile"]) {
                [self sendTrackingRequest:aURL];
                [MaxCommonLogger debug:@"VAST - Event Processor" withMessage:[NSString stringWithFormat:@"Sent firstQuartile to url: %@", [aURL absoluteString]]];
            }
            break;
            
        case VASTEventTrackMidpoint:
            if ([self.delegate respondsToSelector:@selector(vastTrackingEvent:)]) {
                [self.delegate vastTrackingEvent:@"midpoint"];
            }
            
            for (NSURL *aURL in (self.trackingEvents)[@"midpoint"]) {
                [self sendTrackingRequest:aURL];
                [MaxCommonLogger debug:@"VAST - Event Processor" withMessage:[NSString stringWithFormat:@"Sent midpoint to url: %@", [aURL absoluteString]]];
            }
            break;
            
        case VASTEventTrackThirdQuartile:
            if ([self.delegate respondsToSelector:@selector(vastTrackingEvent:)]) {
                [self.delegate vastTrackingEvent:@"thirdQuartile"];
            }
            
            for (NSURL *aURL in (self.trackingEvents)[@"thirdQuartile"]) {
                [self sendTrackingRequest:aURL];
                [MaxCommonLogger debug:@"VAST - Event Processor" withMessage:[NSString stringWithFormat:@"Sent thirdQuartile to url: %@", [aURL absoluteString]]];
            }
            break;
 
        case VASTEventTrackComplete:
            if ([self.delegate respondsToSelector:@selector(vastTrackingEvent:)]) {
                [self.delegate vastTrackingEvent:@"complete"];
            }
            
            for( NSURL *aURL in (self.trackingEvents)[@"complete"]) {
                [self sendTrackingRequest:aURL];
                [MaxCommonLogger debug:@"VAST - Event Processor" withMessage:[NSString stringWithFormat:@"Sent complete to url: %@", [aURL absoluteString]]];
            }
            break;
            
        case VASTEventTrackClose:
            if ([self.delegate respondsToSelector:@selector(vastTrackingEvent:)]) {
                [self.delegate vastTrackingEvent:@"close"];
            }
            
            for (NSURL *aURL in (self.trackingEvents)[@"close"]) {
                [self sendTrackingRequest:aURL];
                [MaxCommonLogger debug:@"VAST - Event Processor" withMessage:[NSString stringWithFormat:@"Sent close to url: %@", [aURL absoluteString]]];
            }
            break;
            
        case VASTEventTrackPause:
            if ([self.delegate respondsToSelector:@selector(vastTrackingEvent:)]) {
                [self.delegate vastTrackingEvent:@"pause"];
            }
            
            for (NSURL *aURL in (self.trackingEvents)[@"pause"]) {
                [self sendTrackingRequest:aURL];
                [MaxCommonLogger debug:@"VAST - Event Processor" withMessage:[NSString stringWithFormat:@"Sent pause start to url: %@", [aURL absoluteString]]];
            }
            break;
            
        case VASTEventTrackResume:
            if ([self.delegate respondsToSelector:@selector(vastTrackingEvent:)]) {
                [self.delegate vastTrackingEvent:@"resume"];
            }
            
            for (NSURL *aURL in (self.trackingEvents)[@"resume"]) {
                [self sendTrackingRequest:aURL];
                [MaxCommonLogger debug:@"VAST - Event Processor" withMessage:[NSString stringWithFormat:@"Sent resume start to url: %@", [aURL absoluteString]]];
            }
            break;
            
        default:
            if ([self.delegate respondsToSelector:@selector(vastTrackingEvent:)]) {
                [self.delegate vastTrackingEvent:@"Unknown"];
            }

            break;
    }
}

- (void)sendVASTUrlsWithId:(NSArray *)vastUrls
{
    for (MaxVASTUrlWithId *urlWithId in vastUrls) {
        [self sendTrackingRequest:urlWithId.url];
        if (urlWithId.id_) {
            [MaxCommonLogger debug:@"VAST - Event Processor" withMessage:[NSString stringWithFormat:@"Sent http request %@ to url: %@", urlWithId.id_, urlWithId.url]];
        } else {
            [MaxCommonLogger debug:@"VAST - Event Processor" withMessage:[NSString stringWithFormat:@"Sent http request to url: %@", urlWithId.url]];
        }
    }
}

- (void)sendTrackingRequest:(NSURL *)trackingURL
{
    dispatch_queue_t sendTrackRequestQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(sendTrackRequestQueue, ^{
        NSURLRequest* trackingURLrequest = [ NSURLRequest requestWithURL:trackingURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:1.0];
        NSOperationQueue *senderQueue = [[NSOperationQueue alloc] init];
        [MaxCommonLogger debug:@"VAST - Event Processor" withMessage:[NSString stringWithFormat:@"Event processor sending request to url: %@", [trackingURL absoluteString]]];
        [NSURLConnection sendAsynchronousRequest:trackingURLrequest queue:senderQueue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {}];  // Send the request only, no response or errors
    });
}

@end
