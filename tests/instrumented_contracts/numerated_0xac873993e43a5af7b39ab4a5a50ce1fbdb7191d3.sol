1 pragma solidity ^0.5.7;
2 
3 // Voken Public Sale
4 // 
5 // More info:
6 //   https://vision.network
7 //   https://voken.io
8 //
9 // Contact us:
10 //   support@vision.network
11 //   support@voken.io
12 
13 
14 /**
15  * @title SafeMath for uint256
16  * @dev Unsigned math operations with safety checks that revert on error.
17  */
18 library SafeMath256 {
19     /**
20      * @dev Adds two unsigned integers, reverts on overflow.
21      */
22     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
23         c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 
28     /**
29      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
30      */
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         assert(b <= a);
33         return a - b;
34     }
35 
36     /**
37      * @dev Multiplies two unsigned integers, reverts on overflow.
38      */
39     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
40         if (a == 0) {
41             return 0;
42         }
43         c = a * b;
44         assert(c / a == b);
45         return c;
46     }
47 
48     /**
49      * @dev Integer division of two unsigned integers truncating the quotient,
50      * reverts on division by zero.
51      */
52     function div(uint256 a, uint256 b) internal pure returns (uint256) {
53         assert(b > 0);
54         uint256 c = a / b;
55         assert(a == b * c + a % b);
56         return a / b;
57     }
58 
59     /**
60      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61      * reverts when dividing by zero.
62      */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 /**
70  * @title SafeMath for uint16
71  * @dev Unsigned math operations with safety checks that revert on error.
72  */
73 library SafeMath16 {
74     /**
75      * @dev Adds two unsigned integers, reverts on overflow.
76      */
77     function add(uint16 a, uint16 b) internal pure returns (uint16 c) {
78         c = a + b;
79         assert(c >= a);
80         return c;
81     }
82 
83     /**
84      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
85      */
86     function sub(uint16 a, uint16 b) internal pure returns (uint16) {
87         assert(b <= a);
88         return a - b;
89     }
90 
91     /**
92      * @dev Multiplies two unsigned integers, reverts on overflow.
93      */
94     function mul(uint16 a, uint16 b) internal pure returns (uint16 c) {
95         if (a == 0) {
96             return 0;
97         }
98         c = a * b;
99         assert(c / a == b);
100         return c;
101     }
102 
103     /**
104      * @dev Integer division of two unsigned integers truncating the quotient,
105      * reverts on division by zero.
106      */
107     function div(uint16 a, uint16 b) internal pure returns (uint16) {
108         assert(b > 0);
109         uint256 c = a / b;
110         assert(a == b * c + a % b);
111         return a / b;
112     }
113 
114     /**
115      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
116      * reverts when dividing by zero.
117      */
118     function mod(uint16 a, uint16 b) internal pure returns (uint16) {
119         require(b != 0);
120         return a % b;
121     }
122 }
123 
124 
125 /**
126  * @title Ownable
127  */
128 contract Ownable {
129     address private _owner;
130     address payable internal _receiver;
131 
132     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
133     event ReceiverChanged(address indexed previousReceiver, address indexed newReceiver);
134 
135     /**
136      * @dev The Ownable constructor sets the original `owner` of the contract
137      * to the sender account.
138      */
139     constructor () internal {
140         _owner = msg.sender;
141         _receiver = msg.sender;
142     }
143 
144     /**
145      * @return The address of the owner.
146      */
147     function owner() public view returns (address) {
148         return _owner;
149     }
150 
151     /**
152      * @dev Throws if called by any account other than the owner.
153      */
154     modifier onlyOwner() {
155         require(msg.sender == _owner);
156         _;
157     }
158 
159     /**
160      * @dev Allows the current owner to transfer control of the contract to a newOwner.
161      * @param newOwner The address to transfer ownership to.
162      */
163     function transferOwnership(address newOwner) external onlyOwner {
164         require(newOwner != address(0));
165         address __previousOwner = _owner;
166         _owner = newOwner;
167         emit OwnershipTransferred(__previousOwner, newOwner);
168     }
169 
170     /**
171      * @dev Change receiver.
172      */
173     function changeReceiver(address payable newReceiver) external onlyOwner {
174         require(newReceiver != address(0));
175         address __previousReceiver = _receiver;
176         _receiver = newReceiver;
177         emit ReceiverChanged(__previousReceiver, newReceiver);
178     }
179 
180     /**
181      * @dev Rescue compatible ERC20 Token
182      *
183      * @param tokenAddr ERC20 The address of the ERC20 token contract
184      * @param receiver The address of the receiver
185      * @param amount uint256
186      */
187     function rescueTokens(address tokenAddr, address receiver, uint256 amount) external onlyOwner {
188         IERC20 _token = IERC20(tokenAddr);
189         require(receiver != address(0));
190         uint256 balance = _token.balanceOf(address(this));
191         require(balance >= amount);
192 
193         assert(_token.transfer(receiver, amount));
194     }
195 
196     /**
197      * @dev Withdraw ether
198      */
199     function withdrawEther(address payable to, uint256 amount) external onlyOwner {
200         require(to != address(0));
201         uint256 balance = address(this).balance;
202         require(balance >= amount);
203 
204         to.transfer(amount);
205     }
206 }
207 
208 
209 /**
210  * @title Pausable
211  * @dev Base contract which allows children to implement an emergency stop mechanism.
212  */
213 contract Pausable is Ownable {
214     bool private _paused;
215 
216     event Paused(address account);
217     event Unpaused(address account);
218 
219     constructor () internal {
220         _paused = false;
221     }
222 
223     /**
224      * @return Returns true if the contract is paused, false otherwise.
225      */
226     function paused() public view returns (bool) {
227         return _paused;
228     }
229 
230     /**
231      * @dev Modifier to make a function callable only when the contract is not paused.
232      */
233     modifier whenNotPaused() {
234         require(!_paused, "Paused.");
235         _;
236     }
237 
238     /**
239      * @dev Called by a pauser to pause, triggers stopped state.
240      */
241     function setPaused(bool state) external onlyOwner {
242         if (_paused && !state) {
243             _paused = false;
244             emit Unpaused(msg.sender);
245         } else if (!_paused && state) {
246             _paused = true;
247             emit Paused(msg.sender);
248         }
249     }
250 }
251 
252 
253 /**
254  * @title ERC20 interface
255  * @dev see https://eips.ethereum.org/EIPS/eip-20
256  */
257 interface IERC20 {
258     function balanceOf(address owner) external view returns (uint256);
259     function transfer(address to, uint256 value) external returns (bool);
260 }
261 
262 
263 /**
264  * @title Voken interface
265  */
266 interface IVoken {
267     function balanceOf(address owner) external view returns (uint256);
268     function transfer(address to, uint256 value) external returns (bool);
269     function inWhitelist(address account) external view returns (bool);
270     function referrer(address account) external view returns (address);
271     function refCount(address account) external view returns (uint256);
272 }
273 
274 
275 /**
276  * @title Voken Public Sale
277  */
278 contract VokenPublicSale is Ownable, Pausable{
279     using SafeMath16 for uint16;
280     using SafeMath256 for uint256;
281 
282     // Voken
283     IVoken public VOKEN = IVoken(0x82070415FEe803f94Ce5617Be1878503e58F0a6a);
284 
285     // Start timestamp
286     uint32 _startTimestamp;
287 
288     // Audit ether price
289     uint256 private _etherPrice;    // 1 Ether = xx.xxxxxx USD, with 6 decimals
290 
291     // Referral rewards, 35% for 15 levels
292     uint16 private WHITELIST_REF_REWARDS_PCT_SUM = 35;
293     uint16[15] private WHITELIST_REF_REWARDS_PCT = [
294         6,  // 6% for Level.1
295         6,  // 6% for Level.2
296         5,  // 5% for Level.3
297         4,  // 4% for Level.4
298         3,  // 3% for Level.5
299         2,  // 2% for Level.6
300         1,  // 1% for Level.7
301         1,  // 1% for Level.8
302         1,  // 1% for Level.9
303         1,  // 1% for Level.10
304         1,  // 1% for Level.11
305         1,  // 1% for Level.12
306         1,  // 1% for Level.13
307         1,  // 1% for Level.14
308         1   // 1% for Level.15
309     ];
310 
311     // Wei & Gas
312     uint72 private WEI_MIN = 0.1 ether;     // 0.1 Ether Minimum
313     uint72 private WEI_MAX = 100 ether;     // 100 Ether Maximum
314     uint72 private WEI_BONUS = 10 ether;    // >10 Ether for Bonus
315     uint24 private GAS_MIN = 3000000;       // 3.0 Mwei gas Mininum
316     uint24 private GAS_EX = 1500000;        // 1.5 Mwei gas for ex
317 
318     // Price
319     uint256 private VOKEN_USD_PRICE_START = 1000;       // $      0.00100 USD    
320     uint256 private VOKEN_USD_PRICE_STEP = 10;          // $    + 0.00001 USD
321     uint256 private STAGE_USD_CAP_START = 100000000;    // $    100 USD
322     uint256 private STAGE_USD_CAP_STEP = 1000000;       // $     +1 USD
323     uint256 private STAGE_USD_CAP_MAX = 15100000000;    // $ 15,100 USD
324 
325     uint256 private _vokenUsdPrice = VOKEN_USD_PRICE_START;
326 
327     // Progress
328     uint16 private STAGE_MAX = 60000;   // 60,000 stages total
329     uint16 private SEASON_MAX = 100;    // 100 seasons total
330     uint16 private SEASON_STAGES = 600; // each 600 stages is a season
331 
332     uint16 private _stage;
333     uint16 private _season;
334 
335     // Sum
336     uint256 private _txs;
337     uint256 private _vokenTxs;
338     uint256 private _vokenBonusTxs;
339     uint256 private _vokenWhitelistTxs;
340     uint256 private _vokenIssued;
341     uint256 private _vokenBonus;
342     uint256 private _vokenWhitelist;
343     uint256 private _weiSold;
344     uint256 private _weiRefRewarded;
345     uint256 private _weiTopSales;
346     uint256 private _weiTeam;
347     uint256 private _weiPending;
348     uint256 private _weiPendingTransfered;
349 
350     // Top-Sales
351     uint256 private TOP_SALES_RATIO_START = 15000000;         // 15%, with 8 decimals
352     uint256 private TOP_SALES_RATIO_DISTANCE = 50000000;      // 50%, with 8 decimals
353 
354     uint256 private _topSalesRatio = TOP_SALES_RATIO_START;   // 15% + 50% x(_stage/_stageMax)
355 
356     // During tx
357     bool private _inWhitelist_;
358     uint256 private _pending_ = WHITELIST_REF_REWARDS_PCT_SUM;
359     uint16[] private _rewards_;
360     address[] private _referrers_;
361 
362     // Audit ether price auditor
363     mapping (address => bool) private _etherPriceAuditors;
364 
365     // Stage
366     mapping (uint16 => uint256) private _stageUsdSold;
367     mapping (uint16 => uint256) private _stageVokenIssued;
368 
369     // Season
370     mapping (uint16 => uint256) private _seasonWeiSold;
371     mapping (uint16 => uint256) private _seasonWeiTopSales;
372     mapping (uint16 => uint256) private _seasonWeiTopSalesTransfered;
373 
374     // Account
375     mapping (address => uint256) private _accountVokenIssued;
376     mapping (address => uint256) private _accountVokenBonus;
377     mapping (address => uint256) private _accountVokenWhitelisted;
378     mapping (address => uint256) private _accountWeiPurchased;
379     mapping (address => uint256) private _accountWeiRefRewarded;
380 
381     // Ref
382     mapping (uint16 => address[]) private _seasonRefAccounts;
383     mapping (uint16 => mapping (address => bool)) private _seasonHasRefAccount;
384     mapping (uint16 => mapping (address => uint256)) private _usdSeasonAccountPurchased;
385     mapping (uint16 => mapping (address => uint256)) private _usdSeasonAccountRef;
386 
387     // Events
388     event AuditEtherPriceChanged(uint256 value, address indexed account);
389     event AuditEtherPriceAuditorChanged(address indexed account, bool state);
390 
391     event VokenBonusTransfered(address indexed to, uint256 amount);
392     event VokenWhitelistTransfered(address indexed to, uint256 amount);
393     event VokenIssuedTransfered(uint16 stageIndex, address indexed to, uint256 vokenAmount, uint256 auditEtherPrice, uint256 weiUsed);
394 
395     event StageClosed(uint256 _stageNumber, address indexed account);
396     event SeasonClosed(uint16 _seasonNumber, address indexed account);
397 
398     event SeasonTopSalesWeiTransfered(uint16 seasonNumber, address indexed to, uint256 amount);
399     event TeamWeiTransfered(address indexed to, uint256 amount);
400     event PendingWeiTransfered(address indexed to, uint256 amount);
401 
402 
403     /**
404      * @dev Start timestamp.
405      */
406     function startTimestamp() public view returns (uint32) {
407         return _startTimestamp;
408     }
409 
410     /**
411      * @dev Set start timestamp.
412      */
413     function setStartTimestamp(uint32 timestamp) external onlyOwner {
414         _startTimestamp = timestamp;
415     }
416 
417     /**
418      * @dev Throws if not ether price auditor.
419      */
420     modifier onlyEtherPriceAuditor() {
421         require(_etherPriceAuditors[msg.sender]);
422         _;
423     }
424 
425     /**
426      * @dev Set audit ether price.
427      */
428     function setEtherPrice(uint256 value) external onlyEtherPriceAuditor {
429         _etherPrice = value;
430         emit AuditEtherPriceChanged(value, msg.sender);
431     }
432 
433     /**
434      * @dev Get ether price auditor state.
435      */
436     function etherPriceAuditor(address account) public view returns (bool) {
437         return _etherPriceAuditors[account];
438     }
439 
440     /**
441      * @dev Get ether price auditor state.
442      */
443     function setEtherPriceAuditor(address account, bool state) external onlyOwner {
444         _etherPriceAuditors[account] = state;
445         emit AuditEtherPriceAuditorChanged(account, state);
446     }
447 
448     /**
449      * @dev Stage Voken price in USD, by stage index.
450      */
451     function stageVokenUsdPrice(uint16 stageIndex) private view returns (uint256) {
452         return VOKEN_USD_PRICE_START.add(VOKEN_USD_PRICE_STEP.mul(stageIndex));
453     }
454 
455     /**
456      * @dev wei => USD
457      */
458     function wei2usd(uint256 amount) private view returns (uint256) {
459         return amount.mul(_etherPrice).div(1 ether);
460     }
461 
462     /**
463      * @dev USD => wei
464      */
465     function usd2wei(uint256 amount) private view returns (uint256) {
466         return amount.mul(1 ether).div(_etherPrice);
467     }
468 
469     /**
470      * @dev USD => voken
471      */
472     function usd2voken(uint256 usdAmount) private view returns (uint256) {
473         return usdAmount.mul(1000000).div(_vokenUsdPrice);
474     }
475 
476     /**
477      * @dev USD => voken
478      */
479     function usd2vokenByStage(uint256 usdAmount, uint16 stageIndex) public view returns (uint256) {
480         return usdAmount.mul(1000000).div(stageVokenUsdPrice(stageIndex));
481     }
482 
483     /**
484      * @dev Calculate season number, by stage index.
485      */
486     function calcSeason(uint16 stageIndex) private view returns (uint16) {
487         if (stageIndex > 0) {
488             uint16 __seasonNumber = stageIndex.div(SEASON_STAGES);
489 
490             if (stageIndex.mod(SEASON_STAGES) > 0) {
491                 return __seasonNumber.add(1);
492             }
493             
494             return __seasonNumber;
495         }
496         
497         return 1;
498     }
499 
500     /**
501      * @dev Transfer Top-Sales wei, by season number.
502      */
503     function transferTopSales(uint16 seasonNumber, address payable to) external onlyOwner {
504         uint256 __weiRemain = seasonTopSalesRemain(seasonNumber);
505         require(to != address(0));
506         
507         _seasonWeiTopSalesTransfered[seasonNumber] = _seasonWeiTopSalesTransfered[seasonNumber].add(__weiRemain);
508         emit SeasonTopSalesWeiTransfered(seasonNumber, to, __weiRemain);
509         to.transfer(__weiRemain);
510     }
511 
512     /**
513      * @dev Pending remain, in wei.
514      */
515     function pendingRemain() private view returns (uint256) {
516         return _weiPending.sub(_weiPendingTransfered);
517     }
518 
519     /**
520      * @dev Transfer pending wei.
521      */
522     function transferPending(address payable to) external onlyOwner {
523         uint256 __weiRemain = pendingRemain();
524         require(to != address(0));
525 
526         _weiPendingTransfered = _weiPendingTransfered.add(__weiRemain);
527         emit PendingWeiTransfered(to, __weiRemain);
528         to.transfer(__weiRemain);
529     }
530 
531     /**
532      * @dev Transfer team wei.
533      */
534     function transferTeam(address payable to) external onlyOwner {
535         uint256 __weiRemain = _weiSold.sub(_weiRefRewarded).sub(_weiTopSales).sub(_weiPending).sub(_weiTeam);
536         require(to != address(0));
537 
538         _weiTeam = _weiTeam.add(__weiRemain);
539         emit TeamWeiTransfered(to, __weiRemain);
540         to.transfer(__weiRemain);
541     }
542 
543     /**
544      * @dev Status.
545      */
546     function status() public view returns (uint256 auditEtherPrice,
547                                            uint16 stage,
548                                            uint16 season,
549                                            uint256 vokenUsdPrice,
550                                            uint256 currentTopSalesRatio,
551                                            uint256 txs,
552                                            uint256 vokenTxs,
553                                            uint256 vokenBonusTxs,
554                                            uint256 vokenWhitelistTxs,
555                                            uint256 vokenIssued,
556                                            uint256 vokenBonus,
557                                            uint256 vokenWhitelist) {
558         auditEtherPrice = _etherPrice;
559 
560         if (_stage > STAGE_MAX) {
561             stage = STAGE_MAX;
562             season = SEASON_MAX;
563         } else {
564             stage = _stage;
565             season = _season;
566         }
567 
568         vokenUsdPrice = _vokenUsdPrice;
569         currentTopSalesRatio = _topSalesRatio;
570 
571         txs = _txs;
572         vokenTxs = _vokenTxs;
573         vokenBonusTxs = _vokenBonusTxs;
574         vokenWhitelistTxs = _vokenWhitelistTxs;
575         vokenIssued = _vokenIssued;
576         vokenBonus = _vokenBonus;
577         vokenWhitelist = _vokenWhitelist;
578     }
579 
580     /**
581      * @dev Sum.
582      */
583     function sum() public view returns(uint256 weiSold,
584                                        uint256 weiReferralRewarded,
585                                        uint256 weiTopSales,
586                                        uint256 weiTeam,
587                                        uint256 weiPending,
588                                        uint256 weiPendingTransfered,
589                                        uint256 weiPendingRemain) {
590         weiSold = _weiSold;
591         weiReferralRewarded = _weiRefRewarded;
592         weiTopSales = _weiTopSales;
593         weiTeam = _weiTeam;
594         weiPending = _weiPending;
595         weiPendingTransfered = _weiPendingTransfered;
596         weiPendingRemain = pendingRemain();
597     }
598 
599     /**
600      * @dev Throws if gas is not enough.
601      */
602     modifier enoughGas() {
603         require(gasleft() > GAS_MIN);
604         _;
605     }
606 
607     /**
608      * @dev Throws if not started.
609      */
610     modifier onlyOnSale() {
611         require(_startTimestamp > 0 && now > _startTimestamp, "Voken Public-Sale has not started yet.");
612         require(_etherPrice > 0, "Audit ETH price must be greater than zero.");
613         require(!paused(), "Voken Public-Sale is paused.");
614         require(_stage <= STAGE_MAX, "Voken Public-Sale Closed.");
615         _;
616     }
617 
618     /**
619      * @dev Top-Sales ratio.
620      */
621     function topSalesRatio(uint16 stageIndex) private view returns (uint256) {
622         return TOP_SALES_RATIO_START.add(TOP_SALES_RATIO_DISTANCE.mul(stageIndex).div(STAGE_MAX));
623     }
624 
625     /**
626      * @dev USD => wei, for Top-Sales
627      */
628     function usd2weiTopSales(uint256 usdAmount) private view returns (uint256) {
629         return usd2wei(usdAmount.mul(_topSalesRatio).div(100000000));
630     }
631 
632     /**
633      * @dev Calculate stage dollor cap, by stage index.
634      */
635     function stageUsdCap(uint16 stageIndex) private view returns (uint256) {
636         uint256 __usdCap = STAGE_USD_CAP_START.add(STAGE_USD_CAP_STEP.mul(stageIndex)); 
637 
638         if (__usdCap > STAGE_USD_CAP_MAX) {
639             return STAGE_USD_CAP_MAX;
640         }
641 
642         return __usdCap;
643     }
644 
645     /**
646      * @dev Stage Vokdn cap, by stage index.
647      */
648     function stageVokenCap(uint16 stageIndex) private view returns (uint256) {
649         return usd2vokenByStage(stageUsdCap(stageIndex), stageIndex);
650     }
651 
652     /**
653      * @dev Stage status, by stage index.
654      */
655     function stageStatus(uint16 stageIndex) public view returns (uint256 vokenUsdPrice,
656                                                                  uint256 vokenCap,
657                                                                  uint256 vokenOnSale,
658                                                                  uint256 vokenSold,
659                                                                  uint256 usdCap,
660                                                                  uint256 usdOnSale,
661                                                                  uint256 usdSold,
662                                                                  uint256 weiTopSalesRatio) {
663         if (stageIndex > STAGE_MAX) {
664             return (0, 0, 0, 0, 0, 0, 0, 0);
665         }
666 
667         vokenUsdPrice = stageVokenUsdPrice(stageIndex);
668 
669         vokenSold = _stageVokenIssued[stageIndex];
670         vokenCap = stageVokenCap(stageIndex);
671         vokenOnSale = vokenCap.sub(vokenSold);
672 
673         usdSold = _stageUsdSold[stageIndex];
674         usdCap = stageUsdCap(stageIndex);
675         usdOnSale = usdCap.sub(usdSold);
676 
677         weiTopSalesRatio = topSalesRatio(stageIndex);
678     }
679 
680     /**
681      * @dev Season Top-Sales remain, in wei.
682      */
683     function seasonTopSalesRemain(uint16 seasonNumber) private view returns (uint256) {
684         return _seasonWeiTopSales[seasonNumber].sub(_seasonWeiTopSalesTransfered[seasonNumber]);
685     }
686 
687     /**
688      * @dev Season Top-Sales rewards, by season number, in wei.
689      */
690     function seasonTopSalesRewards(uint16 seasonNumber) public view returns (uint256 weiSold,
691                                                                              uint256 weiTopSales,
692                                                                              uint256 weiTopSalesTransfered,
693                                                                              uint256 weiTopSalesRemain) {
694         weiSold = _seasonWeiSold[seasonNumber];
695         weiTopSales = _seasonWeiTopSales[seasonNumber];
696         weiTopSalesTransfered = _seasonWeiTopSalesTransfered[seasonNumber];
697         weiTopSalesRemain = seasonTopSalesRemain(seasonNumber);
698     }
699 
700     /**
701      * @dev Query account.
702      */
703     function accountQuery(address account) public view returns (uint256 vokenIssued,
704                                                                 uint256 vokenBonus,
705                                                                 uint256 vokenWhitelisted,
706                                                                 uint256 weiPurchased,
707                                                                 uint256 weiReferralRewarded) {
708         vokenIssued = _accountVokenIssued[account];
709         vokenBonus = _accountVokenBonus[account];
710         vokenWhitelisted = _accountVokenWhitelisted[account];
711         weiPurchased = _accountWeiPurchased[account];
712         weiReferralRewarded = _accountWeiRefRewarded[account];
713     }
714 
715     /**
716      * @dev Accounts in a specific season.
717      */
718     function seasonRefAccounts(uint16 seasonNumber) public view returns (address[] memory accounts) {
719         accounts = _seasonRefAccounts[seasonNumber];
720     }
721 
722     /**
723      * @dev Season number => account => USD purchased.
724      */
725     function usdSeasonAccountPurchased(uint16 seasonNumber, address account) public view returns (uint256) {
726         return _usdSeasonAccountPurchased[seasonNumber][account];
727     }
728 
729     /**
730      * @dev Season number => account => referral dollors.
731      */
732     function usdSeasonAccountRef(uint16 seasonNumber, address account) public view returns (uint256) {
733         return _usdSeasonAccountRef[seasonNumber][account];
734     }
735 
736     /**
737      * @dev constructor
738      */
739     constructor () public {
740         _etherPriceAuditors[msg.sender] = true;
741         _stage = 0;
742         _season = 1;
743     }
744 
745     /**
746      * @dev Receive ETH, and send Vokens.
747      */
748     function () external payable enoughGas onlyOnSale {
749         require(msg.value >= WEI_MIN);
750         require(msg.value <= WEI_MAX);
751 
752         // Set temporary variables.
753         setTemporaryVariables();
754         uint256 __usdAmount = wei2usd(msg.value);
755         uint256 __usdRemain = __usdAmount;
756         uint256 __vokenIssued;
757         uint256 __vokenBonus;
758         uint256 __usdUsed;
759         uint256 __weiUsed;
760 
761         // USD => Voken
762         while (gasleft() > GAS_EX && __usdRemain > 0 && _stage <= STAGE_MAX) {
763             uint256 __txVokenIssued;
764             (__txVokenIssued, __usdRemain) = ex(__usdRemain);
765             __vokenIssued = __vokenIssued.add(__txVokenIssued);
766         }
767 
768         // Used
769         __usdUsed = __usdAmount.sub(__usdRemain);
770         __weiUsed = usd2wei(__usdUsed);
771 
772         // Bonus 10%
773         if (msg.value >= WEI_BONUS) {
774             __vokenBonus = __vokenIssued.div(10);
775             assert(transferVokenBonus(__vokenBonus));
776         }
777 
778         // Whitelisted
779         // BUY-ONE-AND-GET-ONE-MORE-FREE
780         if (_inWhitelist_ && __vokenIssued > 0) {
781             // both issued and bonus
782             assert(transferVokenWhitelisted(__vokenIssued.add(__vokenBonus)));
783 
784             // 35% for 15 levels
785             sendWhitelistReferralRewards(__weiUsed);
786         }
787 
788         // If wei remains, refund.
789         if (__usdRemain > 0) {
790             uint256 __weiRemain = usd2wei(__usdRemain);
791             
792             __weiUsed = msg.value.sub(__weiRemain);
793             
794             // Refund wei back
795             msg.sender.transfer(__weiRemain);
796         }
797 
798         // Counter
799         if (__weiUsed > 0) {
800             _txs = _txs.add(1);
801             _weiSold = _weiSold.add(__weiUsed);
802             _accountWeiPurchased[msg.sender] = _accountWeiPurchased[msg.sender].add(__weiUsed);
803         }
804 
805         // Wei team
806         uint256 __weiTeam;
807         if (_season > SEASON_MAX)
808             __weiTeam = _weiSold.sub(_weiRefRewarded).sub(_weiTopSales).sub(_weiPending).sub(_weiTeam);
809         else
810             __weiTeam = _weiSold.sub(_weiRefRewarded).sub(_weiTopSales).sub(_weiPending).sub(_weiTeam).div(0.01 ether).mul(0.01 ether);
811 
812         _weiTeam = _weiTeam.add(__weiTeam);
813         _receiver.transfer(__weiTeam);
814 
815         // Assert finished
816         assert(true);
817     }
818 
819     /**
820      * @dev Set temporary variables.
821      */
822     function setTemporaryVariables() private {
823         delete _referrers_;
824         delete _rewards_;
825 
826         _inWhitelist_ = VOKEN.inWhitelist(msg.sender);
827         _pending_ = WHITELIST_REF_REWARDS_PCT_SUM;
828 
829         address __cursor = msg.sender;
830         for(uint16 i = 0; i < WHITELIST_REF_REWARDS_PCT.length; i++) {
831             address __refAccount = VOKEN.referrer(__cursor);
832 
833             if (__cursor == __refAccount)
834                 break;
835 
836             if (VOKEN.refCount(__refAccount) > i) {
837                 if (!_seasonHasRefAccount[_season][__refAccount]) {
838                     _seasonRefAccounts[_season].push(__refAccount);
839                     _seasonHasRefAccount[_season][__refAccount] = true;
840                 }
841 
842                 _pending_ = _pending_.sub(WHITELIST_REF_REWARDS_PCT[i]);
843                 _rewards_.push(WHITELIST_REF_REWARDS_PCT[i]);                    
844                 _referrers_.push(__refAccount);
845             }
846 
847             __cursor = __refAccount;
848         }
849     }
850 
851     /**
852      * @dev USD => Voken
853      */
854     function ex(uint256 usdAmount) private returns (uint256, uint256) {
855         uint256 __stageUsdCap = stageUsdCap(_stage);
856         uint256 __vokenIssued;
857 
858         // in stage
859         if (_stageUsdSold[_stage].add(usdAmount) <= __stageUsdCap) {
860             exCount(usdAmount);
861 
862             __vokenIssued = usd2voken(usdAmount);
863             assert(transfervokenIssued(__vokenIssued, usdAmount));
864 
865             // close stage, if stage dollor cap reached
866             if (__stageUsdCap == _stageUsdSold[_stage]) {
867                 assert(closeStage());
868             }
869 
870             return (__vokenIssued, 0);
871         }
872 
873         // close stage
874         uint256 __usdUsed = __stageUsdCap.sub(_stageUsdSold[_stage]);
875         uint256 __usdRemain = usdAmount.sub(__usdUsed);
876 
877         exCount(__usdUsed);
878 
879         __vokenIssued = usd2voken(__usdUsed);
880         assert(transfervokenIssued(__vokenIssued, __usdUsed));
881         assert(closeStage());
882 
883         return (__vokenIssued, __usdRemain);
884     }
885 
886     /**
887      * @dev Ex counter.
888      */
889     function exCount(uint256 usdAmount) private {
890         uint256 __weiSold = usd2wei(usdAmount);
891         uint256 __weiTopSales = usd2weiTopSales(usdAmount);
892 
893         _usdSeasonAccountPurchased[_season][msg.sender] = _usdSeasonAccountPurchased[_season][msg.sender].add(usdAmount);   // season => address => purchased, in USD
894         
895         _stageUsdSold[_stage] = _stageUsdSold[_stage].add(usdAmount);                   // stage sold, in USD
896         _seasonWeiSold[_season] = _seasonWeiSold[_season].add(__weiSold);               // season sold, in wei
897         _seasonWeiTopSales[_season] = _seasonWeiTopSales[_season].add(__weiTopSales);   // season Top-Sales, in wei
898         _weiTopSales = _weiTopSales.add(__weiTopSales);                                 // sum Top-Sales, in wei
899 
900         // season referral account
901         if (_inWhitelist_) {
902             for (uint16 i = 0; i < _rewards_.length; i++) {
903                 _usdSeasonAccountRef[_season][_referrers_[i]] = _usdSeasonAccountRef[_season][_referrers_[i]].add(usdAmount);
904             }
905         }
906     }
907 
908     /**
909      * @dev Transfer Voken issued.
910      */
911     function transfervokenIssued(uint256 amount, uint256 usdAmount) private returns (bool) {
912         _vokenTxs = _vokenTxs.add(1);
913         
914         _vokenIssued = _vokenIssued.add(amount);
915         _stageVokenIssued[_stage] = _stageVokenIssued[_stage].add(amount);
916         _accountVokenIssued[msg.sender] = _accountVokenIssued[msg.sender].add(amount);
917 
918         assert(VOKEN.transfer(msg.sender, amount));
919         emit VokenIssuedTransfered(_stage, msg.sender, amount, _etherPrice, usdAmount);
920         return true;
921     }
922 
923     /**
924      * @dev Transfer Voken bonus.
925      */
926     function transferVokenBonus(uint256 amount) private returns (bool) {
927         _vokenBonusTxs = _vokenBonusTxs.add(1);
928 
929         _vokenBonus = _vokenBonus.add(amount);
930         _accountVokenBonus[msg.sender] = _accountVokenBonus[msg.sender].add(amount);
931 
932         assert(VOKEN.transfer(msg.sender, amount));
933         emit VokenBonusTransfered(msg.sender, amount);
934         return true;
935     }
936 
937     /**
938      * @dev Transfer Voken whitelisted.
939      */
940     function transferVokenWhitelisted(uint256 amount) private returns (bool) {
941         _vokenWhitelistTxs = _vokenWhitelistTxs.add(1);
942 
943         _vokenWhitelist = _vokenWhitelist.add(amount);
944         _accountVokenWhitelisted[msg.sender] = _accountVokenWhitelisted[msg.sender].add(amount);
945 
946         assert(VOKEN.transfer(msg.sender, amount));
947         emit VokenWhitelistTransfered(msg.sender, amount);
948         return true;
949     }
950 
951     /**
952      * Close current stage.
953      */
954     function closeStage() private returns (bool) {
955         emit StageClosed(_stage, msg.sender);
956         _stage = _stage.add(1);
957         _vokenUsdPrice = stageVokenUsdPrice(_stage);
958         _topSalesRatio = topSalesRatio(_stage);
959 
960         // Close current season
961         uint16 __seasonNumber = calcSeason(_stage);
962         if (_season < __seasonNumber) {
963             emit SeasonClosed(_season, msg.sender);
964             _season = __seasonNumber;
965         }
966 
967         return true;
968     }
969 
970     /**
971      * @dev Send whitelist referral rewards.
972      */
973     function sendWhitelistReferralRewards(uint256 weiAmount) private {
974         uint256 __weiRemain = weiAmount;
975         for (uint16 i = 0; i < _rewards_.length; i++) {
976             uint256 __weiReward = weiAmount.mul(_rewards_[i]).div(100);
977             address payable __receiver = address(uint160(_referrers_[i]));
978 
979             _weiRefRewarded = _weiRefRewarded.add(__weiReward);
980             _accountWeiRefRewarded[__receiver] = _accountWeiRefRewarded[__receiver].add(__weiReward);
981             __weiRemain = __weiRemain.sub(__weiReward);
982 
983             __receiver.transfer(__weiReward);
984         }
985         
986         if (_pending_ > 0)
987             _weiPending = _weiPending.add(weiAmount.mul(_pending_).div(100));
988     }
989 }