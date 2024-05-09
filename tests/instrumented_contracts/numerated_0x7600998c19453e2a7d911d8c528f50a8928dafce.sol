1 //
2 pragma solidity ^0.5.0;
3 
4 interface TeamInterface {
5 
6     function isOwner() external view returns (bool);
7 
8     function isAdmin(address _sender) external view returns (bool);
9 
10     function isDev(address _sender) external view returns (bool);
11 
12 }
13 
14 interface PlatformInterface {
15 
16     function getAllTurnover() external view returns (uint256);
17 
18     function getTurnover(bytes32 _worksID) external view returns (uint256);
19 
20     function updateAllTurnover(uint256 _amount) external;
21 
22     function updateTurnover(bytes32 _worksID, uint256 _amount) external;
23 
24     function updateFoundAddress(address _foundation) external;
25 
26     function deposit(bytes32 _worksID) external payable;
27 
28     function transferTo(address _receiver, uint256 _amount) external;
29 
30     function getFoundAddress() external view returns (address payable);
31 
32     function balances() external view returns (uint256);
33 
34 }
35 
36 interface ArtistInterface {
37 
38     function getAddress(bytes32 _artistID) external view returns (address payable);
39 
40     function add(bytes32 _artistID, address _address) external;
41 
42     function hasArtist(bytes32 _artistID) external view returns (bool);
43 
44     function updateAddress(bytes32 _artistID, address _address) external;
45 
46 }
47 
48 interface WorksInterface {
49 
50     function addWorks(
51         bytes32 _worksID,
52         bytes32 _artistID, 
53         uint8 _debrisNum, 
54         uint256 _price, 
55         uint256 _beginTime
56     ) 
57         external;
58 
59     function configRule(
60         bytes32 _worksID,
61         uint8 _firstBuyLimit, 
62         uint256 _freezeGap, 
63         uint256 _protectGap, 
64         uint256 _increaseRatio,
65         uint256 _discountGap, 
66         uint256 _discountRatio, 
67 
68         uint8[3] calldata _firstAllot, 
69         uint8[3] calldata _againAllot, 
70         uint8[3] calldata _lastAllot 
71     ) 
72         external;
73 
74     function publish(bytes32 _worksID, uint256 _beginTime) external;
75 
76     function close(bytes32 _worksID) external;
77 
78     function getWorks(bytes32 _worksID) external view returns (uint8, uint256, uint256, uint256, bool);
79 
80     function getDebris(bytes32 _worksID, uint8 _debrisID) external view 
81         returns (uint256, address, address, bytes32, bytes32, uint256);
82 
83     function getRule(bytes32 _worksID) external view 
84         returns (uint8, uint256, uint256, uint256, uint256, uint256, uint8[3] memory, uint8[3] memory, uint8[3] memory);
85 
86     function hasWorks(bytes32 _worksID) external view returns (bool);
87 
88     function hasDebris(bytes32 _worksID, uint8 _debrisID) external view returns (bool);
89 
90     function isPublish(bytes32 _worksID) external view returns (bool);
91 
92     function isStart(bytes32 _worksID) external view returns (bool);
93 
94     function isProtect(bytes32 _worksID, uint8 _debrisID) external view returns (bool);
95 
96     function isSecond(bytes32 _worksID, uint8 _debrisID) external view returns (bool);
97 
98     function isGameOver(bytes32 _worksID) external view returns (bool);
99     
100     function isFinish(bytes32 _worksID, bytes32 _unionID) external view returns (bool);
101 
102     function hasFirstUnionIds(bytes32 _worksID, bytes32 _unionID) external view returns (bool);
103 
104     function hasSecondUnionIds(bytes32 _worksID, bytes32 _unionID) external view returns (bool);
105 
106     function getFirstUnionIds(bytes32 _worksID) external view returns (bytes32[] memory);
107 
108     function getSecondUnionIds(bytes32 _worksID) external view returns (bytes32[] memory);
109 
110     function getPrice(bytes32 _worksID) external view returns (uint256);
111 
112     function getDebrisPrice(bytes32 _worksID, uint8 _debrisID) external view returns (uint256);
113 
114     function getDebrisStatus(bytes32 _worksID, uint8 _debrisID) external view returns (uint256[4] memory, uint256, bytes32);
115 
116     function getInitPrice(bytes32 _worksID, uint8 _debrisID) external view returns (uint256);
117 
118     function getLastPrice(bytes32 _worksID, uint8 _debrisID) external view returns (uint256);
119 
120     function getLastBuyer(bytes32 _worksID, uint8 _debrisID) external view returns (address payable);
121 
122     function getLastUnionId(bytes32 _worksID, uint8 _debrisID) external view returns (bytes32);
123 
124     function getFreezeGap(bytes32 _worksID) external view returns (uint256);
125 
126     function getFirstBuyLimit(bytes32 _worksID) external view returns (uint256);
127 
128     function getArtistId(bytes32 _worksID) external view returns (bytes32);
129 
130     function getDebrisNum(bytes32 _worksID) external view returns (uint8);
131 
132     function getAllot(bytes32 _worksID, uint8 _flag) external view returns (uint8[3] memory);
133 
134     function getAllot(bytes32 _worksID, uint8 _flag, uint8 _element) external view returns (uint8);
135 
136     function getPools(bytes32 _worksID) external view returns (uint256);
137 
138     function getPoolsAllot(bytes32 _worksID) external view returns (uint256, uint256[3] memory, uint8[3] memory);
139 
140     function getStartHourglass(bytes32 _worksID) external view returns (uint256);
141 
142     function getWorksStatus(bytes32 _worksID) external view returns (uint256, uint256, uint256, bytes32);
143 
144     function getProtectHourglass(bytes32 _worksID, uint8 _debrisID) external view returns (uint256);
145 
146     function getDiscountHourglass(bytes32 _worksID, uint8 _debrisID) external view returns (uint256);
147 
148     function updateDebris(bytes32 _worksID, uint8 _debrisID, bytes32 _unionID, address _sender) external;
149 
150     function updateFirstBuyer(bytes32 _worksID, uint8 _debrisID, bytes32 _unionID, address _sender) external;
151 
152     function updateBuyNum(bytes32 _worksID, uint8 _debrisID) external;
153 
154     function finish(bytes32 _worksID, bytes32 _unionID) external;
155 
156     function updatePools(bytes32 _worksID, uint256 _value) external;
157 
158     function updateFirstUnionIds(bytes32 _worksID, bytes32 _unionID) external;
159 
160     function updateSecondUnionIds(bytes32 _worksID, bytes32 _unionID) external;
161 
162  }
163 
164 interface PlayerInterface {
165 
166     function hasAddress(address _address) external view returns (bool);
167 
168     function hasUnionId(bytes32 _unionID) external view returns (bool);
169 
170     function getInfoByUnionId(bytes32 _unionID) external view returns (address payable, bytes32, uint256);
171 
172     function getUnionIdByAddress(address _address) external view returns (bytes32);
173 
174     function isFreeze(bytes32 _unionID, bytes32 _worksID) external view returns (bool);
175 
176     function getFirstBuyNum(bytes32 _unionID, bytes32 _worksID) external view returns (uint256);
177 
178     function getSecondAmount(bytes32 _unionID, bytes32 _worksID) external view returns (uint256);
179 
180     function getFirstAmount(bytes32 _unionID, bytes32 _worksID) external view returns (uint256);
181 
182     function getLastAddress(bytes32 _unionID) external view returns (address payable);
183 
184     function getRewardAmount(bytes32 _unionID, bytes32 _worksID) external view returns (uint256);
185 
186     function getFreezeHourglass(bytes32 _unionID, bytes32 _worksID) external view returns (uint256);
187 
188     function getMyReport(bytes32 _unionID, bytes32 _worksID) external view returns (uint256, uint256, uint256);
189 
190     function getMyStatus(bytes32 _unionID, bytes32 _worksID) external view returns (uint256, uint256, uint256, uint256, uint256);
191 
192     function getMyWorks(bytes32 _unionID, bytes32 _worksID) external view returns (address, bytes32, uint256, uint256, uint256);
193 
194     function isLegalPlayer(bytes32 _unionID, address _address) external view returns (bool);
195 
196     function register(bytes32 _unionID, address _address, bytes32 _worksID, bytes32 _referrer) external returns (bool);
197 
198     function updateLastAddress(bytes32 _unionID, address payable _sender) external;
199 
200     function updateLastTime(bytes32 _unionID, bytes32 _worksID) external;
201 
202     function updateFirstBuyNum(bytes32 _unionID, bytes32 _worksID) external;
203 
204     function updateSecondAmount(bytes32 _unionID, bytes32 _worksID, uint256 _amount) external;
205 
206     function updateFirstAmount(bytes32 _unionID, bytes32 _worksID, uint256 _amount) external;
207 
208     function updateRewardAmount(bytes32 _unionID, bytes32 _worksID, uint256 _amount) external;
209 
210     function updateMyWorks(
211         bytes32 _unionID, 
212         address _address, 
213         bytes32 _worksID, 
214         uint256 _totalInput, 
215         uint256 _totalOutput
216     ) external;
217 
218 }
219 
220 /**
221  * @title SafeMath
222  * @dev Math operations with safety checks that throw on error
223  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
224  * - added sqrt
225  * - added sq
226  * - added pwr 
227  * - changed asserts to requires with error log outputs
228  * - removed div, its useless
229  */
230 library SafeMath {
231     
232     /**
233     * @dev Multiplies two numbers, throws on overflow.
234     */
235     function mul(uint256 a, uint256 b) 
236         internal 
237         pure 
238         returns (uint256 c) 
239     {
240         if (a == 0) {
241             return 0;
242         }
243         c = a * b;
244         require(c / a == b, "SafeMath mul failed");
245         return c;
246     }
247 
248     /**
249     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
250     */
251     function sub(uint256 a, uint256 b)
252         internal
253         pure
254         returns (uint256) 
255     {
256         require(b <= a, "SafeMath sub failed");
257         return a - b;
258     }
259 
260     /**
261     * @dev Adds two numbers, throws on overflow.
262     */
263     function add(uint256 a, uint256 b)
264         internal
265         pure
266         returns (uint256 c) 
267     {
268         c = a + b;
269         require(c >= a, "SafeMath add failed");
270         return c;
271     }
272     
273     /**
274      * @dev gives square root of given x.
275      */
276     function sqrt(uint256 x)
277         internal
278         pure
279         returns (uint256 y) 
280     {
281         uint256 z = ((add(x,1)) / 2);
282         y = x;
283         while (z < y) 
284         {
285             y = z;
286             z = ((add((x / z),z)) / 2);
287         }
288     }
289     
290     /**
291      * @dev gives square. multiplies x by x
292      */
293     function sq(uint256 x)
294         internal
295         pure
296         returns (uint256)
297     {
298         return (mul(x,x));
299     }
300     
301     /**
302      * @dev x to the power of y 
303      */
304     function pwr(uint256 x, uint256 y)
305         internal 
306         pure 
307         returns (uint256)
308     {
309         if (x==0)
310             return (0);
311         else if (y==0)
312             return (1);
313         else 
314         {
315             uint256 z = x;
316             for (uint256 i=1; i < y; i++)
317                 z = mul(z,x);
318             return (z);
319         }
320     }
321 
322 }
323 
324 library Datasets {
325 
326     struct Player {
327         address[] ethAddress; 
328         bytes32 referrer; 
329         address payable lastAddress; 
330         uint256 time;
331     }
332 
333     struct MyWorks { 
334         address ethAddress; 
335         bytes32 worksID; 
336         uint256 totalInput; 
337         uint256 totalOutput; 
338         uint256 time; 
339     }
340 
341 
342     struct Works {
343         bytes32 worksID; 
344         bytes32 artistID; 
345         uint8 debrisNum; 
346         uint256 price; 
347         uint256 beginTime; 
348         uint256 endTime;
349         bool isPublish; 
350         bytes32 lastUnionID;
351     }
352 
353     struct Debris {
354         uint8 debrisID; 
355         bytes32 worksID; 
356         uint256 initPrice; 
357         uint256 lastPrice; 
358         uint256 buyNum; 
359         address payable firstBuyer; 
360         address payable lastBuyer; 
361         bytes32 firstUnionID; 
362         bytes32 lastUnionID; 
363         uint256 lastTime; 
364     }
365     
366     struct Rule {       
367         uint8 firstBuyLimit; 
368         uint256 freezeGap; 
369         uint256 protectGap; 
370         uint256 increaseRatio;
371         uint256 discountGap; 
372         uint256 discountRatio; 
373 
374         uint8[3] firstAllot; 
375         uint8[3] againAllot;
376         uint8[3] lastAllot; 
377     }
378 
379     struct PlayerCount {
380         uint256 lastTime; 
381         uint256 firstBuyNum; 
382         uint256 firstAmount; 
383         uint256 secondAmount; 
384         uint256 rewardAmount;
385     }
386 
387 }
388 
389 /**
390  * @title PuzzleBID Game Main Contract
391  * @dev http://www.puzzlebid.com/
392  * @author PuzzleBID Game Team 
393  * @dev Simon<vsiryxm@163.com>
394  */
395 contract PuzzleBID {
396 
397     using SafeMath for *;
398 
399     string constant public name = "PuzzleBID Game";
400     string constant public symbol = "PZB";
401 
402     TeamInterface private team; 
403     PlatformInterface private platform; 
404     ArtistInterface private artist; 
405     WorksInterface private works; 
406     PlayerInterface private player; 
407     
408     constructor(
409         address _teamAddress,
410         address _platformAddress,
411         address _artistAddress,
412         address _worksAddress,
413         address _playerAddress
414     ) public {
415         require(
416             _teamAddress != address(0) &&
417             _platformAddress != address(0) &&
418             _artistAddress != address(0) &&
419             _worksAddress != address(0) &&
420             _playerAddress != address(0)
421         );
422         team = TeamInterface(_teamAddress);
423         platform = PlatformInterface(_platformAddress);
424         artist = ArtistInterface(_artistAddress);
425         works = WorksInterface(_worksAddress);
426         player = PlayerInterface(_playerAddress);
427     }  
428 
429     function() external payable {
430         revert();
431     }
432 
433     event OnUpgrade(
434         address indexed _teamAddress,
435         address indexed _platformAddress,
436         address indexed _artistAddress,
437         address _worksAddress,
438         address _playerAddress
439     );
440 
441     modifier isHuman() {
442         address _address = msg.sender;
443         uint256 _size;
444 
445         assembly {_size := extcodesize(_address)}
446         require(_size == 0, "sorry humans only");
447         _;
448     }
449 
450     modifier checkPlay(bytes32 _worksID, uint8 _debrisID, bytes32 _unionID) {
451         require(msg.value > 0);
452 
453         require(works.hasWorks(_worksID)); 
454         require(works.hasDebris(_worksID, _debrisID)); 
455         require(works.isGameOver(_worksID) == false);
456         require(works.isPublish(_worksID) && works.isStart(_worksID));
457         require(works.isProtect(_worksID, _debrisID) == false);
458          
459         require(player.isFreeze(_unionID, _worksID) == false); 
460         if(player.getFirstBuyNum(_unionID, _worksID).add(1) > works.getFirstBuyLimit(_worksID)) {
461             require(works.isSecond(_worksID, _debrisID));
462         }      
463         require(msg.value >= works.getDebrisPrice(_worksID, _debrisID));
464         _;
465     } 
466        
467     modifier onlyAdmin() {
468         require(team.isAdmin(msg.sender));
469         _;
470     }
471     
472     function upgrade(
473         address _teamAddress,
474         address _platformAddress,
475         address _artistAddress,
476         address _worksAddress,
477         address _playerAddress
478     ) external onlyAdmin() {
479         require(
480             _teamAddress != address(0) &&
481             _platformAddress != address(0) &&
482             _artistAddress != address(0) &&
483             _worksAddress != address(0) &&
484             _playerAddress != address(0)
485         );
486         team = TeamInterface(_teamAddress);
487         platform = PlatformInterface(_platformAddress);
488         artist = ArtistInterface(_artistAddress);
489         works = WorksInterface(_worksAddress);
490         player = PlayerInterface(_playerAddress);
491         emit OnUpgrade(_teamAddress, _platformAddress, _artistAddress, _worksAddress, _playerAddress);
492     }   
493 
494     function startPlay(bytes32 _worksID, uint8 _debrisID, bytes32 _unionID, bytes32 _referrer) 
495         isHuman()
496         checkPlay(_worksID, _debrisID, _unionID)
497         external
498         payable
499     {
500         player.register(_unionID, msg.sender, _worksID, _referrer); 
501 
502         uint256 lastPrice = works.getLastPrice(_worksID, _debrisID);
503 
504         bytes32 lastUnionID = works.getLastUnionId(_worksID, _debrisID);
505 
506         works.updateDebris(_worksID, _debrisID, _unionID, msg.sender); 
507 
508         player.updateLastTime(_unionID, _worksID); 
509         
510         platform.updateTurnover(_worksID, msg.value); 
511 
512         platform.updateAllTurnover(msg.value); 
513         
514         if(works.isSecond(_worksID, _debrisID)) {
515             secondPlay(_worksID, _debrisID, _unionID, lastUnionID, lastPrice);            
516         } else {
517             works.updateBuyNum(_worksID, _debrisID);
518             firstPlay(_worksID, _debrisID, _unionID);       
519         }
520 
521         if(works.isFinish(_worksID, _unionID)) {
522             works.finish(_worksID, _unionID); 
523             finishGame(_worksID);
524             collectWorks(_worksID, _unionID); 
525         }
526 
527     }
528 
529     function firstPlay(bytes32 _worksID, uint8 _debrisID, bytes32 _unionID) private {    
530         works.updateFirstBuyer(_worksID, _debrisID, _unionID, msg.sender);    
531         player.updateFirstBuyNum(_unionID, _worksID); 
532         player.updateFirstAmount(_unionID, _worksID, msg.value); 
533 
534         uint8[3] memory firstAllot = works.getAllot(_worksID, 0); 
535         artist.getAddress(works.getArtistId(_worksID)).transfer(msg.value.mul(firstAllot[0]) / 100); 
536         platform.getFoundAddress().transfer(msg.value.mul(firstAllot[1]) / 100); 
537 
538         works.updatePools(_worksID, msg.value.mul(firstAllot[2]) / 100); 
539         platform.deposit.value(msg.value.mul(firstAllot[2]) / 100)(_worksID); 
540 
541     }
542 
543     function secondPlay(bytes32 _worksID, uint8 _debrisID, bytes32 _unionID, bytes32 _oldUnionID, uint256 _oldPrice) private {
544 
545         if(0 == player.getSecondAmount(_unionID, _worksID)) {
546             works.updateSecondUnionIds(_worksID, _unionID);
547         }
548 
549         player.updateSecondAmount(_unionID, _worksID, msg.value);
550 
551         uint8[3] memory againAllot = works.getAllot(_worksID, 1);
552         uint256 lastPrice = works.getLastPrice(_worksID, _debrisID); 
553         uint256 commission = lastPrice.mul(againAllot[1]) / 100;
554         platform.getFoundAddress().transfer(commission); 
555 
556         lastPrice = lastPrice.sub(commission); 
557 
558         if(lastPrice > _oldPrice) {
559             uint256 overflow = lastPrice.sub(_oldPrice); 
560             artist.getAddress(works.getArtistId(_worksID)).transfer(overflow.mul(againAllot[0]) / 100); 
561             works.updatePools(_worksID, overflow.mul(againAllot[2]) / 100); 
562             platform.deposit.value(overflow.mul(againAllot[2]) / 100)(_worksID); 
563             player.getLastAddress(_oldUnionID).transfer(
564                 lastPrice.sub(overflow.mul(againAllot[0]) / 100)                
565                 .sub(overflow.mul(againAllot[2]) / 100)
566             ); 
567         } else { 
568             player.getLastAddress(_oldUnionID).transfer(lastPrice);
569         }
570 
571     }
572 
573     function finishGame(bytes32 _worksID) private {              
574         uint8 lastAllot = works.getAllot(_worksID, 2, 0);
575         platform.transferTo(msg.sender, works.getPools(_worksID).mul(lastAllot) / 100);
576         firstSend(_worksID); 
577         secondSend(_worksID); 
578     }
579 
580     function collectWorks(bytes32 _worksID, bytes32 _unionID) private {
581         player.updateMyWorks(_unionID, msg.sender, _worksID, 0, 0);
582     }
583     
584     function firstSend(bytes32 _worksID) private {
585         uint8 i;
586         bytes32[] memory tmpFirstUnionId = works.getFirstUnionIds(_worksID); 
587         address tmpAddress; 
588         uint256 tmpAmount;
589         uint8 lastAllot = works.getAllot(_worksID, 2, 1);
590         for(i=0; i<tmpFirstUnionId.length; i++) {
591             tmpAddress = player.getLastAddress(tmpFirstUnionId[i]);
592             tmpAmount = player.getFirstAmount(tmpFirstUnionId[i], _worksID);
593             tmpAmount = works.getPools(_worksID).mul(lastAllot).mul(tmpAmount) / 100 / works.getPrice(_worksID);
594             platform.transferTo(tmpAddress, tmpAmount); 
595         }
596     }
597 
598     function secondSend(bytes32 _worksID) private {
599         uint8 i;
600         bytes32[] memory tmpSecondUnionId = works.getSecondUnionIds(_worksID); 
601         address tmpAddress; 
602         uint256 tmpAmount;
603         uint8 lastAllot = works.getAllot(_worksID, 2, 2);
604         for(i=0; i<tmpSecondUnionId.length; i++) {
605             tmpAddress = player.getLastAddress(tmpSecondUnionId[i]);
606             tmpAmount = player.getSecondAmount(tmpSecondUnionId[i], _worksID);
607             tmpAmount = works.getPools(_worksID).mul(lastAllot).mul(tmpAmount) / 100 / (platform.getTurnover(_worksID).sub(works.getPrice(_worksID)));
608             platform.transferTo(tmpAddress, tmpAmount); 
609         }
610     }
611 
612     function getNowTime() external view returns (uint256) {
613         return now;
614     }
615 
616  }