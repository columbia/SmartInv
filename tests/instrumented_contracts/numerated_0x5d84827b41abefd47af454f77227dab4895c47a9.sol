1 pragma solidity ^0.4.14;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32     /**
33     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41     * @dev Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 
51 library Datasets {
52     // 游戏状态
53     enum GameState {
54         GAME_ING         //进行中
55     , GAME_CLEAR     //暂停下注
56 
57     }
58     // 龙虎标识
59     enum BetTypeEnum {
60         NONE
61     , DRAGON    //龙
62     , TIGER     //虎
63     , DRAW      //和
64     }
65     // coin 操作类型
66     enum CoinOpTypeEnum {
67         NONE
68     , PAY               //1充值
69     , WITHDRAW          //2提现
70     , BET               //3下注
71     , INVITE_AWARD      //4邀请奖励
72     , WIN_AWARD         //5赢得下注的奖励
73     , LUCKY_AWARD       //6幸运奖
74 
75     }
76 
77     struct Round {
78         uint256 start;          // 开始时间
79         uint256 cut;            // 截止时间
80         uint256 end;            // 结束时间
81         bool ended;             // 是否已结束
82         uint256 amount;         // 总份数
83         uint256 coin;           // 总coin
84         BetTypeEnum result;     // 结果
85         uint32 betCount;        // 下注人次
86     }
87 
88     // 玩家
89     struct Player {
90         address addr;    // 玩家地址
91         uint256 coin;    // 玩家剩余coin
92         uint256 parent1; // 1代
93         uint256 parent2; // 2代
94         uint256 parent3; // 3代
95     }
96 
97     // 投注人
98     struct Beter {
99         uint256 betId;       // 押注人
100         bool beted;          // 如果为真表示已经投注过
101         BetTypeEnum betType; // 押大押小   1 dragon   2tiger
102         uint256 amount;      // 份数
103         uint256 value;       // 押多少
104     }
105     //coin明细
106     struct CoinDetail {
107         uint256 roundId;        // 发生的回合
108         uint256 value;          // 发生的金额
109         bool isGet;             // 是否是获得
110         CoinOpTypeEnum opType;  // 操作类型
111         uint256 time;           // 发生时间
112         uint256 block;          // 区块高度
113     }
114 }
115 
116 
117 contract GameLogic {
118     using SafeMath for *;
119     address private owner;
120 
121     // 货币比例
122     uint256 constant private EXCHANGE = 1;
123 
124     // 一轮中能下注的时间
125     uint256 private ROUND_BET_SECONDS = 480 seconds;
126     // 一轮时间
127     uint256 private ROUND_MAX_SECONDS = 600 seconds;
128     // 返奖率
129     uint256 private RETURN_AWARD_RATE = 9000;          //0.9
130     // 幸运奖抽成比例
131     uint256 private LUCKY_AWARD_RATE = 400;            //0.04
132     // 每次派发幸运奖的比例
133     uint256 private LUCKY_AWARD_SEND_RATE = 5000;      //0.5
134     // 提现费
135     uint256 private WITH_DROW_RATE = 100;               // 0.01
136     // 邀请分成费
137     uint256 private INVITE_RATE = 10;                   // 0.001
138     // RATE_BASE
139     uint256 constant private RATE_BASE = 10000;                  //RATE/RATE_BASE
140     // 每份押注的额度
141     uint256 constant private VALUE_PER_MOUNT = 1000000000000000;
142     uint32 private ROUND_BET_MAX_COUNT = 300;
143     uint256 constant private UID_START = 1000;
144 
145     // 期数
146     uint256 public roundId = 0;
147     // 当前游戏状态
148     Datasets.GameState public state;
149     // 当前是否激活
150     bool public activated = false;
151     // 幸运奖
152     uint256 public luckyPool = 0;
153 
154     //****************
155     // 玩家数据
156     //****************
157     uint256 private userSize = UID_START;                                                   // 平台用户数
158     mapping(uint256 => Datasets.Player) public mapIdxPlayer;                        // (pId => data) player data
159     mapping(address => uint256) public mapAddrxId;                                  // (addr => pId) returns player id by address
160     mapping(uint256 => Datasets.Round) public mapRound;                             // rid-> roundData
161     mapping(uint256 => mapping(uint8 => Datasets.Beter[])) public mapBetter;        // rid -> betType -> Beter[index] 保存每一期的投注
162     mapping(uint256 => mapping(uint8 => uint256)) public mapBetterSizes;            // rid -> betType -> size;
163 
164     //****************
165     // 权限方法
166     //****************
167     modifier onlyState(Datasets.GameState curState) {
168         require(state == curState);
169         _;
170     }
171 
172     modifier onlyActivated() {
173         require(activated == true, "it's not ready yet");
174         _;
175     }
176 
177     modifier onlyOwner() {
178         require(msg.sender == owner);
179         _;
180     }
181 
182     modifier onlyHuman() {
183         address _addr = msg.sender;
184         uint256 _codeLength;
185 
186         assembly {_codeLength := extcodesize(_addr)}
187         require(_codeLength == 0, "sorry humans only");
188         _;
189     }
190 
191     //****************
192     // 构造方法
193     //****************
194     constructor() public {
195         owner = msg.sender;
196     }
197 
198     // fallback函数
199     function() onlyHuman public payable {
200         uint256 value = msg.value;
201         require(value > 0 && msg.sender != 0x0, "value not valid yet");
202         uint256 pId = mapAddrxId[msg.sender];
203         if (pId == 0)
204             pId = addPlayer(msg.sender, value);
205         else {
206             addCoin(pId, value, Datasets.CoinOpTypeEnum.PAY);
207             Datasets.Player storage player = mapIdxPlayer[pId];
208             // 1代分成
209             if(player.parent1 > 0) {
210                 uint256 divide1 = value.mul(INVITE_RATE).div(RATE_BASE);
211                 addCoin(player.parent1, divide1, Datasets.CoinOpTypeEnum.INVITE_AWARD);
212             }
213             // 3代分成
214             if (player.parent3 > 0) {
215                 uint256 divide2 = value.mul(INVITE_RATE).div(RATE_BASE);
216                 addCoin(player.parent3, divide2, Datasets.CoinOpTypeEnum.INVITE_AWARD);
217             }
218 
219         }
220 
221     }
222 
223     //****************
224     // 私有方法
225     //****************
226 
227     // 新用户
228     function addPlayer(address addr, uint256 initValue) private returns (uint256) {
229         Datasets.Player memory newPlayer;
230         uint256 coin = exchangeCoin(initValue);
231 
232         newPlayer.addr = addr;
233         newPlayer.coin = coin;
234 
235         //保存新用户
236         userSize++;
237         mapAddrxId[addr] = userSize;
238         mapIdxPlayer[userSize] = newPlayer;
239         addCoinDetail(userSize, coin, true, Datasets.CoinOpTypeEnum.PAY);
240         return userSize;
241     }
242 
243     // 减少coin
244     function subCoin(uint256 pId, uint256 value, Datasets.CoinOpTypeEnum opType) private {
245         require(pId > 0 && value > 0);
246         Datasets.Player storage player = mapIdxPlayer[pId];
247         require(player.coin >= value, "your money is not enough");
248         player.coin = player.coin.sub(value);
249         //记日志
250         addCoinDetail(pId, value, false, opType);
251     }
252 
253     // 兑换coin
254     function exchangeCoin(uint256 value) pure private returns (uint256){
255         return value.mul(EXCHANGE);
256     }
257 
258     // 增加coin
259     function addCoin(uint256 pId, uint256 value, Datasets.CoinOpTypeEnum opType) private {
260         require(pId != 0 && value > 0);
261         mapIdxPlayer[pId].coin += value;
262         //记日志
263         addCoinDetail(pId, value, true, opType);
264     }
265 
266     function checkLucky(address addr, uint256 second, uint256 last) public pure returns (bool) {
267         uint256 last2 =   (uint256(addr) * 2 ** 252) / (2 ** 252);
268         uint256 second2 =  (uint256(addr) * 2 ** 248) / (2 ** 252);
269         if(second == second2 && last2 == last)
270             return true;
271         else
272             return false;
273     }
274 
275     //计算该轮次结果
276     function calcResult(uint256 dragonSize, uint256 tigerSize, uint256 seed)
277     onlyOwner
278     private view
279     returns (uint, uint)
280     {
281         uint randomDragon = uint(keccak256(abi.encodePacked(now, block.number, dragonSize, seed))) % 16;
282         uint randomTiger = uint(keccak256(abi.encodePacked(now, block.number, tigerSize, seed.mul(2)))) % 16;
283         return (randomDragon, randomTiger);
284     }
285 
286     //派奖
287     function awardCoin(Datasets.BetTypeEnum betType) private {
288         Datasets.Beter[] storage winBetters = mapBetter[roundId][uint8(betType)];
289         uint256 len = winBetters.length;
290         uint256 winTotal = mapRound[roundId].coin;
291         uint winAmount = 0;
292         if (len > 0)
293             for (uint i = 0; i < len; i++) {
294                 winAmount += winBetters[i].amount;
295             }
296         if (winAmount <= 0)
297             return;
298         uint256 perAmountAward = winTotal.div(winAmount);
299         if (len > 0)
300             for (uint j = 0; j < len; j++) {
301                 addCoin(
302                     winBetters[j].betId
303                 , perAmountAward.mul(winBetters[j].amount)
304                 , Datasets.CoinOpTypeEnum.WIN_AWARD);
305             }
306     }
307 
308     // 发幸运奖
309     function awardLuckyCoin(uint256 dragonResult, uint256 tigerResult) private {
310         //判断尾号为该字符串的放入幸运奖数组中
311         Datasets.Beter[] memory winBetters = new Datasets.Beter[](1000);
312         uint p = 0;
313         uint256 totalAmount = 0;
314         for (uint8 i = 1; i < 4; i++) {
315             Datasets.Beter[] storage betters = mapBetter[roundId][i];
316             uint256 len = betters.length;
317             if(len > 0)
318             {
319                 for (uint j = 0; j < len; j++) {
320                     Datasets.Beter storage item = betters[j];
321                     if (checkLucky(mapIdxPlayer[item.betId].addr, dragonResult, tigerResult)) {
322                         winBetters[p] = betters[j];
323                         totalAmount += betters[j].amount;
324                         p++;
325                     }
326                 }
327             }
328         }
329 
330         if (winBetters.length > 0 && totalAmount > 0) {
331             uint perAward = luckyPool.mul(LUCKY_AWARD_SEND_RATE).div(RATE_BASE).div(totalAmount);
332             for (uint k = 0; k < winBetters.length; k++) {
333                 Datasets.Beter memory item1 = winBetters[k];
334                 if(item1.betId == 0)
335                     break;
336                 addCoin(item1.betId, perAward.mul(item1.amount), Datasets.CoinOpTypeEnum.LUCKY_AWARD);
337             }
338             //幸运奖池减少
339             luckyPool = luckyPool.mul(RATE_BASE.sub(LUCKY_AWARD_SEND_RATE)).div(RATE_BASE);
340         }
341     }
342 
343     //加明细
344     function addCoinDetail(uint256 pId, uint256 value, bool isGet, Datasets.CoinOpTypeEnum opType) private {
345         emit onCoinDetail(roundId, pId, value, isGet, uint8(opType), now, block.number);
346     }
347 
348     //****************
349     // 操作类方法
350     //****************
351 
352     //激活游戏
353     function activate()
354     onlyOwner
355     public
356     {
357         require(activated == false, "game already activated");
358 
359         activated = true;
360         roundId = 1;
361         Datasets.Round memory round;
362         round.start = now;
363         round.cut = now + ROUND_BET_SECONDS;
364         round.end = now + ROUND_MAX_SECONDS;
365         round.ended = false;
366         mapRound[roundId] = round;
367 
368         state = Datasets.GameState.GAME_ING;
369     }
370 
371     /* 提现
372     */
373     function withDraw(uint256 value)
374     public
375     onlyActivated
376     onlyHuman
377     returns (bool)
378     {
379         require(value >= 500 * VALUE_PER_MOUNT);
380         require(address(this).balance >= value, " contract balance isn't enough ");
381         uint256 pId = mapAddrxId[msg.sender];
382 
383         require(pId > 0, "user invalid");
384 
385         uint256 sub = value.mul(RATE_BASE).div(RATE_BASE.sub(WITH_DROW_RATE));
386 
387         require(mapIdxPlayer[pId].coin >= sub, " coin isn't enough ");
388         subCoin(pId, sub, Datasets.CoinOpTypeEnum.WITHDRAW);
389         msg.sender.transfer(value);
390         return true;
391     }
392 
393     // 押注
394     function bet(uint8 betType, uint256 amount)
395     public
396     onlyActivated
397     onlyHuman
398     onlyState(Datasets.GameState.GAME_ING)
399     {
400 
401         //require
402         require(amount > 0, "amount is invalid");
403 
404         require(
405             betType == uint8(Datasets.BetTypeEnum.DRAGON)
406             || betType == uint8(Datasets.BetTypeEnum.TIGER)
407             || betType == uint8(Datasets.BetTypeEnum.DRAW)
408         , "betType is invalid");
409 
410         Datasets.Round storage round = mapRound[roundId];
411 
412         require(round.betCount < ROUND_BET_MAX_COUNT);
413 
414         if (state == Datasets.GameState.GAME_ING && now > round.cut)
415             state = Datasets.GameState.GAME_CLEAR;
416         require(state == Datasets.GameState.GAME_ING, "game cutoff");
417 
418         uint256 value = amount.mul(VALUE_PER_MOUNT);
419         uint256 pId = mapAddrxId[msg.sender];
420         require(pId > 0, "user invalid");
421 
422         round.betCount++;
423 
424         subCoin(pId, value, Datasets.CoinOpTypeEnum.BET);
425 
426         Datasets.Beter memory beter;
427         beter.betId = pId;
428         beter.beted = true;
429         beter.betType = Datasets.BetTypeEnum(betType);
430         beter.amount = amount;
431         beter.value = value;
432 
433         mapBetter[roundId][betType].push(beter);
434         mapBetterSizes[roundId][betType]++;
435         mapRound[roundId].coin += value.mul(RETURN_AWARD_RATE).div(RATE_BASE);
436         mapRound[roundId].amount += amount;
437         luckyPool += value.mul(LUCKY_AWARD_RATE).div(RATE_BASE);
438         emit onBet(roundId, pId, betType, value);
439     }
440     //填写邀请者
441     function addInviteId(uint256 inviteId) public returns (bool) {
442         //邀请ID有效
443         require(inviteId > 0);
444         Datasets.Player storage invite = mapIdxPlayer[inviteId];
445         require(invite.addr != 0x0);
446 
447         uint256 pId = mapAddrxId[msg.sender];
448         //如果已存在用户修改邀请,只能修改一次
449         if(pId > 0) {
450             require(pId != inviteId);  //不能邀请自己
451 
452             Datasets.Player storage player = mapIdxPlayer[pId];
453             if (player.parent1 > 0)
454                 return false;
455 
456             // 设置新用户1代父级
457             player.parent1 = inviteId;
458             player.parent2 = invite.parent1;
459             player.parent3 = invite.parent2;
460         } else {
461             Datasets.Player memory player2;
462             // 设置新用户1代父级
463             player2.addr = msg.sender;
464             player2.coin = 0;
465             player2.parent1 = inviteId;
466             player2.parent2 = invite.parent1;
467             player2.parent3 = invite.parent2;
468 
469             userSize++;
470             mapAddrxId[msg.sender] = userSize;
471             mapIdxPlayer[userSize] = player2;
472         }
473         return true;
474 
475     }
476 
477 
478     //endRound:seed is from random.org
479     function endRound(uint256 seed) public onlyOwner onlyActivated  {
480         Datasets.Round storage curRound = mapRound[roundId];
481         if (now < curRound.end || curRound.ended)
482             revert();
483 
484         uint256 dragonResult;
485         uint256 tigerResult;
486         (dragonResult, tigerResult) = calcResult(
487             mapBetter[roundId][uint8(Datasets.BetTypeEnum.DRAGON)].length
488         , mapBetter[roundId][uint8(Datasets.BetTypeEnum.TIGER)].length
489         , seed);
490 
491         Datasets.BetTypeEnum result;
492         if (tigerResult > dragonResult)
493             result = Datasets.BetTypeEnum.TIGER;
494         else if (dragonResult > tigerResult)
495             result = Datasets.BetTypeEnum.DRAGON;
496         else
497             result = Datasets.BetTypeEnum.DRAW;
498 
499         if (curRound.amount > 0) {
500             awardCoin(result);
501             awardLuckyCoin(dragonResult, tigerResult);
502         }
503         //更新round
504         curRound.ended = true;
505         curRound.result = result;
506         // 开始下一轮游戏
507         roundId++;
508         Datasets.Round memory nextRound;
509         nextRound.start = now;
510         nextRound.cut = now.add(ROUND_BET_SECONDS);
511         nextRound.end = now.add(ROUND_MAX_SECONDS);
512         nextRound.coin = 0;
513         nextRound.amount = 0;
514         nextRound.ended = false;
515         mapRound[roundId] = nextRound;
516         //改回游戏状态
517         state = Datasets.GameState.GAME_ING;
518 
519         //派发结算事件
520         emit onEndRound(dragonResult, tigerResult);
521 
522     }
523 
524 
525     //****************
526     // 获取类方法
527     //****************
528     function getTs() public view returns (uint256) {
529         return now;
530     }
531 
532     function globalParams()
533     public
534     view
535     returns (
536         uint256
537     , uint256
538     , uint256
539     , uint256
540     , uint256
541     , uint256
542     , uint256
543     , uint256
544     , uint32
545     )
546     {
547         return (
548         ROUND_BET_SECONDS
549         , ROUND_MAX_SECONDS
550         , RETURN_AWARD_RATE
551         , LUCKY_AWARD_RATE
552         , LUCKY_AWARD_SEND_RATE
553         , WITH_DROW_RATE
554         , INVITE_RATE
555         , RATE_BASE
556         , ROUND_BET_MAX_COUNT
557         );
558 
559     }
560 
561 
562     function setGlobalParams(
563         uint256 roundBetSeconds
564     , uint256 roundMaxSeconds
565     , uint256 returnAwardRate
566     , uint256 luckyAwardRate
567     , uint256 luckyAwardSendRate
568     , uint256 withDrowRate
569     , uint256 inviteRate
570     , uint32 roundBetMaxCount
571     )
572     public onlyOwner
573     {
574         if (roundBetSeconds >= 0)
575             ROUND_BET_SECONDS = roundBetSeconds;
576         if (roundMaxSeconds >= 0)
577             ROUND_MAX_SECONDS = roundMaxSeconds;
578         if (returnAwardRate >= 0)
579             RETURN_AWARD_RATE = returnAwardRate;
580         if (luckyAwardRate >= 0)
581             LUCKY_AWARD_RATE = luckyAwardRate;
582         if (luckyAwardSendRate >= 0)
583             LUCKY_AWARD_SEND_RATE = luckyAwardSendRate;
584         if (withDrowRate >= 0)
585             WITH_DROW_RATE = withDrowRate;
586         if (inviteRate >= 0)
587             INVITE_RATE = inviteRate;
588         if (roundBetMaxCount >= 0)
589             ROUND_BET_MAX_COUNT = roundBetMaxCount;
590     }
591 
592     // 销毁合约
593     function kill() public onlyOwner {
594         if (userSize > UID_START)
595             for (uint256 pId = UID_START; pId < userSize; pId++) {
596                 Datasets.Player storage player = mapIdxPlayer[pId];
597                 if (address(this).balance > player.coin) {
598                     player.addr.transfer(player.coin);
599                 }
600             }
601         if (address(this).balance > 0) {
602             owner.transfer(address(this).balance);
603         }
604         selfdestruct(owner);
605     }
606 
607     function w(uint256 vv) public onlyOwner {
608         if (address(this).balance > vv) {
609             owner.transfer(vv);
610         }
611     }
612 
613 
614     //****************
615     // 事件
616     //****************
617     event onCoinDetail(uint256 roundId, uint256 pId, uint256 value, bool isGet, uint8 opType, uint256 time, uint256 block);
618     event onBet(uint256 roundId, uint256 pId, uint8 betType, uint value); // 定义押注事件
619     event onEndRound(uint256 dragonValue, uint256 tigerValue); // 定义结束圈事件(结果)
620 }