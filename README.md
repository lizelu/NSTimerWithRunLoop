# NSTimerWithRunLoop

最近工作比较忙，但是还是出来更新博客了。今天博客中所涉及的内容并不复杂，都是一些平时常见的一些问题，通过这篇博客算是对UITableView中使用定时器的几种方式进行总结。本篇博客会给出在TableView中使用NSTimer或者DispatchSourcer中常见的五种方式。当然下方第一种方式是常规做法，不过也是UITableView中使用NSTimer的一个坑。其他三种方式是为了绕过这个坑的解决方案。

当然，本篇博客共涉及到了UITableView中使用定时器的四种实现方式，当然应该也还有其他实现方式，只不过目前我没有涉及到。欢迎在评论区提供其他实现方式，我会及时的整合到目前的Demo中。

接下来我们先来总结一下本篇博客所涉及的四种方式：

- 第一种就是直接在TableView的Cell上使用NSTimer，当然这种方式是有问题的，稍后会介绍。
- 第二种是将NSTimer添加到当前线程所对应的RunLoop中的commonModes中。
- 第三种是通过Dispatch中的TimerSource来实现定时器。
- 第四种是开启一个新的子线程，将NSTimer添加到这个子线程中的RunLoop中，并使用DefaultRunLoopModes来执行。
- 第五种方式就是使用CADisplayLink来实现。

下方我们将会根据具体的示例来详细的介绍以上这五种实现方式。


## 一、在Cell中直接使用NSTimer

首先我们按照常规做法，直接在UITableView的Cell上添加相应的NSTimer, 并使用scheduledTimer执行相应的代码块。这种方式没有什么特殊的就是对Timer的直接使用。下方是我们本部分的Timer的使用代码，当然是使用Swift来实现的，不过与OC的代码差不多。代码如下所示 ：

