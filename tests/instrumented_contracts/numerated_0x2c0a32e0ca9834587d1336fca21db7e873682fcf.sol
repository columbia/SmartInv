1 pragma solidity ^0.5.7;
2 
3 // WESION Public Sale
4 
5 
6 /**
7  * @title SafeMath for uint256
8  * @dev Unsigned math operations with safety checks that revert on error.
9  */
10 library SafeMath256 {
11     /**
12      * @dev Adds two unsigned integers, reverts on overflow.
13      */
14     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
15         c = a + b;
16         assert(c >= a);
17         return c;
18     }
19 
20     /**
21      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
22      */
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         assert(b <= a);
25         return a - b;
26     }
27 
28     /**
29      * @dev Multiplies two unsigned integers, reverts on overflow.
30      */
31     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
32         if (a == 0) {
33             return 0;
34         }
35         c = a * b;
36         assert(c / a == b);
37         return c;
38     }
39 
40     /**
41      * @dev Integer division of two unsigned integers truncating the quotient,
42      * reverts on division by zero.
43      */
44     function div(uint256 a, uint256 b) internal pure returns (uint256) {
45         assert(b > 0);
46         uint256 c = a / b;
47         assert(a == b * c + a % b);
48         return a / b;
49     }
50 
51     /**
52      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
53      * reverts when dividing by zero.
54      */
55     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
56         require(b != 0);
57         return a % b;
58     }
59 }
60 
61 /**
62  * @title SafeMath for uint16
63  * @dev Unsigned math operations with safety checks that revert on error.
64  */
65 library SafeMath16 {
66     /**
67      * @dev Adds two unsigned integers, reverts on overflow.
68      */
69     function add(uint16 a, uint16 b) internal pure returns (uint16 c) {
70         c = a + b;
71         assert(c >= a);
72         return c;
73     }
74 
75     /**
76      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
77      */
78     function sub(uint16 a, uint16 b) internal pure returns (uint16) {
79         assert(b <= a);
80         return a - b;
81     }
82 
83     /**
84      * @dev Multiplies two unsigned integers, reverts on overflow.
85      */
86     function mul(uint16 a, uint16 b) internal pure returns (uint16 c) {
87         if (a == 0) {
88             return 0;
89         }
90         c = a * b;
91         assert(c / a == b);
92         return c;
93     }
94 
95     /**
96      * @dev Integer division of two unsigned integers truncating the quotient,
97      * reverts on division by zero.
98      */
99     function div(uint16 a, uint16 b) internal pure returns (uint16) {
100         assert(b > 0);
101         uint256 c = a / b;
102         assert(a == b * c + a % b);
103         return a / b;
104     }
105 
106     /**
107      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
108      * reverts when dividing by zero.
109      */
110     function mod(uint16 a, uint16 b) internal pure returns (uint16) {
111         require(b != 0);
112         return a % b;
113     }
114 }
115 
116 
117 /**
118  * @title Ownable
119  */
120 contract Ownable {
121     address private _owner;
122     address payable internal _receiver;
123 
124     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
125     event ReceiverChanged(address indexed previousReceiver, address indexed newReceiver);
126 
127     /**
128      * @dev The Ownable constructor sets the original `owner` of the contract
129      * to the sender account.
130      */
131     constructor () internal {
132         _owner = msg.sender;
133         _receiver = msg.sender;
134     }
135 
136     /**
137      * @return The address of the owner.
138      */
139     function owner() public view returns (address) {
140         return _owner;
141     }
142 
143     /**
144      * @dev Throws if called by any account other than the owner.
145      */
146     modifier onlyOwner() {
147         require(msg.sender == _owner);
148         _;
149     }
150 
151     /**
152      * @dev Allows the current owner to transfer control of the contract to a newOwner.
153      * @param newOwner The address to transfer ownership to.
154      */
155     function transferOwnership(address newOwner) external onlyOwner {
156         require(newOwner != address(0));
157         address __previousOwner = _owner;
158         _owner = newOwner;
159         emit OwnershipTransferred(__previousOwner, newOwner);
160     }
161 
162     /**
163      * @dev Change receiver.
164      */
165     function changeReceiver(address payable newReceiver) external onlyOwner {
166         require(newReceiver != address(0));
167         address __previousReceiver = _receiver;
168         _receiver = newReceiver;
169         emit ReceiverChanged(__previousReceiver, newReceiver);
170     }
171 
172     /**
173      * @dev Rescue compatible ERC20 Token
174      *
175      * @param tokenAddr ERC20 The address of the ERC20 token contract
176      * @param receiver The address of the receiver
177      * @param amount uint256
178      */
179     function rescueTokens(address tokenAddr, address receiver, uint256 amount) external onlyOwner {
180         IERC20 _token = IERC20(tokenAddr);
181         require(receiver != address(0));
182         uint256 balance = _token.balanceOf(address(this));
183         require(balance >= amount);
184 
185         assert(_token.transfer(receiver, amount));
186     }
187 
188     /**
189      * @dev Withdraw ether
190      */
191     function withdrawEther(address payable to, uint256 amount) external onlyOwner {
192         require(to != address(0));
193         uint256 balance = address(this).balance;
194         require(balance >= amount);
195 
196         to.transfer(amount);
197     }
198 }
199 
200 
201 /**
202  * @title Pausable
203  * @dev Base contract which allows children to implement an emergency stop mechanism.
204  */
205 contract Pausable is Ownable {
206     bool private _paused;
207 
208     event Paused(address account);
209     event Unpaused(address account);
210 
211     constructor () internal {
212         _paused = false;
213     }
214 
215     /**
216      * @return Returns true if the contract is paused, false otherwise.
217      */
218     function paused() public view returns (bool) {
219         return _paused;
220     }
221 
222     /**
223      * @dev Modifier to make a function callable only when the contract is not paused.
224      */
225     modifier whenNotPaused() {
226         require(!_paused, "Paused.");
227         _;
228     }
229 
230     /**
231      * @dev Called by a pauser to pause, triggers stopped state.
232      */
233     function setPaused(bool state) external onlyOwner {
234         if (_paused && !state) {
235             _paused = false;
236             emit Unpaused(msg.sender);
237         } else if (!_paused && state) {
238             _paused = true;
239             emit Paused(msg.sender);
240         }
241     }
242 }
243 
244 
245 /**
246  * @title ERC20 interface
247  * @dev see https://eips.ethereum.org/EIPS/eip-20
248  */
249 interface IERC20 {
250     function balanceOf(address owner) external view returns (uint256);
251     function transfer(address to, uint256 value) external returns (bool);
252 }
253 
254 
255 /**
256  * @title WESION interface
257  */
258 interface IWesion {
259     function balanceOf(address owner) external view returns (uint256);
260     function transfer(address to, uint256 value) external returns (bool);
261     function inWhitelist(address account) external view returns (bool);
262     function referrer(address account) external view returns (address);
263     function refCount(address account) external view returns (uint256);
264 }
265 
266 
267 /**
268  * @title WESION Public Sale
269  */
270 contract WesionPublicSale is Ownable, Pausable{
271     using SafeMath16 for uint16;
272     using SafeMath256 for uint256;
273 
274     // WESION
275     IWesion public WESION = IWesion(0x2c1564A74F07757765642ACef62a583B38d5A213);
276 
277     // Start timestamp
278     uint32 _startTimestamp;
279 
280     // Audit ether price
281     uint256 private _etherPrice;    // 1 Ether = xx.xxxxxx USD, with 6 decimals
282 
283     // Referral rewards, 35% for 15 levels
284     uint16 private WHITELIST_REF_REWARDS_PCT_SUM = 35;
285     uint16[15] private WHITELIST_REF_REWARDS_PCT = [
286         6,  // 6% for Level.1
287         6,  // 6% for Level.2
288         5,  // 5% for Level.3
289         4,  // 4% for Level.4
290         3,  // 3% for Level.5
291         2,  // 2% for Level.6
292         1,  // 1% for Level.7
293         1,  // 1% for Level.8
294         1,  // 1% for Level.9
295         1,  // 1% for Level.10
296         1,  // 1% for Level.11
297         1,  // 1% for Level.12
298         1,  // 1% for Level.13
299         1,  // 1% for Level.14
300         1   // 1% for Level.15
301     ];
302 
303     // Wei & Gas
304     uint72 private WEI_MIN = 0.1 ether;     // 0.1 Ether Minimum
305     uint72 private WEI_MAX = 100 ether;     // 100 Ether Maximum
306     uint72 private WEI_BONUS = 10 ether;    // >10 Ether for Bonus
307     uint24 private GAS_MIN = 3000000;       // 3.0 Mwei gas Mininum
308     uint24 private GAS_EX = 1500000;        // 1.5 Mwei gas for ex
309 
310     // Price
311     uint256 private WESION_USD_PRICE_START = 1000;       // $      0.00100 USD
312     uint256 private WESION_USD_PRICE_STEP = 10;          // $    + 0.00001 USD
313     uint256 private STAGE_USD_CAP_START = 100000000;    // $    100 USD
314     uint256 private STAGE_USD_CAP_STEP = 1000000;       // $     +1 USD
315     uint256 private STAGE_USD_CAP_MAX = 15100000000;    // $ 15,100 USD
316 
317     uint256 private _WESIONUsdPrice = WESION_USD_PRICE_START;
318 
319     // Progress
320     uint16 private STAGE_MAX = 60000;   // 60,000 stages total
321     uint16 private SEASON_MAX = 100;    // 100 seasons total
322     uint16 private SEASON_STAGES = 600; // each 600 stages is a season
323 
324     uint16 private _stage;
325     uint16 private _season;
326 
327     // Sum
328     uint256 private _txs;
329     uint256 private _WESIONTxs;
330     uint256 private _WESIONBonusTxs;
331     uint256 private _WESIONWhitelistTxs;
332     uint256 private _WESIONIssued;
333     uint256 private _WESIONBonus;
334     uint256 private _WESIONWhitelist;
335     uint256 private _weiSold;
336     uint256 private _weiRefRewarded;
337     uint256 private _weiTopSales;
338     uint256 private _weiTeam;
339     uint256 private _weiPending;
340     uint256 private _weiPendingTransfered;
341 
342     // Top-Sales
343     uint256 private TOP_SALES_RATIO_START = 15000000;         // 15%, with 8 decimals
344     uint256 private TOP_SALES_RATIO_DISTANCE = 50000000;      // 50%, with 8 decimals
345 
346     uint256 private _topSalesRatio = TOP_SALES_RATIO_START;   // 15% + 50% x(_stage/_stageMax)
347 
348     // During tx
349     bool private _inWhitelist_;
350     uint256 private _pending_ = WHITELIST_REF_REWARDS_PCT_SUM;
351     uint16[] private _rewards_;
352     address[] private _referrers_;
353 
354     // Audit ether price auditor
355     mapping (address => bool) private _etherPriceAuditors;
356 
357     // Stage
358     mapping (uint16 => uint256) private _stageUsdSold;
359     mapping (uint16 => uint256) private _stageWESIONIssued;
360 
361     // Season
362     mapping (uint16 => uint256) private _seasonWeiSold;
363     mapping (uint16 => uint256) private _seasonWeiTopSales;
364     mapping (uint16 => uint256) private _seasonWeiTopSalesTransfered;
365 
366     // Account
367     mapping (address => uint256) private _accountWESIONIssued;
368     mapping (address => uint256) private _accountWESIONBonus;
369     mapping (address => uint256) private _accountWESIONWhitelisted;
370     mapping (address => uint256) private _accountWeiPurchased;
371     mapping (address => uint256) private _accountWeiRefRewarded;
372 
373     // Ref
374     mapping (uint16 => address[]) private _seasonRefAccounts;
375     mapping (uint16 => mapping (address => bool)) private _seasonHasRefAccount;
376     mapping (uint16 => mapping (address => uint256)) private _usdSeasonAccountPurchased;
377     mapping (uint16 => mapping (address => uint256)) private _usdSeasonAccountRef;
378 
379     // Events
380     event AuditEtherPriceChanged(uint256 value, address indexed account);
381     event AuditEtherPriceAuditorChanged(address indexed account, bool state);
382 
383     event WESIONBonusTransfered(address indexed to, uint256 amount);
384     event WESIONWhitelistTransfered(address indexed to, uint256 amount);
385     event WESIONIssuedTransfered(uint16 stageIndex, address indexed to, uint256 WESIONAmount, uint256 auditEtherPrice, uint256 weiUsed);
386 
387     event StageClosed(uint256 _stageNumber, address indexed account);
388     event SeasonClosed(uint16 _seasonNumber, address indexed account);
389 
390     event SeasonTopSalesWeiTransfered(uint16 seasonNumber, address indexed to, uint256 amount);
391     event TeamWeiTransfered(address indexed to, uint256 amount);
392     event PendingWeiTransfered(address indexed to, uint256 amount);
393 
394 
395     /**
396      * @dev Start timestamp.
397      */
398     function startTimestamp() public view returns (uint32) {
399         return _startTimestamp;
400     }
401 
402     /**
403      * @dev Set start timestamp.
404      */
405     function setStartTimestamp(uint32 timestamp) external onlyOwner {
406         _startTimestamp = timestamp;
407     }
408 
409     /**
410      * @dev Throws if not ether price auditor.
411      */
412     modifier onlyEtherPriceAuditor() {
413         require(_etherPriceAuditors[msg.sender]);
414         _;
415     }
416 
417     /**
418      * @dev Set audit ether price.
419      */
420     function setEtherPrice(uint256 value) external onlyEtherPriceAuditor {
421         _etherPrice = value;
422         emit AuditEtherPriceChanged(value, msg.sender);
423     }
424 
425     /**
426      * @dev Get ether price auditor state.
427      */
428     function etherPriceAuditor(address account) public view returns (bool) {
429         return _etherPriceAuditors[account];
430     }
431 
432     /**
433      * @dev Get ether price auditor state.
434      */
435     function setEtherPriceAuditor(address account, bool state) external onlyOwner {
436         _etherPriceAuditors[account] = state;
437         emit AuditEtherPriceAuditorChanged(account, state);
438     }
439 
440     /**
441      * @dev Stage WESION price in USD, by stage index.
442      */
443     function stageWESIONUsdPrice(uint16 stageIndex) private view returns (uint256) {
444         return WESION_USD_PRICE_START.add(WESION_USD_PRICE_STEP.mul(stageIndex));
445     }
446 
447     /**
448      * @dev wei => USD
449      */
450     function wei2usd(uint256 amount) private view returns (uint256) {
451         return amount.mul(_etherPrice).div(1 ether);
452     }
453 
454     /**
455      * @dev USD => wei
456      */
457     function usd2wei(uint256 amount) private view returns (uint256) {
458         return amount.mul(1 ether).div(_etherPrice);
459     }
460 
461     /**
462      * @dev USD => WESION
463      */
464     function usd2WESION(uint256 usdAmount) private view returns (uint256) {
465         return usdAmount.mul(1000000).div(_WESIONUsdPrice);
466     }
467 
468     /**
469      * @dev USD => WESION
470      */
471     function usd2WESIONByStage(uint256 usdAmount, uint16 stageIndex) public view returns (uint256) {
472         return usdAmount.mul(1000000).div(stageWESIONUsdPrice(stageIndex));
473     }
474 
475     /**
476      * @dev Calculate season number, by stage index.
477      */
478     function calcSeason(uint16 stageIndex) private view returns (uint16) {
479         if (stageIndex > 0) {
480             uint16 __seasonNumber = stageIndex.div(SEASON_STAGES);
481 
482             if (stageIndex.mod(SEASON_STAGES) > 0) {
483                 return __seasonNumber.add(1);
484             }
485 
486             return __seasonNumber;
487         }
488 
489         return 1;
490     }
491 
492     /**
493      * @dev Transfer Top-Sales wei, by season number.
494      */
495     function transferTopSales(uint16 seasonNumber, address payable to) external onlyOwner {
496         uint256 __weiRemain = seasonTopSalesRemain(seasonNumber);
497         require(to != address(0));
498 
499         _seasonWeiTopSalesTransfered[seasonNumber] = _seasonWeiTopSalesTransfered[seasonNumber].add(__weiRemain);
500         emit SeasonTopSalesWeiTransfered(seasonNumber, to, __weiRemain);
501         to.transfer(__weiRemain);
502     }
503 
504     /**
505      * @dev Pending remain, in wei.
506      */
507     function pendingRemain() private view returns (uint256) {
508         return _weiPending.sub(_weiPendingTransfered);
509     }
510 
511     /**
512      * @dev Transfer pending wei.
513      */
514     function transferPending(address payable to) external onlyOwner {
515         uint256 __weiRemain = pendingRemain();
516         require(to != address(0));
517 
518         _weiPendingTransfered = _weiPendingTransfered.add(__weiRemain);
519         emit PendingWeiTransfered(to, __weiRemain);
520         to.transfer(__weiRemain);
521     }
522 
523     /**
524      * @dev Transfer team wei.
525      */
526     function transferTeam(address payable to) external onlyOwner {
527         uint256 __weiRemain = _weiSold.sub(_weiRefRewarded).sub(_weiTopSales).sub(_weiPending).sub(_weiTeam);
528         require(to != address(0));
529 
530         _weiTeam = _weiTeam.add(__weiRemain);
531         emit TeamWeiTransfered(to, __weiRemain);
532         to.transfer(__weiRemain);
533     }
534 
535     /**
536      * @dev Status.
537      */
538     function status() public view returns (uint256 auditEtherPrice,
539                                            uint16 stage,
540                                            uint16 season,
541                                            uint256 WESIONUsdPrice,
542                                            uint256 currentTopSalesRatio,
543                                            uint256 txs,
544                                            uint256 WESIONTxs,
545                                            uint256 WESIONBonusTxs,
546                                            uint256 WESIONWhitelistTxs,
547                                            uint256 WESIONIssued,
548                                            uint256 WESIONBonus,
549                                            uint256 WESIONWhitelist) {
550         auditEtherPrice = _etherPrice;
551 
552         if (_stage > STAGE_MAX) {
553             stage = STAGE_MAX;
554             season = SEASON_MAX;
555         } else {
556             stage = _stage;
557             season = _season;
558         }
559 
560         WESIONUsdPrice = _WESIONUsdPrice;
561         currentTopSalesRatio = _topSalesRatio;
562 
563         txs = _txs;
564         WESIONTxs = _WESIONTxs;
565         WESIONBonusTxs = _WESIONBonusTxs;
566         WESIONWhitelistTxs = _WESIONWhitelistTxs;
567         WESIONIssued = _WESIONIssued;
568         WESIONBonus = _WESIONBonus;
569         WESIONWhitelist = _WESIONWhitelist;
570     }
571 
572     /**
573      * @dev Sum.
574      */
575     function sum() public view returns(uint256 weiSold,
576                                        uint256 weiReferralRewarded,
577                                        uint256 weiTopSales,
578                                        uint256 weiTeam,
579                                        uint256 weiPending,
580                                        uint256 weiPendingTransfered,
581                                        uint256 weiPendingRemain) {
582         weiSold = _weiSold;
583         weiReferralRewarded = _weiRefRewarded;
584         weiTopSales = _weiTopSales;
585         weiTeam = _weiTeam;
586         weiPending = _weiPending;
587         weiPendingTransfered = _weiPendingTransfered;
588         weiPendingRemain = pendingRemain();
589     }
590 
591     /**
592      * @dev Throws if gas is not enough.
593      */
594     modifier enoughGas() {
595         require(gasleft() > GAS_MIN);
596         _;
597     }
598 
599     /**
600      * @dev Throws if not started.
601      */
602     modifier onlyOnSale() {
603         require(_startTimestamp > 0 && now > _startTimestamp, "WESION Public-Sale has not started yet.");
604         require(_etherPrice > 0, "Audit ETH price must be greater than zero.");
605         require(!paused(), "WESION Public-Sale is paused.");
606         require(_stage <= STAGE_MAX, "WESION Public-Sale Closed.");
607         _;
608     }
609 
610     /**
611      * @dev Top-Sales ratio.
612      */
613     function topSalesRatio(uint16 stageIndex) private view returns (uint256) {
614         return TOP_SALES_RATIO_START.add(TOP_SALES_RATIO_DISTANCE.mul(stageIndex).div(STAGE_MAX));
615     }
616 
617     /**
618      * @dev USD => wei, for Top-Sales
619      */
620     function usd2weiTopSales(uint256 usdAmount) private view returns (uint256) {
621         return usd2wei(usdAmount.mul(_topSalesRatio).div(100000000));
622     }
623 
624     /**
625      * @dev Calculate stage dollor cap, by stage index.
626      */
627     function stageUsdCap(uint16 stageIndex) private view returns (uint256) {
628         uint256 __usdCap = STAGE_USD_CAP_START.add(STAGE_USD_CAP_STEP.mul(stageIndex));
629 
630         if (__usdCap > STAGE_USD_CAP_MAX) {
631             return STAGE_USD_CAP_MAX;
632         }
633 
634         return __usdCap;
635     }
636 
637     /**
638      * @dev Stage Vokdn cap, by stage index.
639      */
640     function stageWESIONCap(uint16 stageIndex) private view returns (uint256) {
641         return usd2WESIONByStage(stageUsdCap(stageIndex), stageIndex);
642     }
643 
644     /**
645      * @dev Stage status, by stage index.
646      */
647     function stageStatus(uint16 stageIndex) public view returns (uint256 WESIONUsdPrice,
648                                                                  uint256 WESIONCap,
649                                                                  uint256 WESIONOnSale,
650                                                                  uint256 WESIONSold,
651                                                                  uint256 usdCap,
652                                                                  uint256 usdOnSale,
653                                                                  uint256 usdSold,
654                                                                  uint256 weiTopSalesRatio) {
655         if (stageIndex > STAGE_MAX) {
656             return (0, 0, 0, 0, 0, 0, 0, 0);
657         }
658 
659         WESIONUsdPrice = stageWESIONUsdPrice(stageIndex);
660 
661         WESIONSold = _stageWESIONIssued[stageIndex];
662         WESIONCap = stageWESIONCap(stageIndex);
663         WESIONOnSale = WESIONCap.sub(WESIONSold);
664 
665         usdSold = _stageUsdSold[stageIndex];
666         usdCap = stageUsdCap(stageIndex);
667         usdOnSale = usdCap.sub(usdSold);
668 
669         weiTopSalesRatio = topSalesRatio(stageIndex);
670     }
671 
672     /**
673      * @dev Season Top-Sales remain, in wei.
674      */
675     function seasonTopSalesRemain(uint16 seasonNumber) private view returns (uint256) {
676         return _seasonWeiTopSales[seasonNumber].sub(_seasonWeiTopSalesTransfered[seasonNumber]);
677     }
678 
679     /**
680      * @dev Season Top-Sales rewards, by season number, in wei.
681      */
682     function seasonTopSalesRewards(uint16 seasonNumber) public view returns (uint256 weiSold,
683                                                                              uint256 weiTopSales,
684                                                                              uint256 weiTopSalesTransfered,
685                                                                              uint256 weiTopSalesRemain) {
686         weiSold = _seasonWeiSold[seasonNumber];
687         weiTopSales = _seasonWeiTopSales[seasonNumber];
688         weiTopSalesTransfered = _seasonWeiTopSalesTransfered[seasonNumber];
689         weiTopSalesRemain = seasonTopSalesRemain(seasonNumber);
690     }
691 
692     /**
693      * @dev Query account.
694      */
695     function accountQuery(address account) public view returns (uint256 WESIONIssued,
696                                                                 uint256 WESIONBonus,
697                                                                 uint256 WESIONWhitelisted,
698                                                                 uint256 weiPurchased,
699                                                                 uint256 weiReferralRewarded) {
700         WESIONIssued = _accountWESIONIssued[account];
701         WESIONBonus = _accountWESIONBonus[account];
702         WESIONWhitelisted = _accountWESIONWhitelisted[account];
703         weiPurchased = _accountWeiPurchased[account];
704         weiReferralRewarded = _accountWeiRefRewarded[account];
705     }
706 
707     /**
708      * @dev Accounts in a specific season.
709      */
710     function seasonRefAccounts(uint16 seasonNumber) public view returns (address[] memory accounts) {
711         accounts = _seasonRefAccounts[seasonNumber];
712     }
713 
714     /**
715      * @dev Season number => account => USD purchased.
716      */
717     function usdSeasonAccountPurchased(uint16 seasonNumber, address account) public view returns (uint256) {
718         return _usdSeasonAccountPurchased[seasonNumber][account];
719     }
720 
721     /**
722      * @dev Season number => account => referral dollors.
723      */
724     function usdSeasonAccountRef(uint16 seasonNumber, address account) public view returns (uint256) {
725         return _usdSeasonAccountRef[seasonNumber][account];
726     }
727 
728     /**
729      * @dev constructor
730      */
731     constructor () public {
732         _etherPriceAuditors[msg.sender] = true;
733         _stage = 0;
734         _season = 1;
735     }
736 
737     /**
738      * @dev Receive ETH, and send WESIONs.
739      */
740     function () external payable enoughGas onlyOnSale {
741         require(msg.value >= WEI_MIN);
742         require(msg.value <= WEI_MAX);
743 
744         // Set temporary variables.
745         setTemporaryVariables();
746         uint256 __usdAmount = wei2usd(msg.value);
747         uint256 __usdRemain = __usdAmount;
748         uint256 __WESIONIssued;
749         uint256 __WESIONBonus;
750         uint256 __usdUsed;
751         uint256 __weiUsed;
752 
753         // USD => WESION
754         while (gasleft() > GAS_EX && __usdRemain > 0 && _stage <= STAGE_MAX) {
755             uint256 __txWESIONIssued;
756             (__txWESIONIssued, __usdRemain) = ex(__usdRemain);
757             __WESIONIssued = __WESIONIssued.add(__txWESIONIssued);
758         }
759 
760         // Used
761         __usdUsed = __usdAmount.sub(__usdRemain);
762         __weiUsed = usd2wei(__usdUsed);
763 
764         // Bonus 10%
765         if (msg.value >= WEI_BONUS) {
766             __WESIONBonus = __WESIONIssued.div(10);
767             assert(transferWESIONBonus(__WESIONBonus));
768         }
769 
770         // Whitelisted
771         // BUY-ONE-AND-GET-ONE-MORE-FREE
772         if (_inWhitelist_ && __WESIONIssued > 0) {
773             // both issued and bonus
774             assert(transferWESIONWhitelisted(__WESIONIssued.add(__WESIONBonus)));
775 
776             // 35% for 15 levels
777             sendWhitelistReferralRewards(__weiUsed);
778         }
779 
780         // If wei remains, refund.
781         if (__usdRemain > 0) {
782             uint256 __weiRemain = usd2wei(__usdRemain);
783 
784             __weiUsed = msg.value.sub(__weiRemain);
785 
786             // Refund wei back
787             msg.sender.transfer(__weiRemain);
788         }
789 
790         // Counter
791         if (__weiUsed > 0) {
792             _txs = _txs.add(1);
793             _weiSold = _weiSold.add(__weiUsed);
794             _accountWeiPurchased[msg.sender] = _accountWeiPurchased[msg.sender].add(__weiUsed);
795         }
796 
797         // Wei team
798         uint256 __weiTeam;
799         if (_season > SEASON_MAX)
800             __weiTeam = _weiSold.sub(_weiRefRewarded).sub(_weiTopSales).sub(_weiPending).sub(_weiTeam);
801         else
802             __weiTeam = _weiSold.sub(_weiRefRewarded).sub(_weiTopSales).sub(_weiPending).sub(_weiTeam).div(0.01 ether).mul(0.01 ether);
803 
804         _weiTeam = _weiTeam.add(__weiTeam);
805         _receiver.transfer(__weiTeam);
806 
807         // Assert finished
808         assert(true);
809     }
810 
811     /**
812      * @dev Set temporary variables.
813      */
814     function setTemporaryVariables() private {
815         delete _referrers_;
816         delete _rewards_;
817 
818         _inWhitelist_ = WESION.inWhitelist(msg.sender);
819         _pending_ = WHITELIST_REF_REWARDS_PCT_SUM;
820 
821         address __cursor = msg.sender;
822         for(uint16 i = 0; i < WHITELIST_REF_REWARDS_PCT.length; i++) {
823             address __refAccount = WESION.referrer(__cursor);
824 
825             if (__cursor == __refAccount) {
826                 _rewards_.push(uint16(_pending_));
827                 _referrers_.push(address(this));
828                 _pending_ = 0;
829                 break;
830             }
831 
832             if (WESION.refCount(__refAccount) > i) {
833                 if (!_seasonHasRefAccount[_season][__refAccount]) {
834                     _seasonRefAccounts[_season].push(__refAccount);
835                     _seasonHasRefAccount[_season][__refAccount] = true;
836                 }
837 
838                 _pending_ = _pending_.sub(WHITELIST_REF_REWARDS_PCT[i]);
839                 _rewards_.push(WHITELIST_REF_REWARDS_PCT[i]);
840                 _referrers_.push(__refAccount);
841             }
842 
843             __cursor = __refAccount;
844         }
845     }
846 
847     /**
848      * @dev USD => WESION
849      */
850     function ex(uint256 usdAmount) private returns (uint256, uint256) {
851         uint256 __stageUsdCap = stageUsdCap(_stage);
852         uint256 __WESIONIssued;
853 
854         // in stage
855         if (_stageUsdSold[_stage].add(usdAmount) <= __stageUsdCap) {
856             exCount(usdAmount);
857 
858             __WESIONIssued = usd2WESION(usdAmount);
859             assert(transferWESIONIssued(__WESIONIssued, usdAmount));
860 
861             // close stage, if stage dollor cap reached
862             if (__stageUsdCap == _stageUsdSold[_stage]) {
863                 assert(closeStage());
864             }
865 
866             return (__WESIONIssued, 0);
867         }
868 
869         // close stage
870         uint256 __usdUsed = __stageUsdCap.sub(_stageUsdSold[_stage]);
871         uint256 __usdRemain = usdAmount.sub(__usdUsed);
872 
873         exCount(__usdUsed);
874 
875         __WESIONIssued = usd2WESION(__usdUsed);
876         assert(transferWESIONIssued(__WESIONIssued, __usdUsed));
877         assert(closeStage());
878 
879         return (__WESIONIssued, __usdRemain);
880     }
881 
882     /**
883      * @dev Ex counter.
884      */
885     function exCount(uint256 usdAmount) private {
886         uint256 __weiSold = usd2wei(usdAmount);
887         uint256 __weiTopSales = usd2weiTopSales(usdAmount);
888 
889         _usdSeasonAccountPurchased[_season][msg.sender] = _usdSeasonAccountPurchased[_season][msg.sender].add(usdAmount);   // season => address => purchased, in USD
890 
891         _stageUsdSold[_stage] = _stageUsdSold[_stage].add(usdAmount);                   // stage sold, in USD
892         _seasonWeiSold[_season] = _seasonWeiSold[_season].add(__weiSold);               // season sold, in wei
893         _seasonWeiTopSales[_season] = _seasonWeiTopSales[_season].add(__weiTopSales);   // season Top-Sales, in wei
894         _weiTopSales = _weiTopSales.add(__weiTopSales);                                 // sum Top-Sales, in wei
895 
896         // season referral account
897         if (_inWhitelist_) {
898             for (uint16 i = 0; i < _rewards_.length; i++) {
899                 _usdSeasonAccountRef[_season][_referrers_[i]] = _usdSeasonAccountRef[_season][_referrers_[i]].add(usdAmount);
900             }
901         }
902     }
903 
904     /**
905      * @dev Transfer WESION issued.
906      */
907     function transferWESIONIssued(uint256 amount, uint256 usdAmount) private returns (bool) {
908         _WESIONTxs = _WESIONTxs.add(1);
909 
910         _WESIONIssued = _WESIONIssued.add(amount);
911         _stageWESIONIssued[_stage] = _stageWESIONIssued[_stage].add(amount);
912         _accountWESIONIssued[msg.sender] = _accountWESIONIssued[msg.sender].add(amount);
913 
914         assert(WESION.transfer(msg.sender, amount));
915         emit WESIONIssuedTransfered(_stage, msg.sender, amount, _etherPrice, usdAmount);
916         return true;
917     }
918 
919     /**
920      * @dev Transfer WESION bonus.
921      */
922     function transferWESIONBonus(uint256 amount) private returns (bool) {
923         _WESIONBonusTxs = _WESIONBonusTxs.add(1);
924 
925         _WESIONBonus = _WESIONBonus.add(amount);
926         _accountWESIONBonus[msg.sender] = _accountWESIONBonus[msg.sender].add(amount);
927 
928         assert(WESION.transfer(msg.sender, amount));
929         emit WESIONBonusTransfered(msg.sender, amount);
930         return true;
931     }
932 
933     /**
934      * @dev Transfer WESION whitelisted.
935      */
936     function transferWESIONWhitelisted(uint256 amount) private returns (bool) {
937         _WESIONWhitelistTxs = _WESIONWhitelistTxs.add(1);
938 
939         _WESIONWhitelist = _WESIONWhitelist.add(amount);
940         _accountWESIONWhitelisted[msg.sender] = _accountWESIONWhitelisted[msg.sender].add(amount);
941 
942         assert(WESION.transfer(msg.sender, amount));
943         emit WESIONWhitelistTransfered(msg.sender, amount);
944         return true;
945     }
946 
947     /**
948      * Close current stage.
949      */
950     function closeStage() private returns (bool) {
951         emit StageClosed(_stage, msg.sender);
952         _stage = _stage.add(1);
953         _WESIONUsdPrice = stageWESIONUsdPrice(_stage);
954         _topSalesRatio = topSalesRatio(_stage);
955 
956         // Close current season
957         uint16 __seasonNumber = calcSeason(_stage);
958         if (_season < __seasonNumber) {
959             emit SeasonClosed(_season, msg.sender);
960             _season = __seasonNumber;
961         }
962 
963         return true;
964     }
965 
966     /**
967      * @dev Send whitelist referral rewards.
968      */
969     function sendWhitelistReferralRewards(uint256 weiAmount) private {
970         uint256 __weiRemain = weiAmount;
971         for (uint16 i = 0; i < _rewards_.length; i++) {
972             uint256 __weiReward = weiAmount.mul(_rewards_[i]).div(100);
973             address payable __receiver = address(uint160(_referrers_[i]));
974 
975             _weiRefRewarded = _weiRefRewarded.add(__weiReward);
976             _accountWeiRefRewarded[__receiver] = _accountWeiRefRewarded[__receiver].add(__weiReward);
977             __weiRemain = __weiRemain.sub(__weiReward);
978 
979             __receiver.transfer(__weiReward);
980         }
981 
982         if (_pending_ > 0)
983             _weiPending = _weiPending.add(weiAmount.mul(_pending_).div(100));
984     }
985 }