1 pragma solidity ^0.4.18;
2 
3 contract DogCoreInterface {
4 
5     address public ceoAddress;
6     address public cfoAddress;
7 
8     function getDog(uint256 _id)
9         external
10         view
11         returns (
12         uint256 cooldownIndex,
13         uint256 nextActionAt,
14         uint256 siringWithId,
15         uint256 birthTime,
16         uint256 matronId,
17         uint256 sireId,
18         uint256 generation,
19         uint256 genes,
20         uint8  variation,
21         uint256 gen0
22     );
23     function ownerOf(uint256 _tokenId) external view returns (address);
24     function transferFrom(address _from, address _to, uint256 _tokenId) external;
25     function sendMoney(address _to, uint256 _money) external;
26     function totalSupply() external view returns (uint);
27     function getOwner(uint256 _tokenId) public view returns(address);
28     function getAvailableBlance() external view returns(uint256);
29 }
30 
31 
32 contract LotteryBase {
33     
34     uint8 public currentGene;
35     
36     uint256 public lastBlockNumber;
37     
38     uint256 randomSeed = 1;
39 
40     struct CLottery {
41         
42         uint8[7]        luckyGenes;
43         
44         uint256         totalAmount;
45         
46         uint256         openBlock;
47         
48         bool            isReward;
49         
50         bool         noFirstReward;
51     }
52     
53     CLottery[] public CLotteries;
54     
55     address public finalLottery;
56     
57     uint256 public SpoolAmount = 0;
58     
59     DogCoreInterface public dogCore;
60     
61     event OpenLottery(uint8 currentGene, uint8 luckyGenes, uint256 currentTerm, uint256 blockNumber, uint256 totalAmount);
62     
63     event OpenCarousel(uint256 luckyGenes, uint256 currentTerm, uint256 blockNumber, uint256 totalAmount);
64     
65     
66     modifier onlyCEO() {
67         require(msg.sender == dogCore.ceoAddress());
68         _;  
69     }
70     
71     modifier onlyCFO() {
72         require(msg.sender == dogCore.cfoAddress());
73         _;  
74     }
75     
76     function toLotteryPool(uint amount) public onlyCFO {
77         require(SpoolAmount >= amount);
78         SpoolAmount -= amount;
79     }
80     
81     function _isCarousal(uint256 currentTerm) external view returns(bool) {
82        return (currentTerm > 1 && CLotteries[currentTerm - 2].noFirstReward && CLotteries[currentTerm - 1].noFirstReward); 
83     }
84     
85     function getCurrentTerm() external view returns (uint256) {
86 
87         return (CLotteries.length - 1);
88     }
89 }
90 
91 
92 contract LotteryGenes is LotteryBase {
93     
94     function convertGeneArray(uint256 gene) public pure returns(uint8[7]) {
95         uint8[28] memory geneArray; 
96         uint8[7] memory lotteryArray;
97         uint index = 0;
98         for (index = 0; index < 28; index++) {
99             uint256 geneItem = gene % (2 ** (5 * (index + 1)));
100             geneItem /= (2 ** (5 * index));
101             geneArray[index] = uint8(geneItem);
102         }
103         for (index = 0; index < 7; index++) {
104             uint size = 4 * index;
105             lotteryArray[index] = geneArray[size];
106             
107         }
108         return lotteryArray;
109     }
110 
111     function convertGene(uint8[7] luckyGenes) public pure returns(uint256) {
112         uint8[28] memory geneArray;
113         for (uint8 i = 0; i < 28; i++) {
114             if (i%4 == 0) {
115                 geneArray[i] = luckyGenes[i/4];
116             } else {
117                 geneArray[i] = 6;
118             }
119         }
120         uint256 gene = uint256(geneArray[0]);
121         
122         for (uint8 index = 1; index < 28; index++) {
123             uint256 geneItem = uint256(geneArray[index]);
124             gene += geneItem << (index * 5);
125         }
126         return gene;
127     }
128 }
129 
130 
131 contract SetLottery is LotteryGenes {
132 
133     function random(uint8 seed) internal returns(uint8) {
134         randomSeed = block.timestamp;
135         return uint8(uint256(keccak256(randomSeed, block.difficulty))%seed)+1;
136     }
137 
138     function openLottery(uint8 _viewId) public returns(uint8,uint8) {
139         uint8 viewId = _viewId;
140         require(viewId < 7);
141         uint256 currentTerm = CLotteries.length - 1;
142         CLottery storage clottery = CLotteries[currentTerm];
143 
144         if (currentGene == 0 && clottery.openBlock > 0 && clottery.isReward == false) {
145             OpenLottery(viewId, clottery.luckyGenes[viewId], currentTerm, clottery.openBlock, clottery.totalAmount);
146             return (clottery.luckyGenes[viewId],1);
147         }
148         if (lastBlockNumber == block.number) {
149             OpenLottery(viewId, clottery.luckyGenes[viewId], currentTerm, clottery.openBlock, clottery.totalAmount);
150             return (clottery.luckyGenes[viewId],2);
151         }
152         if (currentGene == 0 && clottery.isReward == true) {
153             CLottery memory _clottery;
154             _clottery.luckyGenes = [0,0,0,0,0,0,0];
155             _clottery.totalAmount = uint256(0);
156             _clottery.isReward = false;
157             _clottery.openBlock = uint256(0);
158             currentTerm = CLotteries.push(_clottery) - 1;
159         }
160 
161         if (this._isCarousal(currentTerm)) {
162             revert();
163         }
164 
165         uint8 luckyNum = 0;
166         
167         uint256 bonusBalance = dogCore.getAvailableBlance();
168         if (currentGene == 6) {
169             if (bonusBalance <= SpoolAmount) {
170                 OpenLottery(viewId, clottery.luckyGenes[viewId], currentTerm, 0, 0);
171                 return (clottery.luckyGenes[viewId],3);
172             }
173             luckyNum = random(8);
174             CLotteries[currentTerm].luckyGenes[currentGene] = luckyNum;
175             OpenLottery(currentGene, luckyNum, currentTerm, block.number, bonusBalance);
176             currentGene = 0;
177             CLotteries[currentTerm].openBlock = block.number;
178             CLotteries[currentTerm].totalAmount = bonusBalance;
179             lastBlockNumber = block.number;
180         } else {         
181             luckyNum = random(12);
182             CLotteries[currentTerm].luckyGenes[currentGene] = luckyNum;
183 
184             OpenLottery(currentGene, luckyNum, currentTerm, 0, 0);
185             currentGene ++;
186             lastBlockNumber = block.number;
187         }
188         return (luckyNum,0);
189     } 
190 
191     function random2() internal view returns (uint256) {
192         return uint256(uint256(keccak256(block.timestamp, block.difficulty))%uint256(dogCore.totalSupply()) + 1);
193     }
194 
195     function openCarousel() public {
196         uint256 currentTerm = CLotteries.length - 1;
197         CLottery storage clottery = CLotteries[currentTerm];
198 
199         if (currentGene == 0 && clottery.openBlock > 0 && clottery.isReward == false) {
200 
201             OpenCarousel(convertGene(clottery.luckyGenes), currentTerm, clottery.openBlock, clottery.totalAmount);
202         }
203 
204         if (currentGene == 0 && clottery.openBlock > 0 && clottery.isReward == true) {
205             CLottery memory _clottery;
206             _clottery.luckyGenes = [0,0,0,0,0,0,0];
207             _clottery.totalAmount = uint256(0);
208             _clottery.isReward = false;
209             _clottery.openBlock = uint256(0);
210             currentTerm = CLotteries.push(_clottery) - 1;
211         }
212 
213         uint256 bonusBlance = dogCore.getAvailableBlance();
214 
215         require (this._isCarousal(currentTerm));
216         uint256 genes = _getValidRandomGenes();
217         require (genes > 0);
218         uint8[7] memory luckyGenes = convertGeneArray(genes);
219         OpenCarousel(genes, currentTerm, block.number, bonusBlance);
220 
221         CLotteries[currentTerm].luckyGenes = luckyGenes;
222         CLotteries[currentTerm].openBlock = block.number;
223         CLotteries[currentTerm].totalAmount = bonusBlance;        
224     }
225     
226     function _getValidRandomGenes() internal view returns (uint256) {
227         uint256 luckyDog = random2();
228         uint256 genes = _validGenes(luckyDog);
229         uint256 totalSupply = dogCore.totalSupply();
230         if (genes > 0) {
231             return genes;
232         }  
233         uint256 min = (luckyDog < totalSupply-luckyDog) ? (luckyDog - 1) : totalSupply-luckyDog;
234         for (uint256 i = 1; i < min + 1; i++) {
235             genes = _validGenes(luckyDog - i);
236             if (genes > 0) {
237                 break;
238             }
239             genes = _validGenes(luckyDog + i);
240             if (genes > 0) {
241                     break;
242                 }
243             }
244         if (genes == 0) {
245             if (min == luckyDog - 1) {
246                 for (i = min + luckyDog; i < totalSupply + 1; i++) {
247                         genes = _validGenes(i);
248                         if (genes > 0) {
249                             break;
250                         }
251                     }   
252                 }
253             if (min == totalSupply - luckyDog) {
254                 for (i = min; i < luckyDog; i++) {
255                         genes = _validGenes(luckyDog - i - 1);
256                         if (genes > 0) {
257                             break;
258                         }
259                     }   
260                 }
261             }
262         return genes;
263     }
264 
265 
266     function _validGenes(uint256 dogId) internal view returns (uint256) {
267 
268         var(, , , , , ,generation, genes, variation,) = dogCore.getDog(dogId);
269         if (generation == 0 || dogCore.ownerOf(dogId) == finalLottery || variation > 0) {
270             return 0;
271         } else {
272             return genes;
273         }
274     }
275 
276     
277 }
278 
279 
280 contract LotteryCore is SetLottery {
281     
282     function LotteryCore(address _ktAddress) public {
283 
284         dogCore = DogCoreInterface(_ktAddress);
285 
286         CLottery memory _clottery;
287         _clottery.luckyGenes = [0,0,0,0,0,0,0];
288         _clottery.totalAmount = uint256(0);
289         _clottery.isReward = false;
290         _clottery.openBlock = uint256(0);
291         CLotteries.push(_clottery);
292     }
293 
294     function setFinalLotteryAddress(address _flAddress) public onlyCEO {
295         finalLottery = _flAddress;
296     }
297     
298     function getCLottery() 
299         public 
300         view 
301         returns (
302             uint8[7]        luckyGenes,
303             uint256         totalAmount,
304             uint256         openBlock,
305             bool            isReward,
306             uint256         term
307         ) {
308             term = CLotteries.length - uint256(1);
309             luckyGenes = CLotteries[term].luckyGenes;
310             totalAmount = CLotteries[term].totalAmount;
311             openBlock = CLotteries[term].openBlock;
312             isReward = CLotteries[term].isReward;
313     }
314 
315     function rewardLottery(bool isMore) external {
316         require(msg.sender == finalLottery);
317 
318         uint256 term = CLotteries.length - 1;
319         CLotteries[term].isReward = true;
320         CLotteries[term].noFirstReward = isMore;
321     }
322 
323     function toSPool(uint amount) external {
324         
325         require(msg.sender == finalLottery);
326 
327         SpoolAmount += amount;
328     }
329 }
330 
331 
332 contract FinalLottery {
333     bool public isLottery = true;
334     LotteryCore public lotteryCore;
335     DogCoreInterface public dogCore;
336     uint8[7] public luckyGenes;
337     uint256         totalAmount;
338     uint256         openBlock;
339     bool            isReward;
340     uint256         currentTerm;
341     uint256  public duration;
342     uint8   public  lotteryRatio;
343     uint8[7] public lotteryParam;
344     uint8   public  carousalRatio;
345     uint8[7] public carousalParam; 
346     
347     struct FLottery {
348         address[]        owners0;
349         uint256[]        dogs0;
350         address[]        owners1;
351         uint256[]        dogs1;
352         address[]        owners2;
353         uint256[]        dogs2;
354         address[]        owners3;
355         uint256[]        dogs3;
356         address[]        owners4;
357         uint256[]        dogs4;
358         address[]        owners5;
359         uint256[]        dogs5;
360         address[]        owners6;
361         uint256[]        dogs6;
362         uint256[]       reward;
363     }
364     mapping(uint256 => FLottery) flotteries;
365 
366     function FinalLottery(address _lcAddress) public {
367         lotteryCore = LotteryCore(_lcAddress);
368         dogCore = DogCoreInterface(lotteryCore.dogCore());
369         duration = 11520;
370         lotteryRatio = 23;
371         lotteryParam = [46,16,10,9,8,6,5];
372         carousalRatio = 12;
373         carousalParam = [35,18,14,12,8,7,6];        
374     }
375     
376     event DistributeLottery(uint256[] rewardArray, uint256 currentTerm);
377     
378     event RegisterLottery(uint256 dogId, address owner, uint8 lotteryClass, string result);
379     
380     function setLotteryDuration(uint256 durationBlocks) public {
381         require(msg.sender == dogCore.ceoAddress());
382         require(durationBlocks > 140);
383         require(durationBlocks < block.number);
384         duration = durationBlocks;
385     }
386     
387     function registerLottery(uint256 dogId) public returns (uint8) {
388         uint256 _dogId = dogId;
389         (luckyGenes, totalAmount, openBlock, isReward, currentTerm) = lotteryCore.getCLottery();
390         address owner = dogCore.ownerOf(_dogId);
391         require (owner != address(this));
392         require(address(dogCore) == msg.sender);
393         require(totalAmount > 0 && isReward == false && openBlock > (block.number-duration));
394         var(, , , birthTime, , ,generation,genes, variation,) = dogCore.getDog(_dogId);
395         require(birthTime < openBlock);
396         require(generation > 0);
397         require(variation == 0);
398         uint8 _lotteryClass = getLotteryClass(luckyGenes, genes);
399         require(_lotteryClass < 7);
400         address[] memory owners;
401         uint256[] memory dogs;
402          (dogs, owners) = _getLuckyList(currentTerm, _lotteryClass);
403             
404         for (uint i = 0; i < dogs.length; i++) {
405             if (_dogId == dogs[i]) {
406                 RegisterLottery(_dogId, owner, _lotteryClass,"dog already registered");
407                  return 5;
408             }
409         }
410         _pushLuckyInfo(currentTerm, _lotteryClass, owner, _dogId);
411         
412         RegisterLottery(_dogId, owner, _lotteryClass,"successful");
413         return 0;
414     }
415     
416     function distributeLottery() public returns (uint8) {
417         (luckyGenes, totalAmount, openBlock, isReward, currentTerm) = lotteryCore.getCLottery();
418         
419         require(openBlock > 0 && openBlock < (block.number-duration));
420 
421         require(totalAmount >= lotteryCore.SpoolAmount());
422 
423         if (isReward == true) {
424             DistributeLottery(flotteries[currentTerm].reward, currentTerm);
425             return 1;
426         }
427         uint256 legalAmount = totalAmount - lotteryCore.SpoolAmount();
428         uint256 totalDistribute = 0;
429         uint8[7] memory lR;
430         uint8 ratio;
431 
432         if (lotteryCore._isCarousal(currentTerm) ) {
433             lR = carousalParam;
434             ratio = carousalRatio;
435         } else {
436             lR = lotteryParam;
437             ratio = lotteryRatio;
438         }
439         for (uint8 i = 0; i < 7; i++) {
440             address[] memory owners;
441             uint256[] memory dogs;
442             (dogs, owners) = _getLuckyList(currentTerm, i);
443             if (owners.length > 0) {
444                     uint256 reward = (legalAmount * ratio * lR[i])/(10000 * owners.length);
445                     totalDistribute += reward * owners.length;
446                     dogCore.sendMoney(dogCore.cfoAddress(),reward * owners.length/10);
447                     
448                     for (uint j = 0; j < owners.length; j++) {
449                         address gen0Add;
450                         if (i == 0) {
451                             dogCore.sendMoney(owners[j],reward*95*9/1000);
452                             gen0Add = _getGen0Address(dogs[j]);
453                             if(gen0Add != address(0)){
454                                 dogCore.sendMoney(gen0Add,reward*5/100);
455                             }
456                         } else if (i == 1) {
457                             dogCore.sendMoney(owners[j],reward*97*9/1000);
458                             gen0Add = _getGen0Address(dogs[j]);
459                             if(gen0Add != address(0)){
460                                 dogCore.sendMoney(gen0Add,reward*3/100);
461                             }
462                         } else if (i == 2) {
463                             dogCore.sendMoney(owners[j],reward*98*9/1000);
464                             gen0Add = _getGen0Address(dogs[j]);
465                             if(gen0Add != address(0)){
466                                 dogCore.sendMoney(gen0Add,reward*2/100);
467                             }
468                         } else {
469                             dogCore.sendMoney(owners[j],reward*9/10);
470                         }
471                     }
472                     flotteries[currentTerm].reward.push(reward); 
473                 } else {
474                     flotteries[currentTerm].reward.push(0);
475                 } 
476         }
477         if (flotteries[currentTerm].owners0.length == 0) {
478             lotteryCore.toSPool((dogCore.getAvailableBlance() - lotteryCore.SpoolAmount())/20);
479             lotteryCore.rewardLottery(true);
480         } else {
481             lotteryCore.rewardLottery(false);
482         }
483         
484         DistributeLottery(flotteries[currentTerm].reward, currentTerm);
485         return 0;
486     }
487 
488     function _getGen0Address(uint256 dogId) internal view returns(address) {
489         var(, , , , , , , , , gen0) = dogCore.getDog(dogId);
490         return dogCore.getOwner(gen0);
491     }
492 
493     function _getLuckyList(uint256 currentTerm1, uint8 lotclass) public view returns (uint256[] kts, address[] ons) {
494         if (lotclass==0) {
495             ons = flotteries[currentTerm1].owners0;
496             kts = flotteries[currentTerm1].dogs0;
497         } else if (lotclass==1) {
498             ons = flotteries[currentTerm1].owners1;
499             kts = flotteries[currentTerm1].dogs1;
500         } else if (lotclass==2) {
501             ons = flotteries[currentTerm1].owners2;
502             kts = flotteries[currentTerm1].dogs2;
503         } else if (lotclass==3) {
504             ons = flotteries[currentTerm1].owners3;
505             kts = flotteries[currentTerm1].dogs3;
506         } else if (lotclass==4) {
507             ons = flotteries[currentTerm1].owners4;
508             kts = flotteries[currentTerm1].dogs4;
509         } else if (lotclass==5) {
510             ons = flotteries[currentTerm1].owners5;
511             kts = flotteries[currentTerm1].dogs5;
512         } else if (lotclass==6) {
513             ons = flotteries[currentTerm1].owners6;
514             kts = flotteries[currentTerm1].dogs6;
515         }
516     }
517 
518     function _pushLuckyInfo(uint256 currentTerm1, uint8 _lotteryClass, address owner, uint256 _dogId) internal {
519         if (_lotteryClass == 0) {
520             flotteries[currentTerm1].owners0.push(owner);
521             flotteries[currentTerm1].dogs0.push(_dogId);
522         } else if (_lotteryClass == 1) {
523             flotteries[currentTerm1].owners1.push(owner);
524             flotteries[currentTerm1].dogs1.push(_dogId);
525         } else if (_lotteryClass == 2) {
526             flotteries[currentTerm1].owners2.push(owner);
527             flotteries[currentTerm1].dogs2.push(_dogId);
528         } else if (_lotteryClass == 3) {
529             flotteries[currentTerm1].owners3.push(owner);
530             flotteries[currentTerm1].dogs3.push(_dogId);
531         } else if (_lotteryClass == 4) {
532             flotteries[currentTerm1].owners4.push(owner);
533             flotteries[currentTerm1].dogs4.push(_dogId);
534         } else if (_lotteryClass == 5) {
535             flotteries[currentTerm1].owners5.push(owner);
536             flotteries[currentTerm1].dogs5.push(_dogId);
537         } else if (_lotteryClass == 6) {
538             flotteries[currentTerm1].owners6.push(owner);
539             flotteries[currentTerm1].dogs6.push(_dogId);
540         }
541     }
542 
543     function getLotteryClass(uint8[7] luckyGenesArray, uint256 genes) internal view returns(uint8) {
544         if (currentTerm < 0) {
545             return 100;
546         }
547         
548         uint8[7] memory dogArray = lotteryCore.convertGeneArray(genes);
549         uint8 cnt = 0;
550         uint8 lnt = 0;
551         for (uint i = 0; i < 6; i++) {
552 
553             if (luckyGenesArray[i] > 0 && luckyGenesArray[i] == dogArray[i]) {
554                 cnt++;
555             }
556         }
557         if (luckyGenesArray[6] > 0 && luckyGenesArray[6] == dogArray[6]) {
558             lnt = 1;
559         }
560         uint8 lotclass = 100;
561         if (cnt==6 && lnt==1) {
562             lotclass = 0;
563         } else if (cnt==6 && lnt==0) {
564             lotclass = 1;
565         } else if (cnt==5 && lnt==1) {
566             lotclass = 2;
567         } else if (cnt==5 && lnt==0) {
568             lotclass = 3;
569         } else if (cnt==4 && lnt==1) {
570             lotclass = 4;
571         } else if (cnt==3 && lnt==1) {
572             lotclass = 5;
573         } else if (cnt==3 && lnt==0) {
574             lotclass = 6;
575         } else {
576             lotclass = 100;
577         }
578         return lotclass;
579     }
580     
581     function checkLottery(uint256 genes) public view returns(uint8) {
582         var(luckyGenesArray, , , isReward1, ) = lotteryCore.getCLottery();
583         if (isReward1) {
584             return 100;
585         }
586         return getLotteryClass(luckyGenesArray, genes);
587     }
588     
589     function getCLottery() 
590         public 
591         view 
592         returns (
593             uint8[7]        luckyGenes1,
594             uint256         totalAmount1,
595             uint256         openBlock1,
596             bool            isReward1,
597             uint256         term1,
598             uint8           currentGenes1,
599             uint256         tSupply,
600             uint256         sPoolAmount1,
601             uint256[]       reward1
602         ) {
603             (luckyGenes1, totalAmount1, openBlock1, isReward1, term1) = lotteryCore.getCLottery();
604             currentGenes1 = lotteryCore.currentGene();
605             tSupply = dogCore.totalSupply();
606             sPoolAmount1 = lotteryCore.SpoolAmount();
607             reward1 = flotteries[term1].reward;
608     }    
609 }