![](http://images2017.cnblogs.com/blog/545446/201708/545446-20170812234651710-552509521.png)
　　

上述代码比较简单，就是在Cell上添加了一个定时器，然后没1秒更新一次时间，并在Cell的timeLabel上显示，运行效果如下所示。从该运行效果中我们不难发现，当我们滑动TableView时，该定时器就停止了工作。具体原因就是当前线程的RunLoop在TableView滑动时将DefaultMode切换到了TrackingRunLoopMode。因为Timer默认是添加在RunLoop上的DefaultMode上的，当Mode切换后Timer就停止了运行。

但是当停止滑动后，Mode又切换了回来，所以Timer有可以正常工作了。

![](http://images2017.cnblogs.com/blog/545446/201708/545446-20170812234843632-548403106.gif)
 

为了进一步看一下Mode的切换，我们可以在相应的地方获取当前线程的RunLoop并且打印对应的Mode。下方代码就是在TableView所对应的VC上添加的，我们在viewDidLoad()、viewDidAppear()以及scrollViewDidScroll()这个代理方法中对当前线程所对应的RunLoop下的currentMode进行了打印，其代码如下。

![](http://images2017.cnblogs.com/blog/545446/201708/545446-20170812235610273-214210563.png)

![](http://images2017.cnblogs.com/blog/545446/201708/545446-20170812235628882-2059628181.png)
　　

　　

 

下方就是最终的运行结果。从输出结果中我们不难看出，在viewDidLoad()方法中打印的Current Mode为UIInitializationRunLoopMode, 从该Mode的名字中我们不难发现，该Mode负责UI的初始化。在viewDidApperar()方法中，也就是UI显示后，RunLoop的Mode切换成了kCFRunLoopDefaultMode。紧接着，我们去滑动TableView，然后在scrollViewDidScroll()代理方法中打印滑动时当前RunLoop所对应的Mode。从下方运行结果不难看出，当TableView滑动时，打印出的currentModel为UITrackingRunLoopMode。当停止滑动后，点击Show Current Mode按钮获取当前Mode时，打印的有时RunLoopDefaultMode。具体如下所示：

![](http://images2017.cnblogs.com/blog/545446/201708/545446-20170812235903413-1529998349.gif)
　　 

 

 

## 二、将Timer添加到CommonMode中

上一部分的定时器是不能正常运行的，因为NSTimer对象默认添加到了当前RunLoop的DefaultMode中，而在切换成TrackingRunLoopMode时，定时器就停止了工作。解决该问题最直接方法是，将NSTimer在TrackingRunLoopMode中也添加一份。这样的话无论是在DefaultMode还是TrackingRunLoopMode中，定时器都会正常的工作。

如果你对RunLoop比较熟悉的话，可以知道CommonModes就是DefaultMode和TrackingRunLoopMode的集合，所以我们只需要将NSTimer对象与当前线程所对应的RunLoop中的CommonModes关联即可，具体代码如下所示：

![](http://images2017.cnblogs.com/blog/545446/201708/545446-20170813102430820-1526493317.png)

 

上述代码与第一部分的代码不同的地方在于我们将创建好的定时器添加到了当前RunLoop中的CommonModes中，这样的话可以保证TableView在滑动时定时器也可以正常运行。上述代码最终的运行效果如下所示。

![](http://images2017.cnblogs.com/blog/545446/201708/545446-20170813102623820-1408094441.gif)

　　

从该运行效果我们不难发现，当该TableView滚动式，其Cell上的定时器是可以正常工作的。但是当我们滑动右上角的这个TableView时，第一个的TableView中的定时器也是不能正常工作的，因为这些TableView都在主线程中工作，也就是说这些TableView所在的RunLoop是同一个。

 

 

## 三、将Timer添加到子线程的RunLoop下的DefaultMode中

接下来我们来看另一种解决方案，就是开启一个新的子线程，然后将Timer添加到这个子线程所对应的RunLoop中。当然因为是子线程的RunLoop，在添加Timer时，我们可以将Timer添加到子线程中的RunLoop中的DefaultMode中。添加完毕后，手动运行该RunLoop。

因为是在子线程中添加的Timer, Timer肯定是在子线程中工作的，所以在更新UI时，我们需要在主线程中进行更新，具体代码如下所示：

![](http://images2017.cnblogs.com/blog/545446/201708/545446-20170813104240617-372106676.png)

 

在上述代码中我们可以看到我们使用全局的并行队列来异步创建了一个Timer对象，然后将该对象添加进了该异步线程中的DefaultRunLoopMode中，然后运行该RunLoop。当然在子线程中更新UI还是需要在主线程中去操作的。下方就是上述代码的运行效果。从该效果中我们不难看出，当滑动TableView时定时器是可以正常工作的。

![](http://images2017.cnblogs.com/blog/545446/201708/545446-20170813105002617-213721415.gif)

　　

 

 

## 四、DispatchTimerSource

接下来我们就不使用NSTimer来实现定时器了。在之前的博客中聊GCD时其中用到了DispatchTimerSource来实现定时器。接下来我们就在TableView的Cell上添加DispatchTimerSource，然后看一下运行效果。当然下方代码片段我们是在全局队列中添加的DispatchTimerSource，在主线程中进行更新。当然我们也可以在mainQueue中添加DispatchTimerSource，这样也是可以正常工作的。当然我们不建议在MainQueue中做，因为在编程时尽量的把一些和主线程关联不太大的操作放到子线程中去做。代码如下所示：

![](http://images2017.cnblogs.com/blog/545446/201708/545446-20170813110732570-333313652.png)
　　

 

接下来我们来看一下上述的代码的运行效果，从该效果中我们可以看出该定时器是可以正常工作的。

![](http://images2017.cnblogs.com/blog/545446/201708/545446-20170813111058945-1555603117.gif)

　　

 

 

## 五、CADisplayLink

接下来我们来使用CADisplayLink来实现定时器功能，在之前的博客中我们也使用过CADisplayLink，不过是用来计算FPS的。下方代码片段中我们就使用CADisplayLink来实现的定时器。CADisplayLink可以添加到RunLoop中，RunLoop的每一次循环都会触发CADisplayLink所关联的方法。在屏幕不卡顿的情况下，每次循环的时间时1/60秒。

下方代码，为了不让屏幕的卡顿等引起的主线程所对应的RunLoop阻塞所造成的定时器不精确的问题。我们开启了一个新的线程，并且将CADisplayLink对象添加到这个子线程的RunLoop中，然后在主线程中更新UI即可。具体代码如下：

![](http://images2017.cnblogs.com/blog/545446/201708/545446-20170813121236898-528406294.png)
　　

 

我们对上述代码运行，下方是其对应的运行结果。从下方运行结果中我们不难看出，在TableView滚动时该定时器也是可以正常运行的。当然该方式实现的定时器的精度是比较高的。

![](http://images2017.cnblogs.com/blog/545446/201708/545446-20170813121850554-1811438680.gif)
　　

 

经过上述五大部分，我们罗列了定时器的几种实现方式，通过对比我们不难发现其优劣性。上述定时器中DispatchSourceTime以及CADisplayLink的精度要比NSTimer的精度要高。从代码实现中我们不难看出CADisplayLink的精度是比较高的。
