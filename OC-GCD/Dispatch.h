//
//  Dispatch.h
//  OC-GCD
//
//  Created by Gaoxiang Zhang on 2020/11/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Dispatch : NSObject
@property (nonatomic, assign) int ticketSurplusCount;
- (void)syncConcurrent;
- (void)asyncConcurrent;
- (void)syncSerial;
- (void)asyncSerial;
- (void)syncMainQueue;
- (void)runSyncMainQueueInNewThread;
- (void)asyncMainQueue;
- (void)communication;
- (void)barrier;
- (void)once;
- (void)after;
- (void)apply;
- (void)groupNotify;
- (void)semaphoreSync;
- (void)initTicketStatusNotSave;
- (void)initTicketStatusSave;
@end

NS_ASSUME_NONNULL_END
