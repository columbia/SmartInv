1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-20
3 */
4 
5 pragma solidity ^0.5.7;
6 
7 // WESION Public Sale
8 
9 
10 /**
11  * @title SafeMath for uint256
12  * @dev Unsigned math operations with safety checks that revert on error.
13  */
14 library SafeMath256 {
15     /**
16      * @dev Adds two unsigned integers, reverts on overflow.
17      */
18     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
19         c = a + b;
20         assert(c >= a);
21         return c;
22     }
23 
24     /**
25      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
26      */
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         assert(b <= a);
29         return a - b;
30     }
31 
32     /**
33      * @dev Multiplies two unsigned integers, reverts on overflow.
34      */
35     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
36         if (a == 0) {
37             return 0;
38         }
39         c = a * b;
40         assert(c / a == b);
41         return c;
42     }
43 
44     /**
45      * @dev Integer division of two unsigned integers truncating the quotient,
46      * reverts on division by zero.
47      */
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         assert(b > 0);
50         uint256 c = a / b;
51         assert(a == b * c + a % b);
52         return a / b;
53     }
54 
55     /**
56      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
57      * reverts when dividing by zero.
58      */
59     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
60         require(b != 0);
61         return a % b;
62     }
63 }
64 
65 /**
66  * @title SafeMath for uint16
67  * @dev Unsigned math operations with safety checks that revert on error.
68  */
69 library SafeMath16 {
70     /**
71      * @dev Adds two unsigned integers, reverts on overflow.
72      */
73     function add(uint16 a, uint16 b) internal pure returns (uint16 c) {
74         c = a + b;
75         assert(c >= a);
76         return c;
77     }
78 
79     /**
80      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
81      */
82     function sub(uint16 a, uint16 b) internal pure returns (uint16) {
83         assert(b <= a);
84         return a - b;
85     }
86 
87     /**
88      * @dev Multiplies two unsigned integers, reverts on overflow.
89      */
90     function mul(uint16 a, uint16 b) internal pure returns (uint16 c) {
91         if (a == 0) {
92             return 0;
93         }
94         c = a * b;
95         assert(c / a == b);
96         return c;
97     }
98 
99     /**
100      * @dev Integer division of two unsigned integers truncating the quotient,
101      * reverts on division by zero.
102      */
103     function div(uint16 a, uint16 b) internal pure returns (uint16) {
104         assert(b > 0);
105         uint256 c = a / b;
106         assert(a == b * c + a % b);
107         return a / b;
108     }
109 
110     /**
111      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
112      * reverts when dividing by zero.
113      */
114     function mod(uint16 a, uint16 b) internal pure returns (uint16) {
115         require(b != 0);
116         return a % b;
117     }
118 }
119 
120 
121 /**
122  * @title Ownable
123  */
124 contract Ownable {
125     address private _owner;
126     address payable internal _receiver;
127 
128     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
129     event ReceiverChanged(address indexed previousReceiver, address indexed newReceiver);
130 
131     /**
132      * @dev The Ownable constructor sets the original `owner` of the contract
133      * to the sender account.
134      */
135     constructor () internal {
136         _owner = msg.sender;
137         _receiver = msg.sender;
138     }
139 
140     /**
141      * @return The address of the owner.
142      */
143     function owner() public view returns (address) {
144         return _owner;
145     }
146 
147     /**
148      * @dev Throws if called by any account other than the owner.
149      */
150     modifier onlyOwner() {
151         require(msg.sender == _owner);
152         _;
153     }
154 
155     /**
156      * @dev Allows the current owner to transfer control of the contract to a newOwner.
157      * @param newOwner The address to transfer ownership to.
158      */
159     function transferOwnership(address newOwner) external onlyOwner {
160         require(newOwner != address(0));
161         address __previousOwner = _owner;
162         _owner = newOwner;
163         emit OwnershipTransferred(__previousOwner, newOwner);
164     }
165 
166     /**
167      * @dev Change receiver.
168      */
169     function changeReceiver(address payable newReceiver) external onlyOwner {
170         require(newReceiver != address(0));
171         address __previousReceiver = _receiver;
172         _receiver = newReceiver;
173         emit ReceiverChanged(__previousReceiver, newReceiver);
174     }
175 
176     /**
177      * @dev Rescue compatible ERC20 Token
178      *
179      * @param tokenAddr ERC20 The address of the ERC20 token contract
180      * @param receiver The address of the receiver
181      * @param amount uint256
182      */
183     function rescueTokens(address tokenAddr, address receiver, uint256 amount) external onlyOwner {
184         IERC20 _token = IERC20(tokenAddr);
185         require(receiver != address(0));
186         uint256 balance = _token.balanceOf(address(this));
187         require(balance >= amount);
188 
189         assert(_token.transfer(receiver, amount));
190     }
191 
192     /**
193      * @dev Withdraw ether
194      */
195     function withdrawEther(address payable to, uint256 amount) external onlyOwner {
196         require(to != address(0));
197         uint256 balance = address(this).balance;
198         require(balance >= amount);
199 
200         to.transfer(amount);
201     }
202 }
203 
204 
205 /**
206  * @title Pausable
207  * @dev Base contract which allows children to implement an emergency stop mechanism.
208  */
209 contract Pausable is Ownable {
210     bool private _paused;
211 
212     event Paused(address account);
213     event Unpaused(address account);
214 
215     constructor () internal {
216         _paused = false;
217     }
218 
219     /**
220      * @return Returns true if the contract is paused, false otherwise.
221      */
222     function paused() public view returns (bool) {
223         return _paused;
224     }
225 
226     /**
227      * @dev Modifier to make a function callable only when the contract is not paused.
228      */
229     modifier whenNotPaused() {
230         require(!_paused, "Paused.");
231         _;
232     }
233 
234     /**
235      * @dev Called by a pauser to pause, triggers stopped state.
236      */
237     function setPaused(bool state) external onlyOwner {
238         if (_paused && !state) {
239             _paused = false;
240             emit Unpaused(msg.sender);
241         } else if (!_paused && state) {
242             _paused = true;
243             emit Paused(msg.sender);
244         }
245     }
246 }
247 
248 
249 /**
250  * @title ERC20 interface
251  * @dev see https://eips.ethereum.org/EIPS/eip-20
252  */
253 interface IERC20 {
254     function balanceOf(address owner) external view returns (uint256);
255     function transfer(address to, uint256 value) external returns (bool);
256 }
257 
258 
259 /**
260  * @title WESION interface
261  */
262 interface IWesion {
263     function balanceOf(address owner) external view returns (uint256);
264     function transfer(address to, uint256 value) external returns (bool);
265     function inWhitelist(address account) external view returns (bool);
266     function referrer(address account) external view returns (address);
267     function refCount(address account) external view returns (uint256);
268 }
269 
270 
271 /**
272  * @title WESION Public Sale
273  */
274 contract WesionPublicSale is Ownable, Pausable{
275     using SafeMath16 for uint16;
276     using SafeMath256 for uint256;
277 
278     // WESION
279     IWesion public WESION = IWesion(0x2c1564A74F07757765642ACef62a583B38d5A213);
280 
281     // Start timestamp
282     uint32 _startTimestamp;
283 
284     // Audit ether price
285     uint256 private _etherPrice;    // 1 Ether = xx.xxxxxx USD, with 6 decimals
286 
287     // Referral rewards, 35% for 15 levels
288     uint16 private WHITELIST_REF_REWARDS_PCT_SUM = 35;
289     uint16[15] private WHITELIST_REF_REWARDS_PCT = [
290         6,  // 6% for Level.1
291         6,  // 6% for Level.2
292         5,  // 5% for Level.3
293         4,  // 4% for Level.4
294         3,  // 3% for Level.5
295         2,  // 2% for Level.6
296         1,  // 1% for Level.7
297         1,  // 1% for Level.8
298         1,  // 1% for Level.9
299         1,  // 1% for Level.10
300         1,  // 1% for Level.11
301         1,  // 1% for Level.12
302         1,  // 1% for Level.13
303         1,  // 1% for Level.14
304         1   // 1% for Level.15
305     ];
306 
307     // Wei & Gas
308     uint72 private WEI_MIN = 0.1 ether;     // 0.1 Ether Minimum
309     uint72 private WEI_MAX = 100 ether;     // 100 Ether Maximum
310     uint72 private WEI_BONUS = 10 ether;    // >10 Ether for Bonus
311     uint24 private GAS_MIN = 3000000;       // 3.0 Mwei gas Mininum
312     uint24 private GAS_EX = 1500000;        // 1.5 Mwei gas for ex
313 
314     // Price
315     uint256 private WESION_USD_PRICE_START = 1000;       // $      0.00100 USD
316     uint256 private WESION_USD_PRICE_STEP = 10;          // $    + 0.00001 USD
317     uint256 private STAGE_USD_CAP_START = 100000000;    // $    100 USD
318     uint256 private STAGE_USD_CAP_STEP = 1000000;       // $     +1 USD
319     uint256 private STAGE_USD_CAP_MAX = 15100000000;    // $ 15,100 USD
320 
321     uint256 private _WESIONUsdPrice = WESION_USD_PRICE_START;
322 
323     // Progress
324     uint16 private STAGE_MAX = 60000;   // 60,000 stages total
325     uint16 private SEASON_MAX = 100;    // 100 seasons total
326     uint16 private SEASON_STAGES = 600; // each 600 stages is a season
327 
328     uint16 private _stage;
329     uint16 private _season;
330 
331     // Sum
332     uint256 private _txs;
333     uint256 private _WESIONTxs;
334     uint256 private _WESIONBonusTxs;
335     uint256 private _WESIONWhitelistTxs;
336     uint256 private _WESIONIssued;
337     uint256 private _WESIONBonus;
338     uint256 private _WESIONWhitelist;
339     uint256 private _weiSold;
340     uint256 private _weiRefRewarded;
341     uint256 private _weiTopSales;
342     uint256 private _weiTeam;
343     uint256 private _weiPending;
344     uint256 private _weiPendingTransfered;
345 
346     // Top-Sales
347     uint256 private TOP_SALES_RATIO_START = 15000000;         // 15%, with 8 decimals
348     uint256 private TOP_SALES_RATIO_DISTANCE = 50000000;      // 50%, with 8 decimals
349 
350     uint256 private _topSalesRatio = TOP_SALES_RATIO_START;   // 15% + 50% x(_stage/_stageMax)
351 
352     // During tx
353     bool private _inWhitelist_;
354     uint256 private _pending_ = WHITELIST_REF_REWARDS_PCT_SUM;
355     uint16[] private _rewards_;
356     address[] private _referrers_;
357 
358     // Audit ether price auditor
359     mapping (address => bool) private _etherPriceAuditors;
360 
361     // Stage
362     mapping (uint16 => uint256) private _stageUsdSold;
363     mapping (uint16 => uint256) private _stageWESIONIssued;
364 
365     // Season
366     mapping (uint16 => uint256) private _seasonWeiSold;
367     mapping (uint16 => uint256) private _seasonWeiTopSales;
368     mapping (uint16 => uint256) private _seasonWeiTopSalesTransfered;
369 
370     // Account
371     mapping (address => uint256) private _accountWESIONIssued;
372     mapping (address => uint256) private _accountWESIONBonus;
373     mapping (address => uint256) private _accountWESIONWhitelisted;
374     mapping (address => uint256) private _accountWeiPurchased;
375     mapping (address => uint256) private _accountWeiRefRewarded;
376 
377     // Ref
378     mapping (uint16 => address[]) private _seasonRefAccounts;
379     mapping (uint16 => mapping (address => bool)) private _seasonHasRefAccount;
380     mapping (uint16 => mapping (address => uint256)) private _usdSeasonAccountPurchased;
381     mapping (uint16 => mapping (address => uint256)) private _usdSeasonAccountRef;
382 
383     // Events
384     event AuditEtherPriceChanged(uint256 value, address indexed account);
385     event AuditEtherPriceAuditorChanged(address indexed account, bool state);
386 
387     event WESIONBonusTransfered(address indexed to, uint256 amount);
388     event WESIONWhitelistTransfered(address indexed to, uint256 amount);
389     event WESIONIssuedTransfered(uint16 stageIndex, address indexed to, uint256 WESIONAmount, uint256 auditEtherPrice, uint256 weiUsed);
390 
391     event StageClosed(uint256 _stageNumber, address indexed account);
392     event SeasonClosed(uint16 _seasonNumber, address indexed account);
393 
394     event SeasonTopSalesWeiTransfered(uint16 seasonNumber, address indexed to, uint256 amount);
395     event TeamWeiTransfered(address indexed to, uint256 amount);
396     event PendingWeiTransfered(address indexed to, uint256 amount);
397 
398 
399     /**
400      * @dev Start timestamp.
401      */
402     function startTimestamp() public view returns (uint32) {
403         return _startTimestamp;
404     }
405 
406     /**
407      * @dev Set start timestamp.
408      */
409     function setStartTimestamp(uint32 timestamp) external onlyOwner {
410         _startTimestamp = timestamp;
411     }
412 
413     /**
414      * @dev Throws if not ether price auditor.
415      */
416     modifier onlyEtherPriceAuditor() {
417         require(_etherPriceAuditors[msg.sender]);
418         _;
419     }
420 
421     /**
422      * @dev Set audit ether price.
423      */
424     function setEtherPrice(uint256 value) external onlyEtherPriceAuditor {
425         _etherPrice = value;
426         emit AuditEtherPriceChanged(value, msg.sender);
427     }
428 
429     /**
430      * @dev Get ether price auditor state.
431      */
432     function etherPriceAuditor(address account) public view returns (bool) {
433         return _etherPriceAuditors[account];
434     }
435 
436     /**
437      * @dev Get ether price auditor state.
438      */
439     function setEtherPriceAuditor(address account, bool state) external onlyOwner {
440         _etherPriceAuditors[account] = state;
441         emit AuditEtherPriceAuditorChanged(account, state);
442     }
443 
444     /**
445      * @dev Stage WESION price in USD, by stage index.
446      */
447     function stageWESIONUsdPrice(uint16 stageIndex) private view returns (uint256) {
448         return WESION_USD_PRICE_START.add(WESION_USD_PRICE_STEP.mul(stageIndex));
449     }
450 
451     /**
452      * @dev wei => USD
453      */
454     function wei2usd(uint256 amount) private view returns (uint256) {
455         return amount.mul(_etherPrice).div(1 ether);
456     }
457 
458     /**
459      * @dev USD => wei
460      */
461     function usd2wei(uint256 amount) private view returns (uint256) {
462         return amount.mul(1 ether).div(_etherPrice);
463     }
464 
465     /**
466      * @dev USD => WESION
467      */
468     function usd2WESION(uint256 usdAmount) private view returns (uint256) {
469         return usdAmount.mul(1000000).div(_WESIONUsdPrice);
470     }
471 
472     /**
473      * @dev USD => WESION
474      */
475     function usd2WESIONByStage(uint256 usdAmount, uint16 stageIndex) public view returns (uint256) {
476         return usdAmount.mul(1000000).div(stageWESIONUsdPrice(stageIndex));
477     }
478 
479     /**
480      * @dev Calculate season number, by stage index.
481      */
482     function calcSeason(uint16 stageIndex) private view returns (uint16) {
483         if (stageIndex > 0) {
484             uint16 __seasonNumber = stageIndex.div(SEASON_STAGES);
485 
486             if (stageIndex.mod(SEASON_STAGES) > 0) {
487                 return __seasonNumber.add(1);
488             }
489 
490             return __seasonNumber;
491         }
492 
493         return 1;
494     }
495 
496     /**
497      * @dev Transfer Top-Sales wei, by season number.
498      */
499     function transferTopSales(uint16 seasonNumber, address payable to) external onlyOwner {
500         uint256 __weiRemain = seasonTopSalesRemain(seasonNumber);
501         require(to != address(0));
502 
503         _seasonWeiTopSalesTransfered[seasonNumber] = _seasonWeiTopSalesTransfered[seasonNumber].add(__weiRemain);
504         emit SeasonTopSalesWeiTransfered(seasonNumber, to, __weiRemain);
505         to.transfer(__weiRemain);
506     }
507 
508     /**
509      * @dev Pending remain, in wei.
510      */
511     function pendingRemain() private view returns (uint256) {
512         return _weiPending.sub(_weiPendingTransfered);
513     }
514 
515     /**
516      * @dev Transfer pending wei.
517      */
518     function transferPending(address payable to) external onlyOwner {
519         uint256 __weiRemain = pendingRemain();
520         require(to != address(0));
521 
522         _weiPendingTransfered = _weiPendingTransfered.add(__weiRemain);
523         emit PendingWeiTransfered(to, __weiRemain);
524         to.transfer(__weiRemain);
525     }
526 
527     /**
528      * @dev Transfer team wei.
529      */
530     function transferTeam(address payable to) external onlyOwner {
531         uint256 __weiRemain = _weiSold.sub(_weiRefRewarded).sub(_weiTopSales).sub(_weiPending).sub(_weiTeam);
532         require(to != address(0));
533 
534         _weiTeam = _weiTeam.add(__weiRemain);
535         emit TeamWeiTransfered(to, __weiRemain);
536         to.transfer(__weiRemain);
537     }
538 
539     /**
540      * @dev Status.
541      */
542     function status() public view returns (uint256 auditEtherPrice,
543                                            uint16 stage,
544                                            uint16 season,
545                                            uint256 WESIONUsdPrice,
546                                            uint256 currentTopSalesRatio,
547                                            uint256 txs,
548                                            uint256 WESIONTxs,
549                                            uint256 WESIONBonusTxs,
550                                            uint256 WESIONWhitelistTxs,
551                                            uint256 WESIONIssued,
552                                            uint256 WESIONBonus,
553                                            uint256 WESIONWhitelist) {
554         auditEtherPrice = _etherPrice;
555 
556         if (_stage > STAGE_MAX) {
557             stage = STAGE_MAX;
558             season = SEASON_MAX;
559         } else {
560             stage = _stage;
561             season = _season;
562         }
563 
564         WESIONUsdPrice = _WESIONUsdPrice;
565         currentTopSalesRatio = _topSalesRatio;
566 
567         txs = _txs;
568         WESIONTxs = _WESIONTxs;
569         WESIONBonusTxs = _WESIONBonusTxs;
570         WESIONWhitelistTxs = _WESIONWhitelistTxs;
571         WESIONIssued = _WESIONIssued;
572         WESIONBonus = _WESIONBonus;
573         WESIONWhitelist = _WESIONWhitelist;
574     }
575 
576     /**
577      * @dev Sum.
578      */
579     function sum() public view returns(uint256 weiSold,
580                                        uint256 weiReferralRewarded,
581                                        uint256 weiTopSales,
582                                        uint256 weiTeam,
583                                        uint256 weiPending,
584                                        uint256 weiPendingTransfered,
585                                        uint256 weiPendingRemain) {
586         weiSold = _weiSold;
587         weiReferralRewarded = _weiRefRewarded;
588         weiTopSales = _weiTopSales;
589         weiTeam = _weiTeam;
590         weiPending = _weiPending;
591         weiPendingTransfered = _weiPendingTransfered;
592         weiPendingRemain = pendingRemain();
593     }
594 
595     /**
596      * @dev Throws if gas is not enough.
597      */
598     modifier enoughGas() {
599         require(gasleft() > GAS_MIN);
600         _;
601     }
602 
603     /**
604      * @dev Throws if not started.
605      */
606     modifier onlyOnSale() {
607         require(_startTimestamp > 0 && now > _startTimestamp, "WESION Public-Sale has not started yet.");
608         require(_etherPrice > 0, "Audit ETH price must be greater than zero.");
609         require(!paused(), "WESION Public-Sale is paused.");
610         require(_stage <= STAGE_MAX, "WESION Public-Sale Closed.");
611         _;
612     }
613 
614     /**
615      * @dev Top-Sales ratio.
616      */
617     function topSalesRatio(uint16 stageIndex) private view returns (uint256) {
618         return TOP_SALES_RATIO_START.add(TOP_SALES_RATIO_DISTANCE.mul(stageIndex).div(STAGE_MAX));
619     }
620 
621     /**
622      * @dev USD => wei, for Top-Sales
623      */
624     function usd2weiTopSales(uint256 usdAmount) private view returns (uint256) {
625         return usd2wei(usdAmount.mul(_topSalesRatio).div(100000000));
626     }
627 
628     /**
629      * @dev Calculate stage dollor cap, by stage index.
630      */
631     function stageUsdCap(uint16 stageIndex) private view returns (uint256) {
632         uint256 __usdCap = STAGE_USD_CAP_START.add(STAGE_USD_CAP_STEP.mul(stageIndex));
633 
634         if (__usdCap > STAGE_USD_CAP_MAX) {
635             return STAGE_USD_CAP_MAX;
636         }
637 
638         return __usdCap;
639     }
640 
641     /**
642      * @dev Stage Vokdn cap, by stage index.
643      */
644     function stageWESIONCap(uint16 stageIndex) private view returns (uint256) {
645         return usd2WESIONByStage(stageUsdCap(stageIndex), stageIndex);
646     }
647 
648     /**
649      * @dev Stage status, by stage index.
650      */
651     function stageStatus(uint16 stageIndex) public view returns (uint256 WESIONUsdPrice,
652                                                                  uint256 WESIONCap,
653                                                                  uint256 WESIONOnSale,
654                                                                  uint256 WESIONSold,
655                                                                  uint256 usdCap,
656                                                                  uint256 usdOnSale,
657                                                                  uint256 usdSold,
658                                                                  uint256 weiTopSalesRatio) {
659         if (stageIndex > STAGE_MAX) {
660             return (0, 0, 0, 0, 0, 0, 0, 0);
661         }
662 
663         WESIONUsdPrice = stageWESIONUsdPrice(stageIndex);
664 
665         WESIONSold = _stageWESIONIssued[stageIndex];
666         WESIONCap = stageWESIONCap(stageIndex);
667         WESIONOnSale = WESIONCap.sub(WESIONSold);
668 
669         usdSold = _stageUsdSold[stageIndex];
670         usdCap = stageUsdCap(stageIndex);
671         usdOnSale = usdCap.sub(usdSold);
672 
673         weiTopSalesRatio = topSalesRatio(stageIndex);
674     }
675 
676     /**
677      * @dev Season Top-Sales remain, in wei.
678      */
679     function seasonTopSalesRemain(uint16 seasonNumber) private view returns (uint256) {
680         return _seasonWeiTopSales[seasonNumber].sub(_seasonWeiTopSalesTransfered[seasonNumber]);
681     }
682 
683     /**
684      * @dev Season Top-Sales rewards, by season number, in wei.
685      */
686     function seasonTopSalesRewards(uint16 seasonNumber) public view returns (uint256 weiSold,
687                                                                              uint256 weiTopSales,
688                                                                              uint256 weiTopSalesTransfered,
689                                                                              uint256 weiTopSalesRemain) {
690         weiSold = _seasonWeiSold[seasonNumber];
691         weiTopSales = _seasonWeiTopSales[seasonNumber];
692         weiTopSalesTransfered = _seasonWeiTopSalesTransfered[seasonNumber];
693         weiTopSalesRemain = seasonTopSalesRemain(seasonNumber);
694     }
695 
696     /**
697      * @dev Query account.
698      */
699     function accountQuery(address account) public view returns (uint256 WESIONIssued,
700                                                                 uint256 WESIONBonus,
701                                                                 uint256 WESIONWhitelisted,
702                                                                 uint256 weiPurchased,
703                                                                 uint256 weiReferralRewarded) {
704         WESIONIssued = _accountWESIONIssued[account];
705         WESIONBonus = _accountWESIONBonus[account];
706         WESIONWhitelisted = _accountWESIONWhitelisted[account];
707         weiPurchased = _accountWeiPurchased[account];
708         weiReferralRewarded = _accountWeiRefRewarded[account];
709     }
710 
711     /**
712      * @dev Accounts in a specific season.
713      */
714     function seasonRefAccounts(uint16 seasonNumber) public view returns (address[] memory accounts) {
715         accounts = _seasonRefAccounts[seasonNumber];
716     }
717 
718     /**
719      * @dev Season number => account => USD purchased.
720      */
721     function usdSeasonAccountPurchased(uint16 seasonNumber, address account) public view returns (uint256) {
722         return _usdSeasonAccountPurchased[seasonNumber][account];
723     }
724 
725     /**
726      * @dev Season number => account => referral dollors.
727      */
728     function usdSeasonAccountRef(uint16 seasonNumber, address account) public view returns (uint256) {
729         return _usdSeasonAccountRef[seasonNumber][account];
730     }
731 
732     /**
733      * @dev constructor
734      */
735     constructor () public {
736         _etherPriceAuditors[msg.sender] = true;
737         _stage = 0;
738         _season = 1;
739     }
740 
741     /**
742      * @dev Receive ETH, and send WESIONs.
743      */
744     function () external payable enoughGas onlyOnSale {
745         require(msg.value >= WEI_MIN);
746         require(msg.value <= WEI_MAX);
747 
748         // Set temporary variables.
749         setTemporaryVariables();
750         uint256 __usdAmount = wei2usd(msg.value);
751         uint256 __usdRemain = __usdAmount;
752         uint256 __WESIONIssued;
753         uint256 __WESIONBonus;
754         uint256 __usdUsed;
755         uint256 __weiUsed;
756 
757         // USD => WESION
758         while (gasleft() > GAS_EX && __usdRemain > 0 && _stage <= STAGE_MAX) {
759             uint256 __txWESIONIssued;
760             (__txWESIONIssued, __usdRemain) = ex(__usdRemain);
761             __WESIONIssued = __WESIONIssued.add(__txWESIONIssued);
762         }
763 
764         // Used
765         __usdUsed = __usdAmount.sub(__usdRemain);
766         __weiUsed = usd2wei(__usdUsed);
767 
768         // Bonus 10%
769         if (msg.value >= WEI_BONUS) {
770             __WESIONBonus = __WESIONIssued.div(10);
771             assert(transferWESIONBonus(__WESIONBonus));
772         }
773 
774         // Whitelisted
775         // BUY-ONE-AND-GET-ONE-MORE-FREE
776         if (_inWhitelist_ && __WESIONIssued > 0) {
777             // both issued and bonus
778             assert(transferWESIONWhitelisted(__WESIONIssued.add(__WESIONBonus)));
779 
780             // 35% for 15 levels
781             sendWhitelistReferralRewards(__weiUsed);
782         }
783 
784         // If wei remains, refund.
785         if (__usdRemain > 0) {
786             uint256 __weiRemain = usd2wei(__usdRemain);
787 
788             __weiUsed = msg.value.sub(__weiRemain);
789 
790             // Refund wei back
791             msg.sender.transfer(__weiRemain);
792         }
793 
794         // Counter
795         if (__weiUsed > 0) {
796             _txs = _txs.add(1);
797             _weiSold = _weiSold.add(__weiUsed);
798             _accountWeiPurchased[msg.sender] = _accountWeiPurchased[msg.sender].add(__weiUsed);
799         }
800 
801         // Wei team
802         uint256 __weiTeam;
803         if (_season > SEASON_MAX)
804             __weiTeam = _weiSold.sub(_weiRefRewarded).sub(_weiTopSales).sub(_weiPending).sub(_weiTeam);
805         else
806             __weiTeam = _weiSold.sub(_weiRefRewarded).sub(_weiTopSales).sub(_weiPending).sub(_weiTeam).div(0.01 ether).mul(0.01 ether);
807 
808         _weiTeam = _weiTeam.add(__weiTeam);
809         _receiver.transfer(__weiTeam);
810 
811         // Assert finished
812         assert(true);
813     }
814 
815     /**
816      * @dev Set temporary variables.
817      */
818     function setTemporaryVariables() private {
819         delete _referrers_;
820         delete _rewards_;
821 
822         _inWhitelist_ = WESION.inWhitelist(msg.sender);
823         _pending_ = WHITELIST_REF_REWARDS_PCT_SUM;
824 
825         address __cursor = msg.sender;
826         for(uint16 i = 0; i < WHITELIST_REF_REWARDS_PCT.length; i++) {
827             address __refAccount = WESION.referrer(__cursor);
828 
829             if (__cursor == __refAccount)
830                 break;
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