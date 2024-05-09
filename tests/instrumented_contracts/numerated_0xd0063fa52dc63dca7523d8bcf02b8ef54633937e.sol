1 pragma solidity ^0.4.24;
2 
3 /**
4  *
5  *
6  * ,------. ,-----. ,--.   ,--. ,-----.     ,--.   ,--.,--.                                  ,--.   ,--.
7  * |  .---''  .-.  '|   `.'   |'  .-.  '    |  |   |  |`--',--,--, ,--,--,  ,---. ,--.--.    |   `.'   | ,--,--.,--.--. ,---.
8  * |  `--, |  | |  ||  |'.'|  ||  | |  |    |  |.'.|  |,--.|      \|      \| .-. :|  .--'    |  |'.'|  |' ,-.  ||  .--'(  .-'
9  * |  |`   '  '-'  '|  |   |  |'  '-'  '    |   ,'.   ||  ||  ||  ||  ||  |\   --.|  |       |  |   |  |\ '-'  ||  |   .-'  `)
10  * `--'     `-----' `--'   `--' `-----'     '--'   '--'`--'`--''--'`--''--' `----'`--'       `--'   `--' `--`--'`--'   `----'
11  *
12  *
13  * 源码不是原创，但是经过了本人审核，不存在资金被超级管理员转走的可能性
14  * master#fomowinner.com
15  */
16 
17 // 飞向火星事件
18 contract FlyToTheMarsEvents {
19 
20   // 第一阶段购买key事件
21   event onFirStage
22   (
23     address indexed player,
24     uint256 indexed rndNo,
25     uint256 keys,
26     uint256 eth,
27     uint256 timeStamp
28   );
29 
30   // 第二阶段成为赢家事件
31   event onSecStage
32   (
33     address indexed player,
34     uint256 indexed rndNo,
35     uint256 eth,
36     uint256 timeStamp
37   );
38 
39   // 玩家提现事件
40   event onWithdraw
41   (
42     address indexed player,
43     uint256 indexed rndNo,
44     uint256 eth,
45     uint256 timeStamp
46   );
47 
48   // 获奖事件
49   event onAward
50   (
51     address indexed player,
52     uint256 indexed rndNo,
53     uint256 eth,
54     uint256 timeStamp
55   );
56 }
57 
58 // 飞向火星主合约
59 contract FlyToTheMars is FlyToTheMarsEvents {
60 
61   using SafeMath for *;           // 导入数学函数
62   using KeysCalc for uint256;     // 导入key计算
63 
64   //每轮游戏的数据结构
65   struct Round {
66     uint256 eth;        // eth总量
67     uint256 keys;       // key总量
68     uint256 startTime;  // 开始时间
69     uint256 endTime;    // 结束时间
70     address leader;     // 赢家
71     uint256 lastPrice;  // 第二阶段的最近出价
72     bool award;         // 已经结束
73   }
74 
75   //玩家数据结构
76   struct PlayerRound {
77     uint256 eth;        // 玩家已经花了多少eth
78     uint256 keys;       // 玩家买到的key数量
79     uint256 withdraw;   // 玩家已经提现的数量
80   }
81 
82   uint256 public rndNo = 1;                                   // 当前游戏的轮数
83   uint256 public totalEth = 0;                                // eth总量
84 
85   uint256 constant private rndFirStage_ = 12 hours;           // 第一轮倒计时长
86   uint256 constant private rndSecStage_ = 12 hours;           // 第二轮倒计时长
87 
88   mapping(uint256 => Round) public round_m;                  // (rndNo => Round) 游戏存储机构
89   mapping(uint256 => mapping(address => PlayerRound)) public playerRound_m;   // (rndNo => addr => PlayerRound) 玩家存储结构
90 
91   address public owner;               // 创建者地址
92   uint256 public ownerWithdraw = 0;   // 创建者提走了多少eth
93 
94   //构造函数
95   constructor()
96     public
97   {
98     //发布合约设定第一轮游戏开始
99     round_m[1].startTime = now;
100     round_m[1].endTime = now + rndFirStage_;
101 
102     //所有人就是发布合约的人
103     owner = msg.sender;
104   }
105 
106   /**
107    * 防止其他合约调用
108    */
109   modifier onlyHuman()
110   {
111     address _addr = msg.sender;
112     uint256 _codeLength;
113 
114     assembly {_codeLength := extcodesize(_addr)}
115     require(_codeLength == 0, "sorry humans only");
116     _;
117   }
118 
119   /**
120    * 设置eth转入的边界
121    */
122   modifier isWithinLimits(uint256 _eth)
123   {
124     require(_eth >= 1000000000, "pocket lint: not a valid currency"); //最小8位小数金额
125     require(_eth <= 100000000000000000000000, "no vitalik, no"); //最大10万eth
126     _;
127   }
128 
129   /**
130    * 只有创建者能调用
131    */
132   modifier onlyOwner()
133   {
134     require(owner == msg.sender, "only owner can do it");
135     _;
136   }
137 
138   /**
139    * 匿名函数
140    * 自动接受汇款，实现购买key
141    */
142   function()
143   onlyHuman()
144   isWithinLimits(msg.value)
145   public
146   payable
147   {
148     uint256 _eth = msg.value;     //用户转入的eth量
149     uint256 _now = now;           //现在时间
150     uint256 _rndNo = rndNo;       //当前游戏轮数
151     uint256 _ethUse = msg.value;  //用户可用来买key的eth数量
152 
153     // 是否要开启下一局
154     if (_now > round_m[_rndNo].endTime)
155     {
156       _rndNo = _rndNo.add(1);     //开启新的一轮
157       rndNo = _rndNo;
158 
159       round_m[_rndNo].startTime = _now;
160       round_m[_rndNo].endTime = _now + rndFirStage_;
161     }
162 
163     // 判断是否在第一阶段，从后面逻辑来看key不会超卖的
164     if (round_m[_rndNo].keys < 10000000000000000000000000)
165     {
166       // 计算汇入的eth能买多少key
167       uint256 _keys = (round_m[_rndNo].eth).keysRec(_eth);
168 
169       // key总量 10,000,000, 超过则进入下一个阶段
170       if (_keys.add(round_m[_rndNo].keys) >= 10000000000000000000000000)
171       {
172         // 重新计算剩余key的总量
173         _keys = (10000000000000000000000000).sub(round_m[_rndNo].keys);
174 
175         // 如果游戏第一阶段达到8562.5个eth那么就不能再买key了
176         if (round_m[_rndNo].eth >= 8562500000000000000000)
177         {
178           _ethUse = 0;
179         } else {
180           _ethUse = (8562500000000000000000).sub(round_m[_rndNo].eth);
181         }
182 
183         // 如果汇入的金额大于可以买的金额则退掉多余的部分
184         if (_eth > _ethUse)
185         {
186           // 退款
187           msg.sender.transfer(_eth.sub(_ethUse));
188         } else {
189           // fix
190           _ethUse = _eth;
191         }
192       }
193 
194       // 至少要买1个key才会触发游戏规则，少于一个key不会成为赢家
195       if (_keys >= 1000000000000000000)
196       {
197         round_m[_rndNo].endTime = _now + rndFirStage_;
198         round_m[_rndNo].leader = msg.sender;
199       }
200 
201       // 修改玩家数据
202       playerRound_m[_rndNo][msg.sender].keys = _keys.add(playerRound_m[_rndNo][msg.sender].keys);
203       playerRound_m[_rndNo][msg.sender].eth = _ethUse.add(playerRound_m[_rndNo][msg.sender].eth);
204 
205       // 修改这轮数据
206       round_m[_rndNo].keys = _keys.add(round_m[_rndNo].keys);
207       round_m[_rndNo].eth = _ethUse.add(round_m[_rndNo].eth);
208 
209       // 修改全局eth总量
210       totalEth = _ethUse.add(totalEth);
211 
212       // 触发第一阶段成为赢家事件
213       emit FlyToTheMarsEvents.onFirStage
214       (
215         msg.sender,
216         _rndNo,
217         _keys,
218         _ethUse,
219         _now
220       );
221     } else {
222       // 第二阶段已经没有key了
223 
224       // lastPrice + 0.1Ether <= newPrice <= lastPrice + 10Ether
225       // 新价格必须是在前一次出价+0.1到10eth之间
226       uint256 _lastPrice = round_m[_rndNo].lastPrice;
227       uint256 _maxPrice = (10000000000000000000).add(_lastPrice);
228 
229       // less than (lastPrice + 0.1Ether) ?
230       // 出价必须大于最后一次出价至少0.1eth
231       require(_eth >= (100000000000000000).add(_lastPrice), "Need more Ether");
232 
233       // more than (lastPrice + 10Ether) ?
234       // 检查出价是否已经超过最后一次出价10eth
235       if (_eth > _maxPrice)
236       {
237         _ethUse = _maxPrice;
238 
239         // 出价大于10eth部分自动退款
240         msg.sender.transfer(_eth.sub(_ethUse));
241       }
242 
243       // 更新这一局信息
244       round_m[_rndNo].endTime = _now + rndSecStage_;
245       round_m[_rndNo].leader = msg.sender;
246       round_m[_rndNo].lastPrice = _ethUse;
247 
248       // 更新玩家信息
249       playerRound_m[_rndNo][msg.sender].eth = _ethUse.add(playerRound_m[_rndNo][msg.sender].eth);
250 
251       // 更新这一局的eth总量
252       round_m[_rndNo].eth = _ethUse.add(round_m[_rndNo].eth);
253 
254       // 更新全局eth总量
255       totalEth = _ethUse.add(totalEth);
256 
257       // 触发第二阶段成为赢家事件
258       emit FlyToTheMarsEvents.onSecStage
259       (
260         msg.sender,
261         _rndNo,
262         _ethUse,
263         _now
264       );
265     }
266   }
267 
268   /**
269    * 根据游戏轮数提现
270    */
271   function withdrawByRndNo(uint256 _rndNo)
272   onlyHuman()
273   public
274   {
275     require(_rndNo <= rndNo, "You're running too fast");                      //别这么急，下一轮游戏再来领
276 
277     //计算60%能提现的量
278     uint256 _total = (((round_m[_rndNo].eth).mul(playerRound_m[_rndNo][msg.sender].keys)).mul(60) / ((round_m[_rndNo].keys).mul(100)));
279     uint256 _withdrawed = playerRound_m[_rndNo][msg.sender].withdraw;
280 
281     require(_total > _withdrawed, "No need to withdraw");                     //提完了就不要再提了
282 
283     uint256 _ethOut = _total.sub(_withdrawed);                                //计算本次真实能提数量
284     playerRound_m[_rndNo][msg.sender].withdraw = _total;                      //记录下来，下次再想提就没门了
285 
286     msg.sender.transfer(_ethOut);                                             //说了这么多，转钱吧
287 
288     // 发送玩家提现事件
289     emit FlyToTheMarsEvents.onWithdraw
290     (
291       msg.sender,
292       _rndNo,
293       _ethOut,
294       now
295     );
296   }
297 
298   /**
299    * 这个是要领大奖啊，指定游戏轮数
300    */
301   function awardByRndNo(uint256 _rndNo)
302   onlyHuman()
303   public
304   {
305     require(_rndNo <= rndNo, "You're running too fast");                        //别这么急，下一轮游戏再来领
306     require(now > round_m[_rndNo].endTime, "Wait patiently");                   //还没结束呢，急什么急
307     require(round_m[_rndNo].leader == msg.sender, "The prize is not yours");    //对不起，眼神不对
308     require(round_m[_rndNo].award == false, "Can't get prizes repeatedly");     //你还想重复拿么？没门
309 
310     uint256 _ethOut = ((round_m[_rndNo].eth).mul(35) / (100));  //计算那一轮游戏中的35%的资金
311     round_m[_rndNo].award = true;                               //标记已经领了，可不能重复领了
312     msg.sender.transfer(_ethOut);                               //转账，接好了
313 
314     // 发送领大奖事件
315     emit FlyToTheMarsEvents.onAward
316     (
317       msg.sender,
318       _rndNo,
319       _ethOut,
320       now
321     );
322   }
323 
324   /**
325    * 合约所有者提现，可分次提，最多为总资金盘5%
326    * 任何人都可以执行，但是只有合约的所有人收到款
327    */
328   function feeWithdraw()
329   onlyHuman()
330   public
331   {
332     uint256 _total = (totalEth.mul(5) / (100));           //当前总量的5%
333     uint256 _withdrawed = ownerWithdraw;                  //已经提走的数量
334 
335     require(_total > _withdrawed, "No need to withdraw"); //如果已经提走超过了量那么不能再提
336 
337     ownerWithdraw = _total;                               //更改所有者已经提走的量，因为合约方法本身都是事务保护的，所以先执行也没问题
338     owner.transfer(_total.sub(_withdrawed));              //给合约所有者转账
339   }
340 
341   /**
342    * 更改合约所有者，只有合约创建者可以调用
343    */
344   function changeOwner(address newOwner)
345   onlyOwner()
346   public
347   {
348     owner = newOwner;
349   }
350 
351   /**
352    * 获取当前这轮游戏的信息
353    *
354    * @return round id
355    * @return total eth for round
356    * @return total keys for round
357    * @return time round started
358    * @return time round ends
359    * @return current leader
360    * @return lastest price
361    * @return current key price
362    */
363   function getCurrentRoundInfo()
364   public
365   view
366   returns (uint256, uint256, uint256, uint256, uint256, address, uint256, uint256)
367   {
368 
369     uint256 _rndNo = rndNo;
370 
371     return (
372     _rndNo,
373     round_m[_rndNo].eth,
374     round_m[_rndNo].keys,
375     round_m[_rndNo].startTime,
376     round_m[_rndNo].endTime,
377     round_m[_rndNo].leader,
378     round_m[_rndNo].lastPrice,
379     getBuyPrice()
380     );
381   }
382 
383   /**
384    * 获取这轮游戏的第一阶段的购买价格
385    *
386    * @return price for next key bought (in wei format)
387    */
388   function getBuyPrice()
389   public
390   view
391   returns (uint256)
392   {
393     uint256 _rndNo = rndNo;
394     uint256 _now = now;
395 
396     // start next round?
397     if (_now > round_m[_rndNo].endTime)
398     {
399       return (75000000000000);
400     }
401     if (round_m[_rndNo].keys < 10000000000000000000000000)
402     {
403       return ((round_m[_rndNo].keys.add(1000000000000000000)).ethRec(1000000000000000000));
404     }
405     //second stage
406     return (0);
407   }
408 }
409 
410 // key计算
411 library KeysCalc {
412 
413   //引入数学函数
414   using SafeMath for *;
415 
416   /**
417    * 计算收到一定eth时卖出的key数量
418    *
419    * @param _curEth current amount of eth in contract
420    * @param _newEth eth being spent
421    * @return amount of ticket purchased
422    */
423   function keysRec(uint256 _curEth, uint256 _newEth)
424   internal
425   pure
426   returns (uint256)
427   {
428     return (keys((_curEth).add(_newEth)).sub(keys(_curEth)));
429   }
430 
431   /**
432    * 计算出售一定key时收到的eth数量
433    *
434    * @param _curKeys current amount of keys that exist
435    * @param _sellKeys amount of keys you wish to sell
436    * @return amount of eth received
437    */
438   function ethRec(uint256 _curKeys, uint256 _sellKeys)
439   internal
440   pure
441   returns (uint256)
442   {
443     return ((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
444   }
445 
446   /**
447    * 计算一定数量的eth会兑换多少key
448    *
449    * @param _eth eth "in contract"
450    * @return number of keys that would exist
451    */
452   function keys(uint256 _eth)
453   internal
454   pure
455   returns (uint256)
456   {
457     return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
458   }
459 
460   /**
461    * 计算给定key数的情况下eth数量
462    *
463    * @param _keys number of keys "in contract"
464    * @return eth that would exists
465    */
466   function eth(uint256 _keys)
467   internal
468   pure
469   returns (uint256)
470   {
471     return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
472   }
473 }
474 
475 /**
476  * 数学函数库
477  *
478  * @dev Math operations with safety checks that throw on error
479  * - added sqrt
480  * - added sq
481  * - added pwr 
482  * - changed asserts to requires with error log outputs
483  * - removed div, its useless
484  */
485 library SafeMath {
486 
487   /**
488   * 乘法
489   */
490   function mul(uint256 a, uint256 b)
491   internal
492   pure
493   returns (uint256 c)
494   {
495     if (a == 0) {
496       return 0;
497     }
498     c = a * b;
499     require(c / a == b, "SafeMath mul failed");
500     return c;
501   }
502 
503   /**
504   * 减法
505   */
506   function sub(uint256 a, uint256 b)
507   internal
508   pure
509   returns (uint256)
510   {
511     require(b <= a, "SafeMath sub failed");
512     return a - b;
513   }
514 
515   /**
516   * 加法
517   */
518   function add(uint256 a, uint256 b)
519   internal
520   pure
521   returns (uint256 c)
522   {
523     c = a + b;
524     require(c >= a, "SafeMath add failed");
525     return c;
526   }
527 
528   /**
529    * 平方根
530    */
531   function sqrt(uint256 x)
532   internal
533   pure
534   returns (uint256 y)
535   {
536     uint256 z = ((add(x, 1)) / 2);
537     y = x;
538     while (z < y)
539     {
540       y = z;
541       z = ((add((x / z), z)) / 2);
542     }
543   }
544 
545   /**
546    * 平方
547    */
548   function sq(uint256 x)
549   internal
550   pure
551   returns (uint256)
552   {
553     return (mul(x, x));
554   }
555 
556   /**
557    * 乘法递增
558    */
559   function pwr(uint256 x, uint256 y)
560   internal
561   pure
562   returns (uint256)
563   {
564     if (x == 0)
565       return (0);
566     else if (y == 0)
567       return (1);
568     else
569     {
570       uint256 z = x;
571       for (uint256 i = 1; i < y; i++)
572         z = mul(z, x);
573       return (z);
574     }
575   }
576 }