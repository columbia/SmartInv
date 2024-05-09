1 pragma solidity ^0.5.7;
2 
3 // TG Public Sale
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
256  * @title TG interface
257  */
258 interface ITG {
259     function balanceOf(address owner) external view returns (uint256);
260     function transfer(address to, uint256 value) external returns (bool);
261     function inWhitelist(address account) external view returns (bool);
262     function referrer(address account) external view returns (address);
263     function refCount(address account) external view returns (uint256);
264 }
265 
266 
267 /**
268  * @title TG Public Sale
269  */
270 contract TGPublicSale is Ownable, Pausable{
271     using SafeMath16 for uint16;
272     using SafeMath256 for uint256;
273 
274     // TG
275     address TG_Addr = address(0);
276     ITG public TG = ITG(TG_Addr);
277 
278     // Start timestamp
279     uint32 _startTimestamp;
280 
281     // Audit ether price
282     uint256 private _etherPrice;    // 1 Ether = xx.xxxxxx USD, with 6 decimals
283 
284     // Referral rewards, 35% for 15 levels
285     uint16 private WHITELIST_REF_REWARDS_PCT_SUM = 35;
286     uint16[15] private WHITELIST_REF_REWARDS_PCT = [
287         6,  // 6% for Level.1
288         6,  // 6% for Level.2
289         5,  // 5% for Level.3
290         4,  // 4% for Level.4
291         3,  // 3% for Level.5
292         2,  // 2% for Level.6
293         1,  // 1% for Level.7
294         1,  // 1% for Level.8
295         1,  // 1% for Level.9
296         1,  // 1% for Level.10
297         1,  // 1% for Level.11
298         1,  // 1% for Level.12
299         1,  // 1% for Level.13
300         1,  // 1% for Level.14
301         1   // 1% for Level.15
302     ];
303 
304     // Wei & Gas
305     uint72 private WEI_MIN = 0.1 ether;     // 0.1 Ether Minimum
306     uint72 private WEI_MAX = 100 ether;     // 100 Ether Maximum
307     uint72 private WEI_BONUS = 10 ether;    // >10 Ether for Bonus
308     uint24 private GAS_MIN = 3000000;       // 3.0 Mwei gas Mininum
309     uint24 private GAS_EX = 1500000;        // 1.5 Mwei gas for ex
310 
311     // Price
312     uint256 private TG_USD_PRICE_START = 1000;       // $      0.00100 USD
313     uint256 private TG_USD_PRICE_STEP = 10;          // $    + 0.00001 USD
314     uint256 private STAGE_USD_CAP_START = 100000000;    // $    100 USD
315     uint256 private STAGE_USD_CAP_STEP = 1000000;       // $     +1 USD
316     uint256 private STAGE_USD_CAP_MAX = 15100000000;    // $ 15,100 USD
317 
318     uint256 private _TGUsdPrice = TG_USD_PRICE_START;
319 
320     // Progress
321     uint16 private STAGE_MAX = 60000;   // 60,000 stages total
322     uint16 private SEASON_MAX = 100;    // 100 seasons total
323     uint16 private SEASON_STAGES = 600; // each 600 stages is a season
324 
325     uint16 private _stage;
326     uint16 private _season;
327 
328     // Sum
329     uint256 private _txs;
330     uint256 private _TGTxs;
331     uint256 private _TGBonusTxs;
332     uint256 private _TGWhitelistTxs;
333     uint256 private _TGIssued;
334     uint256 private _TGBonus;
335     uint256 private _TGWhitelist;
336     uint256 private _weiSold;
337     uint256 private _weiRefRewarded;
338     uint256 private _weiTopSales;
339     uint256 private _weiTeam;
340     uint256 private _weiPending;
341     uint256 private _weiPendingTransfered;
342 
343     // Top-Sales
344     uint256 private TOP_SALES_RATIO_START = 15000000;         // 15%, with 8 decimals
345     uint256 private TOP_SALES_RATIO_DISTANCE = 50000000;      // 50%, with 8 decimals
346 
347     uint256 private _topSalesRatio = TOP_SALES_RATIO_START;   // 15% + 50% x(_stage/_stageMax)
348 
349     // During tx
350     bool private _inWhitelist_;
351     uint256 private _pending_ = WHITELIST_REF_REWARDS_PCT_SUM;
352     uint16[] private _rewards_;
353     address[] private _referrers_;
354 
355     // Audit ether price auditor
356     mapping (address => bool) private _etherPriceAuditors;
357 
358     // Stage
359     mapping (uint16 => uint256) private _stageUsdSold;
360     mapping (uint16 => uint256) private _stageTGIssued;
361 
362     // Season
363     mapping (uint16 => uint256) private _seasonWeiSold;
364     mapping (uint16 => uint256) private _seasonWeiTopSales;
365     mapping (uint16 => uint256) private _seasonWeiTopSalesTransfered;
366 
367     // Account
368     mapping (address => uint256) private _accountTGIssued;
369     mapping (address => uint256) private _accountTGBonus;
370     mapping (address => uint256) private _accountTGWhitelisted;
371     mapping (address => uint256) private _accountWeiPurchased;
372     mapping (address => uint256) private _accountWeiRefRewarded;
373 
374     // Ref
375     mapping (uint16 => address[]) private _seasonRefAccounts;
376     mapping (uint16 => mapping (address => bool)) private _seasonHasRefAccount;
377     mapping (uint16 => mapping (address => uint256)) private _usdSeasonAccountPurchased;
378     mapping (uint16 => mapping (address => uint256)) private _usdSeasonAccountRef;
379 
380     // Events
381     event AuditEtherPriceChanged(uint256 value, address indexed account);
382     event AuditEtherPriceAuditorChanged(address indexed account, bool state);
383 
384     event TGBonusTransfered(address indexed to, uint256 amount);
385     event TGWhitelistTransfered(address indexed to, uint256 amount);
386     event TGIssuedTransfered(uint16 stageIndex, address indexed to, uint256 TGAmount, uint256 auditEtherPrice, uint256 weiUsed);
387 
388     event StageClosed(uint256 _stageNumber, address indexed account);
389     event SeasonClosed(uint16 _seasonNumber, address indexed account);
390 
391     event SeasonTopSalesWeiTransfered(uint16 seasonNumber, address indexed to, uint256 amount);
392     event TeamWeiTransfered(address indexed to, uint256 amount);
393     event PendingWeiTransfered(address indexed to, uint256 amount);
394 
395 
396     /**
397      * @dev Start timestamp.
398      */
399     function startTimestamp() public view returns (uint32) {
400         return _startTimestamp;
401     }
402 
403     /**
404      * @dev Set start timestamp.
405      */
406     function setStartTimestamp(uint32 timestamp) external onlyOwner {
407         _startTimestamp = timestamp;
408     }
409 
410     /**
411      * @dev Throws if not ether price auditor.
412      */
413     modifier onlyEtherPriceAuditor() {
414         require(_etherPriceAuditors[msg.sender]);
415         _;
416     }
417 
418     /**
419      * @dev Set audit ether price.
420      */
421     function setEtherPrice(uint256 value) external onlyEtherPriceAuditor {
422         _etherPrice = value;
423         emit AuditEtherPriceChanged(value, msg.sender);
424     }
425 
426     /**
427      * @dev Get ether price auditor state.
428      */
429     function etherPriceAuditor(address account) public view returns (bool) {
430         return _etherPriceAuditors[account];
431     }
432 
433     /**
434      * @dev Get ether price auditor state.
435      */
436     function setEtherPriceAuditor(address account, bool state) external onlyOwner {
437         _etherPriceAuditors[account] = state;
438         emit AuditEtherPriceAuditorChanged(account, state);
439     }
440 
441     /**
442      * @dev Stage TG price in USD, by stage index.
443      */
444     function stageTGUsdPrice(uint16 stageIndex) private view returns (uint256) {
445         return TG_USD_PRICE_START.add(TG_USD_PRICE_STEP.mul(stageIndex));
446     }
447 
448     /**
449      * @dev wei => USD
450      */
451     function wei2usd(uint256 amount) private view returns (uint256) {
452         return amount.mul(_etherPrice).div(1 ether);
453     }
454 
455     /**
456      * @dev USD => wei
457      */
458     function usd2wei(uint256 amount) private view returns (uint256) {
459         return amount.mul(1 ether).div(_etherPrice);
460     }
461 
462     /**
463      * @dev USD => TG
464      */
465     function usd2TG(uint256 usdAmount) private view returns (uint256) {
466         return usdAmount.mul(1000000).div(_TGUsdPrice);
467     }
468 
469     /**
470      * @dev USD => TG
471      */
472     function usd2TGByStage(uint256 usdAmount, uint16 stageIndex) public view returns (uint256) {
473         return usdAmount.mul(1000000).div(stageTGUsdPrice(stageIndex));
474     }
475 
476     /**
477      * @dev Calculate season number, by stage index.
478      */
479     function calcSeason(uint16 stageIndex) private view returns (uint16) {
480         if (stageIndex > 0) {
481             uint16 __seasonNumber = stageIndex.div(SEASON_STAGES);
482 
483             if (stageIndex.mod(SEASON_STAGES) > 0) {
484                 return __seasonNumber.add(1);
485             }
486 
487             return __seasonNumber;
488         }
489 
490         return 1;
491     }
492 
493     /**
494      * @dev Transfer Top-Sales wei, by season number.
495      */
496     function transferTopSales(uint16 seasonNumber, address payable to) external onlyOwner {
497         uint256 __weiRemain = seasonTopSalesRemain(seasonNumber);
498         require(to != address(0));
499 
500         _seasonWeiTopSalesTransfered[seasonNumber] = _seasonWeiTopSalesTransfered[seasonNumber].add(__weiRemain);
501         emit SeasonTopSalesWeiTransfered(seasonNumber, to, __weiRemain);
502         to.transfer(__weiRemain);
503     }
504 
505     /**
506      * @dev Pending remain, in wei.
507      */
508     function pendingRemain() private view returns (uint256) {
509         return _weiPending.sub(_weiPendingTransfered);
510     }
511 
512     /**
513      * @dev Transfer pending wei.
514      */
515     function transferPending(address payable to) external onlyOwner {
516         uint256 __weiRemain = pendingRemain();
517         require(to != address(0));
518 
519         _weiPendingTransfered = _weiPendingTransfered.add(__weiRemain);
520         emit PendingWeiTransfered(to, __weiRemain);
521         to.transfer(__weiRemain);
522     }
523 
524     /**
525      * @dev Transfer team wei.
526      */
527     function transferTeam(address payable to) external onlyOwner {
528         uint256 __weiRemain = _weiSold.sub(_weiRefRewarded).sub(_weiTopSales).sub(_weiPending).sub(_weiTeam);
529         require(to != address(0));
530 
531         _weiTeam = _weiTeam.add(__weiRemain);
532         emit TeamWeiTransfered(to, __weiRemain);
533         to.transfer(__weiRemain);
534     }
535 
536     /**
537      * @dev Status.
538      */
539     function status() public view returns (uint256 auditEtherPrice,
540                                            uint16 stage,
541                                            uint16 season,
542                                            uint256 TGUsdPrice,
543                                            uint256 currentTopSalesRatio,
544                                            uint256 txs,
545                                            uint256 TGTxs,
546                                            uint256 TGBonusTxs,
547                                            uint256 TGWhitelistTxs,
548                                            uint256 TGIssued,
549                                            uint256 TGBonus,
550                                            uint256 TGWhitelist) {
551         auditEtherPrice = _etherPrice;
552 
553         if (_stage > STAGE_MAX) {
554             stage = STAGE_MAX;
555             season = SEASON_MAX;
556         } else {
557             stage = _stage;
558             season = _season;
559         }
560 
561         TGUsdPrice = _TGUsdPrice;
562         currentTopSalesRatio = _topSalesRatio;
563 
564         txs = _txs;
565         TGTxs = _TGTxs;
566         TGBonusTxs = _TGBonusTxs;
567         TGWhitelistTxs = _TGWhitelistTxs;
568         TGIssued = _TGIssued;
569         TGBonus = _TGBonus;
570         TGWhitelist = _TGWhitelist;
571     }
572 
573     /**
574      * @dev Sum.
575      */
576     function sum() public view returns(uint256 weiSold,
577                                        uint256 weiReferralRewarded,
578                                        uint256 weiTopSales,
579                                        uint256 weiTeam,
580                                        uint256 weiPending,
581                                        uint256 weiPendingTransfered,
582                                        uint256 weiPendingRemain) {
583         weiSold = _weiSold;
584         weiReferralRewarded = _weiRefRewarded;
585         weiTopSales = _weiTopSales;
586         weiTeam = _weiTeam;
587         weiPending = _weiPending;
588         weiPendingTransfered = _weiPendingTransfered;
589         weiPendingRemain = pendingRemain();
590     }
591 
592     /**
593      * @dev Throws if gas is not enough.
594      */
595     modifier enoughGas() {
596         require(gasleft() > GAS_MIN);
597         _;
598     }
599 
600     /**
601      * @dev Throws if not started.
602      */
603     modifier onlyOnSale() {
604         require(_startTimestamp > 0 && now > _startTimestamp, "TG Public-Sale has not started yet.");
605         require(_etherPrice > 0, "Audit ETH price must be greater than zero.");
606         require(!paused(), "TG Public-Sale is paused.");
607         require(_stage <= STAGE_MAX, "TG Public-Sale Closed.");
608         _;
609     }
610 
611     /**
612      * @dev Top-Sales ratio.
613      */
614     function topSalesRatio(uint16 stageIndex) private view returns (uint256) {
615         return TOP_SALES_RATIO_START.add(TOP_SALES_RATIO_DISTANCE.mul(stageIndex).div(STAGE_MAX));
616     }
617 
618     /**
619      * @dev USD => wei, for Top-Sales
620      */
621     function usd2weiTopSales(uint256 usdAmount) private view returns (uint256) {
622         return usd2wei(usdAmount.mul(_topSalesRatio).div(100000000));
623     }
624 
625     /**
626      * @dev Calculate stage dollor cap, by stage index.
627      */
628     function stageUsdCap(uint16 stageIndex) private view returns (uint256) {
629         uint256 __usdCap = STAGE_USD_CAP_START.add(STAGE_USD_CAP_STEP.mul(stageIndex));
630 
631         if (__usdCap > STAGE_USD_CAP_MAX) {
632             return STAGE_USD_CAP_MAX;
633         }
634 
635         return __usdCap;
636     }
637 
638     /**
639      * @dev Stage Vokdn cap, by stage index.
640      */
641     function stageTGCap(uint16 stageIndex) private view returns (uint256) {
642         return usd2TGByStage(stageUsdCap(stageIndex), stageIndex);
643     }
644 
645     /**
646      * @dev Stage status, by stage index.
647      */
648     function stageStatus(uint16 stageIndex) public view returns (uint256 TGUsdPrice,
649                                                                  uint256 TGCap,
650                                                                  uint256 TGOnSale,
651                                                                  uint256 TGSold,
652                                                                  uint256 usdCap,
653                                                                  uint256 usdOnSale,
654                                                                  uint256 usdSold,
655                                                                  uint256 weiTopSalesRatio) {
656         if (stageIndex > STAGE_MAX) {
657             return (0, 0, 0, 0, 0, 0, 0, 0);
658         }
659 
660         TGUsdPrice = stageTGUsdPrice(stageIndex);
661 
662         TGSold = _stageTGIssued[stageIndex];
663         TGCap = stageTGCap(stageIndex);
664         TGOnSale = TGCap.sub(TGSold);
665 
666         usdSold = _stageUsdSold[stageIndex];
667         usdCap = stageUsdCap(stageIndex);
668         usdOnSale = usdCap.sub(usdSold);
669 
670         weiTopSalesRatio = topSalesRatio(stageIndex);
671     }
672 
673     /**
674      * @dev Season Top-Sales remain, in wei.
675      */
676     function seasonTopSalesRemain(uint16 seasonNumber) private view returns (uint256) {
677         return _seasonWeiTopSales[seasonNumber].sub(_seasonWeiTopSalesTransfered[seasonNumber]);
678     }
679 
680     /**
681      * @dev Season Top-Sales rewards, by season number, in wei.
682      */
683     function seasonTopSalesRewards(uint16 seasonNumber) public view returns (uint256 weiSold,
684                                                                              uint256 weiTopSales,
685                                                                              uint256 weiTopSalesTransfered,
686                                                                              uint256 weiTopSalesRemain) {
687         weiSold = _seasonWeiSold[seasonNumber];
688         weiTopSales = _seasonWeiTopSales[seasonNumber];
689         weiTopSalesTransfered = _seasonWeiTopSalesTransfered[seasonNumber];
690         weiTopSalesRemain = seasonTopSalesRemain(seasonNumber);
691     }
692 
693     /**
694      * @dev Query account.
695      */
696     function accountQuery(address account) public view returns (uint256 TGIssued,
697                                                                 uint256 TGBonus,
698                                                                 uint256 TGWhitelisted,
699                                                                 uint256 weiPurchased,
700                                                                 uint256 weiReferralRewarded) {
701         TGIssued = _accountTGIssued[account];
702         TGBonus = _accountTGBonus[account];
703         TGWhitelisted = _accountTGWhitelisted[account];
704         weiPurchased = _accountWeiPurchased[account];
705         weiReferralRewarded = _accountWeiRefRewarded[account];
706     }
707 
708     /**
709      * @dev Accounts in a specific season.
710      */
711     function seasonRefAccounts(uint16 seasonNumber) public view returns (address[] memory accounts) {
712         accounts = _seasonRefAccounts[seasonNumber];
713     }
714 
715     /**
716      * @dev Season number => account => USD purchased.
717      */
718     function usdSeasonAccountPurchased(uint16 seasonNumber, address account) public view returns (uint256) {
719         return _usdSeasonAccountPurchased[seasonNumber][account];
720     }
721 
722     /**
723      * @dev Season number => account => referral dollors.
724      */
725     function usdSeasonAccountRef(uint16 seasonNumber, address account) public view returns (uint256) {
726         return _usdSeasonAccountRef[seasonNumber][account];
727     }
728 
729     /**
730      * @dev constructor
731      */
732     constructor () public {
733         _etherPriceAuditors[msg.sender] = true;
734         _stage = 0;
735         _season = 1;
736     }
737 
738     /**
739      * @dev Receive ETH, and send TGs.
740      */
741     function () external payable enoughGas onlyOnSale {
742         require(msg.value >= WEI_MIN);
743         require(msg.value <= WEI_MAX);
744 
745         // Set temporary variables.
746         setTemporaryVariables();
747         uint256 __usdAmount = wei2usd(msg.value);
748         uint256 __usdRemain = __usdAmount;
749         uint256 __TGIssued;
750         uint256 __TGBonus;
751         uint256 __usdUsed;
752         uint256 __weiUsed;
753 
754         // USD => TG
755         while (gasleft() > GAS_EX && __usdRemain > 0 && _stage <= STAGE_MAX) {
756             uint256 __txTGIssued;
757             (__txTGIssued, __usdRemain) = ex(__usdRemain);
758             __TGIssued = __TGIssued.add(__txTGIssued);
759         }
760 
761         // Used
762         __usdUsed = __usdAmount.sub(__usdRemain);
763         __weiUsed = usd2wei(__usdUsed);
764 
765         // Bonus 10%
766         if (msg.value >= WEI_BONUS) {
767             __TGBonus = __TGIssued.div(10);
768             assert(transferTGBonus(__TGBonus));
769         }
770 
771         // Whitelisted
772         // BUY-ONE-AND-GET-ONE-MORE-FREE
773         if (_inWhitelist_ && __TGIssued > 0) {
774             // both issued and bonus
775             assert(transferTGWhitelisted(__TGIssued.add(__TGBonus)));
776 
777             // 35% for 15 levels
778             sendWhitelistReferralRewards(__weiUsed);
779         }
780 
781         // If wei remains, refund.
782         if (__usdRemain > 0) {
783             uint256 __weiRemain = usd2wei(__usdRemain);
784 
785             __weiUsed = msg.value.sub(__weiRemain);
786 
787             // Refund wei back
788             msg.sender.transfer(__weiRemain);
789         }
790 
791         // Counter
792         if (__weiUsed > 0) {
793             _txs = _txs.add(1);
794             _weiSold = _weiSold.add(__weiUsed);
795             _accountWeiPurchased[msg.sender] = _accountWeiPurchased[msg.sender].add(__weiUsed);
796         }
797 
798         // Wei team
799         uint256 __weiTeam;
800         if (_season > SEASON_MAX)
801             __weiTeam = _weiSold.sub(_weiRefRewarded).sub(_weiTopSales).sub(_weiPending).sub(_weiTeam);
802         else
803             __weiTeam = _weiSold.sub(_weiRefRewarded).sub(_weiTopSales).sub(_weiPending).sub(_weiTeam).div(0.01 ether).mul(0.01 ether);
804 
805         _weiTeam = _weiTeam.add(__weiTeam);
806         _receiver.transfer(__weiTeam);
807 
808         // Assert finished
809         assert(true);
810     }
811 
812     /**
813      * @dev Set temporary variables.
814      */
815     function setTemporaryVariables() private {
816         delete _referrers_;
817         delete _rewards_;
818 
819         _inWhitelist_ = TG.inWhitelist(msg.sender);
820         _pending_ = WHITELIST_REF_REWARDS_PCT_SUM;
821 
822         address __cursor = msg.sender;
823         for(uint16 i = 0; i < WHITELIST_REF_REWARDS_PCT.length; i++) {
824             address __refAccount = TG.referrer(__cursor);
825 
826             if (__cursor == __refAccount)
827                 break;
828 
829             if (TG.refCount(__refAccount) > i) {
830                 if (!_seasonHasRefAccount[_season][__refAccount]) {
831                     _seasonRefAccounts[_season].push(__refAccount);
832                     _seasonHasRefAccount[_season][__refAccount] = true;
833                 }
834 
835                 _pending_ = _pending_.sub(WHITELIST_REF_REWARDS_PCT[i]);
836                 _rewards_.push(WHITELIST_REF_REWARDS_PCT[i]);
837                 _referrers_.push(__refAccount);
838             }
839 
840             __cursor = __refAccount;
841         }
842     }
843 
844     /**
845      * @dev USD => TG
846      */
847     function ex(uint256 usdAmount) private returns (uint256, uint256) {
848         uint256 __stageUsdCap = stageUsdCap(_stage);
849         uint256 __TGIssued;
850 
851         if (_stageUsdSold[_stage].add(usdAmount) > __stageUsdCap) {
852             // calc used usd
853             uint256 __usdUsed = __stageUsdCap.sub(_stageUsdSold[_stage]);
854 
855             // calc usd remain
856             uint256 __usdRemain = usdAmount.sub(__usdUsed);
857 
858             // count status
859             exCount(__usdUsed);
860 
861             // calc token issued
862             __TGIssued = usd2TG(__usdUsed);
863 
864             // commit
865             assert(transferTGIssued(__TGIssued, __usdUsed));
866             assert(closeStage());
867 
868             return (__TGIssued, __usdRemain);
869         } else {
870             // count status
871             exCount(usdAmount);
872 
873             // calc token issued
874             __TGIssued = usd2TG(usdAmount);
875 
876             // commit
877             assert(transferTGIssued(__TGIssued, usdAmount));
878 
879             // close stage, if stage dollor cap reached
880             if (__stageUsdCap == _stageUsdSold[_stage]) {
881                 assert(closeStage());
882             }
883 
884             return (__TGIssued, 0);
885         }
886     }
887 
888     /**
889      * @dev Ex counter.
890      */
891     function exCount(uint256 usdAmount) private {
892         uint256 __weiSold = usd2wei(usdAmount);
893         uint256 __weiTopSales = usd2weiTopSales(usdAmount);
894 
895         _usdSeasonAccountPurchased[_season][msg.sender] = _usdSeasonAccountPurchased[_season][msg.sender].add(usdAmount);   // season => address => purchased, in USD
896 
897         _stageUsdSold[_stage] = _stageUsdSold[_stage].add(usdAmount);                   // stage sold, in USD
898         _seasonWeiSold[_season] = _seasonWeiSold[_season].add(__weiSold);               // season sold, in wei
899         _seasonWeiTopSales[_season] = _seasonWeiTopSales[_season].add(__weiTopSales);   // season Top-Sales, in wei
900         _weiTopSales = _weiTopSales.add(__weiTopSales);                                 // sum Top-Sales, in wei
901 
902         // season referral account
903         if (_inWhitelist_) {
904             for (uint16 i = 0; i < _rewards_.length; i++) {
905                 _usdSeasonAccountRef[_season][_referrers_[i]] = _usdSeasonAccountRef[_season][_referrers_[i]].add(usdAmount);
906             }
907         }
908     }
909 
910     /**
911      * @dev Transfer TG issued.
912      */
913     function transferTGIssued(uint256 amount, uint256 usdAmount) private returns (bool) {
914         _TGTxs = _TGTxs.add(1);
915 
916         _TGIssued = _TGIssued.add(amount);
917         _stageTGIssued[_stage] = _stageTGIssued[_stage].add(amount);
918         _accountTGIssued[msg.sender] = _accountTGIssued[msg.sender].add(amount);
919 
920         assert(TG.transfer(msg.sender, amount));
921         emit TGIssuedTransfered(_stage, msg.sender, amount, _etherPrice, usdAmount);
922         return true;
923     }
924 
925     /**
926      * @dev Transfer TG bonus.
927      */
928     function transferTGBonus(uint256 amount) private returns (bool) {
929         _TGBonusTxs = _TGBonusTxs.add(1);
930 
931         _TGBonus = _TGBonus.add(amount);
932         _accountTGBonus[msg.sender] = _accountTGBonus[msg.sender].add(amount);
933 
934         assert(TG.transfer(msg.sender, amount));
935         emit TGBonusTransfered(msg.sender, amount);
936         return true;
937     }
938 
939     /**
940      * @dev Transfer TG whitelisted.
941      */
942     function transferTGWhitelisted(uint256 amount) private returns (bool) {
943         _TGWhitelistTxs = _TGWhitelistTxs.add(1);
944 
945         _TGWhitelist = _TGWhitelist.add(amount);
946         _accountTGWhitelisted[msg.sender] = _accountTGWhitelisted[msg.sender].add(amount);
947 
948         assert(TG.transfer(msg.sender, amount));
949         emit TGWhitelistTransfered(msg.sender, amount);
950         return true;
951     }
952 
953     /**
954      * Close current stage.
955      */
956     function closeStage() private returns (bool) {
957         emit StageClosed(_stage, msg.sender);
958         _stage = _stage.add(1);
959         _TGUsdPrice = stageTGUsdPrice(_stage);
960         _topSalesRatio = topSalesRatio(_stage);
961 
962         // Close current season
963         uint16 __seasonNumber = calcSeason(_stage);
964         if (_season < __seasonNumber) {
965             emit SeasonClosed(_season, msg.sender);
966             _season = __seasonNumber;
967         }
968 
969         return true;
970     }
971 
972     /**
973      * @dev Send whitelist referral rewards.
974      */
975     function sendWhitelistReferralRewards(uint256 weiAmount) private {
976         uint256 __weiRemain = weiAmount;
977         for (uint16 i = 0; i < _rewards_.length; i++) {
978             uint256 __weiReward = weiAmount.mul(_rewards_[i]).div(100);
979             address payable __receiver = address(uint160(_referrers_[i]));
980 
981             _weiRefRewarded = _weiRefRewarded.add(__weiReward);
982             _accountWeiRefRewarded[__receiver] = _accountWeiRefRewarded[__receiver].add(__weiReward);
983             __weiRemain = __weiRemain.sub(__weiReward);
984 
985             __receiver.transfer(__weiReward);
986         }
987 
988         if (_pending_ > 0)
989             _weiPending = _weiPending.add(weiAmount.mul(_pending_).div(100));
990     }
991 
992     /**
993      * @dev set TG Address
994      */
995     function setTGAddress(address _TgAddr) public onlyOwner {
996         TG_Addr = _TgAddr;
997         TG = ITG(_TgAddr);
998     }
999 }