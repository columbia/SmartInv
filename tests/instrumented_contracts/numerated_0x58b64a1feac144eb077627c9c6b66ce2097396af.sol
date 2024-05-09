1 pragma solidity 0.5.13;
2 
3 
4 library SafeMath {
5     
6     function add(uint256 a, uint256 b) internal pure returns (uint256) {
7         uint256 c = a + b;
8         require(c >= a, "SafeMath: addition overflow");
9 
10         return c;
11     }
12 
13     
14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15         return sub(a, b, "SafeMath: subtraction overflow");
16     }
17 
18     
19     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
20         require(b <= a, errorMessage);
21         uint256 c = a - b;
22 
23         return c;
24     }
25 
26     
27     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28         
29         
30         
31         if (a == 0) {
32             return 0;
33         }
34 
35         uint256 c = a * b;
36         require(c / a == b, "SafeMath: multiplication overflow");
37 
38         return c;
39     }
40 
41     
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         return div(a, b, "SafeMath: division by zero");
44     }
45 
46     
47     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         
49         require(b > 0, errorMessage);
50         uint256 c = a / b;
51         
52 
53         return c;
54     }
55 
56     
57     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58         return mod(a, b, "SafeMath: modulo by zero");
59     }
60 
61     
62     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b != 0, errorMessage);
64         return a % b;
65     }
66 }
67 
68 contract Context {
69     
70     
71     constructor () internal { }
72     
73 
74     function _msgSender() internal view returns (address payable) {
75         return msg.sender;
76     }
77 
78     function _msgData() internal view returns (bytes memory) {
79         this; 
80         return msg.data;
81     }
82 }
83 
84 contract Ownable is Context {
85     address private _owner;
86 
87     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
88 
89     
90     constructor () internal {
91         _owner = _msgSender();
92         emit OwnershipTransferred(address(0), _owner);
93     }
94 
95     
96     function owner() public view returns (address) {
97         return _owner;
98     }
99 
100     
101     modifier onlyOwner() {
102         require(isOwner(), "Ownable: caller is not the owner");
103         _;
104     }
105 
106     
107     function isOwner() public view returns (bool) {
108         return _msgSender() == _owner;
109     }
110 
111     
112     function renounceOwnership() public onlyOwner {
113         emit OwnershipTransferred(_owner, address(0));
114         _owner = address(0);
115     }
116 
117     
118     function transferOwnership(address newOwner) public onlyOwner {
119         _transferOwnership(newOwner);
120     }
121 
122     
123     function _transferOwnership(address newOwner) internal {
124         require(newOwner != address(0), "Ownable: new owner is the zero address");
125         emit OwnershipTransferred(_owner, newOwner);
126         _owner = newOwner;
127     }
128 }
129 
130 contract ReentrancyGuard {
131     
132     uint256 private _guardCounter;
133 
134     constructor () internal {
135         
136         
137         _guardCounter = 1;
138     }
139 
140     
141     modifier nonReentrant() {
142         _guardCounter += 1;
143         uint256 localCounter = _guardCounter;
144         _;
145         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
146     }
147 }
148 
149 interface IMiniMeToken {
150     function balanceOf(address _owner) external view returns (uint256 balance);
151     function totalSupply() external view returns(uint);
152     function generateTokens(address _owner, uint _amount) external returns (bool);
153     function destroyTokens(address _owner, uint _amount) external returns (bool);
154     function totalSupplyAt(uint _blockNumber) external view returns(uint);
155     function balanceOfAt(address _holder, uint _blockNumber) external view returns (uint);
156     function transferOwnership(address newOwner) external;
157 }
158 
159 contract TokenController {
160   
161   
162   
163   function proxyPayment(address _owner) public payable returns(bool);
164 
165   
166   
167   
168   
169   
170   
171   function onTransfer(address _from, address _to, uint _amount) public returns(bool);
172 
173   
174   
175   
176   
177   
178   
179   function onApprove(address _owner, address _spender, uint _amount) public
180     returns(bool);
181 }
182 
183 interface IERC20 {
184     
185     function totalSupply() external view returns (uint256);
186 
187     
188     function balanceOf(address account) external view returns (uint256);
189 
190     
191     function transfer(address recipient, uint256 amount) external returns (bool);
192 
193     
194     function allowance(address owner, address spender) external view returns (uint256);
195 
196     
197     function approve(address spender, uint256 amount) external returns (bool);
198 
199     
200     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
201 
202     
203     event Transfer(address indexed from, address indexed to, uint256 value);
204 
205     
206     event Approval(address indexed owner, address indexed spender, uint256 value);
207 }
208 
209 contract ERC20Detailed is IERC20 {
210     string private _name;
211     string private _symbol;
212     uint8 private _decimals;
213 
214     
215     constructor (string memory name, string memory symbol, uint8 decimals) public {
216         _name = name;
217         _symbol = symbol;
218         _decimals = decimals;
219     }
220 
221     
222     function name() public view returns (string memory) {
223         return _name;
224     }
225 
226     
227     function symbol() public view returns (string memory) {
228         return _symbol;
229     }
230 
231     
232     function decimals() public view returns (uint8) {
233         return _decimals;
234     }
235 }
236 
237 library Address {
238     
239     function isContract(address account) internal view returns (bool) {
240         
241         
242         
243 
244         
245         
246         
247         bytes32 codehash;
248         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
249         
250         assembly { codehash := extcodehash(account) }
251         return (codehash != 0x0 && codehash != accountHash);
252     }
253 
254     
255     function toPayable(address account) internal pure returns (address payable) {
256         return address(uint160(account));
257     }
258 
259     
260     function sendValue(address payable recipient, uint256 amount) internal {
261         require(address(this).balance >= amount, "Address: insufficient balance");
262 
263         
264         (bool success, ) = recipient.call.value(amount)("");
265         require(success, "Address: unable to send value, recipient may have reverted");
266     }
267 }
268 
269 library SafeERC20 {
270     using SafeMath for uint256;
271     using Address for address;
272 
273     function safeTransfer(IERC20 token, address to, uint256 value) internal {
274         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
275     }
276 
277     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
278         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
279     }
280 
281     function safeApprove(IERC20 token, address spender, uint256 value) internal {
282         
283         
284         
285         
286         require((value == 0) || (token.allowance(address(this), spender) == 0),
287             "SafeERC20: approve from non-zero to non-zero allowance"
288         );
289         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
290     }
291 
292     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
293         uint256 newAllowance = token.allowance(address(this), spender).add(value);
294         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
295     }
296 
297     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
298         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
299         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
300     }
301 
302     
303     function callOptionalReturn(IERC20 token, bytes memory data) private {
304         
305         
306 
307         
308         
309         
310         
311         
312         require(address(token).isContract(), "SafeERC20: call to non-contract");
313 
314         
315         (bool success, bytes memory returndata) = address(token).call(data);
316         require(success, "SafeERC20: low-level call failed");
317 
318         if (returndata.length > 0) { 
319             
320             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
321         }
322     }
323 }
324 
325 interface KyberNetwork {
326   function getExpectedRate(ERC20Detailed src, ERC20Detailed dest, uint srcQty) external view
327       returns (uint expectedRate, uint slippageRate);
328 
329   function tradeWithHint(
330     ERC20Detailed src, uint srcAmount, ERC20Detailed dest, address payable destAddress, uint maxDestAmount,
331     uint minConversionRate, address walletId, bytes calldata hint) external payable returns(uint);
332 }
333 
334 interface Dexag {
335     function approvalHandler() external view returns (address);
336 }
337 
338 contract Utils {
339   using SafeMath for uint256;
340   using SafeERC20 for ERC20Detailed;
341 
342   
343   modifier isValidToken(address _token) {
344     require(_token != address(0));
345     if (_token != address(ETH_TOKEN_ADDRESS)) {
346       require(isContract(_token));
347     }
348     _;
349   }
350 
351   address public DAI_ADDR;
352   address payable public KYBER_ADDR;
353   address payable public DEXAG_ADDR;
354 
355   bytes public constant PERM_HINT = "PERM";
356 
357   ERC20Detailed internal constant ETH_TOKEN_ADDRESS = ERC20Detailed(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
358   ERC20Detailed internal dai;
359   KyberNetwork internal kyber;
360 
361   uint constant internal PRECISION = (10**18);
362   uint constant internal MAX_QTY   = (10**28); 
363   uint constant internal ETH_DECIMALS = 18;
364   uint constant internal MAX_DECIMALS = 18;
365 
366   constructor(
367     address _daiAddr,
368     address payable _kyberAddr,
369     address payable _dexagAddr
370   ) public {
371     DAI_ADDR = _daiAddr;
372     KYBER_ADDR = _kyberAddr;
373     DEXAG_ADDR = _dexagAddr;
374 
375     dai = ERC20Detailed(_daiAddr);
376     kyber = KyberNetwork(_kyberAddr);
377   }
378 
379   
380   function getDecimals(ERC20Detailed _token) internal view returns(uint256) {
381     if (address(_token) == address(ETH_TOKEN_ADDRESS)) {
382       return uint256(ETH_DECIMALS);
383     }
384     return uint256(_token.decimals());
385   }
386 
387   
388   function getBalance(ERC20Detailed _token, address _addr) internal view returns(uint256) {
389     if (address(_token) == address(ETH_TOKEN_ADDRESS)) {
390       return uint256(_addr.balance);
391     }
392     return uint256(_token.balanceOf(_addr));
393   }
394 
395   
396   function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
397         internal pure returns(uint)
398   {
399     require(srcAmount <= MAX_QTY);
400     require(destAmount <= MAX_QTY);
401 
402     if (dstDecimals >= srcDecimals) {
403       require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
404       return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
405     } else {
406       require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
407       return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
408     }
409   }
410 
411   
412   function __kyberTrade(ERC20Detailed _srcToken, uint256 _srcAmount, ERC20Detailed _destToken)
413     internal
414     returns(
415       uint256 _destPriceInSrc,
416       uint256 _srcPriceInDest,
417       uint256 _actualDestAmount,
418       uint256 _actualSrcAmount
419     )
420   {
421     require(_srcToken != _destToken);
422 
423     uint256 beforeSrcBalance = getBalance(_srcToken, address(this));
424     uint256 msgValue;
425     if (_srcToken != ETH_TOKEN_ADDRESS) {
426       msgValue = 0;
427       _srcToken.safeApprove(KYBER_ADDR, 0);
428       _srcToken.safeApprove(KYBER_ADDR, _srcAmount);
429     } else {
430       msgValue = _srcAmount;
431     }
432     _actualDestAmount = kyber.tradeWithHint.value(msgValue)(
433       _srcToken,
434       _srcAmount,
435       _destToken,
436       toPayableAddr(address(this)),
437       MAX_QTY,
438       1,
439       0x332D87209f7c8296389C307eAe170c2440830A47,
440       PERM_HINT
441     );
442     _actualSrcAmount = beforeSrcBalance.sub(getBalance(_srcToken, address(this)));
443     require(_actualDestAmount > 0 && _actualSrcAmount > 0);
444     _destPriceInSrc = calcRateFromQty(_actualDestAmount, _actualSrcAmount, getDecimals(_destToken), getDecimals(_srcToken));
445     _srcPriceInDest = calcRateFromQty(_actualSrcAmount, _actualDestAmount, getDecimals(_srcToken), getDecimals(_destToken));
446   }
447 
448   
449   function __dexagTrade(ERC20Detailed _srcToken, uint256 _srcAmount, ERC20Detailed _destToken, bytes memory _calldata)
450     internal
451     returns(
452       uint256 _destPriceInSrc,
453       uint256 _srcPriceInDest,
454       uint256 _actualDestAmount,
455       uint256 _actualSrcAmount
456     )
457   {
458     require(_srcToken != _destToken);
459 
460     uint256 beforeSrcBalance = getBalance(_srcToken, address(this));
461     uint256 beforeDestBalance = getBalance(_destToken, address(this));
462     
463     if (_srcToken != ETH_TOKEN_ADDRESS) {
464       _actualSrcAmount = 0;
465       Dexag dex = Dexag(DEXAG_ADDR);
466       address approvalHandler = dex.approvalHandler();
467       _srcToken.safeApprove(approvalHandler, 0);
468       _srcToken.safeApprove(approvalHandler, _srcAmount);
469     } else {
470       _actualSrcAmount = _srcAmount;
471     }
472 
473     
474     (bool success,) = DEXAG_ADDR.call.value(_actualSrcAmount)(_calldata);
475     require(success);
476 
477     
478     _actualDestAmount = getBalance(_destToken, address(this)).sub(beforeDestBalance);
479     _actualSrcAmount = beforeSrcBalance.sub(getBalance(_srcToken, address(this)));
480     require(_actualDestAmount > 0 && _actualSrcAmount > 0);
481     _destPriceInSrc = calcRateFromQty(_actualDestAmount, _actualSrcAmount, getDecimals(_destToken), getDecimals(_srcToken));
482     _srcPriceInDest = calcRateFromQty(_actualSrcAmount, _actualDestAmount, getDecimals(_srcToken), getDecimals(_destToken));
483 
484     
485     (, uint256 kyberSrcPriceInDest) = kyber.getExpectedRate(_srcToken, _destToken, _srcAmount);
486     require(kyberSrcPriceInDest > 0 && _srcPriceInDest >= kyberSrcPriceInDest);
487   }
488 
489   
490   function isContract(address _addr) internal view returns(bool) {
491     uint size;
492     if (_addr == address(0)) return false;
493     assembly {
494         size := extcodesize(_addr)
495     }
496     return size>0;
497   }
498 
499   function toPayableAddr(address _addr) internal pure returns (address payable) {
500     return address(uint160(_addr));
501   }
502 }
503 
504 interface BetokenProxyInterface {
505   function betokenFundAddress() external view returns (address payable);
506   function updateBetokenFundAddress() external;
507 }
508 
509 interface ScdMcdMigration {
510   
511   
512   
513   function swapSaiToDai(
514     uint wad
515   ) external;
516 }
517 
518 contract BetokenStorage is Ownable, ReentrancyGuard {
519   using SafeMath for uint256;
520 
521   enum CyclePhase { Intermission, Manage }
522   enum VoteDirection { Empty, For, Against }
523   enum Subchunk { Propose, Vote }
524 
525   struct Investment {
526     address tokenAddress;
527     uint256 cycleNumber;
528     uint256 stake;
529     uint256 tokenAmount;
530     uint256 buyPrice; 
531     uint256 sellPrice; 
532     uint256 buyTime;
533     uint256 buyCostInDAI;
534     bool isSold;
535   }
536 
537   
538   uint256 public constant COMMISSION_RATE = 20 * (10 ** 16); 
539   uint256 public constant ASSET_FEE_RATE = 1 * (10 ** 15); 
540   uint256 public constant NEXT_PHASE_REWARD = 1 * (10 ** 18); 
541   uint256 public constant MAX_BUY_KRO_PROP = 1 * (10 ** 16); 
542   uint256 public constant FALLBACK_MAX_DONATION = 100 * (10 ** 18); 
543   uint256 public constant MIN_KRO_PRICE = 25 * (10 ** 17); 
544   uint256 public constant COLLATERAL_RATIO_MODIFIER = 75 * (10 ** 16); 
545   uint256 public constant MIN_RISK_TIME = 3 days; 
546   uint256 public constant INACTIVE_THRESHOLD = 2; 
547   uint256 public constant ROI_PUNISH_THRESHOLD = 1 * (10 ** 17); 
548   uint256 public constant ROI_BURN_THRESHOLD = 25 * (10 ** 16); 
549   uint256 public constant ROI_PUNISH_SLOPE = 6; 
550   uint256 public constant ROI_PUNISH_NEG_BIAS = 5 * (10 ** 17); 
551   
552   uint256 public constant CHUNK_SIZE = 3 days;
553   uint256 public constant PROPOSE_SUBCHUNK_SIZE = 1 days;
554   uint256 public constant CYCLES_TILL_MATURITY = 3;
555   uint256 public constant QUORUM = 10 * (10 ** 16); 
556   uint256 public constant VOTE_SUCCESS_THRESHOLD = 75 * (10 ** 16); 
557 
558   
559 
560   
561   bool public hasInitializedTokenListings;
562 
563   
564   bool public isInitialized;
565 
566   
567   address public controlTokenAddr;
568 
569   
570   address public shareTokenAddr;
571 
572   
573   address payable public proxyAddr;
574 
575   
576   address public compoundFactoryAddr;
577 
578   
579   address public betokenLogic;
580   address public betokenLogic2;
581 
582   
583   address payable public devFundingAccount;
584 
585   
586   address payable public previousVersion;
587 
588   
589   address public saiAddr;
590 
591   
592   uint256 public cycleNumber;
593 
594   
595   uint256 public totalFundsInDAI;
596 
597   
598   uint256 public startTimeOfCyclePhase;
599 
600   
601   uint256 public devFundingRate;
602 
603   
604   uint256 public totalCommissionLeft;
605 
606   
607   uint256[2] public phaseLengths;
608 
609   
610   mapping(address => uint256) internal _lastCommissionRedemption;
611 
612   
613   mapping(address => mapping(uint256 => bool)) internal _hasRedeemedCommissionForCycle;
614 
615   
616   mapping(address => mapping(uint256 => uint256)) internal _riskTakenInCycle;
617 
618   
619   mapping(address => uint256) internal _baseRiskStakeFallback;
620 
621   
622   mapping(address => Investment[]) public userInvestments;
623 
624   
625   mapping(address => address payable[]) public userCompoundOrders;
626 
627   
628   mapping(uint256 => uint256) internal _totalCommissionOfCycle;
629 
630   
631   mapping(uint256 => uint256) internal _managePhaseEndBlock;
632 
633   
634   mapping(address => uint256) internal _lastActiveCycle;
635 
636   
637   mapping(address => bool) public isKyberToken;
638 
639   
640   mapping(address => bool) public isCompoundToken;
641 
642   
643   mapping(address => bool) public isPositionToken;
644 
645   
646   CyclePhase public cyclePhase;
647 
648   
649   bool public hasFinalizedNextVersion; 
650   bool public upgradeVotingActive; 
651   address payable public nextVersion; 
652   address[5] public proposers; 
653   address payable[5] public candidates; 
654   uint256[5] public forVotes; 
655   uint256[5] public againstVotes; 
656   uint256 public proposersVotingWeight; 
657   mapping(uint256 => mapping(address => VoteDirection[5])) public managerVotes; 
658   mapping(uint256 => uint256) public upgradeSignalStrength; 
659   mapping(uint256 => mapping(address => bool)) public upgradeSignal; 
660 
661   
662   IMiniMeToken internal cToken;
663   IMiniMeToken internal sToken;
664   BetokenProxyInterface internal proxy;
665   ScdMcdMigration internal mcdaiMigration;
666 
667   
668 
669   event ChangedPhase(uint256 indexed _cycleNumber, uint256 indexed _newPhase, uint256 _timestamp, uint256 _totalFundsInDAI);
670 
671   event Deposit(uint256 indexed _cycleNumber, address indexed _sender, address _tokenAddress, uint256 _tokenAmount, uint256 _daiAmount, uint256 _timestamp);
672   event Withdraw(uint256 indexed _cycleNumber, address indexed _sender, address _tokenAddress, uint256 _tokenAmount, uint256 _daiAmount, uint256 _timestamp);
673 
674   event CreatedInvestment(uint256 indexed _cycleNumber, address indexed _sender, uint256 _id, address _tokenAddress, uint256 _stakeInWeis, uint256 _buyPrice, uint256 _costDAIAmount, uint256 _tokenAmount);
675   event SoldInvestment(uint256 indexed _cycleNumber, address indexed _sender, uint256 _id, address _tokenAddress, uint256 _receivedKairo, uint256 _sellPrice, uint256 _earnedDAIAmount);
676 
677   event CreatedCompoundOrder(uint256 indexed _cycleNumber, address indexed _sender, uint256 _id, address _order, bool _orderType, address _tokenAddress, uint256 _stakeInWeis, uint256 _costDAIAmount);
678   event SoldCompoundOrder(uint256 indexed _cycleNumber, address indexed _sender, uint256 _id, address _order,  bool _orderType, address _tokenAddress, uint256 _receivedKairo, uint256 _earnedDAIAmount);
679   event RepaidCompoundOrder(uint256 indexed _cycleNumber, address indexed _sender, uint256 _id, address _order, uint256 _repaidDAIAmount);
680 
681   event CommissionPaid(uint256 indexed _cycleNumber, address indexed _sender, uint256 _commission);
682   event TotalCommissionPaid(uint256 indexed _cycleNumber, uint256 _totalCommissionInDAI);
683 
684   event Register(address indexed _manager, uint256 _donationInDAI, uint256 _kairoReceived);
685 
686   event SignaledUpgrade(uint256 indexed _cycleNumber, address indexed _sender, bool indexed _inSupport);
687   event DeveloperInitiatedUpgrade(uint256 indexed _cycleNumber, address _candidate);
688   event InitiatedUpgrade(uint256 indexed _cycleNumber);
689   event ProposedCandidate(uint256 indexed _cycleNumber, uint256 indexed _voteID, address indexed _sender, address _candidate);
690   event Voted(uint256 indexed _cycleNumber, uint256 indexed _voteID, address indexed _sender, bool _inSupport, uint256 _weight);
691   event FinalizedNextVersion(uint256 indexed _cycleNumber, address _nextVersion);
692 
693   
694 
695   
696   function currentChunk() public view returns (uint) {
697     if (cyclePhase != CyclePhase.Manage) {
698       return 0;
699     }
700     return (now - startTimeOfCyclePhase) / CHUNK_SIZE;
701   }
702 
703   
704   function currentSubchunk() public view returns (Subchunk _subchunk) {
705     if (cyclePhase != CyclePhase.Manage) {
706       return Subchunk.Vote;
707     }
708     uint256 timeIntoCurrChunk = (now - startTimeOfCyclePhase) % CHUNK_SIZE;
709     return timeIntoCurrChunk < PROPOSE_SUBCHUNK_SIZE ? Subchunk.Propose : Subchunk.Vote;
710   }
711 
712   
713   function getVotingWeight(address _of) public view returns (uint256 _weight) {
714     if (cycleNumber <= CYCLES_TILL_MATURITY || _of == address(0)) {
715       return 0;
716     }
717     return cToken.balanceOfAt(_of, managePhaseEndBlock(cycleNumber.sub(CYCLES_TILL_MATURITY)));
718   }
719 
720   
721   function getTotalVotingWeight() public view returns (uint256 _weight) {
722     if (cycleNumber <= CYCLES_TILL_MATURITY) {
723       return 0;
724     }
725     return cToken.totalSupplyAt(managePhaseEndBlock(cycleNumber.sub(CYCLES_TILL_MATURITY))).sub(proposersVotingWeight);
726   }
727 
728   
729   function kairoPrice() public view returns (uint256 _kairoPrice) {
730     if (cToken.totalSupply() == 0) { return MIN_KRO_PRICE; }
731     uint256 controlPerKairo = totalFundsInDAI.mul(10 ** 18).div(cToken.totalSupply());
732     if (controlPerKairo < MIN_KRO_PRICE) {
733       
734       return MIN_KRO_PRICE;
735     }
736     return controlPerKairo;
737   }
738 
739   function lastCommissionRedemption(address _manager) public view returns (uint256) {
740     if (_lastCommissionRedemption[_manager] == 0) {
741       return previousVersion == address(0) ? 0 : BetokenStorage(previousVersion).lastCommissionRedemption(_manager);
742     }
743     return _lastCommissionRedemption[_manager];
744   }
745 
746   function hasRedeemedCommissionForCycle(address _manager, uint256 _cycle) public view returns (bool) {
747     if (_hasRedeemedCommissionForCycle[_manager][_cycle] == false) {
748       return previousVersion == address(0) ? false : BetokenStorage(previousVersion).hasRedeemedCommissionForCycle(_manager, _cycle);
749     }
750     return _hasRedeemedCommissionForCycle[_manager][_cycle];
751   }
752 
753   function riskTakenInCycle(address _manager, uint256 _cycle) public view returns (uint256) {
754     if (_riskTakenInCycle[_manager][_cycle] == 0) {
755       return previousVersion == address(0) ? 0 : BetokenStorage(previousVersion).riskTakenInCycle(_manager, _cycle);
756     }
757     return _riskTakenInCycle[_manager][_cycle];
758   }
759 
760   function baseRiskStakeFallback(address _manager) public view returns (uint256) {
761     if (_baseRiskStakeFallback[_manager] == 0) {
762       return previousVersion == address(0) ? 0 : BetokenStorage(previousVersion).baseRiskStakeFallback(_manager);
763     }
764     return _baseRiskStakeFallback[_manager];
765   }
766 
767   function totalCommissionOfCycle(uint256 _cycle) public view returns (uint256) {
768     if (_totalCommissionOfCycle[_cycle] == 0) {
769       return previousVersion == address(0) ? 0 : BetokenStorage(previousVersion).totalCommissionOfCycle(_cycle);
770     }
771     return _totalCommissionOfCycle[_cycle];
772   }
773 
774   function managePhaseEndBlock(uint256 _cycle) public view returns (uint256) {
775     if (_managePhaseEndBlock[_cycle] == 0) {
776       return previousVersion == address(0) ? 0 : BetokenStorage(previousVersion).managePhaseEndBlock(_cycle);
777     }
778     return _managePhaseEndBlock[_cycle];
779   }
780 
781   function lastActiveCycle(address _manager) public view returns (uint256) {
782     if (_lastActiveCycle[_manager] == 0) {
783       return previousVersion == address(0) ? 0 : BetokenStorage(previousVersion).lastActiveCycle(_manager);
784     }
785     return _lastActiveCycle[_manager];
786   }
787 }
788 
789 interface Comptroller {
790     function enterMarkets(address[] calldata cTokens) external returns (uint[] memory);
791     function markets(address cToken) external view returns (bool isListed, uint256 collateralFactorMantissa);
792 }
793 
794 interface PriceOracle {
795   function getUnderlyingPrice(address cToken) external view returns (uint);
796 }
797 
798 interface CERC20 {
799   function mint(uint mintAmount) external returns (uint);
800   function redeemUnderlying(uint redeemAmount) external returns (uint);
801   function borrow(uint borrowAmount) external returns (uint);
802   function repayBorrow(uint repayAmount) external returns (uint);
803   function borrowBalanceCurrent(address account) external returns (uint);
804   function exchangeRateCurrent() external returns (uint);
805 
806   function balanceOf(address account) external view returns (uint);
807   function decimals() external view returns (uint);
808   function underlying() external view returns (address);
809 }
810 
811 interface CEther {
812   function mint() external payable;
813   function redeemUnderlying(uint redeemAmount) external returns (uint);
814   function borrow(uint borrowAmount) external returns (uint);
815   function repayBorrow() external payable;
816   function borrowBalanceCurrent(address account) external returns (uint);
817   function exchangeRateCurrent() external returns (uint);
818 
819   function balanceOf(address account) external view returns (uint);
820   function decimals() external view returns (uint);
821 }
822 
823 contract CompoundOrder is Utils(address(0), address(0), address(0)), Ownable {
824   
825   uint256 internal constant NEGLIGIBLE_DEBT = 10 ** 14; 
826   uint256 internal constant MAX_REPAY_STEPS = 3; 
827   uint256 internal constant DEFAULT_LIQUIDITY_SLIPPAGE = 10 ** 12; 
828   uint256 internal constant FALLBACK_LIQUIDITY_SLIPPAGE = 10 ** 15; 
829   uint256 internal constant MAX_LIQUIDITY_SLIPPAGE = 10 ** 17; 
830 
831   
832   Comptroller public COMPTROLLER; 
833   PriceOracle public ORACLE; 
834   CERC20 public CDAI; 
835   address public CETH_ADDR;
836 
837   
838   uint256 public stake;
839   uint256 public collateralAmountInDAI;
840   uint256 public loanAmountInDAI;
841   uint256 public cycleNumber;
842   uint256 public buyTime; 
843   uint256 public outputAmount; 
844   address public compoundTokenAddr;
845   bool public isSold;
846   bool public orderType; 
847   bool internal initialized;
848 
849 
850   constructor() public {}
851 
852   function init(
853     address _compoundTokenAddr,
854     uint256 _cycleNumber,
855     uint256 _stake,
856     uint256 _collateralAmountInDAI,
857     uint256 _loanAmountInDAI,
858     bool _orderType,
859     address _daiAddr,
860     address payable _kyberAddr,
861     address _comptrollerAddr,
862     address _priceOracleAddr,
863     address _cDAIAddr,
864     address _cETHAddr
865   ) public {
866     require(!initialized);
867     initialized = true;
868     
869     
870     require(_compoundTokenAddr != _cDAIAddr);
871     require(_stake > 0 && _collateralAmountInDAI > 0 && _loanAmountInDAI > 0); 
872     stake = _stake;
873     collateralAmountInDAI = _collateralAmountInDAI;
874     loanAmountInDAI = _loanAmountInDAI;
875     cycleNumber = _cycleNumber;
876     compoundTokenAddr = _compoundTokenAddr;
877     orderType = _orderType;
878 
879     COMPTROLLER = Comptroller(_comptrollerAddr);
880     ORACLE = PriceOracle(_priceOracleAddr);
881     CDAI = CERC20(_cDAIAddr);
882     CETH_ADDR = _cETHAddr;
883     DAI_ADDR = _daiAddr;
884     KYBER_ADDR = _kyberAddr;
885     dai = ERC20Detailed(_daiAddr);
886     kyber = KyberNetwork(_kyberAddr);
887 
888     
889     _transferOwnership(msg.sender);
890   }
891 
892   
893   function executeOrder(uint256 _minPrice, uint256 _maxPrice) public;
894 
895   
896   function sellOrder(uint256 _minPrice, uint256 _maxPrice) public returns (uint256 _inputAmount, uint256 _outputAmount);
897 
898   
899   function repayLoan(uint256 _repayAmountInDAI) public;
900 
901   function getMarketCollateralFactor() public view returns (uint256);
902 
903   function getCurrentCollateralInDAI() public returns (uint256 _amount);
904 
905   function getCurrentBorrowInDAI() public returns (uint256 _amount);
906 
907   function getCurrentCashInDAI() public view returns (uint256 _amount);
908 
909   
910   function getCurrentProfitInDAI() public returns (bool _isNegative, uint256 _amount) {
911     uint256 l;
912     uint256 r;
913     if (isSold) {
914       l = outputAmount;
915       r = collateralAmountInDAI;
916     } else {
917       uint256 cash = getCurrentCashInDAI();
918       uint256 supply = getCurrentCollateralInDAI();
919       uint256 borrow = getCurrentBorrowInDAI();
920       if (cash >= borrow) {
921         l = supply.add(cash);
922         r = borrow.add(collateralAmountInDAI);
923       } else {
924         l = supply;
925         r = borrow.sub(cash).mul(PRECISION).div(getMarketCollateralFactor()).add(collateralAmountInDAI);
926       }
927     }
928     
929     if (l >= r) {
930       return (false, l.sub(r));
931     } else {
932       return (true, r.sub(l));
933     }
934   }
935 
936   
937   function getCurrentCollateralRatioInDAI() public returns (uint256 _amount) {
938     uint256 supply = getCurrentCollateralInDAI();
939     uint256 borrow = getCurrentBorrowInDAI();
940     if (borrow == 0) {
941       return uint256(-1);
942     }
943     return supply.mul(PRECISION).div(borrow);
944   }
945 
946   
947   function getCurrentLiquidityInDAI() public returns (bool _isNegative, uint256 _amount) {
948     uint256 supply = getCurrentCollateralInDAI();
949     uint256 borrow = getCurrentBorrowInDAI().mul(PRECISION).div(getMarketCollateralFactor());
950     if (supply >= borrow) {
951       return (false, supply.sub(borrow));
952     } else {
953       return (true, borrow.sub(supply));
954     }
955   }
956 
957   function __sellDAIForToken(uint256 _daiAmount) internal returns (uint256 _actualDAIAmount, uint256 _actualTokenAmount) {
958     ERC20Detailed t = __underlyingToken(compoundTokenAddr);
959     (,, _actualTokenAmount, _actualDAIAmount) = __kyberTrade(dai, _daiAmount, t); 
960     require(_actualDAIAmount > 0 && _actualTokenAmount > 0); 
961   }
962 
963   function __sellTokenForDAI(uint256 _tokenAmount) internal returns (uint256 _actualDAIAmount, uint256 _actualTokenAmount) {
964     ERC20Detailed t = __underlyingToken(compoundTokenAddr);
965     (,, _actualDAIAmount, _actualTokenAmount) = __kyberTrade(t, _tokenAmount, dai); 
966     require(_actualDAIAmount > 0 && _actualTokenAmount > 0); 
967   }
968 
969   
970   function __daiToToken(address _cToken, uint256 _daiAmount) internal view returns (uint256) {
971     if (_cToken == CETH_ADDR) {
972       
973       return _daiAmount.mul(ORACLE.getUnderlyingPrice(address(CDAI))).div(PRECISION);
974     }
975     ERC20Detailed t = __underlyingToken(_cToken);
976     return _daiAmount.mul(ORACLE.getUnderlyingPrice(address(CDAI))).mul(10 ** getDecimals(t)).div(ORACLE.getUnderlyingPrice(_cToken).mul(PRECISION));
977   }
978 
979   
980   function __tokenToDAI(address _cToken, uint256 _tokenAmount) internal view returns (uint256) {
981     if (_cToken == CETH_ADDR) {
982       
983       return _tokenAmount.mul(PRECISION).div(ORACLE.getUnderlyingPrice(address(CDAI)));
984     }
985     ERC20Detailed t = __underlyingToken(_cToken);
986     return _tokenAmount.mul(ORACLE.getUnderlyingPrice(_cToken)).mul(PRECISION).div(ORACLE.getUnderlyingPrice(address(CDAI)).mul(10 ** uint256(t.decimals())));
987   }
988 
989   function __underlyingToken(address _cToken) internal view returns (ERC20Detailed) {
990     if (_cToken == CETH_ADDR) {
991       
992       return ETH_TOKEN_ADDRESS;
993     }
994     CERC20 ct = CERC20(_cToken);
995     address underlyingToken = ct.underlying();
996     ERC20Detailed t = ERC20Detailed(underlyingToken);
997     return t;
998   }
999 
1000   function() external payable {}
1001 }
1002 
1003 contract LongCERC20Order is CompoundOrder {
1004   modifier isValidPrice(uint256 _minPrice, uint256 _maxPrice) {
1005     
1006     uint256 tokenPrice = ORACLE.getUnderlyingPrice(compoundTokenAddr); 
1007     require(tokenPrice > 0); 
1008     tokenPrice = __tokenToDAI(CETH_ADDR, tokenPrice); 
1009     require(tokenPrice >= _minPrice && tokenPrice <= _maxPrice); 
1010     _;
1011   }
1012 
1013   function executeOrder(uint256 _minPrice, uint256 _maxPrice)
1014     public
1015     onlyOwner
1016     isValidToken(compoundTokenAddr)
1017     isValidPrice(_minPrice, _maxPrice)
1018   {
1019     buyTime = now;
1020 
1021     
1022     dai.safeTransferFrom(owner(), address(this), collateralAmountInDAI); 
1023 
1024     
1025     (,uint256 actualTokenAmount) = __sellDAIForToken(collateralAmountInDAI);
1026 
1027     
1028     CERC20 market = CERC20(compoundTokenAddr);
1029     address[] memory markets = new address[](2);
1030     markets[0] = compoundTokenAddr;
1031     markets[1] = address(CDAI);
1032     uint[] memory errors = COMPTROLLER.enterMarkets(markets);
1033     require(errors[0] == 0 && errors[1] == 0);
1034 
1035     
1036     ERC20Detailed token = __underlyingToken(compoundTokenAddr);
1037     token.safeApprove(compoundTokenAddr, 0); 
1038     token.safeApprove(compoundTokenAddr, actualTokenAmount); 
1039     require(market.mint(actualTokenAmount) == 0); 
1040     token.safeApprove(compoundTokenAddr, 0); 
1041     require(CDAI.borrow(loanAmountInDAI) == 0);
1042     (bool negLiquidity, ) = getCurrentLiquidityInDAI();
1043     require(!negLiquidity); 
1044 
1045     
1046     __sellDAIForToken(loanAmountInDAI);
1047 
1048     
1049     if (dai.balanceOf(address(this)) > 0) {
1050       uint256 repayAmount = dai.balanceOf(address(this));
1051       dai.safeApprove(address(CDAI), 0);
1052       dai.safeApprove(address(CDAI), repayAmount);
1053       require(CDAI.repayBorrow(repayAmount) == 0);
1054       dai.safeApprove(address(CDAI), 0);
1055     }
1056   }
1057 
1058   function sellOrder(uint256 _minPrice, uint256 _maxPrice)
1059     public
1060     onlyOwner
1061     isValidPrice(_minPrice, _maxPrice)
1062     returns (uint256 _inputAmount, uint256 _outputAmount)
1063   {
1064     require(buyTime > 0); 
1065     require(isSold == false);
1066     isSold = true;
1067     
1068     
1069     
1070     CERC20 market = CERC20(compoundTokenAddr);
1071     ERC20Detailed token = __underlyingToken(compoundTokenAddr);
1072     for (uint256 i = 0; i < MAX_REPAY_STEPS; i = i.add(1)) {
1073       uint256 currentDebt = getCurrentBorrowInDAI();
1074       if (currentDebt > NEGLIGIBLE_DEBT) {
1075         
1076         uint256 currentBalance = getCurrentCashInDAI();
1077         uint256 repayAmount = 0; 
1078         if (currentDebt <= currentBalance) {
1079           
1080           repayAmount = currentDebt;
1081         } else {
1082           
1083           repayAmount = currentBalance;
1084         }
1085 
1086         
1087         repayLoan(repayAmount);
1088       }
1089 
1090       
1091       (bool isNeg, uint256 liquidity) = getCurrentLiquidityInDAI();
1092       if (!isNeg) {
1093         liquidity = __daiToToken(compoundTokenAddr, liquidity);
1094         uint256 errorCode = market.redeemUnderlying(liquidity.mul(PRECISION.sub(DEFAULT_LIQUIDITY_SLIPPAGE)).div(PRECISION));
1095         if (errorCode != 0) {
1096           
1097           
1098           errorCode = market.redeemUnderlying(liquidity.mul(PRECISION.sub(FALLBACK_LIQUIDITY_SLIPPAGE)).div(PRECISION));
1099           if (errorCode != 0) {
1100             
1101             
1102             market.redeemUnderlying(liquidity.mul(PRECISION.sub(MAX_LIQUIDITY_SLIPPAGE)).div(PRECISION));
1103           }
1104         }
1105       }
1106 
1107       if (currentDebt <= NEGLIGIBLE_DEBT) {
1108         break;
1109       }
1110     }
1111 
1112     
1113     __sellTokenForDAI(token.balanceOf(address(this)));
1114 
1115     
1116     _inputAmount = collateralAmountInDAI;
1117     _outputAmount = dai.balanceOf(address(this));
1118     outputAmount = _outputAmount;
1119     dai.safeTransfer(owner(), dai.balanceOf(address(this)));
1120     uint256 leftoverTokens = token.balanceOf(address(this));
1121     if (leftoverTokens > 0) {
1122       token.safeTransfer(owner(), leftoverTokens); 
1123     }
1124   }
1125 
1126   
1127   function repayLoan(uint256 _repayAmountInDAI) public onlyOwner {
1128     require(buyTime > 0); 
1129 
1130     
1131     uint256 repayAmountInToken = __daiToToken(compoundTokenAddr, _repayAmountInDAI);
1132     (uint256 actualDAIAmount,) = __sellTokenForDAI(repayAmountInToken);
1133     
1134     
1135     uint256 currentDebt = CDAI.borrowBalanceCurrent(address(this));
1136     if (actualDAIAmount > currentDebt) {
1137       actualDAIAmount = currentDebt;
1138     }
1139     
1140     
1141     dai.safeApprove(address(CDAI), 0);
1142     dai.safeApprove(address(CDAI), actualDAIAmount);
1143     require(CDAI.repayBorrow(actualDAIAmount) == 0);
1144     dai.safeApprove(address(CDAI), 0);
1145   }
1146 
1147   function getMarketCollateralFactor() public view returns (uint256) {
1148     (, uint256 ratio) = COMPTROLLER.markets(address(compoundTokenAddr));
1149     return ratio;
1150   }
1151 
1152   function getCurrentCollateralInDAI() public returns (uint256 _amount) {
1153     CERC20 market = CERC20(compoundTokenAddr);
1154     uint256 supply = __tokenToDAI(compoundTokenAddr, market.balanceOf(address(this)).mul(market.exchangeRateCurrent()).div(PRECISION));
1155     return supply;
1156   }
1157 
1158   function getCurrentBorrowInDAI() public returns (uint256 _amount) {
1159     uint256 borrow = CDAI.borrowBalanceCurrent(address(this));
1160     return borrow;
1161   }
1162 
1163   function getCurrentCashInDAI() public view returns (uint256 _amount) {
1164     ERC20Detailed token = __underlyingToken(compoundTokenAddr);
1165     uint256 cash = __tokenToDAI(compoundTokenAddr, getBalance(token, address(this)));
1166     return cash;
1167   }
1168 }
1169 
1170 contract LongCEtherOrder is CompoundOrder {
1171   modifier isValidPrice(uint256 _minPrice, uint256 _maxPrice) {
1172     
1173     uint256 tokenPrice = PRECISION; 
1174     tokenPrice = __tokenToDAI(CETH_ADDR, tokenPrice); 
1175     require(tokenPrice >= _minPrice && tokenPrice <= _maxPrice); 
1176     _;
1177   }
1178 
1179   function executeOrder(uint256 _minPrice, uint256 _maxPrice)
1180     public
1181     onlyOwner
1182     isValidToken(compoundTokenAddr)
1183     isValidPrice(_minPrice, _maxPrice)
1184   {
1185     buyTime = now;
1186     
1187     
1188     dai.safeTransferFrom(owner(), address(this), collateralAmountInDAI); 
1189 
1190     
1191     (,uint256 actualTokenAmount) = __sellDAIForToken(collateralAmountInDAI);
1192 
1193     
1194     CEther market = CEther(compoundTokenAddr);
1195     address[] memory markets = new address[](2);
1196     markets[0] = compoundTokenAddr;
1197     markets[1] = address(CDAI);
1198     uint[] memory errors = COMPTROLLER.enterMarkets(markets);
1199     require(errors[0] == 0 && errors[1] == 0);
1200     
1201     
1202     market.mint.value(actualTokenAmount)(); 
1203     require(CDAI.borrow(loanAmountInDAI) == 0);
1204     (bool negLiquidity, ) = getCurrentLiquidityInDAI();
1205     require(!negLiquidity); 
1206 
1207     
1208     __sellDAIForToken(loanAmountInDAI);
1209 
1210     
1211     if (dai.balanceOf(address(this)) > 0) {
1212       uint256 repayAmount = dai.balanceOf(address(this));
1213       dai.safeApprove(address(CDAI), 0);
1214       dai.safeApprove(address(CDAI), repayAmount);
1215       require(CDAI.repayBorrow(repayAmount) == 0);
1216       dai.safeApprove(address(CDAI), 0);
1217     }
1218   }
1219 
1220   function sellOrder(uint256 _minPrice, uint256 _maxPrice)
1221     public
1222     onlyOwner
1223     isValidPrice(_minPrice, _maxPrice)
1224     returns (uint256 _inputAmount, uint256 _outputAmount)
1225   {
1226     require(buyTime > 0); 
1227     require(isSold == false);
1228     isSold = true;
1229 
1230     
1231     
1232     CEther market = CEther(compoundTokenAddr);
1233     for (uint256 i = 0; i < MAX_REPAY_STEPS; i = i.add(1)) {
1234       uint256 currentDebt = getCurrentBorrowInDAI();
1235       if (currentDebt > NEGLIGIBLE_DEBT) {
1236         
1237         uint256 currentBalance = getCurrentCashInDAI();
1238         uint256 repayAmount = 0; 
1239         if (currentDebt <= currentBalance) {
1240           
1241           repayAmount = currentDebt;
1242         } else {
1243           
1244           repayAmount = currentBalance;
1245         }
1246 
1247         
1248         repayLoan(repayAmount);
1249       }
1250 
1251       
1252       (bool isNeg, uint256 liquidity) = getCurrentLiquidityInDAI();
1253       if (!isNeg) {
1254         liquidity = __daiToToken(compoundTokenAddr, liquidity);
1255         uint256 errorCode = market.redeemUnderlying(liquidity.mul(PRECISION.sub(DEFAULT_LIQUIDITY_SLIPPAGE)).div(PRECISION));
1256         if (errorCode != 0) {
1257           
1258           
1259           errorCode = market.redeemUnderlying(liquidity.mul(PRECISION.sub(FALLBACK_LIQUIDITY_SLIPPAGE)).div(PRECISION));
1260           if (errorCode != 0) {
1261             
1262             
1263             market.redeemUnderlying(liquidity.mul(PRECISION.sub(MAX_LIQUIDITY_SLIPPAGE)).div(PRECISION));
1264           }
1265         }
1266       }
1267 
1268       if (currentDebt <= NEGLIGIBLE_DEBT) {
1269         break;
1270       }
1271     }
1272 
1273     
1274     __sellTokenForDAI(address(this).balance);
1275 
1276     
1277     _inputAmount = collateralAmountInDAI;
1278     _outputAmount = dai.balanceOf(address(this));
1279     outputAmount = _outputAmount;
1280     dai.safeTransfer(owner(), dai.balanceOf(address(this)));
1281     toPayableAddr(owner()).transfer(address(this).balance); 
1282   }
1283 
1284   
1285   function repayLoan(uint256 _repayAmountInDAI) public onlyOwner {
1286     require(buyTime > 0); 
1287 
1288     
1289     uint256 repayAmountInToken = __daiToToken(compoundTokenAddr, _repayAmountInDAI);
1290     (uint256 actualDAIAmount,) = __sellTokenForDAI(repayAmountInToken);
1291     
1292     
1293     uint256 currentDebt = CDAI.borrowBalanceCurrent(address(this));
1294     if (actualDAIAmount > currentDebt) {
1295       actualDAIAmount = currentDebt;
1296     }
1297 
1298     
1299     dai.safeApprove(address(CDAI), 0);
1300     dai.safeApprove(address(CDAI), actualDAIAmount);
1301     require(CDAI.repayBorrow(actualDAIAmount) == 0);
1302     dai.safeApprove(address(CDAI), 0);
1303   }
1304 
1305   function getMarketCollateralFactor() public view returns (uint256) {
1306     (, uint256 ratio) = COMPTROLLER.markets(address(compoundTokenAddr));
1307     return ratio;
1308   }
1309 
1310   function getCurrentCollateralInDAI() public returns (uint256 _amount) {
1311     CEther market = CEther(compoundTokenAddr);
1312     uint256 supply = __tokenToDAI(compoundTokenAddr, market.balanceOf(address(this)).mul(market.exchangeRateCurrent()).div(PRECISION));
1313     return supply;
1314   }
1315 
1316   function getCurrentBorrowInDAI() public returns (uint256 _amount) {
1317     uint256 borrow = CDAI.borrowBalanceCurrent(address(this));
1318     return borrow;
1319   }
1320 
1321   function getCurrentCashInDAI() public view returns (uint256 _amount) {
1322     ERC20Detailed token = __underlyingToken(compoundTokenAddr);
1323     uint256 cash = __tokenToDAI(compoundTokenAddr, getBalance(token, address(this)));
1324     return cash;
1325   }
1326 }
1327 
1328 contract ShortCERC20Order is CompoundOrder {
1329   modifier isValidPrice(uint256 _minPrice, uint256 _maxPrice) {
1330     
1331     uint256 tokenPrice = ORACLE.getUnderlyingPrice(compoundTokenAddr); 
1332     require(tokenPrice > 0); 
1333     tokenPrice = __tokenToDAI(CETH_ADDR, tokenPrice); 
1334     require(tokenPrice >= _minPrice && tokenPrice <= _maxPrice); 
1335     _;
1336   }
1337 
1338   function executeOrder(uint256 _minPrice, uint256 _maxPrice)
1339     public
1340     onlyOwner
1341     isValidToken(compoundTokenAddr)
1342     isValidPrice(_minPrice, _maxPrice)
1343   {
1344     buyTime = now;
1345 
1346     
1347     dai.safeTransferFrom(owner(), address(this), collateralAmountInDAI); 
1348 
1349     
1350     CERC20 market = CERC20(compoundTokenAddr);
1351     address[] memory markets = new address[](2);
1352     markets[0] = compoundTokenAddr;
1353     markets[1] = address(CDAI);
1354     uint[] memory errors = COMPTROLLER.enterMarkets(markets);
1355     require(errors[0] == 0 && errors[1] == 0);
1356     
1357     
1358     uint256 loanAmountInToken = __daiToToken(compoundTokenAddr, loanAmountInDAI);
1359     dai.safeApprove(address(CDAI), 0); 
1360     dai.safeApprove(address(CDAI), collateralAmountInDAI); 
1361     require(CDAI.mint(collateralAmountInDAI) == 0); 
1362     dai.safeApprove(address(CDAI), 0);
1363     require(market.borrow(loanAmountInToken) == 0);
1364     (bool negLiquidity, ) = getCurrentLiquidityInDAI();
1365     require(!negLiquidity); 
1366 
1367     
1368     (uint256 actualDAIAmount,) = __sellTokenForDAI(loanAmountInToken);
1369     loanAmountInDAI = actualDAIAmount; 
1370 
1371     
1372     ERC20Detailed token = __underlyingToken(compoundTokenAddr);
1373     if (token.balanceOf(address(this)) > 0) {
1374       uint256 repayAmount = token.balanceOf(address(this));
1375       token.safeApprove(compoundTokenAddr, 0);
1376       token.safeApprove(compoundTokenAddr, repayAmount);
1377       require(market.repayBorrow(repayAmount) == 0);
1378       token.safeApprove(compoundTokenAddr, 0);
1379     }
1380   }
1381 
1382   function sellOrder(uint256 _minPrice, uint256 _maxPrice)
1383     public
1384     onlyOwner
1385     isValidPrice(_minPrice, _maxPrice)
1386     returns (uint256 _inputAmount, uint256 _outputAmount)
1387   {
1388     require(buyTime > 0); 
1389     require(isSold == false);
1390     isSold = true;
1391 
1392     
1393     
1394     for (uint256 i = 0; i < MAX_REPAY_STEPS; i = i.add(1)) {
1395       uint256 currentDebt = getCurrentBorrowInDAI();
1396       if (currentDebt > NEGLIGIBLE_DEBT) {
1397         
1398         uint256 currentBalance = getCurrentCashInDAI();
1399         uint256 repayAmount = 0; 
1400         if (currentDebt <= currentBalance) {
1401           
1402           repayAmount = currentDebt;
1403         } else {
1404           
1405           repayAmount = currentBalance;
1406         }
1407 
1408         
1409         repayLoan(repayAmount);
1410       }
1411 
1412       
1413       (bool isNeg, uint256 liquidity) = getCurrentLiquidityInDAI();
1414       if (!isNeg) {
1415         uint256 errorCode = CDAI.redeemUnderlying(liquidity.mul(PRECISION.sub(DEFAULT_LIQUIDITY_SLIPPAGE)).div(PRECISION));
1416         if (errorCode != 0) {
1417           
1418           
1419           errorCode = CDAI.redeemUnderlying(liquidity.mul(PRECISION.sub(FALLBACK_LIQUIDITY_SLIPPAGE)).div(PRECISION));
1420           if (errorCode != 0) {
1421             
1422             
1423             CDAI.redeemUnderlying(liquidity.mul(PRECISION.sub(MAX_LIQUIDITY_SLIPPAGE)).div(PRECISION));
1424           }
1425         }
1426       }
1427 
1428       if (currentDebt <= NEGLIGIBLE_DEBT) {
1429         break;
1430       }
1431     }
1432 
1433     
1434     _inputAmount = collateralAmountInDAI;
1435     _outputAmount = dai.balanceOf(address(this));
1436     outputAmount = _outputAmount;
1437     dai.safeTransfer(owner(), dai.balanceOf(address(this)));
1438   }
1439 
1440   
1441   function repayLoan(uint256 _repayAmountInDAI) public onlyOwner {
1442     require(buyTime > 0); 
1443 
1444     
1445     (,uint256 actualTokenAmount) = __sellDAIForToken(_repayAmountInDAI);
1446 
1447     
1448     CERC20 market = CERC20(compoundTokenAddr);
1449     uint256 currentDebt = market.borrowBalanceCurrent(address(this));
1450     if (actualTokenAmount > currentDebt) {
1451       actualTokenAmount = currentDebt;
1452     }
1453 
1454     
1455     ERC20Detailed token = __underlyingToken(compoundTokenAddr);
1456     token.safeApprove(compoundTokenAddr, 0);
1457     token.safeApprove(compoundTokenAddr, actualTokenAmount);
1458     require(market.repayBorrow(actualTokenAmount) == 0);
1459     token.safeApprove(compoundTokenAddr, 0);
1460   }
1461 
1462   function getMarketCollateralFactor() public view returns (uint256) {
1463     (, uint256 ratio) = COMPTROLLER.markets(address(CDAI));
1464     return ratio;
1465   }
1466 
1467   function getCurrentCollateralInDAI() public returns (uint256 _amount) {
1468     uint256 supply = CDAI.balanceOf(address(this)).mul(CDAI.exchangeRateCurrent()).div(PRECISION);
1469     return supply;
1470   }
1471 
1472   function getCurrentBorrowInDAI() public returns (uint256 _amount) {
1473     CERC20 market = CERC20(compoundTokenAddr);
1474     uint256 borrow = __tokenToDAI(compoundTokenAddr, market.borrowBalanceCurrent(address(this)));
1475     return borrow;
1476   }
1477 
1478   function getCurrentCashInDAI() public view returns (uint256 _amount) {
1479     uint256 cash = getBalance(dai, address(this));
1480     return cash;
1481   }
1482 }
1483 
1484 contract ShortCEtherOrder is CompoundOrder {
1485   modifier isValidPrice(uint256 _minPrice, uint256 _maxPrice) {
1486     
1487     uint256 tokenPrice = PRECISION; 
1488     tokenPrice = __tokenToDAI(CETH_ADDR, tokenPrice); 
1489     require(tokenPrice >= _minPrice && tokenPrice <= _maxPrice); 
1490     _;
1491   }
1492 
1493   function executeOrder(uint256 _minPrice, uint256 _maxPrice)
1494     public
1495     onlyOwner
1496     isValidToken(compoundTokenAddr)
1497     isValidPrice(_minPrice, _maxPrice)
1498   {
1499     buyTime = now;
1500 
1501     
1502     dai.safeTransferFrom(owner(), address(this), collateralAmountInDAI); 
1503     
1504     
1505     CEther market = CEther(compoundTokenAddr);
1506     address[] memory markets = new address[](2);
1507     markets[0] = compoundTokenAddr;
1508     markets[1] = address(CDAI);
1509     uint[] memory errors = COMPTROLLER.enterMarkets(markets);
1510     require(errors[0] == 0 && errors[1] == 0);
1511 
1512     
1513     uint256 loanAmountInToken = __daiToToken(compoundTokenAddr, loanAmountInDAI);
1514     dai.safeApprove(address(CDAI), 0); 
1515     dai.safeApprove(address(CDAI), collateralAmountInDAI); 
1516     require(CDAI.mint(collateralAmountInDAI) == 0); 
1517     dai.safeApprove(address(CDAI), 0);
1518     require(market.borrow(loanAmountInToken) == 0);
1519     (bool negLiquidity, ) = getCurrentLiquidityInDAI();
1520     require(!negLiquidity); 
1521 
1522     
1523     (uint256 actualDAIAmount,) = __sellTokenForDAI(loanAmountInToken);
1524     loanAmountInDAI = actualDAIAmount; 
1525 
1526     
1527     if (address(this).balance > 0) {
1528       uint256 repayAmount = address(this).balance;
1529       market.repayBorrow.value(repayAmount)();
1530     }
1531   }
1532 
1533   function sellOrder(uint256 _minPrice, uint256 _maxPrice)
1534     public
1535     onlyOwner
1536     isValidPrice(_minPrice, _maxPrice)
1537     returns (uint256 _inputAmount, uint256 _outputAmount)
1538   {
1539     require(buyTime > 0); 
1540     require(isSold == false);
1541     isSold = true;
1542 
1543     
1544     
1545     for (uint256 i = 0; i < MAX_REPAY_STEPS; i = i.add(1)) {
1546       uint256 currentDebt = getCurrentBorrowInDAI();
1547       if (currentDebt > NEGLIGIBLE_DEBT) {
1548         
1549         uint256 currentBalance = getCurrentCashInDAI();
1550         uint256 repayAmount = 0; 
1551         if (currentDebt <= currentBalance) {
1552           
1553           repayAmount = currentDebt;
1554         } else {
1555           
1556           repayAmount = currentBalance;
1557         }
1558 
1559         
1560         repayLoan(repayAmount);
1561       }
1562 
1563       
1564       (bool isNeg, uint256 liquidity) = getCurrentLiquidityInDAI();
1565       if (!isNeg) {
1566         uint256 errorCode = CDAI.redeemUnderlying(liquidity.mul(PRECISION.sub(DEFAULT_LIQUIDITY_SLIPPAGE)).div(PRECISION));
1567         if (errorCode != 0) {
1568           
1569           
1570           errorCode = CDAI.redeemUnderlying(liquidity.mul(PRECISION.sub(FALLBACK_LIQUIDITY_SLIPPAGE)).div(PRECISION));
1571           if (errorCode != 0) {
1572             
1573             
1574             CDAI.redeemUnderlying(liquidity.mul(PRECISION.sub(MAX_LIQUIDITY_SLIPPAGE)).div(PRECISION));
1575           }
1576         }
1577       }
1578 
1579       if (currentDebt <= NEGLIGIBLE_DEBT) {
1580         break;
1581       }
1582     }
1583 
1584     
1585     _inputAmount = collateralAmountInDAI;
1586     _outputAmount = dai.balanceOf(address(this));
1587     outputAmount = _outputAmount;
1588     dai.safeTransfer(owner(), dai.balanceOf(address(this)));
1589   }
1590 
1591   
1592   function repayLoan(uint256 _repayAmountInDAI) public onlyOwner {
1593     require(buyTime > 0); 
1594 
1595     
1596     (,uint256 actualTokenAmount) = __sellDAIForToken(_repayAmountInDAI);
1597 
1598     
1599     CEther market = CEther(compoundTokenAddr);
1600     uint256 currentDebt = market.borrowBalanceCurrent(address(this));
1601     if (actualTokenAmount > currentDebt) {
1602       actualTokenAmount = currentDebt;
1603     }
1604 
1605     
1606     market.repayBorrow.value(actualTokenAmount)();
1607   }
1608 
1609   function getMarketCollateralFactor() public view returns (uint256) {
1610     (, uint256 ratio) = COMPTROLLER.markets(address(CDAI));
1611     return ratio;
1612   }
1613 
1614   function getCurrentCollateralInDAI() public returns (uint256 _amount) {
1615     uint256 supply = CDAI.balanceOf(address(this)).mul(CDAI.exchangeRateCurrent()).div(PRECISION);
1616     return supply;
1617   }
1618 
1619   function getCurrentBorrowInDAI() public returns (uint256 _amount) {
1620     CEther market = CEther(compoundTokenAddr);
1621     uint256 borrow = __tokenToDAI(compoundTokenAddr, market.borrowBalanceCurrent(address(this)));
1622     return borrow;
1623   }
1624 
1625   function getCurrentCashInDAI() public view returns (uint256 _amount) {
1626     uint256 cash = getBalance(dai, address(this));
1627     return cash;
1628   }
1629 }
1630 
1631 contract CloneFactory {
1632 
1633   function createClone(address target) internal returns (address result) {
1634     bytes20 targetBytes = bytes20(target);
1635     assembly {
1636       let clone := mload(0x40)
1637       mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
1638       mstore(add(clone, 0x14), targetBytes)
1639       mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
1640       result := create(0, clone, 0x37)
1641     }
1642   }
1643 
1644   function isClone(address target, address query) internal view returns (bool result) {
1645     bytes20 targetBytes = bytes20(target);
1646     assembly {
1647       let clone := mload(0x40)
1648       mstore(clone, 0x363d3d373d3d3d363d7300000000000000000000000000000000000000000000)
1649       mstore(add(clone, 0xa), targetBytes)
1650       mstore(add(clone, 0x1e), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
1651 
1652       let other := add(clone, 0x40)
1653       extcodecopy(query, other, 0, 0x2d)
1654       result := and(
1655         eq(mload(clone), mload(other)),
1656         eq(mload(add(clone, 0xd)), mload(add(other, 0xd)))
1657       )
1658     }
1659   }
1660 }
1661 
1662 contract CompoundOrderFactory is CloneFactory {
1663   address public SHORT_CERC20_LOGIC_CONTRACT;
1664   address public SHORT_CEther_LOGIC_CONTRACT;
1665   address public LONG_CERC20_LOGIC_CONTRACT;
1666   address public LONG_CEther_LOGIC_CONTRACT;
1667 
1668   address public DAI_ADDR;
1669   address payable public KYBER_ADDR;
1670   address public COMPTROLLER_ADDR;
1671   address public ORACLE_ADDR;
1672   address public CDAI_ADDR;
1673   address public CETH_ADDR;
1674 
1675   constructor(
1676     address _shortCERC20LogicContract,
1677     address _shortCEtherLogicContract,
1678     address _longCERC20LogicContract,
1679     address _longCEtherLogicContract,
1680     address _daiAddr,
1681     address payable _kyberAddr,
1682     address _comptrollerAddr,
1683     address _priceOracleAddr,
1684     address _cDAIAddr,
1685     address _cETHAddr
1686   ) public {
1687     SHORT_CERC20_LOGIC_CONTRACT = _shortCERC20LogicContract;
1688     SHORT_CEther_LOGIC_CONTRACT = _shortCEtherLogicContract;
1689     LONG_CERC20_LOGIC_CONTRACT = _longCERC20LogicContract;
1690     LONG_CEther_LOGIC_CONTRACT = _longCEtherLogicContract;
1691 
1692     DAI_ADDR = _daiAddr;
1693     KYBER_ADDR = _kyberAddr;
1694     COMPTROLLER_ADDR = _comptrollerAddr;
1695     ORACLE_ADDR = _priceOracleAddr;
1696     CDAI_ADDR = _cDAIAddr;
1697     CETH_ADDR = _cETHAddr;
1698   }
1699 
1700   function createOrder(
1701     address _compoundTokenAddr,
1702     uint256 _cycleNumber,
1703     uint256 _stake,
1704     uint256 _collateralAmountInDAI,
1705     uint256 _loanAmountInDAI,
1706     bool _orderType
1707   ) external returns (CompoundOrder) {
1708     require(_compoundTokenAddr != address(0));
1709 
1710     CompoundOrder order;
1711 
1712     address payable clone;
1713     if (_compoundTokenAddr != CETH_ADDR) {
1714       if (_orderType) {
1715         
1716         clone = toPayableAddr(createClone(SHORT_CERC20_LOGIC_CONTRACT));
1717       } else {
1718         
1719         clone = toPayableAddr(createClone(LONG_CERC20_LOGIC_CONTRACT));
1720       }
1721     } else {
1722       if (_orderType) {
1723         
1724         clone = toPayableAddr(createClone(SHORT_CEther_LOGIC_CONTRACT));
1725       } else {
1726         
1727         clone = toPayableAddr(createClone(LONG_CEther_LOGIC_CONTRACT));
1728       }
1729     }
1730     order = CompoundOrder(clone);
1731     order.init(_compoundTokenAddr, _cycleNumber, _stake, _collateralAmountInDAI, _loanAmountInDAI, _orderType,
1732       DAI_ADDR, KYBER_ADDR, COMPTROLLER_ADDR, ORACLE_ADDR, CDAI_ADDR, CETH_ADDR);
1733     order.transferOwnership(msg.sender);
1734     return order;
1735   }
1736 
1737   function getMarketCollateralFactor(address _compoundTokenAddr) external view returns (uint256) {
1738     Comptroller troll = Comptroller(COMPTROLLER_ADDR);
1739     (, uint256 factor) = troll.markets(_compoundTokenAddr);
1740     return factor;
1741   }
1742 
1743   function tokenIsListed(address _compoundTokenAddr) external view returns (bool) {
1744     Comptroller troll = Comptroller(COMPTROLLER_ADDR);
1745     (bool isListed,) = troll.markets(_compoundTokenAddr);
1746     return isListed;
1747   }
1748 
1749   function toPayableAddr(address _addr) internal pure returns (address payable) {
1750     return address(uint160(_addr));
1751   }
1752 }
1753 
1754 contract BetokenFund is BetokenStorage, Utils, TokenController {
1755   
1756   modifier readyForUpgradeMigration {
1757     require(hasFinalizedNextVersion == true);
1758     require(now > startTimeOfCyclePhase.add(phaseLengths[uint(CyclePhase.Intermission)]));
1759     _;
1760   }
1761 
1762 
1763   
1764 
1765   constructor(
1766     address payable _kroAddr,
1767     address payable _sTokenAddr,
1768     address payable _devFundingAccount,
1769     uint256[2] memory _phaseLengths,
1770     uint256 _devFundingRate,
1771     address payable _previousVersion,
1772     address _daiAddr,
1773     address payable _kyberAddr,
1774     address _compoundFactoryAddr,
1775     address _betokenLogic,
1776     address _betokenLogic2,
1777     uint256 _startCycleNumber,
1778     address payable _dexagAddr,
1779     address _saiAddr,
1780     address _mcdaiMigrationAddr
1781   )
1782     public
1783     Utils(_daiAddr, _kyberAddr, _dexagAddr)
1784   {
1785     controlTokenAddr = _kroAddr;
1786     shareTokenAddr = _sTokenAddr;
1787     devFundingAccount = _devFundingAccount;
1788     phaseLengths = _phaseLengths;
1789     devFundingRate = _devFundingRate;
1790     cyclePhase = CyclePhase.Intermission;
1791     compoundFactoryAddr = _compoundFactoryAddr;
1792     betokenLogic = _betokenLogic;
1793     betokenLogic2 = _betokenLogic2;
1794     previousVersion = _previousVersion;
1795     cycleNumber = _startCycleNumber;
1796     saiAddr = _saiAddr;
1797 
1798     cToken = IMiniMeToken(_kroAddr);
1799     sToken = IMiniMeToken(_sTokenAddr);
1800     mcdaiMigration = ScdMcdMigration(_mcdaiMigrationAddr);
1801   }
1802 
1803   function initTokenListings(
1804     address[] memory _kyberTokens,
1805     address[] memory _compoundTokens,
1806     address[] memory _positionTokens
1807   )
1808     public
1809     onlyOwner
1810   {
1811     
1812     require(!hasInitializedTokenListings);
1813     hasInitializedTokenListings = true;
1814 
1815     uint256 i;
1816     for (i = 0; i < _kyberTokens.length; i = i.add(1)) {
1817       isKyberToken[_kyberTokens[i]] = true;
1818     }
1819 
1820     for (i = 0; i < _compoundTokens.length; i = i.add(1)) {
1821       isCompoundToken[_compoundTokens[i]] = true;
1822     }
1823 
1824     for (i = 0; i < _positionTokens.length; i = i.add(1)) {
1825       isPositionToken[_positionTokens[i]] = true;
1826     }
1827   }
1828 
1829   
1830   function setProxy(address payable _proxyAddr) public onlyOwner {
1831     require(_proxyAddr != address(0));
1832     require(proxyAddr == address(0));
1833     proxyAddr = _proxyAddr;
1834     proxy = BetokenProxyInterface(_proxyAddr);
1835   }
1836 
1837   
1838 
1839   
1840   function developerInitiateUpgrade(address payable _candidate) public returns (bool _success) {
1841     (bool success, bytes memory result) = betokenLogic2.delegatecall(abi.encodeWithSelector(this.developerInitiateUpgrade.selector, _candidate));
1842     if (!success) { return false; }
1843     return abi.decode(result, (bool));
1844   }
1845 
1846   
1847   function signalUpgrade(bool _inSupport) public returns (bool _success) {
1848     (bool success, bytes memory result) = betokenLogic2.delegatecall(abi.encodeWithSelector(this.signalUpgrade.selector, _inSupport));
1849     if (!success) { return false; }
1850     return abi.decode(result, (bool));
1851   }
1852 
1853   
1854   function proposeCandidate(uint256 _chunkNumber, address payable _candidate) public returns (bool _success) {
1855     (bool success, bytes memory result) = betokenLogic2.delegatecall(abi.encodeWithSelector(this.proposeCandidate.selector, _chunkNumber, _candidate));
1856     if (!success) { return false; }
1857     return abi.decode(result, (bool));
1858   }
1859 
1860   
1861   function voteOnCandidate(uint256 _chunkNumber, bool _inSupport) public returns (bool _success) {
1862     (bool success, bytes memory result) = betokenLogic2.delegatecall(abi.encodeWithSelector(this.voteOnCandidate.selector, _chunkNumber, _inSupport));
1863     if (!success) { return false; }
1864     return abi.decode(result, (bool));
1865   }
1866 
1867   
1868   function finalizeSuccessfulVote(uint256 _chunkNumber) public returns (bool _success) {
1869     (bool success, bytes memory result) = betokenLogic2.delegatecall(abi.encodeWithSelector(this.finalizeSuccessfulVote.selector, _chunkNumber));
1870     if (!success) { return false; }
1871     return abi.decode(result, (bool));
1872   }
1873 
1874   
1875   function migrateOwnedContractsToNextVersion() public nonReentrant readyForUpgradeMigration {
1876     cToken.transferOwnership(nextVersion);
1877     sToken.transferOwnership(nextVersion);
1878     proxy.updateBetokenFundAddress();
1879   }
1880 
1881   
1882   function transferAssetToNextVersion(address _assetAddress) public nonReentrant readyForUpgradeMigration isValidToken(_assetAddress) {
1883     if (_assetAddress == address(ETH_TOKEN_ADDRESS)) {
1884       nextVersion.transfer(address(this).balance);
1885     } else {
1886       ERC20Detailed token = ERC20Detailed(_assetAddress);
1887       token.safeTransfer(nextVersion, token.balanceOf(address(this)));
1888     }
1889   }
1890 
1891   
1892 
1893   
1894   function investmentsCount(address _userAddr) public view returns(uint256 _count) {
1895     return userInvestments[_userAddr].length;
1896   }
1897 
1898   
1899   function compoundOrdersCount(address _userAddr) public view returns(uint256 _count) {
1900     return userCompoundOrders[_userAddr].length;
1901   }
1902 
1903   
1904   function getPhaseLengths() public view returns(uint256[2] memory _phaseLengths) {
1905     return phaseLengths;
1906   }
1907 
1908   
1909   function commissionBalanceOf(address _manager) public returns (uint256 _commission, uint256 _penalty) {
1910     (bool success, bytes memory result) = betokenLogic.delegatecall(abi.encodeWithSelector(this.commissionBalanceOf.selector, _manager));
1911     if (!success) { return (0, 0); }
1912     return abi.decode(result, (uint256, uint256));
1913   }
1914 
1915   
1916   function commissionOfAt(address _manager, uint256 _cycle) public returns (uint256 _commission, uint256 _penalty) {
1917     (bool success, bytes memory result) = betokenLogic.delegatecall(abi.encodeWithSelector(this.commissionOfAt.selector, _manager, _cycle));
1918     if (!success) { return (0, 0); }
1919     return abi.decode(result, (uint256, uint256));
1920   }
1921 
1922   
1923 
1924   
1925   function changeDeveloperFeeAccount(address payable _newAddr) public onlyOwner {
1926     require(_newAddr != address(0) && _newAddr != address(this));
1927     devFundingAccount = _newAddr;
1928   }
1929 
1930   
1931   function changeDeveloperFeeRate(uint256 _newProp) public onlyOwner {
1932     require(_newProp < PRECISION);
1933     require(_newProp < devFundingRate);
1934     devFundingRate = _newProp;
1935   }
1936 
1937   
1938   function listKyberToken(address _token) public onlyOwner {
1939     isKyberToken[_token] = true;
1940   }
1941 
1942   
1943   function listCompoundToken(address _token) public onlyOwner {
1944     CompoundOrderFactory factory = CompoundOrderFactory(compoundFactoryAddr);
1945     require(factory.tokenIsListed(_token));
1946     isCompoundToken[_token] = true;
1947   }
1948 
1949   
1950   function nextPhase()
1951     public
1952   {
1953     (bool success,) = betokenLogic2.delegatecall(abi.encodeWithSelector(this.nextPhase.selector));
1954     if (!success) { revert(); }
1955   }
1956 
1957 
1958   
1959 
1960   
1961   function registerWithDAI(uint256 _donationInDAI) public {
1962     (bool success,) = betokenLogic2.delegatecall(abi.encodeWithSelector(this.registerWithDAI.selector, _donationInDAI));
1963     if (!success) { revert(); }
1964   }
1965 
1966   
1967   function registerWithETH() public payable {
1968     (bool success,) = betokenLogic2.delegatecall(abi.encodeWithSelector(this.registerWithETH.selector));
1969     if (!success) { revert(); }
1970   }
1971 
1972   
1973   function registerWithToken(address _token, uint256 _donationInTokens) public {
1974     (bool success,) = betokenLogic2.delegatecall(abi.encodeWithSelector(this.registerWithToken.selector, _token, _donationInTokens));
1975     if (!success) { revert(); }
1976   }
1977 
1978 
1979   
1980 
1981   
1982   function depositEther()
1983     public
1984     payable
1985   {
1986     (bool success,) = betokenLogic2.delegatecall(abi.encodeWithSelector(this.depositEther.selector));
1987     if (!success) { revert(); }
1988   }
1989 
1990   
1991   function depositDAI(uint256 _daiAmount)
1992     public
1993   {
1994     (bool success,) = betokenLogic2.delegatecall(abi.encodeWithSelector(this.depositDAI.selector, _daiAmount));
1995     if (!success) { revert(); }
1996   }
1997 
1998   
1999   function depositToken(address _tokenAddr, uint256 _tokenAmount)
2000     public
2001   {
2002     (bool success,) = betokenLogic2.delegatecall(abi.encodeWithSelector(this.depositToken.selector, _tokenAddr, _tokenAmount));
2003     if (!success) { revert(); }
2004   }
2005 
2006   
2007   function withdrawEther(uint256 _amountInDAI)
2008     public
2009   {
2010     (bool success,) = betokenLogic2.delegatecall(abi.encodeWithSelector(this.withdrawEther.selector, _amountInDAI));
2011     if (!success) { revert(); }
2012   }
2013 
2014   
2015   function withdrawDAI(uint256 _amountInDAI)
2016     public
2017   {
2018     (bool success,) = betokenLogic2.delegatecall(abi.encodeWithSelector(this.withdrawDAI.selector, _amountInDAI));
2019     if (!success) { revert(); }
2020   }
2021 
2022   
2023   function withdrawToken(address _tokenAddr, uint256 _amountInDAI)
2024     public
2025   {
2026     (bool success,) = betokenLogic2.delegatecall(abi.encodeWithSelector(this.withdrawToken.selector, _tokenAddr, _amountInDAI));
2027     if (!success) { revert(); }
2028   }
2029 
2030   
2031   function redeemCommission(bool _inShares)
2032     public
2033   {
2034     (bool success,) = betokenLogic.delegatecall(abi.encodeWithSelector(this.redeemCommission.selector, _inShares));
2035     if (!success) { revert(); }
2036   }
2037 
2038   
2039   function redeemCommissionForCycle(bool _inShares, uint256 _cycle)
2040     public
2041   {
2042     (bool success,) = betokenLogic.delegatecall(abi.encodeWithSelector(this.redeemCommissionForCycle.selector, _inShares, _cycle));
2043     if (!success) { revert(); }
2044   }
2045 
2046   
2047   function sellLeftoverToken(address _tokenAddr)
2048     public
2049   {
2050     (bool success,) = betokenLogic2.delegatecall(abi.encodeWithSelector(this.sellLeftoverToken.selector, _tokenAddr));
2051     if (!success) { revert(); }
2052   }
2053 
2054   function sellLeftoverFulcrumToken(address _tokenAddr)
2055     public
2056   {
2057     (bool success,) = betokenLogic2.delegatecall(abi.encodeWithSelector(this.sellLeftoverFulcrumToken.selector, _tokenAddr));
2058     if (!success) { revert(); }
2059   }
2060 
2061   
2062   function sellLeftoverCompoundOrder(address payable _orderAddress)
2063     public
2064   {
2065     (bool success,) = betokenLogic2.delegatecall(abi.encodeWithSelector(this.sellLeftoverCompoundOrder.selector, _orderAddress));
2066     if (!success) { revert(); }
2067   }
2068 
2069   
2070   function burnDeadman(address _deadman)
2071     public
2072   {
2073     (bool success,) = betokenLogic.delegatecall(abi.encodeWithSelector(this.burnDeadman.selector, _deadman));
2074     if (!success) { revert(); }
2075   }
2076 
2077   
2078 
2079   
2080   function createInvestment(
2081     address _tokenAddress,
2082     uint256 _stake,
2083     uint256 _minPrice,
2084     uint256 _maxPrice
2085   )
2086     public
2087   {
2088     (bool success,) = betokenLogic.delegatecall(abi.encodeWithSelector(this.createInvestment.selector, _tokenAddress, _stake, _minPrice, _maxPrice));
2089     if (!success) { revert(); }
2090   }
2091 
2092   
2093   function createInvestmentV2(
2094     address _tokenAddress,
2095     uint256 _stake,
2096     uint256 _minPrice,
2097     uint256 _maxPrice,
2098     bytes memory _calldata,
2099     bool _useKyber
2100   )
2101     public
2102   {
2103     (bool success,) = betokenLogic.delegatecall(abi.encodeWithSelector(this.createInvestmentV2.selector, _tokenAddress, _stake, _minPrice, _maxPrice, _calldata, _useKyber));
2104     if (!success) { revert(); }
2105   }
2106 
2107   
2108   function sellInvestmentAsset(
2109     uint256 _investmentId,
2110     uint256 _tokenAmount,
2111     uint256 _minPrice,
2112     uint256 _maxPrice
2113   )
2114     public
2115   {
2116     (bool success,) = betokenLogic.delegatecall(abi.encodeWithSelector(this.sellInvestmentAsset.selector, _investmentId, _tokenAmount, _minPrice, _maxPrice));
2117     if (!success) { revert(); }
2118   }
2119 
2120   
2121   function sellInvestmentAssetV2(
2122     uint256 _investmentId,
2123     uint256 _tokenAmount,
2124     uint256 _minPrice,
2125     uint256 _maxPrice,
2126     bytes memory _calldata,
2127     bool _useKyber
2128   )
2129     public
2130   {
2131     (bool success,) = betokenLogic.delegatecall(abi.encodeWithSelector(this.sellInvestmentAssetV2.selector, _investmentId, _tokenAmount, _minPrice, _maxPrice, _calldata, _useKyber));
2132     if (!success) { revert(); }
2133   }
2134 
2135   
2136   function createCompoundOrder(
2137     bool _orderType,
2138     address _tokenAddress,
2139     uint256 _stake,
2140     uint256 _minPrice,
2141     uint256 _maxPrice
2142   )
2143     public
2144   {
2145     (bool success,) = betokenLogic.delegatecall(abi.encodeWithSelector(this.createCompoundOrder.selector, _orderType, _tokenAddress, _stake, _minPrice, _maxPrice));
2146     if (!success) { revert(); }
2147   }
2148 
2149   
2150   function sellCompoundOrder(
2151     uint256 _orderId,
2152     uint256 _minPrice,
2153     uint256 _maxPrice
2154   )
2155     public
2156   {
2157     (bool success,) = betokenLogic.delegatecall(abi.encodeWithSelector(this.sellCompoundOrder.selector, _orderId, _minPrice, _maxPrice));
2158     if (!success) { revert(); }
2159   }
2160 
2161   
2162   function repayCompoundOrder(uint256 _orderId, uint256 _repayAmountInDAI) public {
2163     (bool success,) = betokenLogic.delegatecall(abi.encodeWithSelector(this.repayCompoundOrder.selector, _orderId, _repayAmountInDAI));
2164     if (!success) { revert(); }
2165   }
2166 
2167   
2168 
2169   
2170   
2171   function proxyPayment(address _owner) public payable returns(bool) {
2172     return false;
2173   }
2174 
2175   
2176   function onTransfer(address _from, address _to, uint _amount) public returns(bool) {
2177     return true;
2178   }
2179 
2180   
2181   function onApprove(address _owner, address _spender, uint _amount) public
2182       returns(bool) {
2183     return true;
2184   }
2185 
2186   function() external payable {}
2187 }