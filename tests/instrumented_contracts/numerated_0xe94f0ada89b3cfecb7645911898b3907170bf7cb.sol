1 pragma solidity ^0.5.7;
2 
3 
4 // Token Public Sale
5 
6 library SafeMath256 {
7 
8     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
9         c = a + b;
10         assert(c >= a);
11         return c;
12     }
13 
14 
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19 
20 
21     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
22         if (a == 0) {
23             return 0;
24         }
25         c = a * b;
26         assert(c / a == b);
27         return c;
28     }
29 
30 
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         assert(b > 0);
33         uint256 c = a / b;
34         assert(a == b * c + a % b);
35         return a / b;
36     }
37 
38 
39     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
40         require(b != 0);
41         return a % b;
42     }
43 }
44 
45 
46 library SafeMath16 {
47 
48     function add(uint16 a, uint16 b) internal pure returns (uint16 c) {
49         c = a + b;
50         assert(c >= a);
51         return c;
52     }
53 
54 
55     function sub(uint16 a, uint16 b) internal pure returns (uint16) {
56         assert(b <= a);
57         return a - b;
58     }
59 
60     function mul(uint16 a, uint16 b) internal pure returns (uint16 c) {
61         if (a == 0) {
62             return 0;
63         }
64         c = a * b;
65         assert(c / a == b);
66         return c;
67     }
68 
69     function div(uint16 a, uint16 b) internal pure returns (uint16) {
70         assert(b > 0);
71         uint256 c = a / b;
72         assert(a == b * c + a % b);
73         return a / b;
74     }
75 
76     function mod(uint16 a, uint16 b) internal pure returns (uint16) {
77         require(b != 0);
78         return a % b;
79     }
80 }
81 
82 
83 contract Ownable {
84     address private _owner;
85     address payable internal _receiver;
86 
87     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
88     event ReceiverChanged(address indexed previousReceiver, address indexed newReceiver);
89 
90     constructor () internal {
91         _owner = msg.sender;
92         _receiver = msg.sender;
93     }
94 
95 
96     function owner() public view returns (address) {
97         return _owner;
98     }
99 
100 
101     modifier onlyOwner() {
102         require(msg.sender == _owner);
103         _;
104     }
105 
106 
107     function transferOwnership(address newOwner) external onlyOwner {
108         require(newOwner != address(0));
109         address __previousOwner = _owner;
110         _owner = newOwner;
111         emit OwnershipTransferred(__previousOwner, newOwner);
112     }
113 
114     function changeReceiver(address payable newReceiver) external onlyOwner {
115         require(newReceiver != address(0));
116         address __previousReceiver = _receiver;
117         _receiver = newReceiver;
118         emit ReceiverChanged(__previousReceiver, newReceiver);
119     }
120 
121     function rescueTokens(address tokenAddress, address receiver, uint256 amount) external onlyOwner {
122         IERC20 _token = IERC20(tokenAddress);
123         require(receiver != address(0));
124         uint256 balance = _token.balanceOf(address(this));
125         require(balance >= amount);
126 
127         assert(_token.transfer(receiver, amount));
128     }
129 
130 
131     function withdrawEther(address payable to, uint256 amount) external onlyOwner {
132         require(to != address(0));
133         uint256 balance = address(this).balance;
134         require(balance >= amount);
135 
136         to.transfer(amount);
137     }
138 }
139 
140 
141 
142 contract Pausable is Ownable {
143     bool private _paused;
144 
145     event Paused(address account);
146     event Unpaused(address account);
147 
148     constructor () internal {
149         _paused = false;
150     }
151 
152     function paused() public view returns (bool) {
153         return _paused;
154     }
155 
156     modifier whenNotPaused() {
157         require(!_paused, "Paused.");
158         _;
159     }
160 
161     function setPaused(bool state) external onlyOwner {
162         if (_paused && !state) {
163             _paused = false;
164             emit Unpaused(msg.sender);
165         } else if (!_paused && state) {
166             _paused = true;
167             emit Paused(msg.sender);
168         }
169     }
170 }
171 
172 
173 interface IERC20 {
174     function balanceOf(address owner) external view returns (uint256);
175     function transfer(address to, uint256 value) external returns (bool);
176 }
177 
178 
179 interface IToken {
180     function balanceOf(address owner) external view returns (uint256);
181     function transfer(address to, uint256 value) external returns (bool);
182     function inWhitelist(address account) external view returns (bool);
183     function referrer(address account) external view returns (address);
184     function refCount(address account) external view returns (uint256);
185 }
186 
187 
188 contract TokenPublicSale is Ownable, Pausable{
189     using SafeMath16 for uint16;
190     using SafeMath256 for uint256;
191 
192     IToken public TOKEN = IToken(0x13bB73376c18faB89Dd5143D50BeF64d9D865200);
193 
194     // Start timestamp
195     uint32 _startTimestamp;
196 
197     // Audit ether price
198     uint256 private _etherPrice;    // 1 Ether = xx.xxxxxx USD, with 6 decimals
199 
200     // Referral rewards, 35% for 15 levels
201     uint16 private WHITELIST_REF_REWARDS_PCT_SUM = 35;
202     uint16[15] private WHITELIST_REF_REWARDS_PCT = [
203     6,  // 6% for Level.1
204     6,  // 6% for Level.2
205     5,  // 5% for Level.3
206     4,  // 4% for Level.4
207     3,  // 3% for Level.5
208     2,  // 2% for Level.6
209     1,  // 1% for Level.7
210     1,  // 1% for Level.8
211     1,  // 1% for Level.9
212     1,  // 1% for Level.10
213     1,  // 1% for Level.11
214     1,  // 1% for Level.12
215     1,  // 1% for Level.13
216     1,  // 1% for Level.14
217     1   // 1% for Level.15
218     ];
219 
220     // Wei & Gas
221     uint72 private WEI_MIN   = 0.1 ether;      // 0.1 Ether Minimum
222     uint72 private WEI_MAX   = 10 ether;       // 10 Ether Maximum
223     uint72 private WEI_BONUS = 10 ether;       // >10 Ether for Bonus
224     uint24 private GAS_MIN   = 3000000;        // 3.0 Mwei gas Mininum
225     uint24 private GAS_EX    = 1500000;        // 1.5 Mwei gas for ex
226 
227     // Price
228     uint256 private TOKEN_USD_PRICE_START = 1000;           // $      0.00100 USD
229     uint256 private TOKEN_USD_PRICE_STEP  = 10;             // $    + 0.00001 USD
230     uint256 private STAGE_USD_CAP_START   = 100000000;      // $    100 USD
231     uint256 private STAGE_USD_CAP_STEP    = 1000000;        // $     +1 USD
232     uint256 private STAGE_USD_CAP_MAX     = 15100000000;    // $    15,100 USD
233 
234     uint256 private _tokenUsdPrice        = TOKEN_USD_PRICE_START;
235 
236     // Progress
237     uint16 private STAGE_MAX = 60000;   // 60,000 stages total
238     uint16 private SEASON_MAX = 100;    // 100 seasons total
239     uint16 private SEASON_STAGES = 600; // each 600 stages is a season
240 
241     uint16 private _stage;
242     uint16 private _season;
243 
244     // Sum
245     uint256 private _txs;
246     uint256 private _tokenTxs;
247     uint256 private _tokenBonusTxs;
248     uint256 private _tokenWhitelistTxs;
249     uint256 private _tokenIssued;
250     uint256 private _tokenBonus;
251     uint256 private _tokenWhitelist;
252     uint256 private _weiSold;
253     uint256 private _weiRefRewarded;
254     uint256 private _weiTopSales;
255     uint256 private _weiTeam;
256     uint256 private _weiPending;
257     uint256 private _weiPendingTransfered;
258 
259     // Top-Sales
260     uint256 private TOP_SALES_RATIO_START = 15000000;         // 15%, with 8 decimals
261     uint256 private TOP_SALES_RATIO_DISTANCE = 50000000;      // 50%, with 8 decimals
262 
263     uint256 private _topSalesRatio = TOP_SALES_RATIO_START;   // 15% + 50% x(_stage/_stageMax)
264 
265     // During tx
266     bool private _inWhitelist_;
267     uint256 private _pending_ = WHITELIST_REF_REWARDS_PCT_SUM;
268     uint16[] private _rewards_;
269     address[] private _referrers_;
270 
271     // Audit ether price auditor
272     mapping (address => bool) private _etherPriceAuditors;
273 
274     // Stage
275     mapping (uint16 => uint256) private _stageUsdSold;
276     mapping (uint16 => uint256) private _stageTokenIssued;
277 
278     // Season
279     mapping (uint16 => uint256) private _seasonWeiSold;
280     mapping (uint16 => uint256) private _seasonWeiTopSales;
281     mapping (uint16 => uint256) private _seasonWeiTopSalesTransfered;
282 
283     // Account
284     mapping (address => uint256) private _accountTokenIssued;
285     mapping (address => uint256) private _accountTokenBonus;
286     mapping (address => uint256) private _accountTokenWhitelisted;
287     mapping (address => uint256) private _accountWeiPurchased;
288     mapping (address => uint256) private _accountWeiRefRewarded;
289 
290     // Ref
291     mapping (uint16 => address[]) private _seasonRefAccounts;
292     mapping (uint16 => mapping (address => bool)) private _seasonHasRefAccount;
293     mapping (uint16 => mapping (address => uint256)) private _usdSeasonAccountPurchased;
294     mapping (uint16 => mapping (address => uint256)) private _usdSeasonAccountRef;
295 
296     // Events
297     event AuditEtherPriceChanged(uint256 value, address indexed account);
298     event AuditEtherPriceAuditorChanged(address indexed account, bool state);
299 
300     event TokenBonusTransfered(address indexed to, uint256 amount);
301     event TokenWhitelistTransfered(address indexed to, uint256 amount);
302     event TokenIssuedTransfered(uint16 stageIndex, address indexed to, uint256 tokenAmount, uint256 auditEtherPrice, uint256 weiUsed);
303 
304     event StageClosed(uint256 _stageNumber, address indexed account);
305     event SeasonClosed(uint16 _seasonNumber, address indexed account);
306 
307     event SeasonTopSalesWeiTransfered(uint16 seasonNumber, address indexed to, uint256 amount);
308     event TeamWeiTransfered(address indexed to, uint256 amount);
309     event PendingWeiTransfered(address indexed to, uint256 amount);
310 
311 
312     function startTimestamp() public view returns (uint32) {
313         return _startTimestamp;
314     }
315 
316     function setStartTimestamp(uint32 timestamp) external onlyOwner {
317         _startTimestamp = timestamp;
318     }
319 
320     modifier onlyEtherPriceAuditor() {
321         require(_etherPriceAuditors[msg.sender]);
322         _;
323     }
324 
325     function setEtherPrice(uint256 value) external onlyEtherPriceAuditor {
326         _etherPrice = value;
327         emit AuditEtherPriceChanged(value, msg.sender);
328     }
329 
330     function etherPriceAuditor(address account) public view returns (bool) {
331         return _etherPriceAuditors[account];
332     }
333 
334     function setEtherPriceAuditor(address account, bool state) external onlyOwner {
335         _etherPriceAuditors[account] = state;
336         emit AuditEtherPriceAuditorChanged(account, state);
337     }
338 
339     function stageTokenUsdPrice(uint16 stageIndex) private view returns (uint256) {
340         return TOKEN_USD_PRICE_START.add(TOKEN_USD_PRICE_STEP.mul(stageIndex));
341     }
342 
343     function wei2usd(uint256 amount) private view returns (uint256) {
344         return amount.mul(_etherPrice).div(1 ether);
345     }
346 
347     function usd2wei(uint256 amount) private view returns (uint256) {
348         return amount.mul(1 ether).div(_etherPrice);
349     }
350 
351     function usd2token(uint256 usdAmount) private view returns (uint256) {
352         return usdAmount.mul(1000000).div(_tokenUsdPrice);
353     }
354 
355     function usd2tokenByStage(uint256 usdAmount, uint16 stageIndex) public view returns (uint256) {
356         return usdAmount.mul(1000000).div(stageTokenUsdPrice(stageIndex));
357     }
358 
359     function calcSeason(uint16 stageIndex) private view returns (uint16) {
360         if (stageIndex > 0) {
361             uint16 __seasonNumber = stageIndex.div(SEASON_STAGES);
362 
363             if (stageIndex.mod(SEASON_STAGES) > 0) {
364                 return __seasonNumber.add(1);
365             }
366 
367             return __seasonNumber;
368         }
369 
370         return 1;
371     }
372 
373 
374     function transferTopSales(uint16 seasonNumber, address payable to) external onlyOwner {
375         uint256 __weiRemain = seasonTopSalesRemain(seasonNumber);
376         require(to != address(0));
377 
378         _seasonWeiTopSalesTransfered[seasonNumber] = _seasonWeiTopSalesTransfered[seasonNumber].add(__weiRemain);
379         emit SeasonTopSalesWeiTransfered(seasonNumber, to, __weiRemain);
380         to.transfer(__weiRemain);
381     }
382 
383     function pendingRemain() private view returns (uint256) {
384         return _weiPending.sub(_weiPendingTransfered);
385     }
386 
387 
388     function transferPending(address payable to) external onlyOwner {
389         uint256 __weiRemain = pendingRemain();
390         require(to != address(0));
391 
392         _weiPendingTransfered = _weiPendingTransfered.add(__weiRemain);
393         emit PendingWeiTransfered(to, __weiRemain);
394         to.transfer(__weiRemain);
395     }
396 
397     function transferTeam(address payable to) external onlyOwner {
398         uint256 __weiRemain = _weiSold.sub(_weiRefRewarded).sub(_weiTopSales).sub(_weiPending).sub(_weiTeam);
399         require(to != address(0));
400 
401         _weiTeam = _weiTeam.add(__weiRemain);
402         emit TeamWeiTransfered(to, __weiRemain);
403         to.transfer(__weiRemain);
404     }
405 
406 
407     function status() public view returns (uint256 auditEtherPrice,
408         uint16 stage,
409         uint16 season,
410         uint256 tokenUsdPrice,
411         uint256 currentTopSalesRatio,
412         uint256 txs,
413         uint256 tokenTxs,
414         uint256 tokenBonusTxs,
415         uint256 tokenWhitelistTxs,
416         uint256 tokenIssued,
417         uint256 tokenBonus,
418         uint256 tokenWhitelist) {
419         auditEtherPrice = _etherPrice;
420 
421         if (_stage > STAGE_MAX) {
422             stage = STAGE_MAX;
423             season = SEASON_MAX;
424         } else {
425             stage = _stage;
426             season = _season;
427         }
428 
429         tokenUsdPrice = _tokenUsdPrice;
430         currentTopSalesRatio = _topSalesRatio;
431 
432         txs = _txs;
433         tokenTxs = _tokenTxs;
434         tokenBonusTxs = _tokenBonusTxs;
435         tokenWhitelistTxs = _tokenWhitelistTxs;
436         tokenIssued = _tokenIssued;
437         tokenBonus = _tokenBonus;
438         tokenWhitelist = _tokenWhitelist;
439     }
440 
441     function sum() public view returns(uint256 weiSold,
442         uint256 weiReferralRewarded,
443         uint256 weiTopSales,
444         uint256 weiTeam,
445         uint256 weiPending,
446         uint256 weiPendingTransfered,
447         uint256 weiPendingRemain) {
448         weiSold = _weiSold;
449         weiReferralRewarded = _weiRefRewarded;
450         weiTopSales = _weiTopSales;
451         weiTeam = _weiTeam;
452         weiPending = _weiPending;
453         weiPendingTransfered = _weiPendingTransfered;
454         weiPendingRemain = pendingRemain();
455     }
456 
457     modifier enoughGas() {
458         require(gasleft() > GAS_MIN);
459         _;
460     }
461 
462     modifier onlyOnSale() {
463         require(_startTimestamp > 0 && now > _startTimestamp, "TM Token Public-Sale has not started yet.");
464         require(_etherPrice > 0,        "Audit ETH price must be greater than zero.");
465         require(!paused(),              "TM Token Public-Sale is paused.");
466         require(_stage <= STAGE_MAX,    "TM Token Public-Sale Closed.");
467         _;
468     }
469 
470 
471     function topSalesRatio(uint16 stageIndex) private view returns (uint256) {
472         return TOP_SALES_RATIO_START.add(TOP_SALES_RATIO_DISTANCE.mul(stageIndex).div(STAGE_MAX));
473     }
474 
475     function usd2weiTopSales(uint256 usdAmount) private view returns (uint256) {
476         return usd2wei(usdAmount.mul(_topSalesRatio).div(100000000));
477     }
478 
479 
480     function stageUsdCap(uint16 stageIndex) private view returns (uint256) {
481         uint256 __usdCap = STAGE_USD_CAP_START.add(STAGE_USD_CAP_STEP.mul(stageIndex));
482 
483         if (__usdCap > STAGE_USD_CAP_MAX) {
484             return STAGE_USD_CAP_MAX;
485         }
486 
487         return __usdCap;
488     }
489 
490 
491     function stageTokenCap(uint16 stageIndex) private view returns (uint256) {
492         return usd2tokenByStage(stageUsdCap(stageIndex), stageIndex);
493     }
494 
495 
496     function stageStatus(uint16 stageIndex) public view returns (uint256 tokenUsdPrice,
497         uint256 tokenCap,
498         uint256 tokenOnSale,
499         uint256 tokenSold,
500         uint256 usdCap,
501         uint256 usdOnSale,
502         uint256 usdSold,
503         uint256 weiTopSalesRatio) {
504         if (stageIndex > STAGE_MAX) {
505             return (0, 0, 0, 0, 0, 0, 0, 0);
506         }
507 
508         tokenUsdPrice = stageTokenUsdPrice(stageIndex);
509 
510         tokenSold = _stageTokenIssued[stageIndex];
511         tokenCap = stageTokenCap(stageIndex);
512         tokenOnSale = tokenCap.sub(tokenSold);
513 
514         usdSold = _stageUsdSold[stageIndex];
515         usdCap = stageUsdCap(stageIndex);
516         usdOnSale = usdCap.sub(usdSold);
517 
518         weiTopSalesRatio = topSalesRatio(stageIndex);
519     }
520 
521     function seasonTopSalesRemain(uint16 seasonNumber) private view returns (uint256) {
522         return _seasonWeiTopSales[seasonNumber].sub(_seasonWeiTopSalesTransfered[seasonNumber]);
523     }
524 
525     function seasonTopSalesRewards(uint16 seasonNumber) public view returns (uint256 weiSold,
526         uint256 weiTopSales,
527         uint256 weiTopSalesTransfered,
528         uint256 weiTopSalesRemain) {
529         weiSold = _seasonWeiSold[seasonNumber];
530         weiTopSales = _seasonWeiTopSales[seasonNumber];
531         weiTopSalesTransfered = _seasonWeiTopSalesTransfered[seasonNumber];
532         weiTopSalesRemain = seasonTopSalesRemain(seasonNumber);
533     }
534 
535     function accountQuery(address account) public view returns (uint256 tokenIssued,
536         uint256 tokenBonus,
537         uint256 tokenWhitelisted,
538         uint256 weiPurchased,
539         uint256 weiReferralRewarded) {
540         tokenIssued = _accountTokenIssued[account];
541         tokenBonus = _accountTokenBonus[account];
542         tokenWhitelisted = _accountTokenWhitelisted[account];
543         weiPurchased = _accountWeiPurchased[account];
544         weiReferralRewarded = _accountWeiRefRewarded[account];
545     }
546 
547     function seasonRefAccounts(uint16 seasonNumber) public view returns (address[] memory accounts) {
548         accounts = _seasonRefAccounts[seasonNumber];
549     }
550 
551     function usdSeasonAccountPurchased(uint16 seasonNumber, address account) public view returns (uint256) {
552         return _usdSeasonAccountPurchased[seasonNumber][account];
553     }
554 
555     function usdSeasonAccountRef(uint16 seasonNumber, address account) public view returns (uint256) {
556         return _usdSeasonAccountRef[seasonNumber][account];
557     }
558 
559     constructor () public {
560         _etherPriceAuditors[msg.sender] = true;
561         _stage = 0;
562         _season = 1;
563     }
564 
565     function () external payable enoughGas onlyOnSale {
566         require(msg.value >= WEI_MIN);
567         require(msg.value <= WEI_MAX);
568 
569         // Set temporary variables.
570         setTemporaryVariables();
571         uint256 __usdAmount = wei2usd(msg.value);
572         uint256 __usdRemain = __usdAmount;
573         uint256 __tokenIssued;
574         uint256 __tokenBonus;
575         uint256 __usdUsed;
576         uint256 __weiUsed;
577 
578         // USD => TM Token
579         while (gasleft() > GAS_EX && __usdRemain > 0 && _stage <= STAGE_MAX) {
580             uint256 __txTokenIssued;
581             (__txTokenIssued, __usdRemain) = ex(__usdRemain);
582             __tokenIssued = __tokenIssued.add(__txTokenIssued);
583         }
584 
585         // Used
586         __usdUsed = __usdAmount.sub(__usdRemain);
587         __weiUsed = usd2wei(__usdUsed);
588 
589         // Bonus 10%
590         if (msg.value >= WEI_BONUS) {
591             __tokenBonus = __tokenIssued.div(10);
592             assert(transferTokenBonus(__tokenBonus));
593         }
594 
595         // Whitelisted
596         // BUY-ONE-AND-GET-ONE-MORE-FREE
597         if (_inWhitelist_ && __tokenIssued > 0) {
598             // both issued and bonus
599             assert(transferTokenWhitelisted(__tokenIssued.add(__tokenBonus)));
600 
601             // 35% for 15 levels
602             sendWhitelistReferralRewards(__weiUsed);
603         }
604 
605         // If wei remains, refund.
606         if (__usdRemain > 0) {
607             uint256 __weiRemain = usd2wei(__usdRemain);
608 
609             __weiUsed = msg.value.sub(__weiRemain);
610 
611             // Refund wei back
612             msg.sender.transfer(__weiRemain);
613         }
614 
615         // Counter
616         if (__weiUsed > 0) {
617             _txs = _txs.add(1);
618             _weiSold = _weiSold.add(__weiUsed);
619             _accountWeiPurchased[msg.sender] = _accountWeiPurchased[msg.sender].add(__weiUsed);
620         }
621 
622         // Wei team
623         uint256 __weiTeam;
624         if (_season > SEASON_MAX)
625             __weiTeam = _weiSold.sub(_weiRefRewarded).sub(_weiTopSales).sub(_weiPending).sub(_weiTeam);
626         else
627             __weiTeam = _weiSold.sub(_weiRefRewarded).sub(_weiTopSales).sub(_weiPending).sub(_weiTeam).div(0.01 ether).mul(0.01 ether);
628 
629         _weiTeam = _weiTeam.add(__weiTeam);
630         _receiver.transfer(__weiTeam);
631 
632         // Assert finished
633         assert(true);
634     }
635 
636     function setTemporaryVariables() private {
637         delete _referrers_;
638         delete _rewards_;
639 
640         _inWhitelist_ = TOKEN.inWhitelist(msg.sender);
641         _pending_ = WHITELIST_REF_REWARDS_PCT_SUM;
642 
643         address __cursor = msg.sender;
644         for(uint16 i = 0; i < WHITELIST_REF_REWARDS_PCT.length; i++) {
645             address __refAccount = TOKEN.referrer(__cursor);
646 
647             if (__cursor == __refAccount)
648                   break;
649 
650             if (TOKEN.refCount(__refAccount) > i) {
651                 if (!_seasonHasRefAccount[_season][__refAccount]) {
652                     _seasonRefAccounts[_season].push(__refAccount);
653                     _seasonHasRefAccount[_season][__refAccount] = true;
654                 }
655 
656                 _pending_ = _pending_.sub(WHITELIST_REF_REWARDS_PCT[i]);
657                 _rewards_.push(WHITELIST_REF_REWARDS_PCT[i]);
658                 _referrers_.push(__refAccount);
659             }
660 
661             __cursor = __refAccount;
662         }
663     }
664 
665     /**
666      *  USD => TM Token
667      */
668     function ex(uint256 usdAmount) private returns (uint256, uint256) {
669         uint256 __stageUsdCap = stageUsdCap(_stage);
670         uint256 __tokenIssued;
671 
672         // in stage
673         if (_stageUsdSold[_stage].add(usdAmount) <= __stageUsdCap) {
674             exCount(usdAmount);
675 
676             __tokenIssued = usd2token(usdAmount);
677             assert(transfertokenIssued(__tokenIssued, usdAmount));
678 
679             // close stage, if stage dollor cap reached
680             if (__stageUsdCap == _stageUsdSold[_stage]) {
681                 assert(closeStage());
682             }
683 
684             return (__tokenIssued, 0);
685         }
686 
687         // close stage
688         uint256 __usdUsed = __stageUsdCap.sub(_stageUsdSold[_stage]);
689         uint256 __usdRemain = usdAmount.sub(__usdUsed);
690 
691         exCount(__usdUsed);
692 
693         __tokenIssued = usd2token(__usdUsed);
694         assert(transfertokenIssued(__tokenIssued, __usdUsed));
695         assert(closeStage());
696 
697         return (__tokenIssued, __usdRemain);
698     }
699 
700     function exCount(uint256 usdAmount) private {
701         uint256 __weiSold = usd2wei(usdAmount);
702         uint256 __weiTopSales = usd2weiTopSales(usdAmount);
703 
704         _usdSeasonAccountPurchased[_season][msg.sender] = _usdSeasonAccountPurchased[_season][msg.sender].add(usdAmount);   // season => address => purchased, in USD
705 
706         _stageUsdSold[_stage] = _stageUsdSold[_stage].add(usdAmount);                   // stage sold, in USD
707         _seasonWeiSold[_season] = _seasonWeiSold[_season].add(__weiSold);               // season sold, in wei
708         _seasonWeiTopSales[_season] = _seasonWeiTopSales[_season].add(__weiTopSales);   // season Top-Sales, in wei
709         _weiTopSales = _weiTopSales.add(__weiTopSales);                                 // sum Top-Sales, in wei
710 
711         // season referral account
712         if (_inWhitelist_) {
713             for (uint16 i = 0; i < _rewards_.length; i++) {
714                 _usdSeasonAccountRef[_season][_referrers_[i]] = _usdSeasonAccountRef[_season][_referrers_[i]].add(usdAmount);
715             }
716         }
717     }
718 
719     function transfertokenIssued(uint256 amount, uint256 usdAmount) private returns (bool) {
720         _tokenTxs = _tokenTxs.add(1);
721 
722         _tokenIssued = _tokenIssued.add(amount);
723         _stageTokenIssued[_stage] = _stageTokenIssued[_stage].add(amount);
724         _accountTokenIssued[msg.sender] = _accountTokenIssued[msg.sender].add(amount);
725 
726         assert(TOKEN.transfer(msg.sender, amount));
727         emit TokenIssuedTransfered(_stage, msg.sender, amount, _etherPrice, usdAmount);
728         return true;
729     }
730 
731     function transferTokenBonus(uint256 amount) private returns (bool) {
732         _tokenBonusTxs = _tokenBonusTxs.add(1);
733 
734         _tokenBonus = _tokenBonus.add(amount);
735         _accountTokenBonus[msg.sender] = _accountTokenBonus[msg.sender].add(amount);
736 
737         assert(TOKEN.transfer(msg.sender, amount));
738         emit TokenBonusTransfered(msg.sender, amount);
739         return true;
740     }
741 
742     function transferTokenWhitelisted(uint256 amount) private returns (bool) {
743         _tokenWhitelistTxs = _tokenWhitelistTxs.add(1);
744 
745         _tokenWhitelist = _tokenWhitelist.add(amount);
746         _accountTokenWhitelisted[msg.sender] = _accountTokenWhitelisted[msg.sender].add(amount);
747 
748         assert(TOKEN.transfer(msg.sender, amount));
749         emit TokenWhitelistTransfered(msg.sender, amount);
750         return true;
751     }
752 
753     function closeStage() private returns (bool) {
754         emit StageClosed(_stage, msg.sender);
755         _stage = _stage.add(1);
756         _tokenUsdPrice = stageTokenUsdPrice(_stage);
757         _topSalesRatio = topSalesRatio(_stage);
758 
759         // Close current season
760         uint16 __seasonNumber = calcSeason(_stage);
761         if (_season < __seasonNumber) {
762             emit SeasonClosed(_season, msg.sender);
763             _season = __seasonNumber;
764         }
765 
766         return true;
767     }
768 
769     function sendWhitelistReferralRewards(uint256 weiAmount) private {
770         uint256 __weiRemain = weiAmount;
771         for (uint16 i = 0; i < _rewards_.length; i++) {
772             uint256 __weiReward = weiAmount.mul(_rewards_[i]).div(100);
773             address payable __receiver = address(uint160(_referrers_[i]));
774 
775             _weiRefRewarded = _weiRefRewarded.add(__weiReward);
776             _accountWeiRefRewarded[__receiver] = _accountWeiRefRewarded[__receiver].add(__weiReward);
777             __weiRemain = __weiRemain.sub(__weiReward);
778 
779             __receiver.transfer(__weiReward);
780         }
781 
782         if (_pending_ > 0)
783             _weiPending = _weiPending.add(weiAmount.mul(_pending_).div(100));
784     }
785 }