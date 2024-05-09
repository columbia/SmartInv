1 pragma solidity ^0.5.0;
2 
3 interface TeamInterface {
4 
5     function isOwner() external view returns (bool);
6 
7     function isAdmin(address _sender) external view returns (bool);
8 
9     function isDev(address _sender) external view returns (bool);
10 
11 }
12 
13 interface ArtistInterface {
14 
15     function getAddress(bytes32 _artistID) external view returns (address payable);
16 
17     function add(bytes32 _artistID, address _address) external;
18 
19     function hasArtist(bytes32 _artistID) external view returns (bool);
20 
21     function updateAddress(bytes32 _artistID, address _address) external;
22 
23 }
24 
25 /**
26  * @title SafeMath
27  * @dev Math operations with safety checks that throw on error
28  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
29  * - added sqrt
30  * - added sq
31  * - added pwr 
32  * - changed asserts to requires with error log outputs
33  * - removed div, its useless
34  */
35 library SafeMath {
36     
37     /**
38     * @dev Multiplies two numbers, throws on overflow.
39     */
40     function mul(uint256 a, uint256 b) 
41         internal 
42         pure 
43         returns (uint256 c) 
44     {
45         if (a == 0) {
46             return 0;
47         }
48         c = a * b;
49         require(c / a == b, "SafeMath mul failed");
50         return c;
51     }
52 
53     /**
54     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
55     */
56     function sub(uint256 a, uint256 b)
57         internal
58         pure
59         returns (uint256) 
60     {
61         require(b <= a, "SafeMath sub failed");
62         return a - b;
63     }
64 
65     /**
66     * @dev Adds two numbers, throws on overflow.
67     */
68     function add(uint256 a, uint256 b)
69         internal
70         pure
71         returns (uint256 c) 
72     {
73         c = a + b;
74         require(c >= a, "SafeMath add failed");
75         return c;
76     }
77     
78     /**
79      * @dev gives square root of given x.
80      */
81     function sqrt(uint256 x)
82         internal
83         pure
84         returns (uint256 y) 
85     {
86         uint256 z = ((add(x,1)) / 2);
87         y = x;
88         while (z < y) 
89         {
90             y = z;
91             z = ((add((x / z),z)) / 2);
92         }
93     }
94     
95     /**
96      * @dev gives square. multiplies x by x
97      */
98     function sq(uint256 x)
99         internal
100         pure
101         returns (uint256)
102     {
103         return (mul(x,x));
104     }
105     
106     /**
107      * @dev x to the power of y 
108      */
109     function pwr(uint256 x, uint256 y)
110         internal 
111         pure 
112         returns (uint256)
113     {
114         if (x==0)
115             return (0);
116         else if (y==0)
117             return (1);
118         else 
119         {
120             uint256 z = x;
121             for (uint256 i=1; i < y; i++)
122                 z = mul(z,x);
123             return (z);
124         }
125     }
126 
127 }
128 
129 library Datasets {
130 
131     struct Player {
132         address[] ethAddress; 
133         bytes32 referrer; 
134         address payable lastAddress; 
135         uint256 time;
136     }
137 
138     struct MyWorks { 
139         address ethAddress; 
140         bytes32 worksID; 
141         uint256 totalInput; 
142         uint256 totalOutput; 
143         uint256 time; 
144     }
145 
146 
147     struct Works {
148         bytes32 worksID; 
149         bytes32 artistID; 
150         uint8 debrisNum; 
151         uint256 price; 
152         uint256 beginTime; 
153         uint256 endTime;
154         bool isPublish; 
155         bytes32 lastUnionID;
156     }
157 
158     struct Debris {
159         uint8 debrisID; 
160         bytes32 worksID; 
161         uint256 initPrice; 
162         uint256 lastPrice; 
163         uint256 buyNum; 
164         address payable firstBuyer; 
165         address payable lastBuyer; 
166         bytes32 firstUnionID; 
167         bytes32 lastUnionID; 
168         uint256 lastTime; 
169     }
170     
171     struct Rule {       
172         uint8 firstBuyLimit; 
173         uint256 freezeGap; 
174         uint256 protectGap; 
175         uint256 increaseRatio;
176         uint256 discountGap; 
177         uint256 discountRatio; 
178 
179         uint8[3] firstAllot; 
180         uint8[3] againAllot;
181         uint8[3] lastAllot; 
182     }
183 
184     struct PlayerCount {
185         uint256 lastTime; 
186         uint256 firstBuyNum; 
187         uint256 firstAmount; 
188         uint256 secondAmount; 
189         uint256 rewardAmount;
190     }
191 
192 }
193 
194 /**
195  * @title Works Contract
196  * @dev http://www.puzzlebid.com/
197  * @author PuzzleBID Game Team 
198  * @dev Simon<vsiryxm@163.com>
199  */
200 contract Works {
201 
202     using SafeMath for *;
203 
204     TeamInterface private team; 
205     ArtistInterface private artist; 
206 
207     constructor(address _teamAddress, address _artistAddress) public {
208         require(_teamAddress != address(0) && _artistAddress != address(0));
209         team = TeamInterface(_teamAddress);
210         artist = ArtistInterface(_artistAddress);
211     }
212 
213     function() external payable {
214         revert();
215     }
216 
217     event OnUpgrade(address indexed _teamAddress, address indexed _artistAddress);
218     event OnAddWorks(
219         bytes32 _worksID,
220         bytes32 _artistID, 
221         uint8 _debrisNum, 
222         uint256 _price, 
223         uint256 _beginTime,
224         bool _isPublish
225     );
226     event OnInitDebris(
227         bytes32 _worksID,
228         uint8 _debrisNum,
229         uint256 _initPrice
230     );
231     event OnUpdateDebris(
232         bytes32 _worksID, 
233         uint8 _debrisID, 
234         bytes32 _unionID, 
235         address indexed _sender
236     );
237     event OnUpdateFirstBuyer(
238         bytes32 _worksID, 
239         uint8 _debrisID, 
240         bytes32 _unionID, 
241         address indexed _sender
242     );
243     event OnUpdateBuyNum(bytes32 _worksID, uint8 _debrisID);
244     event OnFinish(bytes32 _worksID, bytes32 _unionID, uint256 _time);
245     event OnUpdatePools(bytes32 _worksID, uint256 _value);
246     event OnUpdateFirstUnionIds(bytes32 _worksID, bytes32 _unionID);
247     event OnUpdateSecondUnionIds(bytes32 _worksID, bytes32 _unionID);
248 
249     mapping(bytes32 => Datasets.Works) private works; 
250     mapping(bytes32 => Datasets.Rule) private rules; 
251     mapping(bytes32 => uint256) private pools; 
252     mapping(bytes32 => mapping(uint8 => Datasets.Debris)) private debris; 
253     mapping(bytes32 => bytes32[]) firstUnionID; 
254     mapping(bytes32 => bytes32[]) secondUnionID; 
255 
256     modifier whenHasWorks(bytes32 _worksID) {
257         require(works[_worksID].beginTime != 0);
258         _;
259     }
260 
261     modifier whenNotHasWorks(bytes32 _worksID) {
262         require(works[_worksID].beginTime == 0);
263         _;
264     }
265 
266     modifier whenHasArtist(bytes32 _artistID) {
267         require(artist.hasArtist(_artistID));
268         _;
269     }
270 
271     modifier onlyAdmin() {
272         require(team.isAdmin(msg.sender));
273         _;
274     }
275 
276     modifier onlyDev() {
277         require(team.isDev(msg.sender));
278         _;
279     }
280 
281     function upgrade(address _teamAddress, address _artistAddress) external onlyAdmin() {
282         require(_teamAddress != address(0) && _artistAddress != address(0));
283         team = TeamInterface(_teamAddress);
284         artist = ArtistInterface(_artistAddress);
285         emit OnUpgrade(_teamAddress, _artistAddress);
286     }
287 
288     function addWorks(
289         bytes32 _worksID,
290         bytes32 _artistID, 
291         uint8 _debrisNum, 
292         uint256 _price, 
293         uint256 _beginTime
294     ) 
295         external 
296         onlyAdmin()
297         whenNotHasWorks(_worksID)
298         whenHasArtist(_artistID)
299     {
300         require(
301             _debrisNum >= 2 && _debrisNum < 256 && 
302             _price > 0 && _price % _debrisNum == 0 &&
303             _beginTime > 0 && _beginTime > now 
304         ); 
305 
306         works[_worksID] = Datasets.Works(
307             _worksID, 
308             _artistID, 
309             _debrisNum, 
310             _price.mul(1 wei),
311             _beginTime, 
312             0,
313             false,
314             bytes32(0)
315         ); 
316 
317         emit OnAddWorks(
318             _worksID,
319             _artistID, 
320             _debrisNum, 
321             _price, 
322             _beginTime,
323             false
324         ); 
325 
326         initDebris(_worksID, _price, _debrisNum);
327     }
328 
329     function initDebris(bytes32 _worksID, uint256 _price, uint8 _debrisNum) private {      
330         uint256 initPrice = (_price / _debrisNum).mul(1 wei);
331         for(uint8 i=1; i<=_debrisNum; i++) {
332             debris[_worksID][i].worksID = _worksID;
333             debris[_worksID][i].initPrice = initPrice;
334         }
335         emit OnInitDebris(
336             _worksID,
337             _debrisNum,
338             initPrice
339         );
340     }
341 
342     function configRule(
343         bytes32 _worksID,
344         uint8 _firstBuyLimit, 
345         uint256 _freezeGap, 
346         uint256 _protectGap,
347         uint256 _increaseRatio, 
348         uint256 _discountGap,
349         uint256 _discountRatio,
350 
351         uint8[3] calldata _firstAllot,
352         uint8[3] calldata _againAllot, 
353         uint8[3] calldata _lastAllot
354     ) 
355         external
356         onlyAdmin()
357         whenHasWorks(_worksID)
358     {
359 
360         require(
361             _firstBuyLimit > 0 &&
362             _freezeGap > 0 &&
363             _protectGap > 0 &&
364             _increaseRatio > 0 && 
365             _discountGap > 0 &&
366             _discountRatio > 0 &&
367             _discountGap > _protectGap
368         );
369 
370         require(
371             _firstAllot[0] > 0 && _firstAllot[1] > 0 && _firstAllot[2] > 0 && 
372             _againAllot[0] > 0 && _againAllot[1] > 0 && _againAllot[2] > 0 &&
373             _lastAllot[0] > 0 && _lastAllot[1] > 0 && _lastAllot[2] > 0
374         ); 
375 
376         rules[_worksID] = Datasets.Rule(
377             _firstBuyLimit,
378             _freezeGap.mul(1 seconds),
379             _protectGap.mul(1 seconds),
380             _increaseRatio,
381             _discountGap.mul(1 seconds),    
382             _discountRatio,
383             _firstAllot,
384             _againAllot,
385             _lastAllot
386         );
387     }
388 
389     function publish(bytes32 _worksID, uint256 _beginTime) external onlyAdmin() {
390         require(works[_worksID].beginTime != 0 && works[_worksID].isPublish == false);
391         require(this.getAllot(_worksID, 0, 0) != 0);
392         if(_beginTime > 0) {
393             require(_beginTime > now);
394             works[_worksID].beginTime = _beginTime;
395         }
396         works[_worksID].isPublish = true;
397     }
398 
399     function close(bytes32 _worksID) external onlyAdmin() {
400         works[_worksID].isPublish = false;
401     }
402 
403     function getWorks(bytes32 _worksID) external view returns (uint8, uint256, uint256, uint256, bool) {
404         return (
405             works[_worksID].debrisNum,
406             works[_worksID].price,
407             works[_worksID].beginTime,
408             works[_worksID].endTime,
409             works[_worksID].isPublish
410         );
411     }
412 
413     function getDebris(bytes32 _worksID, uint8 _debrisID) external view 
414         returns (uint256, address, address, bytes32, bytes32, uint256) {
415         return (
416             debris[_worksID][_debrisID].buyNum,
417             debris[_worksID][_debrisID].firstBuyer,
418             debris[_worksID][_debrisID].lastBuyer,
419             debris[_worksID][_debrisID].firstUnionID,
420             debris[_worksID][_debrisID].lastUnionID,
421             debris[_worksID][_debrisID].lastTime
422         );
423     }
424 
425     function getRule(bytes32 _worksID) external view 
426         returns (uint256, uint256, uint256, uint8[3] memory, uint8[3] memory, uint8[3] memory) {
427         return (
428             rules[_worksID].increaseRatio,
429             rules[_worksID].discountGap,
430             rules[_worksID].discountRatio,
431             rules[_worksID].firstAllot,
432             rules[_worksID].againAllot,
433             rules[_worksID].lastAllot
434         );
435     }
436 
437     function hasWorks(bytes32 _worksID) external view returns (bool) {
438         return works[_worksID].beginTime != 0;
439     }
440 
441     function hasDebris(bytes32 _worksID, uint8 _debrisID) external view returns (bool) {
442         return _debrisID > 0 && _debrisID <= works[_worksID].debrisNum;
443     }
444 
445     function isPublish(bytes32 _worksID) external view returns (bool) {
446         return works[_worksID].isPublish;
447     }
448 
449     function isStart(bytes32 _worksID) external view returns (bool) {
450         return works[_worksID].beginTime <= now;
451     }
452 
453     function isProtect(bytes32 _worksID, uint8 _debrisID) external view returns (bool) {
454         if(debris[_worksID][_debrisID].lastTime == 0) {
455             return false;
456         }
457         uint256 protectGap = rules[_worksID].protectGap;
458         return debris[_worksID][_debrisID].lastTime.add(protectGap) < now ? false : true;
459     }
460 
461     function isSecond(bytes32 _worksID, uint8 _debrisID) external view returns (bool) {
462         return debris[_worksID][_debrisID].buyNum > 0;
463     }
464 
465     function isGameOver(bytes32 _worksID) external view returns (bool) {
466         return works[_worksID].endTime != 0;
467     }
468 
469     function isFinish(bytes32 _worksID, bytes32 _unionID) external view returns (bool) {
470         bool finish = true; 
471         uint8 i = 1;
472         while(i <= works[_worksID].debrisNum) {
473             if(debris[_worksID][i].lastUnionID != _unionID) {
474                 finish = false;
475                 break;
476             }
477             i++;
478         }
479         return finish;
480     } 
481 
482     function hasFirstUnionIds(bytes32 _worksID, bytes32 _unionID) external view returns (bool) {
483         if(0 == firstUnionID[_worksID].length) {
484             return false;
485         }
486         bool has = false;
487         for(uint256 i=0; i<firstUnionID[_worksID].length; i++) {
488             if(firstUnionID[_worksID][i] == _unionID) {
489                 has = true;
490                 break;
491             }
492         }
493         return has;
494     }
495 
496     function hasSecondUnionIds(bytes32 _worksID, bytes32 _unionID) external view returns (bool) {
497         if(0 == secondUnionID[_worksID].length) {
498             return false;
499         }
500         bool has = false;
501         for(uint256 i=0; i<secondUnionID[_worksID].length; i++) {
502             if(secondUnionID[_worksID][i] == _unionID) {
503                 has = true;
504                 break;
505             }
506         }
507         return has;
508     }  
509 
510     function getFirstUnionIds(bytes32 _worksID) external view returns (bytes32[] memory) {
511         return firstUnionID[_worksID];
512     }
513 
514     function getSecondUnionIds(bytes32 _worksID) external view returns (bytes32[] memory) {
515         return secondUnionID[_worksID];
516     }
517 
518     function getPrice(bytes32 _worksID) external view returns (uint256) {
519         return works[_worksID].price;
520     }
521 
522     function getDebrisPrice(bytes32 _worksID, uint8 _debrisID) external view returns(uint256) {        
523         uint256 discountGap = rules[_worksID].discountGap;
524         uint256 discountRatio = rules[_worksID].discountRatio;
525         uint256 increaseRatio = rules[_worksID].increaseRatio;
526         uint256 lastPrice;
527 
528         if(debris[_worksID][_debrisID].buyNum > 0 && debris[_worksID][_debrisID].lastTime.add(discountGap) < now) { 
529 
530             uint256 n = (now.sub(debris[_worksID][_debrisID].lastTime.add(discountGap))) / discountGap; 
531             if((now.sub(debris[_worksID][_debrisID].lastTime.add(discountGap))) % discountGap > 0) { 
532                 n = n.add(1);
533             }
534             for(uint256 i=0; i<n; i++) {
535                 if(0 == i) {
536                     lastPrice = debris[_worksID][_debrisID].lastPrice.mul(increaseRatio).mul(discountRatio) / 10000; 
537                 } else {
538                     lastPrice = lastPrice.mul(discountRatio) / 100;
539                 }
540             }
541 
542         } else if (debris[_worksID][_debrisID].buyNum > 0) { 
543             lastPrice = debris[_worksID][_debrisID].lastPrice.mul(increaseRatio) / 100;
544         } else {
545             lastPrice = debris[_worksID][_debrisID].initPrice; 
546         }
547 
548         return lastPrice;
549     }
550 
551     function getDebrisStatus(bytes32 _worksID, uint8 _debrisID) external view returns (uint256[4] memory, uint256, uint256, bytes32)  {
552         uint256 gap = 0;
553         uint256 status = 0;
554 
555         if(0 == debris[_worksID][_debrisID].buyNum) { 
556 
557         } else if(this.isProtect(_worksID, _debrisID)) { 
558             gap = rules[_worksID].protectGap;
559             status = 1;
560         } else { 
561 
562             if(debris[_worksID][_debrisID].lastTime.add(rules[_worksID].discountGap) > now) {
563                 gap = rules[_worksID].discountGap; 
564             } else {
565                 uint256 n = (now.sub(debris[_worksID][_debrisID].lastTime)) / rules[_worksID].discountGap; 
566                 if((now.sub(debris[_worksID][_debrisID].lastTime.add(rules[_worksID].discountGap))) % rules[_worksID].discountGap > 0) { 
567                     n = n.add(1);
568                 }
569                 gap = rules[_worksID].discountGap.mul(n); 
570             }
571             status = 2;
572 
573         }
574         uint256 price = this.getDebrisPrice(_worksID, _debrisID);
575         bytes32 lastUnionID = debris[_worksID][_debrisID].lastUnionID;
576         uint256[4] memory state = [status, debris[_worksID][_debrisID].lastTime, gap, now];
577         return (state, price, debris[_worksID][_debrisID].buyNum, lastUnionID);
578     }
579 
580     function getInitPrice(bytes32 _worksID, uint8 _debrisID) external view returns(uint256) {
581         return debris[_worksID][_debrisID].initPrice;
582     }
583 
584     function getLastPrice(bytes32 _worksID, uint8 _debrisID) external view returns(uint256) {
585         return debris[_worksID][_debrisID].lastPrice;
586     }
587 
588     function getLastBuyer(bytes32 _worksID, uint8 _debrisID) external view returns(address) {
589         return debris[_worksID][_debrisID].lastBuyer;
590     }
591 
592     function getLastUnionId(bytes32 _worksID, uint8 _debrisID) external view returns(bytes32) {
593         return debris[_worksID][_debrisID].lastUnionID;
594     }
595 
596     function getFreezeGap(bytes32 _worksID) external view returns(uint256) {
597         return rules[_worksID].freezeGap;
598     }
599 
600     function getFirstBuyLimit(bytes32 _worksID) external view returns(uint256) {
601         return rules[_worksID].firstBuyLimit;
602     }
603 
604     function getArtistId(bytes32 _worksID) external view returns(bytes32) {
605         return works[_worksID].artistID;
606     }
607 
608     function getDebrisNum(bytes32 _worksID) external view returns(uint8) {
609         return works[_worksID].debrisNum;
610     }
611 
612     function getAllot(bytes32 _worksID, uint8 _flag) external view returns(uint8[3] memory) {
613         require(_flag < 3);
614         if(0 == _flag) {
615             return rules[_worksID].firstAllot;
616         } else if(1 == _flag) {
617             return rules[_worksID].againAllot;
618         } else {
619             return rules[_worksID].lastAllot;
620         }        
621     }
622 
623     function getAllot(bytes32 _worksID, uint8 _flag, uint8 _element) external view returns(uint8) {
624         require(_flag < 3 && _element < 3);
625         if(0 == _flag) {
626             return rules[_worksID].firstAllot[_element];
627         } else if(1 == _flag) {
628             return rules[_worksID].againAllot[_element];
629         } else {
630             return rules[_worksID].lastAllot[_element];
631         }        
632     }
633 
634     function getPools(bytes32 _worksID) external view returns (uint256) {
635         return pools[_worksID];
636     }
637 
638     function getPoolsAllot(bytes32 _worksID) external view returns (uint256, uint256[3] memory, uint8[3] memory) {
639         require(works[_worksID].endTime != 0); 
640 
641         uint8[3] memory lastAllot = this.getAllot(_worksID, 2); 
642         uint256 finishAccount = pools[_worksID].mul(lastAllot[0]) / 100; 
643         uint256 firstAccount = pools[_worksID].mul(lastAllot[1]) / 100;
644         uint256 allAccount = pools[_worksID].mul(lastAllot[2]) / 100;
645         uint256[3] memory account = [finishAccount, firstAccount, allAccount];   
646 
647         return (pools[_worksID], account, lastAllot);
648     }
649 
650     function getStartHourglass(bytes32 _worksID) external view returns(uint256) {
651         if(works[_worksID].beginTime > 0 && works[_worksID].beginTime > now ) {
652             return works[_worksID].beginTime.sub(now);
653         }
654         return 0;
655     }
656 
657     function getWorksStatus(bytes32 _worksID) external view returns (uint256, uint256, uint256, bytes32) {
658         return (works[_worksID].beginTime, works[_worksID].endTime, now, works[_worksID].lastUnionID);
659     }
660 
661     function getProtectHourglass(bytes32 _worksID, uint8 _debrisID) external view returns(uint256) {
662         if(
663             debris[_worksID][_debrisID].lastTime > 0 && 
664             debris[_worksID][_debrisID].lastTime.add(rules[_worksID].protectGap) > now
665         ) {
666             return debris[_worksID][_debrisID].lastTime.add(rules[_worksID].protectGap).sub(now);
667         }
668         return 0;
669     }
670 
671     function getDiscountHourglass(bytes32 _worksID, uint8 _debrisID) external view returns(uint256) {
672         if(debris[_worksID][_debrisID].lastTime == 0) {
673             return 0;
674         }
675         uint256 discountGap = rules[_worksID].discountGap;
676         uint256 n = (now.sub(debris[_worksID][_debrisID].lastTime)) / discountGap; 
677         if((now.sub(debris[_worksID][_debrisID].lastTime)) % discountGap > 0) { 
678             n = n.add(1);
679         }
680         return debris[_worksID][_debrisID].lastTime.add(discountGap.mul(n)).sub(now);
681     }
682 
683     function updateDebris(bytes32 _worksID, uint8 _debrisID, bytes32 _unionID, address payable _sender) external onlyDev() {
684         debris[_worksID][_debrisID].lastPrice = this.getDebrisPrice(_worksID, _debrisID);
685         debris[_worksID][_debrisID].lastUnionID = _unionID; 
686         debris[_worksID][_debrisID].lastBuyer = _sender; 
687         debris[_worksID][_debrisID].lastTime = now; 
688         emit OnUpdateDebris(_worksID, _debrisID, _unionID, _sender);
689     }
690 
691     function updateFirstBuyer(bytes32 _worksID, uint8 _debrisID, bytes32 _unionID, address payable _sender) external onlyDev() {
692         debris[_worksID][_debrisID].firstBuyer = _sender;
693         debris[_worksID][_debrisID].firstUnionID = _unionID;
694         emit OnUpdateFirstBuyer(_worksID, _debrisID, _unionID, _sender);
695         this.updateFirstUnionIds(_worksID, _unionID);
696     }
697 
698     function updateBuyNum(bytes32 _worksID, uint8 _debrisID) external onlyDev() {
699         debris[_worksID][_debrisID].buyNum = debris[_worksID][_debrisID].buyNum.add(1);
700         emit OnUpdateBuyNum(_worksID, _debrisID);
701     }
702 
703     function finish(bytes32 _worksID, bytes32 _unionID) external onlyDev() {
704         works[_worksID].endTime = now;
705         works[_worksID].lastUnionID = _unionID;
706         emit OnFinish(_worksID, _unionID, now);
707     }
708 
709     function updatePools(bytes32 _worksID, uint256 _value) external onlyDev() {
710         pools[_worksID] = pools[_worksID].add(_value);
711         emit OnUpdatePools(_worksID, _value);
712     }
713 
714     function updateFirstUnionIds(bytes32 _worksID, bytes32 _unionID) external onlyDev() {
715         if(this.hasFirstUnionIds(_worksID, _unionID) == false) {
716             firstUnionID[_worksID].push(_unionID);
717             emit OnUpdateFirstUnionIds(_worksID, _unionID);
718         }
719     }
720 
721     function updateSecondUnionIds(bytes32 _worksID, bytes32 _unionID) external onlyDev() {
722         if(this.hasSecondUnionIds(_worksID, _unionID) == false) {
723             secondUnionID[_worksID].push(_unionID);
724             emit OnUpdateSecondUnionIds(_worksID, _unionID);
725         }
726     }
727 
728  }