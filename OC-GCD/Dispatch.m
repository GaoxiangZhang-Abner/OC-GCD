//
//  Dispatch.m
//  OC-GCD
//
//  Created by Gaoxiang Zhang on 2020/11/4.
//

#import "Dispatch.h"


@implementation Dispatch

dispatch_semaphore_t semaphoreLock;

/**
 * 同步执行 + 并发队列
 * 特点：在当前线程中执行任务，不会开启新线程，执行完一个任务，再执行下一个任务。
 */
- (void)syncConcurrent {
    
    NSLog(@"currentThread: %@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncConcurrent begin");
    
    dispatch_queue_t queue = dispatch_queue_create("io.github.gaoxiangzhang-abner", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(queue, ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"Task1: %@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_sync(queue, ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"Task2: %@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_sync(queue, ^{
        // 追加任务 3
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"Task3: %@",[NSThread currentThread]);      // 打印当前线程
    });
    
    NSLog(@"syncConcurrent end");
}

/**
 * 异步执行 + 并发队列
 * 特点：可以开启多个线程，任务交替（同时）执行。
 */
- (void)asyncConcurrent {
    NSLog(@"currentThread: %@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncConcurrent begin");
    
    dispatch_queue_t queue = dispatch_queue_create("io.github.gaoxiangzhang-abner-2", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        // 追加任务 1
        //        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"Task1: %@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_async(queue, ^{
        // 追加任务 2
        //        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"Task2: %@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_async(queue, ^{
        // 追加任务 3
        //        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"Task3: %@",[NSThread currentThread]);      // 打印当前线程
    });
    
    NSLog(@"asyncConcurrent end");
}

/**
 * 同步执行 + 串行队列
 * 特点：不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务
 */

- (void) syncSerial {
    
    NSLog(@"currentThread: %@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncSerial begin");
    
    dispatch_queue_t queue = dispatch_queue_create("io.github.gaoxiangzhang-abner", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"Task1: %@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_sync(queue, ^{
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"Task2: %@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_sync(queue, ^{
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"Task3: %@",[NSThread currentThread]);      // 打印当前线程
    });
    
    NSLog(@"syncSerial end");
    
}

/**
 * 异步执行 + 串行队列
 * 特点：会开启新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务。
 * 不执行的话是线程阻塞了
 */

- (void)asyncSerial {
    
    NSLog(@"currentThread:%@", [NSThread currentThread]);
    NSLog(@"asyncSerial begin");
    
    
    dispatch_queue_t queue = dispatch_queue_create("asdasd", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        //        [NSThread sleepForTimeInterval:2];
        NSLog(@"Task1: %@", [NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        //        [NSThread sleepForTimeInterval:2];
        NSLog(@"Task2: %@", [NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        //        [NSThread sleepForTimeInterval:2];
        NSLog(@"Task3: %@", [NSThread currentThread]);
    });
    
    NSLog(@"asyncSerial end");
}

/**
 * 同步执行 + 主队列
 * 特点：
 */
- (void)syncMainQueue {
    
    NSLog(@"currentThread: %@", [NSThread currentThread]);
    NSLog(@"syncMainQueue begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    // 主队列会把syncMainQueue任务放到主线程执行，因为同步执行，队列会等待当前syncMainQueue任务执行完后执行NSLog任务，而syncMainQueue任务需要等待NSLog任务 执行完毕，才算执行完毕，所以它在等待NSLog。
    
    // 即syncMainQueue任务、NSLog任务互相等待，造成主队列堵塞
    
    dispatch_sync(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"Task1: %@", [NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"Task2: %@", [NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"Task3: %@", [NSThread currentThread]);
    });
    
    NSLog(@"syncMainQueue end");
    
}

- (void) runSyncMainQueueInNewThread {
    [NSThread detachNewThreadSelector:@selector(syncMainQueue) toTarget:self withObject:nil];
}

/**
 * 异步执行 + 主队列
 * 特点：
 */
- (void)asyncMainQueue {
    
    NSLog(@"currentThread: %@", [NSThread currentThread]);
    NSLog(@"asynMainQueue begin");
    
    dispatch_group_t queue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"Task1: %@", [NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"Task2: %@", [NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"Task3: %@", [NSThread currentThread]);
    });
    
    NSLog(@"asynMainQueue end");
}

/**
 * 线程间通信
 */
- (void)communication {
    // 获取全局并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 获取主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        // 异步追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        
        // 回到主线程
        dispatch_async(mainQueue, ^{
            // 追加在主线程中执行的任务
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        });
    });
}

/**
 * 栅栏方法 dispatch_barrier_async
 * 应用：隔断两个异步，让第一个先完成再执行第二个
 */
- (void)barrier {
    
    dispatch_queue_t queue = dispatch_queue_create("io.github.gaoxiangzhang-abner", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    dispatch_async(queue, ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_barrier_async(queue, ^{
        // 追加任务 barrier
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"barrier---%@",[NSThread currentThread]);// 打印当前线程
    });
    
    dispatch_async(queue, ^{
        // 追加任务 3
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
    });
    dispatch_async(queue, ^{
        // 追加任务 4
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"4---%@",[NSThread currentThread]);      // 打印当前线程
    });
}

/**
 * 一次性代码（只执行一次）dispatch_once
 * 应用：单例
 */
- (void)once {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 只执行 1 次的代码（这里面默认是线程安全的）
    });
}

