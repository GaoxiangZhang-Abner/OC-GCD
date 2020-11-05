//
//  main.m
//  OC-GCD
//
//  Created by Gaoxiang Zhang on 2020/11/4.
//

#import <Foundation/Foundation.h>
#import "Dispatch.h"

int main(int argc, const char * argv[]) {
    
    // 串行队列
    dispatch_queue_t queueSerial = dispatch_queue_create(@"io.github.gaoxiangzhang-abner", DISPATCH_QUEUE_SERIAL);
    
    // 并行队列
    dispatch_queue_t queueConcurrent = dispatch_queue_create(@"io.github.gaoxiangzhang-abner", DISPATCH_QUEUE_CONCURRENT);
    
    // 主队列[默认代码放在主队列，其任务默认放到主线程执行]（串行队列）
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 全局并发队列
    dispatch_queue_t queueGlobal = dispatch_get_global_queue(0, 0);
    dispatch_queue_t queueGlobal2 = dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0);
    
    // 同步执行任务的方法创建
//    dispatch_sync(queueSerial, ^{
//        NSLog(@"");
//    });
    
    // 异步执行任务的方法创建
//    dispatch_async(queueSerial, ^{
//        NSLog(@"");
//    });
    
    // 同步执行+串行队列 嵌套 异步执行+串行队列 = 死锁
    /*
    dispatch_queue_t queueS = dispatch_queue_create("test.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queueS, ^{    // 异步执行 + 串行队列
        dispatch_sync(queueS, ^{  // 同步执行 + 当前串行队列
            // 追加任务 1
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        });
    });
    */
    

    // MARK: 测试同步/异步+并发/串行
    Dispatch *dispatch = [Dispatch new];
    // [dispatch syncConcurrent];
    // [dispatch asyncConcurrent];
    // [dispatch syncSerial];
    // [dispatch asyncSerial];
    // [dispatch syncMainQueue];
    
    // 使用 NSThread 的 detachNewThreadSelector 方法会创建线程，并自动启动线程执行 selector 任务
    // [dispatch runSyncMainQueueInNewThread];
    
    // [dispatch communication];
    // [dispatch barrier];
    // [dispatch apply];
    // [dispatch semaphoreSync];
    // [dispatch initTicketStatusNotSave];
     [dispatch initTicketStatusSave];

}




