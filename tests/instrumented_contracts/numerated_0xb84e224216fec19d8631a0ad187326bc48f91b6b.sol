1 pragma solidity ^0.4.21;
2 
3 // File: contracts/ISimpleCrowdsale.sol
4 
5 interface ISimpleCrowdsale {
6     function getSoftCap() external view returns(uint256);
7     function isContributorInLists(address contributorAddress) external view returns(bool);
8     function processReservationFundContribution(
9         address contributor,
10         uint256 tokenAmount,
11         uint256 tokenBonusAmount
12     ) external payable;
13 }
14 
15 // File: contracts/ownership/Ownable.sol
16 
17 /**
18  * @title Ownable
19  * @dev The Ownable contract has an owner address, and provides basic authorization control
20  * functions, this simplifies the implementation of "user permissions".
21  */
22 contract Ownable {
23     address public owner;
24     address public newOwner;
25 
26     event OwnershipTransferred(address previousOwner, address newOwner);
27 
28     /**
29     * @dev The Ownable constructor sets the original `owner` of the contract.
30     */
31     function Ownable(address _owner) public {
32         owner = _owner == address(0) ? msg.sender : _owner;
33     }
34 
35     /**
36     * @dev Throws if called by any account other than the owner.
37     */
38     modifier onlyOwner() {
39         require(msg.sender == owner);
40         _;
41     }
42 
43     /**
44     * @dev Allows the current owner to transfer control of the contract to a newOwner.
45     * @param _newOwner The address to transfer ownership to.
46     */
47     function transferOwnership(address _newOwner) public onlyOwner {
48         require(_newOwner != owner);
49         newOwner = _newOwner;
50     }
51 
52     /**
53     * @dev confirm ownership by a new owner
54     */
55     function confirmOwnership() public {
56         require(msg.sender == newOwner);
57         OwnershipTransferred(owner, newOwner);
58         owner = newOwner;
59         newOwner = 0x0;
60     }
61 }
62 
63 // File: contracts/Pausable.sol
64 
65 /**
66  * @title Pausable
67  * @dev Base contract which allows children to implement an emergency stop mechanism.
68  */
69 contract Pausable is Ownable {
70     event Pause();
71     event Unpause();
72 
73     bool public paused = false;
74 
75 
76     /**
77      * @dev Modifier to make a function callable only when the contract is not paused.
78      */
79     modifier whenNotPaused() {
80         require(!paused);
81         _;
82     }
83 
84     /**
85      * @dev Modifier to make a function callable only when the contract is paused.
86      */
87     modifier whenPaused() {
88         require(paused);
89         _;
90     }
91 
92     /**
93      * @dev called by the owner to pause, triggers stopped state
94      */
95     function pause() onlyOwner whenNotPaused public {
96         paused = true;
97         Pause();
98     }
99 
100     /**
101      * @dev called by the owner to unpause, returns to normal state
102      */
103     function unpause() onlyOwner whenPaused public {
104         paused = false;
105         Unpause();
106     }
107 }
108 
109 // File: contracts/fund/ICrowdsaleFund.sol
110 
111 /**
112  * @title ICrowdsaleFund
113  * @dev Fund methods used by crowdsale contract
114  */
115 interface ICrowdsaleFund {
116     /**
117     * @dev Function accepts user`s contributed ether and logs contribution
118     * @param contributor Contributor wallet address.
119     */
120     function processContribution(address contributor) external payable;
121     /**
122     * @dev Function is called on the end of successful crowdsale
123     */
124     function onCrowdsaleEnd() external;
125     /**
126     * @dev Function is called if crowdsale failed to reach soft cap
127     */
128     function enableCrowdsaleRefund() external;
129 }
130 
131 // File: contracts/fund/ICrowdsaleReservationFund.sol
132 
133 /**
134  * @title ICrowdsaleReservationFund
135  * @dev ReservationFund methods used by crowdsale contract
136  */
137 interface ICrowdsaleReservationFund {
138     /**
139      * @dev Check if contributor has transactions
140      */
141     function canCompleteContribution(address contributor) external returns(bool);
142     /**
143      * @dev Complete contribution
144      * @param contributor Contributor`s address
145      */
146     function completeContribution(address contributor) external;
147     /**
148      * @dev Function accepts user`s contributed ether and amount of tokens to issue
149      * @param contributor Contributor wallet address.
150      * @param _tokensToIssue Token amount to issue
151      * @param _bonusTokensToIssue Bonus token amount to issue
152      */
153     function processContribution(address contributor, uint256 _tokensToIssue, uint256 _bonusTokensToIssue) external payable;
154 
155     /**
156      * @dev Function returns current user`s contributed ether amount
157      */
158     function contributionsOf(address contributor) external returns(uint256);
159 
160     /**
161      * @dev Function is called on the end of successful crowdsale
162      */
163     function onCrowdsaleEnd() external;
164 }
165 
166 // File: contracts/token/IERC20Token.sol
167 
168 /**
169  * @title IERC20Token - ERC20 interface
170  * @dev see https://github.com/ethereum/EIPs/issues/20
171  */
172 contract IERC20Token {
173     string public name;
174     string public symbol;
175     uint8 public decimals;
176     uint256 public totalSupply;
177 
178     function balanceOf(address _owner) public constant returns (uint256 balance);
179     function transfer(address _to, uint256 _value)  public returns (bool success);
180     function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success);
181     function approve(address _spender, uint256 _value)  public returns (bool success);
182     function allowance(address _owner, address _spender)  public constant returns (uint256 remaining);
183 
184     event Transfer(address indexed _from, address indexed _to, uint256 _value);
185     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
186 }
187 
188 // File: contracts/math/SafeMath.sol
189 
190 /**
191  * @title SafeMath
192  * @dev Math operations with safety checks that throw on error
193  */
194 contract SafeMath {
195     /**
196     * @dev constructor
197     */
198     function SafeMath() public {
199     }
200 
201     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
202         uint256 c = a * b;
203         assert(a == 0 || c / a == b);
204         return c;
205     }
206 
207     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
208         uint256 c = a / b;
209         return c;
210     }
211 
212     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
213         assert(a >= b);
214         return a - b;
215     }
216 
217     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
218         uint256 c = a + b;
219         assert(c >= a);
220         return c;
221     }
222 }
223 
224 // File: contracts/token/LockedTokens.sol
225 
226 /**
227  * @title LockedTokens
228  * @dev Lock tokens for certain period of time
229  */
230 contract LockedTokens is SafeMath {
231     struct Tokens {
232         uint256 amount;
233         uint256 lockEndTime;
234         bool released;
235     }
236 
237     event TokensUnlocked(address _to, uint256 _value);
238 
239     IERC20Token public token;
240     address public crowdsaleAddress;
241     mapping(address => Tokens[]) public walletTokens;
242 
243     /**
244      * @dev LockedTokens constructor
245      * @param _token ERC20 compatible token contract
246      * @param _crowdsaleAddress Crowdsale contract address
247      */
248     function LockedTokens(IERC20Token _token, address _crowdsaleAddress) public {
249         token = _token;
250         crowdsaleAddress = _crowdsaleAddress;
251     }
252 
253     /**
254      * @dev Functions locks tokens
255      * @param _to Wallet address to transfer tokens after _lockEndTime
256      * @param _amount Amount of tokens to lock
257      * @param _lockEndTime End of lock period
258      */
259     function addTokens(address _to, uint256 _amount, uint256 _lockEndTime) external {
260         require(msg.sender == crowdsaleAddress);
261         walletTokens[_to].push(Tokens({amount: _amount, lockEndTime: _lockEndTime, released: false}));
262     }
263 
264     /**
265      * @dev Called by owner of locked tokens to release them
266      */
267     function releaseTokens() public {
268         require(walletTokens[msg.sender].length > 0);
269 
270         for(uint256 i = 0; i < walletTokens[msg.sender].length; i++) {
271             if(!walletTokens[msg.sender][i].released && now >= walletTokens[msg.sender][i].lockEndTime) {
272                 walletTokens[msg.sender][i].released = true;
273                 token.transfer(msg.sender, walletTokens[msg.sender][i].amount);
274                 TokensUnlocked(msg.sender, walletTokens[msg.sender][i].amount);
275             }
276         }
277     }
278 }
279 
280 // File: contracts/ownership/MultiOwnable.sol
281 
282 /**
283  * @title MultiOwnable
284  * @dev The MultiOwnable contract has owners addresses and provides basic authorization control
285  * functions, this simplifies the implementation of "users permissions".
286  */
287 contract MultiOwnable {
288     address public manager; // address used to set owners
289     address[] public owners;
290     mapping(address => bool) public ownerByAddress;
291 
292     event SetOwners(address[] owners);
293 
294     modifier onlyOwner() {
295         require(ownerByAddress[msg.sender] == true);
296         _;
297     }
298 
299     /**
300      * @dev MultiOwnable constructor sets the manager
301      */
302     function MultiOwnable() public {
303         manager = msg.sender;
304     }
305 
306     /**
307      * @dev Function to set owners addresses
308      */
309     function setOwners(address[] _owners) public {
310         require(msg.sender == manager);
311         _setOwners(_owners);
312 
313     }
314 
315     function _setOwners(address[] _owners) internal {
316         for(uint256 i = 0; i < owners.length; i++) {
317             ownerByAddress[owners[i]] = false;
318         }
319 
320 
321         for(uint256 j = 0; j < _owners.length; j++) {
322             ownerByAddress[_owners[j]] = true;
323         }
324         owners = _owners;
325         SetOwners(_owners);
326     }
327 
328     function getOwners() public constant returns (address[]) {
329         return owners;
330     }
331 }
332 
333 // File: contracts/token/ERC20Token.sol
334 
335 /**
336  * @title ERC20Token - ERC20 base implementation
337  * @dev see https://github.com/ethereum/EIPs/issues/20
338  */
339 contract ERC20Token is IERC20Token, SafeMath {
340     mapping (address => uint256) public balances;
341     mapping (address => mapping (address => uint256)) public allowed;
342 
343     function transfer(address _to, uint256 _value) public returns (bool) {
344         require(_to != address(0));
345         require(balances[msg.sender] >= _value);
346 
347         balances[msg.sender] = safeSub(balances[msg.sender], _value);
348         balances[_to] = safeAdd(balances[_to], _value);
349         Transfer(msg.sender, _to, _value);
350         return true;
351     }
352 
353     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
354         require(_to != address(0));
355         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
356 
357         balances[_to] = safeAdd(balances[_to], _value);
358         balances[_from] = safeSub(balances[_from], _value);
359         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
360         Transfer(_from, _to, _value);
361         return true;
362     }
363 
364     function balanceOf(address _owner) public constant returns (uint256) {
365         return balances[_owner];
366     }
367 
368     function approve(address _spender, uint256 _value) public returns (bool) {
369         allowed[msg.sender][_spender] = _value;
370         Approval(msg.sender, _spender, _value);
371         return true;
372     }
373 
374     function allowance(address _owner, address _spender) public constant returns (uint256) {
375       return allowed[_owner][_spender];
376     }
377 }
378 
379 // File: contracts/token/ITokenEventListener.sol
380 
381 /**
382  * @title ITokenEventListener
383  * @dev Interface which should be implemented by token listener
384  */
385 interface ITokenEventListener {
386     /**
387      * @dev Function is called after token transfer/transferFrom
388      * @param _from Sender address
389      * @param _to Receiver address
390      * @param _value Amount of tokens
391      */
392     function onTokenTransfer(address _from, address _to, uint256 _value) external;
393 }
394 
395 // File: contracts/token/ManagedToken.sol
396 
397 /**
398  * @title ManagedToken
399  * @dev ERC20 compatible token with issue and destroy facilities
400  * @dev All transfers can be monitored by token event listener
401  */
402 contract ManagedToken is ERC20Token, MultiOwnable {
403     bool public allowTransfers = false;
404     bool public issuanceFinished = false;
405 
406     ITokenEventListener public eventListener;
407 
408     event AllowTransfersChanged(bool _newState);
409     event Issue(address indexed _to, uint256 _value);
410     event Destroy(address indexed _from, uint256 _value);
411     event IssuanceFinished();
412 
413     modifier transfersAllowed() {
414         require(allowTransfers);
415         _;
416     }
417 
418     modifier canIssue() {
419         require(!issuanceFinished);
420         _;
421     }
422 
423     /**
424      * @dev ManagedToken constructor
425      * @param _listener Token listener(address can be 0x0)
426      * @param _owners Owners list
427      */
428     function ManagedToken(address _listener, address[] _owners) public {
429         if(_listener != address(0)) {
430             eventListener = ITokenEventListener(_listener);
431         }
432         _setOwners(_owners);
433     }
434 
435     /**
436      * @dev Enable/disable token transfers. Can be called only by owners
437      * @param _allowTransfers True - allow False - disable
438      */
439     function setAllowTransfers(bool _allowTransfers) external onlyOwner {
440         allowTransfers = _allowTransfers;
441         AllowTransfersChanged(_allowTransfers);
442     }
443 
444     /**
445      * @dev Set/remove token event listener
446      * @param _listener Listener address (Contract must implement ITokenEventListener interface)
447      */
448     function setListener(address _listener) public onlyOwner {
449         if(_listener != address(0)) {
450             eventListener = ITokenEventListener(_listener);
451         } else {
452             delete eventListener;
453         }
454     }
455 
456     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool) {
457         bool success = super.transfer(_to, _value);
458         if(hasListener() && success) {
459             eventListener.onTokenTransfer(msg.sender, _to, _value);
460         }
461         return success;
462     }
463 
464     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool) {
465         bool success = super.transferFrom(_from, _to, _value);
466         if(hasListener() && success) {
467             eventListener.onTokenTransfer(_from, _to, _value);
468         }
469         return success;
470     }
471 
472     function hasListener() internal view returns(bool) {
473         if(eventListener == address(0)) {
474             return false;
475         }
476         return true;
477     }
478 
479     /**
480      * @dev Issue tokens to specified wallet
481      * @param _to Wallet address
482      * @param _value Amount of tokens
483      */
484     function issue(address _to, uint256 _value) external onlyOwner canIssue {
485         totalSupply = safeAdd(totalSupply, _value);
486         balances[_to] = safeAdd(balances[_to], _value);
487         Issue(_to, _value);
488         Transfer(address(0), _to, _value);
489     }
490 
491     /**
492      * @dev Destroy tokens on specified address (Called by owner or token holder)
493      * @dev Fund contract address must be in the list of owners to burn token during refund
494      * @param _from Wallet address
495      * @param _value Amount of tokens to destroy
496      */
497     function destroy(address _from, uint256 _value) external {
498         require(ownerByAddress[msg.sender] || msg.sender == _from);
499         require(balances[_from] >= _value);
500         totalSupply = safeSub(totalSupply, _value);
501         balances[_from] = safeSub(balances[_from], _value);
502         Transfer(_from, address(0), _value);
503         Destroy(_from, _value);
504     }
505 
506     /**
507      * @dev Increase the amount of tokens that an owner allowed to a spender.
508      *
509      * approve should be called when allowed[_spender] == 0. To increment
510      * allowed value is better to use this function to avoid 2 calls (and wait until
511      * the first transaction is mined)
512      * From OpenZeppelin StandardToken.sol
513      * @param _spender The address which will spend the funds.
514      * @param _addedValue The amount of tokens to increase the allowance by.
515      */
516     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
517         allowed[msg.sender][_spender] = safeAdd(allowed[msg.sender][_spender], _addedValue);
518         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
519         return true;
520     }
521 
522     /**
523      * @dev Decrease the amount of tokens that an owner allowed to a spender.
524      *
525      * approve should be called when allowed[_spender] == 0. To decrement
526      * allowed value is better to use this function to avoid 2 calls (and wait until
527      * the first transaction is mined)
528      * From OpenZeppelin StandardToken.sol
529      * @param _spender The address which will spend the funds.
530      * @param _subtractedValue The amount of tokens to decrease the allowance by.
531      */
532     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
533         uint oldValue = allowed[msg.sender][_spender];
534         if (_subtractedValue > oldValue) {
535             allowed[msg.sender][_spender] = 0;
536         } else {
537             allowed[msg.sender][_spender] = safeSub(oldValue, _subtractedValue);
538         }
539         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
540         return true;
541     }
542 
543     /**
544      * @dev Finish token issuance
545      * @return True if success
546      */
547     function finishIssuance() public onlyOwner returns (bool) {
548         issuanceFinished = true;
549         IssuanceFinished();
550         return true;
551     }
552 }
553 
554 // File: contracts/token/TransferLimitedToken.sol
555 
556 /**
557  * @title TransferLimitedToken
558  * @dev Token with ability to limit transfers within wallets included in limitedWallets list for certain period of time
559  */
560 contract TransferLimitedToken is ManagedToken {
561     uint256 public constant LIMIT_TRANSFERS_PERIOD = 365 days;
562 
563     mapping(address => bool) public limitedWallets;
564     uint256 public limitEndDate;
565     address public limitedWalletsManager;
566     bool public isLimitEnabled;
567 
568     event TransfersEnabled();
569 
570     modifier onlyManager() {
571         require(msg.sender == limitedWalletsManager);
572         _;
573     }
574 
575     /**
576      * @dev Check if transfer between addresses is available
577      * @param _from From address
578      * @param _to To address
579      */
580     modifier canTransfer(address _from, address _to)  {
581         require(now >= limitEndDate || !isLimitEnabled || (!limitedWallets[_from] && !limitedWallets[_to]));
582         _;
583     }
584 
585     /**
586      * @dev TransferLimitedToken constructor
587      * @param _limitStartDate Limit start date
588      * @param _listener Token listener(address can be 0x0)
589      * @param _owners Owners list
590      * @param _limitedWalletsManager Address used to add/del wallets from limitedWallets
591      */
592     function TransferLimitedToken(
593         uint256 _limitStartDate,
594         address _listener,
595         address[] _owners,
596         address _limitedWalletsManager
597     ) public ManagedToken(_listener, _owners)
598     {
599         limitEndDate = _limitStartDate + LIMIT_TRANSFERS_PERIOD;
600         isLimitEnabled = true;
601         limitedWalletsManager = _limitedWalletsManager;
602     }
603 
604     /**
605      * @dev Enable token transfers
606      */
607     function enableTransfers() public {
608         require(msg.sender == limitedWalletsManager);
609         allowTransfers = true;
610         TransfersEnabled();
611     }
612 
613     /**
614      * @dev Add address to limitedWallets
615      * @dev Can be called only by manager
616      */
617     function addLimitedWalletAddress(address _wallet) public {
618         require(msg.sender == limitedWalletsManager || ownerByAddress[msg.sender]);
619         limitedWallets[_wallet] = true;
620     }
621 
622     /**
623      * @dev Del address from limitedWallets
624      * @dev Can be called only by manager
625      */
626     function delLimitedWalletAddress(address _wallet) public onlyManager {
627         limitedWallets[_wallet] = false;
628     }
629 
630     /**
631      * @dev Disable transfer limit manually. Can be called only by manager
632      */
633     function disableLimit() public onlyManager {
634         isLimitEnabled = false;
635     }
636 
637     function transfer(address _to, uint256 _value) public canTransfer(msg.sender, _to) returns (bool) {
638         return super.transfer(_to, _value);
639     }
640 
641     function transferFrom(address _from, address _to, uint256 _value) public canTransfer(_from, _to) returns (bool) {
642         return super.transferFrom(_from, _to, _value);
643     }
644 
645     function approve(address _spender, uint256 _value) public canTransfer(msg.sender, _spender) returns (bool) {
646         return super.approve(_spender,_value);
647     }
648 }
649 
650 // File: contracts/Crowdsale.sol
651 
652 contract TheAbyssDAICO is Ownable, SafeMath, Pausable, ISimpleCrowdsale {
653     enum AdditionalBonusState {
654         Unavailable,
655         Active,
656         Applied
657     }
658 
659     uint256 public constant ADDITIONAL_BONUS_NUM = 3;
660     uint256 public constant ADDITIONAL_BONUS_DENOM = 100;
661 
662     uint256 public constant ETHER_MIN_CONTRIB = 0.2 ether;
663     uint256 public constant ETHER_MAX_CONTRIB = 20 ether;
664 
665     uint256 public constant ETHER_MIN_CONTRIB_PRIVATE = 100 ether;
666     uint256 public constant ETHER_MAX_CONTRIB_PRIVATE = 3000 ether;
667 
668     uint256 public constant ETHER_MIN_CONTRIB_USA = 0.2 ether;
669     uint256 public constant ETHER_MAX_CONTRIB_USA = 20 ether;
670 
671     uint256 public constant SALE_START_TIME = 1524060000; // 18.04.2018 14:00:00 UTC
672     uint256 public constant SALE_END_TIME = 1526479200; // 16.05.2018 14:00:00 UTC
673 
674     uint256 public constant BONUS_WINDOW_1_END_TIME = SALE_START_TIME + 2 days;
675     uint256 public constant BONUS_WINDOW_2_END_TIME = SALE_START_TIME + 7 days;
676     uint256 public constant BONUS_WINDOW_3_END_TIME = SALE_START_TIME + 14 days;
677     uint256 public constant BONUS_WINDOW_4_END_TIME = SALE_START_TIME + 21 days;
678 
679     uint256 public constant MAX_CONTRIB_CHECK_END_TIME = SALE_START_TIME + 1 days;
680 
681     uint256 public constant BNB_TOKEN_PRICE_NUM = 169;
682     uint256 public constant BNB_TOKEN_PRICE_DENOM = 1;
683 
684     uint256 public tokenPriceNum = 0;
685     uint256 public tokenPriceDenom = 0;
686     
687     TransferLimitedToken public token;
688     ICrowdsaleFund public fund;
689     ICrowdsaleReservationFund public reservationFund;
690     LockedTokens public lockedTokens;
691 
692     mapping(address => bool) public whiteList;
693     mapping(address => bool) public privilegedList;
694     mapping(address => AdditionalBonusState) public additionalBonusOwnerState;
695     mapping(address => uint256) public userTotalContributed;
696 
697     address public bnbTokenWallet;
698     address public referralTokenWallet;
699     address public foundationTokenWallet;
700     address public advisorsTokenWallet;
701     address public companyTokenWallet;
702     address public reserveTokenWallet;
703     address public bountyTokenWallet;
704 
705     uint256 public totalEtherContributed = 0;
706     uint256 public rawTokenSupply = 0;
707 
708     // BNB
709     IERC20Token public bnbToken;
710     uint256 public BNB_HARD_CAP = 300000 ether; // 300K BNB
711     uint256 public BNB_MIN_CONTRIB = 1000 ether; // 1K BNB
712     mapping(address => uint256) public bnbContributions;
713     uint256 public totalBNBContributed = 0;
714     bool public bnbWithdrawEnabled = false;
715 
716     uint256 public hardCap = 0; // World hard cap will be set right before Token Sale
717     uint256 public softCap = 0; // World soft cap will be set right before Token Sale
718 
719     bool public bnbRefundEnabled = false;
720 
721     event LogContribution(address contributor, uint256 amountWei, uint256 tokenAmount, uint256 tokenBonus, bool additionalBonusApplied, uint256 timestamp);
722     event ReservationFundContribution(address contributor, uint256 amountWei, uint256 tokensToIssue, uint256 bonusTokensToIssue, uint256 timestamp);
723     event LogBNBContribution(address contributor, uint256 amountBNB, uint256 tokenAmount, uint256 tokenBonus, bool additionalBonusApplied, uint256 timestamp);
724 
725     modifier checkContribution() {
726         require(isValidContribution());
727         _;
728     }
729 
730     modifier checkBNBContribution() {
731         require(isValidBNBContribution());
732         _;
733     }
734 
735     modifier checkCap() {
736         require(validateCap());
737         _;
738     }
739 
740     modifier checkTime() {
741         require(now >= SALE_START_TIME && now <= SALE_END_TIME);
742         _;
743     }
744 
745     function TheAbyssDAICO(
746         address bnbTokenAddress,
747         address tokenAddress,
748         address fundAddress,
749         address reservationFundAddress,
750         address _bnbTokenWallet,
751         address _referralTokenWallet,
752         address _foundationTokenWallet,
753         address _advisorsTokenWallet,
754         address _companyTokenWallet,
755         address _reserveTokenWallet,
756         address _bountyTokenWallet,
757         address _owner
758     ) public
759         Ownable(_owner)
760     {
761         require(tokenAddress != address(0));
762 
763         bnbToken = IERC20Token(bnbTokenAddress);
764         token = TransferLimitedToken(tokenAddress);
765         fund = ICrowdsaleFund(fundAddress);
766         reservationFund = ICrowdsaleReservationFund(reservationFundAddress);
767 
768         bnbTokenWallet = _bnbTokenWallet;
769         referralTokenWallet = _referralTokenWallet;
770         foundationTokenWallet = _foundationTokenWallet;
771         advisorsTokenWallet = _advisorsTokenWallet;
772         companyTokenWallet = _companyTokenWallet;
773         reserveTokenWallet = _reserveTokenWallet;
774         bountyTokenWallet = _bountyTokenWallet;
775     }
776 
777     /**
778      * @dev check if address can contribute
779      */
780     function isContributorInLists(address contributor) external view returns(bool) {
781         return whiteList[contributor] || privilegedList[contributor] || token.limitedWallets(contributor);
782     }
783 
784     /**
785      * @dev check contribution amount and time
786      */
787     function isValidContribution() internal view returns(bool) {
788         uint256 currentUserContribution = safeAdd(msg.value, userTotalContributed[msg.sender]);
789         if(whiteList[msg.sender] && msg.value >= ETHER_MIN_CONTRIB) {
790             if(now <= MAX_CONTRIB_CHECK_END_TIME && currentUserContribution > ETHER_MAX_CONTRIB ) {
791                     return false;
792             }
793             return true;
794 
795         }
796         if(privilegedList[msg.sender] && msg.value >= ETHER_MIN_CONTRIB_PRIVATE) {
797             if(now <= MAX_CONTRIB_CHECK_END_TIME && currentUserContribution > ETHER_MAX_CONTRIB_PRIVATE ) {
798                     return false;
799             }
800             return true;
801         }
802 
803         if(token.limitedWallets(msg.sender) && msg.value >= ETHER_MIN_CONTRIB_USA) {
804             if(now <= MAX_CONTRIB_CHECK_END_TIME && currentUserContribution > ETHER_MAX_CONTRIB_USA) {
805                     return false;
806             }
807             return true;
808         }
809 
810         return false;
811     }
812 
813     /**
814      * @dev Check hard cap overflow
815      */
816     function validateCap() internal view returns(bool){
817         if(msg.value <= safeSub(hardCap, totalEtherContributed)) {
818             return true;
819         }
820         return false;
821     }
822 
823     /**
824      * @dev Set token price once before start of crowdsale
825      */
826     function setTokenPrice(uint256 _tokenPriceNum, uint256 _tokenPriceDenom) public onlyOwner {
827         require(tokenPriceNum == 0 && tokenPriceDenom == 0);
828         require(_tokenPriceNum > 0 && _tokenPriceDenom > 0);
829         tokenPriceNum = _tokenPriceNum;
830         tokenPriceDenom = _tokenPriceDenom;
831     }
832 
833     /**
834      * @dev Set hard cap.
835      * @param _hardCap - Hard cap value
836      */
837     function setHardCap(uint256 _hardCap) public onlyOwner {
838         require(hardCap == 0);
839         hardCap = _hardCap;
840     }
841 
842     /**
843      * @dev Set soft cap.
844      * @param _softCap - Soft cap value
845      */
846     function setSoftCap(uint256 _softCap) public onlyOwner {
847         require(softCap == 0);
848         softCap = _softCap;
849     }
850 
851     /**
852      * @dev Get soft cap amount
853      **/
854     function getSoftCap() external view returns(uint256) {
855         return softCap;
856     }
857 
858     /**
859      * @dev Check bnb contribution time, amount and hard cap overflow
860      */
861     function isValidBNBContribution() internal view returns(bool) {
862         if(token.limitedWallets(msg.sender)) {
863             return false;
864         }
865         if(!whiteList[msg.sender] && !privilegedList[msg.sender]) {
866             return false;
867         }
868         uint256 amount = bnbToken.allowance(msg.sender, address(this));
869         if(amount < BNB_MIN_CONTRIB || safeAdd(totalBNBContributed, amount) > BNB_HARD_CAP) {
870             return false;
871         }
872         return true;
873 
874     }
875 
876     /**
877      * @dev Calc bonus amount by contribution time
878      */
879     function getBonus() internal constant returns (uint256, uint256) {
880         uint256 numerator = 0;
881         uint256 denominator = 100;
882 
883         if(now < BONUS_WINDOW_1_END_TIME) {
884             numerator = 25;
885         } else if(now < BONUS_WINDOW_2_END_TIME) {
886             numerator = 15;
887         } else if(now < BONUS_WINDOW_3_END_TIME) {
888             numerator = 10;
889         } else if(now < BONUS_WINDOW_4_END_TIME) {
890             numerator = 5;
891         } else {
892             numerator = 0;
893         }
894 
895         return (numerator, denominator);
896     }
897 
898     function addToLists(
899         address _wallet,
900         bool isInWhiteList,
901         bool isInPrivilegedList,
902         bool isInLimitedList,
903         bool hasAdditionalBonus
904     ) public onlyOwner {
905         if(isInWhiteList) {
906             whiteList[_wallet] = true;
907         }
908         if(isInPrivilegedList) {
909             privilegedList[_wallet] = true;
910         }
911         if(isInLimitedList) {
912             token.addLimitedWalletAddress(_wallet);
913         }
914         if(hasAdditionalBonus) {
915             additionalBonusOwnerState[_wallet] = AdditionalBonusState.Active;
916         }
917         if(reservationFund.canCompleteContribution(_wallet)) {
918             reservationFund.completeContribution(_wallet);
919         }
920     }
921 
922     /**
923      * @dev Add wallet to whitelist. For contract owner only.
924      */
925     function addToWhiteList(address _wallet) public onlyOwner {
926         whiteList[_wallet] = true;
927     }
928 
929     /**
930      * @dev Add wallet to additional bonus members. For contract owner only.
931      */
932     function addAdditionalBonusMember(address _wallet) public onlyOwner {
933         additionalBonusOwnerState[_wallet] = AdditionalBonusState.Active;
934     }
935 
936     /**
937      * @dev Add wallet to privileged list. For contract owner only.
938      */
939     function addToPrivilegedList(address _wallet) public onlyOwner {
940         privilegedList[_wallet] = true;
941     }
942 
943     /**
944      * @dev Set LockedTokens contract address
945      */
946     function setLockedTokens(address lockedTokensAddress) public onlyOwner {
947         lockedTokens = LockedTokens(lockedTokensAddress);
948     }
949 
950     /**
951      * @dev Fallback function to receive ether contributions
952      */
953     function () payable public whenNotPaused {
954         if(whiteList[msg.sender] || privilegedList[msg.sender] || token.limitedWallets(msg.sender)) {
955             processContribution(msg.sender, msg.value);
956         } else {
957             processReservationContribution(msg.sender, msg.value);
958         }
959     }
960 
961     function processReservationContribution(address contributor, uint256 amount) private checkTime checkCap {
962         require(amount >= ETHER_MIN_CONTRIB);
963 
964         if(now <= MAX_CONTRIB_CHECK_END_TIME) {
965             uint256 currentUserContribution = safeAdd(amount, reservationFund.contributionsOf(contributor));
966             require(currentUserContribution <= ETHER_MAX_CONTRIB);
967         }
968         uint256 bonusNum = 0;
969         uint256 bonusDenom = 100;
970         (bonusNum, bonusDenom) = getBonus();
971         uint256 tokenBonusAmount = 0;
972         uint256 tokenAmount = safeDiv(safeMul(amount, tokenPriceNum), tokenPriceDenom);
973 
974         if(bonusNum > 0) {
975             tokenBonusAmount = safeDiv(safeMul(tokenAmount, bonusNum), bonusDenom);
976         }
977 
978         reservationFund.processContribution.value(amount)(
979             contributor,
980             tokenAmount,
981             tokenBonusAmount
982         );
983         ReservationFundContribution(contributor, amount, tokenAmount, tokenBonusAmount, now);
984     }
985 
986     /**
987      * @dev Process BNB token contribution
988      * Transfer all amount of tokens approved by sender. Calc bonuses and issue tokens to contributor.
989      */
990     function processBNBContribution() public whenNotPaused checkTime checkBNBContribution {
991         bool additionalBonusApplied = false;
992         uint256 bonusNum = 0;
993         uint256 bonusDenom = 100;
994         (bonusNum, bonusDenom) = getBonus();
995         uint256 amountBNB = bnbToken.allowance(msg.sender, address(this));
996         bnbToken.transferFrom(msg.sender, address(this), amountBNB);
997         bnbContributions[msg.sender] = safeAdd(bnbContributions[msg.sender], amountBNB);
998 
999         uint256 tokenBonusAmount = 0;
1000         uint256 tokenAmount = safeDiv(safeMul(amountBNB, BNB_TOKEN_PRICE_NUM), BNB_TOKEN_PRICE_DENOM);
1001         rawTokenSupply = safeAdd(rawTokenSupply, tokenAmount);
1002         if(bonusNum > 0) {
1003             tokenBonusAmount = safeDiv(safeMul(tokenAmount, bonusNum), bonusDenom);
1004         }
1005 
1006         if(additionalBonusOwnerState[msg.sender] ==  AdditionalBonusState.Active) {
1007             additionalBonusOwnerState[msg.sender] = AdditionalBonusState.Applied;
1008             uint256 additionalBonus = safeDiv(safeMul(tokenAmount, ADDITIONAL_BONUS_NUM), ADDITIONAL_BONUS_DENOM);
1009             tokenBonusAmount = safeAdd(tokenBonusAmount, additionalBonus);
1010             additionalBonusApplied = true;
1011         }
1012 
1013         uint256 tokenTotalAmount = safeAdd(tokenAmount, tokenBonusAmount);
1014         token.issue(msg.sender, tokenTotalAmount);
1015         totalBNBContributed = safeAdd(totalBNBContributed, amountBNB);
1016 
1017         LogBNBContribution(msg.sender, amountBNB, tokenAmount, tokenBonusAmount, additionalBonusApplied, now);
1018     }
1019 
1020     /**
1021      * @dev Process ether contribution. Calc bonuses and issue tokens to contributor.
1022      */
1023     function processContribution(address contributor, uint256 amount) private checkTime checkContribution checkCap {
1024         bool additionalBonusApplied = false;
1025         uint256 bonusNum = 0;
1026         uint256 bonusDenom = 100;
1027         (bonusNum, bonusDenom) = getBonus();
1028         uint256 tokenBonusAmount = 0;
1029 
1030         uint256 tokenAmount = safeDiv(safeMul(amount, tokenPriceNum), tokenPriceDenom);
1031         rawTokenSupply = safeAdd(rawTokenSupply, tokenAmount);
1032 
1033         if(bonusNum > 0) {
1034             tokenBonusAmount = safeDiv(safeMul(tokenAmount, bonusNum), bonusDenom);
1035         }
1036 
1037         if(additionalBonusOwnerState[contributor] ==  AdditionalBonusState.Active) {
1038             additionalBonusOwnerState[contributor] = AdditionalBonusState.Applied;
1039             uint256 additionalBonus = safeDiv(safeMul(tokenAmount, ADDITIONAL_BONUS_NUM), ADDITIONAL_BONUS_DENOM);
1040             tokenBonusAmount = safeAdd(tokenBonusAmount, additionalBonus);
1041             additionalBonusApplied = true;
1042         }
1043 
1044         processPayment(contributor, amount, tokenAmount, tokenBonusAmount, additionalBonusApplied);
1045     }
1046 
1047     /**
1048      * @dev Process ether contribution before KYC. Calc bonuses and tokens to issue after KYC.
1049      */
1050     function processReservationFundContribution(
1051         address contributor,
1052         uint256 tokenAmount,
1053         uint256 tokenBonusAmount
1054     ) external payable checkCap {
1055         require(msg.sender == address(reservationFund));
1056         require(msg.value > 0);
1057         rawTokenSupply = safeAdd(rawTokenSupply, tokenAmount);
1058         processPayment(contributor, msg.value, tokenAmount, tokenBonusAmount, false);
1059     }
1060 
1061     function processPayment(address contributor, uint256 etherAmount, uint256 tokenAmount, uint256 tokenBonusAmount, bool additionalBonusApplied) internal {
1062         uint256 tokenTotalAmount = safeAdd(tokenAmount, tokenBonusAmount);
1063 
1064         token.issue(contributor, tokenTotalAmount);
1065         fund.processContribution.value(etherAmount)(contributor);
1066         totalEtherContributed = safeAdd(totalEtherContributed, etherAmount);
1067         userTotalContributed[contributor] = safeAdd(userTotalContributed[contributor], etherAmount);
1068         LogContribution(contributor, etherAmount, tokenAmount, tokenBonusAmount, additionalBonusApplied, now);
1069     }
1070 
1071     /**
1072      * @dev Force crowdsale refund
1073      */
1074     function forceCrowdsaleRefund() public onlyOwner {
1075         pause();
1076         fund.enableCrowdsaleRefund();
1077         reservationFund.onCrowdsaleEnd();
1078         token.finishIssuance();
1079         bnbRefundEnabled = true;
1080     }
1081 
1082     /**
1083      * @dev Finalize crowdsale if we reached hard cap or current time > SALE_END_TIME
1084      */
1085     function finalizeCrowdsale() public onlyOwner {
1086         if(
1087             totalEtherContributed >= safeSub(hardCap, 1000 ether) ||
1088             (now >= SALE_END_TIME && totalEtherContributed >= softCap)
1089         ) {
1090             fund.onCrowdsaleEnd();
1091             reservationFund.onCrowdsaleEnd();
1092             bnbWithdrawEnabled = true;
1093 
1094             // Referral
1095             uint256 referralTokenAmount = safeDiv(rawTokenSupply, 10);
1096             token.issue(referralTokenWallet, referralTokenAmount);
1097 
1098             // Foundation
1099             uint256 foundationTokenAmount = safeDiv(token.totalSupply(), 2); // 20%
1100             token.issue(address(lockedTokens), foundationTokenAmount);
1101             lockedTokens.addTokens(foundationTokenWallet, foundationTokenAmount, now + 365 days);
1102             uint256 suppliedTokenAmount = token.totalSupply();
1103 
1104             // Reserve
1105             uint256 reservedTokenAmount = safeDiv(safeMul(suppliedTokenAmount, 3), 10); // 18%
1106             token.issue(address(lockedTokens), reservedTokenAmount);
1107             lockedTokens.addTokens(reserveTokenWallet, reservedTokenAmount, now + 183 days);
1108 
1109             // Advisors
1110             uint256 advisorsTokenAmount = safeDiv(suppliedTokenAmount, 10); // 6%
1111             token.issue(advisorsTokenWallet, advisorsTokenAmount);
1112 
1113             // Company
1114             uint256 companyTokenAmount = safeDiv(suppliedTokenAmount, 4); // 15%
1115             token.issue(address(lockedTokens), companyTokenAmount);
1116             lockedTokens.addTokens(companyTokenWallet, companyTokenAmount, now + 730 days);
1117 
1118             // Bounty
1119             uint256 bountyTokenAmount = safeDiv(suppliedTokenAmount, 60); // 1%
1120             token.issue(bountyTokenWallet, bountyTokenAmount);
1121             token.finishIssuance();
1122         } else if(now >= SALE_END_TIME) {
1123             // Enable fund`s crowdsale refund if soft cap is not reached
1124             fund.enableCrowdsaleRefund();
1125             reservationFund.onCrowdsaleEnd();
1126             token.finishIssuance();
1127             bnbRefundEnabled = true;
1128         }
1129     }
1130 
1131     /**
1132      * @dev Withdraw bnb after crowdsale if crowdsale is not in refund mode
1133      */
1134     function withdrawBNB() public onlyOwner {
1135         require(bnbWithdrawEnabled);
1136         // BNB transfer
1137         if(bnbToken.balanceOf(address(this)) > 0) {
1138             bnbToken.transfer(bnbTokenWallet, bnbToken.balanceOf(address(this)));
1139         }
1140     }
1141 
1142     /**
1143      * @dev Function is called by contributor to refund BNB token payments if crowdsale failed to reach soft cap
1144      */
1145     function refundBNBContributor() public {
1146         require(bnbRefundEnabled);
1147         require(bnbContributions[msg.sender] > 0);
1148         uint256 amount = bnbContributions[msg.sender];
1149         bnbContributions[msg.sender] = 0;
1150         bnbToken.transfer(msg.sender, amount);
1151         token.destroy(msg.sender, token.balanceOf(msg.sender));
1152     }
1153 }