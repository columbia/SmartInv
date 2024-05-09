1 pragma solidity ^0.4.18;
2 
3 contract DogCoreInterface {
4     address public ceoAddress;
5     address public cfoAddress;
6     function getDog(uint256 _id)
7         external
8         view
9         returns (
10         //冷却期索引号
11         uint256 cooldownIndex,
12         //本次冷却期结束所在区块
13         uint256 nextActionAt,
14         //配种的公狗ID
15         uint256 siringWithId,
16         //出生时间
17         uint256 birthTime,
18         //母亲ID
19         uint256 matronId,
20         //父亲ID
21         uint256 sireId,
22         //代数
23         uint256 generation,
24         //基因
25         uint256 genes,
26         //变异，0表示未变异，1-7表示变异
27         uint8  variation,
28         //0代祖先的ID
29         uint256 gen0
30     );
31     function ownerOf(uint256 _tokenId) external view returns (address);
32     function transferFrom(address _from, address _to, uint256 _tokenId) external;
33     function sendMoney(address _to, uint256 _money) external;
34     function totalSupply() external view returns (uint);
35 }
36 
37 
38 /*
39     LotteryBase 主要定义了开奖信息，奖金池转入函数以及判断是否开必中
40 */
41 contract LotteryBase {
42     
43     // 当前开奖基因位数
44     uint8 public currentGene;
45     // 当前开奖所在区块
46     uint256 public lastBlockNumber;
47     // 随机数种子
48     uint256 randomSeed = 1;
49     // 奖金池地址
50     address public bonusPool;
51     // 中奖信息
52     struct CLottery {
53         // 该期中奖基因
54         uint8[7]        luckyGenes;
55         // 该期奖金池总额
56         uint256         totalAmount;
57         // 该期第7个基因开奖所在区块
58         uint256         openBlock;
59         // 是否发奖完毕
60         bool            isReward;
61         // 未开一等奖标记
62         bool         noFirstReward;
63     }
64     // 历史开奖信息
65     CLottery[] public CLotteries;
66     // 发奖合约地址
67     address public finalLottery;
68     // 蓄奖池金额
69     uint256 public SpoolAmount = 0;
70     // 宠物信息接口
71     DogCoreInterface public dogCore;
72     // 随机开奖事件
73     event OpenLottery(uint8 currentGene, uint8 luckyGenes, uint256 currentTerm, uint256 blockNumber, uint256 totalAmount);
74     //必中开奖事件
75     event OpenCarousel(uint256 luckyGenes, uint256 currentTerm, uint256 blockNumber, uint256 totalAmount);
76     
77     
78     //
79     modifier onlyCEO() {
80         require(msg.sender == dogCore.ceoAddress());
81         _;  
82     }
83     //
84     modifier onlyCFO() {
85         require(msg.sender == dogCore.cfoAddress());
86         _;  
87     }
88     /*
89         蓄奖池转入奖金池函数
90     */
91     function toLotteryPool(uint amount) public onlyCFO {
92         require(SpoolAmount >= amount);
93         SpoolAmount -= amount;
94     }
95     /*
96     判断当期是否开必中
97     */
98     function _isCarousal(uint256 currentTerm) external view returns(bool) {
99        return (currentTerm > 1 && CLotteries[currentTerm - 2].noFirstReward && CLotteries[currentTerm - 1].noFirstReward); 
100     }
101     
102     /*
103       返回当前期数
104     */ 
105     function getCurrentTerm() external view returns (uint256) {
106 
107         return (CLotteries.length - 1);
108     }
109 }
110 
111 
112 /*
113     LotteryGenes主要实现奖宠物原始基因转化为兑奖数组
114 */
115 contract LotteryGenes is LotteryBase {
116     /*
117      将基因数字格式转换为抽奖数组格式
118     */
119     function convertGeneArray(uint256 gene) public pure returns(uint8[7]) {
120         uint8[28] memory geneArray; 
121         uint8[7] memory lotteryArray;
122         uint index = 0;
123         for (index = 0; index < 28; index++) {
124             uint256 geneItem = gene % (2 ** (5 * (index + 1)));
125             geneItem /= (2 ** (5 * index));
126             geneArray[index] = uint8(geneItem);
127         }
128         for (index = 0; index < 7; index++) {
129             uint size = 4 * index;
130             lotteryArray[index] = geneArray[size];
131             
132         }
133         return lotteryArray;
134     }
135 
136     /**
137        将显性基因串拼凑成原始基因数字
138     */ 
139     function convertGene(uint8[7] luckyGenes) public pure returns(uint256) {
140         uint8[28] memory geneArray;
141         for (uint8 i = 0; i < 28; i++) {
142             if (i%4 == 0) {
143                 geneArray[i] = luckyGenes[i/4];
144             } else {
145                 geneArray[i] = 6;
146             }
147         }
148         uint256 gene = uint256(geneArray[0]);
149         
150         for (uint8 index = 1; index < 28; index++) {
151             uint256 geneItem = uint256(geneArray[index]);
152             gene += geneItem << (index * 5);
153         }
154         return gene;
155     }
156 }
157 
158 
159 /*
160     SetLottery主要实现了随机开奖和必中开奖
161 */
162 contract SetLottery is LotteryGenes {
163 
164     function random(uint8 seed) internal returns(uint8) {
165         randomSeed = block.timestamp;
166         return uint8(uint256(keccak256(randomSeed, block.difficulty))%seed)+1;
167     }
168 
169     /*
170      随机开奖函数，每一期开7次。
171      currentGene表示当期开奖的第N个基因
172      若当前currentGene指标为0，则表示在开奖期未开任何数字，或者开奖期已经开完了所有数字
173      当前开奖期最后一个基因开完后，记录当前所在区块号和当前奖金池金额
174      返回值分别为当前开奖基因(0代表不存在)、查询开奖基因(0代表不存在)、
175      开奖状态(0表示开奖成功，1表示当期开奖结束且在等待发奖，2表示当前基因开奖区块与上个基因开奖区块相同,3表示奖金池金额不足)
176      */
177     function openLottery(uint8 _viewId) public returns(uint8,uint8) {
178         uint8 viewId = _viewId;
179         require(viewId < 7);
180         // 获取当前中奖信息
181         uint256 currentTerm = CLotteries.length - 1;
182         CLottery storage clottery = CLotteries[currentTerm];
183 
184         // 如果7个基因都完成开奖并且当期没有发奖，则说明当期所有基因已经开奖完毕在等待发奖，退出
185         if (currentGene == 0 && clottery.openBlock > 0 && clottery.isReward == false) {
186             // 触发事件，返回查询的基因
187             OpenLottery(viewId, clottery.luckyGenes[viewId], currentTerm, 0, 0);
188             //分别返回查询基因，状态1 (表示当期所有基因开奖完毕在等待发奖)
189             return (clottery.luckyGenes[viewId],1);
190         }
191         // 如果上个基因开奖和本次开奖在同一个区块，退出
192         if (lastBlockNumber == block.number) {
193             // 触发事件，返回查询的基因
194             OpenLottery(viewId, clottery.luckyGenes[viewId], currentTerm, 0, 0);
195             //分别返回查询基因，状态2 (当前基因开奖区块与上个基因开奖区块相同)
196             return (clottery.luckyGenes[viewId],2);
197         }
198         // 如果当前开奖基因位为0且当期已经发奖，则进入下一期开奖
199         if (currentGene == 0 && clottery.isReward == true) {
200             // 初始化当前lottery信息
201             CLottery memory _clottery;
202             _clottery.luckyGenes = [0,0,0,0,0,0,0];
203             _clottery.totalAmount = uint256(0);
204             _clottery.isReward = false;
205             _clottery.openBlock = uint256(0);
206             currentTerm = CLotteries.push(_clottery) - 1;
207         }
208 
209         // 如果前两期都没有一等奖产生，则该期产生必中奖，退出随机开奖函数
210         if (this._isCarousal(currentTerm)) {
211             revert();
212         }
213 
214         //开奖结果
215         uint8 luckyNum = 0;
216         
217         if (currentGene == 6) {
218             // 如果奖金池金额为零，则退出
219             if (bonusPool.balance <= SpoolAmount) {
220                 // 触发事件，返回查询的基因
221                 OpenLottery(viewId, clottery.luckyGenes[viewId], currentTerm, 0, 0);
222                 //分别返回查询基因，状态3 (奖金池金额不足)
223                 return (clottery.luckyGenes[viewId],3);
224             }
225             //将随机数赋值给当前基因
226             luckyNum = random(8);
227             CLotteries[currentTerm].luckyGenes[currentGene] = luckyNum;
228             //触发开奖事件
229             OpenLottery(currentGene, luckyNum, currentTerm, block.number, bonusPool.balance);
230             //如果当前为最后一个开奖基因，则下一个开奖基因位为0，同时记录下当前区块号并写入开奖信息，同时将奖金池金额写入开奖信息, 同时启动主合约
231             currentGene = 0;
232             CLotteries[currentTerm].openBlock = block.number;
233             CLotteries[currentTerm].totalAmount = bonusPool.balance;
234             //记录当前开奖所在区块
235             lastBlockNumber = block.number;
236         } else { 
237             //将随机数赋值给当前基因
238         
239             luckyNum = random(12);
240             CLotteries[currentTerm].luckyGenes[currentGene] = luckyNum;
241 
242             //触发开奖事件
243             OpenLottery(currentGene, luckyNum, currentTerm, 0, 0);
244             //其它情况下，下一个开奖基因位加1
245             currentGene ++;
246             //记录当前开奖所在区块
247             lastBlockNumber = block.number;
248         }
249         //分别返回开奖基因，查询基因和开奖成功状态
250         return (luckyNum,0);
251     } 
252 
253     function random2() internal view returns (uint256) {
254         return uint256(uint256(keccak256(block.timestamp, block.difficulty))%uint256(dogCore.totalSupply()) + 1);
255     }
256 
257     /*
258      必中开奖函数,每期开一次
259     */
260     function openCarousel() public {
261         //获取当前开奖信息
262         uint256 currentTerm = CLotteries.length - 1;
263         CLottery storage clottery = CLotteries[currentTerm];
264 
265         // 如果当前开奖基因指针为0且开奖基因存在，且未发奖，则说明当前基因开奖完毕，在等待发奖
266         if (currentGene == 0 && clottery.openBlock > 0 && clottery.isReward == false) {
267 
268             //触发开奖事件,返回当期现有开奖数据
269             OpenCarousel(convertGene(clottery.luckyGenes), currentTerm, clottery.openBlock, clottery.totalAmount);
270         }
271 
272         // 如果开奖基因指针为0且开奖基因存在，并且发奖完毕，则进入下一开奖周期
273         if (currentGene == 0 && clottery.openBlock > 0 && clottery.isReward == true) {
274             CLottery memory _clottery;
275             _clottery.luckyGenes = [0,0,0,0,0,0,0];
276             _clottery.totalAmount = uint256(0);
277             _clottery.isReward = false;
278             _clottery.openBlock = uint256(0);
279             currentTerm = CLotteries.push(_clottery) - 1;
280         }
281 
282         //期数大于3 且前三期未产生特等奖
283         require (this._isCarousal(currentTerm));
284         // 随机获取必中基因
285         uint256 genes = _getValidRandomGenes();
286         require (genes > 0);
287         uint8[7] memory luckyGenes = convertGeneArray(genes);
288         //触发开奖事件
289         OpenCarousel(genes, currentTerm, block.number, bonusPool.balance);
290 
291         //写入记录
292         CLotteries[currentTerm].luckyGenes = luckyGenes;
293         CLotteries[currentTerm].openBlock = block.number;
294         CLotteries[currentTerm].totalAmount = bonusPool.balance;
295         
296     }
297     
298     /*
299       随机获取合法的必中基因
300     */
301     function _getValidRandomGenes() internal view returns (uint256) {
302         uint256 luckyDog = random2();
303         uint256 genes = _validGenes(luckyDog);
304         uint256 totalSupply = dogCore.totalSupply();
305         if (genes > 0) {
306             return genes;
307         }  
308         // 如果dog不能兑奖，则渐进振荡判断其它dog是否满足条件
309         uint256 min = (luckyDog < totalSupply-luckyDog) ? (luckyDog - 1) : totalSupply-luckyDog;
310         for (uint256 i = 1; i < min + 1; i++) {
311             genes = _validGenes(luckyDog - i);
312             if (genes > 0) {
313                 break;
314             }
315             genes = _validGenes(luckyDog + i);
316             if (genes > 0) {
317                     break;
318                 }
319             }
320             // min次震荡仍然未找到可兑奖基因
321         if (genes == 0) {
322             //luckyDog右侧更长
323             if (min == luckyDog - 1) {
324                 for (i = min + luckyDog; i < totalSupply + 1; i++) {
325                         genes = _validGenes(i);
326                         if (genes > 0) {
327                             break;
328                         }
329                     }   
330                 }
331             //luckyDog左侧更长
332             if (min == totalSupply - luckyDog) {
333                 for (i = min; i < luckyDog; i++) {
334                         genes = _validGenes(luckyDog - i - 1);
335                         if (genes > 0) {
336                             break;
337                         }
338                     }   
339                 }
340             }
341         return genes;
342     }
343 
344 
345     /*
346       判断狗是否能兑奖，能则直接返回狗的基因，不能则返回0
347     */
348     function _validGenes(uint256 dogId) internal view returns (uint256) {
349 
350         var(, , , , , ,generation, genes, variation,) = dogCore.getDog(dogId);
351         if (generation == 0 || dogCore.ownerOf(dogId) == finalLottery || variation > 0) {
352             return 0;
353         } else {
354             return genes;
355         }
356     }
357 
358     
359 }
360 
361 /*
362   LotteryCore是开奖函数的入口合约
363   开奖包括必中开奖和随机开奖
364   同时LotteryCore提供对外查询接口
365 */
366 
367 contract LotteryCore is SetLottery {
368     
369     // 构造函数，传入奖金池地址,初始化中奖信息
370     function LotteryCore(address _ktAddress) public {
371 
372         bonusPool = _ktAddress;
373         dogCore = DogCoreInterface(_ktAddress);
374 
375         //初始化中奖信息
376         CLottery memory _clottery;
377         _clottery.luckyGenes = [0,0,0,0,0,0,0];
378         _clottery.totalAmount = uint256(0);
379         _clottery.isReward = false;
380         _clottery.openBlock = uint256(0);
381         CLotteries.push(_clottery);
382     }
383     /*
384     设置FinalLottery地址
385     */
386     function setFinalLotteryAddress(address _flAddress) public onlyCEO {
387         finalLottery = _flAddress;
388     }
389     /*
390     获取当前中奖记录
391     */
392     function getCLottery() 
393         public 
394         view 
395         returns (
396             uint8[7]        luckyGenes,
397             uint256         totalAmount,
398             uint256         openBlock,
399             bool            isReward,
400             uint256         term
401         ) {
402             term = CLotteries.length - uint256(1);
403             luckyGenes = CLotteries[term].luckyGenes;
404             totalAmount = CLotteries[term].totalAmount;
405             openBlock = CLotteries[term].openBlock;
406             isReward = CLotteries[term].isReward;
407     }
408 
409     /*
410     更改发奖状态
411     */
412     function rewardLottery(bool isMore) external {
413         // require contract address is final lottery
414         require(msg.sender == finalLottery);
415 
416         uint256 term = CLotteries.length - 1;
417         CLotteries[term].isReward = true;
418         CLotteries[term].noFirstReward = isMore;
419     }
420 
421     /*
422     转入蓄奖池
423     */
424     function toSPool(uint amount) external {
425         // require contract address is final lottery
426         require(msg.sender == finalLottery);
427 
428         SpoolAmount += amount;
429     }
430 }
431 
432 
433 /*
434     FinalLottery 包含兑奖函数和发奖函数
435     中奖信息flotteries存入开奖期数到[各等奖获奖者，各等奖中奖金额]的映射
436 */
437 contract FinalLottery {
438     bool public isLottery = true;
439     LotteryCore lotteryCore;
440     DogCoreInterface dogCore;
441     uint8[7] public luckyGenes;
442     uint256         totalAmount;
443     uint256         openBlock;
444     bool            isReward;
445     uint256         currentTerm;
446     uint256  public duration;
447     uint8   public  lotteryRatio;
448     uint8[7] public lotteryParam;
449     uint8   public  carousalRatio;
450     uint8[7] public carousalParam; 
451     // 中奖信息
452     struct FLottery {
453         //  该期各等奖获奖者
454         //  一等奖
455         address[]        owners0;
456         uint256[]        dogs0;
457         //  二等奖
458         address[]        owners1;
459         uint256[]        dogs1;
460         //  三等奖
461         address[]        owners2;
462         uint256[]        dogs2;
463         //  四等奖
464         address[]        owners3;
465         uint256[]        dogs3;
466         //  五等奖
467         address[]        owners4;
468         uint256[]        dogs4;
469         //  六等奖
470         address[]        owners5;
471         uint256[]        dogs5;
472         //  七等奖
473         address[]        owners6;
474         uint256[]        dogs6;
475         // 中奖金额
476         uint256[]       reward;
477     }
478     // 兑奖发奖信息
479     mapping(uint256 => FLottery) flotteries;
480     // 构造函数
481     function FinalLottery(address _lcAddress) public {
482         lotteryCore = LotteryCore(_lcAddress);
483         dogCore = DogCoreInterface(lotteryCore.bonusPool());
484         duration = 11520;
485         lotteryRatio = 23;
486         lotteryParam = [46,16,10,9,8,6,5];
487         carousalRatio = 12;
488         carousalParam = [35,18,14,12,8,7,6];
489         
490     }
491     
492     // 发奖事件
493     event DistributeLottery(uint256[] rewardArray, uint256 currentTerm);
494     // 兑奖事件
495     event RegisterLottery(uint256 dogId, address owner, uint8 lotteryClass, string result);
496     // 设置兑奖周期
497     function setLotteryDuration(uint256 durationBlocks) public {
498         require(msg.sender == dogCore.ceoAddress());
499         require(durationBlocks > 140);
500         require(durationBlocks < block.number);
501         duration = durationBlocks;
502     }
503     /*
504      登记兑奖函数,发生在当期开奖结束之后7天内（即40，320个区块内）
505     */
506     function registerLottery(uint256 dogId) public returns (uint8) {
507         uint256 _dogId = dogId;
508         (luckyGenes, totalAmount, openBlock, isReward, currentTerm) = lotteryCore.getCLottery();
509         // 获取当前开奖信息
510         address owner = dogCore.ownerOf(_dogId);
511         // 回收的不能兑奖
512         require (owner != address(this));
513         // 调用者必须是主合约
514         require(address(dogCore) == msg.sender);
515         // 所有基因位开奖完毕（指针为0同时奖金池大于0）且未发奖且未兑奖结束
516         require(totalAmount > 0 && isReward == false && openBlock > (block.number-duration));
517         // 获取该宠物的基因，代数，出生时间
518         var(, , , birthTime, , ,generation,genes, variation,) = dogCore.getDog(_dogId);
519         // 出生日期小于开奖时间
520         require(birthTime < openBlock);
521         // 0代狗不能兑奖
522         require(generation > 0);
523         // 变异的不能兑奖
524         require(variation == 0);
525         // 判断该用户获几等奖，100表示未中奖
526         uint8 _lotteryClass = getLotteryClass(luckyGenes, genes);
527         // 若未获奖则退出
528         require(_lotteryClass < 7);
529         // 避免重复兑奖
530         address[] memory owners;
531         uint256[] memory dogs;
532          (dogs, owners) = _getLuckyList(currentTerm, _lotteryClass);
533             
534         for (uint i = 0; i < dogs.length; i++) {
535             if (_dogId == dogs[i]) {
536             //    revert();
537                 RegisterLottery(_dogId, owner, _lotteryClass,"dog already registered");
538                  return 5;
539             }
540         }
541         // 将登记中奖者的账户存入奖金信息表
542         _pushLuckyInfo(currentTerm, _lotteryClass, owner, _dogId);
543         // 触发兑奖成功事件
544         RegisterLottery(_dogId, owner, _lotteryClass,"successful");
545         return 0;
546     }
547     /*
548     发奖函数，发生在当期开奖结束之后
549     */
550     
551     function distributeLottery() public returns (uint8) {
552         (luckyGenes, totalAmount, openBlock, isReward, currentTerm) = lotteryCore.getCLottery();
553         
554         // 必须在当期开奖结束一周之后发奖
555         require(openBlock > 0 && openBlock < (block.number-duration));
556 
557         //奖金池可用金额必须大于或等于0
558         require(totalAmount >= lotteryCore.SpoolAmount());
559 
560         // 如果已经发奖
561         if (isReward == true) {
562             DistributeLottery(flotteries[currentTerm].reward, currentTerm);
563             return 1;
564         }
565         uint256 legalAmount = totalAmount - lotteryCore.SpoolAmount();
566         uint256 totalDistribute = 0;
567         uint8[7] memory lR;
568         uint8 ratio;
569 
570         // 必中和随机两种不同的奖金分配比率
571         if (lotteryCore._isCarousal(currentTerm) ) {
572             lR = carousalParam;
573             ratio = carousalRatio;
574         } else {
575             lR = lotteryParam;
576             ratio = lotteryRatio;
577         }
578         // 计算各奖项金额并分发给中奖者
579         for (uint8 i = 0; i < 7; i++) {
580             address[] memory owners;
581             uint256[] memory dogs;
582             (dogs, owners) = _getLuckyList(currentTerm, i);
583             if (owners.length > 0) {
584                     uint256 reward = (legalAmount * ratio * lR[i])/(10000 * owners.length);
585                     totalDistribute += reward * owners.length;
586                     // 转给CFO的手续费（10%）
587                     dogCore.sendMoney(dogCore.cfoAddress(),reward * owners.length/10);
588                     
589                     for (uint j = 0; j < owners.length; j++) {
590                         address gen0Add;
591                         if (i == 0) {
592                             // 转账
593                             dogCore.sendMoney(owners[j],reward*95*9/1000);
594                             // gen0 奖励
595                             gen0Add = _getGen0Address(dogs[j]);
596                             assert(gen0Add != address(0));
597                             dogCore.sendMoney(gen0Add,reward*5/100);
598                         } else if (i == 1) {
599                             // 转账
600                             dogCore.sendMoney(owners[j],reward*97*9/1000);
601                             // gen0 奖励
602                             gen0Add = _getGen0Address(dogs[j]);
603                             assert(gen0Add != address(0));
604                             dogCore.sendMoney(gen0Add,reward*3/100);
605                         } else if (i == 2) {
606                             // 转账
607                             dogCore.sendMoney(owners[j],reward*98*9/1000);
608                             // gen0 奖励
609                             gen0Add = _getGen0Address(dogs[j]);
610                             assert(gen0Add != address(0));
611                             dogCore.sendMoney(gen0Add,reward*2/100);
612                         } else {
613                             // 转账
614                             dogCore.sendMoney(owners[j],reward*9/10);
615                         }
616                     }
617                   // 记录各等奖发奖金额
618                     flotteries[currentTerm].reward.push(reward);  
619                 } else {
620                     flotteries[currentTerm].reward.push(0); 
621                 } 
622         }
623         //没有人登记一等奖中奖，将奖金池5%转入蓄奖池,并且更新无一等奖计数
624         if (flotteries[currentTerm].owners0.length == 0) {
625             lotteryCore.toSPool((lotteryCore.bonusPool().balance - lotteryCore.SpoolAmount())/20);
626             lotteryCore.rewardLottery(true);
627         } else {
628             //发奖完成之后，更新当前奖项状态、将当前奖项加入历史记录
629             lotteryCore.rewardLottery(false);
630         }
631         
632         DistributeLottery(flotteries[currentTerm].reward, currentTerm);
633         return 0;
634     }
635 
636      /*
637     获取狗的gen0祖先的主人账户
638     */
639     function _getGen0Address(uint256 dogId) internal view returns(address) {
640         var(, , , , , , , , , gen0) = dogCore.getDog(dogId);
641         return dogCore.ownerOf(gen0);
642     }
643 
644     /*
645       通过奖项等级获取中奖者列表和中奖狗列表
646     */
647     function _getLuckyList(uint256 currentTerm1, uint8 lotclass) public view returns (uint256[] kts, address[] ons) {
648         if (lotclass==0) {
649             ons = flotteries[currentTerm1].owners0;
650             kts = flotteries[currentTerm1].dogs0;
651         } else if (lotclass==1) {
652             ons = flotteries[currentTerm1].owners1;
653             kts = flotteries[currentTerm1].dogs1;
654         } else if (lotclass==2) {
655             ons = flotteries[currentTerm1].owners2;
656             kts = flotteries[currentTerm1].dogs2;
657         } else if (lotclass==3) {
658             ons = flotteries[currentTerm1].owners3;
659             kts = flotteries[currentTerm1].dogs3;
660         } else if (lotclass==4) {
661             ons = flotteries[currentTerm1].owners4;
662             kts = flotteries[currentTerm1].dogs4;
663         } else if (lotclass==5) {
664             ons = flotteries[currentTerm1].owners5;
665             kts = flotteries[currentTerm1].dogs5;
666         } else if (lotclass==6) {
667             ons = flotteries[currentTerm1].owners6;
668             kts = flotteries[currentTerm1].dogs6;
669         }
670     }
671 
672     /*
673       将owner和dogId推入中奖信息存储
674     */
675     function _pushLuckyInfo(uint256 currentTerm1, uint8 _lotteryClass, address owner, uint256 _dogId) internal {
676         if (_lotteryClass == 0) {
677             flotteries[currentTerm1].owners0.push(owner);
678             flotteries[currentTerm1].dogs0.push(_dogId);
679         } else if (_lotteryClass == 1) {
680             flotteries[currentTerm1].owners1.push(owner);
681             flotteries[currentTerm1].dogs1.push(_dogId);
682         } else if (_lotteryClass == 2) {
683             flotteries[currentTerm1].owners2.push(owner);
684             flotteries[currentTerm1].dogs2.push(_dogId);
685         } else if (_lotteryClass == 3) {
686             flotteries[currentTerm1].owners3.push(owner);
687             flotteries[currentTerm1].dogs3.push(_dogId);
688         } else if (_lotteryClass == 4) {
689             flotteries[currentTerm1].owners4.push(owner);
690             flotteries[currentTerm1].dogs4.push(_dogId);
691         } else if (_lotteryClass == 5) {
692             flotteries[currentTerm1].owners5.push(owner);
693             flotteries[currentTerm1].dogs5.push(_dogId);
694         } else if (_lotteryClass == 6) {
695             flotteries[currentTerm1].owners6.push(owner);
696             flotteries[currentTerm1].dogs6.push(_dogId);
697         }
698     }
699 
700     /*
701       检测该基因获奖等级
702     */
703     function getLotteryClass(uint8[7] luckyGenesArray, uint256 genes) internal view returns(uint8) {
704         // 不存在开奖信息,则直接返回未中奖
705         if (currentTerm < 0) {
706             return 100;
707         }
708         
709         uint8[7] memory dogArray = lotteryCore.convertGeneArray(genes);
710         uint8 cnt = 0;
711         uint8 lnt = 0;
712         for (uint i = 0; i < 6; i++) {
713 
714             if (luckyGenesArray[i] > 0 && luckyGenesArray[i] == dogArray[i]) {
715                 cnt++;
716             }
717         }
718         if (luckyGenesArray[6] > 0 && luckyGenesArray[6] == dogArray[6]) {
719             lnt = 1;
720         }
721         uint8 lotclass = 100;
722         if (cnt==6 && lnt==1) {
723             lotclass = 0;
724         } else if (cnt==6 && lnt==0) {
725             lotclass = 1;
726         } else if (cnt==5 && lnt==1) {
727             lotclass = 2;
728         } else if (cnt==5 && lnt==0) {
729             lotclass = 3;
730         } else if (cnt==4 && lnt==1) {
731             lotclass = 4;
732         } else if (cnt==3 && lnt==1) {
733             lotclass = 5;
734         } else if (cnt==3 && lnt==0) {
735             lotclass = 6;
736         } else {
737             lotclass = 100;
738         }
739         return lotclass;
740     }
741     /*
742        检测该基因获奖等级接口
743     */
744     function checkLottery(uint256 genes) public view returns(uint8) {
745         var(luckyGenesArray, , , isReward1, ) = lotteryCore.getCLottery();
746         if (isReward1) {
747             return 100;
748         }
749         return getLotteryClass(luckyGenesArray, genes);
750     }
751     /*
752        获取当前Lottery信息
753     */
754     function getCLottery() 
755         public 
756         view 
757         returns (
758             uint8[7]        luckyGenes1,
759             uint256         totalAmount1,
760             uint256         openBlock1,
761             bool            isReward1,
762             uint256         term1,
763             uint8           currentGenes1,
764             uint256         tSupply,
765             uint256         sPoolAmount1,
766             uint256[]       reward1
767         ) {
768             (luckyGenes1, totalAmount1, openBlock1, isReward1, term1) = lotteryCore.getCLottery();
769             currentGenes1 = lotteryCore.currentGene();
770             tSupply = dogCore.totalSupply();
771             sPoolAmount1 = lotteryCore.SpoolAmount();
772             reward1 = flotteries[term1].reward;
773     }
774     
775 }