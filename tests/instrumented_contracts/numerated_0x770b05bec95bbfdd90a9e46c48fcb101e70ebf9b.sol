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
568     modifier onlyManager() {
569         require(msg.sender == limitedWalletsManager);
570         _;
571     }
572 
573     /**
574      * @dev Check if transfer between addresses is available
575      * @param _from From address
576      * @param _to To address
577      */
578     modifier canTransfer(address _from, address _to)  {
579         require(now >= limitEndDate || !isLimitEnabled || (!limitedWallets[_from] && !limitedWallets[_to]));
580         _;
581     }
582 
583     /**
584      * @dev TransferLimitedToken constructor
585      * @param _limitStartDate Limit start date
586      * @param _listener Token listener(address can be 0x0)
587      * @param _owners Owners list
588      * @param _limitedWalletsManager Address used to add/del wallets from limitedWallets
589      */
590     function TransferLimitedToken(
591         uint256 _limitStartDate,
592         address _listener,
593         address[] _owners,
594         address _limitedWalletsManager
595     ) public ManagedToken(_listener, _owners)
596     {
597         limitEndDate = _limitStartDate + LIMIT_TRANSFERS_PERIOD;
598         isLimitEnabled = true;
599         limitedWalletsManager = _limitedWalletsManager;
600     }
601 
602     /**
603      * @dev Add address to limitedWallets
604      * @dev Can be called only by manager
605      */
606     function addLimitedWalletAddress(address _wallet) public {
607         require(msg.sender == limitedWalletsManager || ownerByAddress[msg.sender]);
608         limitedWallets[_wallet] = true;
609     }
610 
611     /**
612      * @dev Del address from limitedWallets
613      * @dev Can be called only by manager
614      */
615     function delLimitedWalletAddress(address _wallet) public onlyManager {
616         limitedWallets[_wallet] = false;
617     }
618 
619     /**
620      * @dev Disable transfer limit manually. Can be called only by manager
621      */
622     function disableLimit() public onlyManager {
623         isLimitEnabled = false;
624     }
625 
626     function transfer(address _to, uint256 _value) public canTransfer(msg.sender, _to) returns (bool) {
627         return super.transfer(_to, _value);
628     }
629 
630     function transferFrom(address _from, address _to, uint256 _value) public canTransfer(_from, _to) returns (bool) {
631         return super.transferFrom(_from, _to, _value);
632     }
633 
634     function approve(address _spender, uint256 _value) public canTransfer(msg.sender, _spender) returns (bool) {
635         return super.approve(_spender,_value);
636     }
637 }
638 
639 // File: contracts/Crowdsale.sol
640 
641 contract TheAbyssDAICO is Ownable, SafeMath, Pausable, ISimpleCrowdsale {
642     enum AdditionalBonusState {
643         Unavailable,
644         Active,
645         Applied
646     }
647 
648     uint256 public constant ADDITIONAL_BONUS_NUM = 3;
649     uint256 public constant ADDITIONAL_BONUS_DENOM = 100;
650 
651     uint256 public constant ETHER_MIN_CONTRIB = 0.2 ether;
652     uint256 public constant ETHER_MAX_CONTRIB = 20 ether;
653 
654     uint256 public constant ETHER_MIN_CONTRIB_PRIVATE = 100 ether;
655     uint256 public constant ETHER_MAX_CONTRIB_PRIVATE = 3000 ether;
656 
657     uint256 public constant ETHER_MIN_CONTRIB_USA = 0.2 ether;
658     uint256 public constant ETHER_MAX_CONTRIB_USA = 20 ether;
659 
660     uint256 public constant SALE_START_TIME = 1523887200; // 16.04.2018 14:00:00 UTC
661     uint256 public constant SALE_END_TIME = 1526479200; // 16.05.2018 14:00:00 UTC
662 
663     uint256 public constant BONUS_WINDOW_1_END_TIME = SALE_START_TIME + 2 days;
664     uint256 public constant BONUS_WINDOW_2_END_TIME = SALE_START_TIME + 7 days;
665     uint256 public constant BONUS_WINDOW_3_END_TIME = SALE_START_TIME + 14 days;
666     uint256 public constant BONUS_WINDOW_4_END_TIME = SALE_START_TIME + 21 days;
667 
668     uint256 public constant MAX_CONTRIB_CHECK_END_TIME = SALE_START_TIME + 1 days;
669 
670     uint256 public constant BNB_TOKEN_PRICE_NUM = 169;
671     uint256 public constant BNB_TOKEN_PRICE_DENOM = 1;
672 
673     uint256 public tokenPriceNum = 0;
674     uint256 public tokenPriceDenom = 0;
675     
676     TransferLimitedToken public token;
677     ICrowdsaleFund public fund;
678     ICrowdsaleReservationFund public reservationFund;
679     LockedTokens public lockedTokens;
680 
681     mapping(address => bool) public whiteList;
682     mapping(address => bool) public privilegedList;
683     mapping(address => AdditionalBonusState) public additionalBonusOwnerState;
684     mapping(address => uint256) public userTotalContributed;
685 
686     address public bnbTokenWallet;
687     address public referralTokenWallet;
688     address public foundationTokenWallet;
689     address public advisorsTokenWallet;
690     address public companyTokenWallet;
691     address public reserveTokenWallet;
692     address public bountyTokenWallet;
693 
694     uint256 public totalEtherContributed = 0;
695     uint256 public rawTokenSupply = 0;
696 
697     // BNB
698     IERC20Token public bnbToken;
699     uint256 public BNB_HARD_CAP = 300000 ether; // 300K BNB
700     uint256 public BNB_MIN_CONTRIB = 1000 ether; // 1K BNB
701     mapping(address => uint256) public bnbContributions;
702     uint256 public totalBNBContributed = 0;
703 
704     uint256 public hardCap = 0; // World hard cap will be set right before Token Sale
705     uint256 public softCap = 0; // World soft cap will be set right before Token Sale
706 
707     bool public bnbRefundEnabled = false;
708 
709     event LogContribution(address contributor, uint256 amountWei, uint256 tokenAmount, uint256 tokenBonus, bool additionalBonusApplied, uint256 timestamp);
710     event ReservationFundContribution(address contributor, uint256 amountWei, uint256 tokensToIssue, uint256 bonusTokensToIssue, uint256 timestamp);
711     event LogBNBContribution(address contributor, uint256 amountBNB, uint256 tokenAmount, uint256 tokenBonus, bool additionalBonusApplied, uint256 timestamp);
712 
713     modifier checkContribution() {
714         require(isValidContribution());
715         _;
716     }
717 
718     modifier checkBNBContribution() {
719         require(isValidBNBContribution());
720         _;
721     }
722 
723     modifier checkCap() {
724         require(validateCap());
725         _;
726     }
727 
728     modifier checkTime() {
729         require(now >= SALE_START_TIME && now <= SALE_END_TIME);
730         _;
731     }
732 
733     function TheAbyssDAICO(
734         address bnbTokenAddress,
735         address tokenAddress,
736         address fundAddress,
737         address reservationFundAddress,
738         address _bnbTokenWallet,
739         address _referralTokenWallet,
740         address _foundationTokenWallet,
741         address _advisorsTokenWallet,
742         address _companyTokenWallet,
743         address _reserveTokenWallet,
744         address _bountyTokenWallet,
745         address _owner
746     ) public
747         Ownable(_owner)
748     {
749         require(tokenAddress != address(0));
750 
751         bnbToken = IERC20Token(bnbTokenAddress);
752         token = TransferLimitedToken(tokenAddress);
753         fund = ICrowdsaleFund(fundAddress);
754         reservationFund = ICrowdsaleReservationFund(reservationFundAddress);
755 
756         bnbTokenWallet = _bnbTokenWallet;
757         referralTokenWallet = _referralTokenWallet;
758         foundationTokenWallet = _foundationTokenWallet;
759         advisorsTokenWallet = _advisorsTokenWallet;
760         companyTokenWallet = _companyTokenWallet;
761         reserveTokenWallet = _reserveTokenWallet;
762         bountyTokenWallet = _bountyTokenWallet;
763     }
764 
765     /**
766      * @dev check if address can contribute
767      */
768     function isContributorInLists(address contributor) external view returns(bool) {
769         return whiteList[contributor] || privilegedList[contributor] || token.limitedWallets(contributor);
770     }
771 
772     /**
773      * @dev check contribution amount and time
774      */
775     function isValidContribution() internal view returns(bool) {
776         uint256 currentUserContribution = safeAdd(msg.value, userTotalContributed[msg.sender]);
777         if(whiteList[msg.sender] && msg.value >= ETHER_MIN_CONTRIB) {
778             if(now <= MAX_CONTRIB_CHECK_END_TIME && currentUserContribution > ETHER_MAX_CONTRIB ) {
779                     return false;
780             }
781             return true;
782 
783         }
784         if(privilegedList[msg.sender] && msg.value >= ETHER_MIN_CONTRIB_PRIVATE) {
785             if(now <= MAX_CONTRIB_CHECK_END_TIME && currentUserContribution > ETHER_MAX_CONTRIB_PRIVATE ) {
786                     return false;
787             }
788             return true;
789         }
790 
791         if(token.limitedWallets(msg.sender) && msg.value >= ETHER_MIN_CONTRIB_USA) {
792             if(now <= MAX_CONTRIB_CHECK_END_TIME && currentUserContribution > ETHER_MAX_CONTRIB_USA) {
793                     return false;
794             }
795             return true;
796         }
797 
798         return false;
799     }
800 
801     /**
802      * @dev Check hard cap overflow
803      */
804     function validateCap() internal view returns(bool){
805         if(msg.value <= safeSub(hardCap, totalEtherContributed)) {
806             return true;
807         }
808         return false;
809     }
810 
811     /**
812      * @dev Set token price once before start of crowdsale
813      */
814     function setTokenPrice(uint256 _tokenPriceNum, uint256 _tokenPriceDenom) public onlyOwner {
815         require(tokenPriceNum == 0 && tokenPriceDenom == 0);
816         require(_tokenPriceNum > 0 && _tokenPriceDenom > 0);
817         tokenPriceNum = _tokenPriceNum;
818         tokenPriceDenom = _tokenPriceDenom;
819     }
820 
821     /**
822      * @dev Set hard cap.
823      * @param _hardCap - Hard cap value
824      */
825     function setHardCap(uint256 _hardCap) public onlyOwner {
826         require(hardCap == 0);
827         hardCap = _hardCap;
828     }
829 
830     /**
831      * @dev Set soft cap.
832      * @param _softCap - Soft cap value
833      */
834     function setSoftCap(uint256 _softCap) public onlyOwner {
835         require(softCap == 0);
836         softCap = _softCap;
837     }
838 
839     /**
840      * @dev Get soft cap amount
841      **/
842     function getSoftCap() external view returns(uint256) {
843         return softCap;
844     }
845 
846     /**
847      * @dev Check bnb contribution time, amount and hard cap overflow
848      */
849     function isValidBNBContribution() internal view returns(bool) {
850         if(token.limitedWallets(msg.sender)) {
851             return false;
852         }
853         if(!whiteList[msg.sender] && !privilegedList[msg.sender]) {
854             return false;
855         }
856         uint256 amount = bnbToken.allowance(msg.sender, address(this));
857         if(amount < BNB_MIN_CONTRIB || safeAdd(totalBNBContributed, amount) > BNB_HARD_CAP) {
858             return false;
859         }
860         return true;
861 
862     }
863 
864     /**
865      * @dev Calc bonus amount by contribution time
866      */
867     function getBonus() internal constant returns (uint256, uint256) {
868         uint256 numerator = 0;
869         uint256 denominator = 100;
870 
871         if(now < BONUS_WINDOW_1_END_TIME) {
872             numerator = 25;
873         } else if(now < BONUS_WINDOW_2_END_TIME) {
874             numerator = 15;
875         } else if(now < BONUS_WINDOW_3_END_TIME) {
876             numerator = 10;
877         } else if(now < BONUS_WINDOW_4_END_TIME) {
878             numerator = 5;
879         } else {
880             numerator = 0;
881         }
882 
883         return (numerator, denominator);
884     }
885 
886     function addToLists(
887         address _wallet,
888         bool isInWhiteList,
889         bool isInPrivilegedList,
890         bool isInLimitedList,
891         bool hasAdditionalBonus
892     ) public onlyOwner {
893         if(isInWhiteList) {
894             whiteList[_wallet] = true;
895         }
896         if(isInPrivilegedList) {
897             privilegedList[_wallet] = true;
898         }
899         if(isInLimitedList) {
900             token.addLimitedWalletAddress(_wallet);
901         }
902         if(hasAdditionalBonus) {
903             additionalBonusOwnerState[_wallet] = AdditionalBonusState.Active;
904         }
905         if(reservationFund.canCompleteContribution(_wallet)) {
906             reservationFund.completeContribution(_wallet);
907         }
908     }
909 
910     /**
911      * @dev Add wallet to whitelist. For contract owner only.
912      */
913     function addToWhiteList(address _wallet) public onlyOwner {
914         whiteList[_wallet] = true;
915     }
916 
917     /**
918      * @dev Add wallet to additional bonus members. For contract owner only.
919      */
920     function addAdditionalBonusMember(address _wallet) public onlyOwner {
921         additionalBonusOwnerState[_wallet] = AdditionalBonusState.Active;
922     }
923 
924     /**
925      * @dev Add wallet to privileged list. For contract owner only.
926      */
927     function addToPrivilegedList(address _wallet) public onlyOwner {
928         privilegedList[_wallet] = true;
929     }
930 
931     /**
932      * @dev Set LockedTokens contract address
933      */
934     function setLockedTokens(address lockedTokensAddress) public onlyOwner {
935         lockedTokens = LockedTokens(lockedTokensAddress);
936     }
937 
938     /**
939      * @dev Fallback function to receive ether contributions
940      */
941     function () payable public whenNotPaused {
942         if(whiteList[msg.sender] || privilegedList[msg.sender] || token.limitedWallets(msg.sender)) {
943             processContribution(msg.sender, msg.value);
944         } else {
945             processReservationContribution(msg.sender, msg.value);
946         }
947     }
948 
949     function processReservationContribution(address contributor, uint256 amount) private checkTime checkCap {
950         require(amount >= ETHER_MIN_CONTRIB);
951 
952         if(now <= MAX_CONTRIB_CHECK_END_TIME) {
953             uint256 currentUserContribution = safeAdd(amount, reservationFund.contributionsOf(contributor));
954             require(currentUserContribution <= ETHER_MAX_CONTRIB);
955         }
956         uint256 bonusNum = 0;
957         uint256 bonusDenom = 100;
958         (bonusNum, bonusDenom) = getBonus();
959         uint256 tokenBonusAmount = 0;
960         uint256 tokenAmount = safeDiv(safeMul(amount, tokenPriceNum), tokenPriceDenom);
961 
962         if(bonusNum > 0) {
963             tokenBonusAmount = safeDiv(safeMul(tokenAmount, bonusNum), bonusDenom);
964         }
965 
966         reservationFund.processContribution.value(amount)(
967             contributor,
968             tokenAmount,
969             tokenBonusAmount
970         );
971         ReservationFundContribution(contributor, amount, tokenAmount, tokenBonusAmount, now);
972     }
973 
974     /**
975      * @dev Process BNB token contribution
976      * Transfer all amount of tokens approved by sender. Calc bonuses and issue tokens to contributor.
977      */
978     function processBNBContribution() public whenNotPaused checkTime checkBNBContribution {
979         bool additionalBonusApplied = false;
980         uint256 bonusNum = 0;
981         uint256 bonusDenom = 100;
982         (bonusNum, bonusDenom) = getBonus();
983         uint256 amountBNB = bnbToken.allowance(msg.sender, address(this));
984         bnbToken.transferFrom(msg.sender, address(this), amountBNB);
985         bnbContributions[msg.sender] = safeAdd(bnbContributions[msg.sender], amountBNB);
986 
987         uint256 tokenBonusAmount = 0;
988         uint256 tokenAmount = safeDiv(safeMul(amountBNB, BNB_TOKEN_PRICE_NUM), BNB_TOKEN_PRICE_DENOM);
989         rawTokenSupply = safeAdd(rawTokenSupply, tokenAmount);
990         if(bonusNum > 0) {
991             tokenBonusAmount = safeDiv(safeMul(tokenAmount, bonusNum), bonusDenom);
992         }
993 
994         if(additionalBonusOwnerState[msg.sender] ==  AdditionalBonusState.Active) {
995             additionalBonusOwnerState[msg.sender] = AdditionalBonusState.Applied;
996             uint256 additionalBonus = safeDiv(safeMul(tokenAmount, ADDITIONAL_BONUS_NUM), ADDITIONAL_BONUS_DENOM);
997             tokenBonusAmount = safeAdd(tokenBonusAmount, additionalBonus);
998             additionalBonusApplied = true;
999         }
1000 
1001         uint256 tokenTotalAmount = safeAdd(tokenAmount, tokenBonusAmount);
1002         token.issue(msg.sender, tokenTotalAmount);
1003         totalBNBContributed = safeAdd(totalBNBContributed, amountBNB);
1004 
1005         LogBNBContribution(msg.sender, amountBNB, tokenAmount, tokenBonusAmount, additionalBonusApplied, now);
1006     }
1007 
1008     /**
1009      * @dev Process ether contribution. Calc bonuses and issue tokens to contributor.
1010      */
1011     function processContribution(address contributor, uint256 amount) private checkTime checkContribution checkCap {
1012         bool additionalBonusApplied = false;
1013         uint256 bonusNum = 0;
1014         uint256 bonusDenom = 100;
1015         (bonusNum, bonusDenom) = getBonus();
1016         uint256 tokenBonusAmount = 0;
1017 
1018         uint256 tokenAmount = safeDiv(safeMul(amount, tokenPriceNum), tokenPriceDenom);
1019         rawTokenSupply = safeAdd(rawTokenSupply, tokenAmount);
1020 
1021         if(bonusNum > 0) {
1022             tokenBonusAmount = safeDiv(safeMul(tokenAmount, bonusNum), bonusDenom);
1023         }
1024 
1025         if(additionalBonusOwnerState[contributor] ==  AdditionalBonusState.Active) {
1026             additionalBonusOwnerState[contributor] = AdditionalBonusState.Applied;
1027             uint256 additionalBonus = safeDiv(safeMul(tokenAmount, ADDITIONAL_BONUS_NUM), ADDITIONAL_BONUS_DENOM);
1028             tokenBonusAmount = safeAdd(tokenBonusAmount, additionalBonus);
1029             additionalBonusApplied = true;
1030         }
1031 
1032         processPayment(contributor, amount, tokenAmount, tokenBonusAmount, additionalBonusApplied);
1033     }
1034 
1035     /**
1036      * @dev Process ether contribution before KYC. Calc bonuses and tokens to issue after KYC.
1037      */
1038     function processReservationFundContribution(
1039         address contributor,
1040         uint256 tokenAmount,
1041         uint256 tokenBonusAmount
1042     ) external payable checkCap {
1043         require(msg.sender == address(reservationFund));
1044         require(msg.value > 0);
1045 
1046         processPayment(contributor, msg.value, tokenAmount, tokenBonusAmount, false);
1047     }
1048 
1049     function processPayment(address contributor, uint256 etherAmount, uint256 tokenAmount, uint256 tokenBonusAmount, bool additionalBonusApplied) internal {
1050         uint256 tokenTotalAmount = safeAdd(tokenAmount, tokenBonusAmount);
1051 
1052         token.issue(contributor, tokenTotalAmount);
1053         fund.processContribution.value(etherAmount)(contributor);
1054         totalEtherContributed = safeAdd(totalEtherContributed, etherAmount);
1055         userTotalContributed[contributor] = safeAdd(userTotalContributed[contributor], etherAmount);
1056         LogContribution(contributor, etherAmount, tokenAmount, tokenBonusAmount, additionalBonusApplied, now);
1057     }
1058 
1059     /**
1060      * @dev Finalize crowdsale if we reached hard cap or current time > SALE_END_TIME
1061      */
1062     function finalizeCrowdsale() public onlyOwner {
1063         if(
1064             (totalEtherContributed >= safeSub(hardCap, 20 ether) && totalBNBContributed >= safeSub(BNB_HARD_CAP, 10000 ether)) ||
1065             (now >= SALE_END_TIME && totalEtherContributed >= softCap)
1066         ) {
1067             fund.onCrowdsaleEnd();
1068             reservationFund.onCrowdsaleEnd();
1069             // BNB transfer
1070             bnbToken.transfer(bnbTokenWallet, bnbToken.balanceOf(address(this)));
1071 
1072             // Referral
1073             uint256 referralTokenAmount = safeDiv(rawTokenSupply, 10);
1074             token.issue(referralTokenWallet, referralTokenAmount);
1075 
1076             // Foundation
1077             uint256 foundationTokenAmount = safeDiv(token.totalSupply(), 2); // 20%
1078             lockedTokens.addTokens(foundationTokenWallet, foundationTokenAmount, now + 365 days);
1079 
1080             uint256 suppliedTokenAmount = token.totalSupply();
1081 
1082             // Reserve
1083             uint256 reservedTokenAmount = safeDiv(safeMul(suppliedTokenAmount, 3), 10); // 18%
1084             token.issue(address(lockedTokens), reservedTokenAmount);
1085             lockedTokens.addTokens(reserveTokenWallet, reservedTokenAmount, now + 183 days);
1086 
1087             // Advisors
1088             uint256 advisorsTokenAmount = safeDiv(suppliedTokenAmount, 10); // 6%
1089             token.issue(advisorsTokenWallet, advisorsTokenAmount);
1090 
1091             // Company
1092             uint256 companyTokenAmount = safeDiv(suppliedTokenAmount, 4); // 15%
1093             token.issue(address(lockedTokens), companyTokenAmount);
1094             lockedTokens.addTokens(companyTokenWallet, companyTokenAmount, now + 730 days);
1095 
1096             // Bounty
1097             uint256 bountyTokenAmount = safeDiv(suppliedTokenAmount, 60); // 1%
1098             token.issue(bountyTokenWallet, bountyTokenAmount);
1099 
1100             token.setAllowTransfers(true);
1101 
1102         } else if(now >= SALE_END_TIME) {
1103             // Enable fund`s crowdsale refund if soft cap is not reached
1104             fund.enableCrowdsaleRefund();
1105             reservationFund.onCrowdsaleEnd();
1106             bnbRefundEnabled = true;
1107         }
1108         token.finishIssuance();
1109     }
1110 
1111     /**
1112      * @dev Function is called by contributor to refund BNB token payments if crowdsale failed to reach soft cap
1113      */
1114     function refundBNBContributor() public {
1115         require(bnbRefundEnabled);
1116         require(bnbContributions[msg.sender] > 0);
1117         uint256 amount = bnbContributions[msg.sender];
1118         bnbContributions[msg.sender] = 0;
1119         bnbToken.transfer(msg.sender, amount);
1120         token.destroy(msg.sender, token.balanceOf(msg.sender));
1121     }
1122 }