/**
 * 延时执行方法 dispatch_after
 * 应用：延迟执行
 */
- (void)after {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncMain---begin");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 2.0 秒后异步追加任务代码到主队列，并开始执行
        NSLog(@"after---%@",[NSThread currentThread]);  // 打印当前线程
    });
}

/**
 * 快速迭代方法 dispatch_apply
 * 应用场景： 需要快速迭代
 */
- (void)apply {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSLog(@"apply---begin");
    dispatch_apply(10, queue, ^(size_t index) { // 并发执行的循环
        NSLog(@"%d: %@", index, [NSThread currentThread]);
    });
    NSLog(@"apply---end");
}


/**
 * 队列组 dispatch_group_notify
 * 应用：分别异步执行2个耗时任务，然后当2个耗时任务都执行完毕后再回到主线程执行任务。这时候我们可以用到 GCD 的队列组。
 */
- (void)groupNotify {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group =  dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_group_enter(group);
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        dispatch_group_leave(group);
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步任务 1、任务 2 都执行完毕后，回到主线程执行下边任务
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        
        NSLog(@"group---end");
    });
    
}

/**
 Dispatch Semaphore 在实际开发中主要用于：
 保持线程同步，将异步执行任务转换为同步执行任务
 保证线程安全，为线程加锁
 */
/**
 * semaphore 线程同步
 */
- (void)semaphoreSync {
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    
    // 首先创建semaphore_create，信号量为0；然后执行semaphore_wait， 让信号量-1； 等异步任务完成时，执行semaphore_signal，让信号量恢复为0，接着执行NSLog方法
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block int number = 0;
    dispatch_async(queue, ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"Task1: %@",[NSThread currentThread]);      // 打印当前线程
        
        number = 100;
        
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    // 等待异步任务执行完成后，执行此方法
    
    NSLog(@"semaphore---end,number = %zd",number);
}

/**
 * 非线程安全：不使用 semaphore
 * 初始化火车票数量、卖票窗口（非线程安全）、并开始卖票
 * 但似乎有bug，无法执行async内的内容，不知道如何解决
 */
- (void)initTicketStatusNotSave {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    
    self.ticketSurplusCount = 50;
    
    // queue1 代表北京火车票售卖窗口
    dispatch_queue_t queue1 = dispatch_queue_create("io.github.gaoxiangzhang-abner1", DISPATCH_QUEUE_SERIAL);
    // queue2 代表上海火车票售卖窗口
    dispatch_queue_t queue2 = dispatch_queue_create("io.github.gaoxiangzhang-abner2", DISPATCH_QUEUE_SERIAL);
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(queue1, ^{
        [weakSelf saleTicketNotSafe];
    });
    
    dispatch_async(queue2, ^{
        [weakSelf saleTicketNotSafe];
    });
}

/**
 * 售卖火车票（非线程安全）
 */
- (void)saleTicketNotSafe {
    while (1) {
        if (self.ticketSurplusCount > 0) {  // 如果还有票，继续售卖
            self.ticketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%d 窗口：%@", self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        } else { // 如果已卖完，关闭售票窗口
            NSLog(@"所有火车票均已售完");
            break;
        }
        
    }
}

/**
 * 线程安全：使用 semaphore 加锁
 * 初始化火车票数量、卖票窗口（线程安全）、并开始卖票
 * 但似乎有bug，无法执行async内的内容，不知道如何解决
 */
- (void)initTicketStatusSave {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    
    semaphoreLock = dispatch_semaphore_create(1);
    
    self.ticketSurplusCount = 50;
    
    // queue1 代表北京火车票售卖窗口
    dispatch_queue_t queue1 = dispatch_queue_create("net.bujige.testQueue1", DISPATCH_QUEUE_SERIAL);
    // queue2 代表上海火车票售卖窗口
    dispatch_queue_t queue2 = dispatch_queue_create("net.bujige.testQueue2", DISPATCH_QUEUE_SERIAL);
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(queue1, ^{
        [weakSelf saleTicketSafe];
    });
    
    dispatch_async(queue2, ^{
        [weakSelf saleTicketSafe];
    });
    
    NSLog(@"为防止异步不显示console专用NSLog!");
}

/**
 * 售卖火车票（线程安全）
 */
- (void)saleTicketSafe {
    while (1) {
        // 相当于加锁, 信号量为0；若其他线程来执行此方法，需要等待解锁后才可以
        dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);
                
        if (self.ticketSurplusCount > 0) {  // 如果还有票，继续售卖
            self.ticketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%d 窗口：%@", self.ticketSurplusCount, [NSThread currentThread]]);
            NSLog(@"为防止异步不显示console专用NSLog!");
        } else { // 如果已卖完，关闭售票窗口
            NSLog(@"所有火车票均已售完");
            
            // 相当于解锁
            dispatch_semaphore_signal(semaphoreLock);
            break;
        }
        NSLog(@"为防止异步不显示console专用NSLog!");
        // 相当于解锁
        dispatch_semaphore_signal(semaphoreLock);
    }
}
@end
